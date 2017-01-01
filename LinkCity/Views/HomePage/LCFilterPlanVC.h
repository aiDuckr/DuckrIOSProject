//
//  LCFilterPlanVC.h
//  LinkCity
//
//  Created by 张宗硕 on 11/15/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCSearchDestinationVC.h"

typedef enum {TIME_TYPE_TWO_DAYS, TIME_TYPE_ONE_WEEK, TIME_TYPE_ONE_MONTH, TIME_TYPE_UNLIMIT} TimeType;

@class LCFilterPlanVC;

@protocol LCFilterPlanDelegate <NSObject>
- (void)chooseFilterFinished:(LCFilterPlanVC *)controller;

@end


@interface LCFilterPlanVC : LCBaseVC<LCSearchDestinationDelegate> {
    BOOL isReception;       //!< 是否选择求接待.
    BOOL isPartner;         //!< 是否选择求约伴.
    UILabel *sliderLabel;   //!> 选择人数上限上面展示的数字.
}

/// 筛选计划的类型.
@property (nonatomic, retain) NSString *planType;
/// 筛选的时间类型.
@property (nonatomic, assign) TimeType timeType;
/// 筛选人数上限.
@property (nonatomic, assign) NSInteger scaleMax;
/// 筛选目的地的ID.
@property (nonatomic, retain) NSString *placeID;
/// 出发时间.
@property (nonatomic, retain) NSString *startDate;
/// 结束时间.
@property (nonatomic, retain) NSString *endDate;

@property (nonatomic, retain) id<LCFilterPlanDelegate> delegate;
@end
