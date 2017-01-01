//
//  LCHomeRecmTabCell.m
//  LinkCity
//
//  Created by 张宗硕 on 5/14/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCHomeRecmTabCell.h"

@implementation LCHomeRecmTabCell
#pragma mark - LifeCycle.
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

#pragma mark - UIButton Actions.
/// 精选活动.
- (IBAction)selectedPlansAction:(id)sender {
    [MobClick event:V5_HOMEPAGE_RECM_SELCECTED_CLICK];
    [LCViewSwitcher pushToShowHomeRecmCostPlans:LCHomeRecmCostPlansViewType_Selected on:[LCSharedFuncUtil getTopMostNavigationController]];
}

/// 本地推荐.
- (IBAction)localRecmsAction:(id)sender {
    [MobClick event:V5_HOMEPAGE_RECM_LOCAL_CLICK];
    [LCViewSwitcher pushToShowHomeRecmCostPlans:LCHomeRecmCostPlansViewType_LocalRecm on:[LCSharedFuncUtil getTopMostNavigationController]];
}

/// 热门旅图.
- (IBAction)hotTourpicsAction:(id)sender {
    [MobClick event:V5_HOMEPAGE_RECM_TOURPIC_CLICK];
    [LCViewSwitcher pushToShowHomeRecmHotTourpicsOn:[LCSharedFuncUtil getTopMostNavigationController]];
}

/// 在线达客.
- (IBAction)onlineDuckrsAction:(id)sender {
    [MobClick event:V5_HOMEPAGE_RECM_DUCKR_CLICK];
    [LCViewSwitcher pushToShowHomeRecmOnlineDuckrsOn:[LCSharedFuncUtil getTopMostNavigationController]];
}

@end
