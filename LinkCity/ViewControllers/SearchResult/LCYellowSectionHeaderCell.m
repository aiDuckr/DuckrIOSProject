//
//  LCYellowSectionHeaderCell.m
//  LinkCity
//
//  Created by roy on 6/4/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCYellowSectionHeaderCell.h"

@interface LCYellowSectionHeaderCell()

@end
@implementation LCYellowSectionHeaderCell

- (void)awakeFromNib {
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)didTap:(UIGestureRecognizer *)sender{
    if ([self.delegate respondsToSelector:@selector(yellowSectionHeaderDidClick:)]) {
        [self.delegate yellowSectionHeaderDidClick:self];
    }
}


+ (CGFloat)getCellHeight{
    return 58;
}

@end
