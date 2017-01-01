//
//  UtilFunctionTest.m
//  LinkCity
//
//  Created by roy on 11/17/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "LCDateUtil.h"
#import "LCUserModel.h"
#import "LCPhoneUtil.h"
#import "LCRoutePlaceModel.h"
#import "LCStringUtil.h"

@interface UtilFunctionTest : XCTestCase

@end

@implementation UtilFunctionTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testIsPhoneNum {
    XCTAssert([LCPhoneUtil isPhoneNum:@"18601153634"]);
    XCTAssert([LCPhoneUtil isPhoneNum:@"15112348754"]);
    XCTAssert([LCPhoneUtil isPhoneNum:@"18601153634"]);
    
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

- (void)testGetTimeIntervalStringFromDateString{
    NSString *a = [LCDateUtil getTimeIntervalStringFromDateString:@"2014-10-17 21:30:01"];
    NSLog(@"%@",a);
    a = [LCDateUtil getTimeIntervalStringFromDateString:@"2014-11-10 21:30:01"];
    NSLog(@"%@",a);
    a = [LCDateUtil getTimeIntervalStringFromDateString:@"2014-11-12 21:30:01"];
    NSLog(@"%@",a);
    a = [LCDateUtil getTimeIntervalStringFromDateString:@"2014-11-17 14:30:01"];
    NSLog(@"%@",a);
    a = [LCDateUtil getTimeIntervalStringFromDateString:@"2014-11-17 21:30:01"];
    NSLog(@"%@",a);
    a = [LCDateUtil getTimeIntervalStringFromDateString:@"2014-11-17 21:30:01"];
    NSLog(@"%@",a);
    a = [LCDateUtil getTimeIntervalStringFromDateString:@"2014-11-17 21:41:01"];
    NSLog(@"%@",a);
}

- (void)testArray{
    NSMutableArray *arr1 = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i=0;i<10;i++){
        [arr1 addObject:[NSString stringWithFormat:@"1%d",i]];
    }
    NSMutableArray *arr2 = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i=0;i<10;i++){
        [arr2 addObject:[NSString stringWithFormat:@"2%d",i]];
    }
    
//    NSArray *tmpArr = arr1;
//    NSString *str = [tmpArr objectAtIndex:2];
//    str = [str stringByAppendingString:@"modified"];
//    
//    tmpArr = arr2;
//    str = [tmpArr objectAtIndex:2];
//    str = [str stringByAppendingString:@"modified"];
//    
//    for (NSString *s in arr1){
//        NSLog(@"arr1: %@",s);
//    }
//    for (NSString *s in arr2){
//        NSLog(@"arr2: %@",s);
//    }
}

- (void)testArray2{
    NSMutableArray *arr1 = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i=0;i<10;i++){
        LCUserModel *u = [[LCUserModel alloc]init];
        u.nick = [NSString stringWithFormat:@"nick:%d",i];
        [arr1 addObject:u];
    }
    
    LCUserModel *tmpU = [arr1 objectAtIndex:2];
    tmpU.nick = [tmpU.nick stringByAppendingString:@"modified"];
    
    for (LCUserModel *u in arr1){
        NSLog(@"arr1:%@",u.nick);
    }
}

- (void)testSystemVersion{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    NSLog(@"sys version %f",version);
}

- (void)testJson{
    LCRoutePlaceModel *routePlace = [[LCRoutePlaceModel alloc] init];
    routePlace.routePlaceId = 22;
    routePlace.routeDay = 33;
    routePlace.descriptionStr = @"description str";
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:routePlace options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"str:%@,err:%@",jsonStr,error);
}
@end

