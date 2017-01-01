//
//  LCUserInfoSectionHeaderCell.m
//  LinkCity
//
//  Created by Roy on 8/26/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCUserInfoSectionHeaderCell.h"

@implementation LCUserInfoSectionHeaderCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)getCellHeight{
    return 40;
}


@end
