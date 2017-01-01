//
//  LCReportUserCell.m
//  LinkCity
//
//  Created by godhangyu on 16/6/13.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCReportUserCell.h"

@implementation LCReportUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.reportSelectedIcon.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected) {
        self.reportReason.textColor = UIColorFromRGBA(0xfb4c4c, 1);
        self.reportSelectedIcon.hidden = NO;
    } else {
        self.reportReason.textColor = UIColorFromRGBA(0x2c2a28, 1);
        self.reportSelectedIcon.hidden = YES;
    }
}

- (void)updateCellWithReason:(NSString *)reason isHaveSeparateLine:(BOOL)separateLine {
    
    self.reportReason.text = reason;
    
    if (!separateLine) {
        self.separateLineHeight.constant = 0;
    }
}

@end
