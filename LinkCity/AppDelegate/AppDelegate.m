//
//  AppDelegate.m
//  LinkCity
//
//  Created by 哈哈哈 on 10/23/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "AppDelegate.h"
#import "LCDataManager.h"
#import "LCBaiduMapManager.h"
#import "LCRedDotHelper.h"

#import "LCViewSwitcher.h"
#import "LCInitData.h"
#import "LCLogManager.h"
#import "LCPhoneUtil.h"
#import "LCUserEvaluationVC.h"
#import "LCUserOrderDetailVC.h"
#import "LCEditUserInfoVC.h"
#import "LCUserIdentityHelper.h"

//for UMeng
#import "LCUMengHelper.h"

#import "LCDebugVC.h"
#import "SSKeychain.h"

#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

#import "LCEqqHelper.h"

#import "LCLocationManager.h"
#import "LCDuckrShareCodeHelper.h"

#import "LinkCity-Swift.h"


@interface AppDelegate ()<WXApiDelegate>
@property (nonatomic, strong) LCSplashVC *splashVC;
@property (nonatomic, assign) NSInteger setConfigLocationTag;    ///> 0为未知结果，-1为失败，1为成功
@property (nonatomic, assign) NSInteger setConfigClientTag;    ///> 0为未知结果，-1为失败，1为成功
@end

@implementation AppDelegate

#pragma mark - App LifeCycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.setConfigLocationTag = 0;
    self.setConfigClientTag = 0;
    //初始化Bugtags
    //三种呼出方式
    //BTGInvocationEventBubble(悬浮小球)
    //BTGInvocationEventShake(摇一摇)
    //BTGInvocationEventNone(静默)
    [self updateDeviceUUID];
    
    [[LCDataManager sharedInstance] doBackCompatible];
    [[LCDataManager sharedInstance] readData];
    
    [self initUI];

    //setup GeXin
    [[LCGeXinHelper sharedInstance] startSdk];
    //注册远程通知
    [self registerRemoteNotification];
    //注册监听更新remote notification deviceToken的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:NotificationUserJustLogin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:NotificationUserJustResetPassword object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:NotificationJustUpdateLocation object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:NotificationJustFailUpdateLocation object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:NotificationJustRegisterGexinClientID object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:NotificationJustFailRegisterGexinClientID object:nil];
    //初始化百度地图
    [[LCBaiduMapManager sharedInstance] startBaiduMap];
    //初始化XMPP聊天
    [[LCXMPPMessageHelper sharedInstance] setup];
    //初始化友盟统计
//    [self testToGetUMengDeviceID];
//    [MobClick setLogEnabled:YES];
//    if (![LCDataManager sharedInstance].isFirstTimeOpenApp &&
//        [LCDataManager sharedInstance].shouldUMengActive == 1) {
    [[LCUMengHelper sharedInstance] setup];
//    }
    
    
    //初始化Log日志模块
    [[LCLogManager sharedInstance] setupLogManager];
    //setup wexin
    [WXApi registerApp:UMENG_WEIXIN_APP_ID withDescription:@"Duckr"];
    //上传手机通讯录
    [LCPhoneUtil checkAndUploadTelephoneContact];
    
#if DEBUG
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didShake:) name:LCWindowShakeNotification object:nil];
    [[[[UIApplication sharedApplication] delegate] window] setEnableShakeGesture:YES];
#else
    [[[UIApplication sharedApplication] keyWindow] setEnableShakeGesture:NO];
#endif
    
    NSDictionary* message = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (message) {
        NSString *payloadMsg = [message objectForKey:@"payload"];
        NSString *record = [NSString stringWithFormat:@"[APN]%@, %@", [NSDate date], payloadMsg];
        LCLogInfo(@"finish launch with payLoadMsg:%@,record:%@",payloadMsg,record);
    }
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[LCDataManager sharedInstance] saveData];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[LCGeXinHelper sharedInstance] stopSdk];
    [[LCDataManager sharedInstance] clearOneActivityValidData];
    [[LCDataManager sharedInstance] saveData];
    [[LCXMPPMessageHelper sharedInstance] goOffline];
    [[LCRedDotHelper sharedInstance] stopUpdateRedDot];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    LCLogInfo(@"applicationWillEnterForeground");
