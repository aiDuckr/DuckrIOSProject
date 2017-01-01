//
//  LCFilterResultVC.h
//  LinkCity
//
//  Created by 张宗硕 on 1/16/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCFilterResultVC : UIViewController
@property (nonatomic, retain) NSString *placeId;
/// 筛选计划的类型.
@property (nonatomic, retain) NSString *planType;
/// 筛选人数上限.
@property (nonatomic, assign) NSInteger scaleMax;
/// 出发时间.
@property (nonatomic, retain) NSString *startDate;
/// 结束时间.
@property (nonatomic, retain) NSString *endDate;
@end
