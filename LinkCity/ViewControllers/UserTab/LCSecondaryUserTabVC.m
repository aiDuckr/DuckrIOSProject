//
//  LCSecondaryUserTabVC.m
//  LinkCity
//
//  Created by lhr on 16/5/24.
//  Copyright © 2016年 linkcity. All rights reserved.
//
#import "LCUserInfoVC.h"
#import "LCUserServiceVC.h"
#import "LCRegisterAndLoginHelper.h"
#import "LCAgreementVC.h"
#import "LCUserIdentifyVC.h"
#import "LCUserIdentityHelper.h"
#import "LCPlanTableVC.h"
#import "LCSettingVC.h"
#import "LCTourpicAlbumVC.h"
#import "LCNotifyTableVC.h"
#import "LCUserTableVC.h"
#import "LCUserPlanHelperVC.h"
#import "LCUserOrderListVC.h"
#import "LCMerchantOrderListVC.h"
#import "LCEditUserInfoVC.h"
#import "LinkCity-Swift.h"
#import "LCPickAndUploadImageView.h"
#import "LCSecondaryUserTabVC.h"

@interface LCSecondaryUserTabVC ()

@end

@implementation LCSecondaryUserTabVC

#pragma mark - init

+ (UINavigationController *)createNavInstance {
    return [[UINavigationController alloc] initWithRootViewController:[LCSecondaryUserTabVC createInstance]];
}

+ (instancetype)createInstance {
    return (LCSecondaryUserTabVC *)[LCStoryboardManager viewControllerWithFileName:SBNameUserTab identifier:VCIDSecondaryUserTabVC];
}

- (void)commonInit {
    [super commonInit];
    self.isHaveTabBar = YES;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
