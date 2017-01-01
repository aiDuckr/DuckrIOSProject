//
//  LCProvinceModel.m
//  LinkCity
//
//  Created by 张宗硕 on 5/20/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCProvinceModel.h"

@implementation LCProvinceModel

- (id)initWithDictionary:(NSDictionary *)dic {
    self = [super initWithDictionary:dic];
    if (self) {
        self.provinceID = [LCStringUtil getNotNullStr:[dic objectForKey:@"ProvinceID"]];
        self.provniceName = [LCStringUtil getNotNullStr:[dic objectForKey:@"ProvinceName"]];
        self.city = [[LCCityModel alloc] initWithDictionary:[dic objectForKey:@"CityInfo"]];
    }
    return self;
}

- (void)encodeWithCoder: (NSCoder *)coder {
    [coder encodeObject:self.provinceID forKey:@"ProvinceID"];
    [coder encodeObject:self.provniceName forKey:@"ProvinceName"];
    [coder encodeObject:self.city forKey:@"CityInfo"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.provinceID = [coder decodeObjectForKey:@"Date"];
        self.provniceName = [coder decodeObjectForKey:@"ProvinceName"];
        self.city = [coder decodeObjectForKey:@"CityInfo"];
    }
    return self;
}


@end
