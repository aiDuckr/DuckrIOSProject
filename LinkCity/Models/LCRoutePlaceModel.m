//
//  LCRoutePlaceModel.m
//  LinkCity
//
//  Created by roy on 2/11/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCRoutePlaceModel.h"

@implementation LCRoutePlaceModel

#pragma mark Public Interface
- (NSMutableDictionary *)getDicForNetRequest{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    //新建的地点，设置默认ID为-1，表示create place
    //只有ID>=0时才有效，表示update place
    if (self.routePlaceId>=0) {
        [dic setObject:[NSNumber numberWithInteger:self.routePlaceId] forKey:@"RoutePlaceId"];
    }
    if (self.routeDay > 0) {
        [dic setObject:[NSNumber numberWithInteger:self.routeDay] forKey:@"RouteDay"];
    }
    
    if ([LCStringUtil isNotNullString:self.placeName]) {
        [dic setObject:self.placeName forKey:@"PlaceName"];
    }
    
    if ([LCStringUtil isNotNullString:self.placeCoverUrl]) {
        [dic setObject:self.placeCoverUrl forKey:@"PlaceCoverUrl"];
    }
    if ([LCStringUtil isNotNullString:self.descriptionStr]) {
        [dic setObject:self.descriptionStr forKey:@"Description"];
    }
    
    return dic;
}

+ (instancetype)createInstanceForEdit{
    LCRoutePlaceModel *routePlace = [[LCRoutePlaceModel alloc] init];
    
    routePlace.routePlaceId = -1;
    routePlace.routeDay = -1;
    
    return routePlace;
}

#pragma mark Init & Encode & Decode
- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super initWithDictionary:dic];
    if (self)
    {
        self.createdTime = [LCStringUtil getNotNullStr:[dic objectForKey:@"CreatedTime"]];
        self.dayPlaces = [LCStringUtil getNotNullStr:[dic objectForKey:@"DayPlaces"]];
        self.dayDescription = [LCStringUtil getNotNullStr:[dic objectForKey:@"DayDescription"]];
        self.placeCoverUrl = [LCStringUtil getNotNullStr:[dic objectForKey:@"PlaceCoverUrl"]];
        self.placeCoverThumbUrl = [LCStringUtil getNotNullStr:[dic objectForKey:@"PlaceCoverThumbUrl"]];
        NSNumber *routePlaceIdNum = [dic objectForKey:@"RoutePlaceId"];
        self.routePlaceId = [routePlaceIdNum integerValue];
        NSNumber *placeLocLatNum = [dic objectForKey:@"PlaceLocLat"];
        self.placeLocLat = [placeLocLatNum integerValue];
        NSNumber *placeLocLngNum = [dic objectForKey:@"PlaceLocLng"];
        self.placeLocLng = [placeLocLngNum integerValue];
        self.placeName = [LCStringUtil getNotNullStr:[dic objectForKey:@"PlaceName"]];
        self.descriptionStr = [LCStringUtil getNotNullStr:[dic objectForKey:@"Description"]];
        self.placeAddress = [LCStringUtil getNotNullStr:[dic objectForKey:@"PlaceAddress"]];
        NSNumber *routeDayNum = [dic objectForKey:@"RouteDay"];
        self.routeDay = [routeDayNum integerValue];
    }
    return self;
}


- (void)encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:self.createdTime forKey:@"CreatedTime"];
    [coder encodeObject:self.placeCoverUrl forKey:@"PlaceCoverUrl"];
    [coder encodeObject:self.placeCoverThumbUrl forKey:@"PlaceCoverThumbUrl"];
    [coder encodeInteger:self.routePlaceId forKey:@"RoutePlaceId"];
    [coder encodeInteger:self.placeLocLat forKey:@"PlaceLocLat"];
    [coder encodeInteger:self.placeLocLng forKey:@"PlaceLocLng"];
    [coder encodeObject:self.placeName forKey:@"PlaceName"];
    [coder encodeObject:self.descriptionStr forKey:@"Description"];
    [coder encodeObject:self.placeAddress forKey:@"PlaceAddress"];
    [coder encodeInteger:self.routeDay forKey:@"RouteDay"];
    [coder encodeObject:self.dayPlaces forKey:@"DayPlaces"];
    [coder encodeObject:self.dayDescription forKey:@"DayDescription"];
}


- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        self.createdTime = [coder decodeObjectForKey:@"CreatedTime"];
        self.placeCoverUrl = [coder decodeObjectForKey:@"PlaceCoverUrl"];
        self.placeCoverThumbUrl = [coder decodeObjectForKey:@"PlaceCoverThumbUrl"];
        self.routePlaceId = [coder decodeIntegerForKey:@"RoutePlaceId"];
        self.placeLocLat = [coder decodeIntegerForKey:@"PlaceLocLat"];
        self.placeLocLng = [coder decodeIntegerForKey:@"PlaceLocLng"];
        self.placeName = [coder decodeObjectForKey:@"PlaceName"];
        self.descriptionStr = [coder decodeObjectForKey:@"Description"];
        self.placeAddress = [coder decodeObjectForKey:@"PlaceAddress"];
        self.routeDay = [coder decodeIntegerForKey:@"RouteDay"];
        self.dayPlaces = [coder decodeObjectForKey:@"DayPlaces"];
        self.dayDescription = [coder decodeObjectForKey:@"DayDescription"];
    }
    return self;
}
@end
