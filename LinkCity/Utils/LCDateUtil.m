//
//  LCDateUtil.m
//  LinkCity
//
//  Created by 张宗硕 on 11/11/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCDateUtil.h"

@interface LCDateUtil()

@end
@implementation LCDateUtil

static NSDateFormatter *sUsualDateFormatterToDay;
static NSDateFormatter *sUsualDateFormatterToSecond;

+ (NSString *)getMonthDayFromDateStr:(NSString *)dateStr {
    NSString *resultStr = dateStr;
    if ([LCStringUtil isNotNullString:dateStr]) {
        NSArray *strArr = [dateStr componentsSeparatedByString: @"-"];
        if (nil != strArr && 3 == strArr.count) {
            NSString *monthStr = [strArr objectAtIndex:1];
            NSString *dayStr = [strArr objectAtIndex:2];
            resultStr = [NSString stringWithFormat:@"%@.%@", monthStr, dayStr];
        }
    }
    return resultStr;
}

+ (NSDate *)getLocalDateFromGMTDate:(NSDate *)gmtDate{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMT];
    NSDate *localeDate = [gmtDate  dateByAddingTimeInterval: interval];
    return localeDate;
}

+ (NSDateFormatter *)getUsualDateFormatterToDay{
    if (!sUsualDateFormatterToDay) {
        sUsualDateFormatterToDay = [[NSDateFormatter alloc] init];
        sUsualDateFormatterToDay.dateFormat = @"yyyy-MM-dd";
    }
    return sUsualDateFormatterToDay;
}
+ (NSDateFormatter *)getUsualDateFormatterToSecond{
    if (!sUsualDateFormatterToSecond) {
        sUsualDateFormatterToSecond = [[NSDateFormatter alloc] init];
        sUsualDateFormatterToSecond.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    return sUsualDateFormatterToSecond;
}

+ (NSDateFormatter *)getMonthAndDayFormatter {
    static NSDateFormatter *monthAndDayFormatter = nil;
    if (!monthAndDayFormatter) {
        monthAndDayFormatter = [[NSDateFormatter alloc] init];
        monthAndDayFormatter.dateFormat = @"MM月dd日";
    }
    return monthAndDayFormatter;
}

+ (NSDateFormatter *)getHourAndMinuteFormatter {
    static NSDateFormatter *hourAndMinuteFormatter = nil;
    if (!hourAndMinuteFormatter) {
        hourAndMinuteFormatter = [[NSDateFormatter alloc] init];
        hourAndMinuteFormatter.dateFormat = @"HH:mm";
    }
    return hourAndMinuteFormatter;
}

+ (NSString *)getMonthAndDayStrFromDate:(NSDate *)date {
    NSString *str = [[LCDateUtil getMonthAndDayFormatter] stringFromDate:date];
    return str;
}

+ (NSString *)getHourAndMinuteStrFromDate:(NSDate *)date {
    NSString *str = [[LCDateUtil getHourAndMinuteFormatter] stringFromDate:date];
    return str;
}

+ (NSString *)getMonthDayByDateStr:(NSString *)str {
    NSDate *date = [LCDateUtil dateFromString:str];
    str = [LCDateUtil getMonthAndDayStrFromDate:date];
    str = [LCStringUtil getNotNullStr:str];
    return str;
}

+ (NSString *)getMonthDayByDateTimeStr:(NSString *)str {
    NSDate *date = [LCDateUtil dateFromStringYMD_HMS:str];
    str = [LCDateUtil getMonthAndDayStrFromDate:date];
    str = [LCStringUtil getNotNullStr:str];
    return str;
}

+ (NSString *)getHourMinuteByDateTimeStr:(NSString *)str {
    NSDate *date = [LCDateUtil dateFromStringYMD_HMS:str];
    str = [LCDateUtil getHourAndMinuteStrFromDate:date];
    str = [LCStringUtil getNotNullStr:str];
    return str;
}

+ (NSString *)getTodayStr
{
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    NSString *nowStr = [LCDateUtil stringFromDate:date];
    return nowStr;
}
+(NSString*)getTodayYearMonthDaySeconds
{
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    NSString *nowStr = [LCDateUtil getYearMonthDaySeconds:date];
    return nowStr;
}
+ (NSString *)nDaysLaterStr:(int)days
{
    NSTimeInterval secondsNDays = 24*60*60*days;
    NSDate *nDaysLaterDate = [NSDate dateWithTimeIntervalSinceNow:secondsNDays];
    NSString *nDaysLaterStr = [LCDateUtil stringFromDate:nDaysLaterDate];
    return nDaysLaterStr;
}

+ (NSString *)getDotDateFromHorizontalLineStr:(NSString *)dateStr
{
    return [dateStr stringByReplacingOccurrencesOfString:@"-" withString:@"."];
}

+ (NSString *)getMonthAndDayStrfromStr:(NSString *)dateStr {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate*current=[dateFormatter dateFromString:dateStr];
    [dateFormatter setDateFormat:@"M月d日"];
    NSString *str = [dateFormatter stringFromDate:current];
    return str;
}

+ (NSString *)getHourAndMinuteStrfromStr:(NSString *)dateStr {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSDate*current=[dateFormatter dateFromString:dateStr];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *str = [dateFormatter stringFromDate:current];
    return str;
}

+ (NSString *)getUTCStringFromLocalDate:(NSDate *)localDate {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setFormatterBehavior:NSDateFormatterBehavior10_4]; // Use unicode patterns (as opposed to 10_3)
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    [df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    NSString *utcValue = [df stringFromDate:localDate];
    return utcValue;
}

+ (NSString *)getYearMonthDaySeconds:(NSDate *)date {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setFormatterBehavior:NSDateFormatterBehavior10_4]; // Use unicode patterns (as opposed to 10_3)
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    NSString *utcValue = [df stringFromDate:date];
    return utcValue;
}

