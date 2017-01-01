//
//  LCBaseCollectionController.m
//  LinkCity
//
//  Created by roy on 12/2/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCBaseCollectionVC.h"

@interface LCBaseCollectionVC ()
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation LCBaseCollectionVC

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
