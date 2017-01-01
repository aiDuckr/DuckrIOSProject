//
//  LCNearbyUserFilterView.h
//  LinkCity
//
//  Created by roy on 3/8/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLCPopup.h"

@protocol LCNearbyUserFilterViewDelegate;
@interface LCNearbyUserFilterView : UIView
@property (nonatomic, weak) id<LCNearbyUserFilterViewDelegate> delegate;

+ (instancetype)createInstance;
@end


@protocol LCNearbyUserFilterViewDelegate <NSObject>
- (void)nearbyUserFilterViewDidFiltCancel:(LCNearbyUserFilterView *)userFilterView;
- (void)nearbyUserFilterView:(LCNearbyUserFilterView *)userFilterView filtType:(LCUserFilterType)filtType;
@end