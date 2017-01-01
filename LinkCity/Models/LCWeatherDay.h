//
//  LCWeatherDay.h
//  LinkCity
//
//  Created by 张宗硕 on 12/17/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCBaseModel.h"

@interface LCWeatherDay : LCBaseModel<NSCoding>
@property (retain, nonatomic) NSString *date;
@property (retain, nonatomic) NSString *dayName;
@property (retain, nonatomic) NSString *dayId;
@property (retain, nonatomic) NSString *nightName;
@property (retain, nonatomic) NSString *nightId;
@property (retain, nonatomic) NSString *temperature;
@property (retain, nonatomic) NSString *dWindLevel;
@property (retain, nonatomic) NSString *nWindLevel;
@end
