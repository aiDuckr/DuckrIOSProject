//
//  LCPlanBillModel.h
//  LinkCity
//
//  Created by godhangyu on 16/6/15.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCBaseModel.h"

typedef NS_ENUM(NSInteger, LCPlanBillType) {
    LCPlanBillTypeWithdrawMoney = 0,
    LCPlanBillTypePlan = 1,
};

@interface LCPlanBillModel : LCBaseModel

@property (nonatomic, strong) LCPlanModel *planInfo;

@property (nonatomic, assign) LCPlanBillType planBillType;

@property (nonatomic, assign) NSInteger memberNum;

@property (nonatomic, strong) NSDecimalNumber *moneySum;

@property (nonatomic, strong) NSString *updatedTime;

@end
