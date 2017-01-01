//
//  LCReceptionDetailVC.h
//  LinkCity
//
//  Created by roy on 11/12/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCReceptionPlan.h"
#import "LCPlanDetailVC.h"

@interface LCReceptionDetailVC : LCPlanDetailVC
@property (nonatomic, strong) LCReceptionPlan *receptionPlan;
@end
