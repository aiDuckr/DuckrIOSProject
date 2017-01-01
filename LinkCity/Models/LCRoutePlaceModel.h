//
//  LCRoutePlaceModel.h
//  LinkCity
//
//  Created by roy on 2/11/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCBaseModel.h"

@interface LCRoutePlaceModel : LCBaseModel
@property (nonatomic, assign) NSInteger routePlaceId;

@property (nonatomic, retain) NSString *placeName;
@property (nonatomic, strong) NSString *dayPlaces;
@property (nonatomic, strong) NSString *dayDescription;

@property (nonatomic, retain) NSString *descriptionStr;
@property (nonatomic, retain) NSString *placeAddress;

@property (nonatomic, assign) NSInteger routeDay;   // start from 1

@property (nonatomic, retain) NSString *createdTime;
@property (nonatomic, assign) NSInteger placeLocLat;
@property (nonatomic, assign) NSInteger placeLocLng;

@property (nonatomic, retain) NSString *placeCoverUrl;
@property (nonatomic, retain) NSString *placeCoverThumbUrl;

- (NSMutableDictionary *)getDicForNetRequest;
+ (instancetype)createInstanceForEdit;
@end
