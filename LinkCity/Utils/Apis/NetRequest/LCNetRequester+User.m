//
//  LCNetRequester+User.m
//  LinkCity
//
//  Created by Roy on 6/27/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCNetRequester+User.h"

NSString *const KeyWordKey = @"Keyword";
NSString *const RedDotKey = @"RedDot";
NSString *const OrderStrKey = @"OrderStr";
NSString *const PlanOrderListKey = @"PlanOrderList";
NSString *const OrderGuidKey = @"OrderGuid";
NSString *const MsgKey = @"Msg";
@implementation LCNetRequester (User)

+ (void)favorUser:(NSString *)uuid callBack:(requestCallBack)callBack{
    [[self getInstance] doPost:URL_FAVOR_USER withParams:@{@"FavorUuid":uuid} requestCallBack:callBack];
}
+ (void)searchUserByKeyWord:(NSString *)keyword callBack:(void (^)(NSArray *, NSError *))callBack{
    if ([LCStringUtil isNullString:keyword]) {
        if (callBack) {
            callBack(nil, [NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        return;
    }
    
    [[self getInstance] doPost:URL_SEARCH_USER_BY_KEYWORD withParams:@{@"Keyword":keyword} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                NSMutableArray *userArray = [[NSMutableArray alloc] init];
                for (NSDictionary *userDic in [dataDic arrayForKey:@"UserList"]){
                    LCUserModel *user = [[LCUserModel alloc] initWithDictionary:userDic];
                    if (user) {
                        [userArray addObject:user];
                    }
                }
                
                callBack(userArray, error);
            }else{
                callBack(nil, error);
            }
        }
    }];
}

+ (void)getUserInfo:(NSString *)uuid callBack:(void (^)(LCUserModel *, NSError *))callBack{
    if ([LCStringUtil isNullString:uuid]) {
        if (callBack) {
            callBack(nil, [NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        return;
    }
    
    [[self getInstance] doGet:URL_GET_USERINFO withParams:@{@"UUID":uuid} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                NSDictionary *userDic = [dataDic dicOfObjectForKey:@"User"];
                LCUserModel *user = [[LCUserModel alloc] initWithDictionary:userDic];
                callBack(user, error);
            }else{
                callBack(nil, error);
            }
        }
    }];
}
+ (void)evaluateUser:(NSString *)userUUID
                type:(NSInteger)type
               score:(float)score
             content:(NSString *)content
                tags:(NSArray *)tags
            callBack:(void (^)(LCUserEvaluationModel *, NSError *))callBack{
    
    if ([LCStringUtil isNullString:userUUID] && callBack) {
        callBack(nil,[NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        return;
    }
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithCapacity:0];
    [param setObject:userUUID forKey:@"UserUUID"];
    [param setObject:[NSNumber numberWithInteger:type] forKey:@"Type"];
    [param setObject:[NSNumber numberWithFloat:score] forKey:@"Score"];
    
    if ([LCStringUtil isNotNullString:content]) {
        [param setObject:content forKey:@"Content"];
    }
    
    NSString *tagsJsonString = [LCStringUtil getJsonStrFromArray:tags];
    if ([LCStringUtil isNotNullString:tagsJsonString]) {
        [param setObject:tagsJsonString forKey:@"Tags"];
    }
    
    [[self getInstance] doPost:URL_ADD_EVALUATION withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                NSDictionary *evaluationDic = [dataDic dicOfObjectForKey:@"UserEvaluation"];
                LCUserEvaluationModel *evaluation = [[LCUserEvaluationModel alloc] initWithDictionary:evaluationDic];
                callBack(evaluation,error);
            }else{
                callBack(nil,error);
            }
        }
    }];
}

+ (void)getEvaluationForUser:(NSString *)userUUID orderStr:(NSString *)orderStr callBack:(void(^)(NSArray *evaluationArray, NSString *orderStr, NSError *error))callBack{
    if ([LCStringUtil isNullString:userUUID]) {
        if (callBack) {
            callBack(nil, nil, [NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        return;
    }
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithCapacity:0];
    [param setObject:userUUID forKey:@"UserUuid"];
    
    if ([LCStringUtil isNotNullString:orderStr]) {
        [param setObject:orderStr forKey:@"OrderStr"];
    }
    
    [[self getInstance] doPost:URL_GET_EVALUATION withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                NSMutableArray *evaluationArray = [[NSMutableArray alloc] initWithCapacity:0];
                for (NSDictionary *evaluationDic in [dataDic arrayForKey:@"EvaluationList"]){
                    LCUserEvaluationModel *userEvluation = [[LCUserEvaluationModel alloc] initWithDictionary:evaluationDic];
                    if (userEvluation) {
                        [evaluationArray addObject:userEvluation];
                    }
                }
                
                NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
                callBack(evaluationArray, orderStr, error);
            }else{
                callBack(nil, orderStr, error);
            }
        }
    }];
}

+ (void)getUserService:(NSString *)userUUID callBack:(void (^)(LCCarIdentityModel *, NSMutableArray *, NSError *))callBack{
    [[self getInstance] doGet:URL_GET_USER_SERVICE withParams:@{@"userUUID":userUUID} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                LCCarIdentityModel *carIdentitl = [[LCCarIdentityModel alloc] initWithDictionary:[dataDic dicOfObjectForKey:@"CarIdentity"]];
                
                NSArray *userRoutesDicArray = [dataDic arrayForKey:@"UserRoutes"];
                NSMutableArray *userRoutesArray = [[NSMutableArray alloc] initWithCapacity:0];
                for (NSDictionary *userRouteDic in userRoutesDicArray){
                    LCUserRouteModel *userRoute = [[LCUserRouteModel alloc] initWithDictionary:userRouteDic];
                    if (userRoute) {
                        [userRoutesArray addObject:userRoute];
                    }
                }
                
                callBack(carIdentitl,userRoutesArray,error);
            }else{
                callBack(nil,nil,error);
            }
        }
    }];
}