+ (NSString *)stringFromDate:(NSDate *)date
{
    NSString *str = [[LCDateUtil getUsualDateFormatterToDay] stringFromDate:date];
    return str;
}

+ (NSDate *)dateFromString:(NSString *)str {
    NSDate *date = [[LCDateUtil getUsualDateFormatterToDay] dateFromString:str];
    return date;
}

+ (NSDate *)dateFromStringYMD_HMS:(NSString *)str{
    NSDate *date = [[LCDateUtil getUsualDateFormatterToSecond] dateFromString:str];
    return date;
}

+ (NSDateComponents *)getComps:(NSDate *)date {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//设置成中国阳历
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    return comps;
}

+ (NSString *)getYearFromStr:(NSString *)str {
    NSDate *date = [LCDateUtil dateFromStringYMD_HMS:str];
    NSDateComponents *comps = [LCDateUtil getComps:date];
    return [NSString stringWithFormat:@"%ld", (long)[comps year]];
}

+ (NSString *)getMonthFromStr:(NSString *)str {
    NSDate *date = [LCDateUtil dateFromStringYMD_HMS:str];
    NSDateComponents *comps = [LCDateUtil getComps:date];
    return [NSString stringWithFormat:@"%ld", (long)[comps month]];
}

+ (NSString *)getDayFromStr:(NSString *)str {
    NSDate *date = [LCDateUtil dateFromStringYMD_HMS:str];
    NSDateComponents *comps = [LCDateUtil getComps:date];
    return [NSString stringWithFormat:@"%ld", (long)[comps day]];
}

+ (BOOL)isSameDayYMD_HHS:(NSString *)str1 withAnotherDay:(NSString *)str2 {
    NSDate *day1 = [LCDateUtil dateFromStringYMD_HMS:str1];
    NSDate *day2 = [LCDateUtil dateFromStringYMD_HMS:str2];
    
    NSDateComponents *comps1 = [LCDateUtil getComps:day1];
    NSDateComponents *comps2 = [LCDateUtil getComps:day2];
    
    return ([comps1 day] == [comps2 day]) && ([comps1 month] == [comps2 month]) && ([comps1 year] == [comps2 year]);
}

