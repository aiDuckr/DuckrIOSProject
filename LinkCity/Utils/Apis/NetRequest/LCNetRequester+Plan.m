//
//  LCNetRequester+Plan.m
//  LinkCity
//
//  Created by Roy on 6/27/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCNetRequester+Plan.h"

@implementation LCNetRequester (Plan)

#pragma mark Plan
+ (void)sendPlan:(LCPlanModel *)plan
        callBack:(void(^)(LCPlanModel *planSent, NSError *error))callBack{
    
    NSMutableDictionary *paramDic = [plan getDicForNetRequest];
    LCNetLogInfo(@"SendPlanParamDic:%@",paramDic);
    [[self getInstance] doPost:URL_SEND_FREE_PLAN withParams:paramDic
               requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error)
     {
         if (callBack) {
             if (dataDic) {
                 LCPlanModel *planModel = [[LCPlanModel alloc] initWithDictionary:[dataDic objectForKey:@"PartnerPlan"]];
                 callBack(planModel,error);
             }else{
                 callBack(nil,error);
             }
         }
     }];
}

+ (void)getRouteForSendPlan:(NSString *)departName
                  destNames:(NSArray *)destNames
                  startTime:(NSString *)startTimeStr
                    endTime:(NSString *)endTimeStr
                   daysLong:(NSInteger)daysLong
                   orderStr:(NSString *)orderStr
                   callBack:(void (^)(NSArray *, NSString *, NSError *))callBack
{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    
    if ([LCStringUtil isNotNullString:departName]) {
        [paramDic setObject:departName forKey:@"DepartName"];
    }
    
    if (destNames.count > 0) {
        NSString *departNamesStr = [LCStringUtil getJsonStrFromArray:destNames];
        if ([LCStringUtil isNotNullString:departNamesStr]) {
            [paramDic setObject:departNamesStr forKey:@"DestinationNames"];
        }
    }
    
    if ([LCStringUtil isNotNullString:startTimeStr]) {
        [paramDic setObject:startTimeStr forKey:@"StartTime"];
    }
    
    if ([LCStringUtil isNotNullString:endTimeStr]) {
        [paramDic setObject:endTimeStr forKey:@"EndTime"];
    }
    
    if (daysLong > 0) {
        [paramDic setObject:[NSNumber numberWithInteger:daysLong] forKey:@"DaysLong"];
    }
    
    if ([LCStringUtil isNotNullString:orderStr]) {
        [paramDic setObject:orderStr forKey:@"OrderStr"];
    }
    
    
    
    [[self getInstance] doPost:URL_GET_ROUTE_FRO_SEND_PLAN withParams:paramDic requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                NSMutableArray *routeArray = [[NSMutableArray alloc] init];
                for (NSDictionary *routeDic in [dataDic arrayForKey:@"Routes"]){
                    LCUserRouteModel *aRoute = [[LCUserRouteModel alloc] initWithDictionary:routeDic];
                    if (aRoute) {
                        [routeArray addObject:aRoute];
                    }
                }
                
                NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
                
                callBack(routeArray, orderStr, error);
            }else{
                callBack(nil, nil, error);
            }
        }
    }];
}

+ (void)getRecommendOfPlan:(NSString *)planGuid callBack:(void (^)(NSArray *, NSArray *, NSArray *, NSError *))callBack{
    if ([LCStringUtil isNullString:planGuid]) {
        if (callBack) {
            callBack(nil,nil,nil,[NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        return;
    }
    
    [[self getInstance] doPost:URL_RECOMMEND_OF_PLAN withParams:@{@"PlanGuid":planGuid} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                NSMutableArray *userArray = [[NSMutableArray alloc] init];
                for (NSDictionary *userDic in [dataDic arrayForKey:@"UserList"]){
                    LCUserModel *user = [[LCUserModel alloc] initWithDictionary:userDic];
                    if (user) {
                        [userArray addObject:user];
                    }
                }
                
                NSMutableArray *planArray = [[NSMutableArray alloc] init];
                for (NSDictionary *planDic in [dataDic arrayForKey:@"PlanList"]){
                    LCPlanModel *plan = [[LCPlanModel alloc] initWithDictionary:planDic];
                    if (plan) {
                        [planArray addObject:plan];
                    }
                }
                
                NSMutableArray *webPlanArray = [[NSMutableArray alloc] init];
                for (NSDictionary *webPlanDic in [dataDic arrayForKey:@"WebPlanList"]){
                    LCWebPlanModel *webPlan = [[LCWebPlanModel alloc] initWithDictionary:webPlanDic];
                    if (webPlan) {
                        [webPlanArray addObject:webPlan];
                    }
                }
                
                callBack(userArray,planArray,webPlanArray,error);
            }else{
                callBack(nil,nil,nil,error);
            }
        }
    }];
}

