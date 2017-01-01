//
//  LCMerchantWithdrawCell.m
//  LinkCity
//
//  Created by 张宗硕 on 6/17/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCMerchantWithdrawCell.h"

@implementation LCMerchantWithdrawCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateShowCell:(NSDictionary *)dic {
    self.timeLabel.text = [LCStringUtil getNotNullStr:[dic objectForKey:@"CreatedTime"]];
    self.moneyLabel.text = [LCStringUtil getNotNullStr:[dic objectForKey:@"Amount"]];
}
@end