+ (NSInteger)numberOfDaysFromDateStr:(NSString *)dateStr1 toAnotherStr:(NSString *)dateStr2
{
    NSDateFormatter *formatter = [LCDateUtil getUsualDateFormatterToDay];
    NSTimeZone *localTimeZone = [NSTimeZone systemTimeZone];
    [formatter setTimeZone:localTimeZone];
    
    NSDate *today1 = [formatter dateFromString:dateStr1];
    NSDate *today2 = [formatter dateFromString:dateStr2];
    
    return [LCDateUtil numberOfDaysFromTwoDate:today1 withAnotherDate:today2];
}

+ (NSInteger)numberOfDaysFromTwoDate:(NSDate *)date1 withAnotherDate:(NSDate *)date2 {
    NSTimeInterval time = [date2 timeIntervalSinceDate:date1];
    NSInteger oneDaySecs = 24 * 3600;
    
    return time / oneDaySecs + 1;
}

+ (NSDate *)nDaysBeforeDate:(NSInteger)days {
    NSInteger oneDaySecs = 24 * 3600;
    NSDate * date = [NSDate dateWithTimeIntervalSinceNow:-oneDaySecs * days];
    return date;
}

+ (NSString *)getTimeIntervalStringFromDateString:(NSString *)dateString {
    NSString *timeStr = @"";
    NSDate *createDate = [LCDateUtil dateFromStringYMD_HMS:dateString];
    NSTimeInterval timeInterval = [createDate timeIntervalSinceNow];
    timeInterval = 0-timeInterval;
    if (timeInterval <= 0) {
        timeStr = @"";
    } else if (timeInterval < 60) {
        timeStr = @"刚刚";
    } else if(timeInterval < 60 * 60) {
        timeStr = [NSString stringWithFormat:@"%ld分钟前",(long)timeInterval/60];
    } else if(timeInterval < 60 * 60 * 24) {
        timeStr = [NSString stringWithFormat:@"%ld小时前",(long)timeInterval/60/60];
    } else if(timeInterval < 60 * 60 * 24 * 30) {
        timeStr = [NSString stringWithFormat:@"%ld天前",(long)timeInterval/60/60/24];
    } else {
        timeStr = [LCDateUtil stringFromDate:createDate];
    }
    return timeStr;
}

+ (NSDate *)nDaysBeforeDate:(NSDate *)date withDays:(NSInteger)days {
    NSInteger oneDaySecs = 24 * 3600;
    
    return [NSDate dateWithTimeInterval:(- oneDaySecs * days) sinceDate:date];
}

+ (NSDate *)dateOfFirstDayNextMonth {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                                                   fromDate:[NSDate date]];
    if (components.month == 12) {
        components.year += 1;
        components.month = 1;
        
    } else {
        components.month += 1;
    }
    components.day = 1;
    return  [[NSCalendar currentCalendar] dateFromComponents: components];
        
}

+ (NSDate *)dateOfFirstDayThisMonth {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                                                   fromDate:[NSDate date]];
    components.day = 1;
    return  [[NSCalendar currentCalendar] dateFromComponents: components];
}

+ (NSDate *)dateOfFirstDayThisWeek {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday | NSCalendarUnitWeekOfYear | NSCalendarUnitYearForWeekOfYear fromDate:[NSDate date]];
    //    if (components.month == 12) {
    //        components.year += 1;
    //        components.month = 1;
    //
    //    } else {
    //        components.month += 1;
    //    }
    //components.w
    if (components.weekday >= 2) {
        components.weekday = 2;
    } else {
       components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:[self nDaysBeforeDate:7]];
        ;
        components.weekday = 2;
    }
    return  [[NSCalendar currentCalendar] dateFromComponents: components];
}