//    [[LCDataManager sharedInstance] readData];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    LCLogInfo(@"AppDidBecodeActive");
    /// 获取初始化配置信息.
    [self getInitConfigFromServer];
    /// 获取订单相关配置信息
    [self getOrderRuleFromServer];
    /// 更新红点数信息
    [[LCRedDotHelper sharedInstance] startUpdateRedDot];
    /// 更新位置信息.
    [[LCBaiduMapManager sharedInstance] startUpdateUserLocation];
    /// 重新上线个推
    [[LCGeXinHelper sharedInstance] startSdk];
    [self updateUserInfo];
    /// 清除App Icon上的未读消息数.
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    /// 连接聊天服务器.
    [self loginXMPP];
    /// 检测达客口令
    [[LCDuckrShareCodeHelper sharedInstance] detectDuckrShareCode];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[LCXMPPMessageHelper sharedInstance] saveContext];
    [[LCDataManager sharedInstance] saveData];
    [[LCXMPPMessageHelper sharedInstance] goOffline];
}

- (void)dealloc {
    [[LCDataManager sharedInstance] saveData];
    [[LCXMPPMessageHelper sharedInstance] goOffline];
    [[LCXMPPMessageHelper sharedInstance] teardownStream];
}

#pragma mark - 3D Touch
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if ([shortcutItem.type isEqualToString:UITouchSendPlan]) {
            [self.tabBarVC setSelectedIndex:0];
            [self.tabBarVC.planTabNavVC popToRootViewControllerAnimated:NO];
            
            UIViewController *topVC = [self.tabBarVC.planTabNavVC.viewControllers firstObject];
            if ([topVC isKindOfClass:[LCPlanTabVC class]]) {
                LCPlanTabVC *planTabVC = (LCPlanTabVC *)topVC;
                [planTabVC sendPlan];
            }
        }else if([shortcutItem.type isEqualToString:UITouchSendTourpic]) {
            [self.tabBarVC setSelectedIndex:1];
            [self.tabBarVC.tourpicTabVC popToRootViewControllerAnimated:NO];
            
            UIViewController *topVC = [self.tabBarVC.tourpicTabVC.viewControllers firstObject];
            if ([topVC isKindOfClass:[LCTourpicTabVC class]]) {
                LCTourpicTabVC *tourpicTabVC = (LCTourpicTabVC *)topVC;
                [tourpicTabVC sendTourPic];
            }
        }else if([shortcutItem.type isEqualToString:UITouchBestTourpic]) {
            [self.tabBarVC setSelectedIndex:1];
            [self.tabBarVC.tourpicTabVC popToRootViewControllerAnimated:NO];
            
            UIViewController *topVC = [self.tabBarVC.tourpicTabVC.viewControllers firstObject];
            if ([topVC isKindOfClass:[LCTourpicTabVC class]]) {
                LCTourpicTabVC *tourpicTabVC = (LCTourpicTabVC *)topVC;
                [tourpicTabVC showTabIndex:0];
            }
        }
    });
}