+ (void)getCreatedPlansOfUser:(NSString *)uuid
                  orderString:(NSString *)orderString
                     callBack:(void (^)(NSArray *, NSString *orderStr, NSError *))callBack{
    if ([LCStringUtil isNullString:uuid]) {
        if (callBack) {
            callBack(nil, nil, [NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        
        return;
    }
    
    NSDictionary *param = nil;
    if ([LCStringUtil isNotNullString:orderString]) {
        param = @{@"UserUUID":uuid,
                  @"OrderStr":orderString};
    }else{
        param = @{@"UserUUID":uuid};
    }
    
    [[self getInstance] doPost:URL_GET_CREATED_PLAN_OFUSER
                    withParams:param
               requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error)
     {
         if (callBack) {
             if (dataDic) {
                 NSMutableArray *planArray = [[NSMutableArray alloc] initWithCapacity:0];
                 NSArray *planDicArray = [dataDic arrayForKey:@"PlanList"];
                 for (NSDictionary *planDic in planDicArray){
                     LCPlanModel *aPlan = [[LCPlanModel alloc] initWithDictionary:planDic];
                     if (aPlan) {
                         [planArray addObject:aPlan];
                     }
                 }
                 
                 NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
                 callBack(planArray, orderStr, error);
             }else{
                 callBack(nil, nil, error);
             }
         }
     }];
}
+ (void)getJoinedPlansOfUser:(NSString *)uuid
                 orderString:(NSString *)orderString
                    callBack:(void (^)(NSArray *, NSString *orderStr, NSError *))callBack{
    if ([LCStringUtil isNullString:uuid]) {
        if (callBack) {
            callBack(nil, nil, [NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        
        return;
    }
    
    NSDictionary *param = nil;
    if ([LCStringUtil isNotNullString:orderString]) {
        param = @{@"UserUUID":uuid,
                  @"OrderStr":orderString};
    }else{
        param = @{@"UserUUID":uuid};
    }
    
    [[self getInstance] doPost:URL_GET_JOINED_PLAN_OFUSER
                    withParams:param
               requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error)
     {
         if (callBack) {
             if (dataDic) {
                 NSMutableArray *planArray = [[NSMutableArray alloc] initWithCapacity:0];
                 NSArray *planDicArray = [dataDic arrayForKey:@"PlanList"];
                 for (NSDictionary *planDic in planDicArray){
                     LCPlanModel *aPlan = [[LCPlanModel alloc] initWithDictionary:planDic];
                     if (aPlan) {
                         [planArray addObject:aPlan];
                     }
                 }
                 
                 NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
                 callBack(planArray, orderStr, error);
             }else{
                 callBack(nil, nil, error);
             }
         }
     }];
}

+ (void)getFavoredPlansWithOrderString:(NSString *)orderString callBack:(void (^)(NSArray *, NSString *, NSError *))callBack{
    NSDictionary *param = nil;
    if ([LCStringUtil isNotNullString:orderString]) {
        param = @{@"OrderStr":orderString};
    }
    
    [[self getInstance] doPost:URL_GET_FAVORED_PLAN_OFUSER
                    withParams:param
               requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error)
     {
         if (callBack) {
             if (dataDic) {
                 NSMutableArray *planArray = [[NSMutableArray alloc] initWithCapacity:0];
                 NSArray *planDicArray = [dataDic arrayForKey:@"PlanList"];
                 for (NSDictionary *planDic in planDicArray){
                     LCPlanModel *aPlan = [[LCPlanModel alloc] initWithDictionary:planDic];
                     if (aPlan) {
                         [planArray addObject:aPlan];
                     }
                 }
                 
                 NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
                 callBack(planArray, orderStr, error);
             }else{
                 callBack(nil, nil, error);
             }
         }
     }];
}

+ (void)getUserPlanHelperListWithCallBack:(void (^)(NSArray *, NSArray *, NSError *))callBack{
    [[self getInstance] doGet:URL_GET_USER_PLAN_HELPER_LIST withParams:nil requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                NSMutableArray *byJoinedPlanList = [[NSMutableArray alloc] initWithCapacity:0];
                for (NSDictionary *planDic in [dataDic arrayForKey:@"ByJoinedPlanList"]){
                    LCPlanModel *aPlan = [[LCPlanModel alloc] initWithDictionary:planDic];
                    if (aPlan) {
                        [byJoinedPlanList addObject:aPlan];
                    }
                }
                
                NSMutableArray *byWantGoPlanList = [[NSMutableArray alloc] initWithCapacity:0];
                for (NSDictionary *planDic in [dataDic arrayForKey:@"ByWantGoPlanList"]){
                    LCPlanModel *aPlan = [[LCPlanModel alloc] initWithDictionary:planDic];
                    if (aPlan) {
                        [byWantGoPlanList addObject:aPlan];
                    }
                }
                
                callBack(byJoinedPlanList, byWantGoPlanList, error);
            }else{
                callBack(nil, nil, error);
            }
        }
    }];
}
//+ (void)thumbPlanFromPlanGuid:(NSString *)planGuid