+ (NSDate *)getCurrentDate {
    return [NSDate date];
}

+ (NSInteger)getTwoDateInterval:(NSDate *)date1 withDate2:(NSDate *)date2 {
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *d = [cal components:unitFlags fromDate:date1 toDate:date2 options:0];
    NSInteger sec = [d hour]*3600+[d minute]*60+[d second];
    return sec;
}

+ (NSString *)getChatTimeStringFromDate:(NSDate *)msgDate {
    NSString *ret = @"";
    NSDate *localDate = [LCDateUtil getLocalDateFromGMTDate:msgDate];
    NSString *dateStr = [LCDateUtil getYearMonthDaySeconds:localDate];
    ret = [LCDateUtil getTimeIntervalStringFromDateString:dateStr];
    return ret;
}

+ (NSString *)getUnixTimeStamp {
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    return timeString;
}

+ (NSString *)getCurrentYearStr {
    NSString *todayStr = [LCDateUtil getTodayStr];
    return [LCDateUtil getYearFromStr:todayStr];
}

+ (NSString *)getCurrentMonthStr {
    NSString *todayStr = [LCDateUtil getTodayStr];
    return [LCDateUtil getMonthFromStr:todayStr];
}

+ (NSString *)getCurrentDayStr {
    NSString *todayStr = [LCDateUtil getTodayStr];
    return [LCDateUtil getDayFromStr:todayStr];
}

+ (NSArray *)getTodayDateStrs {
    NSMutableArray *mutArr = [[NSMutableArray alloc] init];
    NSDate *date = [LCDateUtil nDaysBeforeDate:0];
    NSString *dayStr = [LCDateUtil stringFromDate:date];
    [mutArr addObject:dayStr];
    return mutArr;
}

+ (NSArray *)getTomorrowDateStrs {
    NSMutableArray *mutArr = [[NSMutableArray alloc] init];
    NSDate *date = [LCDateUtil nDaysBeforeDate:-1];
    NSString *dayStr = [LCDateUtil stringFromDate:date];
    [mutArr addObject:dayStr];
    return mutArr;
}

+ (NSArray *)getWeekDateStrs {
    NSMutableArray *mutArr = [[NSMutableArray alloc] init];
    
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:nowDate];
    NSInteger weekDay = [comp weekday];
    NSInteger firstDiff = -6;
    NSInteger lastDiff = 0;
    // 获取今天是周几
    if (weekDay == 1) {
        firstDiff = -6;
        lastDiff = 0;
    } else {
        firstDiff = [calendar firstWeekday] - weekDay + 1;
        lastDiff = 8 - weekDay;
    }
    
    for (NSInteger i = firstDiff + 4; i <= lastDiff; ++i) {
        NSDate *date = [LCDateUtil nDaysBeforeDate: -1 * i];
        NSString *dayStr = [LCDateUtil stringFromDate:date];
        [mutArr addObject:dayStr];
    }
    
    return mutArr;
}

+ (NSArray *)getMonthDateStrs {
    NSMutableArray *mutArr = [[NSMutableArray alloc] init];
    NSInteger monthDays = [LCDateUtil getCurrentMonthDays];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                                                   fromDate:[NSDate date]];
    for (NSInteger i = 1; i <= monthDays; ++i) {
        components.day = i;
        NSDate *date = [[NSCalendar currentCalendar] dateFromComponents: components];
        NSString *dayStr = [LCDateUtil stringFromDate:date];
        [mutArr addObject:dayStr];
    }
    
    return mutArr;
}

+ (NSInteger)getCurrentMonthDays {
    NSDate *today = [NSDate date]; //Get a date object for today's date
    NSCalendar *c = [NSCalendar currentCalendar];
    NSRange days = [c rangeOfUnit:NSCalendarUnitDay
                           inUnit:NSCalendarUnitMonth
                          forDate:today];
    return days.length;
}

