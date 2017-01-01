//
//  LCUserLocation.h
//  LinkCity
//
//  Created by roy on 11/23/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCBaseModel.h"

typedef enum : NSUInteger {
    LocationTypeError = 0,
    LocationTypeBaidu = 1,
    LocationTypeGaode = 2,
    LocationTypeGoogle = 3,
} LocationType;

@interface LCUserLocation : LCBaseModel
@property (nonatomic, assign) double lat;
@property (nonatomic, assign) double lng;
@property (nonatomic, assign) LocationType type;

@property (nonatomic, strong) NSString *cityID;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *provinceName;
@property (nonatomic, strong) NSDate *updateTime;

@property (nonatomic, strong) NSString *areaName;   // 只用于本地定位后的记录； 与server的交互中不需要

- (BOOL)isUserLocationValid;
@end
