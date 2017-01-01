//
//  LCNetRequester+Homepage.m
//  LinkCity
//
//  Created by 张宗硕 on 5/18/16.
//  Copyright (c) 2016 linkcity. All rights reserved.
//

#import "LCNetRequester+Homepage.h"

@implementation LCNetRequester (Homepage)
+ (void)requestHomeRcmds:(NSString *)orderStr withCallBack:(void(^)(NSArray *rcmdArr, NSArray *contentArr, NSString *orderStr, NSString *whatHotStr, NSError *error))callBack {
    orderStr = [LCStringUtil getNotNullStr:orderStr];
    NSString *lngStr = @"";
    NSString *latStr = @"";
    if (nil != [LCDataManager sharedInstance].userLocation) {
        lngStr = [NSString stringWithFormat:@"%f", [LCDataManager sharedInstance].userLocation.lng];
        latStr = [NSString stringWithFormat:@"%f", [LCDataManager sharedInstance].userLocation.lat];
    }

    [[self getInstance] doPost:URL_HOME_RCMD withParams:@{@"Lng": lngStr, @"Lat": latStr, @"OrderStr": orderStr} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (!error) {
            NSArray *rcmdJsonArr = [dataDic objectForKey:@"RcmdList"];
            NSArray *planJsonArr = [dataDic objectForKey:@"HotPlanList"];
            NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
            
            NSMutableArray *rcmdArr = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in rcmdJsonArr) {
                LCHomeRcmd *model = [[LCHomeRcmd alloc] initWithDictionary:dic];
                if ([model isValidHomeRcmd]) {
                    [rcmdArr addObject:model];
                }
            }
            
            NSMutableArray *contentArr = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in planJsonArr) {
                LCPlanModel *model = [[LCPlanModel alloc] initWithDictionary:dic];
                if (NO == [model isEmptyPlan]) {
                    [contentArr addObject:model];
                }
            }
            
            NSString *whatHotStr = [LCStringUtil getNotNullStr:[dataDic objectForKey:@"WhatsHot"]];
                        
            callBack(rcmdArr, contentArr, orderStr, whatHotStr, error);
        } else {
            callBack(nil, nil, nil, nil, error);
        }
    }];
}

+ (void)requestHomeRcmdModulePersonalWithCallBack:(void(^)(LCHomeRcmd *homeRcmd, NSError *error))callBack {
    [[self getInstance] doPost:URL_HOME_RCMD_MODULE withParams:@{} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (!error) {
            NSDictionary *dic = [dataDic objectForKey:@"HomeRcmd"];
            LCHomeRcmd *model = [[LCHomeRcmd alloc] initWithDictionary:dic];
            callBack(model, error);
        } else {
            callBack(nil, error);
        }
    }];
}

+ (void)requestHomeInvites:(NSString *)orderStr themeId:(NSInteger)themeId sex:(NSInteger)sex orderType:(NSInteger)type withCallBack:(void(^)(NSArray *contentArr, NSString *orderStr, NSError *error))callBack {
    orderStr = [LCStringUtil getNotNullStr:orderStr];
    NSString *lngStr = @"";
    NSString *latStr = @"";
    if (nil != [LCDataManager sharedInstance].userLocation) {
        lngStr = [NSString stringWithFormat:@"%f", [LCDataManager sharedInstance].userLocation.lng];
        latStr = [NSString stringWithFormat:@"%f", [LCDataManager sharedInstance].userLocation.lat];
    }
    NSString *themeIdStr = [LCStringUtil integerToString:themeId];
    NSString *sexStr = [LCStringUtil integerToString:sex];
    NSString *typeStr = [LCStringUtil integerToString:type];
        
    [[self getInstance] doPost:URL_HOME_INVITE withParams:@{@"Lng": lngStr, @"Lat": latStr, @"ThemeId": themeIdStr, @"Sex": sexStr, @"OrderType": typeStr, @"OrderStr": orderStr} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (!error) {
            NSArray *contentJsonArr = [dataDic objectForKey:@"PlanList"];
            NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
            
            NSMutableArray *contentArr = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in contentJsonArr) {
                LCPlanModel *model = [[LCPlanModel alloc] initWithDictionary:dic];
                if (NO == [model isEmptyPlan]) {
                    [contentArr addObject:model];
                }
            }
            
            callBack(contentArr, orderStr, error);
        } else {
            callBack(nil, nil, error);
        }
    }];
}

