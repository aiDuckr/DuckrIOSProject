//
//  YSStringUtil.h
//  MissYou
//
//  Created by zzs on 14-6-23.
//  Copyright (c) 2014年 yunshuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCStringUtil : NSObject
+ (NSString *)getJsonStrFromArray:(NSArray *)arr;
+ (NSArray *)getArrayFromJsonStr:(NSString *)str;
+ (NSArray *)splitStrBySpace:(NSString *)str;
+ (BOOL)isNotNullString:(id)unknownId;
+ (BOOL)isNullString:(id)unknownId;
+ (NSString *)getNotNullStr:(id)unknownId;

+ (NSString *)trimSpaceAndEnter:(NSString *)str;

+ (NSInteger)idToNSInteger:(id)unknownStr;
+ (int)idToInt:(id)unknownId;
+ (NSString *)intToString:(int)intValue;
+ (NSString *)integerToString:(NSInteger)integerValue;

+ (CGFloat)getDefaultHeightOfString:(NSString *)string withFont:(UIFont *)font labelWidth:(float)labelWidth;

+ (float)getHeightOfString:(NSString *)string withFont:(UIFont *)font lineSpace:(float)lineSpace labelWidth:(float)labelWidth;
+ (float)getWidthOfString:(NSString *)string withFont:(UIFont *)font labelHeight:(float)labelHeight;

/* the input string may be nil or @"".
    return a string to show to end user
    if input is nil, return @"未填写"
 */
+ (NSString *)getShowStringFromMayNullString:(NSString *)str;

/*
 @param locationStrMaybeNil     the location string, but it maybe nil
 @return  a string that won't be nil, will be show to end user
 */
+ (NSString *)getLocationStrWhichMaybeNil:(NSString *)locationStrMaybeNil;

+ (NSMutableDictionary *)getURLParamDictionaryFromURLString:(NSString *)absoluteURLString;


+ (NSString *)getNotNullStrToCaculate:(id)unknownId;
+ (NSString *)getNotNullStrToShow:(id)unknownId placeHolder:(NSString *)placeHolder;


+ (BOOL)isEqualStringOrBothEmpty:(NSString *)firstStr second:(NSString *)secondStr;

//判断是否为整型：
+ (BOOL)isPureInt:(NSString*)string;
//判断是否为浮点型：
+ (BOOL)isPureFloat:(NSString*)string;

+ (BOOL)validateIDCardNumber:(NSString *)value;

+ (NSString *)getDistanceString:(NSInteger)distance;

@end
