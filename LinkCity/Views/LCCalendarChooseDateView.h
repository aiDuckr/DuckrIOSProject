//
//  LCCalendarChooseDateView.h
//  LinkCity
//
//  Created by lhr on 16/5/16.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCCalendarChooseDateView;

@protocol LCCalendarChooseDateViewDelegate <NSObject>
@optional
- (void)didSelectedDate:(NSDate *)date;
- (void)didSelectedDates:(NSArray *)dates;
- (void)calendarChooseDateViewCancel:(LCCalendarChooseDateView *)view;
@end

@interface LCCalendarChooseDateView : UIView
@property (nonatomic,assign) BOOL allowsMultipleSelection;
@property (nonatomic,assign) BOOL canSelectedDateBefore;
@property (nonatomic,weak) id <LCCalendarChooseDateViewDelegate> delegate;

+ (LCCalendarChooseDateView *)createInstance;

@end
