//
//  LCPlanCategoryModel.m
//  LinkCity
//
//  Created by roy on 3/9/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCHomeCategoryModel.h"

@implementation LCHomeCategoryModel

- (void)setCategoryType:(LCHomeCategoryType)categoryType{
    self.type = (NSInteger)categoryType;
}
- (LCHomeCategoryType)categoryType{
    return self.type;
}

- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super initWithDictionary:dic];
    if (self)
    {
        self.title = [LCStringUtil getNotNullStr:[dic objectForKey:@"Title"]];
        self.coverUrl = [LCStringUtil getNotNullStr:[dic objectForKey:@"CoverUrl"]];
        self.coverThumbUrl = [LCStringUtil getNotNullStr:[dic objectForKey:@"CoverThumbUrl"]];
        NSNumber *typeNum = [dic objectForKey:@"Type"];
        self.type = [typeNum integerValue];
        self.content = [LCStringUtil getNotNullStr:[dic objectForKey:@"Content"]];
        self.descInfo = [LCStringUtil getNotNullStr:[dic objectForKey:@"DescInfo"]];
    }
    return self;
}

- (void)encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:self.title forKey:@"Title"];
    [coder encodeObject:self.coverUrl forKey:@"CoverUrl"];
    [coder encodeObject:self.coverThumbUrl forKey:@"CoverThumbUrl"];
    [coder encodeInteger:self.type forKey:@"Type"];
    [coder encodeObject:self.content forKey:@"Content"];
    [coder encodeObject:self.content forKey:@"DescInfo"];
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        self.title = [coder decodeObjectForKey:@"Title"];
        self.coverUrl = [coder decodeObjectForKey:@"CoverUrl"];
        self.coverThumbUrl = [coder decodeObjectForKey:@"CoverThumbUrl"];
        self.type = [coder decodeIntegerForKey:@"Type"];
        self.content = [coder decodeObjectForKey:@"Content"];
        self.content = [coder decodeObjectForKey:@"DescInfo"];
    }
    return self;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"LCHomeCategoryModel {\r\n \ttitle:%@\r\n\tcoverUrl:%@\r\n\ttype:%ld\r\n\tcontent:%@\r\n}",self.title,self.coverUrl,(long)self.type,self.content];
}
@end
