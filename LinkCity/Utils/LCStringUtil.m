//
//  YSStringUtil.m
//  MissYou
//
//  Created by zzs on 14-6-23.
//  Copyright (c) 2014年 yunshuo. All rights reserved.
//

#import "LCStringUtil.h"
#import <CommonCrypto/CommonDigest.h>

@implementation LCStringUtil

+ (NSString *)getJsonStrFromArray:(NSArray *)arr
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        LCLogWarn(@"getJosnStrFromArray error:%@",error);
        return nil;
    }
    
    NSString *jsonStr =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonStr;
}

+ (NSArray *)getArrayFromJsonStr:(NSString *)str
{
    if ([LCStringUtil isNullString:str]) {
        return [[NSArray alloc] init];
    }
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (nil != error)
    {
        arr = [[NSArray alloc] init];
    }
    return arr;
}

+ (NSArray *)splitStrBySpace:(NSString *)str {
    NSArray *arr = [str componentsSeparatedByString:@" "];
    return arr;
}

+ (NSString *)integerToString:(NSInteger)integerValue {
    return [NSString stringWithFormat:@"%tu", integerValue];
}

+ (NSString *)intToString:(int)intValue
{
    return [NSString stringWithFormat:@"%d", intValue];
}

+ (int)idToInt:(id)unknownId
{
    NSString *str = [LCStringUtil getNotNullStr:unknownId];
    return [str intValue];
}

+ (NSInteger)idToNSInteger:(id)unknownId
{
    NSString *str = [LCStringUtil getNotNullStr:unknownId];
    return [str integerValue];
}

+ (NSString *)trimSpaceAndEnter:(NSString *)str
{
    NSString *temp = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    str = [temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    return str;
}

+ (BOOL)isNotNullString:(id)unknownId
{
    if ([LCStringUtil isNullString:unknownId])
    {
        return NO;
    }
    return YES;
}

+ (BOOL)isNullString:(id)unknownId
{
    if (nil == unknownId || NULL == unknownId || [NSNull null] == unknownId)
    {
        return YES;
    }
    if ([unknownId isKindOfClass:[NSString class]] && [unknownId isEqualToString:@""])
    {
        return YES;
    }
    
    return NO;
}

+ (NSString *)getNotNullStr:(id)unknownId
{
    if (nil == unknownId || NULL == unknownId || [NSNull null] == unknownId)
    {
        return @"";
    }
    return [NSString stringWithFormat:@"%@", unknownId];
}

+ (CGFloat)getDefaultHeightOfString:(NSString *)string withFont:(UIFont *)font labelWidth:(float)labelWidth {
    if ([LCStringUtil isNullString:string]) {
        return 0;
    }
    CGRect rect = [string boundingRectWithSize:CGSizeMake(labelWidth, MAXFLOAT)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName:font}
                                       context:nil];
    return rect.size.height;
}

+ (float)getHeightOfString:(NSString *)string withFont:(UIFont *)font lineSpace:(float)lineSpace labelWidth:(float)labelWidth{
    if (!string) {
        return 0;
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [string length])];
    
    
    CGRect rect = [attributedString boundingRectWithSize:CGSizeMake(labelWidth, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    return rect.size.height;
}

+ (float)getWidthOfString:(NSString *)string withFont:(UIFont *)font labelHeight:(float)labelHeight{
    if (!string) {
        return 0;
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [string length])];
    
    
    CGRect rect = [attributedString boundingRectWithSize:CGSizeMake(1000, labelHeight) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    return rect.size.width;
}

+ (NSString *)getShowStringFromMayNullString:(NSString *)str{
    if ([LCStringUtil isNullString:str]) {
        return @"未填写";
    }else{
        return str;
    }
}

+ (NSString *)getLocationStrWhichMaybeNil:(NSString *)locationStrMaybeNil{
    if ([LCStringUtil isNullString:locationStrMaybeNil]) {
        return LOCATION_DEFULT_SYMBOL;
    }else{
        return locationStrMaybeNil;
    }
}

+ (NSMutableDictionary *)getURLParamDictionaryFromURLString:(NSString *)absoluteURLString{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    NSArray *strArr = [absoluteURLString componentsSeparatedByString:@"?"];
    if (strArr && strArr.count>0) {
        absoluteURLString = [strArr lastObject];
    }else{
    
    }
    
    strArr = [absoluteURLString componentsSeparatedByString:@"&"];
    for (NSString *paramPair in strArr)
    {
        NSArray *paramPairArray = [paramPair componentsSeparatedByString:@"="];
        if (paramPairArray && paramPairArray.count>=2) {
            NSString *key = [paramPairArray objectAtIndex:0];
            NSString *value = [paramPairArray objectAtIndex:1];
            
            [paramDic setObject:value forKey:key];
        }
    }
    
    return paramDic;
}

+ (NSString *)getNotNullStrToCaculate:(id)unknownId{
    if (nil == unknownId || NULL == unknownId || [NSNull null] == unknownId)
    {
        return @"  ";
    }
    return [NSString stringWithFormat:@"%@", unknownId];
}

+ (NSString *)getNotNullStrToShow:(id)unknownId placeHolder:(NSString *)placeHolder{
    if (nil == unknownId || NULL == unknownId || [NSNull null] == unknownId || [@"" isEqualToString:unknownId])
    {
        return placeHolder;
    }
    return [NSString stringWithFormat:@"%@", unknownId];
}

+ (BOOL)isEqualStringOrBothEmpty:(NSString *)firstStr second:(NSString *)secondStr{
    BOOL ret = NO;
    
    if ([self isNullString:firstStr] && [self isNullString:secondStr]) {
        ret = YES;
    }else if([self isNotNullString:firstStr] && [self isNotNullString:secondStr]) {
        if ([firstStr isEqualToString:secondStr]) {
            ret = YES;
        }
    }
    
    return ret;
}

//判断是否为整型：
+ (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点型：
+ (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}


+ (BOOL)validateIDCardNumber:(NSString *)value {
//    //超过10位，并且是字母或数字
//    if ([LCStringUtil isNotNullString:value] &&
//        value.length >= 10) {
//        
//        NSString *formerTenChar = [value substringToIndex:9];
//        NSString *regex = @"[a-zA-Z0-9]{9}";
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//        if ([predicate evaluateWithObject:formerTenChar] == YES) {
//            return YES;
//        }
//    }
    NSString * regex = @"^[xX0-9]{18}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:value];
    return isMatch;
}

+ (NSString *)getDistanceString:(NSInteger)distance {
    NSString *str = @"";
    if (distance <= 0) {
        str = @"";
    } else {
        if (distance >= 100) {
            str = [NSString stringWithFormat:@"%.1fkm", distance / 1000.0f];
        } else if (distance > 0) {
            str = [NSString stringWithFormat:@"%ldm", (long)distance];
        } else {
            str = @"";
        }
    }
    return str;
}

@end
