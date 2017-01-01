//
//  LCBillTitleCell.m
//  LinkCity
//
//  Created by Roy on 6/25/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCBillTitleCell.h"

@implementation LCBillTitleCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.borderBg.layer.borderColor = UIColorFromRGBA(LCCellBorderColor, 1).CGColor;
    self.borderBg.layer.borderWidth = LCCellBorderWidth;
    self.borderBg.layer.masksToBounds = YES;
    self.borderBg.layer.cornerRadius = LCCellCornerRadius;
    
//    NSDateComponents *comps = [LCDateUtil getComps:[NSDate date]];
//    NSInteger month = [comps month];
//    self.titleLabel.text = [NSString stringWithFormat:@"%ld月收入记录",(long)month];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


+ (CGFloat)getCellHeight{
    return 27;
}


@end
