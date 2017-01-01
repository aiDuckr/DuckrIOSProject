//
//  LCTourpicChoosePlanVC.h
//  LinkCity
//
//  Created by lhr on 16/5/6.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCAutoRefreshVC.h"

@protocol LCTourpicChoosePlanVCDelegate <NSObject>

- (void)didChoosePlanWithPlan:(LCPlanModel *)model;

@end

@interface LCTourpicChoosePlanVC : LCAutoRefreshVC

@property (weak, nonatomic) id<LCTourpicChoosePlanVCDelegate> delegate;

@property (nonatomic,strong) LCPlanModel *selectedPlan;
@end
