//
//  LCOrderRuleModel.m
//  LinkCity
//
//  Created by Roy on 6/28/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCOrderRuleModel.h"

@implementation LCOrderRuleModel

#pragma mark Set & Get

- (NSDecimalNumber *)scoreCashMax{
    if (![LCDecimalUtil isOverZero:_scoreCashMax]) {
        _scoreCashMax = [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithInteger:999999] decimalValue]];
    }
    
    return _scoreCashMax;
}

- (NSDecimalNumber *)scoreRatio{
    if (![LCDecimalUtil isOverZero:_scoreRatio]) {
        _scoreRatio = [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithDouble:0.01] decimalValue]];
    }
    
    return _scoreRatio;
}



#pragma mark

- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super initWithDictionary:dic];
    if (self)
    {
        self.earnestRatio = [NSDecimalNumber decimalNumberWithDecimal:[[dic objectForKey:@"EarnestRatio"] decimalValue]];
        self.scoreRatio = [NSDecimalNumber decimalNumberWithDecimal:[[dic objectForKey:@"ScoreRatio"] decimalValue]];
        self.scoreCashMax = [NSDecimalNumber decimalNumberWithDecimal:[[dic objectForKey:@"ScoreCashMax"] decimalValue]];
        
        self.incomeDescription = [LCStringUtil getNotNullStr:[dic objectForKey:@"IncomeDescription"]];
        self.refundDescription = [LCStringUtil getNotNullStr:[dic objectForKey:@"RefundDescription"]];
        
        NSMutableArray *earnestRadioList = [[NSMutableArray alloc] init];
        for (id anRadioID in [dic arrayForKey:@"EarnestRatioList"]){
            NSDecimalNumber *anRadio = [NSDecimalNumber decimalNumberWithDecimal:[anRadioID decimalValue]];
            if (anRadio) {
                [earnestRadioList addObject:anRadio];
            }
        }
        self.earnestRadioList = earnestRadioList;
        
        self.marginValue = [NSDecimalNumber decimalNumberWithDecimal:[[dic objectForKey:@"MarginValue"] decimalValue]];
    }
    return self;
}

- (void)encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:self.earnestRatio forKey:@"EarnestRatio"];
    [coder encodeObject:self.scoreRatio forKey:@"ScoreRatio"];
    [coder encodeObject:self.scoreCashMax forKey:@"ScoreCashMax"];
    
    [coder encodeObject:self.incomeDescription forKey:@"IncomeDescription"];
    [coder encodeObject:self.refundDescription forKey:@"RefundDescription"];
    
    [coder encodeObject:self.earnestRadioList forKey:@"EarnestRatioList"];
    
    [coder encodeObject:self.marginValue forKey:@"MarginValue"];
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        self.earnestRatio = [coder decodeObjectForKey:@"EarnestRatio"];
        self.scoreRatio = [coder decodeObjectForKey:@"ScoreRatio"];
        self.scoreCashMax = [coder decodeObjectForKey:@"ScoreCashMax"];
        
        self.incomeDescription = [coder decodeObjectForKey:@"IncomeDescription"];
        self.refundDescription = [coder decodeObjectForKey:@"RefundDescription"];
        
        self.earnestRadioList = [coder decodeObjectForKey:@"EarnestRatioList"];
        
        self.marginValue = [coder decodeObjectForKey:@"MarginValue"];
    }
    return self;
}
@end