#pragma mark - Deeplink
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    LCLogInfo(@"application openURL %@",url);
    
    //Roy 偶尔会有跳转后显示错乱的问题，延时跳转
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        LCLogInfo(@"ExecuteAppOpenURL");
        /*e.g.
         url:       com.baiying.linkcity.duckr://plandetail?planguid=71452a291f3fe1a0e589a0510d587e81
         urlHost:   plandetail
         paramDic:  @{ @"planguid" : @"71452a291f3fe1a0e589a0510d587e81" }
         */
        NSString *urlHost = [url host];
        NSMutableDictionary *paramDic = [LCStringUtil getURLParamDictionaryFromURLString:[url absoluteString]];
        LCLogInfo(@"url:%@,\r\nhost:%@,\r\npath:%@,\r\nquery:%@,\r\nparamDic:%@",url,[url host],[url path],[url query],paramDic);
        
        
        if ([[url scheme] isEqualToString:@"com.baiying.linkcity.duckr.plandetail"]) {
            //兼容V3.0以前的版本   跳到计划详情deeplink为：
            //com.baiying.linkcity.duckr.plandetail://plandetail?PlanType=1&PlanGuid=71452a291f3fe1a0e589a0510d587e81
            
            //处理自定义跳转
            NSString *planGuid = [paramDic objectForKey:@"PlanGuid"];
            if ([LCStringUtil isNotNullString:planGuid]) {
                LCPlanModel *plan = [LCPlanModel createEmptyPlanForEdit];
                plan.planGuid = planGuid;
                
                if ([LCSharedFuncUtil getAppDelegate].tabBarVC.planTabNavVC) {
                    [self.tabBarVC setSelectedIndex:0];
                    [LCViewSwitcher pushToShowPlanDetailVCForPlan:plan recmdUuid:nil on:[LCSharedFuncUtil getAppDelegate].tabBarVC.planTabNavVC];
                }
            }
        }else if([urlHost isEqualToString:DeepLinkHostForPlanDetail]) {
            //V3.0以后跳到计划详情，格式为
            //com.baiying.linkcity.duckr://plandetail?planguid=71452a291f3fe1a0e589a0510d587e81&recmduuid=xxxx
            
            NSString *planGuid = [paramDic objectForKey:DeepLinkParamPlanGuid];
            NSString *recmdUuid = [paramDic objectForKey:DeepLinkParamRecmdUuid];
            if (planGuid) {
                LCPlanModel *plan = [LCPlanModel createEmptyPlanForEdit];
                plan.planGuid = planGuid;
                
                if ([LCSharedFuncUtil getAppDelegate].tabBarVC.planTabNavVC) {
                    [self.tabBarVC setSelectedIndex:0];
                    [LCViewSwitcher pushToShowPlanDetailVCForPlan:plan recmdUuid:recmdUuid on:[LCSharedFuncUtil getAppDelegate].tabBarVC.planTabNavVC];
                }
            }
        }else if([urlHost isEqualToString:DeepLinkHostForTourPic]) {
            NSString *tourPicId = [paramDic objectForKey:DeepLinkParamTourpicId];
            if (tourPicId) {
                LCTourpic *tourPic = [[LCTourpic alloc] init];
                tourPic.guid = tourPicId;
                [self.tabBarVC setSelectedIndex:1];
                [LCViewSwitcher pushToShowTourPicDetail:tourPic withType:LCTourpicDetailVCViewType_Normal on:[LCSharedFuncUtil getAppDelegate].tabBarVC.tourpicTabVC];
            }
        }else if([urlHost isEqualToString:DeepLinkHostForThemePlanList]) {
            NSString *themeName = [paramDic objectForKey:DeepLinkParamThemeTitle];
            NSString *themeId = [paramDic objectForKey:DeepLinkParamThemeId];
            if ([LCStringUtil isNotNullString:themeName] &&
                [LCStringUtil isNotNullString:themeId]) {
                
                NSString *themeNameAfterDecode = [themeName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                [self.tabBarVC setSelectedIndex:0];
                [LCViewSwitcher pushToShowThemeSearchResultForThemeId:[LCStringUtil idToNSInteger:themeId] themeName:themeNameAfterDecode on:[LCSharedFuncUtil getAppDelegate].tabBarVC.planTabNavVC];
            }
        }else if([urlHost isEqualToString:DeepLinkHostForPlacePlanList]){
            NSString *placeName = [paramDic objectForKey:DeepLinkParamPlaceName];
            if ([LCStringUtil isNotNullString:placeName]) {
                NSString *placeNameAfterDecode = [placeName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                [self.tabBarVC setSelectedIndex:0];
                [LCViewSwitcher pushToShowPlanTableVCForPlace:placeNameAfterDecode on:[LCSharedFuncUtil getAppDelegate].tabBarVC.planTabNavVC];
            }
            
        }else if([urlHost isEqualToString:DeepLinkHostForUser]) {
            //DeepLink到个人主页
            //com.baiying.linkcity.duckr://userdetail?userguid=bbca77babb038dc47780c211d5cb50a7&iscar=2&istourguide=2 //跳转到用户主页
            NSString *userUuid = [paramDic objectForKey:DeepLinkParamUserGuid];
            NSInteger isCar = [[paramDic objectForKey:DeepLinkParamUserIsCarIdentity] integerValue];
            NSInteger isTourGuide = [[paramDic objectForKey:DeepLinkParamUserIsTourGuideIdentity] integerValue];
            if ([LCStringUtil isNotNullString:userUuid]) {
                LCUserModel *user = [[LCUserModel alloc] init];
                user.uUID = userUuid;
                user.isCarVerify = isCar;
                user.isTourGuideVerify = isTourGuide;
                
                [self.tabBarVC setSelectedIndex:0];
                [LCViewSwitcher pushToShowUserInfoVCForUser:user on:[LCSharedFuncUtil getAppDelegate].tabBarVC.planTabNavVC];
            }
        }else if([urlHost isEqualToString:DeepLinkHostForWeb]){
            //DeepLink到网页
            //com.baiying.linkcity.duckr://webpage?url=http://www.baidu.com //跳转到用户主页
            NSString *str = [url absoluteString];
            NSRange preRange = [str rangeOfString:@"webpage?url="];
            NSString *webUrl = [str substringFromIndex:(preRange.location + preRange.length)];
            [self.tabBarVC setSelectedIndex:0];
            [LCViewSwitcher pushWebVCtoShowURL:webUrl withTitle:nil on:[LCSharedFuncUtil getAppDelegate].tabBarVC.planTabNavVC];
        }else if([urlHost isEqualToString:DeepLinkHostForUserInfoTab]){
            NSString *type = [paramDic objectForKey:DeepLinkParamUserInfoTabType];
            if ([type isEqualToString:@"edit"]) {
                //DeepLink到编辑个人主页
                //com.baiying.linkcity.duckr://myuserinfo?type=edit  //跳转到编辑个人信息
                if ([[LCDataManager sharedInstance] haveLogin]) {
                    
                    [self.tabBarVC setSelectedIndex:3];
                    LCUserModel *user = [LCDataManager sharedInstance].userInfo;
                    if ([LCDataManager sharedInstance].userInfo) {
                        LCEditUserInfoVC *editUserVC = [LCEditUserInfoVC createInstance];
                        editUserVC.currentUser = user;
                        [[LCSharedFuncUtil getAppDelegate].tabBarVC.userTabVC pushViewController:editUserVC animated:YES];
                    }
                }else{
                    [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
                }
            }
        }
    });
    
    if ([[url scheme] isEqualToString:@"com.baiying.LinkCity.alipay"]) {
        //支付宝支付
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"processOrderWithPaymentResultFunction result = %@",resultDic);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationAliPay object:nil userInfo:@{NotificationAliPayResultKey:resultDic}];
        }];
    }
    
    //处理友盟跳转
    [UMSocialSnsService handleOpenURL:url];
    
    //处理微信
    [WXApi handleOpenURL:url delegate:self];
    
    return YES;
}


