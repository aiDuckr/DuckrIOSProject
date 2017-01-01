//
//  LCWebPlanModel.m
//  LinkCity
//
//  Created by roy on 6/1/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCWebPlanModel.h"

@implementation LCWebPlanModel


- (NSString *)getDestinationsStringWithSeparator:(NSString *)sep{
    __block NSString *destinationStr = @"";
    [self.placeNames enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx !=0) {
            destinationStr = [destinationStr stringByAppendingString:sep];
        }
        destinationStr = [destinationStr stringByAppendingString:(NSString *)obj];
    }];
    
    return destinationStr;
}

- (NSString *)getDepartAndDestString {
    NSString *departAndDestStr = @"";
    if ([LCStringUtil isNotNullString:self.departName]) {
        departAndDestStr = [departAndDestStr stringByAppendingFormat:@"%@",self.departName];
    }
    for(int i = 0; i < self.placeNames.count; i++) {
        NSString *destName = self.placeNames[i];
        if ([LCStringUtil isNotNullString:departAndDestStr]) {
            departAndDestStr = [departAndDestStr stringByAppendingFormat:@" - %@", destName];
        }else{
            departAndDestStr = [departAndDestStr stringByAppendingString:destName];
        }
    }
    
    return departAndDestStr;
}

- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super initWithDictionary:dic];
    if (self)
    {
        self.coverUrl = [LCStringUtil getNotNullStr:[dic objectForKey:@"CoverUrl"]];
        self.source = [LCStringUtil getNotNullStr:[dic objectForKey:@"Source"]];
        self.startTime = [LCStringUtil getNotNullStr:[dic objectForKey:@"StartTime"]];
        self.title = [LCStringUtil getNotNullStr:[dic objectForKey:@"Title"]];
        self.content = [LCStringUtil getNotNullStr:[dic objectForKey:@"Content"]];
        self.planUrl = [LCStringUtil getNotNullStr:[dic objectForKey:@"PlanUrl"]];
        self.departName = [LCStringUtil getNotNullStr:[dic objectForKey:@"DepartName"]];
        self.placeNames = [dic arrayForKey:@"PlaceNames"];
        self.nick = [LCStringUtil getNotNullStr:[dic objectForKey:@"Nick"]];
        self.qq = [LCStringUtil getNotNullStr:[dic objectForKey:@"QQ"]];
        self.wechat = [LCStringUtil getNotNullStr:[dic objectForKey:@"Wechat"]];
        self.telephone = [LCStringUtil getNotNullStr:[dic objectForKey:@"Telephone"]];
    }
    return self;
}

- (void)encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:self.coverUrl forKey:@"CoverUrl"];
    [coder encodeObject:self.source forKey:@"Source"];
    [coder encodeObject:self.startTime forKey:@"StartTime"];
    [coder encodeObject:self.title forKey:@"Title"];
    [coder encodeObject:self.content forKey:@"Content"];
    [coder encodeObject:self.planUrl forKey:@"PlanUrl"];
    [coder encodeObject:self.departName forKey:@"DepartName"];
    [coder encodeObject:self.placeNames forKey:@"PlaceNames"];
    [coder encodeObject:self.nick forKey:@"Nick"];
    [coder encodeObject:self.qq forKey:@"QQ"];
    [coder encodeObject:self.wechat forKey:@"Wechat"];
    [coder encodeObject:self.telephone forKey:@"Telephone"];
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        self.coverUrl = [coder decodeObjectForKey:@"CoverUrl"];
        self.source = [coder decodeObjectForKey:@"Source"];
        self.startTime = [coder decodeObjectForKey:@"StartTime"];
        self.title = [coder decodeObjectForKey:@"Title"];
        self.content = [coder decodeObjectForKey:@"Content"];
        self.planUrl = [coder decodeObjectForKey:@"PlanUrl"];
        self.departName = [coder decodeObjectForKey:@"DepartName"];
        self.placeNames = [coder decodeObjectForKey:@"PlaceNames"];
        self.nick = [coder decodeObjectForKey:@"Nick"];
        self.qq = [coder decodeObjectForKey:@"QQ"];
        self.wechat = [coder decodeObjectForKey:@"Wechat"];
        self.telephone = [coder decodeObjectForKey:@"Telephone"];
        
    }
    return self;
}
@end
