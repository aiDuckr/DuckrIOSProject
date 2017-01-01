//
//  LCPartnerOrderModel.m
//  LinkCity
//
//  Created by Roy on 6/27/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCPartnerOrderModel.h"

@implementation LCPartnerOrderModel


- (NSDecimalNumber *)getTotalEarnest{
    NSNumber *payNum = [NSNumber numberWithInteger:self.orderNumber];
    NSDecimalNumber *payNumDecimal = [NSDecimalNumber decimalNumberWithDecimal:[payNum decimalValue]];
    NSDecimalNumber *totalEarnest = [NSDecimalNumber zero];
    if ([LCDecimalUtil isOverZero:payNumDecimal] &&
        [LCDecimalUtil isOverZero:self.orderEarnest]) {
        totalEarnest = [payNumDecimal decimalNumberByMultiplyingBy:self.orderEarnest withBehavior:[LCDecimalUtil getTwoDigitDecimalHandler]];
    }

    return totalEarnest;
}

- (NSDecimalNumber *)getTotalPrice{
    NSNumber *payNum = [NSNumber numberWithInteger:self.orderNumber];
    NSDecimalNumber *payNumDecimal = [NSDecimalNumber decimalNumberWithDecimal:[payNum decimalValue]];
    NSDecimalNumber *totalPrice = [NSDecimalNumber zero];
    if ([LCDecimalUtil isOverZero:payNumDecimal] &&
        [LCDecimalUtil isOverZero:self.orderPrice]) {
        totalPrice = [payNumDecimal decimalNumberByMultiplyingBy:self.orderPrice withBehavior:[LCDecimalUtil getTwoDigitDecimalHandler]];
    }
    
    return totalPrice;
}



- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super initWithDictionary:dic];
    if (self)
    {
        self.guid = [LCStringUtil getNotNullStr:[dic objectForKey:@"Guid"]];
        
        self.orderNumber = [[dic objectForKey:@"OrderNumber"] integerValue];
        self.orderPrice = [NSDecimalNumber decimalNumberWithDecimal:[[dic objectForKey:@"OrderPrice"] decimalValue]];
        self.orderPrice = [LCDecimalUtil getTwoDigitRoundDecimal:self.orderPrice];
        self.orderEarnest = [NSDecimalNumber decimalNumberWithDecimal:[[dic objectForKey:@"OrderEarnest"] decimalValue]];
        self.orderEarnest = [LCDecimalUtil getTwoDigitRoundDecimal:self.orderEarnest];
        self.orderScore = [[dic objectForKey:@"OrderScore"] integerValue];
        self.orderScoreCash = [NSDecimalNumber decimalNumberWithDecimal:[[dic objectForKey:@"OrderScoreCash"] decimalValue]];
        self.orderScoreCash = [LCDecimalUtil getTwoDigitRoundDecimal:self.orderScoreCash];
        self.orderPay = [NSDecimalNumber decimalNumberWithDecimal:[[dic objectForKey:@"OrderPay"] decimalValue]];
        
        id orderPayStr = [dic objectForKey:@"OrderPay"];
//        self.orderPay = [[NSDecimalNumber alloc] initWithFloat:0.0];
//        if ([LCStringUtil isNotNullString:orderPayStr]) {
//            self.orderPay = [NSDecimalNumber decimalNumberWithDecimal:[orderPayStr decimalValue]];
//        }
//        self.orderPay = [LCDecimalUtil getTwoDigitRoundDecimal:self.orderPay];
        self.orderPay = [LCDecimalUtil getTwoDigitRoundDecimal:[NSDecimalNumber decimalNumberWithDecimal:[orderPayStr decimalValue]]];
        
        self.orderCode = [LCStringUtil getNotNullStr:[dic objectForKey:@"OrderCode"]];
        
        self.orderPayment = [[dic objectForKey:@"OrderPayment"] integerValue];
        self.orderRefund = [[dic objectForKey:@"OrderRefund"] integerValue];
        self.orderClear = [[dic objectForKey:@"OrderClear"] integerValue];
        self.orderCheck = [LCStringUtil idToNSInteger:[dic objectForKey:@"OrderCheck"]];
        self.orderRefundReason = [LCStringUtil getNotNullStr:[dic objectForKey:@"OrderRefundReason"]];
        
        NSMutableArray *orderContactNameArray = [NSMutableArray new];
        NSMutableArray *orderContactPhoneArray = [NSMutableArray new];
        NSMutableArray *orderContactIdentityArray = [NSMutableArray new];
        NSArray *orderContactDicArray = [dic arrayForKey:@"OrderContact"];
        for (NSDictionary *dic in orderContactDicArray){
            NSString *name = [dic objectForKey:@"Name"];
            NSString *phone = [dic objectForKey:@"Telephone"];
            NSString *identity = [dic objectForKey:@"Identity"];
            if ([LCStringUtil isNotNullString:name]) {
                [orderContactNameArray addObject:name];
                if ([LCStringUtil isNullString:phone]) {
                    phone = @"未填写";
                }
                [orderContactPhoneArray addObject:phone];
                if ([LCStringUtil isNullString:identity]) {
                    identity = @"未填写";
                }
                [orderContactIdentityArray addObject:identity];
            }
        }
        self.orderContactNameArray = orderContactNameArray;
        self.orderContactPhoneArray = orderContactPhoneArray;
        self.orderContactIdentityArray = orderContactIdentityArray;
        
        self.refundTime = [LCStringUtil getNotNullStr:[dic objectForKey:@"RefundTime"]];
        self.createdTime = [LCStringUtil getNotNullStr:[dic objectForKey:@"CreatedTime"]];
        self.updatedTime = [LCStringUtil getNotNullStr:[dic objectForKey:@"UpdatedTime"]];
    }
    return self;
}