+ (void)requestHomeRcmdPersonal:(NSString *)orderStr withCallBack:(void(^)(NSArray *contentArr, NSString *orderStr, NSError *error))callBack {
    orderStr = [LCStringUtil getNotNullStr:orderStr];
    [[self getInstance] doPost:URL_HOME_RCMD_PERSONAL withParams:@{@"OrderStr": orderStr} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (!error) {
            NSArray *contentJsonArr = [dataDic objectForKey:@"PlanList"];
            NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
            
            NSMutableArray *contentArr = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in contentJsonArr) {
                LCPlanModel *model = [[LCPlanModel alloc] initWithDictionary:dic];
                if (NO == [model isEmptyPlan]) {
                    [contentArr addObject:model];
                }
            }
            
            callBack(contentArr, orderStr, error);
        } else {
            callBack(nil, nil, error);
        }
    }];
}

+ (void)requestHomeRcmdNearby:(NSString *)orderStr withCallBack:(void(^)(NSArray *contentArr, NSString *orderStr, NSError *error))callBack {
    orderStr = [LCStringUtil getNotNullStr:orderStr];
    double lng = [LCDataManager sharedInstance].userLocation.lng;
    double lat = [LCDataManager sharedInstance].userLocation.lat;
    NSString *lngStr = [NSString stringWithFormat:@"%f", lng];
    NSString *latStr = [NSString stringWithFormat:@"%f", lat];
    
    [[self getInstance] doPost:URL_HOME_RCMD_NEARBY withParams:@{@"Lng": lngStr, @"Lat": latStr, @"OrderStr": orderStr} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (!error) {
            NSArray *contentJsonArr = [dataDic objectForKey:@"PlanList"];
            NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
            
            NSMutableArray *contentArr = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in contentJsonArr) {
                LCPlanModel *model = [[LCPlanModel alloc] initWithDictionary:dic];
                if (NO == [model isEmptyPlan]) {
                    [contentArr addObject:model];
                }
            }
            
            callBack(contentArr, orderStr, error);
        } else {
            callBack(nil, nil, error);
        }
    }];
}

+ (void)requestHomeRcmdToday:(NSString *)orderStr withCallBack:(void(^)(NSArray *contentArr, NSString *orderStr, NSError *error))callBack {
    orderStr = [LCStringUtil getNotNullStr:orderStr];
    
    [[self getInstance] doPost:URL_HOME_RCMD_TODAY withParams:@{@"OrderStr": orderStr} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (!error) {
            NSArray *contentJsonArr = [dataDic objectForKey:@"PlanList"];
            NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
            
            NSMutableArray *contentArr = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in contentJsonArr) {
                LCPlanModel *model = [[LCPlanModel alloc] initWithDictionary:dic];
                if (NO == [model isEmptyPlan]) {
                    [contentArr addObject:model];
                }
            }
            
            callBack(contentArr, orderStr, error);
        } else {
            callBack(nil, nil, error);
        }
    }];
}

+ (void)requestHomeRcmdTomorrow:(NSString *)orderStr withCallBack:(void(^)(NSArray *contentArr, NSString *orderStr, NSError *error))callBack {
    orderStr = [LCStringUtil getNotNullStr:orderStr];
    
    [[self getInstance] doPost:URL_HOME_RCMD_TOMORROW withParams:@{@"OrderStr": orderStr} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (!error) {
            NSArray *contentJsonArr = [dataDic objectForKey:@"PlanList"];
            NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
            
            NSMutableArray *contentArr = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in contentJsonArr) {
                LCPlanModel *model = [[LCPlanModel alloc] initWithDictionary:dic];
                if (NO == [model isEmptyPlan]) {
                    [contentArr addObject:model];
                }
            }
            
            callBack(contentArr, orderStr, error);
        } else {
            callBack(nil, nil, error);
        }
    }];
}

+ (void)requestHomeRcmdWeekend:(NSString *)orderStr withCallBack:(void(^)(NSArray *contentArr, NSString *orderStr, NSError *error))callBack {
    orderStr = [LCStringUtil getNotNullStr:orderStr];
    
    [[self getInstance] doPost:URL_HOME_RCMD_WEEKEND withParams:@{@"OrderStr": orderStr} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (!error) {
            NSArray *contentJsonArr = [dataDic objectForKey:@"PlanList"];
            NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
            
            NSMutableArray *contentArr = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in contentJsonArr) {
                LCPlanModel *model = [[LCPlanModel alloc] initWithDictionary:dic];
                if (NO == [model isEmptyPlan]) {
                    [contentArr addObject:model];
                }
            }
            callBack(contentArr, orderStr, error);
        } else {
            callBack(nil, nil, error);
        }
    }];
}

