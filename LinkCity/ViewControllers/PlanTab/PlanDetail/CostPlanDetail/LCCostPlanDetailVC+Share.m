//
//  LCCostPlanDetailVC+Share.m
//  LinkCity
//
//  Created by Roy on 12/22/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCCostPlanDetailVC.h"

@implementation LCCostPlanDetailVC (Share)
- (void)sharePlan:(LCPlanModel *)plan{
    if (!self.shareView) {
        self.shareView = [LCShareView createInstance];
        [self.shareView setShareToDuckrHiden:NO];
        self.shareView.delegate = self;
    }
    [LCShareView showShareView:self.shareView onViewController:self forPlan:plan];
}

#pragma mark - LCShareViewDelegate
- (void)cancelShareAction
{
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){}];
}
- (void)shareWeixinAction:(LCPlanModel *)plan
{
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){
        [LCShareUtil shareWeixinAction:plan presentedController:self];
    }];
}

- (void)shareWeixinTimeLineAction:(LCPlanModel *)plan
{
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){
        [LCShareUtil shareWeixinTimeLineAction:plan presentedController:self];
    }];
}

- (void)shareWeiboAction:(LCPlanModel *)plan
{
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){
        [LCShareUtil shareWeiboAction:plan presentedController:self];
    }];
}

- (void)shareQQAction:(LCPlanModel *)plan
{
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){
        [LCShareUtil shareQQAction:plan presentedController:self];
    }];
}

- (void)shareDuckrAction:(LCPlanModel *)plan
{
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){
        [LCShareUtil shareDuckrAction:plan presentedController:self];
    }];
}

@end