#pragma mark - NotificationDelegate
/// 注册推送成功.
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)pToken {
    LCLogInfo(@"the device token id is %@", pToken);
    
    //    // for < 3.0
    //    NSString *deviceToken = [NSString stringWithFormat:@"%@", pToken];
    //
    //    if ([LCStringUtil isNotNullString:deviceToken])
    //    {
    //        [LCDataManager sharedInstance].remoteNotificationToken = deviceToken;
    //        [self updateRemoteNotifcaitonDeviceToken];
    //    }
    
    // for > 3.0
    NSString *token = [[pToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    NSString *deviceTokenForGexin = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    LCLogInfo(@"deviceTokenForGexin:%@", deviceTokenForGexin);
    // [3]:向个推服务器注册deviceToken
    [[LCGeXinHelper sharedInstance] registerDeviceToken:deviceTokenForGexin];
}

/// 注册推送失败.
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    LCLogWarn(@"Regist remote notification failed :%@",error);
    // [3-EXT]:如果APNS注册失败，通知个推服务器
    [[LCGeXinHelper sharedInstance] registerDeviceToken:@""];
}

/// App正在运行时，收到推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    LCLogInfo(@"didReceiveRemoteNotification %ld",(long)application.applicationState);
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    // [4-EXT]:处理APN
    NSString *payloadMsg = [userInfo objectForKey:@"payload"];
    NSString *record = [NSString stringWithFormat:@"[APN]%@, %@", [NSDate date], payloadMsg];
    LCLogInfo(@"didReceiveRemoteNotification payloadMsg:%@,record:%@",payloadMsg,record);
}

