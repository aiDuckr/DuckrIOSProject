//
//  LCRouteInfo.h
//  LinkCity
//
//  Created by roy on 11/14/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCStringUtil.h"
#import "LCBaseModel.h"

@interface LCRouteInfo : LCBaseModel
- (id)initWithDictionary:(NSDictionary *)dic;
- (void)encodeWithCoder:(NSCoder *)coder;
- (id)initWithCoder:(NSCoder *)coder;

@property (nonatomic, retain) NSString *createdTime;
@property (nonatomic, retain) NSString *descriptionStr;
@property (nonatomic, retain) NSString *image;
@property (nonatomic, retain) NSString *imageThumb;
@property (nonatomic, retain) NSString *placeId;
@property (nonatomic, retain) NSString *placeLocLat;
@property (nonatomic, retain) NSString *placeLocLng;
@property (nonatomic, retain) NSString *placeName;
@property (nonatomic, retain) NSString *receptionPlanId;
@property (nonatomic, retain) NSString *routeId;
@end