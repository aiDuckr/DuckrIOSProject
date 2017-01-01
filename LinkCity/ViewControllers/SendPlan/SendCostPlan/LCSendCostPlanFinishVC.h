//
//  LCSendCostPlanFinishVC.h
//  LinkCity
//
//  Created by Roy on 12/16/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCSendPlanBaseVC.h"

@interface LCSendCostPlanFinishVC : LCAutoRefreshVC
@property (nonatomic, strong) LCPlanModel *curPlan;
@property (nonatomic, assign) BOOL isSendingPlan;
@end
