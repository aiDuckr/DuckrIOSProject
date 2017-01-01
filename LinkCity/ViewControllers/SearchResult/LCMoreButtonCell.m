//
//  LCMoreButtonCell.m
//  LinkCity
//
//  Created by roy on 6/4/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCMoreButtonCell.h"

@implementation LCMoreButtonCell

- (void)awakeFromNib {
    // Initialization code
    self.moreButton.layer.masksToBounds = YES;
    self.moreButton.layer.cornerRadius = 4;
    self.moreButton.layer.borderColor = UIColorFromRGBA(0xc9c5c1, 1).CGColor;
    self.moreButton.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)getCellHeight{
    return 65;
}

@end