/// 收到推送 不论App在前台还是后台
//  当设置了后台接收推送时，后台时收到推送会调用，并唤醒后台运行几秒
//  当用户点击通知从而打开App时，会再调用一遍这个函数 (when your app is about to enter the foreground) 然后App再进入前台
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    LCLogInfo(@"didReceiveRemoteNotification %@",userInfo);
    
    LCLogWarn(@"applicationdidReceiveRemoteNotification\r\n %@",userInfo);
    
    if (application.applicationState == UIApplicationStateActive) {
        //************************ never called ******************/
        
        //如果app在前台，收到推送通知
        NSInteger pushType = [self getPushTypeFromPushUserInfo:userInfo];
        
        //如果不是聊天的通知， 更新红点数
        if (pushType != PUSH_TYPE_CHAT) {
            [[LCRedDotHelper sharedInstance] startUpdateRedDot];
        }
    } else if (application.applicationState == UIApplicationStateInactive) {
        //only jump when app is inactive
        
        // 需要登录跳转的
        if ([LCDataManager sharedInstance].userInfo) {
            //Roy 偶尔会有跳转后显示错乱的问题，延时跳转
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSInteger pushType = [self getPushTypeFromPushUserInfo:userInfo];
                switch (pushType) {
                    case PUSH_TYPE_COMMENT_PLAN:
                    case PUSH_TYPE_REPLY_COMMENT:
                    case PUSH_TYPE_CHAT:
                    case PUSH_TYPE_FAVOR_ME:
                    case PUSH_TYPE_COMMENT_TOURPIC:
                    case PUSH_TYPE_IDENTITY:
                    case PUSH_TYPE_TOURGUIDE_IDENTITY:
                    case PUSH_TYPE_PRISE_TOURPIC_V3:
                    case PUSH_TYPE_SYSTEM_INFO:
                        [self.tabBarVC setSelectedIndex:2];
                        break;
                    case PUSH_TYPE_NEED_TO_EVALUATE_PLAN:
                        [self pushToEvaluatePlanWithUserInfo:userInfo];
                        break;
                    default:
                        [self.tabBarVC setSelectedIndex:0];
                        break;
                }
            });
        } else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSInteger pushType = [self getPushTypeFromPushUserInfo:userInfo];
                switch (pushType) {
                    case PUSH_TYPE_PLAN_DETAIL:
                        [self pushToPlanDetailWithUserInfo:userInfo];
                        break;
                    case PUSH_TYPE_TOURPIC_DETAIL:
                        [self pushToTourpicDetailWithUserInfo:userInfo];
                        break;
                    case PUSH_TYPE_WEBPAGE:
                        [self pushToWebPageWithUserInfo:userInfo];
                        break;
                    case PUSH_TYPE_THEME_LIST:
                        [self pushToPlanThemeListVC:userInfo];
                        break;
                    default:
                        [self.tabBarVC setSelectedIndex:0];
                        break;
                }
            });
        }
    }
    
    // [4-EXT]:处理APN
    NSString *payloadMsg = [userInfo objectForKey:@"payload"];
    
    NSDictionary *aps = [userInfo objectForKey:@"aps"];
    //NSNumber *contentAvailable = aps == nil ? nil : [aps objectForKeyedSubscript:@"content-available"];
    LCLogInfo(@"receive bg notification, payloadMsg:%@,aps:%@",payloadMsg,aps);
    
    
    //必须回调
    if (completionHandler) {
        completionHandler(UIBackgroundFetchResultNoData);
    }
    return ;
}

