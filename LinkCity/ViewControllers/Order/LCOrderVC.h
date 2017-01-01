//
//  LCOrderVC.h
//  LinkCity
//
//  Created by Roy on 12/23/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCAutoRefreshVC.h"

@interface LCOrderVC : LCAutoRefreshVC
@property (nonatomic, strong) LCPlanModel *plan;
@property (nonatomic, strong) LCPartnerStageModel *stage;
@property (nonatomic, strong) NSString *recmdUuid;


- (void)updateShowWithPlan:(LCPlanModel *)plan selectedStage:(LCPartnerStageModel *)stage recmdUuid:(NSString *)recmdUuid;
@end