+ (void)getPlanDetailFromPlanGuid:(NSString *)planGuid
                         callBack:(void(^)(LCPlanModel *plan,NSArray * tourpicArray, NSError *error))callBack{
    if ([LCStringUtil isNullString:planGuid]) {
        if (callBack) {
            callBack(nil,nil, [NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        return;
    }
    
    [[self getInstance] doGet:URL_GET_PLAN_DETAIL
                   withParams:@{@"PlanGuid":planGuid}
              requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error)
     {
         if (callBack) {
             if (!error) {
                 NSDictionary *planDic = [dataDic dicOfObjectForKey:@"PartnerPlan"];
                 LCPlanModel *plan = [[LCPlanModel alloc] initWithDictionary:planDic];
                 NSArray *tourpicArray = [dataDic arrayForKey:@"TourPicList"];
                 if (plan) {
                     [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPlanModelUpdate object:nil userInfo:@{NotificationPlanModelKey:plan}];
                 }
                 
                 callBack(plan,tourpicArray,error);
             } else {
                 callBack(nil,nil,error);
             }
         }
     }];
}

+ (void)getPlanJoinedUserListFromPlanGuid:(NSString *)planGuid callBack:(void (^)(NSArray *, NSDecimalNumber *totalStageIncome, NSError *))callBack{
    if ([LCStringUtil isNullString:planGuid]) {
        if (callBack) {
            callBack(nil, nil, [NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        return;
    }
    
    [[self getInstance] doPost:URL_GET_PLAN_JOINED_USERLIST withParams:@{@"PlanGuid":planGuid} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                NSMutableArray *stageArray = [NSMutableArray new];
                for (NSDictionary *dic in [dataDic arrayForKey:@"Stage"]){
                    LCPartnerStageModel *aStage = [[LCPartnerStageModel alloc] initWithDictionary:dic];
                    if (aStage) {
                        [stageArray addObject:aStage];
                    }
                }
                
                NSDecimalNumber *totalStageIncome = [NSDecimalNumber decimalNumberWithDecimal:[[dataDic objectForKey:@"TotalStageEarnest"]decimalValue]];
                totalStageIncome = [LCDecimalUtil getTwoDigitRoundDecimal:totalStageIncome];
                
                callBack(stageArray, totalStageIncome, error);
            }else{
                callBack(nil, nil, error);
            }
        }
    }];
}

+ (void)searchPlanByDestination:(NSString *)dest
                       PlanType:(NSInteger)planType
                     DepartName:(NSString *)departName
                      StartDate:(NSString *)startDate
                        endDate:(NSString *)endDate
                    orderString:(NSString *)orderString
                       callBack:(void (^)(NSArray *, NSString *, NSError *))callBack {
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    if ([LCStringUtil isNotNullString:orderString]) {
        [param setObject:orderString forKey:@"OrderStr"];
    }
    if ([LCStringUtil isNotNullString:dest]) {
        [param setObject:dest forKey:@"DestName"];
    }
    if ([LCStringUtil isNotNullString:departName]) {
        [param setObject:departName forKey:@"DepartName"];
    }
    
    if ([LCStringUtil isNotNullString:startDate]) {
        [param setObject:startDate forKey:@"StartDate"];
    }
    if ([LCStringUtil isNotNullString:endDate]) {
        [param setObject:endDate forKey:@"EndDate"];
    }
    
    if (planType) {
        [param setObject:[NSNumber numberWithInteger:planType] forKey:@"PlanType"];
    }
    
    [[self getInstance] doPost:URL_V5_SEARCH_PLAN
                    withParams:param
               requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error)
     {
         [MobClick event:V5_HOMEPAGE_SEARCH_REQUEST];
         if (callBack) {
             if (dataDic) {
                 NSMutableArray *planArray = [[NSMutableArray alloc] initWithCapacity:0];
                 NSArray *planDicArray = [dataDic arrayForKey:@"PlanList"];
                 NSArray *planTypeArray = [dataDic arrayForKey:@"MixedList"];
                 NSInteger index = 0;
                 for (NSDictionary *planDic in planDicArray){
                     if (planTypeArray.count > index) {
                         if ([[planTypeArray objectAtIndex:index] integerValue] == 1) {
                             LCWebPlanModel *model = [[LCWebPlanModel alloc] initWithDictionary:planDic];
                             if (model) {
                                 [planArray addObject:model];
                             }
                         } else {
                             LCPlanModel *model = [[LCPlanModel alloc] initWithDictionary:planDic];
                             if (model) {
                                 [planArray addObject:model];
                             }
                             
                         }
                     }
                 }
                 
                 NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
                 callBack(planArray, orderStr, error);
             }else{
                 callBack(nil, nil, error);
             }
         }
     }];
    
    //
    //URL_V5_SEARCH_PLAN
    //
    
}
+ (void)searchPlanByDestination:(NSString *)dest
                    orderString:(NSString *)orderString
                       callBack:(void(^)(NSArray *plans, NSString *orderStr, NSError *error))callBack{
    
    NSDictionary *param = nil;
    if ([LCStringUtil isNotNullString:orderString]) {
        param = @{@"DestName":dest,
                  @"OrderStr":orderString};
    }else{
        param = @{@"DestName":dest};
    }
    
    [[self getInstance] doPost:URL_SEARCH_PLAN_BY_DESTINATION
                    withParams:param
               requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error)
     {
         if (callBack) {
             if (dataDic) {
                 NSMutableArray *planArray = [[NSMutableArray alloc] initWithCapacity:0];
                 NSArray *planDicArray = [dataDic arrayForKey:@"PlanList"];
                 for (NSDictionary *planDic in planDicArray){
                     LCPlanModel *aPlan = [[LCPlanModel alloc] initWithDictionary:planDic];
                     if (aPlan) {
                         [planArray addObject:aPlan];
                     }
                 }
                 
                 NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
                 callBack(planArray, orderStr, error);
             }else{
                 callBack(nil, nil, error);
             }
         }
     }];
}

