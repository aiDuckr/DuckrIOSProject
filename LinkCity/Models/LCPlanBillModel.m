//
//  LCPlanBillModel.m
//  LinkCity
//
//  Created by godhangyu on 16/6/15.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCPlanBillModel.h"

static NSString *const planKey = @"Plan";
static NSString *const typeKey = @"Type";
static NSString *const memberNumKey = @"MemberNum";
static NSString *const moneySumKey = @"MoneySum";
static NSString *const updatedTimeKey = @"UpdatedTime";

@implementation LCPlanBillModel

- (id)initWithDictionary:(NSDictionary *)dic {
    self = [super initWithDictionary:dic];
    
    if (self) {
        self.planInfo = [[LCPlanModel alloc] initWithDictionary:[dic objectForKey:planKey]];
        self.planBillType = [[dic objectForKey:typeKey] integerValue];
        self.memberNum = [[dic objectForKey:memberNumKey] integerValue];
        self.moneySum = [NSDecimalNumber decimalNumberWithDecimal:[[dic objectForKey:moneySumKey] decimalValue]];
        self.updatedTime = [LCStringUtil getNotNullStr:[dic objectForKey:updatedTimeKey]];
    }
    
    return self;
}

@end
