//
//  TextHelper.h
//  zhaoxi
//
//  Created by Leo on 15/6/11.
//  Copyright (c) 2015年 Wu Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextHelper : NSObject

+ (CGFloat)getTextWidthWithText:(NSString *)text ConstraintHeight:(CGFloat)constraintHeight andFont:(UIFont *)font;
+ (CGFloat)getTextHeightWithText:(NSString *)text ConstraintWidth:(CGFloat)constraintWidth andFont:(UIFont *)font numberOfLines:(NSInteger)numberOfLines;
+ (CGFloat)getTextHeightWithText:(NSString *)text ConstraintWidth:(CGFloat)constraintWidth andFont:(UIFont *)font;
+ (CGFloat)getTextHeightWithText:(NSString *)text ConstraintWidth:(CGFloat)constraintWidth andFont:(UIFont *)font andLineSpacing:(CGFloat)lineSpacing;
+ (NSAttributedString *)getAttributedStringWithText:(NSString *)text andFont:(UIFont *)font andLineSpacing:(CGFloat)lineSpacing;

@end
