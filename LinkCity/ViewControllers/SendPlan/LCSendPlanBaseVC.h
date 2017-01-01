//
//  LCSendPlanBaseVC.h
//  LinkCity
//
//  Created by roy on 3/26/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCAutoRefreshVC.h"
#import "LCPlanModel.h"


#define DestinationSeparator @" "
@interface LCSendPlanBaseVC : LCAutoRefreshVC
@property (nonatomic, assign) BOOL isSendingPlan;   // YES:发新计划    NO:编辑现有计划
@property (nonatomic, strong) LCPlanModel *curPlan; //当前正在操作的Plan

- (void)cancelSendPlan;

//should override
- (void)mergeUIDataIntoModel;
@end
