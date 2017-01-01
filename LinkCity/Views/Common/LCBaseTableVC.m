//
//  LCBaseTableVC.m
//  LinkCity
//
//  Created by roy on 12/2/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCBaseTableVC.h"

@interface LCBaseTableVC ()
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation LCBaseTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _haveLayoutSubViews = NO;
    _isFirstTimeViewWillAppear = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _isFirstTimeViewWillAppear = YES;
    NSString *currentControllerName = NSStringFromClass([self class]);
    [MobClick beginLogPageView:currentControllerName];
}

- (void)viewDidLayoutSubviews{
    _haveLayoutSubViews = YES;
    [super viewDidLayoutSubviews];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSString *currentControllerName = NSStringFromClass([self class]);
    [MobClick endLogPageView:currentControllerName];
}

- (void)showHud{
    if (self.hud) {
        [self.hud hide:NO];
    }
    self.hud = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:self.hud];
    [self.view bringSubviewToFront:self.hud];
    [self.hud show:YES];
}
- (void)hideHud{
    [self.hud hide:YES];
}
@end
