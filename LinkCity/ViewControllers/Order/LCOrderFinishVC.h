//
//  LCOrderFinishVC.h
//  LinkCity
//
//  Created by Roy on 12/23/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCAutoRefreshVC.h"

@interface LCOrderFinishVC : LCAutoRefreshVC

@property (nonatomic, strong) LCPlanModel *plan;
@property (retain, nonatomic) LCPartnerOrderModel *planOrder;


@end
