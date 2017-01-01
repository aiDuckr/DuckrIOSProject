//
//  LCRecommendPlanVC.h
//  LinkCity
//
//  Created by roy on 6/1/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCAutoRefreshVC.h"
#import "LCPlanModel.h"

@interface LCRecommendPlanVC : LCAutoRefreshVC
@property (nonatomic, strong) LCPlanModel *plan;
@end
