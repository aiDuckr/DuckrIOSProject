//
//  LCSettingVC.m
//  LinkCity
//
//  Created by roy on 3/24/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCSettingVC.h"
#import "LCSetNotificationVC.h"
#import "LCAboutDuckrVC.h"
#import "AFNetWorking.h"
#import "UIImageView+AFNetWorking.h"

@interface LCSettingVC ()
@property (weak, nonatomic) IBOutlet UIButton *quitButton;


@property (weak, nonatomic) IBOutlet UIView *setInvitedUserCell;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cleanCacheCellTop;
@property (weak, nonatomic) IBOutlet UISwitch *invitedFriendSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *wifiAutoPlayVideoSwitch;

@end

@implementation LCSettingVC

+ (instancetype)createInstance{
    return (LCSettingVC *)[LCStoryboardManager viewControllerWithFileName:SBNameSetting identifier:VCIDSettingVC];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"设置";
    self.quitButton.layer.cornerRadius = 3.0f;
    [self.invitedFriendSwitch setOn:[[LCDataManager sharedInstance] appInitData].showSelfToContact];
    self.wifiAutoPlayVideoSwitch.on = [[LCDataManager sharedInstance] appInitData].notifWifiVedioAutoPlay;
   //[[LCUIConstants sharedInstance] setButtonAsSubmitButtonEnableStyle:self.quitButton];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
    [self updateShow];
}

- (IBAction)invitedFriendAction:(UISwitch *)sender {
    [[LCDataManager sharedInstance] appInitData].showSelfToContact = sender.isOn;
    [LCNetRequester setShowSelfToContact:sender.isOn callBack:^(NSString *message, NSError *error){
        if (error != nil) {
            [[LCDataManager sharedInstance] appInitData].showSelfToContact = !sender.isOn;
        } else {
            [YSAlertUtil tipOneMessage:error.domain];
        }
    }];

}


- (IBAction)autoPlayVideoAction:(UISwitch *)sender {
    [[LCDataManager sharedInstance] appInitData].notifWifiVedioAutoPlay = sender.isOn;
    [LCNetRequester setWifiVedioAutoPlay:sender.isOn callBack:^(NSString *message, NSError *error) {
        if (error != nil) {
            [[LCDataManager sharedInstance] appInitData].notifWifiVedioAutoPlay = !sender.isOn;
        } else {
            [YSAlertUtil tipOneMessage:error.domain];
        }
        [self updateShow];
    }];
}


- (void)updateShow {
    if ([LCDataManager sharedInstance].haveSetInviteUserTelephone) {
        self.setInvitedUserCell.hidden = YES;
        self.cleanCacheCellTop.constant = 56;
    }else{
        self.setInvitedUserCell.hidden = NO;
        self.cleanCacheCellTop.constant = 100;
    }
    if (YES == [[LCDataManager sharedInstance] appInitData].notifWifiVedioAutoPlay) {
        [self.wifiAutoPlayVideoSwitch setOn:YES animated:APP_ANIMATION];
    } else {
        [self.wifiAutoPlayVideoSwitch setOn:NO animated:APP_ANIMATION];
    }
    
    if (YES == [[LCDataManager sharedInstance] appInitData].showSelfToContact) {
        [self.invitedFriendSwitch setOn:YES animated:APP_ANIMATION];
    } else {
        [self.invitedFriendSwitch setOn:NO animated:APP_ANIMATION];
    }
    //CGFloat countOfcache = [[NSURLCache sharedURLCache] diskCapacity] / 1024.0 /1024.0;
}


- (IBAction)notificationButton:(id)sender {
    LCSetNotificationVC *notificationVC = [LCSetNotificationVC createInstance];
    [self.navigationController pushViewController:notificationVC animated:YES];
}

- (IBAction)pointIntro:(id)sender {
    [LCViewSwitcher pushWebVCtoShowURL:server_url([LCConstants serverHost], LCPointIntroURL) withTitle:@"积分说明" on:self.navigationController];
}

//- (IBAction)inviteUserButton:(id)sender {
//    LCSetInviteUserVC *inviteUserVC = [LCSetInviteUserVC createInstance];
//    [self.navigationController pushViewController:inviteUserVC animated:YES];
//}
- (IBAction)cleanCacheButton:(id)sender {
    //删除聊天数据库信息
    [LCXMPPUtil deleteAllChatContact];
    [LCXMPPUtil deleteAllChatMsg];
    
    NSURLCache *urlCache = [NSURLCache sharedURLCache];
    [urlCache removeAllCachedResponses];
    //AFImageCache *cache = (AFImageCache *)[UIImageView sharedImageCache];
    
    [YSAlertUtil tipOneMessage:@"清除缓存成功!" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
}
- (IBAction)updateButton:(id)sender {
     NSString *appVersion = [LCDataManager sharedInstance].appInitData.versionInfo.version;
    if ([appVersion isEqualToString:APP_LOCAL_SHOT_VERSION_STRING]) {
        [YSAlertUtil alertOneMessage:@"您已经安装世界上最先进的达客旅行！"];
    } else {
        [LCSharedFuncUtil gotoAppDownloadPage];
    }
}
- (IBAction)aboutDuckrButton:(id)sender {
    LCAboutDuckrVC *aboutDuckrVC = [LCAboutDuckrVC createInstance];
    [self.navigationController pushViewController:aboutDuckrVC animated:YES];
}
- (IBAction)evaluateAppButton:(id)sender {
    [LCSharedFuncUtil gotoAppDownloadPage];
}
- (IBAction)feedBackButton:(id)sender {
    [YSAlertUtil showHudWithHint:nil];
    [LCNetRequester getSystemUserInfoWithCallback:^(LCUserModel *systemUser, NSError *error) {
        [YSAlertUtil hideHud];
        
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
        }else{
            [LCViewSwitcher pushToShowChatWithUserVC:systemUser on:self.navigationController];
        }
    }];
}
- (IBAction)recommendAppButton:(id)sender {
    [LCViewSwitcher pushWebVCtoShowURL:server_url([LCConstants serverHost], LCAppRecommendURL) withTitle:@"应用推荐" on:self.navigationController];
}

- (IBAction)quitButton:(id)sender {
    [LCSharedFuncUtil quitLoginApp];
    
    //跳出页面
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    [[LCSharedFuncUtil getAppDelegate].tabBarVC setSelectedIndex:0];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUserJustLogout object:nil];
}
@end
