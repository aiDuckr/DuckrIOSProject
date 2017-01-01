//
//  LCPlanRouteModel.h
//  LinkCity
//
//  Created by roy on 2/10/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCPlanModel.h"

/* 列表显示方式：   
    每天是一个Section，每个Section的第1行是天的名字；后续是该天的目的地；最后一行是添加一个行程；
    倒数第二个Section的第0行是添加一天
    倒数第一个Section的第0行是文字描述
 */

/**
 section0
    route title
 section1
    day0 cell
        route1
        route2
        route3
        Add Route Cell
 section2
    day1 cell
        Add Route Cell
 section3
    Add Day Cell
 section4
    Tips Cell
 section5
    charge info
 */


typedef enum : NSUInteger {
    LCPlanRouteCellTypeRouteTitle,
    LCPlanRouteCellTypeDay,
    LCPlanRouteCellTypeRoute,
    LCPlanRouteCellTypeAddRoute,
    LCPlanRouteCellTypeAddDay,
    LCPlanRouteCellTypeTips,
    LCPlanRouteCellTypeChargeInfo,
} LCPlanRouteCellType;


@class LCPlanADay;
@interface LCPlanRouteDataSource : NSObject
@property (nonatomic, strong) LCUserRouteModel *userRoute;
@property (nonatomic, strong) NSMutableArray *days;

- (id)initWithUserRouteModel:(LCUserRouteModel *)userRoute;
- (LCUserRouteModel *)getEditedUserRouteModel;

- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;

- (void)insertDay;
- (void)insertRoutePlace:(LCRoutePlaceModel *)routePlace;
- (void)deleteRoutePlace:(LCRoutePlaceModel *)routePlace;

- (LCPlanRouteCellType)getCellTypeAtIndexPath:(NSIndexPath *)indexPath;

// RouteDay 表示路线中的第几天，从1开始计数
- (NSInteger)getRouteDayAtIndexPath:(NSIndexPath *)indexPath;
- (LCPlanADay *)getADayAtIndexPath:(NSIndexPath *)indexPath;
- (LCRoutePlaceModel *)getRoutePlaceAtIndexPath:(NSIndexPath *)indexPath;

- (NSArray *)getFoldableIndexPathsForSection:(NSInteger)section;

@end



@interface LCPlanADay : NSObject
@property (nonatomic, strong) NSMutableArray *routes;   //array of LCRoutePlaceModel

@property (nonatomic, assign) BOOL isFolded;
@end