- (void)pushToPlanDetailWithUserInfo:(NSDictionary *)userInfo {
    NSDictionary *payLoad = [self getPushPayloadFromPushUserInfo:userInfo];
    NSString *planGuid = [payLoad objectForKey:@"PG"];
    
    LCLogWarn(@"applicationdidReceiveRemoteNotification\r\nplanGuid: %@",planGuid);
    if (planGuid) {
        LCPlanModel *plan = [LCPlanModel createEmptyPlanForEdit];
        plan.planGuid = planGuid;
        
        if ([LCSharedFuncUtil getAppDelegate].tabBarVC.planTabNavVC) {
            [self.tabBarVC setSelectedIndex:0];
            [LCViewSwitcher pushToShowPlanDetailVCForPlan:plan recmdUuid:nil on:[LCSharedFuncUtil getAppDelegate].tabBarVC.planTabNavVC];
        }
    }
}

- (void)pushToTourpicDetailWithUserInfo:(NSDictionary *)userInfo {
    NSDictionary *payLoad = [self getPushPayloadFromPushUserInfo:userInfo];
    NSString *tourPicId = [payLoad objectForKey:@"TG"];
    
    LCLogWarn(@"applicationdidReceiveRemoteNotification\r\ntourpicGuid: %@",tourPicId);
    if (tourPicId) {
        LCTourpic *tourPic = [[LCTourpic alloc] init];
        tourPic.guid = tourPicId;
        [self.tabBarVC setSelectedIndex:1];
        [LCViewSwitcher pushToShowTourPicDetail:tourPic withType:LCTourpicDetailVCViewType_Normal on:[LCSharedFuncUtil getAppDelegate].tabBarVC.tourpicTabVC];
    }
}

- (void)pushToEvaluatePlanWithUserInfo:(NSDictionary *)userInfo {
    NSDictionary *payload = [self getPushPayloadFromPushUserInfo:userInfo];
    NSString *planGuid = [payload objectForKey:@"PG"];
    LCLogWarn(@"applicationdidReceiveRemoteNotification\r\nplanGuid: %@",planGuid);
    if ([LCStringUtil isNotNullString:planGuid]) {
        LCPlanModel *plan = [[LCPlanModel alloc] init];
        plan.planGuid = planGuid;
        [self.tabBarVC setSelectedIndex:3];
        if ([[LCDataManager sharedInstance] haveLogin]) {
            [LCViewSwitcher pushToShowOrderDetail:plan withType:LCUserOrderDetailType_Push on:[LCSharedFuncUtil getAppDelegate].tabBarVC.userTabVC];
        }
    }
}

- (void)pushToWebPageWithUserInfo:(NSDictionary *)userInfo {
    NSDictionary *payload = [self getPushPayloadFromPushUserInfo:userInfo];
    NSString *themeId = [payload objectForKey:@"TI"];
    NSString *themeTitle = [LCStringUtil getNotNullStr:[payload objectForKey:@"TE"]];
    [self.tabBarVC setSelectedIndex:0];
    if ([LCStringUtil isNotNullString:themeId]) {
        [LCViewSwitcher pushToShowThemeSearchResultForThemeId:[LCStringUtil idToNSInteger:themeId] themeName:themeTitle on:[LCSharedFuncUtil getAppDelegate].tabBarVC.planTabNavVC];
    }
}

- (void)pushToPlanThemeListVC:(NSDictionary *)userInfo {
    NSDictionary *payload = [self getPushPayloadFromPushUserInfo:userInfo];
    NSString *webUrl = [payload objectForKey:@"Url"];
    NSString *webTitle = [payload objectForKey:@"TT"];
    [self.tabBarVC setSelectedIndex:0];
    [LCViewSwitcher pushWebVCtoShowURL:webUrl withTitle:webTitle on:[LCSharedFuncUtil getAppDelegate].tabBarVC.planTabNavVC];
}

