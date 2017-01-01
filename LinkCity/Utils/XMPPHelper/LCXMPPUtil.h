//
//  LCXMPPUtil.h
//  LinkCity
//
//  Created by 张宗硕 on 11/26/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCUserModel.h"

/// 0. 全部/未知; 1.单聊; 2.收藏; 3.邀约群; 4.招待群. 5.全部群聊.
typedef enum {
    CHAT_CONTACT_TYPE_ALL = 0,  //可以是任意
    CHAT_CONTACT_TYPE_USER = 1,
    CHAT_CONTACT_TYPE_PLAN = 2,
    CHAT_CONTACT_TYPE_GROUP = 3,
    CHAT_CONTACT_TYPE_GROUPCHAT = 4,    //群聊，可能是计划或聊天室
    CHAT_CONTACT_PRIVATE_CHAT,
    CHAT_CONTACT_FAVOR,
    CHAT_CONTACT_PARTNER,
    CHAT_CONTACT_RECEPTION,
    CHAT_CONTACT_GROUP_ALL
} ChatContactType;

#define MESAAGE_COUNT_USER_FIRST_JOIN_GROUP_CHAT 20
#define THRESHHOLD_MESSAGE_TIME_INTERVAL 60
///在聊天页面，显示聊天信息条数的阈值，当超过该数量的消息时，会自动删除多余显示内容
#define MAX_MESSAGE_NUM_THRESHOLD_WHEN_CHATING 100
#define MESSSAGE_NUM_TO_RESERVE_AFTER_OPTIMIZE 40

@interface LCXMPPUtil : NSObject
+ (void)deleteJid:(NSString *)jidStr;
+ (NSDate *)getGroupChatLastOneMsgDate:(NSString *)receiverJID;
/**当前用户，是否新加入该聊天
   根据userDefault是否存有该聊天的最近聊天时间判断
 @param receiverJID: 群聊的room jid
 */
+ (BOOL)amINewToGroupChat:(NSString *)receiverJID;
+ (NSArray *)loadRecentChatMsg:(NSString *)receiverJID isGroup:(BOOL)isGroup fromDate:(NSDate *)date;
+ (NSArray *)loadRecentChatContact:(ChatContactType)contactType;
+ (BOOL)saveChatContact:(LCUserModel *)contactUser withType:(ChatContactType)contactType;

+ (void)deleteChatMsg:(NSString *)receiverJID;
+ (void)deleteChatContact:(NSString *)contactJID;

+ (void)deleteAllChatMsg;
+ (void)deleteAllChatContact;
//+ (BOOL)saveChatPlanGroup:(LCPlan *)contactGroup;

+ (XMPPJID *)getJIDFromUserOrPlan:(id)userOrPlan;
+ (XMPPJID *)getJIDFromUserInfo:(LCUserModel *)userInfo;
//+ (XMPPJID *)getJIDFromLCPlan:(LCPlan *)plan;

+ (NSString *)getMessagteDateStringFromDate:(NSDate *)date;


@end
