//
//  LCFourPicView.m
//  LinkCity
//
//  Created by 张宗硕 on 4/3/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCFourPicView.h"

@implementation LCFourPicView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)updateTourpicView:(LCTourpic *)tourpic withType:(LCTourpicCellViewType)type {
    [super updateTourpicView:tourpic withType:type];
    
    NSMutableArray *mutArr = [[NSMutableArray alloc] init];
    [mutArr addObject:self.firstImageView];
    [mutArr addObject:self.secondImageView];
    [mutArr addObject:self.thirdImageView];
    [mutArr addObject:self.fourImageView];
    
    [self addImageViewToArray:mutArr];
}

@end