+ (void)followUser:(NSArray *)userUuidArray callBack:(void (^)(NSError *))callBack{
    NSString *uuidArrayJsonStr = [LCStringUtil getJsonStrFromArray:userUuidArray];
    if ([LCStringUtil isNullString:uuidArrayJsonStr]) {
        if (callBack) {
            callBack([NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        return;
    }
    
    [[self getInstance] doPost:URL_FOLLOW_USER withParams:@{@"FavorUuid":uuidArrayJsonStr} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            callBack(error);
        }
    }];
}
+ (void)unfollowUser:(NSString *)uuid callBack:(void (^)(LCUserModel *, NSError *))callBack{
    [[self getInstance] doPost:URL_UNFOLLOW_USER withParams:@{@"FavorUuid":uuid} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                LCUserModel *user = [[LCUserModel alloc] initWithDictionary:[dataDic dicOfObjectForKey:@"FavorUser"]];
                callBack(user,error);
            }
        }
    }];
}
+ (void)getNearbyTouristByLocation:(LCUserLocation *)location
                              skip:(NSInteger)skipNum
                        filterType:(LCUserFilterType)filterType
                          callBack:(void (^)(NSArray *, NSError *))callBack{
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    if (location) {
        [param setObject:[NSString stringWithFormat:@"%f",location.lng] forKey:@"Long"];
        [param setObject:[NSString stringWithFormat:@"%f",location.lat] forKey:@"Lat"];
        NSInteger type = (NSInteger)location.type;
        [param setObject:[NSString stringWithFormat:@"%ld",(long)type] forKey:@"LocType"];
    }
    
    [param setObject:[NSString stringWithFormat:@"%ld",(long)skipNum] forKey:@"Skip"];
    [param setObject:[NSString stringWithFormat:@"%ld",(long)filterType] forKey:@"FilterType"];
    
    [[self getInstance] doPost:URL_GET_NEARBY_TOURIST withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                NSMutableArray *userArray = [[NSMutableArray alloc] init];
                for (NSDictionary *userDic in [dataDic arrayForKey:@"TouristsList"]){
                    if ([userDic isKindOfClass:[NSDictionary class]]) {
                        LCUserModel *aUser = [[LCUserModel alloc] initWithDictionary:userDic];
                        if (aUser) {
                            [userArray addObject:aUser];
                        }
                    }
                }
                callBack(userArray,error);
            }else{
                callBack(nil,error);
            }
        }
    }];
}

+ (void)getNearbyDuckrByLocation:(LCUserLocation *)location
                            skip:(NSInteger)skipNum
                      filterType:(LCUserFilterType)filterType
                         locName:(NSString *)locName
                        callBack:(void (^)(NSArray *, NSError *))callBack{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    if (location) {
        [param setObject:[NSString stringWithFormat:@"%f",location.lng] forKey:@"Lng"];
        [param setObject:[NSString stringWithFormat:@"%f",location.lat] forKey:@"Lat"];
        NSInteger type = (NSInteger)location.type;
        [param setObject:[NSString stringWithFormat:@"%ld",(long)type] forKey:@"LocType"];
    }
    
    [param setObject:[NSString stringWithFormat:@"%ld",(long)skipNum] forKey:@"Skip"];
    [param setObject:[NSString stringWithFormat:@"%ld",(long)filterType] forKey:@"FilterType"];
    
    if ([LCStringUtil isNotNullString:locName]) {
        [param setObject:locName forKey:@"LocName"];
    }
    
    [[self getInstance] doPost:URL_GET_NEARBY_NATIVE withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                NSMutableArray *userArray = [[NSMutableArray alloc] init];
                for (NSDictionary *userDic in [dataDic arrayForKey:@"DuckrList"]){
                    if ([userDic isKindOfClass:[NSDictionary class]]) {
                        LCUserModel *aUser = [[LCUserModel alloc] initWithDictionary:userDic];
                        if (aUser) {
                            [userArray addObject:aUser];
                        }
                    }
                }
                callBack(userArray,error);
            }else{
                callBack(nil,error);
            }
        }
    }];
}

+ (void)userIdentityWith:(LCUserIdentityModel *)userIdentity callBack:(void (^)(LCUserIdentityModel *, LCUserModel *, NSError *))callBack{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithCapacity:0];
    if (!userIdentity ||
        [LCStringUtil isNullString:userIdentity.name] ||
        [LCStringUtil isNullString:userIdentity.idNumber] ||
        [LCStringUtil isNullString:userIdentity.idCardUrl]) {
        
        if (callBack) {
            callBack(nil, nil, [NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        return;
    }
    
    [param setObject:userIdentity.name forKey:@"Name"];
    [param setObject:userIdentity.idNumber forKey:@"IdNumber"];
    [param setObject:userIdentity.idCardUrl forKey:@"IdCardUrl"];
    
    [[self getInstance] doPost:URL_USER_IDENTITY withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                LCUserIdentityModel *userIdentity = [[LCUserIdentityModel alloc] initWithDictionary:[dataDic dicOfObjectForKey:@"UserIdentity"]];
                LCUserModel *user = [[LCUserModel alloc] initWithDictionary:[dataDic dicOfObjectForKey:@"User"]];
                callBack(userIdentity, user, error);
            }else{
                callBack(nil, nil, error);
            }
        }
    }];
}
+ (void)getUserIdentityInfoWithCallBack:(void (^)(LCUserIdentityModel *, NSError *))callBack{
    [[self getInstance] doPost:URL_GET_USER_IDENTITY_INFO withParams:nil requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                LCUserIdentityModel *userIdentity = [[LCUserIdentityModel alloc] initWithDictionary:[dataDic dicOfObjectForKey:@"UserIdentity"]];
                callBack(userIdentity,error);
            }else{
                callBack(nil,error);
            }
        }
    }];
}
+ (void)carIdentityWith:(LCCarIdentityModel *)carIdentity callBack:(void (^)(LCCarIdentityModel *, LCUserModel *, NSError *))callBack{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithCapacity:0];
    if (!carIdentity ||
        [LCStringUtil isNullString:carIdentity.userName] ||
        [LCStringUtil isNullString:carIdentity.idNumber] ||
        [LCStringUtil isNullString:carIdentity.carBrand] ||
        [LCStringUtil isNullString:carIdentity.carType] ||
        [LCStringUtil isNullString:carIdentity.carLicense] ||
        ![LCDecimalUtil isOverZero:carIdentity.dayPrice] ||
        [LCStringUtil isNullString:carIdentity.carArea] ||
        [LCStringUtil isNullString:carIdentity.drivingLicenseUrl] ||
        [LCStringUtil isNullString:carIdentity.carPictureUrl] ||
        [LCStringUtil isNullString:carIdentity.vehicleLicenseUrl]) {
        
        if (callBack) {
            callBack(nil, nil, [NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        return;
    }
    
    [param setObject:carIdentity.userName forKey:@"UserName"];
    [param setObject:carIdentity.idNumber forKey:@"IdNumber"];
    [param setObject:carIdentity.carBrand forKey:@"CarBrand"];
    [param setObject:carIdentity.carType forKey:@"CarType"];
    [param setObject:carIdentity.carLicense forKey:@"CarLicense"];
    
    [param setObject:[NSString stringWithFormat:@"%ld",(long)carIdentity.carSeat] forKey:@"CarSeat"];
    [param setObject:[NSString stringWithFormat:@"%ld",(long)carIdentity.carYear] forKey:@"CarYear"];
    [param setObject:[NSString stringWithFormat:@"%ld",(long)carIdentity.drivingYear] forKey:@"DrivingYear"];
    
    [param setObject:carIdentity.dayPrice forKey:@"DayPrice"];
    
    [param setObject:carIdentity.carArea forKey:@"CarArea"];
    [param setObject:carIdentity.drivingLicenseUrl forKey:@"DrivingLicenseUrl"];
    [param setObject:carIdentity.carPictureUrl forKey:@"CarPictureUrl"];
    [param setObject:carIdentity.vehicleLicenseUrl forKey:@"VehicleLicenseUrl"];
    
    [param setObject:@"1" forKey:@"Strict"];
    
    [[self getInstance] doPost:URL_CAR_IDENTITY withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                LCCarIdentityModel *carIdentity = [[LCCarIdentityModel alloc] initWithDictionary:[dataDic dicOfObjectForKey:@"CarIdentity"]];
                LCUserModel *user = [[LCUserModel alloc] initWithDictionary:[dataDic dicOfObjectForKey:@"User"]];
                callBack(carIdentity, user, error);
            }else{
                callBack(nil, nil, error);
            }
        }
    }];
}

