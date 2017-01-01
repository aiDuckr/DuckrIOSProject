//
//  UIImage+Create.m
//  LinkCity
//
//  Created by Roy on 6/18/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "UIImage+Create.h"

@implementation UIImage (Create)


+ (UIImage *)imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