+ (void)requestHomeSearchText:(NSString *)text withCallBack:(void(^)(NSArray *activList, NSArray *inviteList, NSNumber *activNumber, NSNumber *inviteNumber, NSError *error))callBack {
    text = [LCStringUtil getNotNullStr:text];
    [[self getInstance] doPost:URL_HOME_SEARCH_TEXT withParams:@{@"SearchText": text } requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (!error) {
            
            /*
             "ActivList":
             [
             {PartnerPlan数据结构}
             {PartnerPlan数据结构}
             {PartnerPlan数据结构}
             ]
             "InviteList":
             [
             {PartnerPlan数据结构}
             {PartnerPlan数据结构}
             {PartnerPlan数据结构}
             ]
             ActivNumber: 30
             InviteNumber: 40
             */
            
            NSArray *activListArr = [dataDic objectForKey:@"ActivList"];
            NSArray *inviteListArr = [dataDic objectForKey:@"InviteList"];
            NSNumber *activNumber = [dataDic objectForKey:@"ActivNumber"];
            NSNumber *inviteNumber = [dataDic objectForKey:@"InviteNumber"];
            
            NSMutableArray *activList = @[].mutableCopy;
            NSMutableArray *inviteList = @[].mutableCopy;
            for (NSDictionary *dic in activListArr) {
                LCPlanModel *model = [[LCPlanModel alloc] initWithDictionary:dic];
                if (NO == [model isEmptyPlan]) {
                    [activList addObject:model];
                }
            }
            for (NSDictionary *dic in inviteListArr) {
                LCPlanModel *model = [[LCPlanModel alloc] initWithDictionary:dic];
                if (NO == [model isEmptyPlan]) {
                    [inviteList addObject:model];
                }
            }
            callBack(activList, inviteList, activNumber, inviteNumber, error);
        } else {
            callBack(nil, nil, nil, nil, error);
        }
    }];
}


+ (void)requestHomeCalendar:(NSArray *)dateArr priceArr:(NSArray *)priceArr themeArr:(NSArray *)themeArr searchText:(NSString *)text orderType:(NSInteger)orderType orderStr:(NSString *)orderStr withCallBack:(void(^)(NSArray *contentArr, NSString *orderStr, NSError *error))callBack {
    NSString *dateStr = [LCStringUtil getJsonStrFromArray:dateArr];
    NSString *priceStr = [LCStringUtil getJsonStrFromArray:priceArr];
    NSString *themeStr = [LCStringUtil getJsonStrFromArray:themeArr];
    text = [LCStringUtil getNotNullStr:text];
    NSString *orderTypeStr = [LCStringUtil integerToString:orderType];
    orderStr = [LCStringUtil getNotNullStr:orderStr];
    [[self getInstance] doPost:URL_HOME_SEARCH_CALENDAR withParams:@{@"DateList": dateStr, @"PriceList": priceStr, @"ThemeList": themeStr, @"SearchText": text, @"OrderType":orderTypeStr, @"OrderStr": orderStr} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (!error) {
            NSArray *contentJsonArr = [dataDic objectForKey:@"PlanList"];
            NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
            
            NSMutableArray *contentArr = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in contentJsonArr) {
                LCPlanModel *model = [[LCPlanModel alloc] initWithDictionary:dic];
                if (NO == [model isEmptyPlan]) {
                    [contentArr addObject:model];
                }
            }
            callBack(contentArr, orderStr, error);
        } else {
            callBack(nil, nil, error);
        }
    }];
}

+ (void)requestMoreActiv:(NSArray *)dateArr priceArr:(NSArray *)priceArr themeArr:(NSArray *)themeArr searchText:(NSString *)text orderType:(NSInteger)orderType orderStr:(NSString *)orderStr withCallBack:(void(^)(NSArray *contentArr, NSString *orderStr, NSError *error))callBack {
    NSString *dateStr = [LCStringUtil getJsonStrFromArray:dateArr];
    NSString *priceStr = [LCStringUtil getJsonStrFromArray:priceArr];
    NSString *themeStr = [LCStringUtil getJsonStrFromArray:themeArr];
    text = [LCStringUtil getNotNullStr:text];
    NSString *orderTypeStr = [LCStringUtil integerToString:orderType];
    /*
     @{@"DateList": @"[\n\n]", @"PriceList": @"[\n\n]", @"ThemeList": @"[\n\n]", @"SearchText": @"体验探索", @"OrderType":@"0", @"OrderStr": @""}
     */
    orderStr = [LCStringUtil getNotNullStr:orderStr];
    [[self getInstance] doPost:URL_HOME_SEARCH_TEXT_MORE_ACTIV withParams:@{@"DateList": dateStr, @"PriceList": priceStr, @"ThemeList": themeStr, @"SearchText": text, @"OrderType":orderTypeStr, @"OrderStr": orderStr} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (!error) {
            NSArray *contentJsonArr = [dataDic objectForKey:@"ActivList"];
            NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
            
            NSMutableArray *contentArr = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in contentJsonArr) {
                LCPlanModel *model = [[LCPlanModel alloc] initWithDictionary:dic];
                if (NO == [model isEmptyPlan]) {
                    [contentArr addObject:model];
                }
            }
            callBack(contentArr, orderStr, error);
        } else {
            callBack(nil, nil, error);
        }
    }];
}

