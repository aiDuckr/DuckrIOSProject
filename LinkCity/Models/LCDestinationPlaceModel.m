//
//  LCDestinationPlaceModel.m
//  LinkCity
//
//  Created by roy on 2/12/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCDestinationPlaceModel.h"

@implementation LCDestinationPlaceModel

- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super initWithDictionary:dic];
    if (self)
    {
        self.placeId = [LCStringUtil idToNSInteger:[dic objectForKey:@"PlaceId"]];
        self.placeName = [LCStringUtil getNotNullStr:[dic objectForKey:@"PlaceName"]];
        self.placeImage = [LCStringUtil getNotNullStr:[dic objectForKey:@"PlaceImage"]];
        self.placeThumbImage = [LCStringUtil getNotNullStr:[dic objectForKey:@"PlaceThumbImage"]];
        self.placeDesc = [LCStringUtil getNotNullStr:[dic objectForKey:@"PlaceDesc"]];
        self.placeAddress = [LCStringUtil getNotNullStr:[dic objectForKey:@"PlaceAddress"]];
        self.planNum = [LCStringUtil idToNSInteger:[dic objectForKey:@"PlanNum"]];
    }
    return self;
}


- (void)encodeWithCoder: (NSCoder *)coder
{
    [coder encodeInteger:self.placeId forKey:@"PlaceId"];
    [coder encodeObject:self.placeName forKey:@"PlaceName"];
    [coder encodeObject:self.placeImage forKey:@"PlaceImage"];
    [coder encodeObject:self.placeThumbImage forKey:@"PlaceThumbImage"];
    [coder encodeObject:self.placeDesc forKey:@"PlaceDesc"];
    [coder encodeObject:self.placeAddress forKey:@"PlaceAddress"];
    [coder encodeInteger:self.planNum forKey:@"PlanNum"];
}


- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        self.placeId = [coder decodeIntegerForKey:@"PlaceId"];
        self.placeName = [coder decodeObjectForKey:@"PlaceName"];
        self.placeImage = [coder decodeObjectForKey:@"PlaceImage"];
        self.placeThumbImage = [coder decodeObjectForKey:@"PlaceThumbImage"];
        self.placeDesc = [coder decodeObjectForKey:@"PlaceDesc"];
        self.placeAddress = [coder decodeObjectForKey:@"PlaceAddress"];
        self.planNum = [coder decodeIntegerForKey:@"PlanNum"];
    }
    return self;
}
@end
