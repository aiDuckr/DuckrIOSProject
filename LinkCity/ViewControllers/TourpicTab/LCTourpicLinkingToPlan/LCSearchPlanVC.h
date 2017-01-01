//
//  LCSearchPlanVC.h
//  LinkCity
//
//  Created by 张宗硕 on 5/9/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCSearchPlanVCDelegate <NSObject>
- (void)didChoosePlanWithPlan:(LCPlanModel *)plan;

@end

@interface LCSearchPlanVC : LCAutoRefreshVC
@property (strong, nonatomic) LCPlanModel *selectedPlan;
@property (strong, nonatomic) id<LCSearchPlanVCDelegate> delegate;
@end