+ (void)requestMoreInvites:(NSString *)orderStr themeId:(NSInteger)themeId sex:(NSInteger)sex orderType:(NSInteger)type withCallBack:(void(^)(NSArray *contentArr, NSString *orderStr, NSError *error))callBack {
    orderStr = [LCStringUtil getNotNullStr:orderStr];
    NSString *lngStr = @"";
    NSString *latStr = @"";
    if (nil != [LCDataManager sharedInstance].userLocation) {
        lngStr = [NSString stringWithFormat:@"%f", [LCDataManager sharedInstance].userLocation.lng];
        latStr = [NSString stringWithFormat:@"%f", [LCDataManager sharedInstance].userLocation.lat];
    }
    NSString *themeIdStr = [LCStringUtil integerToString:themeId];
    NSString *sexStr = [LCStringUtil integerToString:sex];
    NSString *typeStr = [LCStringUtil integerToString:type];
    
    [[self getInstance] doPost:URL_HOME_INVITE withParams:@{@"Lng": lngStr, @"Lat": latStr, @"ThemeId": themeIdStr, @"Sex": sexStr, @"OrderType": typeStr, @"OrderStr": orderStr} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (!error) {
            NSArray *contentJsonArr = [dataDic objectForKey:@"PlanList"];
            NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
            
            NSMutableArray *contentArr = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in contentJsonArr) {
                LCPlanModel *model = [[LCPlanModel alloc] initWithDictionary:dic];
                if (NO == [model isEmptyPlan]) {
                    [contentArr addObject:model];
                }
            }
            
            callBack(contentArr, orderStr, error);
        } else {
            callBack(nil, nil, error);
        }
    }];
}

//同城活动接口
//+ (void)requestHomeInvitation:(NSString *)orderStr themeArr:(NSArray *)themeArr sex:(NSInteger)sex orderType:(NSInteger)type withCallBack:(void(^)(NSArray *contentArr, NSString *orderStr, NSError *error))callBack {
//    orderStr = [LCStringUtil getNotNullStr:orderStr];
//    NSString *themeJsonStr = [LCStringUtil getJsonStrFromArray:themeArr];
//    NSString *sexStr = [LCStringUtil integerToString:sex];
//    NSString *typeStr = [LCStringUtil integerToString:type];
//    
//    [[self getInstance] doPost:URL_HOME_INVITE withParams:@{@"ThemeList": themeJsonStr, @"Sex": sexStr, @"OrderType": typeStr, @"OrderStr": orderStr} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
//        if (!error) {
//            NSArray *contentJsonArr = [dataDic objectForKey:@"PlanList"];
//            NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
//            
//            NSMutableArray *contentArr = [[NSMutableArray alloc] init];
//            for (NSDictionary *dic in contentJsonArr) {
//                LCPlanModel *model = [[LCPlanModel alloc] initWithDictionary:dic];
//                if (nil != model) {
//                    [contentArr addObject:model];
//                }
//            }
//            
//            callBack(contentArr, orderStr, error);
//        } else {
//            callBack(nil, nil, error);
//        }
//    }];
//}
/// 首页本地接口.
+ (void)getHomepageLocals:(NSString *)localName withOrderStr:(NSString *)orderStr callBack:(void(^)(LCCityModel *cityObj, LCWeatherDay *weatherDay, NSArray *contentArr, NSString *orderStr, NSError *error))callBack {
    if ([LCStringUtil isNullString:orderStr]) {
        orderStr = @"";
    } else {
        [MobClick event:V5_HOMEPAGE_LOCAL_MORE_REQUEST];
    }
    if ([LCStringUtil isNullString:localName]) {
        localName = @"";
    }
    [[self getInstance] doPost:URL_PLAN_HOMEPAGE_LOCAL withParams:@{@"LocName":localName, @"OrderStr": orderStr} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (!error) {
            NSDictionary *cityJsonDic = [dataDic objectForKey:@"CityInfo"];
            LCCityModel *cityObj = [[LCCityModel alloc] initWithDictionary:cityJsonDic];
            
            NSDictionary *weatherJsonDic = [dataDic objectForKey:@"WeatherData"];
            LCWeatherDay *weatherDay = [[LCWeatherDay alloc] initWithDictionary:weatherJsonDic];
            
            NSArray *tourpicJsonArr = [dataDic objectForKey:@"TourPicList"];
            NSArray *planJsonArr = [dataDic objectForKey:@"PlanList"];
            NSArray *mixedJsonArr = [dataDic objectForKey:@"MixedList"];
            
            NSMutableArray *contentArr = [[NSMutableArray alloc] init];
            NSInteger tourpicIndex = 0;
            NSInteger planIndex = 0;
            for (NSInteger i = 0; i < mixedJsonArr.count; ++i) {
                NSInteger mark = [LCStringUtil idToNSInteger:[mixedJsonArr objectAtIndex:i]];
                if (LCNetRequesterType_Tourpic == mark && tourpicIndex < tourpicJsonArr.count) {
                    LCTourpic *tourpic = [[LCTourpic alloc] initWithDictionary:[tourpicJsonArr objectAtIndex:tourpicIndex]];
                    [contentArr addObject:tourpic];
                    tourpicIndex++;
                } else if (LCNetRequesterType_Plan == mark && planIndex < planJsonArr.count) {
                    LCPlanModel *plan = [[LCPlanModel alloc] initWithDictionary:[planJsonArr objectAtIndex:planIndex]];
                    [contentArr addObject:plan];
                    planIndex++;
                }
            }
            
            NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
            callBack(cityObj, weatherDay, contentArr, orderStr, error);
        } else {
            callBack(nil, nil, nil, nil, error);
        }
    }];
}