+ (void)userMarginOrderNew:(NSDecimalNumber *)marginValue
                     wxPay:(NSInteger)isWxPay   //可选填，用于生成微信预付单，不填则代表是支付宝支付
                  callBack:(void(^)(NSString *orderGuid, NSDecimalNumber *marginValue, LCWxPrepayModel *wxPrepay, NSError *error))callBack{
    
    
    if (![LCDecimalUtil isOverZero:marginValue]) {
        if (callBack) {
            callBack(nil, nil, nil, [NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        return;
    }
    
    NSDictionary *param = @{@"MarginValue":marginValue,
                            @"WxPay":[NSNumber numberWithInteger:isWxPay]};

    [[self getInstance] doPost:URL_USER_MARGIN_ORDER_NEW withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                NSString *orderGuid = [LCStringUtil getNotNullStr:[dataDic objectForKey:@"Guid"]];
                NSDecimalNumber *marginValue = [NSDecimalNumber decimalNumberWithDecimal:[[dataDic objectForKey:@"MarginValue"] decimalValue]];
                LCWxPrepayModel *wxPrepay = [[LCWxPrepayModel alloc] initWithDictionary:[dataDic dicOfObjectForKey:@"WxPrepay"]];
                callBack(orderGuid, marginValue, wxPrepay, error);
            }else{
                callBack(nil, nil, nil, error);
            }
        }
    }];
}

+ (void)userMarginOrderQuery:(NSString *)orderGuide callBack:(void (^)(LCUserModel *, NSError *))callBack{
    if ([LCStringUtil isNullString:orderGuide]) {
        if (callBack) {
            callBack(nil, [NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        return;
    }
    
    NSDictionary *param = @{@"Guid":orderGuide};
    [[self getInstance] doPost:URL_USER_MARGIN_ORDER_QUERY withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                LCUserModel *user = [[LCUserModel alloc] initWithDictionary:[dataDic dicOfObjectForKey:@"User"]];
                callBack(user, error);
            }else{
                callBack(nil, error);
            }
        }
    }];
}

+ (void)getCarIdentityInfoWithCallBack:(void (^)(LCCarIdentityModel *, NSError *))callBack{
    [[self getInstance] doPost:URL_GET_CAR_IDENTITY_INFO withParams:nil requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                LCCarIdentityModel *carIdentity = [[LCCarIdentityModel alloc] initWithDictionary:[dataDic dicOfObjectForKey:@"CarIdentity"]];
                callBack(carIdentity, error);
            }else{
                callBack(nil, error);
            }
        }
    }];
}

+ (void)guideIdentityApproveWithCallBack:(void (^)(LCUserModel *, NSError *))callBack{
    [[self getInstance] doPost:URL_GUIDE_IDENTITY_APPROVE withParams:nil requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                LCUserModel *user = [[LCUserModel alloc] initWithDictionary:[dataDic dicOfObjectForKey:@"User"]];
                callBack(user, error);
            }else{
                callBack(nil, error);
            }
        }
    }];
}

+ (void)guideIdentityWith:(LCGuideIdentityModel *)guideIdentity callBack:(void (^)(LCGuideIdentityModel *, LCUserModel *, NSError *))callBack{
    
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithCapacity:0];
    if (!guideIdentity ||
        [LCStringUtil isNullString:guideIdentity.clubPhotoUrl]) {
        
        if (callBack) {
            callBack(nil, nil, [NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        return;
    }
    
    [param setObject:guideIdentity.clubPhotoUrl forKey:@"GuiderPhotoUrl"];
    
    if ([LCStringUtil isNotNullString:guideIdentity.note]) {
        [param setObject:guideIdentity.note forKey:@"Note"];
    }
    
    if ([LCStringUtil isNotNullString:guideIdentity.type]) {
        [param setObject:guideIdentity.type forKey:@"Type"];
    }
    
    [[self getInstance] doPost:URL_GUIDE_IDENTITY withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                LCGuideIdentityModel *guideIdentity = [[LCGuideIdentityModel alloc] initWithDictionary:[dataDic dicOfObjectForKey:@"GuiderIdentity"]];
                LCUserModel *user = [[LCUserModel alloc] initWithDictionary:[dataDic dicOfObjectForKey:@"User"]];
                callBack(guideIdentity, user, error);
            }else{
                callBack(nil, nil, error);
            }
        }
    }];
}

+ (void)getGuideIdentityInfoWithCallBack:(void (^)(LCGuideIdentityModel *, NSError *))callBack{
    [[self getInstance] doPost:URL_GET_GUIDE_IDENTITY_INFO withParams:nil requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                LCGuideIdentityModel *guideIdentity = [[LCGuideIdentityModel alloc] initWithDictionary:[dataDic dicOfObjectForKey:@"GuiderIdentity"]];
                callBack(guideIdentity, error);
            }else{
                callBack(nil, error);
            }
        }
    }];
}


+ (void)getFansListOfUser:(NSString *)userUuid orderStr:(NSString *)orderStr callBack:(void (^)(NSArray *, NSString *, NSError *))callBack{
    NSMutableDictionary *param = [NSMutableDictionary new];
    if ([LCStringUtil isNotNullString:orderStr]) {
        [param setObject:orderStr forKey:@"OrderStr"];
    }
    
    if ([LCStringUtil isNotNullString:userUuid]) {
        [param setObject:userUuid forKey:@"UserUuid"];
    }
    
    [[self getInstance] doPost:URL_GET_FANS_LIST withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                NSMutableArray *userArray = [[NSMutableArray alloc] init];
                for (NSDictionary *userDic in [dataDic arrayForKey:@"FansList"]) {
                    LCUserModel *aUser = [[LCUserModel alloc] initWithDictionary:userDic];
                    if (aUser) {
                        [userArray addObject:aUser];
                    }
                }
                
                NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
                callBack(userArray, orderStr, error);
            }else{
                callBack(nil, nil, error);
            }
        }
    }];
}

+ (void)getUserListByPlaceName:(NSString *)placeName orderStr:(NSString *)orderStr callBack:(void (^)(NSArray *, NSString *, NSError *))callBack{
    if ([LCStringUtil isNullString:placeName]) {
        if (callBack) {
            callBack(nil, nil, [NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        return;
    }
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:placeName forKey:@"PlaceName"];
    if ([LCStringUtil isNotNullString:orderStr]) {
        [param setObject:orderStr forKeyedSubscript:@"OrderStr"];
    }
    
    [[self getInstance] doPost:URL_GET_USERLIST_BY_PLACENAME withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                NSMutableArray *userArray = [[NSMutableArray alloc] init];
                for (NSDictionary *userDic in [dataDic arrayForKey:@"DuckrList"]){
                    LCUserModel *user = [[LCUserModel alloc] initWithDictionary:userDic];
                    if (user) {
                        [userArray addObject:user];
                    }
                }
                
                NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
                callBack(userArray, orderStr, error);
            }else{
                callBack(nil, nil, error);
            }
        }
    }];
}

