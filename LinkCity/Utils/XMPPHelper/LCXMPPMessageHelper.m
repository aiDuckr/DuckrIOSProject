//
//  LCXMPPMessageHelper.m
//  LinkCity
//
//  Created by roy on 3/25/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCXMPPMessageHelper.h"

@implementation LCXMPPMessageHelper

#pragma mark - Public Interface
+ (instancetype)sharedInstance{
    static LCXMPPMessageHelper *xmppMessageHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        xmppMessageHelper = [[LCXMPPMessageHelper alloc] init];
    });
    return xmppMessageHelper;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSMutableArray *)messagesToSend{
    if (!_messagesToSend) {
        _messagesToSend = [[NSMutableArray alloc] init];
    }
    return _messagesToSend;
}



#pragma mark SystemInfo
- (void)sendChatSystemInfo:(NSString *)systemInfo toBareJidString:(NSString *)jidStr isGroup:(BOOL)isGroup{
    if (systemInfo && systemInfo.length > 0) {
        MessageModel * model = [self createMessageModelForSystem:systemInfo];
        if (!isGroup) {
            /// 生成info发送.
            [self sendChatMessage:systemInfo toBareJidString:jidStr];
        } else {
            [self sendGroupChat:model toBareJidString:jidStr];
        }
    }
}

/// 在聊天列表中显示发送的系统信息.
- (MessageModel *)createMessageModelForSystem:(NSString *)systemInfo {
    LCUserModel *userInfo = [LCDataManager sharedInstance].userInfo;
    MessageModel *model = [[MessageModel alloc] init];
    model.type = eMessageBodyType_System;
    model.content = systemInfo;
    model.isSender = YES;
    model.headImageURL = [NSURL URLWithString:userInfo.avatarThumbUrl];
    model.sendDate = [NSDate date];
    return model;
}

#pragma mark CheckIn
- (void)sendCheckIn:(LCLocationModel *)location toBareJidString:(NSString *)jidStr isGroup:(BOOL)isGroup{
    NSString *showText = @"[签到]";
    LCUserModel *userInfo = [LCDataManager sharedInstance].userInfo;
    MessageModel *model = [[MessageModel alloc] init];
    model.type = eMessageBodyType_CheckIn;
    model.content = showText;
    model.address = location.address;
    model.latitude = location.lat;
    model.longitude = location.lng;
    model.isSender = YES;
    model.headImageURL = [NSURL URLWithString:userInfo.avatarThumbUrl];
    model.sendDate = [NSDate date];
    
    if (!isGroup) {
        /// 生成info发送.
        [self sendChatMessageModel:model toBareJidString:jidStr];
    } else {
        [self sendGroupChat:model toBareJidString:jidStr];
    }
}

#pragma Base Send Message
- (void)sendChatMessage:(NSString *)message toBareJidString:(NSString *)jidStr{
    LCUserModel *userInfo = [LCDataManager sharedInstance].userInfo;
    MessageModel *model = [[MessageModel alloc] init];
    model.type = eMessageBodyType_Text;
    model.content = message;
    model.isSender = YES;
    model.headImageURL = [NSURL URLWithString:userInfo.avatarThumbUrl];
    model.sendDate = [NSDate date];
    
    [self sendChatMessageModel:model toBareJidString:jidStr];
}

- (void)sendChatMessageModel:(MessageModel *)model toBareJidString:(NSString *)jidStr {
    LCUserModel *userInfo = [LCDataManager sharedInstance].userInfo;
    NSString *infoStr = [LCMessageConvert getJsonStrFromEMMessage:model];
    
    model.sendDate = [NSDate date];
    model.infoStr = infoStr;
    model.toJidStr = jidStr;
    
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:model.content];
    /// 生成XML消息文档.
    NSXMLElement *mes = [NSXMLElement elementWithName:@"message"];
    /// 消息类型.
    [mes addAttributeWithName:@"type" stringValue:@"chat"];
    /// 发送给谁.
    [mes addAttributeWithName:@"to" stringValue:model.toJidStr];
    /// 由谁发送.
    [mes addAttributeWithName:@"from" stringValue:userInfo.openfireAccount];
    /// 消息的Json数据.
    [mes addAttributeWithName:@"info" stringValue:model.infoStr];
    [mes addChild:body];
    
    /// 发送消息.
    [self.xmppStream sendElement:mes];
}

- (void)sendGroupChat:(MessageModel *)model toXMPPRoom:(XMPPRoom *)xmppRoom{
    model.sendDate = [NSDate date];
    NSString *info = [LCMessageConvert getJsonStrFromEMMessage:model];
    [xmppRoom sendMessageWithBody:model.content withInfo:info];
}




- (void)sendGroupChat:(MessageModel *)model toBareJidString:(NSString *)jidStr{
    model.sendDate = [NSDate date];
    NSString *info = [LCMessageConvert getJsonStrFromEMMessage:model];
    model.toJidStr = jidStr;
    model.infoStr = info;
    
    XMPPRoom *theRoomToSendMsg = nil;
    for (XMPPRoom *xmppRoom in self.onlineXMPPRoomArray){
        if ([xmppRoom.roomJID.bare isEqualToString:jidStr]) {
            theRoomToSendMsg = xmppRoom;
            break;
        }
    }
    if (theRoomToSendMsg) {
        [theRoomToSendMsg sendMessageWithBody:model.content withInfo:model.infoStr];
    }else{
        [self.messagesToSend addObject:model];
        XMPPRoom *aRoom = [self getRoomOnlineWithRoomBareJid:model.toJidStr];
        [aRoom addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        /*
         Roy 2015.9.25
         Room上线后没有调用此类的回调xmppRoomDidJoin
         所以直接延时发送
         */
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //发送待发送的消息
            for (int i=0; i<self.messagesToSend.count; i++){
                MessageModel *message = [self.messagesToSend objectAtIndex:i];
                if ([message.toJidStr isEqualToString:aRoom.roomJID.bare]) {
                    [aRoom sendMessageWithBody:message.content withInfo:message.infoStr];
                    [self.messagesToSend removeObjectAtIndex:i--];
                }
            }
        });
    }
}





#pragma mark - XMPPRoom Delegate
/*
 Roy 2015.9.25 
 Room上线后没有调用这里的回调
 */
- (void)xmppRoomDidJoin:(XMPPRoom *)sender{
    
    //发送待发送的消息
    for (int i=0; i<self.messagesToSend.count; i++){
        MessageModel *message = [self.messagesToSend objectAtIndex:i];
        if ([message.toJidStr isEqualToString:sender.roomJID.bare]) {
            [sender sendMessageWithBody:message.content withInfo:message.infoStr];
            [self.messagesToSend removeObjectAtIndex:i--];
        }
    }
}


#pragma mark - XMPP Block Delegate
- (void)xmppBlocking:(XMPPBlocking *)sender didBlockJID:(XMPPJID*)xmppJID{
    LCLogInfo(@"didBlockJID %@",xmppJID.bare);
}
- (void)xmppBlocking:(XMPPBlocking *)sender didNotBlockJID:(XMPPJID*)xmppJID error:(id)error{
    LCLogWarn(@"didNotBlockJID %@",error);
}



@end
