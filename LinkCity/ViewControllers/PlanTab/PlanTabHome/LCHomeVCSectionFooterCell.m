//
//  LCHomeVCSectionFooterCell.m
//  LinkCity
//
//  Created by Roy on 8/21/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCHomeVCSectionFooterCell.h"

@implementation LCHomeVCSectionFooterCell

+ (CGFloat)getCellHeight{
    return 55;
}

- (void)awakeFromNib {
    self.containerView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateShowForSeeMorePlan{
    self.titleLabel.text = @"查看更多邀约";
}
- (void)updateShowForSeeMoreUser{
    self.titleLabel.text = @"查看更多达客";
}

@end
