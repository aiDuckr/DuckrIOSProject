//
//  LCChooseProfessionCell.m
//  LinkCity
//
//  Created by roy on 3/4/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCChooseProfessionCell.h"

@implementation LCChooseProfessionCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        self.checkImageView.hidden = NO;
    }else{
        self.checkImageView.hidden = YES;
    }
}

@end
