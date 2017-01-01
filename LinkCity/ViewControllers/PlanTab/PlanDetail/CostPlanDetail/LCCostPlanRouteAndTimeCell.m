//
//  LCCostPlanRouteAndTimeCell.m
//  LinkCity
//
//  Created by lhr on 16/4/23.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCCostPlanRouteAndTimeCell.h"
#import "UIView+BlocksKit.h"

@interface LCCostPlanRouteAndTimeCell()

@property (weak, nonatomic) IBOutlet UILabel *routeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *planDetailGatherPlaceIcon;
@property (weak, nonatomic) IBOutlet UIImageView *planDetailRouteIcon;

@property (weak, nonatomic) IBOutlet UILabel *timeCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *trailLabel;

@property (weak, nonatomic) IBOutlet UIButton *chooseTimeButton;

//集合时间
@property (weak, nonatomic) IBOutlet UILabel *gatherTimeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gatherTimeViewHeight;

@end

@implementation LCCostPlanRouteAndTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([LCDataManager sharedInstance].userInfo && [[LCDataManager sharedInstance].userInfo isMerchant]) {
        [self.chooseTimeButton setTitle:@"查看出行日期" forState:UIControlStateNormal];
    } else {
        [self.chooseTimeButton setTitle:@"选择出行日期" forState:UIControlStateNormal];
    }
}

- (void)bindWithData:(LCPlanModel *)model {
    self.plan = model;
    self.timeCountLabel.text = [model getPlanLastDateText];
    if ([model isUrbanPlan]) {
        self.planDetailGatherPlaceIcon.hidden = NO;
        self.planDetailRouteIcon.hidden = YES;
        self.gatherTimeViewHeight.constant = 45.0f;
        self.gatherTimeLabel.text = [NSString stringWithFormat:@"活动时间：%@",[LCDateUtil getHourAndMinuteStrfromStr:model.gatherTime]];
        self.routeLabel.text = model.gatherPlace;
        
    } else {
        self.planDetailRouteIcon.hidden = NO;
        self.planDetailGatherPlaceIcon.hidden = YES;
        self.gatherTimeViewHeight.constant = 0;
        if (model.daysLong == 0) {
            model.daysLong = 1;
        }
        if ([LCStringUtil isNotNullString:model.userRoute.routeTitle]) {
            self.routeLabel.text = model.userRoute.routeTitle;
        } else {
            self.routeLabel.text = [model getDepartAndDestString];
        }
    }

    if ([self.plan isStagePlan]) {
        self.moneyLabel.text = [NSString stringWithFormat:@"￥%@", self.plan.lowestPrice];
        self.trailLabel.text = @"起/人";
    } else {
        self.moneyLabel.text = [NSString stringWithFormat:@"￥%@",model.costPrice];
        self.trailLabel.text = @"/人";
    }
}
- (IBAction)chooseStartTimeButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(costPlanRouteAndTimeChoosed:)]) {
        [self.delegate costPlanRouteAndTimeChoosed:self.plan];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