- (void)encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:self.guid forKey:@"Guid"];
    
    [coder encodeInteger:self.orderNumber forKey:@"OrderNumber"];
    [coder encodeObject:self.orderPrice forKey:@"OrderPrice"];
    [coder encodeObject:self.orderEarnest forKey:@"OrderEarnest"];
    [coder encodeInteger:self.orderScore forKey:@"OrderScore"];
    [coder encodeObject:self.orderScoreCash forKey:@"OrderScoreCash"];
    [coder encodeObject:self.orderPay forKey:@"OrderPay"];
    
    [coder encodeObject:self.orderCode forKey:@"OrderCode"];
    
    [coder encodeInteger:self.orderPayment forKey:@"OrderPayment"];
    [coder encodeInteger:self.orderRefund forKey:@"OrderRefund"];
    [coder encodeInteger:self.orderClear forKey:@"OrderClear"];
    [coder encodeInteger:self.orderCheck forKey:@"OrderCheck"];
    [coder encodeObject:self.orderRefundReason forKey:@"OrderRefundReason"];
    
    [coder encodeObject:self.orderContactNameArray forKey:NSStringFromSelector(@selector(orderContactNameArray))];
    [coder encodeObject:self.orderContactPhoneArray forKey:NSStringFromSelector(@selector(orderContactPhoneArray))];
    
    [coder encodeObject:self.refundTime forKey:@"RefundTime"];
    [coder encodeObject:self.createdTime forKey:@"CreatedTime"];
    [coder encodeObject:self.updatedTime forKey:@"UpdatedTime"];
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        self.guid = [coder decodeObjectForKey:@"Guid"];
        
        self.orderNumber = [coder decodeIntegerForKey:@"OrderNumber"];
        self.orderPrice = [coder decodeObjectForKey:@"OrderPrice"];
        self.orderEarnest = [coder decodeObjectForKey:@"OrderEarnest"];
        self.orderScore = [coder decodeIntegerForKey:@"OrderScore"];
        self.orderScoreCash = [coder decodeObjectForKey:@"OrderScoreCash"];
        self.orderPay = [coder decodeObjectForKey:@"OrderPay"];
        
        self.orderCode = [coder decodeObjectForKey:@"OrderCode"];
        
        self.orderPayment = [coder decodeIntegerForKey:@"OrderPayment"];
        self.orderRefund = [coder decodeIntegerForKey:@"OrderRefund"];
        self.orderClear = [coder decodeIntegerForKey:@"OrderClear"];
        self.orderCheck = [coder decodeIntegerForKey:@"OrderCheck"];
        self.orderRefundReason = [coder decodeObjectForKey:@"OrderRefundReason"];
        
        self.orderContactNameArray = [coder decodeObjectForKey:NSStringFromSelector(@selector(orderContactNameArray))];
        self.orderContactPhoneArray = [coder decodeObjectForKey:NSStringFromSelector(@selector(orderContactPhoneArray))];
        
        self.refundTime = [coder decodeObjectForKey:@"RefundTime"];
        self.createdTime = [coder decodeObjectForKey:@"CreatedTime"];
        self.updatedTime = [coder decodeObjectForKey:@"UpdatedTime"];
        
    }
    return self;
}

@end