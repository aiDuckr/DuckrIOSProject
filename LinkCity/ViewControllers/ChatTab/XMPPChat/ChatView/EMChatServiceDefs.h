//
//  EMChatServiceDefs.h
//  YSChatInterface
//
//  Created by 张宗硕 on 11/18/14.
//  Copyright (c) 2014 yunshuo. All rights reserved.
//

#ifndef YSChatInterface_EMChatServiceDefs_h
#define YSChatInterface_EMChatServiceDefs_h

#import "commonDefs.h"

/*!
 @enum
 @brief 聊天类型
 @constant eMessageBodyType_Text 文本类型
 @constant eMessageBodyType_Image 图片类型
 @constant eMessageBodyType_Plan 计划分享类型
 @constant eMessageBodyType_System 系统消息
 @constant eMessageBodyType_Video 视频类型
 @constant eMessageBodyType_Location 位置类型
 @constant eMessageBodyType_Voice 语音类型
 @constant eMessageBodyType_File 文件类型
 @constant eMessageBodyType_Command 命令类型
 */
typedef enum {
    eMessageBodyType_Text = 0,
    eMessageBodyType_Image = 1,
    eMessageBodyType_Plan = 2,
    eMessageBodyType_Location = 3,
    eMessageBodyType_System = 4,
    eMessageBodyType_CheckIn = 5,
    eMessageBodyType_Voice = 6,
    eMessageBodyType_Video,
    eMessageBodyType_Command,
    eMessageBodyType_File,
}MessageBodyType;

/*!
 @enum
 @brief 聊天消息发送状态
 @constant eMessageDeliveryState_Pending 待发送
 @constant eMessageDeliveryState_Delivering 正在发送
 @constant eMessageDeliveryState_Delivered 已发送, 成功
 @constant eMessageDeliveryState_Failure 已发送, 失败
 */
typedef enum {
    eMessageDeliveryState_Pending = 0,
    eMessageDeliveryState_Delivering,
    eMessageDeliveryState_Delivered,
    eMessageDeliveryState_Failure
}MessageDeliveryState;

#endif
