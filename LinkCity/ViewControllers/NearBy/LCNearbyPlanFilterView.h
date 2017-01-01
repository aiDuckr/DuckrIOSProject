//
//  LCNearbyPlanFilterView.h
//  LinkCity
//
//  Created by roy on 3/8/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCNearbyPlanFilterViewDelegate;
@interface LCNearbyPlanFilterView : UIView
@property (nonatomic, weak) id<LCNearbyPlanFilterViewDelegate> delegate;

+ (instancetype)createInstance;
@end



@protocol LCNearbyPlanFilterViewDelegate <NSObject>

- (void)nearbyPlanFilterViewDidFiltDepartTime:(LCNearbyPlanFilterView *)planFilterView;
- (void)nearbyPlanFilterViewDidFiltPublishTime:(LCNearbyPlanFilterView *)planFilterView;
- (void)nearbyPlanFilterViewDidFiltCancel:(LCNearbyPlanFilterView *)planFilterView;


@end