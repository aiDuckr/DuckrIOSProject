//
//  LCUserRouteModel.m
//  LinkCity
//
//  Created by roy on 3/6/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCUserRouteModel.h"


//@property (nonatomic, strong) NSString *dayDescription;
NSString *const dayPlacesKey = @"DayPlaces";
NSString *const dayDescriptionKey = @"DayDescription";

@implementation LCUserRouteModel

+ (instancetype)createInstanceForEdit{
    LCUserRouteModel *userRoute = [[LCUserRouteModel alloc] init];
    userRoute.userRouteId = -1;
    userRoute.routePlaces = [[NSMutableArray alloc] init];
    return userRoute;
}

- (NSString *)getRoutePlaceStringForDay:(NSInteger)routeDay withSeparator:(NSString *)sep{
    NSString *routePlaceStr = @"";
    BOOL isFirstPlaceOfDay = YES;
    for (LCRoutePlaceModel *placeModel in self.routePlaces){
        if (placeModel.routeDay == routeDay) {
            if (isFirstPlaceOfDay) {
                isFirstPlaceOfDay = NO;
                routePlaceStr = [routePlaceStr stringByAppendingString:placeModel.placeName];
            }else{
                routePlaceStr = [routePlaceStr stringByAppendingFormat:@"%@%@",sep,placeModel.placeName];
            }
        }
    }
    return routePlaceStr;
}
- (NSInteger)getRoutePlaceNumForDay:(NSInteger)routeDay{
    NSInteger placeNum = 0;
    
    for (LCRoutePlaceModel *place in self.routePlaces){
        if (place.routeDay == routeDay) {
            placeNum++;
        }
    }
    
    return placeNum;
}
- (NSInteger)getRouteDayNum{
    NSInteger dayNum = 0;
    
    LCRoutePlaceModel *aPlace = [self.routePlaces lastObject];
    if (aPlace) {
        dayNum = aPlace.routeDay;
    }
    
    return dayNum;
}

- (NSMutableDictionary *)getDicForNetRequest{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    if (self.userRouteId > 0) {
        [paramDic setObject:[NSString stringWithFormat:@"%ld",(long)self.userRouteId] forKey:@"UserRouteId"];
    }
    if ([LCStringUtil isNotNullString:self.routeTitle]) {
        [paramDic setObject:self.routeTitle forKey:@"RouteTitle"];
    }
    if ([LCStringUtil isNotNullString:self.routeCost]) {
        [paramDic setObject:self.routeCost forKey:@"RouteCost"];
    }
    
    NSMutableArray *routePlaceDicArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (LCRoutePlaceModel *placeModel in self.routePlaces){
        [routePlaceDicArray addObject: [placeModel getDicForNetRequest]];
    }
    NSString *routePlaceStr = [LCStringUtil getJsonStrFromArray:routePlaceDicArray];
    if ([LCStringUtil isNotNullString:routePlaceStr]) {
        [paramDic setObject:routePlaceStr forKey:@"RoutePlaces"];
    }
    
    if ([LCStringUtil isNotNullString:self.dayPlaces]) {
        [paramDic setObject:self.dayPlaces forKey:dayPlacesKey];
    }
    if ([LCStringUtil isNotNullString:self.dayDescription]) {
        [paramDic setObject:self.dayDescription forKey:dayDescriptionKey];
    }
    return paramDic;
}


#pragma mark Init & Encode & Decode
- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super initWithDictionary:dic];
    if (self)
    {
        NSNumber *userRouteIdNum = [dic objectForKey:@"UserRouteId"];
        self.userRouteId = [userRouteIdNum integerValue];
        self.routeTitle = [LCStringUtil getNotNullStr:[dic objectForKey:@"RouteTitle"]];
        self.routeCost = [LCStringUtil getNotNullStr:[dic objectForKey:@"RouteCost"]];
        
        NSMutableArray *routePlacesArray = [[NSMutableArray alloc]initWithCapacity:0];
        for (NSDictionary *routePlaceDic in [dic arrayForKey:@"RoutePlaces"]){
            LCRoutePlaceModel *routePlaceModel = [[LCRoutePlaceModel alloc] initWithDictionary:routePlaceDic];
            [routePlacesArray addObject:routePlaceModel];
        }
        self.routePlaces = routePlacesArray;
        self.dayPlaces = [dic objectForKey:dayPlacesKey];
        self.dayDescription = [dic objectForKey:dayDescriptionKey];
    }
    return self;
}


- (void)encodeWithCoder: (NSCoder *)coder
{
    [coder encodeInteger:self.userRouteId forKey:@"UserRouteId"];
    [coder encodeObject:self.routeTitle forKey:@"RouteTitle"];
    [coder encodeObject:self.routeCost forKey:@"RouteCost"];
    [coder encodeObject:self.routePlaces forKey:@"RoutePlaces"];
    [coder encodeObject:self.dayDescription forKey:dayDescriptionKey];
    [coder encodeObject:self.dayPlaces forKey:dayPlacesKey];
}


- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        self.userRouteId = [coder decodeIntegerForKey:@"UserRouteId"];
        self.routeTitle = [coder decodeObjectForKey:@"RouteTitle"];
        self.routeCost = [coder decodeObjectForKey:@"RouteCost"];
        self.routePlaces = [coder decodeObjectForKey:@"RoutePlaces"];
        self.dayPlaces = [coder decodeObjectForKey:dayPlacesKey];
        self.dayDescription = [coder decodeObjectForKey:dayDescriptionKey];
    }
    return self;
}
@end
