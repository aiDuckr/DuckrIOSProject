//
//  LCNinePicView.m
//  LinkCity
//
//  Created by 张宗硕 on 4/3/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCNinePicView.h"

@implementation LCNinePicView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)updateTourpicView:(LCTourpic *)tourpic withType:(LCTourpicCellViewType)type {
    [super updateTourpicView:tourpic withType:type];
    
    self.widthConstraint.constant = (DEVICE_WIDTH - 4.0f) / 3.0f;
    
    NSMutableArray *mutArr = [[NSMutableArray alloc] init];
    [mutArr addObject:self.firstImageView];
    [mutArr addObject:self.secondImageView];
    [mutArr addObject:self.thirdImageView];
    [mutArr addObject:self.fourImageView];
    [mutArr addObject:self.fiveImageView];
    [mutArr addObject:self.sixImageView];
    [mutArr addObject:self.sevenImageView];
    [mutArr addObject:self.eightImageView];
    [mutArr addObject:self.nineImageView];
    
    [self addImageViewToArray:mutArr];
}

@end