+ (void)getSchoolListByString:(NSString *)str callBack:(void (^)(NSArray *, NSError *))callBack{
    if ([LCStringUtil isNullString:str]) {
        if (callBack) {
            callBack(nil, [NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        return;
    }
    
    [[self getInstance] doGet:URL_GET_SCHOOL_LIST withParams:@{@"Name":str} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                NSArray *schoolArray = [dataDic arrayForKey:@"CollegeList"];
                callBack(schoolArray, error);
            }else{
                callBack(nil, error);
            }
        }
    }];
}


+ (void)getUserHomepage:(NSString *)userUuid callBack:(void(^)(LCUserModel *user,
                                                               NSArray *planArray,
                                                               NSArray *tourpicArray,
                                                               LCCarIdentityModel *carService,
                                                               NSError *error))callBack{
    if ([LCStringUtil isNullString:userUuid]) {
        if (callBack) {
            callBack(nil,nil,nil,nil,[NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        return;
    }
    
    [[self getInstance] doGet:URL_GET_USER_HOMEPAGE withParams:@{@"UUID":userUuid} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                LCUserModel *user = [[LCUserModel alloc] initWithDictionary:[dataDic dicOfObjectForKey:@"User"]];
                
                NSMutableArray *planArray = [[NSMutableArray alloc] init];
                for (NSDictionary *planDic in [dataDic arrayForKey:@"PartnerPlanList"]){
                    LCPlanModel *plan = [[LCPlanModel alloc] initWithDictionary:planDic];
                    if (plan) {
                        [planArray addObject:plan];
                    }
                }
                
                
                NSMutableArray *tourpicArray = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in [dataDic arrayForKey:@"TourPicList"]) {
                    LCTourpic *tourpic = [[LCTourpic alloc] initWithDictionary:dic];
                    if (tourpic) {
                        [tourpicArray addObject:tourpic];
                    }
                }
                
                LCCarIdentityModel *carService = [[LCCarIdentityModel alloc] initWithDictionary:[dataDic dicOfObjectForKey:@"CarIdentity"]];
                
                callBack(user, planArray, tourpicArray, carService, error);
            }else{
                callBack(nil,nil,nil,nil,error);
            }
        }
    }];
}

+ (void)reportUser:(NSString *)userUuid reason:(NSString *)reason callBack:(void (^)(NSString *msg, NSError *))callBack{
    if ([LCStringUtil isNullString:userUuid]) {
        if (callBack) {
            callBack(nil, [NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        return;
    }
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:userUuid forKey:@"Target"];
    
    if ([LCStringUtil isNotNullString:reason]) {
        [param setObject:reason forKey:@"Reason"];
    }
    
    [[self getInstance] doPost:URL_REPORT_USER withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            callBack(message, error);
        }
    }];
}

+ (void)reportUser_V_FIVE:(NSString *)target reportType:(NSString *)reportType reason:(NSString *)reason photoUrls:(NSArray *)photoUrls callBack:(void (^)(NSString *msg, NSError *error))callBack {
    target = [LCStringUtil getNotNullStr:target];
    reportType = [LCStringUtil getNotNullStr:reportType];
    reason = [LCStringUtil getNotNullStr:reason];
    
    if ([LCStringUtil isNullString:target]) {
        if (callBack) {
            callBack(nil, [NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
    }
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:target forKey:@"Target"];
    [param setObject:reportType forKey:@"ReportType"];
    
    if ([LCStringUtil isNotNullString:reason]) {
        [param setObject:reason forKey:@"Reason"];
    }
    NSString *photoUrlStr = [LCStringUtil getJsonStrFromArray:photoUrls];
    photoUrlStr = [LCStringUtil getNotNullStr:photoUrlStr];
    [param setObject:photoUrlStr forKey:@"PhotoUrls"];
    
    [[self getInstance] doPost:URL_REPORT_USER_V_FIVE withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            callBack(message, error);
        }
    }];
    
}

// v5.1
+ (void)getFansListOfUser_V_FIVE:(NSString *)userUuid orderStr:(NSString *)orderStr callBack:(void (^)(NSArray *userArray,
                                                                                                       NSString *orderStr,
                                                                                                       NSError *error))callBack {
    NSMutableDictionary *param = [NSMutableDictionary new];
    if ([LCStringUtil isNotNullString:orderStr]) {
        [param setObject:orderStr forKey:@"OrderStr"];
    }
    if ([LCStringUtil isNotNullString:userUuid]) {
        [param setObject:userUuid forKey:@"UserUuid"];
    }
    
    [[self getInstance] doPost:URL_GET_FANS_LIST_V_FIVE withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (!error) {
                NSMutableArray *userArray = [[NSMutableArray alloc] init];
                for (NSDictionary *userDic in [dataDic arrayForKey:@"UserList"]) {
                    LCUserModel *user = [[LCUserModel alloc] initWithDictionary:userDic];
                    if (user) {
                        [userArray addObject:user];
                    }
                }
                
                NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
                callBack(userArray, orderStr, error);
            } else {
                callBack(nil, nil, error);
            }
        }
    }];
}

+ (void)getFavorsListOfUser_V_FIVE:(NSString *)userUuid orderStr:(NSString *)orderStr callBack:(void (^)(NSArray *userArray,
                                                                                                         NSString *orderStr,
                                                                                                         NSError *error))callBack {
    NSMutableDictionary *param = [NSMutableDictionary new];
    if ([LCStringUtil isNotNullString:orderStr]) {
        [param setObject:orderStr forKey:@"OrderStr"];
    }
    if ([LCStringUtil isNotNullString:userUuid]) {
        [param setObject:userUuid forKey:@"UserUuid"];
    }
    
    [[self getInstance] doPost:URL_GET_FAVORS_LIST_V_FIVE withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (!error) {
                NSMutableArray *userArray = [[NSMutableArray alloc] init];
                for (NSDictionary *userDic in [dataDic arrayForKey:@"UserList"]) {
                    LCUserModel *user = [[LCUserModel alloc] initWithDictionary:userDic];
                    if (user) {
                        [userArray addObject:user];
                    }
                }
                
                NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
                callBack(userArray, orderStr, error);
            } else {
                callBack(nil, nil, error);
            }
        }
    }];
}

