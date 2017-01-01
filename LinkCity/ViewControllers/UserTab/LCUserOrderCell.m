//
//  LCUserOrderCell.m
//  LinkCity
//
//  Created by godhangyu on 16/5/30.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCUserOrderCell.h"

@implementation LCUserOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCell:(LCPlanModel *)plan partnerOrderModel:(LCPartnerOrderModel *)order withSpaInset:(BOOL)separateLine {
    self.plan = plan;
    self.order = order;
    
    // order为空表示待付款
    if (!self.order) {
        _topViewContainerHeight.constant = 0.0f;
        _thirdViewContainerHeight.constant = 0.0f;
        _bottomViewContainerHeight.constant = 0.0f;
        _separateLineHeight.constant = 0.5f;
        _pendingPaymentTopSeparateLineHeight.constant = 10.0f;
        if (separateLine) {
            _pendingPaymentBottomSeparateLineHeight.constant = 10.0f;
        }
    
        [self.planImageView setImageWithURL:[NSURL URLWithString:self.plan.firstPhotoUrl]];
        self.planTitleLabel.text = self.plan.declaration;
        self.planDescriptionLabel.text = self.plan.descriptionStr;
        self.planDateLabel.text = [self.plan getSingleStartDateText];
        self.planPriceLabel.text = [self.plan getPlanCostPerPersonForUserOrder];
        
        return;
    }
    
    LCUserModel *userModel = [self.plan.memberList objectAtIndex:0];
    if (userModel) {
        [self.merchantImageView setImageWithURL:[NSURL URLWithString:userModel.avatarThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultAvatarImageName]];
        self.merchantLabel.text = userModel.nick;
    }
    
    NSInteger start = [LCDateUtil numberOfDaysFromDateStr:[LCDateUtil getTodayStr] toAnotherStr:self.plan.startTime];
    NSInteger end = [LCDateUtil numberOfDaysFromDateStr:[LCDateUtil getTodayStr] toAnotherStr:self.plan.endTime];
    if (start > 0) {
        self.planStateLabel.text = @"即将开始";
    } else if (end > 0) {
        self.planStateLabel.text = @"正在进行";
    } else {
        self.planStateLabel.text = @"已结束";
    }
    
    [self.planImageView setImageWithURL:[NSURL URLWithString:self.plan.firstPhotoUrl]];
    self.planTitleLabel.text = self.plan.declaration;
    self.planDescriptionLabel.text = self.plan.descriptionStr;
    self.planDateLabel.text = [self.plan getSingleStartDateText];
    self.planPriceLabel.text = [self.plan getPlanCostPerPersonForUserOrder];

    NSInteger orderNumber = self.order.orderNumber;
    NSDecimalNumber *orderPrice = self.order.orderPrice;
    NSString *orderInfoStr = [NSString stringWithFormat:@"共买%li件产品  合计:￥%@",(long)orderNumber,orderPrice];
    
    NSMutableAttributedString *orderInfoLabelStr = [[NSMutableAttributedString alloc] initWithString:orderInfoStr];
    NSUInteger loc = [[orderInfoLabelStr string] rangeOfString:@"￥"].location + 1;
    NSUInteger len = [[orderInfoLabelStr string] length] - loc;
    NSRange bigRange = NSMakeRange(loc, len);
    [orderInfoLabelStr addAttribute:NSFontAttributeName value:LCDefaultFontSize(15) range:bigRange];
    [self.orderInfoLabel setAttributedText:orderInfoLabelStr];
    
    self.separateLineHeight.constant = 0.5f;
    
    // button group:
    // refundButton refundingButton deleteButton evaluateButton refundSucceedButton
    self.orderRefundButton.hidden = YES;
    self.orderRefundingButton.hidden = YES;
    self.orderDeleteButton.hidden = YES;
    self.orderEvaluateButton.hidden = YES;
    self.orderRefundSucceedButton.hidden = YES;
    // 优先判断退款条件
    // 退款成功
    if (self.order.orderRefund == 1) {
        self.orderRefundSucceedButton.hidden = NO;
        self.orderDeleteButton.hidden = NO;
        [self.orderRefundSucceedButton.layer setBorderColor:[UIColorFromRGBA(0xe8e4dd, 1) CGColor]];
        [self.orderDeleteButton.layer setBorderColor:[UIColorFromRGBA(0x85817d, 1) CGColor]];
    } else if (self.order.orderRefund == 2 || self.order.orderRefund == 3) {
        // 退款中
        self.orderRefundingButton.hidden = NO;
        [self.orderRefundingButton.layer setBorderColor:[UIColorFromRGBA(0xdae4ea, 1) CGColor]];
    } else if (self.order.orderRefund == 0) {
        // 未退款,按时间区分
        if (start > 0) {
            // 可以申请退款
            self.orderRefundButton.hidden = NO;
            [self.orderRefundButton.layer setBorderColor:[UIColorFromRGBA(0x85817d, 1) CGColor]];
        } else if (end > 0) {
            [self.bottomViewContainer removeFromSuperview];
        } else {
            if (self.plan.isEvalued == NO) {
                self.orderEvaluateButton.hidden = NO;
                [self.orderEvaluateButton.layer setBorderColor:[UIColorFromRGBA(0xf66e00, 1) CGColor]];
            }
            self.orderDeleteButton.hidden = NO;
            [self.orderDeleteButton.layer setBorderColor:[UIColorFromRGBA(0x85817d, 1) CGColor]];
        }
    }
    if (separateLine) {
        _bottomSeparateLineHeight.constant = 10.0f;
    }
}

// type未使用
- (void)updatePendingPaymentTypeCell {
    [self.topViewContainer removeFromSuperview];
    [self.thirdViewContainer removeFromSuperview];
    [self.lineView removeFromSuperview];
    [self.bottomViewContainer removeFromSuperview];
}

- (void)updateToBeEvaluatedTypeCell {
    
}

- (void)updateRefundTypeCell {
    
}

- (void)updateToBeTravellingTypeCell {

}

#pragma mark - Actions

- (IBAction)refundAction:(id)sender {
    LCLogInfo(@"refundAction");
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderRefundButtonClicked:)]) {
        [self.delegate orderRefundButtonClicked:self];
    }
}

- (IBAction)evaluateAction:(id)sender {
    LCLogInfo(@"evaluateAction");
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderEvaluatedButtonClicked:)]) {
        [self.delegate orderEvaluatedButtonClicked:self];
    }
}

- (IBAction)deleteAction:(id)sender {
    LCLogInfo(@"deleteAction");
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderDeleteButtonClicked:)]) {
        [self.delegate orderDeleteButtonClicked:self];
    }
}

@end