/// 首页邀约接口.
+ (void)getHomepagePlans:(LCNetRequesterPlanFilterType)filterType
                destName:(NSString *)destName
              departName:(NSString *)departName
               startDate:(NSString *)startDate
                 endDate:(NSString *)endDate
            withOrderStr:(NSString *)orderStr
                callBack:(void(^)(NSArray *contentArr, NSString *orderStr, NSError *error))callBack {
    if ([LCStringUtil isNotNullString:orderStr]) {
        [MobClick event:V5_HOMEPAGE_PLAN_MORE_REQUEST];
    }
    
    NSMutableDictionary *mutDic = [[NSMutableDictionary alloc] init];
    NSString *filterStr = [NSString stringWithFormat:@"%d", filterType];
    destName = [LCStringUtil getNotNullStr:destName];
    departName = [LCStringUtil getNotNullStr:departName];
    startDate = [LCStringUtil getNotNullStr:startDate];
    endDate = [LCStringUtil getNotNullStr:endDate];
    orderStr = [LCStringUtil getNotNullStr:orderStr];
    NSString *locName = @"";
    if (nil != [LCDataManager sharedInstance].currentCity) {
        locName = [LCDataManager sharedInstance].currentCity.cityName;
    }
    
    [mutDic setObject:filterStr forKey:@"PlanType"];
    [mutDic setObject:locName forKey:@"LocName"];
    [mutDic setObject:destName forKey:@"DestName"];
    [mutDic setObject:departName forKey:@"DepartName"];
    [mutDic setObject:startDate forKey:@"StartDate"];
    [mutDic setObject:endDate forKey:@"EndDate"];
    [mutDic setObject:orderStr forKey:@"OrderStr"];
    
    [[self getInstance] doPost:URL_PLAN_HOMEPAGE_PLAN withParams:mutDic requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (!error) {
            NSArray *planJsonArr = [dataDic objectForKey:@"PlanList"];
            NSMutableArray *contentArr = [[NSMutableArray alloc] init];
            for (NSDictionary *planDic in planJsonArr) {
                LCPlanModel *plan = [[LCPlanModel alloc] initWithDictionary:planDic];
                [contentArr addObject:plan];
            }
            
            NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
            callBack(contentArr, orderStr, error);
        } else {
            callBack(nil, nil, error);
        }
    }];
}

