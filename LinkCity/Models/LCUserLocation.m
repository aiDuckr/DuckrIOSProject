//
//  LCUserLocation.m
//  LinkCity
//
//  Created by roy on 11/23/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCUserLocation.h"

@implementation LCUserLocation

- (BOOL)isUserLocationValid{
    NSTimeInterval timeInterval = [self.updateTime timeIntervalSinceNow];
    timeInterval = 0 - timeInterval;
    if (timeInterval < UserLocationValidTimeInterval &&
        self.type != LocationTypeError) {
        // 有效位置
        return YES;
    }else{
        // 无效位置
        return NO;
    }
}


- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super initWithDictionary:dic];
    if (self)
    {
        self.cityID = [LCStringUtil getNotNullStr:[dic objectForKey:@"CityID"]];
        self.cityName = [LCStringUtil getNotNullStr:[dic objectForKey:@"CityName"]];
        self.areaName = [LCStringUtil getNotNullStr:[dic objectForKey:@"AreaName"]];
    }
    return self;
}



- (void)encodeWithCoder: (NSCoder *)coder
{
    [coder encodeDouble:self.lat forKey:@"Lat"];
    [coder encodeDouble:self.lng forKey:@"Lng"];
    [coder encodeInteger:self.type forKey:@"Type"];
    [coder encodeObject:self.cityID forKey:@"CityID"];
    [coder encodeObject:self.cityName forKey:@"CityName"];
    [coder encodeObject:self.provinceName forKey:@"ProvinceName"];
    [coder encodeObject:self.updateTime forKey:@"UpdateTime"];
    [coder encodeObject:self.areaName forKey:NSStringFromSelector(@selector(areaName))];
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        self.lat = [coder decodeDoubleForKey:@"Lat"];
        self.lng = [coder decodeDoubleForKey:@"Lng"];
        self.type = [coder decodeIntegerForKey:@"Type"];
        self.cityID = [coder decodeObjectForKey:@"CityID"];
        self.cityName = [coder decodeObjectForKey:@"CityName"];
        self.provinceName = [coder decodeObjectForKey:@"ProvinceName"];
        self.updateTime = [coder decodeObjectForKey:@"UpdateTime"];
        self.areaName = [coder decodeObjectForKey:NSStringFromSelector(@selector(areaName))];
    }
    return self;
}
@end
