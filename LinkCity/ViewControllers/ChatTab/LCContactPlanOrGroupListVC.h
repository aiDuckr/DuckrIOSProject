//
//  LCContactPlanListVC.h
//  LinkCity
//
//  Created by roy on 3/16/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCBaseVC.h"

typedef enum : NSUInteger {
    LCContactPlanOrGroupListVC_Plan,
    LCContactPlanOrGroupListVC_Group,
} LCContactPlanOrGroupListVCShowingType;

@interface LCContactPlanOrGroupListVC : LCAutoRefreshVC
@property (nonatomic, assign) LCContactPlanOrGroupListVCShowingType showingType;


@end
