//
//  LCDestinationPlaceModel.h
//  LinkCity
//
//  Created by roy on 2/12/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCBaseModel.h"

@interface LCDestinationPlaceModel : LCBaseModel
@property (nonatomic, assign) NSInteger placeId;
@property (nonatomic, retain) NSString *placeName;
@property (nonatomic, retain) NSString *placeImage;
@property (nonatomic, retain) NSString *placeThumbImage;
@property (nonatomic, retain) NSString *placeDesc;
@property (nonatomic, retain) NSString *placeAddress;
@property (nonatomic, assign) NSInteger planNum;


@end