+ (void)getFansDynamic_V_FIVE:(NSString *)userUuid orderStr:(NSString *)orderStr callBack:(void (^)(NSArray *contentArray,
                                                                                                    NSString *orderStr,
                                                                                                    NSError *error))callBack {
    NSMutableDictionary *param = [NSMutableDictionary new];
    if ([LCStringUtil isNotNullString:orderStr]) {
        [param setObject:orderStr forKey:@"OrderStr"];
    }
    if ([LCStringUtil isNotNullString:userUuid]) {
        [param setObject:userUuid forKey:@"UserUuid"];
    }
    
    [[self getInstance] doPost:URL_GET_FANS_DYNAMIC_V_FIVE withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (!error) {
                NSArray *planArray = [dataDic objectForKey:@"PlanList"];
                NSArray *tourpicArray = [dataDic objectForKey:@"TourPicList"];
                NSArray *mixedArray = [dataDic objectForKey:@"MixedList"];
                NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
                
                NSMutableArray *contentArray = [[NSMutableArray alloc] init];
                NSInteger planIndex = 0;
                NSInteger tourpicIndex = 0;
                NSInteger mark = 0;
                for (NSInteger i = 0; i < mixedArray.count; i++) {
                    mark = [LCStringUtil idToNSInteger:[mixedArray objectAtIndex:i]];
                    if (LCNetRequesterType_Tourpic == mark && tourpicIndex < tourpicArray.count) {
                        LCTourpic *tourpic = [[LCTourpic alloc] initWithDictionary:[tourpicArray objectAtIndex:tourpicIndex]];
                        [contentArray addObject:tourpic];
                        tourpicIndex++;
                    } else if (LCNetRequesterType_Plan == mark && planIndex < planArray.count) {
                        LCPlanModel *plan = [[LCPlanModel alloc] initWithDictionary:[planArray objectAtIndex:planIndex]];
                        [contentArray addObject:plan];
                        planIndex++;
                    }
                }
                
                callBack(contentArray, orderStr, error);
            } else {
                callBack(nil, nil, error);
            }
        }
    }];
}

+ (void)getFavorsDynamic_V_FIVE:(NSString *)userUuid orderStr:(NSString *)orderStr callBack:(void (^)(NSArray *contentArray,
                                                                                                      NSString *orderStr,
                                                                                                      NSError *error))callBack {
    NSMutableDictionary *param = [NSMutableDictionary new];
    if ([LCStringUtil isNotNullString:orderStr]) {
        [param setObject:orderStr forKey:@"OrderStr"];
    }
    if ([LCStringUtil isNotNullString:userUuid]) {
        [param setObject:userUuid forKey:@"UserUuid"];
    }
    
    [[self getInstance] doPost:URL_GET_FAVORS_DYNAMIC_V_FIVE withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (!error) {
                NSArray *planArray = [dataDic objectForKey:@"PlanList"];
                NSArray *tourpicArray = [dataDic objectForKey:@"TourPicList"];
                NSArray *mixedArray = [dataDic objectForKey:@"MixedList"];
                NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
                
                NSMutableArray *contentArray = [[NSMutableArray alloc] init];
                NSInteger planIndex = 0;
                NSInteger tourpicIndex = 0;
                NSInteger mark = 0;
                for (NSInteger i = 0; i < mixedArray.count; i++) {
                    mark = [LCStringUtil idToNSInteger:[mixedArray objectAtIndex:i]];
                    if (LCNetRequesterType_Tourpic == mark && tourpicIndex < tourpicArray.count) {
                        LCTourpic *tourpic = [[LCTourpic alloc] initWithDictionary:[tourpicArray objectAtIndex:tourpicIndex]];
                        [contentArray addObject:tourpic];
                        tourpicIndex++;
                    } else if (LCNetRequesterType_Plan == mark && planIndex < planArray.count) {
                        LCPlanModel *plan = [[LCPlanModel alloc] initWithDictionary:[planArray objectAtIndex:planIndex]];
                        [contentArray addObject:plan];
                        planIndex++;
                    }
                }
                
                callBack(contentArray, orderStr, error);
            } else {
                callBack(nil, nil, error);
            }
        }
    }];
}

+ (void)getFansSearchResult_V_FIVE:(NSString *)keyWord callBack:(void (^)(NSArray *userArray,
                                                                          NSError *error))callBack {
    NSMutableDictionary *param = [NSMutableDictionary new];
    if ([LCStringUtil isNotNullString:keyWord]) {
        [param setObject:keyWord forKey:KeyWordKey];
    }
    
    [[self getInstance] doPost:URL_GET_FANS_SEARCH_RESULT_V_FIVE withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (!error) {
                NSMutableArray *userArray = [[NSMutableArray alloc] init];
                for (NSDictionary *userDic in [dataDic arrayForKey:@"UserList"]) {
                    LCUserModel *user = [[LCUserModel alloc] initWithDictionary:userDic];
                    if (user) {
                        [userArray addObject:user];
                    }
                }
                callBack(userArray, error);
            } else {
                callBack(nil, error);
            }
        }
    }];
}

+ (void)getUserRedDot_V_FIVE:(void (^)(LCRedDotModel *redDot, NSError *error))callBack {
    [[self getInstance] doGet:URL_GET_USER_RED_DOT_V_FIVE withParams:nil requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (!error) {
                NSMutableDictionary *redDotDic = [dataDic objectForKey:RedDotKey];
                LCRedDotModel *redDot = [[LCRedDotModel alloc] initWithDictionary:redDotDic];
                callBack(redDot, error);
            } else {
                callBack(nil, error);
            }
        }
    }];
}

+ (void)getUserAllOrder_V_FIVE:(NSString *)orderStr callBack:(void (^)(NSArray *planArray,
                                                                       NSArray *orderArray,
                                                                       NSString *orderStr,
                                                                       NSError *error))callBack {
    NSMutableDictionary *param = [NSMutableDictionary new];
    if ([LCStringUtil isNotNullString:orderStr]) {
        [param setObject:orderStr forKey:OrderStrKey];
    }
    
    [[self getInstance] doPost:URL_GET_USER_ALL_ORDER_V_FIVE withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (!error) {
                NSMutableArray *planArray = [[NSMutableArray alloc] init];
                NSMutableArray *orderArray = [[NSMutableArray alloc] init];
                NSString *orderStr = [dataDic objectForKey:OrderStrKey];
                
                NSArray *planOrderList = [dataDic arrayForKey:PlanOrderListKey];
                for (NSInteger i = 0; i < planOrderList.count; i++) {
                    LCPlanModel *plan = [[LCPlanModel alloc] initWithDictionary:[[planOrderList objectAtIndex:i] objectForKey:@"Plan"]];
                    LCPartnerOrderModel *order = [[LCPartnerOrderModel alloc] initWithDictionary:[[planOrderList objectAtIndex:i] objectForKey:@"Order"]];
                    
                    if (plan && order) {
                        [planArray addObject:plan];
                        [orderArray addObject:order];
                    }
                }
                callBack(planArray, orderArray, orderStr, error);
            } else {
                callBack(nil, nil, nil, error);
            }
        }
    }];
}

+ (void)getUserPendingPaymentOrder_V_FIVE:(NSString *)orderStr callBack:(void (^)(NSArray *planArray,
                                                                                  NSString *orderStr,
                                                                                  NSError *error))callBack {
    NSMutableDictionary *param = [NSMutableDictionary new];
    if ([LCStringUtil isNotNullString:orderStr]) {
        [param setObject:orderStr forKey:OrderStrKey];
    }
    
    [[self getInstance] doPost:URL_GET_USER_PENDING_PAYMENT_ORDER_V_FIVE withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (!error) {
                NSMutableArray *planArray = [[NSMutableArray alloc] init];
                NSString *orderStr = [dataDic objectForKey:OrderStrKey];
                
                NSArray *planList = [dataDic arrayForKey:@"PlanList"];
                for (NSInteger i = 0; i < planList.count; i++) {
                    LCPlanModel *plan = [[LCPlanModel alloc] initWithDictionary:[planList objectAtIndex:i]];
                    [planArray addObject:plan];
                }
                callBack(planArray, orderStr, error);
            } else {
                callBack(nil, nil, error);
            }
        }
    }];
}

