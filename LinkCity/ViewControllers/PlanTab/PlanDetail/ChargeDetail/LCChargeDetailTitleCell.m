//
//  LCChargeDetailTitleCell.m
//  LinkCity
//
//  Created by Roy on 6/25/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCChargeDetailTitleCell.h"

@implementation LCChargeDetailTitleCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.chargeLabelBg.layer.borderColor = UIColorFromRGBA(LCCellBorderColor, 1).CGColor;
    self.chargeLabelBg.layer.borderWidth = LCCellBorderWidth;
    self.chargeLabelBg.layer.masksToBounds = YES;
    self.chargeLabelBg.layer.cornerRadius = LCCellCornerRadius;
    
    self.memberTitleBorderView.layer.borderColor = UIColorFromRGBA(LCCellBorderColor, 1).CGColor;
    self.memberTitleBorderView.layer.borderWidth = LCCellBorderWidth;
    self.memberTitleBorderView.layer.masksToBounds = YES;
    self.memberTitleBorderView.layer.cornerRadius = LCCellCornerRadius;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)updateShowAsStageArrayForTotalEarnest:(NSDecimalNumber *)totalEarnest{
    self.chargeLabel.text = [NSString stringWithFormat:@"已收款￥%@",[LCDecimalUtil currencyStrFromDecimal:totalEarnest]];
    self.memberTitleView.hidden = YES;
}

- (void)updateShowWithStage:(LCPartnerStageModel *)stage{
    if (![LCDecimalUtil isOverZero:stage.totalEarnest]) {
        self.chargeLabel.text = @"已收款￥0";
    }else{
        self.chargeLabel.text = [NSString stringWithFormat:@"已收款￥%@",stage.totalEarnest];
    }
    
    if (stage.member.count > 1) {
        // have order
        self.memberTitleView.hidden = NO;
        self.memberTitleLabel.text = [NSString stringWithFormat:@"已支付%ld人",(long)(stage.joinNumber - 1)];
    }else{
        // no order
        self.memberTitleView.hidden = YES;
    }
}

+ (CGFloat)getCellHeightWhetherShowMemberTitle:(BOOL)showMemberTitle{
    if (showMemberTitle) {
        // have order
        return 90;
    }else{
        // no order
        return 64;
    }
}

@end