+ (void)searchDestinationFromHomePage:(NSString *)dest callBack:(void(^)(NSArray *weatherArray, NSArray *routeArray, NSArray *tourpicArray, NSArray *planArray, LCDestinationPlaceModel *place, NSError *error))callBack {
    if ([LCStringUtil isNullString:dest]) {
        return ;
    }
    [[self getInstance] doPost:URL_SEARCH_DESTINATION_FROM_HOMEPAGE
                    withParams:@{@"DestName": dest}
               requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                LCDestinationPlaceModel *place = [[LCDestinationPlaceModel alloc] initWithDictionary:[dataDic objectForKey:@"Place"]];
                
                NSMutableArray *weatherArray = [[NSMutableArray alloc] initWithCapacity:0];
                NSArray *weatherDicArray = [dataDic objectForKey:@"WeatherData"];
                for (NSDictionary *dic in weatherDicArray) {
                    LCWeatherDay *weatherDay = [[LCWeatherDay alloc] initWithDictionary:dic];
                    [weatherArray addObject:weatherDay];
                }
                
                NSMutableArray *routeArray = [[NSMutableArray alloc] initWithCapacity:0];
                NSArray *routeDicArray = [dataDic objectForKey:@"RouteList"];
                for (NSDictionary *dic in routeDicArray) {
                    LCUserRouteModel *route = [[LCUserRouteModel alloc] initWithDictionary:dic];
                    [routeArray addObject:route];
                }
                
                NSMutableArray *tourpicArray = [[NSMutableArray alloc] initWithCapacity:0];
                NSArray *tourpicDicArray = [dataDic objectForKey:@"TourPicList"];
                for (NSDictionary *dic in tourpicDicArray) {
                    LCTourpic *tourpic = [[LCTourpic alloc] initWithDictionary:dic];
                    [tourpicArray addObject:tourpic];
                }
                
                NSArray *typeArray = [dataDic arrayForKey:@"MixedList"];
                NSArray *planDicArray = [dataDic arrayForKey:@"PlanList"];
                NSMutableArray *planArray = [[NSMutableArray alloc] init];
                
                if (typeArray.count != planDicArray.count) {
                    LCLogError(@"searchMixPlanForDestionation error, data doesn't match");
                    
                } else {
                    for (int i = 0; i < typeArray.count; i++) {
                        if (0 == [typeArray[i] integerValue]) {
                            LCPlanModel *plan = [[LCPlanModel alloc] initWithDictionary:planDicArray[i]];
                            if (plan) {
                                [planArray addObject:plan];
                            }
                        } else if(1 == [typeArray[i] integerValue]) {
                            LCWebPlanModel *webPlan = [[LCWebPlanModel alloc] initWithDictionary:planDicArray[i]];
                            if (webPlan) {
                                [planArray addObject:webPlan];
                            }
                        }
                    }
                }
                callBack(weatherArray, routeArray, tourpicArray, planArray, place, error);
            } else {
                callBack(nil, nil, nil, nil, nil, error);
            }
        }
    }];
}