/// 首页达客接口.
+ (void)getHomepageDuckrs:(NSString *)localName withOrderStr:(NSString *)orderStr callBack:(void(^)(NSArray *storyArr, NSArray *duckrBoardArr, LCHomeCategoryModel *onlineCategory, LCHomeCategoryModel *cityCategory, NSArray *contentArr, NSString *orderStr, NSError *error))callBack {
    if ([LCStringUtil isNullString:orderStr]) {
        orderStr = @"";
    } else {
        [MobClick event:V5_HOMEPAGE_DUCKR_MORE_REQUEST];
    }
    if ([LCStringUtil isNullString:localName]) {
        localName = @"";
    }
    [[self getInstance] doPost:URL_PLAN_HOMEPAGE_DUCKR withParams:@{@"LocName":localName, @"OrderStr": orderStr} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (!error) {
            NSArray *storyJsonArr = [dataDic objectForKey:@"StoryList"];
            NSMutableArray *storyArr = [[NSMutableArray alloc] init];
            for (NSDictionary *storyDic in storyJsonArr) {
                LCHomeCategoryModel *category = [[LCHomeCategoryModel alloc] initWithDictionary:storyDic];
                [storyArr addObject:category];
            }
            
            NSArray *duckrBoardJsonArr = [dataDic objectForKey:@"DuckrBoradList"];
            NSMutableArray *duckrBoardArr = [[NSMutableArray alloc] init];
            for (NSDictionary *duckrBoardDic in duckrBoardJsonArr) {
                LCUserModel *user = [[LCUserModel alloc] initWithDictionary:duckrBoardDic];
                [duckrBoardArr addObject:user];
            }
            
            NSDictionary *onlineJsonDic = [dataDic objectForKey:@"OnlineDuckr"];
            LCHomeCategoryModel *onlineCategory = [[LCHomeCategoryModel alloc] initWithDictionary:onlineJsonDic];
            
            NSDictionary *cityJsonDic = [dataDic objectForKey:@"CityDuckr"];
            LCHomeCategoryModel *cityCategory = [[LCHomeCategoryModel alloc] initWithDictionary:cityJsonDic];
            
            NSArray *duckrJsonArr = [dataDic objectForKey:@"HotDuckrList"];
            NSMutableArray *contentArr = [[NSMutableArray alloc] init];
            for (NSDictionary *duckrDic in duckrJsonArr) {
                LCUserModel *user = [[LCUserModel alloc] initWithDictionary:duckrDic];
                [contentArr addObject:user];
            }

            NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
            callBack(storyArr, duckrBoardArr, onlineCategory, cityCategory, contentArr, orderStr, error);
        } else {
            callBack(nil, nil, nil, nil, nil, nil, error);
        }
    }];
}

/// 首页推荐-精选活动.
+ (void)getHomeRecmSelectedCostPlans:(NSString *)orderStr callBack:(void(^)(NSArray *contentArr, NSString *orderStr, NSError *error))callBack {
    if ([LCStringUtil isNotNullString:orderStr]) {
        [MobClick event:V5_HOMEPAGE_RECM_SELECTED_MORE_REQUEST];
    }
    orderStr = [LCStringUtil getNotNullStr:orderStr];
    
    [[self getInstance] doPost:URL_PLAN_HOMEPAGE_RECM_SELECTED withParams:@{@"OrderStr": orderStr} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (!error) {
            NSArray *planJsonArr = [dataDic objectForKey:@"PlanList"];
            NSMutableArray *contentArr = [[NSMutableArray alloc] init];
            for (NSDictionary *planDic in planJsonArr) {
                LCPlanModel *plan = [[LCPlanModel alloc] initWithDictionary:planDic];
                [contentArr addObject:plan];
            }
            
            NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
            callBack(contentArr, orderStr, error);
        } else {
            callBack(nil, nil, error);
        }
    }];
}

/// 首页推荐-本地玩乐.
+ (void)getHomeRecmLocalCostPlans:(NSString *)localName withOrderStr:(NSString *)orderStr callBack:(void(^)(NSArray *contentArr, NSString *orderStr, NSError *error))callBack {
    if ([LCStringUtil isNotNullString:orderStr]) {
        [MobClick event:V5_HOMEPAGE_RECM_LOCAL_MORE_REQUEST];
    }
    localName = [LCStringUtil getNotNullStr:localName];
    orderStr = [LCStringUtil getNotNullStr:orderStr];
    
    [[self getInstance] doPost:URL_PLAN_HOMEPAGE_RECM_LOCAL withParams:@{@"LocName": localName, @"OrderStr": orderStr} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (!error) {
            NSArray *planJsonArr = [dataDic objectForKey:@"PlanList"];
            NSMutableArray *contentArr = [[NSMutableArray alloc] init];
            for (NSDictionary *planDic in planJsonArr) {
                LCPlanModel *plan = [[LCPlanModel alloc] initWithDictionary:planDic];
                [contentArr addObject:plan];
            }
            
            NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
            callBack(contentArr, orderStr, error);
        } else {
            callBack(nil, nil, error);
        }
    }];
}

