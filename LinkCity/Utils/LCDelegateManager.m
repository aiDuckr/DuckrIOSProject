//
//  LCDelegateManager.m
//  LinkCity
//
//  Created by lhr on 16/5/20.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCDelegateManager.h"

@implementation LCDelegateManager

+ (instancetype)sharedInstance {
    static LCDelegateManager *staticInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticInstance = [[LCDelegateManager alloc] init];
    });
    
    return staticInstance;
}

#pragma mark - LCFreePlanCell Delegate 

- (void)planLikeSelected:(LCFreePlanCell *)cell {
    if (![[LCDataManager sharedInstance] haveLogin]) {
        [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
        return ;
    }
    NSString * planGuid = cell.plan.planGuid;
    if (cell.plan.isFavored == 0) {
        cell.plan.isFavored = 1;
        cell.plan.favorNumber += 1;
        cell.likeImageView.image = [UIImage imageNamed:@"TourpiclikedIcon"];
    } else {
        cell.plan.isFavored = 0;
        cell.plan.favorNumber -= 1;
        cell.likeImageView.image = [UIImage imageNamed:@"TourpicUnlikeIcon"];
    }
    __weak typeof(self) weakSelf = self;
    [LCNetRequester favorPlan:planGuid withType:cell.plan.isFavored callBack:^(LCPlanModel *plan, NSError *error){
        if (error) {
            if (cell.plan.isFavored == 0) {
                cell.plan.isFavored = 1;
                cell.plan.favorNumber += 1;
            } else {
                cell.plan.isFavored = 0;
                cell.plan.favorNumber -= 1;
            }
            [YSAlertUtil tipOneMessage:error.domain];
            [weakSelf.delegate updateViewShow];
        }
        
    }];
    [self.delegate updateViewShow];
}

- (void)planCommentSelected:(LCFreePlanCell *)cell {
    if (![[LCDataManager sharedInstance] haveLogin]) {
        [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
        return ;
    }
    [LCViewSwitcher pushToShowPlanDetailVCForPlan:cell.plan recmdUuid:nil on:[LCSharedFuncUtil getTopMostNavigationController]];
}
@end
