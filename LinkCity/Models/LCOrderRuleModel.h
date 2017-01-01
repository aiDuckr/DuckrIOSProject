//
//  LCOrderRuleModel.h
//  LinkCity
//
//  Created by Roy on 6/28/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCBaseModel.h"

@interface LCOrderRuleModel : LCBaseModel


@property (nonatomic, strong) NSDecimalNumber *earnestRatio; // 0.2  // 订金比例
@property (nonatomic, strong) NSDecimalNumber *scoreRatio;   // 0.01  // 积分兑换比例
@property (nonatomic, strong) NSDecimalNumber *scoreCashMax;    //100 // 积分兑现最大限额
@property (nonatomic, strong) NSString *incomeDescription; // "入账规则"
@property (nonatomic, strong) NSString *refundDescription;    // "退款规则"
@property (nonatomic, strong) NSArray *earnestRadioList;    //分段的订金比例
@property (nonatomic, strong) NSDecimalNumber *marginValue; //保证金金额
@end