/// 首页推荐-热门旅图.
+ (void)getHomeRecmHotTourpics:(NSString *)orderStr callBack:(void(^)(NSArray *contentArr, NSString *orderStr, NSError *error))callBack {
    orderStr = [LCStringUtil getNotNullStr:orderStr];
    [[self getInstance] doPost:URL_PLAN_HOMEPAGE_RECM_HOT_TOURPICS withParams:@{@"OrderStr": orderStr} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                NSMutableArray *mutArr = [[NSMutableArray alloc] init];
                NSArray *tourpicJsonArr = [dataDic objectForKey:@"TourPicList"];
                NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
                for (NSDictionary *dic in tourpicJsonArr) {
                    LCTourpic *tourpic = [[LCTourpic alloc] initWithDictionary:dic];
                    if (nil != tourpic) {
                        [mutArr addObject:tourpic];
                    }
                }
                callBack(mutArr, orderStr, error);
            } else {
                callBack(nil, @"", error);
            }
        }
    }];
}

/// 首页推荐-在线达客.
+ (void)getHomeRecmOnlineDuckrs:(NSString *)orderStr callBack:(void(^)(NSArray *contentArr, NSString *orderStr, NSError *error))callBack {
    [[self getInstance] doPost:URL_PLAN_HOMEPAGE_RECM_ONLINE_DUCKRS withParams:@{@"OrderStr": orderStr} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                NSMutableArray *mutArr = [[NSMutableArray alloc] init];
                NSArray *userJsonArr = [dataDic objectForKey:@"UserList"];
                NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
                for (NSDictionary *dic in userJsonArr) {
                    LCUserModel *user = [[LCUserModel alloc] initWithDictionary:dic];
                    if (nil != user) {
                        [mutArr addObject:user];
                    }
                }
                callBack(mutArr, orderStr, error);
            } else {
                callBack(nil, nil, error);
            }
        }
    }];
}

/// 首页推荐-在线达客—正在发生.
+ (void)getHomeRecmOnlineHappens:(NSString *)orderStr callBack:(void(^)(NSArray *contentArr, NSString *orderStr, NSError *error))callBack {
    [[self getInstance] doPost:URL_PLAN_HOMEPAGE_RECM_ONLINE_HAPPENS withParams:@{@"OrderStr": orderStr} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (nil != dataDic) {
                NSArray *tourpicJsonArr = [dataDic objectForKey:@"TourPicList"];
                NSArray *planJsonArr = [dataDic objectForKey:@"PlanList"];
                NSArray *mixedJsonArr = [dataDic objectForKey:@"MixedList"];
                
                NSMutableArray *contentArr = [[NSMutableArray alloc] init];
                NSInteger tourpicIndex = 0;
                NSInteger planIndex = 0;
                for (NSInteger i = 0; i < mixedJsonArr.count; ++i) {
                    NSInteger mark = [LCStringUtil idToNSInteger:[mixedJsonArr objectAtIndex:i]];
                    if (LCNetRequesterType_Tourpic == mark && tourpicIndex < tourpicJsonArr.count) {
                        LCTourpic *tourpic = [[LCTourpic alloc] initWithDictionary:[tourpicJsonArr objectAtIndex:tourpicIndex]];
                        [contentArr addObject:tourpic];
                        tourpicIndex++;
                    } else if (LCNetRequesterType_Plan == mark && planIndex < planJsonArr.count) {
                        LCPlanModel *plan = [[LCPlanModel alloc] initWithDictionary:[planJsonArr objectAtIndex:planIndex]];
                        [contentArr addObject:plan];
                        planIndex++;
                    }
                }
                
                NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
                callBack(contentArr, orderStr, error);
            } else {
                callBack(nil, nil, error);
            }
        }
    }];
}
/**
 * 排行榜
 */