+ (void)getUserToBeEvaluatedOrder_V_FIVE:(NSString *)orderStr callBack:(void (^)(NSArray *planArray,
                                                                                 NSArray *orderArray,
                                                                                 NSString *orderStr,
                                                                                 NSError *error))callBack {
    NSMutableDictionary *param = [NSMutableDictionary new];
    if ([LCStringUtil isNotNullString:orderStr]) {
        [param setObject:orderStr forKey:OrderStrKey];
    }
    
    [[self getInstance] doPost:URL_GET_USER_TO_BE_EVALUATED_ORDER_V_FIVE withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (!error) {
                NSMutableArray *planArray = [[NSMutableArray alloc] init];
                NSMutableArray *orderArray = [[NSMutableArray alloc] init];
                NSString *orderStr = [dataDic objectForKey:OrderStrKey];
                
                NSArray *planOrderList = [dataDic arrayForKey:PlanOrderListKey];
                for (NSInteger i = 0; i < planOrderList.count; i++) {
                    LCPlanModel *plan = [[LCPlanModel alloc] initWithDictionary:[[planOrderList objectAtIndex:i] objectForKey:@"Plan"]];
                    LCPartnerOrderModel *order = [[LCPartnerOrderModel alloc] initWithDictionary:[[planOrderList objectAtIndex:i] objectForKey:@"Order"]];
                    
                    if (plan && order) {
                        [planArray addObject:plan];
                        [orderArray addObject:order];
                    }
                }
                callBack(planArray, orderArray, orderStr, error);
            } else {
                callBack(nil, nil, nil, error);
            }
        }
    }];
}

+ (void)getUserRefundOrder_V_FIVE:(NSString *)orderStr callBack:(void (^)(NSArray *planArray,
                                                                          NSArray *orderArray,
                                                                          NSString *orderStr,
                                                                          NSError *error))callBack {
    NSMutableDictionary *param = [NSMutableDictionary new];
    if ([LCStringUtil isNotNullString:orderStr]) {
        [param setObject:orderStr forKey:OrderStrKey];
    }
    
    [[self getInstance] doPost:URL_GET_USER_REFUND_ORDER_V_FIVE withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (!error) {
                NSMutableArray *planArray = [[NSMutableArray alloc] init];
                NSMutableArray *orderArray = [[NSMutableArray alloc] init];
                NSString *orderStr = [dataDic objectForKey:OrderStrKey];
                
                NSArray *planOrderList = [dataDic arrayForKey:PlanOrderListKey];
                for (NSInteger i = 0; i < planOrderList.count; i++) {
                    LCPlanModel *plan = [[LCPlanModel alloc] initWithDictionary:[[planOrderList objectAtIndex:i] objectForKey:@"Plan"]];
                    LCPartnerOrderModel *order = [[LCPartnerOrderModel alloc] initWithDictionary:[[planOrderList objectAtIndex:i] objectForKey:@"Order"]];
                    
                    if (plan && order) {
                        [planArray addObject:plan];
                        [orderArray addObject:order];
                    }
                }
                callBack(planArray, orderArray, orderStr, error);
            } else {
                callBack(nil, nil, nil, error);
            }
        }
    }];
}

+ (void)deleteUserOrderWithOrderGuid_V_FIVE:(NSString *)orderGuid callBack:(void (^)(NSString *msg,
                                                                                     NSError *error))callBack {
    NSMutableDictionary *param = [NSMutableDictionary new];
    if ([LCStringUtil isNotNullString:orderGuid]) {
        [param setObject:orderGuid forKey:OrderGuidKey];
    }
    
    [[self getInstance] doPost:URL_DELETE_USER_ORDER_V_FIVE withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (!error) {
                callBack(message, error);
            } else {
                callBack(nil, error);
            }
        }
    }];
}


+ (void)getUserRecmDuckrListWithLocName_V_FIVE:(NSString *)locName location:(LCUserLocation *)location orderStr:(NSString *)orderStr callBack:(void (^)(NSArray *userArray,
                                                                                                                                                        NSArray *mixedArray,
                                                                                                                                                        NSString *orderStr,
                                                                                                                                                        NSError *error))callBack {
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    if ([LCStringUtil isNotNullString:locName]) {
        [param setObject:locName forKey:@"LocName"];
    }
    if (location) {
        [param setObject:[NSString stringWithFormat:@"%f",location.lng] forKey:@"Lng"];
        [param setObject:[NSString stringWithFormat:@"%f",location.lat] forKey:@"Lat"];
    }
    if ([LCStringUtil isNotNullString:orderStr]) {
        [param setObject:orderStr forKey:@"OrderStr"];
    }
    [[self getInstance] doPost:URL_GET_USER_RECM_DUCKR_V_FIVE withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (!error) {
                NSMutableArray *userArray = [[NSMutableArray alloc] init];
                NSArray *userList = [dataDic arrayForKey:@"UserList"];
                for (NSInteger i = 0; i < userList.count; i++) {
                    LCUserModel *user = [[LCUserModel alloc] initWithDictionary:[userList objectAtIndex:i]];
                    [userArray addObject:user];
                }
                NSArray *mixedArray = [dataDic arrayForKey:@"MixedList"];
                NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
                
                callBack(userArray, mixedArray, orderStr, error);
            } else {
                callBack(nil, nil, nil, error);
            }
        }
    }];
}

+ (void)setUserRemarkName:(NSString *)remarkName remarkUUID:(NSString *)remarkUuid callBack:(void (^)(NSString *message, NSError *error))callBack {
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    if ([LCStringUtil isNotNullString:remarkUuid]) {
        [param setObject:remarkUuid forKey:@"RemarkUUID"];
    }
    if ([LCStringUtil isNotNullString:remarkName]) {
        [param setObject:remarkName forKey:@"RemarkName"];
    }
    
    [[self getInstance] doPost:URL_SET_USER_REMARK_NAME withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (!error) {
            NSString *message = (NSString *)[dataDic objectForKey:@"Msg"];
            
            callBack(message, error);
        } else {
            callBack(nil, error);
        }
    }];
}


//extern NSString *const URL_USER_JOINED_PLAN;
//*const URL_USER_FAVOR_PLAN;
//extern NSString *const URL_USER_RAISED_PLAN;
+ (void)getUserJoinedPlan:(NSString *)userUuid orderString:(NSString *)orderString callBack:(void(^)(NSArray *planList,NSString *orderStr,NSError *error))callBack{
    NSDictionary *param = @{@"UUID":userUuid,
                            @"OrderStr":orderString
                            };
    [[self getInstance] doPost:URL_USER_JOINED_PLAN withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (!error) {
                NSMutableArray *planArray = [[NSMutableArray alloc] init];
                for (NSDictionary * dic in [dataDic arrayForKey:@"PlanList"]) {
                    LCPlanModel * model = [[LCPlanModel alloc] initWithDictionary:dic];
                    [planArray addObject:model];
                }
                NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
                callBack(planArray, orderStr, error);
            }
            else {
                callBack(nil,nil,error);
            }
        }
    }];

    //
}

