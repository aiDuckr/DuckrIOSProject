//
//  commonDefs.h
//  YSChatInterface
//
//  Created by 张宗硕 on 11/18/14.
//  Copyright (c) 2014 yunshuo. All rights reserved.
//

#ifndef YSChatInterface_commonDefs_h
#define YSChatInterface_commonDefs_h

#define kSDKPassword   @"password"
#define kSDKUsername   @"username"
#define kSDKToken      @"token"

#pragma mark - buddy chatting state
typedef enum {
    eChatState_Stopped = 0,
    eChatState_Composing,
    eChatState_Paused,
}EMChatState;

#pragma mark - buddy online state
typedef enum {
    eOnlineStatus_OffLine = 0,
    eOnlineStatus_Online,
    eOnlineStatus_Away,
    eOnlineStatus_Busy,
    eOnlineStatus_Invisible,
    eOnlineStatus_Do_Not_Disturb
}EMOnlineStatus;

#endif
