//
//  UIButton+ImageAndTitle.m
//  LinkCity
//
//  Created by roy on 11/14/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "UIButton+ImageAndTitle.h"

@implementation UIButton (ImageAndTitle)

- (void)updateLayoutToCenterMargin:(float)centerMargin{
    CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    titleSize.width += 4;
    titleSize.height += 4;
    CGSize imageSize = self.imageView.frame.size;
    float imageButtonHorizontalSpace = (self.frame.size.width - titleSize.width - imageSize.width - centerMargin)/2.0;
    self.titleEdgeInsets = UIEdgeInsetsMake(0, imageButtonHorizontalSpace+centerMargin, 0, imageButtonHorizontalSpace);
    self.imageEdgeInsets = UIEdgeInsetsMake(0, imageButtonHorizontalSpace, 0, imageButtonHorizontalSpace+centerMargin);
    [self setNeedsDisplay];
}
- (void)updateLayoutToEqualMargin{
    CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    CGSize imageSize = self.imageView.frame.size;
    float imageButtonHorizontalSpace = (self.frame.size.width - titleSize.width - imageSize.width)/3.0;
    self.titleEdgeInsets = UIEdgeInsetsMake(0, imageButtonHorizontalSpace*2, 0, imageButtonHorizontalSpace);
    self.imageEdgeInsets = UIEdgeInsetsMake(0, imageButtonHorizontalSpace, 0, imageButtonHorizontalSpace*2);
    [self setNeedsDisplay];
}

- (void)updateLayoutToVerticalAlineWithVerticalSpace:(float)verticalCenterMargin{
    CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    CGSize imageSize = self.imageView.frame.size;
    
    float v = verticalCenterMargin/2;
    self.imageEdgeInsets = UIEdgeInsetsMake(-titleSize.height/2-v, titleSize.width/2, titleSize.height/2+v, -titleSize.width/2);
    self.titleEdgeInsets = UIEdgeInsetsMake(imageSize.height/2+v, -imageSize.width/2, -imageSize.height/2-v, imageSize.width/2);
    [self setNeedsDisplay];
}
@end
