//
//  LCHomeVCBannerCell.m
//  LinkCity
//
//  Created by Roy on 8/21/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCHomeVCBannerCell.h"

@implementation LCHomeVCBannerCell

+ (CGFloat)getCellHeight{
    return 100;
}

- (void)awakeFromNib {
//    self.bannerImageView.layer.cornerRadius = 4;
    self.bannerImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
