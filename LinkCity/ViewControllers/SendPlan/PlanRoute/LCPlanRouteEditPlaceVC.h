//
//  LCPlanRouteEditVC.h
//  LinkCity
//
//  Created by roy on 2/9/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCBaseVC.h"
#import "LCRoutePlaceModel.h"


@class LCPlanRouteEditPlaceVC;
@protocol LCPlanRouteEditPlaceDelegate <NSObject>
- (void)planRouteEditPlace:(LCPlanRouteEditPlaceVC *)routeEditPlaceVC didDeletePlace:(LCRoutePlaceModel *)place;
- (void)planRouteEditPlace:(LCPlanRouteEditPlaceVC *)routeEditPlaceVC didEditPlace:(LCRoutePlaceModel *)place;
- (void)planRouteEditPlace:(LCPlanRouteEditPlaceVC *)routeEditPlaceVC didAddPlace:(LCRoutePlaceModel *)place;

@end

@interface LCPlanRouteEditPlaceVC : LCBaseVC
@property (nonatomic, weak) id<LCPlanRouteEditPlaceDelegate> delegate;
@property (nonatomic, strong) LCRoutePlaceModel *placeModel;

+ (instancetype)createInstance;

- (void)addPlaceAtDay:(NSInteger)routeDay;
- (void)editPlace:(LCRoutePlaceModel *)place;

@end
