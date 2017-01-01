//
//  LCImageModel.m
//  LinkCity
//
//  Created by roy on 11/24/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCImageModel.h"

@implementation LCImageModel
- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super initWithDictionary:dic];
    if (self)
    {
        self.imageUrl = [LCStringUtil getNotNullStr:[dic objectForKey:@"ImageUrl"]];
        self.imageUrlThumb = [LCStringUtil getNotNullStr:[dic objectForKey:@"ImageUrlThumb"]];
        self.imageUrlMD5 = [LCStringUtil getNotNullStr:[dic objectForKey:@"ImageUrlMD5"]];
        self.createdTime = [LCStringUtil getNotNullStr:[dic objectForKey:@"CreatedTime"]];
        self.timestamp = [LCStringUtil getNotNullStr:[dic objectForKey:@"Timestamp"]];
    }
    return self;
}

- (void)encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:self.imageUrl forKey:@"ImageUrl"];
    [coder encodeObject:self.imageUrlThumb forKey:@"ImageUrlThumb"];
    [coder encodeObject:self.imageUrlMD5 forKey:@"ImageUrlMD5"];
    [coder encodeObject:self.createdTime forKey:@"CreatedTime"];
    [coder encodeObject:self.timestamp forKey:@"Timestamp"];
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        self.imageUrl = [coder decodeObjectForKey:@"ImageUrl"];
        self.imageUrlThumb = [coder decodeObjectForKey:@"ImageUrlThumb"];
        self.imageUrlMD5 = [coder decodeObjectForKey:@"ImageUrlMD5"];
        self.createdTime = [coder decodeObjectForKey:@"CreatedTime"];
        self.timestamp = [coder decodeObjectForKey:@"Timestamp"];
    }
    return self;
}

- (NSURL *)getImageNSURL{
    return [NSURL URLWithString:self.imageUrl];
}
- (NSURL *)getImageThumbNSURL{
    return [NSURL URLWithString:self.imageUrlThumb];
}
@end