+ (void)searchPlanByTheme:(NSInteger)themeID
              orderString:(NSString *)orderString
                 callBack:(void (^)(NSArray *, NSString *orderStr, NSError *))callBack{
    
    NSDictionary *param = nil;
    if ([LCStringUtil isNotNullString:orderString]) {
        param = @{@"ThemeId":[NSNumber numberWithInteger:themeID],
                  @"OrderStr":orderString};
    }else{
        param = @{@"ThemeId":[NSNumber numberWithInteger:themeID]};
    }
    
    [[self getInstance] doPost:URL_SEARCH_PLAN_BY_THEME
                    withParams:param
               requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error)
     {
         if (callBack) {
             if (dataDic) {
                 NSMutableArray *planArray = [[NSMutableArray alloc] initWithCapacity:0];
                 NSArray *planDicArray = [dataDic arrayForKey:@"PlanList"];
                 for (NSDictionary *planDic in planDicArray){
                     LCPlanModel *aPlan = [[LCPlanModel alloc] initWithDictionary:planDic];
                     if (aPlan) {
                         [planArray addObject:aPlan];
                     }
                 }
                 
                 NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
                 callBack(planArray, orderStr, error);
             }else{
                 callBack(nil, nil, error);
             }
         }
     }];
}

+ (void)getNearbyPlanByLocation:(LCUserLocation *)location
                           skip:(NSInteger)skipNum
                      orderType:(LCPlanOrderType)orderType
                        locName:(NSString *)locName
                       callBack:(void (^)(NSArray *, NSArray *, NSError *))callBack{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    if (location) {
        [param setObject:[NSString stringWithFormat:@"%f",location.lng] forKey:@"Long"];
        [param setObject:[NSString stringWithFormat:@"%f",location.lat] forKey:@"Lat"];
        NSInteger type = (NSInteger)location.type;
        [param setObject:[NSString stringWithFormat:@"%ld",(long)type] forKey:@"LocType"];
    }
    
    [param setObject:[NSString stringWithFormat:@"%ld",(long)skipNum] forKey:@"Skip"];
    [param setObject:[NSString stringWithFormat:@"%ld",(long)orderType] forKey:@"SortType"];
    
    if ([LCStringUtil isNotNullString:locName]) {
        [param setObject:locName forKey:@"LocName"];
    }
    
    [[self getInstance] doPost:URL_GET_NEARBY_PLAN withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                NSMutableArray *planArray = [[NSMutableArray alloc] init];
                for (NSDictionary *planDic in [dataDic arrayForKey:@"PlanList"]){
                    if ([planDic isKindOfClass:[NSDictionary class]]) {
                        LCPlanModel *aPlan = [[LCPlanModel alloc] initWithDictionary:planDic];
                        if (aPlan) {
                            [planArray addObject:aPlan];
                        }
                    }
                }
                
                NSMutableArray *webPlanArray = [[NSMutableArray alloc] init];
                for (NSDictionary *webPlanDic in [dataDic arrayForKey:@"WebPlanList"]){
                    if ([webPlanDic isKindOfClass:[NSDictionary class]]) {
                        LCWebPlanModel *aWebPlan = [[LCWebPlanModel alloc] initWithDictionary:webPlanDic];
                        if (aWebPlan) {
                            [webPlanArray addObject:aWebPlan];
                        }
                    }
                }
                
                callBack(planArray, webPlanArray, error);
            }else{
                callBack(nil, nil, error);
            }
        }
    }];
}

