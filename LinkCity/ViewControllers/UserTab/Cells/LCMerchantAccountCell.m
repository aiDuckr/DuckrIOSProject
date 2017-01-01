//
//  LCMerchantAccountCell.m
//  LinkCity
//
//  Created by 张宗硕 on 6/17/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCMerchantAccountCell.h"

@implementation LCMerchantAccountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateShowCell:(LCBankcard *)bankcard {
    self.bankNameLabel.text = bankcard.belongedBank;
    self.accountLabel.text = bankcard.bankcardNumber;
}

@end
