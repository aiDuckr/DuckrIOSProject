//
//  LCLogManager.h
//  LinkCity
//
//  Created by roy on 2/5/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

//  初始化Logger，设置在Console和本地文件中存储的Log的级别
//  设置不同功能模块的Log级别，如lcNetLogLevel

#import <Foundation/Foundation.h>
#import "UIWindow+Shake.h"

//for XMPPLogger
#import "XMPPLogging.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "DDFileLogger.h"
#import "DDASLLogger.h"




#if DEBUG
    static int lcDefaultLogLevel = XMPP_LOG_LEVEL_INFO | XMPP_LOG_FLAG_TRACE;
    static int lcNetLogLevel = XMPP_LOG_LEVEL_INFO;
    static int lcChatLogLevel = XMPP_LOG_LEVEL_INFO | XMPP_LOG_FLAG_TRACE;
#else
    static int lcDefaultLogLevel = XMPP_LOG_LEVEL_WARN;
    static int lcNetLogLevel = XMPP_LOG_LEVEL_WARN;
    static int lcChatLogLevel = XMPP_LOG_LEVEL_WARN;
#endif

// In debug mode, this flag enable shake to log.
// In release mode, this flag disable shake to log.
#if DEBUG
    static BOOL ShakeToLogFlag = YES;
#else
    static BOOL ShakeToLogFlag = NO;
#endif


// LCLog, the default logger, use lcDefaultLogLevel
#define LCLogError(frmt, ...) XMPP_LOG_OBJC_MAYBE(XMPP_LOG_ASYNC_ERROR,   lcDefaultLogLevel, XMPP_LOG_FLAG_ERROR,  \
XMPP_LOG_CONTEXT, frmt, ##__VA_ARGS__)

#define LCLogWarn(frmt, ...)     XMPP_LOG_OBJC_MAYBE(XMPP_LOG_ASYNC_WARN,    lcDefaultLogLevel, XMPP_LOG_FLAG_WARN,   \
XMPP_LOG_CONTEXT, frmt, ##__VA_ARGS__)

#define LCLogInfo(frmt, ...)     XMPP_LOG_OBJC_MAYBE(XMPP_LOG_ASYNC_INFO,    lcDefaultLogLevel, XMPP_LOG_FLAG_INFO,    \
XMPP_LOG_CONTEXT, frmt, ##__VA_ARGS__)

#define LCLogVerbose(frmt, ...)  XMPP_LOG_OBJC_MAYBE(XMPP_LOG_ASYNC_VERBOSE, lcDefaultLogLevel, XMPP_LOG_FLAG_VERBOSE, \
XMPP_LOG_CONTEXT, frmt, ##__VA_ARGS__)

#define LCLogTrace()             XMPP_LOG_OBJC_MAYBE(XMPP_LOG_ASYNC_TRACE,   lcDefaultLogLevel, XMPP_LOG_FLAG_TRACE, \
XMPP_LOG_CONTEXT, @"%@: %@", THIS_FILE, THIS_METHOD)

// LCNetLog, the logger for network, use lcNetLogLevel
#define LCNetLogError(frmt, ...) XMPP_LOG_OBJC_MAYBE(XMPP_LOG_ASYNC_ERROR,   lcNetLogLevel, XMPP_LOG_FLAG_ERROR,  \
XMPP_LOG_CONTEXT, frmt, ##__VA_ARGS__)

#define LCNetLogWarn(frmt, ...)     XMPP_LOG_OBJC_MAYBE(XMPP_LOG_ASYNC_WARN,    lcNetLogLevel, XMPP_LOG_FLAG_WARN,   \
XMPP_LOG_CONTEXT, frmt, ##__VA_ARGS__)

#define LCNetLogInfo(frmt, ...)     XMPP_LOG_OBJC_MAYBE(XMPP_LOG_ASYNC_INFO,    lcNetLogLevel, XMPP_LOG_FLAG_INFO,    \
XMPP_LOG_CONTEXT, frmt, ##__VA_ARGS__)

#define LCNetLogVerbose(frmt, ...)  XMPP_LOG_OBJC_MAYBE(XMPP_LOG_ASYNC_VERBOSE, lcNetLogLevel, XMPP_LOG_FLAG_VERBOSE, \
XMPP_LOG_CONTEXT, frmt, ##__VA_ARGS__)

#define LCNetLogTrace()             XMPP_LOG_OBJC_MAYBE(XMPP_LOG_ASYNC_TRACE,   lcNetLogLevel, XMPP_LOG_FLAG_TRACE, \
XMPP_LOG_CONTEXT, @"%@: %@", THIS_FILE, THIS_METHOD)

// LCChatLog, the default logger, use lcDefaultLogLevel
#define LCChatLogError(frmt, ...) XMPP_LOG_OBJC_MAYBE(XMPP_LOG_ASYNC_ERROR,   lcChatLogLevel, XMPP_LOG_FLAG_ERROR,  \
XMPP_LOG_CONTEXT, frmt, ##__VA_ARGS__)

#define LCChatLogWarn(frmt, ...)     XMPP_LOG_OBJC_MAYBE(XMPP_LOG_ASYNC_WARN,    lcChatLogLevel, XMPP_LOG_FLAG_WARN,   \
XMPP_LOG_CONTEXT, frmt, ##__VA_ARGS__)

#define LCChatLogInfo(frmt, ...)     XMPP_LOG_OBJC_MAYBE(XMPP_LOG_ASYNC_INFO,    lcChatLogLevel, XMPP_LOG_FLAG_INFO,    \
XMPP_LOG_CONTEXT, frmt, ##__VA_ARGS__)

#define LCChatLogVerbose(frmt, ...)  XMPP_LOG_OBJC_MAYBE(XMPP_LOG_ASYNC_VERBOSE, lcChatLogLevel, XMPP_LOG_FLAG_VERBOSE, \
XMPP_LOG_CONTEXT, frmt, ##__VA_ARGS__)

#define LCChatLogTrace()             XMPP_LOG_OBJC_MAYBE(XMPP_LOG_ASYNC_TRACE,   lcChatLogLevel, XMPP_LOG_FLAG_TRACE, \
XMPP_LOG_CONTEXT, @"%@: %@", THIS_FILE, THIS_METHOD)

@interface LCLogManager : NSObject
+ (instancetype)sharedInstance;

- (void)setupLogManager;
- (void)sendLog;
@end
