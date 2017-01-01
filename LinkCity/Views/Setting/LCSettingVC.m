//
//  LCSettingVC.m
//  LinkCity
//
//  Created by 张宗硕 on 11/24/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCSettingVC.h"
#import "LCSlideVC.h"
#import "LCStoryboardManager.h"
#import "LCWebVC.h"
#import "EGOCache.h"
#import "ChatViewController.h"
#import "LCContentVC.h"
#import "LCCommonApi.h"

@interface LCSettingVC ()<UIAlertViewDelegate, LCCommonApiDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBarButtonItem;

@end

@implementation LCSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    /// 初始化导航栏的按钮.
//    [self initNavigationItem];
}

/// 初始化导航栏的按钮.
- (void)initNavigationItem {
    /// 使用资源原图片.
    UIImage *menuImage = [[UIImage imageNamed:@"NavigationBackBG"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.backBarButtonItem setImage:menuImage];
}

/// 退出登录.
- (void)quitAccount {
    /// 聊天服务器下线.
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [del goOffline];
    [del disconnect];
    
    LCUserInfo *userInfo = [[LCUserInfo alloc] init];
    [[LCDataManager sharedInstance] setUserInfo:userInfo];
    [[LCDataManager sharedInstance] saveData];
    
    [[LCChatManager sharedInstance] clearChatUserDefault];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:NotificationShouldRefreshPlanListFromServer object:nil];
    [[LCSharedFuncUtil getAppContentVC] showHomePage];
    [[LCSharedFuncUtil getAppContentVC] showLoginPage];
    //    [self.navigationController popToRootViewControllerAnimated:NO];
}

/// 跳转到下载页面.
- (void)goToDownloadPage {
    NSString *urlStr = [NSString stringWithFormat:APP_DOWNLOAD_URL];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
}

#pragma mark - Actions
/// 清除缓存.
- (IBAction)cleanCacheAction:(id)sender {
    [[EGOCache currentCache] clearCache];
    [self showHint:@"成功清除缓存！"];
}

/// 检查版本更新.
- (IBAction)versionUpdateAction:(id)sender {
    LCSettingApi *api = [[LCSettingApi alloc] initWithDelegate:self];
    [api getServerAppVersion:APP_NAME];
}

/// 给达客旅行打分.
- (IBAction)scoreAppAction:(id)sender {
    [self goToDownloadPage];
}

/// 退出登录.
- (IBAction)quitLoginAction:(id)sender {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"退出账号" message:@"确定退出当前账号？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert show];
}

/// 跳转推送通知页面.
- (IBAction)pushAction:(id)sender {
    LCSettingPushVC *controller = (LCSettingPushVC *)[LCStoryboardManager viewControllerWithFileName:SBNameSetting identifier:VCIDSettingPushVC];
    [self.navigationController pushViewController:controller animated:APP_ANIMATION];
}

/// 后退.
- (IBAction)backButtonItemAction:(id)sender {
    [self.navigationController popViewControllerAnimated:APP_ANIMATION];
}

/// 意见反馈.
- (IBAction)suggestionAction:(id)sender {
    LCCommonApi *api = [[LCCommonApi alloc] initWithDelegate:self];
    [api getSystemUserInfo];
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self quitAccount];
            break;
        case 1:
            break;
    }
}

#pragma mark - LCCommonApi Delegate
- (void)commonApi:(LCCommonApi *)api didGetSystemUserInfo:(LCUserInfo *)userInfo withError:(NSError *)error {
    if (!error) {
        ChatViewController *controller = [[ChatViewController alloc] initWithUser:userInfo];
        [self.navigationController pushViewController:controller animated:APP_ANIMATION];
    } else {
        [self showHint:@"系统客服人员不在线，请稍后重试！"];
    }
}

#pragma mark - LCSettingApi Delegate
- (void)settingApi:(LCSettingApi *)userApi didGetAppVersion:(NSString *)appVersion withError:(NSError *)error {
    if (!error) {
        if ([appVersion isEqualToString:APP_LOCAL_VERSION]) {
            [YSAlertUtil alertOneMessage:@"您已经安装世界上最先进的达客旅行！"];
        } else {
            [self goToDownloadPage];
        }
    } else {
        [self showHint:@"获取最新版本失败！"];
    }
}

@end
