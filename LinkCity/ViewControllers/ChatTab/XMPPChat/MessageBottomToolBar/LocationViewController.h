/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@class LocationViewController;
@class LCLocationModel;
@protocol LocationViewDelegate <NSObject>

-(void)locationViewController:(LocationViewController *)locationVC requestToSendLocation:(LCLocationModel *)location;
@end




@interface LocationViewController : UIViewController
@property (nonatomic, assign) id<LocationViewDelegate> delegate;

- (instancetype)initWithLocation:(CLLocationCoordinate2D)locationCoordinate;

@end




@interface LCLocationModel : NSObject
@property (nonatomic,strong) NSString *address;
@property (nonatomic,assign) double lat;
@property (nonatomic,assign) double lng;
@end;