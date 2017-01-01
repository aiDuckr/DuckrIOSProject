//
//  LinkCityTests.m
//  LinkCityTests
//
//  Created by 张宗硕 on 10/23/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "sys/sysctl.h"

@interface LinkCityTests : XCTestCase

@end

@implementation LinkCityTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testDate{
    double secondsPerDay = 60*60*24;
    
    NSDate *nowDate = [NSDate date];
    NSLog(@"%@",nowDate);
    NSDate *earlyDate = [NSDate dateWithTimeInterval:(-1*secondsPerDay*365*100) sinceDate:nowDate];
    NSLog(@"%@",earlyDate);
    NSDate *a = [NSDate dateWithTimeIntervalSince1970:secondsPerDay*365];
    NSLog(@"%@",a);
    NSDate *b = [NSDate dateWithTimeIntervalSince1970:-365*secondsPerDay];
    NSLog(@"%@",b);
    
}

- (void)testRect{
    CGRect r = CGRectMake(0, 10, 100, 200);
    NSLog(@"%@",NSStringFromCGRect(r));
}

- (void)testFont{
    NSArray *ar = [UIFont familyNames];
    NSLog(@"families %@",ar);
}

- (void)testInteger{
    NSInteger a = 10;
    for (int i=0; i<20; i++) {
        NSLog(@"%@",a<0?@"-":@"+");
        NSLog(@"%li",(long)a);
    }
}

- (void)testDecimalNumber{
    NSString *numStr1 = @"0.22";
    NSString *numStr2 = @"2.2";
    
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:numStr1];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:numStr2];
    
    NSString *str1 = [NSString stringWithFormat:@"%@",num1];
    NSString *str2 = [NSString stringWithFormat:@"%@",num2];
    
    NSString *str11 = [num1 stringValue];
    NSString *str22 = [num2 stringValue];
    
    NSLog(@"%@,%@,%@,%@",str1,str2,str11,str22);
}

- (void)testDeviceInfo{
    //手机别名： 用户定义的名称
    NSString* userPhoneName = [[UIDevice currentDevice] name];
    NSLog(@"手机别名: %@", userPhoneName);
    //设备名称
    NSString* deviceName = [[UIDevice currentDevice] systemName];
    NSLog(@"设备名称: %@",deviceName );
    //手机系统版本
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    NSLog(@"手机系统版本: %@", phoneVersion);
    //手机型号
    NSString* phoneModel = [[UIDevice currentDevice] model];
    NSLog(@"手机型号: %@",phoneModel );
    //地方型号  （国际化区域名称）
    NSString* localPhoneModel = [[UIDevice currentDevice] localizedModel];
    NSLog(@"国际化区域名称: %@",localPhoneModel );
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // 当前应用名称
    NSString *appCurName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSLog(@"当前应用名称：%@",appCurName);
    // 当前应用软件版本  比如：1.0.1
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"当前应用软件版本:%@",appCurVersion);
    // 当前应用版本号码   int类型
    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSLog(@"当前应用版本号码：%@",appCurVersionNum);
    // 当前手机型号
    NSString *deviceType = [self getDevicePlatform];
    NSLog(@"当前手机型号: %@",deviceType);
    
    /* test result
     2015-06-06 16:49:11.926 LinkCity[9161:2225695] 手机别名: Roy5
     2015-06-06 16:49:11.928 LinkCity[9161:2225695] 设备名称: iPhone OS
     2015-06-06 16:49:11.928 LinkCity[9161:2225695] 手机系统版本: 8.3
     2015-06-06 16:49:11.929 LinkCity[9161:2225695] 手机型号: iPhone
     2015-06-06 16:49:11.929 LinkCity[9161:2225695] 国际化区域名称: iPhone
     2015-06-06 16:49:11.930 LinkCity[9161:2225695] 当前应用名称：达客旅行
     2015-06-06 16:49:11.930 LinkCity[9161:2225695] 当前应用软件版本:3.1.0
     2015-06-06 16:49:11.931 LinkCity[9161:2225695] 当前应用版本号码：3.1.0.2
     */
}

- (NSString*)getDevicePlatform
{
    size_t size;
    int nR = sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    nR = sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) {
        
        platform = @"iPhone";
        
    } else if ([platform isEqualToString:@"iPhone1,2"]) {
        
        platform = @"iPhone_3G";
        
    } else if ([platform isEqualToString:@"iPhone2,1"]) {
        
        platform = @"iPhone_3GS";
        
    } else if ([platform isEqualToString:@"iPhone3,1"]||[platform isEqualToString:@"iPhone3,2"]||[platform isEqualToString:@"iPhone3,3"]) {
        
        platform = @"iPhone_4";
        
    } else if ([platform isEqualToString:@"iPhone4,1"]) {
        
        platform = @"iPhone_4S";
        
    } else if ([platform isEqualToString:@"iPhone5,1"]||[platform isEqualToString:@"iPhone5,2"]) {
        
        platform = @"iPhone_5";
        
    }else if ([platform isEqualToString:@"iPhone5,3"]||[platform isEqualToString:@"iPhone5,4"]) {
        
        platform = @"iPhone_5C";
        
    }else if ([platform isEqualToString:@"iPhone6,2"]||[platform isEqualToString:@"iPhone6,1"]) {
        
        platform = @"iPhone_5S";
        
    }else if ([platform isEqualToString:@"iPod4,1"]) {
        
        platform = @"iPod_touch_4";
        
    }else if ([platform isEqualToString:@"iPod5,1"]) {
        
        platform = @"iPod_touch_5";
        
    }else if ([platform isEqualToString:@"iPod3,1"]) {
        
        platform = @"iPod_touch_3";
        
    }else if ([platform isEqualToString:@"iPod2,1"]) {
        
        platform = @"iPod_touch_2";
        
    }else if ([platform isEqualToString:@"iPod1,1"]) {
        
        platform = @"iPod_touch";
        
    } else if ([platform isEqualToString:@"iPad3,2"]||[platform isEqualToString:@"iPad3,1"]) {
        
        platform = @"iPad_3";
        
    } else if ([platform isEqualToString:@"iPad2,2"]||[platform isEqualToString:@"iPad2,1"]||[platform isEqualToString:@"iPad2,3"]||[platform isEqualToString:@"iPad2,4"]) {
        
        platform = @"iPad_2";
        
    }else if ([platform isEqualToString:@"iPad1,1"]) {
        
        platform = @"iPad_1";
        
    }else if ([platform isEqualToString:@"iPad2,5"]||[platform isEqualToString:@"iPad2,6"]||[platform isEqualToString:@"iPad2,7"]) {
        
        platform = @"ipad_mini";
        
    } else if ([platform isEqualToString:@"iPad3,3"]||[platform isEqualToString:@"iPad3,4"]||[platform isEqualToString:@"iPad3,5"]||[platform isEqualToString:@"iPad3,6"]) {
        
        platform = @"ipad_3";
        
    }
    
    return platform;
}

@end
