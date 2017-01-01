//
//  LCBankcard.m
//  LinkCity
//
//  Created by 张宗硕 on 6/16/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCBankcard.h"

@implementation LCBankcard

- (id)initWithDictionary:(NSDictionary *)dic {
    self = [super initWithDictionary:dic];
    if (self) {
        self.belongedBank = [LCStringUtil getNotNullStr:[dic objectForKey:@"BelongedBank"]];
        self.bankcardNumber = [LCStringUtil getNotNullStr:[dic objectForKey:@"BankcardNumber"]];
        self.userName = [LCStringUtil getNotNullStr:[dic objectForKey:@"UserName"]];
    }
    return self;
}

- (void)encodeWithCoder: (NSCoder *)coder {
    [coder encodeObject:self.belongedBank forKey:@"BelongedBank"];
    [coder encodeObject:self.bankcardNumber forKey:@"BankcardNumber"];
    [coder encodeObject:self.userName forKey:@"UserName"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.belongedBank = [coder decodeObjectForKey:@"BelongedBank"];
        self.bankcardNumber = [coder decodeObjectForKey:@"BankcardNumber"];
        self.userName = [coder decodeObjectForKey:@"UserName"];
    }
    return self;
}

@end
