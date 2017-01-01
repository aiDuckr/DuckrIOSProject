//
//  LCRouteThemeModel.m
//  LinkCity
//
//  Created by roy on 2/11/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCRouteThemeModel.h"

@implementation LCRouteThemeModel
- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super initWithDictionary:dic];
    if (self)
    {
        self.coverUrl = [LCStringUtil getNotNullStr:[dic objectForKey:@"CoverUrl"]];
        self.coverThumbUrl = [LCStringUtil getNotNullStr:[dic objectForKey:@"CoverThumbUrl"]];
        self.title = [LCStringUtil getNotNullStr:[dic objectForKey:@"Title"]];
        self.themeDesc = [LCStringUtil getNotNullStr:[dic objectForKey:@"ThemeDesc"]];
        NSNumber *tourThemeIdNum = [dic objectForKey:@"TourThemeId"];
        self.tourThemeId = [tourThemeIdNum integerValue];
        NSMutableArray *themeList = [[NSMutableArray alloc] init];
//        for (NSDictionary *themeDic in [dic arrayForKey:@"ChildThemes"]) {
//            LCRouteThemeModel *themeInfo = [[LCRouteThemeModel alloc] initWithDictionary:themeDic];
//            if (themeInfo) {
//                [themeList addObject:themeInfo];
//            }
//        }
        self.childThemeArr = themeList;

        self.iconUrl = [LCStringUtil getNotNullStr:[dic objectForKey:@"IconUrl"]];
    }
    return self;
}


- (void)encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:self.coverUrl forKey:@"CoverUrl"];
    [coder encodeObject:self.coverThumbUrl forKey:@"CoverThumbUrl"];
    [coder encodeObject:self.title forKey:@"Title"];
    [coder encodeObject:self.themeDesc forKey:@"ThemeDesc"];
    [coder encodeInteger:self.tourThemeId forKey:@"TourThemeId"];
    [coder encodeObject:self.childThemeArr forKey:@"ChildThemeArr"];
    //fix issue by lhr 原来是转成bool，对照接口逻辑，修正成对象
    [coder encodeObject:self.iconUrl forKey:@"IconUrl"];
}


- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        self.coverUrl = [coder decodeObjectForKey:@"CoverUrl"];
        self.coverThumbUrl = [coder decodeObjectForKey:@"CoverThumbUrl"];
        self.title = [coder decodeObjectForKey:@"Title"];
        self.themeDesc = [coder decodeObjectForKey:@"ThemeDesc"];
        self.tourThemeId = [coder decodeIntegerForKey:@"TourThemeId"];
        self.childThemeArr = [coder decodeObjectForKey:@"ChildThemeArr"];
        self.iconUrl = [coder decodeObjectForKey:@"IconUrl"];
    }
    return self;
}

@end
