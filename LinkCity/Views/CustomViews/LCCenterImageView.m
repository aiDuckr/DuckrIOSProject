//
//  LCCenterImageView.m
//  LinkCity
//
//  Created by zzs on 14/12/2.
//  Copyright (c) 2014年 linkcity. All rights reserved.
//

#import "LCCenterImageView.h"
#import "LCImageUtil.h"
@implementation LCCenterImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setImage:(UIImage *)image
{
//    UIImage *centerImage = [LCImageUtil getCenterImage:image withRect:self.frame];
    [super setImage:image];
}

@end
