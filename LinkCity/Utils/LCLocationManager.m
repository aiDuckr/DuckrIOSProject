//
//  LCLocationManager.m
//  LinkCity
//
//  Created by roy on 11/29/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCLocationManager.h"

@implementation LCLocationManager
+ (NSMutableArray *)getLocationsFromPlist{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Location" ofType:@"plist"];
    NSMutableArray *data = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    //NSLog(@"%@", data);//直接打印数据。
    return data;
}

+ (NSString *)getProvinceNameFromLocations:(NSMutableArray *)locations atIndex:(NSInteger)index{
    NSDictionary *dic = [locations objectAtIndex:index];
    return [dic objectForKey:@"province"];
}

+ (NSArray *)getCityArrayFromLocations:(NSArray *)locations atIndex:(NSInteger)index{
    NSDictionary *dic = [locations objectAtIndex:index];
    return [dic objectForKey:@"city"];
}

/*
 array of dic
 name    :   cityname
 pinyin  :   cityname pinyin
 areas   :   area array
 */
+ (NSArray *)getCityDicArrayFromPlist{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"sortedCityArray" ofType:@"plist"];
    NSMutableArray *data = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    return data;
}

+ (void)analysisArea{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    NSMutableDictionary *provincesDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    /*
     array of dic
        name    :   cityname
        pinyin  :   cityname pinyin
        areas   :   area array
     */
    NSMutableArray *resCityArray = [[NSMutableArray alloc] init];
    
    for (NSString *key in [provincesDic allKeys]){
        NSDictionary *provinceDic = [provincesDic objectForKey:key];
        NSString *provinceNameKey = [[provinceDic allKeys] firstObject];
        NSDictionary *citiesDic = [provinceDic objectForKey:provinceNameKey];
        
        for (NSString *cityKey in citiesDic){
            NSDictionary *cityDic = [citiesDic objectForKey:cityKey];
            NSString *cityNameKey = [[cityDic allKeys] firstObject];
            NSArray *areasArray = [cityDic objectForKey:cityNameKey];
            
            NSMutableDictionary *resCityDic = [[NSMutableDictionary alloc] init];
            [resCityDic setObject:cityNameKey forKey:@"name"];
            [resCityDic setObject:[self getPinYinFromHanZi:cityNameKey] forKey:@"pinyin"];
            NSMutableArray *resAreaArray = [[NSMutableArray alloc] init];
            
            for (NSString *areaName in areasArray){
                NSLog(@"%@ - %@ - %@",provinceNameKey, cityNameKey, areaName);
                [resAreaArray addObject:areaName];
            }
            
            [resCityDic setObject:resAreaArray forKey:@"areas"];
            [resCityArray addObject:resCityDic];
        }
    }
    
    //sort
    NSArray *sortedCityArray = [resCityArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSDictionary *cityDicA = obj1;
        NSDictionary *cityDicB = obj2;
        
        NSString *pinyinA = [cityDicA objectForKey:@"pinyin"];
        NSString *pinyinB = [cityDicB objectForKey:@"pinyin"];
        
        return [pinyinA compare:pinyinB];
    }];
    
//    //add to alphabet list
//    /*
//     array
//        alpha   :   a
//        city    :   cityDic
//                        name    :   cityname
//                        pinyin  :   cityname pinyin
//                        areas   :   area array
//     */
//    NSMutableArray *alphaCityDicArray = [[NSMutableArray alloc] init];
//    NSString *lastAlpha = @"";
//    NSString *curAlpha = @"";
//    
//    NSMutableDictionary *anAlphaCityArray;
//    for (NSDictionary *aCity in sortedCityArray){
//        NSString *pinyin = [aCity objectForKey:@"pinyin"];
//        curAlpha = [pinyin substringWithRange:NSMakeRange(0, 1)];
//        if ([curAlpha compare:lastAlpha] != NSOrderedSame) {
//            
//        }
//    }
    
    
    
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    
    //得到完整的文件名
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"sortedCityArray.plist"];
    //输入写入
    [sortedCityArray writeToFile:filename atomically:YES];
}


+ (NSString *)getPinYinFromHanZi:(NSString *)hanzi{
    NSMutableString *mutableStr = [NSMutableString stringWithString:hanzi];
    CFStringTransform((CFMutableStringRef)mutableStr, nil, kCFStringTransformToLatin, false);
    CFStringTransform((CFMutableStringRef)mutableStr, nil, kCFStringTransformStripDiacritics, false);
    NSString *pinyin = [mutableStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    return pinyin;
}

@end