+ (NSString *)getDatesShowStrFromDateArr:(NSArray *)dateStrArr {
    NSString *str = @"Dates";
    if (nil == dateStrArr || dateStrArr.count <= 0) {
        return str;
    }
    if (1 == dateStrArr.count) {
        NSString *dateStr = [dateStrArr objectAtIndex:0];
        str = [LCDateUtil getMonthDayFromDateStr:dateStr];
    } else if (dateStrArr.count >= 2) {
        NSString *minDateStr = [dateStrArr objectAtIndex:0];
        NSString *maxDateStr = [dateStrArr objectAtIndex:0];
        for (NSInteger index = 1; index < dateStrArr.count; ++index) {
            NSString *dateStr = [dateStrArr objectAtIndex:index];
            if (NSOrderedDescending == [minDateStr compare:dateStr]) {
                minDateStr = dateStr;
            } else if (NSOrderedAscending == [maxDateStr compare:dateStr]) {
                maxDateStr = dateStr;
            }
        }
        NSInteger days = [LCDateUtil numberOfDaysFromDateStr:minDateStr toAnotherStr:maxDateStr];
        if (days == dateStrArr.count) {
            NSString *minShowStr = [LCDateUtil getMonthDayFromDateStr:minDateStr];
            NSString *maxShowStr = [LCDateUtil getMonthDayFromDateStr:maxDateStr];
            str = [NSString stringWithFormat:@"%@-%@", minShowStr, maxShowStr];
        }
    }
    return str;
}

+ (NSString *)getWeekStrByDateStr:(NSString *)str {
    NSString *weekStr = @"";
    NSDate *date = [LCDateUtil dateFromString:str];
    //获取星期几
    NSDateComponents *componets = [[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitWeekday fromDate:date];
    NSInteger weekday = [componets weekday];
    NSArray *weekArray = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
    if (weekday >= 1) {
        weekStr = weekArray[weekday - 1];
    }
    weekStr = [LCStringUtil getNotNullStr:weekStr];
    return weekStr;
}

//+ (NSString *)getCreatedTimeStrByDateHourMinStr:(NSString *)str {
//    NSString *resStr = @"";
//    NSArray *arr = [LCStringUtil splitStrBySpace:str];
//    NSInteger days = [LCDateUtil numberOfDaysFromTwoDate:[LCDateUtil getCurrentDate] withAnotherDate:[LCDateUtil dateFromString:arr[0]]];
//    if (0 == days) {
//        resStr = [NSString stringWithFormat:@"今天 %@", arr[1]];
//    } else if (1 == days) {
//        resStr = [NSString stringWithFormat:@"昨天 %@", arr[1]];
//    } else {
//        resStr = arr[0];
//    }
//    resStr = [LCStringUtil getNotNullStr:resStr];
//    return resStr;
//}

+ (NSString *)getCreatedTimeStrByDateTimeStr:(NSString *)str {
    NSString *resStr = @"";
    NSString *dateStr = [LCDateUtil getMonthDayByDateTimeStr:str];
    NSString *timeStr = [LCDateUtil getHourMinuteByDateTimeStr:str];
    NSString *dateStr1 = [LCDateUtil getTodayStr];
    NSString *dateStr2 = [LCDateUtil getDateStrByDateTimeStr:str];
    NSInteger days = [LCDateUtil numberOfDaysFromDateStr:dateStr2 toAnotherStr:dateStr1] - 1;
    if (0 == days) {
        resStr = [NSString stringWithFormat:@"今天 %@", timeStr];
    } else if (1 == days) {
        resStr = [NSString stringWithFormat:@"昨天 %@", timeStr];
    } else {
        resStr = dateStr;
    }
    resStr = [LCStringUtil getNotNullStr:resStr];
    return resStr;
}

+ (NSString *)getDateStrByDateTimeStr:(NSString *)str {
    NSString *resStr = @"";
    NSDate *date = [LCDateUtil dateFromStringYMD_HMS:str];
    resStr = [LCDateUtil stringFromDate:date];
    return resStr;
}


@end
