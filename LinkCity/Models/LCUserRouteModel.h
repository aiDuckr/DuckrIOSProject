//
//  LCUserRouteModel.h
//  LinkCity
//
//  Created by roy on 3/6/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCBaseModel.h"
#import "LCRoutePlaceModel.h"

@interface LCUserRouteModel : LCBaseModel
@property (nonatomic, assign) NSInteger userRouteId;

@property (nonatomic, retain) NSString *routeTitle;
@property (nonatomic, retain) NSString *routeCost;
@property (nonatomic, retain) NSArray *routePlaces; //array of LCRoutePlace
@property (nonatomic, strong) NSString *dayPlaces;
@property (nonatomic, strong) NSString *dayDescription;

+ (instancetype)createInstanceForEdit;
- (NSMutableDictionary *)getDicForNetRequest;

- (NSInteger)getRouteDayNum;
- (NSInteger)getRoutePlaceNumForDay:(NSInteger)routeDay;
- (NSString *)getRoutePlaceStringForDay:(NSInteger)routeDay withSeparator:(NSString *)sep;
@end
