//
//  LCChatWithGroupVC.m
//  LinkCity
//
//  Created by roy on 3/18/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCChatWithGroupVC.h"

@interface LCChatWithGroupVC ()
@property (nonatomic, strong) LCChatGroupModel *chatGroup;
@end

@implementation LCChatWithGroupVC

- (instancetype)initWithChatGroup:(LCChatGroupModel *)chatGroup{
    self = [super init];
    if (self) {
        self.chatGroup = chatGroup;
        self.chatWithJidStr = self.chatGroup.groupJid;
        self.isGroupChat = YES;
        self.headImageURL = [LCDataManager sharedInstance].userInfo.avatarThumbUrl;
        self.planOrGroupGuid = self.chatGroup.guid;
        [self updateXMPPRoomUserDic];
        
        //如果Room已经上线了，使用相应的XMPPRoom
        NSArray *onlineXMPPRooms = [LCXMPPMessageHelper sharedInstance].onlineXMPPRoomArray;
        for (XMPPRoom *room in onlineXMPPRooms){
            if ([room.roomJID.bare isEqualToString:self.chatGroup.groupJid]) {
                self.xmppRoom = room;
                break;
            }
        }
        //如果Room还未上线，创建一个新Room并上线
        if (!self.xmppRoom) {
            self.xmppRoom = [[LCXMPPMessageHelper sharedInstance] getRoomOnlineWithRoomBareJid:self.chatGroup.groupJid];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:NotificationDidReceiveXMPPGroupMessage object:nil];
    
    UIBarButtonItem *groupInfoBarButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"GroupInfoIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(barButtonAction)];
    self.navigationItem.rightBarButtonItem = groupInfoBarButton;
}

- (void)refreshData{
    [LCNetRequester getChatGroupInfoForGroupGuid:self.chatGroup.guid callBack:^(LCChatGroupModel *chatGroup, NSError *error) {
        if (error) {
            LCLogWarn(@"getChatGroupInfoForGroupGuid error:%@",error);
        }else{
            self.chatGroup = chatGroup;
            
            //更新本地的聊天会话model
            LCChatContactModel *chatContactModel = [LCChatContactModel chatContactModelWithGroup:chatGroup];
            [[LCDataManager sharedInstance].chatContactDic setObject:chatContactModel forKey:[chatContactModel getBareJidString]];
            
            [self updateShow];
        }
    }];
}

- (void)updateShow{
    [super updateShow];
    
    //Roy： 在聊天室成员页加入，跳到聊天，返回的聊天成员中没有自己，暂时不做popout
    //[self popOutIfUserIsNotMemberOfChatGroup];
    
    self.title = [LCStringUtil getNotNullStr: self.chatGroup.name];
}

//Override
- (void)sendGroupChatToServer:(MessageModel *)model{
    //如果当前用户是聊天室成员，发送消息，否则toast
    if (self.chatGroup.isMember) {
        [super sendGroupChatToServer:model];
    }else{
        [YSAlertUtil tipOneMessage:@"您不在当前邀约中，发送失败" yoffset:TipAboveKeyboardYoffset delay:TipErrorDelay];
    }
}

- (void)barButtonAction{
    [LCViewSwitcher pushToShowChatGroupMemberVCForGroup:self.chatGroup on:self.navigationController];
}

- (void)updateXMPPRoomUserDic{
    for (LCUserModel *user in self.chatGroup.memberList){
        [self.xmppRoomUserDic setObject:user forKey:user.telephone];
    }
    
    [self updateMessageModelsWithNewUserInfo];
}

- (void)popOutIfUserIsNotMemberOfChatGroup{
    BOOL amIMemberOfChatGroup = NO;
    for (LCUserModel *aUser in self.chatGroup.memberList){
        if ([aUser.telephone isEqualToString:[LCDataManager sharedInstance].userInfo.telephone]) {
            amIMemberOfChatGroup = YES;
            break;
        }
    }
    if (!amIMemberOfChatGroup) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)notificationAction:(NSNotification *)notification{
    if ([notification.name isEqualToString:NotificationDidReceiveXMPPGroupMessage]) {
        XMPPMessage *message = [notification.userInfo objectForKey:XMPPMessageKey];
        //收到该Room的消息，并且不是自己发的，进行显示
        if ([message.from.bare isEqualToString:self.chatWithJidStr] &&
            ![message.from.resource isEqualToString:[LCDataManager sharedInstance].userInfo.telephone]) {
            NSString *info = message.info;
            if ([LCStringUtil isNotNullString:info]) {
                [self didReceiveGroupMessage:message senderTelephone:message.from.resource];
            }
        }
    }
}

- (void)didReceiveGroupMessage:(XMPPMessage *)message senderTelephone:(NSString *)senderTelephone{
    LCUserModel *userInfo = [self.xmppRoomUserDic objectForKey:senderTelephone];
    if (!userInfo) {
        //如果当前计划中没有该成员，有可能新加入计划的人或已经退出计划的人，发送的聊天信息
        //更新计划信息
         [self getUserInfoByTelephone:senderTelephone];
    }
    
    MessageModel *model = [LCMessageConvert getEMMessageFromJsonStr:message.info];
    model.senderTelephone = [LCStringUtil getNotNullStr:model.senderTelephone];
    
    model.content = message.body;
    model.isSender = NO;
    model.isChatGroup = YES;
    model.headImageURL = [NSURL URLWithString:userInfo.avatarThumbUrl];
    model.username = userInfo.nick;
    model.sendDate = [message sendDate];
    [self addMessageModelToDataSource:model];
    [self updateTableView];
}


@end
