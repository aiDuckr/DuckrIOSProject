//
//  LCNetRequester+Local.m
//  LinkCity
//
//  Created by linkcity on 16/8/3.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCNetRequester+Local.h"
@implementation LCNetRequester (Local)

+ (void)requestLocalList:(NSString *)orderStr themeId:(NSInteger)themeId sex:(NSInteger)sex orderType:(NSInteger)type withCallBack:(void(^)(NSArray *contentArr, NSString *orderStr, NSError *error))callBack {
    NSString *themeIdStr = [LCStringUtil integerToString:themeId];
    NSString *sexStr = [LCStringUtil integerToString:sex];
    NSString *typeStr = [LCStringUtil integerToString:type];

    orderStr = [LCStringUtil getNotNullStr:orderStr];
    NSString *lngStr = @"";
    NSString *latStr = @"";
    if (nil != [LCDataManager sharedInstance].userLocation) {
        lngStr = [NSString stringWithFormat:@"%f", [LCDataManager sharedInstance].userLocation.lng];
        latStr = [NSString stringWithFormat:@"%f", [LCDataManager sharedInstance].userLocation.lat];
    }
    [[self getInstance] doPost:URL_LOCAL_LIST withParams:@{@"ThemeId":themeIdStr,@"OrderType": typeStr,@"Lng": lngStr, @"Lat": latStr,@"Sex": sexStr, @"OrderStr": orderStr} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (!error) {
            NSArray *contentJsonArr = [dataDic objectForKey:@"UserList"];
            NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
            
            NSMutableArray *contentArr = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in contentJsonArr) {
                LCUserModel *model = [[LCUserModel alloc] initWithDictionary:dic];
//                if (NO == [model isEmptyPlan]) {
                    [contentArr addObject:model];
//                }
            }
            
            callBack(contentArr, orderStr, error);
        } else {
            callBack( nil, nil, error);
        }
    }];
}


+ (void)requestToJoinLocalwiththemeId:(NSInteger)themeId ThemeStr:(NSString*)themeStr withCallBack:(void(^)(NSArray *contentArr,NSError *error))callBack {
    NSString *themeIdStr = [LCStringUtil integerToString:themeId];//NSInteger 转NSString
    themeStr=[LCStringUtil getNotNullStr:themeStr];//判断是否为空，若为空则返回“”形式的空字符串
    themeIdStr=[LCStringUtil getNotNullStr:themeIdStr];

    NSString *lngStr = @"";
    NSString *latStr = @"";
    if (nil != [LCDataManager sharedInstance].userLocation) {
        lngStr = [NSString stringWithFormat:@"%f", [LCDataManager sharedInstance].userLocation.lng];
        latStr = [NSString stringWithFormat:@"%f", [LCDataManager sharedInstance].userLocation.lat];
    }
    [[self getInstance] doPost:URL_LOCAL_JOIN withParams:@{@"ThemeId":themeIdStr,@"ThemeStr": themeStr,@"Lng": lngStr, @"Lat": latStr} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (!error) {
            NSArray *contentJsonArr = [dataDic objectForKey:@"Data"];
            
            NSMutableArray *contentArr = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in contentJsonArr) {
                LCUserModel *model = [[LCUserModel alloc] initWithDictionary:dic];
                //                if (NO == [model isEmptyPlan]) {
                [contentArr addObject:model];
                //                }
            }
            
            callBack(contentArr, error);
        } else {
            callBack( nil, error);
        }
    }];
}

+ (void)requestLocalTrades:(NSString *)orderStr withCallBack:(void(^)(NSArray *rcmdArr, NSArray *contentArr, NSString *orderStr, NSError *error))callBack {
    orderStr = [LCStringUtil getNotNullStr:orderStr];
    
    [[self getInstance] doPost:URL_LOCAL_TRADE withParams:@{@"OrderStr": orderStr} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (!error) {
            NSArray *rcmdJsonArr = [dataDic objectForKey:@"RcmdList"];
            NSArray *planJsonArr = [dataDic objectForKey:@"HotPlanList"];
            NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
            
            NSMutableArray *rcmdArr = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in rcmdJsonArr) {
                LCHomeRcmd *model = [[LCHomeRcmd alloc] initWithDictionary:dic];
                if ([model isValidHomeRcmd]) {
                    [rcmdArr addObject:model];//返回的数据中RcmdList里面的PlanList为空。。
                }
            }
            
            NSMutableArray *contentArr = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in planJsonArr) {
                LCPlanModel *model = [[LCPlanModel alloc] initWithDictionary:dic];
                if (NO == [model isEmptyPlan]) {
                    [contentArr addObject:model];
                }
            }
            
            callBack(rcmdArr, contentArr, orderStr, error);
        } else {
            callBack(nil, nil, nil, error);
        }
    }];
}

+ (void)requestLocalInvites:(NSString *)orderStr themeId:(NSInteger)themeId sex:(NSInteger)sex orderType:(NSInteger)type withCallBack:(void(^)(NSArray *contentArr, NSString *orderStr, NSError *error))callBack {
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
    
    [[self getInstance] doPost:URL_LOCAL_INVITE withParams:@{@"Lng": lngStr, @"Lat": latStr, @"ThemeId": themeIdStr, @"Sex": sexStr, @"OrderType": typeStr, @"OrderStr": orderStr} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
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
+ (void)requestThemeCalendar:(NSArray *)dateArr priceArr:(NSArray *)priceArr themeID:(NSInteger )themeId OrderType:(NSString*)orderType orderStr:(NSString *)orderStr withCallBack:(void(^)(NSArray *contentArr, NSString *orderStr, NSError *error))callBack{
    NSString *dateStr = [LCStringUtil getJsonStrFromArray:dateArr];
    NSString *priceStr = [LCStringUtil getJsonStrFromArray:priceArr];
    NSString *themeStr = [LCStringUtil integerToString:themeId];
    orderStr = [LCStringUtil getNotNullStr:orderStr];
    orderType=[LCStringUtil getNotNullStr:orderType];
    [[self getInstance] doPost:URL_LOCAL_THEME_CALENDAR withParams:@{@"DateList": dateStr, @"PriceList": priceStr, @"ThemeId": themeStr,@"OrderType":orderType, @"OrderStr": orderStr} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
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
@end
