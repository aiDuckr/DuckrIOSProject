//
//  LCPlanRouteModel.m
//  LinkCity
//
//  Created by roy on 2/10/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCPlanRouteDataSource.h"

@implementation LCPlanRouteDataSource

#pragma mark DealWithData


- (id)initWithUserRouteModel:(LCUserRouteModel *)userRoute{
    self = [super init];
    if (self) {
        self.days = [[NSMutableArray alloc] initWithCapacity:0];
        self.userRoute = userRoute;
    }
    return self;
}

- (void)setUserRoute:(LCUserRouteModel *)userRoute{
    _userRoute = userRoute;
    [self updateData];
}

- (void)updateData{
    if (self.userRoute && self.userRoute.routePlaces && self.userRoute.routePlaces.count>0) {
        for (LCRoutePlaceModel *routePlace in self.userRoute.routePlaces){
            //routeDay start from 1, while dayIndex start from 0
            NSInteger dayIndex = routePlace.routeDay-1;
            
            // instantiate a day
            if (!(self.days.count > dayIndex)) {
                LCPlanADay *aDay = [[LCPlanADay alloc] init];
                [self.days addObject:aDay];
            }
            
            // add routePlace to that day
            LCPlanADay *theDay = [self.days objectAtIndex:dayIndex];
            [theDay.routes addObject:routePlace];
        }
    }else if(self.userRoute && (!self.userRoute.routePlaces || self.userRoute.routePlaces.count==0)){
        //如果一天都没有，添加第一天
        [self insertDay];
    }
    
    //默认都合并，只最后一天打开
    for (LCPlanADay *aday in self.days){
        aday.isFolded = YES;
    }
    LCPlanADay *lastDay = [self.days lastObject];
    lastDay.isFolded = NO;
}

- (LCUserRouteModel *)getEditedUserRouteModel{
    NSMutableArray *routePlaces = [[NSMutableArray alloc] init];
    for (LCPlanADay *day in self.days){
        for (LCRoutePlaceModel *routePlace in day.routes){
            [routePlaces addObject:routePlace];
        }
    }
    self.userRoute.routePlaces = routePlaces;
    return self.userRoute;
}

- (void)insertDay{
    LCPlanADay *aDay = [[LCPlanADay alloc] init];
    [self.days addObject:aDay];
}

- (void)insertRoutePlace:(LCRoutePlaceModel *)routePlace{
    //routeDay start from 1, while dayIndex start from 0
    NSInteger dayIndex = routePlace.routeDay-1;
    
    // instantiate a day
    if (!(self.days.count > dayIndex)) {
        LCPlanADay *aDay = [[LCPlanADay alloc] init];
        [self.days addObject:aDay];
    }
    
    // add routePlace to that day
    LCPlanADay *theDay = [self.days objectAtIndex:dayIndex];
    [theDay.routes addObject:routePlace];
}

- (void)deleteRoutePlace:(LCRoutePlaceModel *)routePlace{
    //routeDay start from 1, while dayIndex start from 0
    NSInteger dayIndex = routePlace.routeDay-1;
    
    if (!(self.days.count > dayIndex)) {
        // don't have this day, so we don't have this route ~~ do not need delete
        return;
    }
    
    // delete routePlace
    LCPlanADay *theDay = [self.days objectAtIndex:dayIndex];
    [theDay.routes removeObject:routePlace];
    
    // 如果这一天的行程都没有了，删掉这一天，并把后续的的每天中的行程都更新其天数
    if (theDay.routes.count <= 0) {
        [self.days removeObject:theDay];
    }
    NSInteger routeDay = 1;
    for (LCPlanADay *aDay in self.days){
        for (LCRoutePlaceModel *aPlace in aDay.routes){
            aPlace.routeDay = routeDay;
        }
        routeDay ++;
    }
    
    //如果一天都没有了，添加一天，即Day1
    if (!self.days || self.days.count<1) {
        [self insertDay];
    }
}


//Override
- (NSString *)description{
    return [NSString stringWithFormat:@"%@",self.days];
}

#pragma mark For TableView
- (NSInteger)numberOfSections{
    return self.days.count+4;   // title, days, addDay, tips, chargeInfo
}
- (NSInteger)numberOfRowsInSection:(NSInteger)section{
    
    if (section > 0 && section < self.days.count+1) {
        NSInteger dayIndex = section-1;
        LCPlanADay *aDay = [self.days objectAtIndex:dayIndex];
        if (aDay.isFolded) {
            return 1;
        }else{
            return aDay.routes.count+2; // dayRow + routesRow + addRouteRow
        }
    }else{
        return 1;
    }
}

- (LCPlanRouteCellType)getCellTypeAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        // is route title
        return LCPlanRouteCellTypeRouteTitle;
    }else if (indexPath.section > 0 && indexPath.section < self.days.count+1) {
        // is a day
        NSInteger dayIndex = indexPath.section-1;
        LCPlanADay *aDay = [self.days objectAtIndex:dayIndex];
        if (indexPath.row == 0) {
            // it's day title
            return LCPlanRouteCellTypeDay;
        }else if (indexPath.row <= aDay.routes.count) {
            // is a route
            return LCPlanRouteCellTypeRoute;
        }else{
            // is add route cell
            return LCPlanRouteCellTypeAddRoute;
        }
    }else if(indexPath.section == self.days.count+1){
        // it's add day cell
        return LCPlanRouteCellTypeAddDay;
    }else if(indexPath.section == self.days.count+2){
        // it's tips cell
        return LCPlanRouteCellTypeTips;
    }else if(indexPath.section == self.days.count+3){
        // it's chargeInfo Cell
        return LCPlanRouteCellTypeChargeInfo;
    }
    
    return 0;
}


- (LCPlanADay *)getADayAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section > 0 && indexPath.section < self.days.count+1) {
        NSInteger dayIndex = indexPath.section-1;
        return [self.days objectAtIndex:dayIndex];
    }
    
    return nil;
}

- (NSInteger)getRouteDayAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section;
}

- (LCRoutePlaceModel *)getRoutePlaceAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath > 0 && indexPath.section < self.days.count+1) {
        NSInteger dayIndex = indexPath.section-1;
        LCPlanADay *aDay = [self.days objectAtIndex:dayIndex];
        NSInteger routeIndex = indexPath.row-1;
        if (routeIndex>=0 && routeIndex < aDay.routes.count) {
            return [aDay.routes objectAtIndex:routeIndex];
        }
    }
    return nil;
}


- (NSArray *)getFoldableIndexPathsForSection:(NSInteger)section{
    if (section > 0 && section < self.days.count+1) {
        // it's a day
        NSInteger dayIndex = section-1;
        LCPlanADay *aDay = [self.days objectAtIndex:dayIndex];
        
        NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithCapacity:0];
        // start from Row1 (route0) to last route, and plus addRoute 
        for (int i=0; i<=aDay.routes.count; i++) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:i+1 inSection:section]];
        }
        
        return indexPaths;
    }
    
    return nil;
}

@end




@implementation LCPlanADay
- (id)init{
    self = [super init];
    if (self) {
        self.isFolded = NO;
        self.routes = [[NSMutableArray alloc] init];
    }
    return self;
}

//Override
- (NSString *)description{
    return [NSString stringWithFormat:@"%@",self.routes];
}
@end