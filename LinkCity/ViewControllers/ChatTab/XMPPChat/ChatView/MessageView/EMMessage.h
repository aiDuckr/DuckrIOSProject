//
//  EMMessage.h
//  YSChatInterface
//
//  Created by 张宗硕 on 11/18/14.
//  Copyright (c) 2014 yunshuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMChatServiceDefs.h"

/*!
 @class
 @brief 聊天消息类
 */
@interface EMMessage : NSObject

/*!
 @property
 @brief 消息来源用户名
 */
@property (nonatomic, copy) NSString *from; // should be username for now

/*!
 @property
 @brief 消息目的地用户名
 */
@property (nonatomic, copy) NSString *to;   // should be username for now

/*!
 @property
 @brief 消息ID
 */
@property (nonatomic, copy) NSString *messageId;

/*!
 @property
 @brief 消息发送或接收的时间
 */
@property (nonatomic) long long timestamp;

/*!
 @property
 @brief 消息是否已读
 */
@property (nonatomic) BOOL isRead;

/*!
 @property
 @brief 此消息是否是群聊消息
 */
@property (nonatomic) BOOL isGroup;

/*!
 @property
 @brief 群聊消息里的发送者用户名
 */
@property (nonatomic, copy) NSString *groupSenderName;

/*!
 @property
 @brief 是否是离线消息
 */
@property (nonatomic, readonly) BOOL isOfflineMessage;

/*!
 @property
 @brief 消息送达状态
 */
@property (nonatomic) MessageDeliveryState deliveryState;

@end
