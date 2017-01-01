//
//  LCAuthCode.m
//  LinkCity
//
//  Created by roy on 11/10/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCAuthCode.h"
#import "LCStringUtil.h"

@implementation LCAuthCode
- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super initWithDictionary:dic];
    if (self)
    {
        self.authCode = [LCStringUtil getNotNullStr:[dic objectForKey:@"AuthCode"]];
        NSNumber *expireTimeNum = [dic objectForKey:@"ExpireTime"];
        self.expireTime = [expireTimeNum integerValue];
    }
    return self;
}

- (void)encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:self.authCode forKey:@"AuthCode"];
    [coder encodeInteger:self.expireTime forKey:@"ExpireTime"];
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        self.authCode = [coder decodeObjectForKey:@"AuthCode"];
        self.expireTime = [coder decodeIntegerForKey:@"ExpireTime"];
    }
    return self;
}

- (NSInteger)getIntegerAuthcode{
    return [LCStringUtil idToNSInteger:self.authCode];
}
@end
