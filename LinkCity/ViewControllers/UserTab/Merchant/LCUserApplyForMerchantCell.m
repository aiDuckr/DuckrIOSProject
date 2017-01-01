//
//  LCUserApplyForMerchantCell.m
//  LinkCity
//
//  Created by godhangyu on 16/6/29.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCUserApplyForMerchantCell.h"

@implementation LCUserApplyForMerchantCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCell:(NSString *)str isHaveSeparateLine:(BOOL)separete {
    self.label.text = str;
    
    if (separete) {
        self.separateLineHeight.constant = 0.5f;
    } else {
        self.separateLineHeight.constant = 0;
    }
}

@end
