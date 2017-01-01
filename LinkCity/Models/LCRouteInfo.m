//
//  LCRouteInfo.m
//  LinkCity
//
//  Created by roy on 11/14/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCRouteInfo.h"

@implementation LCRouteInfo
- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super initWithDictionary:dic];
    if (self)
    {
        self.createdTime = [LCStringUtil getNotNullStr:[dic objectForKey:@"CreatedTime"]];
        self.descriptionStr = [LCStringUtil getNotNullStr:[dic objectForKey:@"Description"]];
        self.image = [LCStringUtil getNotNullStr:[dic objectForKey:@"Image"]];
        self.imageThumb = [LCStringUtil getNotNullStr:[dic objectForKey:@"ImageThumb"]];
        self.placeId = [LCStringUtil getNotNullStr:[dic objectForKey:@"PlaceId"]];
        self.placeLocLat = [LCStringUtil getNotNullStr:[dic objectForKey:@"PlaceLocLat"]];
        self.placeLocLng = [LCStringUtil getNotNullStr:[dic objectForKey:@"PlaceLocLng"]];
        self.placeName = [LCStringUtil getNotNullStr:[dic objectForKey:@"PlaceName"]];
        self.receptionPlanId = [LCStringUtil getNotNullStr:[dic objectForKey:@"ReceptionPlanId"]];
        self.routeId = [LCStringUtil getNotNullStr:[dic objectForKey:@"RouteId"]];
    }
    return self;
}

- (void)encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:self.createdTime forKey:@"CreatedTime"];
    [coder encodeObject:self.descriptionStr forKey:@"Description"];
    [coder encodeObject:self.image forKey:@"Image"];
    [coder encodeObject:self.imageThumb forKey:@"ImageThumb"];
    [coder encodeObject:self.placeId forKey:@"PlaceId"];
    [coder encodeObject:self.placeLocLat forKey:@"PlaceLocLat"];
    [coder encodeObject:self.placeLocLng forKey:@"PlaceLocLng"];
    [coder encodeObject:self.placeName forKey:@"PlaceName"];
    [coder encodeObject:self.receptionPlanId forKey:@"ReceptionPlanId"];
    [coder encodeObject:self.routeId forKey:@"RouteId"];
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        self.createdTime = [coder decodeObjectForKey:@"CreatedTime"];
        self.descriptionStr = [coder decodeObjectForKey:@"Description"];
        self.image = [coder decodeObjectForKey:@"Image"];
        self.imageThumb = [coder decodeObjectForKey:@"ImageThumb"];
        self.placeId = [coder decodeObjectForKey:@"PlaceId"];
        self.placeLocLat = [coder decodeObjectForKey:@"PlaceLocLat"];
        self.placeLocLng = [coder decodeObjectForKey:@"PlaceLocLng"];
        self.placeName = [coder decodeObjectForKey:@"PlaceName"];
        self.receptionPlanId = [coder decodeObjectForKey:@"ReceptionPlanId"];
        self.routeId = [coder decodeObjectForKey:@"RouteId"];
    }
    return self;
}
@end
