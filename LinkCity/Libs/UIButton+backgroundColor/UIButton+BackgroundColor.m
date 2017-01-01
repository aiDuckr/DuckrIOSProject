//
//  UIButton+BackgroundColor.m
//  UIButton+BackgroudColor
//
//  Created by akin on 14-4-30.
//  Copyright (c) 2014年 akin. All rights reserved.
//

#import "UIButton+BackgroundColor.h"

@implementation UIButton (BackgroundColor)

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state cornerRadius:(CGFloat)cornerRadius
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    [[UIBezierPath bezierPathWithRoundedRect:self.bounds
                                cornerRadius:cornerRadius] addClip];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [backgroundColor CGColor]);
    CGContextFillRect(context, self.bounds);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self setBackgroundImage:theImage forState:state];
}

@end
