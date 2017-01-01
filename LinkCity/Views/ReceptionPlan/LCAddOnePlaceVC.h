//
//  LCAddOnePlaceVC.h
//  LinkCity
//
//  Created by 张宗硕 on 11/14/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCSearchDestinationVC.h"
#import "LCStringUtil.h"
#import "YSAlertUtil.h"
#import "LCRouteInfo.h"

@class LCAddOnePlaceVC;

@protocol LCAddOnePlaceVCDelegate <NSObject>
@optional
- (void)addOnePlaceFinished:(LCAddOnePlaceVC *)addOnePlaceVC;

@end

@interface LCAddOnePlaceVC : LCBaseVC
@property (nonatomic, retain) LCRouteInfo *routeInfo;
@property (nonatomic, retain) LCRouteInfo *modiRouteInfo;
@property (nonatomic, retain) LCPlaceInfo *placeInfo;
@property (nonatomic, retain) id<LCAddOnePlaceVCDelegate> delegate;
@end