+ (void)getUserFavoredPlan:(NSString *)userUuid orderString:(NSString *)orderString callBack:(void(^)(NSArray *planList,NSString *orderStr,NSError *error))callBack {
    NSDictionary *param = @{@"UUID":userUuid,
                            @"OrderStr":orderString
                            };
    [[self getInstance] doPost:URL_USER_FAVORED_PLAN withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (!error) {
                NSMutableArray *planArray = [[NSMutableArray alloc] init];
                for (NSDictionary * dic in [dataDic arrayForKey:@"PlanList"]) {
                    LCPlanModel * model = [[LCPlanModel alloc] initWithDictionary:dic];
                    [planArray addObject:model];
                }
                NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
                callBack(planArray,orderStr, error);
            } else {
                callBack(nil,nil,error);
            }
        }
    }];
}

+ (void)getUserRaisedPlan:(NSString *)userUuid orderString:(NSString *)orderString callBack:(void(^)(NSArray *planList,NSString *orderStr,NSError *error))callBack {
    NSDictionary *param = @{@"UUID":userUuid,
                            @"OrderStr":orderString
                            };
    [[self getInstance] doPost:URL_USER_RAISED_PLAN withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (!error) {
                NSMutableArray *planArray = [[NSMutableArray alloc] init];
                for (NSDictionary * dic in [dataDic arrayForKey:@"PlanList"]) {
                    LCPlanModel * model = [[LCPlanModel alloc] initWithDictionary:dic];
                    [planArray addObject:model];
                   
                }
                NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
                callBack(planArray,orderStr, error);
            } else {
                callBack(nil,nil,error);
            }
        }
    }];

}

+ (void)setWifiVedioAutoPlay:(BOOL)isAutoPlay callBack:(void(^)(NSString *message, NSError *error))callBack {
    [[self getInstance] doPost:URL_USER_SETTING_WIFI_VEDIO_AUTOPLAY withParams:@{@"NotifWifiVedioAutoPlay":[NSNumber numberWithBool:isAutoPlay]} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            callBack(message, error);
        }
        //[NSNumber numberWithBool:isAutoPlay]
    }];
}

+ (void)setShowSelfToContact:(BOOL)isShowSelfToContract callBack:(void(^)(NSString *message, NSError *error))callBack {
    [[self getInstance] doPost:URL_USER_SETTING_SHOWSELFTOCONTACT withParams:@{@"ShowSelfToContact":[NSNumber numberWithBool:isShowSelfToContract]} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            callBack(message, error);
            
        }
    }];
}
+ (void)getAllContactUserWithCallBack:(void(^)(NSArray *userList, NSError *error))callBack {
    [[self getInstance] doPost:URL_USER_CONTACT withParams:nil requestCallBack:
     ^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
         NSMutableArray * userListArray = [[NSMutableArray alloc] init];
         for (NSDictionary * dic in [dataDic arrayForKey:@"AddressList"]) {
             LCUserModel * model = [[LCUserModel alloc] initWithDictionary:dic];
             [userListArray addObject:model];
         }

         if (callBack) {
             callBack(userListArray, error);
             
         } else {
             callBack(nil,error);
         }
     }];
}
//URL_USER_CONTACT

/// 获取我的服务列表.
+ (void)requestMerchantServiceList:(NSString *)orderStr callBack:(void(^)(NSArray *contentArr, NSString *orderStr, NSError *error))callBack {
    orderStr = [LCStringUtil getNotNullStr:orderStr];
    [[self getInstance] doPost:URL_GET_MERCHANT_SERVICE_LIST withParams:@{@"OrderStr":orderStr} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (!error) {
                NSArray *planJsonArr = [dataDic objectForKey:@"PlanList"];
                NSMutableArray *contentArr = [[NSMutableArray alloc] init];
                if (nil != planJsonArr && planJsonArr.count > 0) {
                    for (NSDictionary *dic in planJsonArr) {
                        LCPlanModel *plan = [[LCPlanModel alloc] initWithDictionary:dic];
                        [contentArr addObject:plan];
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

/// 获取我的账单列表.
+ (void)requestMerchantBillList:(NSString *)orderStr callBack:(void (^)(NSArray *contentArr, LCUserAccount *account, NSString *orderStr, NSError *error))callBack {
    orderStr = [LCStringUtil getNotNullStr:orderStr];
    [[self getInstance] doPost:URL_GET_MERCHANT_BILL_LIST withParams:@{@"OrderStr":orderStr} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (!error) {
                LCUserAccount *account = [[LCUserAccount alloc] initWithDictionary:[dataDic objectForKey:@"UserAccountInfo"]];
                NSArray *planBillJsonArr = [dataDic objectForKey:@"PlanBillList"];
                NSMutableArray *contentArr = [[NSMutableArray alloc] init];
                if (nil != planBillJsonArr && planBillJsonArr.count > 0) {
                    for (NSDictionary *dic in planBillJsonArr) {
                        LCPlanBillModel *planBill = [[LCPlanBillModel alloc] initWithDictionary:dic];
                        [contentArr addObject:planBill];
                    }
                }
                
                NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
                callBack(contentArr, account, orderStr, error);
            } else {
                callBack(nil, nil, nil, error);
            }
        }
    }];
}

/// 获取退款处理列表.
+ (void)requestMerchantRefundList:(NSString *)orderStr callBack:(void(^)(NSArray *planArr, NSArray *userArr, NSString *orderStr, NSError *error))callBack {
    orderStr = [LCStringUtil getNotNullStr:orderStr];
    [[self getInstance] doPost:URL_GET_MERCHANT_REFUND_LIST withParams:@{@"OrderStr":orderStr} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (!error) {
                NSArray *planUserJsonArr = [dataDic objectForKey:@"PlanUserList"];
                
                NSMutableArray *planArr = [[NSMutableArray alloc] init];
                NSMutableArray *userArr = [[NSMutableArray alloc] init];
                if (nil != planUserJsonArr && planUserJsonArr.count > 0) {
                    for (NSDictionary *dic in planUserJsonArr) {
                        LCPlanModel *plan = [[LCPlanModel alloc] initWithDictionary:[dic objectForKey:@"Plan"]];
                        LCUserModel *user = [[LCUserModel alloc] initWithDictionary:[dic objectForKey:@"User"]];
                        if (nil != plan && nil != user) {
                            [planArr addObject:plan];
                            [userArr addObject:user];
                        }
                    }
                }
                
                NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
                callBack(planArr, userArr, orderStr, error);
            } else {
                callBack(nil, nil, nil, error);
            }
        }
    }];
}

/// 我的—商家主页—退款申请详情.
+ (void)requestMerchantRefundDetail:(NSString *)orderGuid callBack:(void(^)(LCPlanModel *plan, LCUserModel *user, NSError *error))callBack {
    orderGuid = [LCStringUtil getNotNullStr:orderGuid];
    [[self getInstance] doGet:URL_GET_MERCHANT_REFUND_DETAIL withParams:@{@"OrderGuid":orderGuid} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (!error) {
                NSDictionary *orderDic = [dataDic objectForKey:@"PlanUserInfo"];
                
                LCPlanModel *plan = [[LCPlanModel alloc] initWithDictionary:[orderDic objectForKey:@"Plan"]];
                LCUserModel *user = [[LCUserModel alloc] initWithDictionary:[orderDic objectForKey:@"User"]];
                
                callBack(plan, user, error);
            } else {
                callBack(nil, nil, error);
            }
        }
    }];
}

