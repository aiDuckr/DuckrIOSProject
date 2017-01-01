//
//  LCSchoolCell.m
//  LinkCity
//
//  Created by roy on 5/31/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCSchoolCell.h"

@implementation LCSchoolCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)getCellHeight{
    return 40;
}

@end
