//
//  CalendarLogic1.h
//  Calendar
//
//  Created by 张凡 on 14-7-3.
//  Copyright (c) 2014年 张凡. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import <Foundation/Foundation.h>
#import "CalendarDayModel.h"
#import "NSDate+WQCalendarLogic.h"

@class CalendarLogic;

@protocol CalendarLogicDelegate <NSObject>

- (void)startAndEndDayFinished:(CalendarLogic *)calendarLogic;

@end

@interface CalendarLogic : NSObject

- (NSMutableArray *)reloadCalendarView:(NSDate *)date  selectStartDate:(NSDate *)startDate selectEndDate:(NSDate *)endDate needDays:(int)days_number;
- (void)selectLogic:(CalendarDayModel *)day;
- (void)setCostPlanStageArr:(NSArray *)arr;

@property (nonatomic, retain) CalendarDayModel *startCalendarDay;
@property (nonatomic, retain) CalendarDayModel *endCalendarDay;
@property (nonatomic, retain) id<CalendarLogicDelegate> delegate;

@property (nonatomic, assign) NSInteger optiondaynumber;
@end