+ (void)addCommentToPlan:(NSString *)planGuid
                 content:(NSString *)content
               replyToId:(NSInteger)replyToId
                   score:(NSInteger)score
                withType:(NSString *)type
                callBack:(void (^)(LCCommentModel *, NSError *))callBack{
    
    if ([LCStringUtil isNullString:planGuid]) {
        // wrong input
        if (callBack) {
            callBack(nil, [NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        return;
    }
    
    NSString *scoreStr = [NSString stringWithFormat:@"%ld", (long)score];
    NSDictionary *param = @{@"PlanGuid":planGuid,
                            @"Content":content,
                            @"ReplyToId":[NSNumber numberWithInteger:replyToId],
                            @"Score":scoreStr,
                            @"Type":type};
    [[self getInstance] doPost:URL_ADD_COMMENT_TO_PLAN
                    withParams:param
               requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error)
     {
         if (callBack) {
             if (dataDic) {
                 LCCommentModel *comment = [[LCCommentModel alloc] initWithDictionary:[dataDic dicOfObjectForKey:@"PlanComment"]];
                 callBack(comment,error);
             }else{
                 callBack(nil,error);
             }
         }
     }];
    
}

+ (void)getCommentOfPlan:(NSString *)planGuid corderString:(NSString *)orderString callBack:(void (^)(NSArray *, NSString *, NSError *))callBack{
    if ([LCStringUtil isNullString:planGuid]) {
        callBack(nil,nil,[NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        return;
    }
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithCapacity:0];
    [param setObject:planGuid forKey:@"PlanGuid"];
    
    if ([LCStringUtil isNotNullString:orderString]) {
        [param setObject:orderString forKey:@"OrderStr"];
    }
    
    [[self getInstance] doPost:URL_GET_COMMENT_OF_PLAN withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                NSMutableArray *commentArray = [[NSMutableArray alloc] initWithCapacity:0];
                for (NSDictionary *commentDic in [dataDic arrayForKey:@"CommentList"]){
                    LCCommentModel *aComment = [[LCCommentModel alloc] initWithDictionary:commentDic];
                    if (aComment) {
                        [commentArray addObject: aComment];
                    }
                }
                NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
                callBack(commentArray, orderStr, error);
            }else{
                callBack(nil, nil, error);
            }
        }
    }];
}