+ (void)getHomepageDuckrBroadList:(NSString *)orderString callBack:(void(^)(NSArray *userList, NSString *orderStr, NSError *error))callBack {
    NSString * orderStr = [LCStringUtil getNotNullStr:orderString];
    [[self getInstance] doPost:URL_GET_HOMEPAGE_DUCKR_BOARD_LIST withParams:@{@"OrderStr": orderStr} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (nil != dataDic) {
               
                NSArray *userListArr = [dataDic objectForKey:@"DurkrBoradList"];
                
                NSMutableArray *contentArr = [[NSMutableArray alloc] init];

                for (NSInteger i = 0; i < userListArr.count; ++i) {
                    NSDictionary * dic = [userListArr objectAtIndex:i];
                    LCUserModel * model = [[LCUserModel alloc] initWithDictionary:dic];
                    [contentArr addObject:model];
                }
                
                NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
                callBack(contentArr, orderStr, error);
            } else {
                callBack(nil, nil, error);
            }
        }
    }];
    
}

///首页推荐-同城达客。
+ (void)getHomeRecmLocalDuckrs:(NSString *)orderStr callBack:(void(^)(NSArray *contentArr, NSString *orderStr, NSError *error))callBack {
    NSString *locName = @"";
    if (nil != [LCDataManager sharedInstance].currentCity) {
        locName = [LCDataManager sharedInstance].currentCity.cityName;
    }
    double lng = [LCDataManager sharedInstance].userLocation.lng;
    double lat = [LCDataManager sharedInstance].userLocation.lat;
    locName = [LCStringUtil getNotNullStr:locName];
    NSString *lngStr = [NSString stringWithFormat:@"%f", lng];
    NSString *latStr = [NSString stringWithFormat:@"%f", lat];
    orderStr = [LCStringUtil getNotNullStr:orderStr];
    [[self getInstance] doPost:URL_PLAN_HOMEPAGE_RECM_LOCAL_DUCKRS withParams:@{@"LocName":locName, @"Lng":lngStr, @"Lat":latStr, @"OrderStr":orderStr} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (nil != dataDic) {
                NSArray *userJsonArr = [dataDic objectForKey:@"UserList"];
                NSArray *mixedJsonArr = [dataDic objectForKey:@"MixedList"];
                
                NSMutableArray *contentArr = [[NSMutableArray alloc] init];
                NSInteger userIndex = 0;
                for (NSInteger i = 0; i < mixedJsonArr.count; ++i) {
                    NSInteger mark = [LCStringUtil idToNSInteger:[mixedJsonArr objectAtIndex:i]];
                    if (i < userJsonArr.count) {
                    LCUserModel *user = [[LCUserModel alloc] initWithDictionary:[userJsonArr objectAtIndex:userIndex]];
                    user.localStatus = mark;
                    [contentArr addObject:user];
                    userIndex++;
                    }
                }
                
                NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
                callBack(contentArr, orderStr, error);
            } else {
                callBack(nil, nil, error);
            }
        }
    }];
}

///首页推荐-同城达客动态。
+ (void)getHomeRecmLocalDuckrsPlan:(NSString *)orderStr localName:(NSString *)localName  callBack:(void(^)(NSArray *contentArr, NSString *orderStr, NSError *error))callBack {
    orderStr = [LCStringUtil getNotNullStr:orderStr];
    [[self getInstance] doPost:URL_PLAN_HOMEPAGE_RECM_LOCAL_DUCKRS_PLAN withParams:@{@"OrderStr": orderStr} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (nil != dataDic) {
                NSArray *tourpicJsonArr = [dataDic objectForKey:@"TourPicList"];
                NSArray *planJsonArr = [dataDic objectForKey:@"PlanList"];
                NSArray *mixedJsonArr = [dataDic objectForKey:@"MixedList"];
                
                NSMutableArray *contentArr = [[NSMutableArray alloc] init];
                NSInteger tourpicIndex = 0;
                NSInteger planIndex = 0;
                for (NSInteger i = 0; i < mixedJsonArr.count; ++i) {
                    NSInteger mark = [LCStringUtil idToNSInteger:[mixedJsonArr objectAtIndex:i]];
                    if (LCNetRequesterType_Tourpic == mark && tourpicIndex < tourpicJsonArr.count) {
                        LCTourpic *tourpic = [[LCTourpic alloc] initWithDictionary:[tourpicJsonArr objectAtIndex:tourpicIndex]];
                        [contentArr addObject:tourpic];
                        tourpicIndex++;
                    } else if (LCNetRequesterType_Plan == mark && planIndex < planJsonArr.count) {
                        LCPlanModel *plan = [[LCPlanModel alloc] initWithDictionary:[planJsonArr objectAtIndex:planIndex]];
                        [contentArr addObject:plan];
                        planIndex++;
                    }
                }
                
                NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
                callBack(contentArr, orderStr, error);
            } else {
                callBack(nil, nil, error);
            }
        }
    }];
}


@end