- (NSDictionary *)getPushPayloadFromPushUserInfo:(NSDictionary *)userInfo{
    if ([[userInfo allKeys] containsObject:@"payload"]) {
        NSString *payloadStr = [userInfo objectForKey:@"payload"];
        NSDictionary *dic = (NSDictionary *)[LCSharedFuncUtil decodeObjectFromJsonString:payloadStr];
        return dic;
    }
    return nil;
}

- (NSInteger)getPushTypeFromPushUserInfo:(NSDictionary *)userInfo{
    NSInteger pushType = -1;
    
    NSDictionary *payload = [self getPushPayloadFromPushUserInfo:userInfo];
    
    if (payload && [[payload allKeys] containsObject:@"T"]) {
        pushType = [LCStringUtil idToNSInteger:[payload objectForKey:@"T"]];
    }
    
    return pushType;
}

#pragma mark - DidShake Phone
- (void)didShake:(NSNotification *)notify{
    LCDebugVC *debugVC = [LCDebugVC createInstance];
    [[LCSharedFuncUtil getTopMostViewController] presentViewController:[[UINavigationController alloc] initWithRootViewController:debugVC] animated:YES completion:nil];
}
#pragma mark - Init & Setup
- (void)initUI{
    [[UINavigationBar appearance] setBackgroundColor:[UIColor clearColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor clearColor]];
    if([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        [[UINavigationBar appearance] setTranslucent:YES];
    }
    [[UINavigationBar appearance] setTintColor:UIColorFromRGBA(NavigationBarTintColor, 1)];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGBA(NavigationBarTintColor, 1), NSForegroundColorAttributeName, [UIFont fontWithName:FONT_LANTINGBLACK size:17], NSFontAttributeName, nil]];
    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:LCNavBarBackBarButtonImageName]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[[UIImage imageNamed:LCNavBarBackBarButtonImageName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [[UINavigationBar appearance] setBackgroundImage:[LCUIConstants sharedInstance].navBarOpaqueImage forBarMetrics:UIBarMetricsDefault];
    
    [[UITabBar appearance] setBackgroundColor:[UIColor clearColor]];
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setTintColor:UIColorFromRGBA(NavigationBarTintColor, 1)];
    [[UITabBar appearance] setBackgroundImage:[LCUIConstants sharedInstance].navBarOpaqueImage];
    
    if ([LCDataManager sharedInstance].isFirstTimeOpenApp) {
        [self.window setRootViewController:self.splashVC];
    }else{
        [self.window setRootViewController:self.tabBarVC];
    }
}

- (void)registerRemoteNotification{
    UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:nil];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [[UIApplication sharedApplication] registerUserNotificationSettings:uns];
}


- (void)notificationAction:(NSNotification *)notify {
    LCLogInfo(@"notificationAction: %@",notify.name);
    
    if ([notify.name isEqualToString:NotificationJustUpdateLocation]) {
        // 成功获得到定位信息
        self.setConfigLocationTag = 1;
    } else if ([notify.name isEqualToString:NotificationJustFailUpdateLocation]) {
        self.setConfigLocationTag = -1;
    }
    if ([notify.name isEqualToString:NotificationJustRegisterGexinClientID]){
        // 成功获取到推送信息
        self.setConfigClientTag = 1;
    } else if ([notify.name isEqualToString:NotificationJustFailRegisterGexinClientID]) {
        self.setConfigClientTag = -1;
    }
    if ([notify.name isEqualToString:NotificationUserJustLogin] ||
             [notify.name isEqualToString:NotificationUserJustResetPassword]){
        //用户刚刚登录
        [self loginXMPP];
        [LCPhoneUtil checkAndUploadTelephoneContact];
        [[LCBaiduMapManager sharedInstance] startUpdateUserLocation];
        [self getInitConfigFromServer];
        [self setAppConfigToServer];
    }
    if (0 != self.setConfigLocationTag && 0 != self.setConfigClientTag) {
        [self setAppConfigToServer];
        self.setConfigLocationTag = 0;
        self.setConfigClientTag = 0;
    }
}

