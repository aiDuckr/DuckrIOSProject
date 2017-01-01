//
//  LCPlanMemeberVC.h
//  LinkCity
//
//  Created by roy on 3/16/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCBaseVC.h"
#import "LCPlanModel.h"

@interface LCPlanMemeberVC : LCAutoRefreshVC
@property (nonatomic, strong) LCPlanModel *plan;
@property (nonatomic, strong) NSArray *stageArray;
@end
