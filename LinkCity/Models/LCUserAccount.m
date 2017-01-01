//
//  LCUserAccount.m
//  LinkCity
//
//  Created by 张宗硕 on 6/16/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCUserAccount.h"
#import "LCBankcard.h"

@implementation LCUserAccount

- (id)initWithDictionary:(NSDictionary *)dic {
    self = [super initWithDictionary:dic];
    if (self) {
        id totalBalanceStr = [dic objectForKey:@"TotalBalance"];
        self.totalBalance = [LCDecimalUtil getTwoDigitRoundDecimal:[NSDecimalNumber decimalNumberWithDecimal:[totalBalanceStr decimalValue]]];
        
        id availBalanceStr = [dic objectForKey:@"AvailBalance"];
        self.availBalance = [LCDecimalUtil getTwoDigitRoundDecimal:[NSDecimalNumber decimalNumberWithDecimal:[availBalanceStr decimalValue]]];
        
        id uncollectedStr = [dic objectForKey:@"Uncollected"];
        self.uncollected = [LCDecimalUtil getTwoDigitRoundDecimal:[NSDecimalNumber decimalNumberWithDecimal:[uncollectedStr decimalValue]]];
        
        NSMutableArray *bankcardMutArr = [[NSMutableArray alloc] init];
        NSDictionary *bankcardsDic = [dic objectForKey:@"Bankcards"];
        for (NSDictionary *bankcardDic in bankcardsDic) {
            LCBankcard *bankcard = [[LCBankcard alloc] initWithDictionary:bankcardDic];
            [bankcardMutArr addObject:bankcard];
        }
        self.bankcardArr = bankcardMutArr;
    }
    return self;
}

- (void)encodeWithCoder: (NSCoder *)coder {
    [coder encodeObject:self.totalBalance forKey:@"TotalBalance"];
    [coder encodeObject:self.availBalance forKey:@"AvailBalance"];
    [coder encodeObject:self.uncollected forKey:@"Uncollected"];
    [coder encodeObject:self.bankcardArr forKey:@"BankcardArr"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.totalBalance = [coder decodeObjectForKey:@"TotalBalance"];
        self.availBalance = [coder decodeObjectForKey:@"AvailBalance"];
        self.uncollected = [coder decodeObjectForKey:@"Uncollected"];
        self.bankcardArr = [coder decodeObjectForKey:@"BankcardArr"];
    }
    return self;
}

@end
