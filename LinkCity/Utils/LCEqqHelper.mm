//
//  LCEqqHelper.m
//  LinkCity
//
//  Created by Roy on 8/12/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCEqqHelper.h"
#include <stdio.h>
#include <string.h>
#import "NSString+Additions.h"
#import "NSData+XMPP.h"

@interface LCEqqHelper()<NSURLConnectionDelegate>

@end
@implementation LCEqqHelper

+ (instancetype)sharedInstance{
    static LCEqqHelper *staticEqq;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticEqq = [[LCEqqHelper alloc] init];
    });
    return staticEqq;
}

- (void)doCallBack{
    /*
     http://t.gdt.qq.com/conv/app/{appid}/conv?v={data}&conv_type={conv_type}&app_type={ app_type}&advertiser_id={uid}
     
     appid:数值,android 应用为开放平台移动应用的 id,或者 ios 应用在 Apple App Store 的 id;广告主在广点通(e.qq.com)创建转化之后,系统会自动生成该 id;
     data:为加密的数据结构,字符串,详细描述见本文第 3 部分; 
     conv_type:为转化类型,枚举值,现在只有移动应用激活类型(MOBILEAPP_ACTIVITE); 
     app_type:为应用类型,枚举值,现阶段只有 ANDROID 和 IOS;注意要大写; 
     uid:数值,广告主在广点通(e.qq.com)的账户 id;广告主在广点通(e.qq.com)创建转化之后,系统会自动生成该 id;
     */
    
    NSString *appid = @"916449492";
    NSString *conv_type = @"MOBILEAPP_ACTIVITE";
    NSString *app_type = @"IOS";
    NSString *uid = @"399572";
    
    NSString *encrypt_key = @"6f55ab672ef93ad0";
    NSString *sign_key = @"a55b5acfb80f885b";
    
    
    /*
     query_string:          {key1}=urlencode({value1})&{key2}=urlencode({value2})
     注:
     1. 此处如果不填写 client_iP,可以直接在 query_string 中去除该参数;
     2. 此处组合参数无顺序要求。
     例:
     muid: 0f074dc8e1f0547310e729032ac0730b
     conv_time: 1422263664
     client_ip: 10.11.12.13
     变为
     muid=0f074dc8e1f0547310e729032ac0730b&conv_time=1422263664&client_ip=10.11.12.13
     */
    NSString *idfa = [LCSharedFuncUtil getIdfa];
    idfa = [idfa uppercaseString];
    NSString *muid = [idfa md5];
    NSString *conv_time = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    
    NSString *queryString = [NSString stringWithFormat:@"muid=%@&conv_time=%@",[muid stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[conv_time stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *page = [NSString stringWithFormat:@"http://t.gdt.qq.com/conv/app/%@/conv?%@",appid,queryString];
    page = [page stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *property = [NSString stringWithFormat:@"%@&GET&%@",sign_key,page];
    
    NSString *signature = [property md5];
    
    NSString *base_data = [NSString stringWithFormat:@"%@&sign=%@",queryString,[signature stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *obfuscateString = [self obfuscate:base_data withKey:encrypt_key];
    NSString *base64Data = [[obfuscateString dataUsingEncoding:NSUTF8StringEncoding] xmpp_base64Encoded];
    [base64Data stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    base64Data = [base64Data stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *attachment = [NSString stringWithFormat:@"conv_type=%@&app_type=%@&advertiser_id=%@",conv_type,app_type,uid];
    
    NSString *finalUrl = [NSString stringWithFormat:@"http://t.gdt.qq.com/conv/app/%@/conv?v=%@&%@",appid,base64Data,attachment];
    
    
//    NSString *testIDFA = @"1E2DFA89-496A-47FD-9941-DF1FC4E6484A";
//    NSString *testMUID = [testIDFA md5];
    
    
    
    
    
    //第一步，创建URL
//    NSURL *url = [NSURL URLWithString:@"http://api.hudong.com/iphonexml.do?type=focus-c"];
    //第二步，通过URL创建网络请求
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:finalUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
//    //NSURLRequest初始化方法第一个参数：请求访问路径，第二个参数：缓存协议，第三个参数：网络请求超时时间（秒）
//    
//    其中缓存协议是个枚举类型包含：
//    
//    NSURLRequestUseProtocolCachePolicy（基础策略）
//    
//    NSURLRequestReloadIgnoringLocalCacheData（忽略本地缓存）
//    
//    NSURLRequestReturnCacheDataElseLoad（首先使用缓存，如果没有本地缓存，才从原地址下载）
//    
//    NSURLRequestReturnCacheDataDontLoad（使用本地缓存，从不下载，如果本地没有缓存，则请求失败，此策略多用于离线操作）
//    
//    NSURLRequestReloadIgnoringLocalAndRemoteCacheData（无视任何缓存策略，无论是本地的还是远程的，总是从原地址重新下载）
//    
//    NSURLRequestReloadRevalidatingCacheData（如果本地缓存是有效的则不下载，其他任何情况都从原地址重新下载）
    
    //第三步，连接服务器
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *str = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",str);
     
    
}



- (NSString *)obfuscate:(NSString *)string withKey:(NSString *)key
{
    // Create data object from the string
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    // Get pointer to data to obfuscate
    char *dataPtr = (char *) [data bytes];
    
    // Get pointer to key data
    char *keyData = (char *) [[key dataUsingEncoding:NSUTF8StringEncoding] bytes];
    
    // Points to each char in sequence in the key
    char *keyPtr = keyData;
    int keyIndex = 0;
    
    // For each character in data, xor with current value in key
    for (int x = 0; x < [data length]; x++)
    {
        // Replace current character in data with
        // current character xor'd with current key value.
        // Bump each pointer to the next character
        *dataPtr = *dataPtr++ ^ *keyPtr++;
        
        // If at end of key data, reset count and
        // set key pointer back to start of key value
        if (++keyIndex == [key length])
            keyIndex = 0, keyPtr = keyData;
    }
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}


@end
