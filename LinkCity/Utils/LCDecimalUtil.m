//
//  LCDecimalUtil.m
//  LinkCity
//
//  Created by Roy on 6/28/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCDecimalUtil.h"

@implementation LCDecimalUtil



+ (NSDecimalNumberHandler *)getTwoDigitDecimalHandler{
    static NSDecimalNumberHandler *handler;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                                                         scale:2
                                                              raiseOnExactness:NO
                                                               raiseOnOverflow:NO
                                                              raiseOnUnderflow:NO
                                                           raiseOnDivideByZero:NO];
    });
    
    return handler;
}
+ (NSDecimalNumberHandler *)getFourDigitDecimalHandler{
    static NSDecimalNumberHandler *handler;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                                                         scale:4
                                                              raiseOnExactness:NO
                                                               raiseOnOverflow:NO
                                                              raiseOnUnderflow:NO
                                                           raiseOnDivideByZero:NO];
    });
    
    return handler;
}

+ (BOOL)isOverZero:(NSDecimalNumber *)num{
    
    if (num &&
        num != [NSDecimalNumber notANumber] &&
        [num compare:[NSDecimalNumber zero]] == NSOrderedDescending) {
        
        return YES;
    }
    
    return NO;
}

+ (BOOL)isNotNANDecimalNumber:(NSDecimalNumber *)num{
    if (!num || [num compare:[NSDecimalNumber notANumber]] == NSOrderedSame) {
        return NO;
    }else{
        return YES;
    }
}

+ (NSString *)currencyStrFromDecimal:(NSDecimalNumber *)num{
    NSNumberFormatter *_currencyFormatter = [[NSNumberFormatter alloc] init];
    _currencyFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    //Roy 2015.7.5
    //不设置CurrencyCode的话，会以$开头； 设置CNY的话会用花体CNY开头；  设置￥则无前缀，自己补上一个￥就好了
    [_currencyFormatter setCurrencyCode:@"￥"];
    return [_currencyFormatter stringFromNumber:num];
}

+ (NSDecimalNumber *)getTwoDigitRoundDecimal:(NSDecimalNumber *)num{
    return [num decimalNumberByRoundingAccordingToBehavior:[self getTwoDigitDecimalHandler]];
}

@end
