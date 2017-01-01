//
//  LCHomeLocalTabCell.m
//  LinkCity
//
//  Created by 张宗硕 on 5/17/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCHomeLocalTabCell.h"
#import "LCLocationPlanTabNearbyPlanVC.h"
#import "LCLocationPlanTabCalendarVC.h"
#import "LCLocationPlanTabTourPicVC.h"

@implementation LCHomeLocalTabCell

#pragma makr - LifeCycle.
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    CGFloat gap = (DEVICE_WIDTH - 44.0f - 4 * 50.0f) / 3.0f;
    self.firstGapWidthConstraint.constant = gap;
    self.secondGapWidthConstraint.constant = gap;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma makr - Button Actions.
/// 跳转到附近约人页面.
- (IBAction)nearbyDuckrAction:(id)sender {
    [MobClick event:V5_HOMEPAGE_LOCAL_NEARBY_CLICK];
    [[LCSharedFuncUtil getTopMostNavigationController] pushViewController:[LCLocationPlanTabNearbyPlanVC createInstance] animated:YES];
}

/// 跳转到活动日历页面.
- (IBAction)calendarPlanAction:(id)sender {
    [MobClick event:V5_HOMEPAGE_LOCAL_CALENDAR_CLICK];
    [[LCSharedFuncUtil getTopMostNavigationController] pushViewController:[LCLocationPlanTabCalendarVC createInstance] animated:YES];
}

/// 跳转到本地本地旅图页面.
- (IBAction)localTourpicAction:(id)sender {
    [MobClick event:V5_HOMEPAGE_LOCAL_TOURPIC_CLICK];
    [[LCSharedFuncUtil getTopMostNavigationController] pushViewController:[LCLocationPlanTabTourPicVC createInstance] animated:YES];
}

/// 跳转到同城达客页面.
- (IBAction)localDuckrAction:(id)sender {
    [MobClick event:V5_HOMEPAGE_LOCAL_DUCKR_CLICK];
    [LCViewSwitcher pushToShowHomeRecmLocalDuckrsOn:[LCSharedFuncUtil getTopMostNavigationController]];
}

@end
