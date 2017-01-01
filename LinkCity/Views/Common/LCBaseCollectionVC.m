//
//  LCBaseCollectionController.m
//  LinkCity
//
//  Created by roy on 12/2/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCBaseCollectionVC.h"

@interface LCBaseCollectionVC ()

@end

@implementation LCBaseCollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *currentControllerName = NSStringFromClass([self class]);
    [MobClick beginLogPageView:currentControllerName];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSString *currentControllerName = NSStringFromClass([self class]);
    [MobClick endLogPageView:currentControllerName];
}

@end
