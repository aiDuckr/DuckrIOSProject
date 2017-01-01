//
//  LCWeatherDay.m
//  LinkCity
//
//  Created by 张宗硕 on 12/17/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCWeatherDay.h"

@implementation LCWeatherDay
- (id)initWithDictionary:(NSDictionary *)dic {
    self = [super initWithDictionary:dic];
    if (self) {
        self.date = [LCStringUtil getNotNullStr:[dic objectForKey:@"Date"]];
        self.dayName = [LCStringUtil getNotNullStr:[dic objectForKey:@"DayName"]];
        self.dayId = [LCStringUtil getNotNullStr:[dic objectForKey:@"DayId"]];
        self.nightName = [LCStringUtil getNotNullStr:[dic objectForKey:@"NightName"]];
        self.nightId = [LCStringUtil getNotNullStr:[dic objectForKey:@"NightId"]];
        self.temperature = [LCStringUtil getNotNullStr:[dic objectForKey:@"T"]];
        self.dWindLevel = [LCStringUtil getNotNullStr:[dic objectForKey:@"DWindLevel"]];
        self.nWindLevel = [LCStringUtil getNotNullStr:[dic objectForKey:@"NWindLevel"]];
    }
    return self;
}

- (void)encodeWithCoder: (NSCoder *)coder {
    [coder encodeObject:self.date forKey:@"Date"];
    [coder encodeObject:self.dayName forKey:@"DayName"];
    [coder encodeObject:self.dayId forKey:@"DayId"];
    [coder encodeObject:self.nightName forKey:@"NightName"];
    [coder encodeObject:self.nightId forKey:@"NightId"];
    [coder encodeObject:self.temperature forKey:@"T"];
    [coder encodeObject:self.dWindLevel forKey:@"DWindLevel"];
    [coder encodeObject:self.nWindLevel forKey:@"NWindLevel"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.date = [coder decodeObjectForKey:@"Date"];
        self.dayName = [coder decodeObjectForKey:@"DayName"];
        self.dayId = [coder decodeObjectForKey:@"DayId"];
        self.nightName = [coder decodeObjectForKey:@"NightName"];
        self.nightId = [coder decodeObjectForKey:@"NightId"];
        self.temperature = [coder decodeObjectForKey:@"T"];
        self.dWindLevel = [coder decodeObjectForKey:@"DWindLevel"];
        self.nWindLevel = [coder decodeObjectForKey:@"NWindLevel"];
    }
    return self;
}

@end
