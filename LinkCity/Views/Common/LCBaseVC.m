//
//  LCBaseVC.m
//  LinkCity
//
//  Created by zzs on 14/11/29.
//  Copyright (c) 2014年 linkcity. All rights reserved.
//

#import "LCBaseVC.h"
#import "MBProgressHUD.h"

@interface LCBaseVC ()
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation LCBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _haveLayoutSubViews = NO;
    _isFirstTimeViewWillAppear = NO;
    _statisticByMob = YES;
    _isAppearing = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _isFirstTimeViewWillAppear = YES;
    _isAppearing = YES;
    NSString *currentControllerName = NSStringFromClass([self class]);
    
    if (self.statisticByMob) {
        [MobClick beginLogPageView:currentControllerName];
    }
}

- (void)viewDidLayoutSubviews{
    _haveLayoutSubViews = YES;
    [super viewDidLayoutSubviews];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    _isAppearing = NO;
    
    NSString *currentControllerName = NSStringFromClass([self class]);
    if (self.statisticByMob) {
        [MobClick endLogPageView:currentControllerName];
    }
}

@end
