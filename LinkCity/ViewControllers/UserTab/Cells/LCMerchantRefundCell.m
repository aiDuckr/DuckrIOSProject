//
//  LCMerchantRefundCell.m
//  LinkCity
//
//  Created by 张宗硕 on 6/14/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCMerchantRefundCell.h"

@implementation LCMerchantRefundCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateShowCell:(LCPlanModel *)plan withUser:(LCUserModel *)user {
    [self.coverImageView setImageWithURL:[NSURL URLWithString:plan.firstPhotoThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
    self.tilteLabel.text = plan.declaration;
    NSString *timeStr = [LCDateUtil getTimeIntervalStringFromDateString:user.partnerOrder.refundTime];
    self.contentLabel.text = [NSString stringWithFormat:@"%@ %@发起退款申请", timeStr, user.nick];
    self.startTimeLabel.text = [NSString stringWithFormat:@"报名活动：%@", plan.startTime];
    if (3 == user.partnerOrder.orderRefund) {
        self.statusLabel.textColor = UIColorFromRGBA(0xc9c5c1, 1.0f);
        self.statusLabel.text = @"已处理";
    } else {
        self.statusLabel.textColor = UIColorFromRGBA(0xfb4c4c, 1.0f);
        self.statusLabel.text = @"未处理";
    }
}

@end
