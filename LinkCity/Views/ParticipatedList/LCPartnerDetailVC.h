//
//  LCPartnerDetailVC.h
//  LinkCity
//
//  Created by roy on 11/18/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCPartnerPlan.h"
#import "LCPlanDetailVC.h"

@interface LCPartnerDetailVC : LCPlanDetailVC
@property (nonatomic, strong) LCPartnerPlan *partnerPlan;

@end