+ (void)deleteCommentOfPlanWithCommentID:(NSString *)commentID callBack:(void (^)(NSError *))callBack{
    if ([LCStringUtil isNullString:commentID]) {
        if (callBack) {
            callBack([NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        return;
    }
    
    [[self getInstance] doPost:URL_DELETE_COMMENT_OF_PLAN withParams:@{@"CommentId":commentID} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            callBack(error);
        }
    }];
}

//apply, approve, refuse, quit, delete
+ (void)joinPlan:(NSString *)planGuid callBack:(void(^)(LCPlanModel *plan, NSError *error))callBack{
    [[self getInstance] doPost:URL_JOIN_PLAN withParams:@{@"PlanGuid":planGuid} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                LCPlanModel *plan = [[LCPlanModel alloc] initWithDictionary:[dataDic dicOfObjectForKey:@"PartnerPlan"]];
                callBack(plan, error);
            }else{
                callBack(nil, error);
            }
        }
    }];
}
+ (void)approveUser:(NSString *)userUuid toJoinPlan:(NSString *)planGuid callBack:(void(^)(NSError *error))callBack{
    [[self getInstance] doPost:URL_APPROVE_JOIN_PLAN
                    withParams:@{@"PlanGuid":planGuid,@"UserUuid":userUuid}
               requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error)
     {
         if (callBack) {
             callBack(error);
         }
     }];
}
+ (void)refuseUser:(NSString *)userUuid toJoinPlan:(NSString *)planGuid callBack:(void(^)(NSError *error))callBack{
    [[self getInstance] doPost:URL_REFUSE_JOIN_PLAN
                    withParams:@{@"PlanGuid":planGuid,@"UserUuid":userUuid}
               requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error)
     {
         if (callBack) {
             callBack(error);
         }
     }];
}
+ (void)quitPlan:(NSString *)planGuid callBack:(void (^)(NSError *))callBack{
    [[self getInstance] doPost:URL_QUIT_PLAN withParams:@{@"PlanGuid":planGuid} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            callBack(error);
        }
    }];
}
+ (void)deletePlan:(NSString *)planGuid callBack:(void (^)(NSError *))callBack{
    [[self getInstance] doPost:URL_DELETE_PLAN withParams:@{@"PlanGuid":planGuid} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            callBack(error);
        }
    }];
}
+ (void)kickOffUser:(NSString *)userUUID ofPlan:(NSString *)planGuid callBack:(void (^)(LCPlanModel *, NSError *))callBack{
    if ([LCStringUtil isNullString:userUUID] || [LCStringUtil isNullString:planGuid]) {
        if (callBack) {
            callBack(nil, [NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        return;
    }
    
    [[self getInstance] doPost:URL_KICKOFF_USRE_OF_PLAN
                    withParams:@{@"PlanGuid":planGuid, @"KickUuid":userUUID}
               requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error)
     {
         if (callBack) {
             if (dataDic) {
                 LCPlanModel *plan = [[LCPlanModel alloc] initWithDictionary:[dataDic dicOfObjectForKey:@"PartnerPlan"]];
                 callBack(plan, error);
             }else{
                 callBack(nil, error);
             }
         }
     }];
}
+ (void)forwardPlan:(NSString *)planGuid callBack:(void (^)(NSInteger, NSError *))callBack{
    if ([LCStringUtil isNullString:planGuid]) {
        if (callBack) {
            callBack(-1, [NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        return;
    }
    
    [[self getInstance] doPost:URL_FORWARD_PLAN withParams:@{@"Guid":planGuid} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                NSInteger forwardNum = [LCStringUtil idToNSInteger:[dataDic objectForKey:@"ForwardNum"]];
                callBack(forwardNum, error);
            }else{
                callBack(-1, error);
            }
        }
    }];
}


+ (void)favorPlan:(NSString *)planGuid withType:(NSInteger)type callBack:(void (^)(LCPlanModel *, NSError *))callBack {
    [[self getInstance] doPost:URL_FAVOR_PLAN withParams:@{@"PlanGuid":planGuid, @"Type":[NSNumber numberWithInteger:type]} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error)
     {
         if (callBack) {
             if (!error) {
                 LCPlanModel *plan = [[LCPlanModel alloc] initWithDictionary:[dataDic objectForKey:@"PartnerPlan"]];
                 [[LCDataBufferManager sharedInstance] addNewPlan:plan];
                 callBack(plan, error);
             } else {
                 callBack(nil, error);
             }
         }
     }];
}


+ (void)checkInPlan:(NSString *)planGuid location:(LCUserLocation *)location callBack:(void (^)(NSError *))callBack{
    if ([LCStringUtil isNullString:planGuid]) {
        if (callBack) {
            callBack([NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        return;
    }
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:planGuid forKey:@"PlanGuid"];
    if (location) {
        [param setObject:[NSString stringWithFormat:@"%f",location.lng] forKey:@"Long"];
        [param setObject:[NSString stringWithFormat:@"%f",location.lat] forKey:@"Lat"];
        NSInteger type = (NSInteger)location.type;
        [param setObject:[NSString stringWithFormat:@"%ld",(long)type] forKey:@"LocType"];
    }
    
    [[self getInstance] doPost:URL_CHECKIN_PLAN withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            callBack(error);
        }
    }];
}

// add to cart
+ (void)addToCartByPlanGuid:(NSString *)planGuid callBack:(void (^)(NSError *error))callBack {
    [[self getInstance] doPost:URL_ADD_TO_CART withParams:@{@"PlanGuid":planGuid} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            callBack(error);
        }
    }];
}


