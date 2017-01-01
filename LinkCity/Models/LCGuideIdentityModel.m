//
//  LCGuideIdentityModel.m
//  LinkCity
//
//  Created by roy on 5/9/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCGuideIdentityModel.h"

@implementation LCGuideIdentityModel

- (LCIdentityStatus)getIdentityStatus{
    return self.status;
}

#pragma mark
- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super initWithDictionary:dic];
    if (self)
    {
        self.clubPhotoUrl = [LCStringUtil getNotNullStr:[dic objectForKey:@"ClubPhotoUrl"]];
        self.clubPhotoThumbUrl = [LCStringUtil getNotNullStr:[dic objectForKey:@"ClubPhotoThumbUrl"]];
        self.note = [LCStringUtil getNotNullStr:[dic objectForKey:@"Note"]];
        self.status = [LCStringUtil idToNSInteger:[dic objectForKey:@"Status"]];
        self.reason = [LCStringUtil getNotNullStr:[dic objectForKey:@"Reason"]];
        self.createdTime = [LCStringUtil getNotNullStr:[dic objectForKey:@"CreatedTime"]];
        self.updatedTime = [LCStringUtil getNotNullStr:[dic objectForKey:@"UpdatedTime"]];
    }
    return self;
}

- (void)encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:self.clubPhotoUrl forKey:@"ClubPhotoUrl"];
    [coder encodeObject:self.clubPhotoThumbUrl forKey:@"ClubPhotoThumbUrl"];
    [coder encodeObject:self.note forKey:@"Note"];
    [coder encodeInteger:self.status forKey:@"Status"];
    [coder encodeObject:self.reason forKey:@"Reason"];
    [coder encodeObject:self.createdTime forKey:@"CreatedTime"];
    [coder encodeObject:self.updatedTime forKey:@"UpdatedTime"];
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        self.clubPhotoUrl = [coder decodeObjectForKey:@"ClubPhotoUrl"];
        self.clubPhotoThumbUrl = [coder decodeObjectForKey:@"ClubPhotoThumbUrl"];
        self.note = [coder decodeObjectForKey:@"Note"];
        self.status = [coder decodeIntegerForKey:@"Status"];
        self.reason = [coder decodeObjectForKey:@"Reason"];
        self.createdTime = [coder decodeObjectForKey:@"CreatedTime"];
        self.updatedTime = [coder decodeObjectForKey:@"UpdatedTime"];
    }
    return self;
}
@end
