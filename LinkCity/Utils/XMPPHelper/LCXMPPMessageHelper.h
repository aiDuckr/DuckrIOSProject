//
//  LCXMPPMessageHelper.h
//  LinkCity
//
//  Created by roy on 3/25/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCXMPPHelper.h"
#import "LocationViewController.h"
#import "MessageModel.h"

@interface LCXMPPMessageHelper : LCXMPPHelper
@property (nonatomic, strong) NSMutableArray *messagesToSend;   //array of MessageModel


+ (instancetype)sharedInstance;


- (void)sendChatSystemInfo:(NSString *)systemInfo toBareJidString:(NSString *)jidStr isGroup:(BOOL)isGroup;
- (void)sendCheckIn:(LCLocationModel *)location toBareJidString:(NSString *)jidStr isGroup:(BOOL)isGroup;




- (void)sendChatMessage:(NSString *)message toBareJidString:(NSString *)jidStr;
- (void)sendChatMessageModel:(MessageModel *)model toBareJidString:(NSString *)jidStr;

//当确定Room在线时，使用这个直接发送
- (void)sendGroupChat:(MessageModel *)model toXMPPRoom:(XMPPRoom *)xmppRoom;
//当不确定Room在线时，使用这个发送；   如果Room不在线会创建并上线Room，然后发送消息
- (void)sendGroupChat:(MessageModel *)model toBareJidString:(NSString *)jidStr;
@end