//Stage
+ (void)planStageUpdate:(NSString *)planGuid
                  price:(NSDecimalNumber *)price
                 maxNum:(NSInteger)maxNum
              startTime:(NSString *)startTime
                endTime:(NSString *)endTime
            isAdd:(BOOL)isAdd
               callBack:(void(^)(LCPlanModel *plan, NSError *error))callBack
{
    if ([LCStringUtil isNullString:planGuid] ||
        [LCStringUtil isNullString:startTime] ||
        [LCStringUtil isNullString:endTime]) {
        
        if (callBack) {
            callBack(nil, [NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        
        return;
    }
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:planGuid forKey:@"PlanGuid"];
    [param setObject:price forKey:@"Price"];
    [param setObject:[NSString stringWithFormat:@"%ld",(long)maxNum] forKey:@"Number"];
    [param setObject:startTime forKey:@"StartTime"];
    [param setObject:endTime forKey:@"EndTime"];
    [param setObject:(isAdd?@"1":@"0") forKey:@"Add"];
    
    [[self getInstance] doPost:URL_PLAN_STAGE_UPDATE withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        
        if (callBack) {
            if (dataDic) {
                NSDictionary *planDic = [dataDic dicOfObjectForKey:@"PartnerPlan"];
                LCPlanModel *plan = [[LCPlanModel alloc] initWithDictionary:planDic];
                callBack(plan,error);
            }else{
                callBack(nil,error);
            }
        }
    }];
}

+ (void)planStageRemove:(NSString *)planGuid
               callBack:(void(^)(NSError *error))callBack
{
    if ([LCStringUtil isNullString:planGuid]) {
        if (callBack) {
            callBack([NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        return;
    }
    
    [[self getInstance] doPost:URL_PLAN_STAGE_REMOVE withParams:@{@"PlanGuid":planGuid} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            callBack(error);
        }
    }];
}


+ (void)getPlanLikedList:(NSString *)guid withOrderStr:(NSString *)orderStr callBack:(void(^)(NSArray *likedArr, NSString *orderStr, NSError *error))callBack {
    if ([LCStringUtil isNullString:orderStr]) {
        orderStr = @"";
    }
    [[self getInstance] doPost:URL_PLAN_LIKEDLIST withParams:@{@"PlanGuid": guid, @"OrderStr":orderStr} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (!error) {
            NSArray *jsonArr = [dataDic objectForKey:@"UserList"];
            NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
            NSMutableArray *mutArr = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in jsonArr) {
                LCUserModel *user = [[LCUserModel alloc] initWithDictionary:dic];
                if (user) {
                    [mutArr addObject:user];
                }
            }
            callBack(mutArr, orderStr, error);
        } else {
            callBack(nil, @"", error);
        }
    }];
}

@end
