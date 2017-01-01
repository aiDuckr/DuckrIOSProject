//
//  UIButton+BackgroundColor.h
//  UIButton+BackgroudColor
//
//  Created by akin on 14-4-30.
//  Copyright (c) 2014年 akin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (BackgroundColor)

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state cornerRadius:(CGFloat)cornerRadius;

@end
