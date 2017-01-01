//
//  LCSettingPushVC.m
//  LinkCity
//
//  Created by 张宗硕 on 11/24/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCSettingPushVC.h"
#import "LCConfig.h"

@interface LCSettingPushVC ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBarButtonItem;
@property (weak, nonatomic) IBOutlet UISwitch *notifyCommentSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *notifyLikeSwitch;

@end

@implementation LCSettingPushVC

- (void)viewDidLoad {
    [super viewDidLoad];
    /// 初始化导航栏按钮.
//    [self initNavigationItem];
    /// 初始化成员变量.
    [self initVariable];
}

/// 初始化导航栏按钮.
- (void)initNavigationItem {
    /// 使用资源原图片.
    UIImage *backImage = [[UIImage imageNamed:@"NavigationBackBG"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.backBarButtonItem setImage:backImage];
}

/// 初始化成员变量.
- (void)initVariable {
    LCConfig *config = [[LCDataManager sharedInstance] readConfig];
    self.notifyCommentSwitch.on = config.isNotifyComment;
    self.notifyLikeSwitch.on = config.isNotifyLike;
}

/// 更新推送收到评论通知的开关.
- (void)updateSettingNotifyLike {
    LCSettingApi *api = [[LCSettingApi alloc] initWithDelegate:self];
    BOOL isNotifyComment = [[LCDataManager sharedInstance] readConfig].isNotifyComment;
    BOOL isNotifyLike = ![[LCDataManager sharedInstance] readConfig].isNotifyLike;
    NSDictionary *dic = @{@"NotifComment":[NSString stringWithFormat:@"%d", isNotifyComment],
                          @"NotifLike":[NSString stringWithFormat:@"%d", isNotifyLike]};
    [api setNotifySwitch:dic];
}

/// 更新推送收到赞的通知开关.
- (void)updateSettingNotifyComment {
    LCSettingApi *api = [[LCSettingApi alloc] initWithDelegate:self];
    BOOL isNotifyComment = ![[LCDataManager sharedInstance] readConfig].isNotifyComment;
    BOOL isNotifyLike = [[LCDataManager sharedInstance] readConfig].isNotifyLike;
    NSDictionary *dic = @{@"NotifComment":[NSString stringWithFormat:@"%d", isNotifyComment],
                          @"NotifLike":[NSString stringWithFormat:@"%d", isNotifyLike]};
    [api setNotifySwitch:dic];
}

#pragma mark - Actions
- (IBAction)isNotifyLikeAction:(id)sender {
    [self updateSettingNotifyLike];
}

- (IBAction)isNotifyCommentAction:(id)sender {
    [self updateSettingNotifyComment];
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:APP_ANIMATION];
}

#pragma mark - LCSettingApi Delegate
- (void)settingApi:(LCSettingApi *)settingApi didSetNotify:(NSDictionary *)settingDic WithError:(NSError *)error {
    if (!error) {
        [self showHint:@"修改成功！"];
        LCConfig *config = [[LCConfig alloc] init];
        config.isNotifyComment = [[settingDic objectForKey:@"NotifComment"] boolValue];
        config.isNotifyLike = [[settingDic objectForKey:@"NotifLike"] boolValue];
        ZLog(@"didSetNotify the config is %d", config.isNotifyComment);
        [[LCDataManager sharedInstance] saveConfig:config];
        
        config = [[LCDataManager sharedInstance] readConfig];
    } else {
        [self showHint:@"修改失败！"];
    }
}

@end
