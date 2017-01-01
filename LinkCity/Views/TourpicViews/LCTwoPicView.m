//
//  LCTwoPicView.m
//  LinkCity
//
//  Created by 张宗硕 on 4/2/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCTwoPicView.h"

@implementation LCTwoPicView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)updateTourpicView:(LCTourpic *)tourpic withType:(LCTourpicCellViewType)type {
    [super updateTourpicView:tourpic withType:type];

    self.leftWidthConstraint.constant = (DEVICE_WIDTH - 2.0f) / 2.0f;
    self.rightWidthConstraint.constant = (DEVICE_WIDTH - 2.0f) / 2.0f;
    
    NSMutableArray *mutArr = [[NSMutableArray alloc] init];
    [mutArr addObject:self.leftImageView];
    [mutArr addObject:self.rightImageView];
    
    [self addImageViewToArray:mutArr];
}


@end