- (void)loginXMPP{
    LCUserModel *userInfo = [[LCDataManager sharedInstance] userInfo];
    if ([LCStringUtil isNotNullString:userInfo.openfireAccount] &&
        [LCStringUtil isNotNullString:userInfo.openfirePass])
    {
        if (NO == [[LCXMPPMessageHelper sharedInstance].xmppStream isConnected]) {
            [[LCXMPPMessageHelper sharedInstance] connect];
        }else{
            [[LCXMPPMessageHelper sharedInstance] goOnline];
        }
    }
}


- (void)getInitConfigFromServer {
    [LCNetRequester getInitConfigWithCallBack:^(LCInitData *initData, NSError *error) {
        if (!error) {
            [LCDataManager sharedInstance].appInitData = initData;
            if ([LCStringUtil idToNSInteger:initData.versionInfo.forceUpdate] == 1) {
                [YSAlertUtil alertOneButton:@"立即更新" withTitle:@"更新提示" msg:initData.versionInfo.descriptionStr callBack:^(NSInteger chooseIndex) {
                    if (chooseIndex == 0) {
                        NSString *urlStr = [NSString stringWithFormat:APP_DOWNLOAD_URL];
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                    }
                }];
            }
        }
    }];
}

- (void)getOrderRuleFromServer{
    [LCNetRequester getOrderRuleWithCallBack:^(LCOrderRuleModel *orderRule, NSError *error) {
        if (error) {
            LCLogInfo(@"getOrderRuleWithCallBack, error:%@",error);
        }else{
            [LCDataManager sharedInstance].orderRule = orderRule;
        }
    }];
}

- (void)setAppConfigToServer {
    [LCNetRequester setAppConfigWithCallBack:^(NSError *error) {
        LCLogInfo(@"%@---%@",[[NSThread callStackSymbols] firstObject],error);
    }];
}

- (void)updateDeviceUUID{
    NSString *deviceUUID = [SSKeychain passwordForService:@"DuckrPromotion" account:@"Duckr"];
    if ([LCStringUtil isNullString:deviceUUID]){
        NSString *aUUID = [[NSUUID UUID] UUIDString];
        [SSKeychain setPassword:aUUID forService:@"DuckrPromotion" account:@"Duckr"];
        deviceUUID = aUUID;
    }
    LCLogInfo(@"duckrPassword:%@",deviceUUID);
    
    [LCDataManager sharedInstance].deviceUUID = deviceUUID;
}

- (void)updateUserInfo{
    if ([LCStringUtil isNotNullString:[LCDataManager sharedInstance].userInfo.uUID]) {
        [LCNetRequester getUserInfo:[LCDataManager sharedInstance].userInfo.uUID callBack:^(LCUserModel *user, NSError *error) {
            if (!error) {
                [LCDataManager sharedInstance].userInfo = user;
            }
        }];
    }
}

#pragma mark Wx Pay
-(void) onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationWechatPay object:nil userInfo:@{NotificationWechatPayResultKey:resp}];
    }
}

#pragma mark For UMeng Test
- (void)testToGetUMengDeviceID {
    // This is an example of a functional test case.
    Class cls = NSClassFromString(@"UMANUtil");
    SEL deviceIDSelector = @selector(openUDIDString);
    NSString *deviceID = nil;
    if(cls && [cls respondsToSelector:deviceIDSelector]){
        deviceID = [cls performSelector:deviceIDSelector];
    }
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:@{@"oid" : deviceID}
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    
    NSLog(@"************\n%@*****************\n", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
}

#pragma mark Public Interface
- (LCSplashVC *)splashVC{
    if (!_splashVC) {
        _splashVC = [LCSplashVC createInstance];
    }
    
    return _splashVC;
}

- (LCTabBarVC *)tabBarVC{
    if (!_tabBarVC) {
        _tabBarVC = [LCTabBarVC createInstance];
    }
    return _tabBarVC;
}

- (void)showTabBarVC{
    [self.window setRootViewController:self.tabBarVC];
}
@end
