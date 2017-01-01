//
//  LCMerchantOrderCell.m
//  LinkCity
//
//  Created by 张宗硕 on 12/25/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCMerchantOrderCell.h"

@implementation LCMerchantOrderCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateShowMerchantOrder:(LCPlanModel *)plan {
    self.plan = plan;
    self.planTitleLabel.text = plan.declaration;
    NSString *todayStr = [LCDateUtil getTodayStr];
    if ([todayStr compare:plan.startTime] < 0) {
        self.planStatusLabel.text = @"即将开始";
    } else if ([todayStr compare:plan.endTime] < 0) {
        self.planStatusLabel.text = @"进行中";
    } else {
        self.planStatusLabel.text = @"已结束";
    }
    if (plan.daysLong == 0) {
        plan.daysLong = 1;
    }
    self.startEndTimeLabel.text = [NSString stringWithFormat:@"出发日期：%@   全程%ld天",
                                [LCDateUtil getDotDateFromHorizontalLineStr:plan.startTime],
                                (long)plan.daysLong];
    self.userNumLabel.text = [NSString stringWithFormat:@"%ld人已参加", (long)plan.currentPlanOrderNumber];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@元/人", plan.costPrice];
}

- (IBAction)viewPlanDetailButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewPlanDetail:)]) {
        [self.delegate viewPlanDetail:self];
    }
}

- (IBAction)viewOrderDetailButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewMerchantOrderDetail:)]) {
        [self.delegate viewMerchantOrderDetail:self];
    }
}

@end
