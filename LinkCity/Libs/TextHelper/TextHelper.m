//
//  TextHeightGetter.m
//  zhaoxi
//
//  Created by Leo on 15/6/11.
//  Copyright (c) 2015年 Wu Dong. All rights reserved.
//

#import "TextHelper.h"

@implementation TextHelper

+ (CGFloat)getTextHeightWithText:(NSString *)text ConstraintWidth:(CGFloat)constraintWidth andFont:(UIFont *)font{
    
    NSDictionary * styleDict = @{
                                 NSFontAttributeName:font,
                                 };
    CGSize constraintSize = CGSizeMake(constraintWidth, CGFLOAT_MAX);
    CGRect rect = [text boundingRectWithSize:constraintSize options:NSStringDrawingUsesLineFragmentOrigin attributes:styleDict context:nil];
    return rect.size.height;
}

+ (CGFloat)getTextHeightWithText:(NSString *)text ConstraintWidth:(CGFloat)constraintWidth andFont:(UIFont *)font numberOfLines:(NSInteger)numberOfLines
{
    NSDictionary * styleDict = @{
                                 NSFontAttributeName:font,
                                 };
    CGSize constraintSize = CGSizeMake(constraintWidth, font.lineHeight * numberOfLines);
    CGRect rect = [text boundingRectWithSize:constraintSize options:NSStringDrawingUsesLineFragmentOrigin attributes:styleDict context:nil];
    return rect.size.height;
}


+ (CGFloat)getTextWidthWithText:(NSString *)text ConstraintHeight:(CGFloat)constraintHeight andFont:(UIFont *)font{
    
    NSDictionary * styleDict = @{
                                 NSFontAttributeName:font,
                                 };
    CGSize constraintSize = CGSizeMake(CGFLOAT_MAX, constraintHeight);
    CGRect rect = [text boundingRectWithSize:constraintSize options:NSStringDrawingUsesLineFragmentOrigin attributes:styleDict context:nil];
    return rect.size.width;
}

+ (CGFloat)getTextHeightWithText:(NSString *)text ConstraintWidth:(CGFloat)constraintWidth andFont:(UIFont *)font andLineSpacing:(CGFloat)lineSpacing{
    
    NSMutableParagraphStyle * paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = lineSpacing;
    NSDictionary * styleDict = @{
                                 NSFontAttributeName:font,
                                 NSParagraphStyleAttributeName:paraStyle,
                                 };
    CGSize constraintSize = CGSizeMake(constraintWidth, CGFLOAT_MAX);
    CGRect rect = [text boundingRectWithSize:constraintSize options:NSStringDrawingUsesLineFragmentOrigin attributes:styleDict context:nil];
    return rect.size.height;
}


+ (NSAttributedString *)getAttributedStringWithText:(NSString *)text andFont:(UIFont *)font andLineSpacing:(CGFloat)lineSpacing{
    
    if (text == nil || font == nil) {
        return nil;
    }
    NSMutableParagraphStyle * paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = lineSpacing;
    
    NSDictionary * styleDict = @{
                                 NSFontAttributeName:font,
                                 NSParagraphStyleAttributeName:paraStyle,
                                 };
    NSAttributedString * attriStr = [[NSAttributedString alloc] initWithString:text attributes:styleDict];
    return attriStr;
    
}

@end
