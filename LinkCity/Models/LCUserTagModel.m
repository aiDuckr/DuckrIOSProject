//
//  LCUserTagModel.m
//  LinkCity
//
//  Created by roy on 3/4/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCUserTagModel.h"

@implementation LCUserTagModel
- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super initWithDictionary:dic];
    if (self)
    {
        NSNumber *tagIdNum = [dic objectForKey:@"TagId"];
        self.tagId = [tagIdNum integerValue];
        self.tagName = [LCStringUtil getNotNullStr:[dic objectForKey:@"TagName"]];
        NSNumber *typeNum = [dic objectForKey:@"Type"];
        self.type = [typeNum integerValue];
        
    }
    return self;
}

- (void)encodeWithCoder: (NSCoder *)coder
{
    [coder encodeInteger:self.tagId forKey:@"TagId"];
    [coder encodeObject:self.tagName forKey:@"TagName"];
    [coder encodeInteger:self.type forKey:@"Type"];
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        self.tagId = [coder decodeIntegerForKey:@"TagId"];
        self.tagName = [coder decodeObjectForKey:@"TagName"];
        self.type = [coder decodeIntegerForKey:@"Type"];
    }
    return self;
}
@end
