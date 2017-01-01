//
//  LCPlanTabVC.h
//  LinkCity
//
//  Created by 张宗硕 on 5/13/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCAutoRefreshVC.h"

typedef enum : NSUInteger {
    LCPlanTabVCTab_Rcmd = 0,
    LCPlanTabVCTab_Invite = 1,
//    LCPlanTabVCTab_Plan = 2,
//    LCPlanTabVCTab_Duckr = 3,
} LCPlanTabVCTab;

typedef enum : NSUInteger {
    LCPlanTabPlanFilterDateType_Default,
    LCPlanTabPlanFilterDateType_Tomorrow,
    LCPlanTabPlanFilterDateType_Weeks,
    LCPlanTabPlanFilterDateType_Mounth,
    LCPlanTabPlanFilterDateType_Calendar,
} LCPlanTabPlanFilterDateType;

@interface LCPlanTabVC : LCAutoRefreshVC
+ (UINavigationController *)createNavInstance;
- (void)sendPlan;
@end
