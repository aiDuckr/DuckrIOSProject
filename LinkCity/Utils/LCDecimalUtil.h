//
//  LCDecimalUtil.h
//  LinkCity
//
//  Created by Roy on 6/28/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCDecimalUtil : NSObject


+ (NSDecimalNumberHandler *)getTwoDigitDecimalHandler;
+ (NSDecimalNumberHandler *)getFourDigitDecimalHandler;

+ (BOOL)isOverZero:(NSDecimalNumber *)num;
+ (BOOL)isNotNANDecimalNumber:(NSDecimalNumber *)num;

+ (NSString *)currencyStrFromDecimal:(NSDecimalNumber *)num;

+ (NSDecimalNumber *)getTwoDigitRoundDecimal:(NSDecimalNumber *)num;

@end
