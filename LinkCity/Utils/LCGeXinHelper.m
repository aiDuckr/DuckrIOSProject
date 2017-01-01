//
//  LCGeXinHelper.m
//  LinkCity
//
//  Created by roy on 2/8/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCGeXinHelper.h"


#if DEBUG
static const int xmppLogLevel = XMPP_LOG_LEVEL_INFO;
#else
static const int xmppLogLevel = XMPP_LOG_LEVEL_WARN;
#endif

@implementation LCGeXinHelper

@synthesize gexinPusher = _gexinPusher;
@synthesize appKey = _appKey;
@synthesize appSecret = _appSecret;
@synthesize appID = _appID;
@synthesize clientId = _clientId;

@synthesize lastPayloadIndex = _lastPaylodIndex;




+ (instancetype)sharedInstance{
    static LCGeXinHelper *gexinHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gexinHelper = [[LCGeXinHelper alloc] init];
    });
    return gexinHelper;
}

- (void)startSdk{
    [self startSdkWith:kAppId appKey:kAppKey appSecret:kAppSecret];
}

- (void)stopSdk
{
    if (_gexinPusher) {
        [_gexinPusher destroy];
        _gexinPusher = nil;
        
        _clientId = nil;
    }
}


- (void)registerDeviceToken:(NSString *)deviceToken
{
    if (![self checkSdkInstance]) {
        return;
    }
    
    [_gexinPusher registerDeviceToken:deviceToken];
}

- (NSString *)sendMessage:(NSData *)body error:(NSError **)error {
    if (![self checkSdkInstance]) {
        return nil;
    }
    
    return [_gexinPusher sendMessage:body error:error];
}


#pragma mark Inner Function
- (BOOL)checkSdkInstance
{
    if (!_gexinPusher) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:@"SDK未启动" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alertView show];
        return NO;
    }
    return YES;
}

- (void)startSdkWith:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret
{
    if (!_gexinPusher) {
        self.appID = appID;
        self.appKey = appKey;
        self.appSecret = appSecret;
        
        _clientId = nil;
        
        NSError *err = nil;
        _gexinPusher = [GexinSdk createSdkWithAppId:_appID
                                             appKey:_appKey
                                          appSecret:_appSecret
                                         appVersion:APP_LOCAL_SHOT_VERSION_STRING
                                           delegate:self
                                              error:&err];
    }
}

#pragma mark - GexinSdkDelegate
- (void)GexinSdkDidRegisterClient:(NSString *)clientId {
    _clientId = clientId;
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationJustRegisterGexinClientID object:nil];
    XMPPLogCInfo(@"[GexinSdk] didRegisterClient**********************:%@",clientId);
}

// [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
- (void)GexinSdkDidOccurError:(NSError *)error {
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationJustFailRegisterGexinClientID object:nil];
    XMPPLogCWarn(@"%@",[NSString stringWithFormat:@">>>[GexinSdk error]:%@", [error localizedDescription]]);
}

// [4]: 收到个推消息

static NSDate *lastReceiveGexinNotifyDate;
- (void)GexinSdkDidReceivePayload:(NSString *)payloadId fromApplication:(NSString *)appId{
    NSData *payload = [_gexinPusher retrivePayloadById:payloadId];
    NSString *payloadMsg = nil;
    if (payload) {
        payloadMsg = [[NSString alloc] initWithBytes:payload.bytes
                                              length:payload.length
                                            encoding:NSUTF8StringEncoding];
    }
    NSString *record = [NSString stringWithFormat:@"%d, %@", ++_lastPaylodIndex, payloadMsg];
    XMPPLogCInfo(@"[GexinSdk] receive payload:%@",record);
    
    
    //应用在前台收到通知后，如果不是聊天的，更新红点数
    NSData *data = [payloadMsg dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *userInfoDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (!error && userInfoDic && [[userInfoDic allKeys] containsObject:@"payload"]) {
        NSDictionary *payloadDic = [userInfoDic objectForKey:@"payload"];
        if (payloadDic && [[payloadDic allKeys]containsObject:@"T"]) {
            NSInteger pushType = -1;
            pushType = [LCStringUtil idToNSInteger:[payloadDic objectForKey:@"T"]];
            
            //如果不是聊天的通知， 更新红点数
            if (pushType != PUSH_TYPE_CHAT) {
                
                //由于App在后台时收到的推送，进入前台后会被个推再接收一遍
                //这里设置由于收到个推推送而更新红点数的操作，不能太频繁，间隔至少大于 MinRefreshRedDotTimeIntervalWhenGexinNotify
                NSDate *now = [NSDate date];
                if (!lastReceiveGexinNotifyDate ||
                    [now timeIntervalSinceDate:lastReceiveGexinNotifyDate]>MinRefreshRedDotTimeIntervalWhenGexinNotify) {
                    
                    lastReceiveGexinNotifyDate = now;
                    [[LCRedDotHelper sharedInstance] startUpdateRedDot];
                }
            }
        }
    }
}

// [4-EXT]:发送上行消息结果反馈
- (void)GexinSdkDidSendMessage:(NSString *)messageId result:(int)result {
    NSString *record = [NSString stringWithFormat:@"Received sendmessage:%@ result:%d", messageId, result];
    XMPPLogCInfo(@"[GexinSdk] sendmessage:%@",record);
}


@end
