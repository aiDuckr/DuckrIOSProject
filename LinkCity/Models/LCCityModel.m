//
//  LCCityModel.m
//  LinkCity
//
//  Created by 张宗硕 on 5/23/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCCityModel.h"

@implementation LCCityModel
- (id)initWithDictionary:(NSDictionary *)dic {
    self = [super initWithDictionary:dic];
    if (self) {
        self.cityId = [LCStringUtil getNotNullStr:[dic objectForKey:@"CityId"]];
        self.cityName = [LCStringUtil getNotNullStr:[dic objectForKey:@"CityName"]];
        self.cityShortName = [LCStringUtil getNotNullStr:[dic objectForKey:@"CityShortName"]];
        self.cityImage = [LCStringUtil getNotNullStr:[dic objectForKey:@"CityImage"]];
        self.cityThumbImage = [LCStringUtil getNotNullStr:[dic objectForKey:@"CityThumbImage"]];
        self.isOpened = [LCStringUtil idToNSInteger:[dic objectForKey:@"IsOpened"]];
    }
    return self;
}

- (void)encodeWithCoder: (NSCoder *)coder {
    [coder encodeObject:self.cityId forKey:@"CityId"];
    [coder encodeObject:self.cityName forKey:@"CityName"];
    [coder encodeObject:self.cityShortName forKey:@"CityShortName"];
    [coder encodeObject:self.cityImage forKey:@"CityImage"];
    [coder encodeObject:self.cityThumbImage forKey:@"CityThumbImage"];
    [coder encodeInteger:self.isOpened forKey:NSStringFromSelector(@selector(isOpened))];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.cityId = [coder decodeObjectForKey:@"CityId"];
        self.cityName = [coder decodeObjectForKey:@"CityName"];
        self.cityShortName = [coder decodeObjectForKey:@"CityShortName"];
        self.cityImage = [coder decodeObjectForKey:@"CityImage"];
        self.cityThumbImage = [coder decodeObjectForKey:@"CityThumbImage"];
        self.isOpened = [coder decodeIntegerForKey:NSStringFromSelector(@selector(isOpened))];
    }
    return self;
}

@end
