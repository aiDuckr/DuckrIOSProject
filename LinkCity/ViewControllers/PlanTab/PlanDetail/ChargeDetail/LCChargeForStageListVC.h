//
//  LCChargeDetailVC.h
//  LinkCity
//
//  Created by Roy on 6/25/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCAutoRefreshVC.h"
#import "LCPlanModel.h"

@interface LCChargeForStageListVC : LCAutoRefreshVC
@property (nonatomic, strong) LCPlanModel *plan;
@property (nonatomic, strong) NSArray *stageArray;
@property (nonatomic, strong) NSDecimalNumber *totalStageIncome;
@end
