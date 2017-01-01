//
//  LCUserIdentityModel.m
//  LinkCity
//
//  Created by roy on 3/12/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCUserIdentityModel.h"

@implementation LCUserIdentityModel
+ (instancetype)createEmptyInstance{
    LCUserIdentityModel *instance = [[LCUserIdentityModel alloc] init];
    instance.status = LCIdentityStatus_None;
    return instance;
}
- (LCIdentityStatus)getUserIdentityStatus{
    return self.status;
}

- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super initWithDictionary:dic];
    if (self)
    {
        self.name = [LCStringUtil getNotNullStr:[dic objectForKey:@"Name"]];
        self.idNumber = [LCStringUtil getNotNullStr:[dic objectForKey:@"IdNumber"]];
        self.idCardUrl = [LCStringUtil getNotNullStr:[dic objectForKey:@"IdCardUrl"]];
        self.idCardThumbUrl = [LCStringUtil getNotNullStr:[dic objectForKey:@"IdCardThumbUrl"]];
        NSNumber *statusNum = [dic objectForKey:@"Status"];
        self.status = [statusNum integerValue];
        self.reason = [LCStringUtil getNotNullStr:[dic objectForKey:@"Reason"]];
        
    }
    return self;
}

- (void)encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:self.name forKey:@"Name"];
    [coder encodeObject:self.idNumber forKey:@"IdNumber"];
    [coder encodeObject:self.idCardUrl forKey:@"IdCardUrl"];
    [coder encodeObject:self.idCardThumbUrl forKey:@"IdCardThumbUrl"];
    [coder encodeInteger:self.status forKey:@"Status"];
    [coder encodeObject:self.reason forKey:@"Reason"];
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        self.name = [coder decodeObjectForKey:@"Name"];
        self.idNumber = [coder decodeObjectForKey:@"IdNumber"];
        self.idCardUrl = [coder decodeObjectForKey:@"IdCardUrl"];
        self.idCardThumbUrl = [coder decodeObjectForKey:@"IdCardThumbUrl"];
        self.status = [coder decodeIntegerForKey:@"Status"];
        self.reason = [coder decodeObjectForKey:@"Reason"];
    }
    return self;
}

@end