/// 我的—商家主页—我的服务列表—报名详情.
+ (void)requestMerchantSignUpDetail:(NSString *)planGuid callBack:(void(^)(NSArray *planArr, NSError *error))callBack {
    planGuid = [LCStringUtil getNotNullStr:planGuid];
    [[self getInstance] doGet:URL_GET_MERCHANT_SIGN_UP_DETAIL withParams:@{@"PlanGuid":planGuid} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (!error) {
                NSArray *planJsonArr = [dataDic objectForKey:@"PartnerPlanList"];
                NSMutableArray *planArr = [[NSMutableArray alloc] init];
                
                if (nil != planJsonArr && planJsonArr.count > 0) {
                    for (NSDictionary *dic in planJsonArr) {
                        LCPlanModel *plan = [[LCPlanModel alloc] initWithDictionary:dic];
                        if (nil != plan) {
                            [planArr addObject:plan];
                        }
                    }
                }

                callBack(planArr, error);
            } else {
                callBack(nil, error);
            }
        }
    }];
}

/// 我的—商家主页—退款申请—确认退款.
+ (void)requestMerchantAgreeRefund:(NSString *)orderGuid withMoney:(NSString *)refundNumStr callBack:(void(^)(NSError *error))callBack {
    orderGuid = [LCStringUtil getNotNullStr:orderGuid];
    refundNumStr = [LCStringUtil getNotNullStr:refundNumStr];
    [[self getInstance] doPost:URL_GET_MERCHANT_AGREE_REFUND withParams:@{@"OrderGuid":orderGuid, @"RefundNum":refundNumStr} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            callBack(error);
        }
    }];
}

/// 我的—商家主页—验票.
+ (void)requestMerchantCheckTicket:(NSString *)code callBack:(void(^)(LCPlanModel *plan, LCUserModel *user, NSError *error))callBack {
    code = [LCStringUtil getNotNullStr:code];
    [[self getInstance] doPost:URL_GET_MERCHANT_ORDER_CHECK withParams:@{@"OrderCode":code} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (!error) {
                NSDictionary *orderDic = [dataDic objectForKey:@"PlanUserInfo"];
                
                LCPlanModel *plan = [[LCPlanModel alloc] initWithDictionary:[orderDic objectForKey:@"Plan"]];
                LCUserModel *user = [[LCUserModel alloc] initWithDictionary:[orderDic objectForKey:@"User"]];
                
                callBack(plan, user, error);
            } else {
                callBack(nil, nil, error);
            }
        }

    }];
}

/// 我的—商家主页—绑定银行卡.
+ (void)requestMerchantAddBankcard:(LCBankcard *)bankcard callBack:(void(^)(LCUserAccount *account, NSError *error))callBack {
    NSString *cardNum = [LCStringUtil getNotNullStr:bankcard.bankcardNumber];
    NSString *bank = [LCStringUtil getNotNullStr:bankcard.belongedBank];
    NSString *userName = [LCStringUtil getNotNullStr:bankcard.userName];
    
    [[self getInstance] doPost:URL_GET_MERCHANT_ADD_CARD withParams:@{@"Bankcard":cardNum, @"BelongedBank": bank, @"UserName":userName} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (!error) {
                LCUserAccount *account = [[LCUserAccount alloc] initWithDictionary:[dataDic objectForKey:@"UserAccountInfo"]];
                callBack(account, error);
            } else {
                callBack(nil, error);
            }
        }
    }];
}

/// 我的—商家主页—确认提现.
+ (void)requestMerchantWithdraw:(LCBankcard *)bankcard withAmount:(NSString *)amount callBack:(void(^)(NSError *error))callBack {
    NSString *cardNum = [LCStringUtil getNotNullStr:bankcard.bankcardNumber];
    amount = [LCStringUtil getNotNullStr:amount];
    [[self getInstance] doPost:URL_GET_MERCHANT_WITHDRAW withParams:@{@"Bankcard":cardNum, @"Amount": amount} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            callBack(error);
        }
    }];
}

/// 我的—商家主页—提现记录.
+ (void)requestMerchantWithdrawList:(NSString *)orderStr callBack:(void(^)(NSArray *contentArr, NSString *orderStr, NSError *error))callBack {
    orderStr = [LCStringUtil getNotNullStr:orderStr];
    
    [[self getInstance] doPost:URL_GET_MERCHANT_WITHDRAW_LIST withParams:@{@"OrderStr":orderStr} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (!error) {
                NSArray *contentArr = [dataDic objectForKey:@"WithdrawList"];
                callBack(contentArr, orderStr, error);
            } else {
                callBack(nil, nil, error);
            }
        }
    }];
}

/// 我的—商家主页—银行列表.
+ (void)requestMerchantBankWithcallBack:(void(^)(NSArray *hotBankArr, NSArray *letterBankArr, NSError *error))callBack {
    [[self getInstance] doGet:URL_GET_MERCHANT_BANK_LIST withParams:@{} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (!error) {
                NSArray *hotBankArr = [dataDic objectForKey:@"HotBanks"];
                NSArray *letterBankArr = [dataDic objectForKey:@"Letters"];
                callBack(hotBankArr, letterBankArr, error);
            } else {
                callBack(nil, nil, error);
            }
        }
    }];
}

+ (void)getNotificationListWithOrderStr:(NSString *)orderStr callBack:(void (^)(NSArray *, NSString *, NSError *))callBack {
    NSDictionary *param = nil;
    if ([LCStringUtil isNotNullString:orderStr]) {
        param = @{@"OrderStr":orderStr};
    }
    
    [[self getInstance] doPost:URL_GET_NOTIFICATION withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (!error) {
                NSMutableArray *notificationArray = [[NSMutableArray alloc] initWithCapacity:0];
                for (NSDictionary *notificationDic in [dataDic arrayForKey:@"UserNotification"]){
                    LCNotificationModel *aNotification = [[LCNotificationModel alloc] initWithDictionary:notificationDic];
                    if (aNotification) {
                        [notificationArray addObject:aNotification];
                    }
                }
                
                NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
                
                //LCRedDotModel *redDot = [[LCRedDotModel alloc] initWithDictionary:[dataDic dicOfObjectForKey:@"RedDot"]];
                callBack(notificationArray, orderStr, error);
            }else{
                callBack(nil, nil, error);
            }
        }
    }];
}


@end
