//
//  UILabel+FitSize.m
//  LinkCity
//
//  Created by roy on 4/13/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "UILabel+FitSize.h"

@implementation UILabel (FitSize)


- (void)fitSize{
    [self fitSizeWithText:self.text width:self.frame.size.width];
}

- (void)fitSizeWithText:(NSString *)text width:(CGFloat)width{
    [self setText:[LCStringUtil getNotNullStr:text]];
    CGRect frame = self.frame;
    CGSize rightSize = [self sizeThatFits:CGSizeMake(width, 0)];
    frame.size = rightSize;
    self.frame = frame;
}

- (void)fitSizeWithText:(NSString *)text width:(CGFloat)width linkSpace:(CGFloat)lineSpace{
    [self setText:[LCStringUtil getNotNullStr:text] withLineSpace:lineSpace];
    CGRect frame = self.frame;
    CGSize rightSize = [self sizeThatFits:CGSizeMake(width, 0)];
    frame.size = rightSize;
    self.frame = frame;
}



@end
