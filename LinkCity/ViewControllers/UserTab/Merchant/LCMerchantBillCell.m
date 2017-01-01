//
//  LCMerchantBillCell.m
//  LinkCity
//
//  Created by godhangyu on 16/6/15.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCMerchantBillCell.h"

@implementation LCMerchantBillCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellWithPlanBill:(LCPlanBillModel *)planBill {
    self.planBill = planBill;
    
    self.planLabel.text = [self.planBill.planInfo getDepartAndDestString];
    self.timeLabel.text = [self.planBill.planInfo getPlanStartDateText];
    self.priceAndMemberNumberLabel.text = [self.planBill.planInfo getPlanCostAndMemberNumberText];
    [self.moneyLabel setAttributedText:[self getMoneyLabelText]];
    self.updatedTimeLabel.text = self.planBill.updatedTime;
    
}

- (NSMutableAttributedString *)getMoneyLabelText {
    NSMutableAttributedString *retAttributedStr = nil;
    NSRange range;
    if (self.planBill.planBillType == LCPlanBillTypeWithdrawMoney) {
        retAttributedStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"- %@", self.planBill.moneySum]];
        range = NSMakeRange(0, [retAttributedStr length]);
        [retAttributedStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGBA(0x2c2a28, 1) range:range];
    } else {
        retAttributedStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"+ %@", self.planBill.moneySum]];
        range = NSMakeRange(0, [retAttributedStr length]);
        [retAttributedStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGBA(0x3ab20f, 1) range:range];
    }
    
    [retAttributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"FZLTHJW--GB1-0" size:16.0f] range:range];
    
    
    return retAttributedStr;
}

@end
