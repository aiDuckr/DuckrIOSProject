//
//  LCDateUtil.h
//  LinkCity
//
//  Created by 张宗硕 on 11/11/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SEC_PER_DAY (3600*24)
@interface LCDateUtil : NSObject
+ (NSString *)getMonthDayFromDateStr:(NSString *)dateStr;
+ (NSDate *)getLocalDateFromGMTDate:(NSDate *)gmtDate;
+ (NSDate *)dateFromString:(NSString *)str;
+ (NSDate *)dateFromStringYMD_HMS:(NSString *)str;
+ (NSDate *)nDaysBeforeDate:(NSInteger)days;
+ (NSDate *)nDaysBeforeDate:(NSDate *)date withDays:(NSInteger)days;
+ (NSDate *)dateOfFirstDayNextMonth;
+ (NSDate *)dateOfFirstDayThisMonth;
+ (NSDate *)dateOfFirstDayThisWeek;
//+ (NSDate *)dateOfFirstDayNextWeek;


+ (NSDateComponents *)getComps:(NSDate *)date;
+ (NSString *)getYearFromStr:(NSString *)str;
+ (NSString *)getMonthFromStr:(NSString *)str;
+ (NSString *)getDayFromStr:(NSString *)str;


+ (BOOL)isSameDayYMD_HHS:(NSString *)str1 withAnotherDay:(NSString *)str2;
+ (NSString *)getUTCStringFromLocalDate:(NSDate *)localDate;
+ (NSString *)getTodayStr;
+ (NSString *)getTodayYearMonthDaySeconds;
+ (NSInteger)numberOfDaysFromTwoDate:(NSDate *)date1 withAnotherDate:(NSDate *)date2;
+ (NSInteger)numberOfDaysFromDateStr:(NSString *)dateStr1 toAnotherStr:(NSString *)dateStr2;
+ (NSString *)getDotDateFromHorizontalLineStr:(NSString *)dateStr;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSString *)nDaysLaterStr:(int)days;
+ (NSString *)getTimeIntervalStringFromDateString:(NSString *)dateString;
+ (NSString *)getMonthAndDayStrFromDate:(NSDate *)date;
+ (NSString *)getMonthAndDayStrfromStr:(NSString *)dateStr;
+ (NSString *)getHourAndMinuteStrfromStr:(NSString *)dateStr;
//+ (NSString *)appendDays:(NSInteger)dayCount originDate:(NSDate *)originDate;

// get static date formatter
+ (NSDateFormatter *)getUsualDateFormatterToDay;
+ (NSDateFormatter *)getMonthAndDayFormatter;
+ (NSDateFormatter *)getHourAndMinuteFormatter;

+ (NSDate *)getCurrentDate;
+ (NSInteger)getTwoDateInterval:(NSDate *)date1 withDate2:(NSDate *)date2;
+ (NSString *)getChatTimeStringFromDate:(NSDate *)msgDate;
+ (NSString *)getYearMonthDaySeconds:(NSDate *)date;
+ (NSString *)getUnixTimeStamp;

+ (NSString *)getCurrentYearStr;
+ (NSString *)getCurrentMonthStr;
+ (NSString *)getCurrentDayStr;

+ (NSArray *)getTodayDateStrs;
+ (NSArray *)getTomorrowDateStrs;
+ (NSArray *)getWeekDateStrs;
+ (NSArray *)getMonthDateStrs;
+ (NSInteger)getCurrentMonthDays;

+ (NSString *)getDatesShowStrFromDateArr:(NSArray *)dateStrArr;
+ (NSString *)getMonthDayByDateStr:(NSString *)str;
+ (NSString *)getMonthDayByDateTimeStr:(NSString *)str;
+ (NSString *)getHourMinuteByDateTimeStr:(NSString *)str;
+ (NSString *)getWeekStrByDateStr:(NSString *)str;
+ (NSString *)getCreatedTimeStrByDateTimeStr:(NSString *)str;
+ (NSString *)getDateStrByDateTimeStr:(NSString *)str;
@end
