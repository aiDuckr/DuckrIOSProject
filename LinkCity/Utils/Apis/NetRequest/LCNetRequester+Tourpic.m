//
//  LCNetRequester+Tourpic.m
//  LinkCity
//
//  Created by Roy on 6/27/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCNetRequester+Tourpic.h"
#import "LCStringUtil.h"
@implementation LCNetRequester (Tourpic)

#pragma mark Tourpic
//+ (void)publishTourPic:(NSString *)picUrl
//             secondPic:(NSString *)secondPicUrl
//              thirdPic:(NSString *)thirdPicUrl
//             placeName:(NSString *)placeName
//           description:(NSString *)description
//           companyList:(NSString *)companyJsonStr
//              callBack:(void(^)(NSError *error))callBack {
//    
//    if ([LCStringUtil isNullString:picUrl]) {
//        if (callBack) {
//            callBack([NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
//        }
//        
//        return;
//    }
//    
//    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
//    if ([LCStringUtil isNotNullString:picUrl]) {
//        [param setObject:picUrl forKey:@"PicUrl"];
//    }
//    
//    if ([LCStringUtil isNotNullString:secondPicUrl]) {
//        [param setObject:secondPicUrl forKey:@"SecondPicUrl"];
//    }
//    
//    if ([LCStringUtil isNotNullString:thirdPicUrl]) {
//        [param setObject:thirdPicUrl forKey:@"ThirdPicUrl"];
//    }
//    
//    if ([LCStringUtil isNotNullString:placeName]) {
//        [param setObject:placeName forKey:@"PlaceName"];
//    }
//    
//    if ([LCStringUtil isNotNullString:description]) {
//        [param setObject:description forKey:@"Description"];
//    }
//    
//    if ([LCStringUtil isNotNullString:companyJsonStr]) {
//        [param setObject:companyJsonStr forKey:@"CompanyList"];
//    }
//    
//    [[self getInstance] doPost:URL_TOURPIC_PUBLISH
//                    withParams:param
//               requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
//                   if (callBack) {
//                       callBack(error);
//                   }
//               }];
//}

+ (void)sendTourPic:(NSArray *)tourPicArray
           withType:(NSInteger)type
       userLocation:(LCUserLocation *)location
          placeName:(NSString *)placeName
        description:(NSString *)description
        planGuid:(NSString *)planGuid
           callBack:(void(^)(NSError *error))callBack {
    
    if (!tourPicArray || tourPicArray.count == 0) {
        if (callBack) {
            callBack([NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        return;
    }
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[LCStringUtil getJsonStrFromArray:tourPicArray] forKey:@"PhotoUrls"];
    [param setObject:[NSString stringWithFormat:@"%ld", (long)type] forKey:@"Type"];
    if ([location isUserLocationValid]) {
        [param setObject:[NSNumber numberWithDouble:location.lng] forKey:@"Lng"];
        [param setObject:[NSNumber numberWithDouble:location.lat] forKey:@"Lat"];
    }
    if ([LCStringUtil isNotNullString:placeName]) {
        [param setObject:placeName forKey:@"PlaceName"];
    }
    
    if ([LCStringUtil isNotNullString:description]) {
        [param setObject:description forKey:@"Description"];
    }
    
    if ([LCStringUtil isNotNullString:planGuid]) {
        [param setObject:planGuid forKey:@"PlanGuid"];
    }
    
    [[self getInstance] doPost:URL_TOURPIC_PUBLISH
                    withParams:param
               requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
                   if (callBack) {
                       callBack(error);
                   }
               }];
}

+ (void)getPlanLinkingTourpicWithPlanGuid:(NSString *)planGuid orderStr:(NSString *)orderStr callBack:(void(^)(NSArray *tourpicList, NSString *orderStr, NSError *error))callBack {
    if ([LCStringUtil isNullString:orderStr]) {
        orderStr = @"";
    }
    [[self getInstance] doPost:URL_TOURPIC_GET_FROMPLANGUID withParams:@{@"OrderStr": orderStr,@"PlanGuid":planGuid} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                NSMutableArray *mutArr = [[NSMutableArray alloc] init];
                NSArray *tourpicArr = [dataDic objectForKey:@"TourPicList"];
                NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
                for (NSDictionary *dic in tourpicArr) {
                    LCTourpic *tourpic = [[LCTourpic alloc] initWithDictionary:dic];
                    if (tourpic) {
                        [mutArr addObject:tourpic];
                    }
                }
                callBack(mutArr, orderStr, error);
            } else {
                callBack(nil, @"", error);
            }
        }
    }];

        //
}
+ (void)getPopularTourpic:(NSString *)orderStr callBack:(void(^)(NSArray *tourpicList, NSString *orderStr, NSError *error))callBack {
    if ([LCStringUtil isNullString:orderStr]) {
        orderStr = @"";
    }
    [[self getInstance] doPost:URL_TOURPIC_GET_POPULAR withParams:@{@"OrderStr": orderStr} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                NSMutableArray *mutArr = [[NSMutableArray alloc] init];
                NSArray *tourpicArr = [dataDic objectForKey:@"TourPicList"];
                NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
                for (NSDictionary *dic in tourpicArr) {
                    LCTourpic *tourpic = [[LCTourpic alloc] initWithDictionary:dic];
                    if (tourpic) {
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

+ (void)getFocusTourpicWithOrderString:(NSString *)orderStr callBack:(void(^)(NSArray *tourpicList, NSString *orderStr, NSError *error))callBack {
    if ([LCStringUtil isNullString:orderStr]) {
        orderStr = @"";
    }
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:orderStr forKey:@"OrderStr"];
    
    [[self getInstance] doPost:URL_TOURPIC_GET_FAVOR withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                NSMutableArray *mutArr = [[NSMutableArray alloc] init];
                NSArray *tourpicArr = [dataDic objectForKey:@"TourPicList"];
                NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
                for (NSDictionary *dic in tourpicArr) {
                    LCTourpic *tourpic = [[LCTourpic alloc] initWithDictionary:dic];
                    if (tourpic) {
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

+ (void)getSquareTourpic:(NSString *)orderStr callBack:(void(^)(NSArray *tourpicList, NSString *orderStr, NSError *error))callBack {
    if ([LCStringUtil isNullString:orderStr]) {
        orderStr = @"";
    }
    [[self getInstance] doPost:URL_TOURPIC_GET_SQUARE withParams:@{@"OrderStr":orderStr} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                NSMutableArray *mutArr = [[NSMutableArray alloc] init];
                NSArray *tourpicArr = [dataDic objectForKey:@"TourPicList"];
                NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
                for (NSDictionary *dic in tourpicArr) {
                    LCTourpic *tourpic = [[LCTourpic alloc] initWithDictionary:dic];
                    if (tourpic) {
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

+ (void)getTourpicByPlaceName:(NSString *)placeName orderString:(NSString *)orderString callBack:(void (^)(NSArray *, NSString *, NSError *))callBack{
    if ([LCStringUtil isNullString:placeName]) {
        if (callBack) {
            callBack(nil, nil, [NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        
        return;
    }
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:placeName forKey:@"Keyword"];
    
    if ([LCStringUtil isNotNullString:orderString]) {
        [param setObject:orderString forKey:@"OrderStr"];
    }
    
    [[self getInstance] doPost:URL_TOURPIC_GET_BY_PLACE withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                NSMutableArray *mutArr = [[NSMutableArray alloc] init];
                NSArray *tourpicArr = [dataDic objectForKey:@"TourPicList"];
                NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
                for (NSDictionary *dic in tourpicArr) {
                    LCTourpic *tourpic = [[LCTourpic alloc] initWithDictionary:dic];
                    if (tourpic) {
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

+ (void)likeTourpic:(NSString *)tourpicGuid withType:(NSString *)typeStr callBack:(void(^)(NSInteger likeNum, NSInteger forwardNum, NSInteger isLike, NSError *error))callBack {
    [[self getInstance] doPost:URL_TOURPIC_LIKE withParams:@{@"Guid":tourpicGuid, @"Type":typeStr} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (dataDic) {
            NSInteger likeNum = [[dataDic objectForKey:@"LikeNum"] integerValue];
            NSInteger forwardNum = [[dataDic objectForKey:@"ForwardNum"] integerValue];
            NSInteger isLike = [[dataDic objectForKey:@"IsLike"] integerValue];
            LCTourpic *tourpic = [[LCTourpic alloc] initWithDictionary:[dataDic objectForKey:@"Tourpic"]];
            if (nil != tourpic) {
                [[LCDataBufferManager sharedInstance] addNewTourpic:tourpic];
            }
            callBack(likeNum, forwardNum, isLike, error);
        } else {
            callBack(0, 0, 0, error);
        }
    }];
}

+ (void)unlikeTourpic:(NSString *)tourpicGuid callBack:(void(^)(NSInteger likeNum, NSInteger isLike, NSError *error))callBack {
    [[self getInstance] doPost:URL_TOURPIC_UNLIKE withParams:@{@"Guid":tourpicGuid} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (dataDic) {
            NSInteger likeNum = [[dataDic objectForKey:@"LikeNum"] integerValue];
            NSInteger isLike = [[dataDic objectForKey:@"IsLike"] integerValue];
            LCTourpic *tourpic = [[LCTourpic alloc] initWithDictionary:[dataDic objectForKey:@"Tourpic"]];
            if (nil != tourpic) {
                [[LCDataBufferManager sharedInstance] addNewTourpic:tourpic];
            }
            callBack(likeNum, isLike, error);
        } else {
            callBack(0, 0, error);
        }
    }];
}

+ (void)getTourpicDetail:(NSString *)tourpicGuid callBack:(void(^)(LCTourpic *tourpic,LCPlanModel *planModel, NSError *error))callBack {
    [[self getInstance] doGet:URL_TOURPIC_DETAIL withParams:@{@"Guid": tourpicGuid} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (dataDic) {
            NSDictionary *dic = [dataDic objectForKey:@"TourPic"];
            LCTourpic *tourpic = nil;
            if (nil != dic) {
                tourpic = [[LCTourpic alloc] initWithDictionary:dic];
            }
            NSDictionary *planDic = [dataDic objectForKey:@"PartnerPlan"];
            LCPlanModel *planModel = nil;
            if (nil != planDic) {
                planModel = [[LCPlanModel alloc] initWithDictionary:planDic];
            }
            callBack(tourpic,planModel, error);
        } else {
            callBack(nil,nil, error);
        }
    }];
}

+ (void)addTourpicComment:(NSString *)tourpicGuid withContent:(NSString *)content replyToId:(NSInteger)replyToId callBack:(void(^)(LCTourpic *tourpic, NSError *error))callBack {
    [[self getInstance] doPost:URL_TOURPIC_ADD_COMMENT withParams:@{@"Guid": tourpicGuid, @"Content": content, @"ReplyToId": [NSString stringWithFormat:@"%ld", (long)replyToId]} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (dataDic) {
            NSDictionary *dic = [dataDic objectForKey:@"TourPic"];
            LCTourpic *tourpic = nil;
            if (nil != dic) {
                tourpic = [[LCTourpic alloc] initWithDictionary:dic];
            }
            callBack(tourpic, error);
        } else {
            callBack(nil, error);
        }
    }];
}

+ (void)getUserTourpics:(NSString *)userUuid withOrderStr:(NSString *)orderStr callBack:(void(^)(NSArray *tourpicArr, NSString *orderStr, NSError *error))callBack {
    if ([LCStringUtil isNullString:orderStr]) {
        orderStr = @"";
    }
    [[self getInstance] doPost:URL_TOURPIC_MYSELFS withParams:@{@"UUID": userUuid, @"OrderStr":orderStr} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (!error) {
            NSArray *jsonArr = [dataDic objectForKey:@"TourPicList"];
            NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
            NSMutableArray *mutArr = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in jsonArr) {
                LCTourpic *tourpic = [[LCTourpic alloc] initWithDictionary:dic];
                if (tourpic) {
                    [mutArr addObject:tourpic];
                }
            }
            callBack(mutArr, orderStr, error);
        } else {
            callBack(nil, @"", error);
        }
    }];
}

+ (void)getTourpicCostPlans:(NSString *)placeName withOrderStr:(NSString *)orderStr callBack:(void(^)(NSArray *planArr, NSString *orderStr, NSError *error))callBack {
    if ([LCStringUtil isNullString:orderStr]) {
        orderStr = @"";
    }
    [[self getInstance] doPost:URL_TOURPIC_SEARCH_DEST withParams:@{@"DestName": placeName, @"OrderStr":orderStr} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (!error) {
            NSArray *jsonArr = [dataDic objectForKey:@"PlanList"];
            NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
            NSMutableArray *mutArr = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in jsonArr) {
                LCPlanModel *plan = [[LCPlanModel alloc] initWithDictionary:dic];
                if (plan) {
                    [mutArr addObject:plan];
                }
            }
            callBack(mutArr, orderStr, error);
        } else {
            callBack(nil, @"", error);
        }
    }];

}

+ (void)getTourpicLikedList:(NSString *)guid withOrderStr:(NSString *)orderStr callBack:(void(^)(NSArray *likedArr, NSString *orderStr, NSError *error))callBack {
    if ([LCStringUtil isNullString:orderStr]) {
        orderStr = @"";
    }
    [[self getInstance] doPost:URL_TOURPIC_LIKEDLIST withParams:@{@"Guid": guid, @"OrderStr":orderStr} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (!error) {
            NSArray *jsonArr = [dataDic objectForKey:@"LikedList"];
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

+ (void)getTourpicMoreComment:(NSString *)guid withOrderStr:(NSString *)orderStr callBack:(void(^)(NSArray *commentArr, NSString *orderStr, NSError *error))callBack {
    if ([LCStringUtil isNullString:orderStr]) {
        orderStr = @"";
    }
    [[self getInstance] doPost:URL_TOURPIC_MORE_COMMENTS withParams:@{@"Guid": guid, @"OrderStr":orderStr} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (!error) {
            NSArray *jsonArr = [dataDic objectForKey:@"CommentList"];
            NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
            NSMutableArray *mutArr = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in jsonArr) {
                LCTourpicComment *comment = [[LCTourpicComment alloc] initWithDictionary:dic];
                if (comment) {
                    [mutArr addObject:comment];
                }
            }
            callBack(mutArr, orderStr, error);
        } else {
            callBack(nil, @"", error);
        }
    }];
}

+ (void)getTourpicNotificationsWithOrderStr:(NSString *)orderStr callBack:(void(^)(NSArray *notifyArr, LCRedDotModel *redDot, NSString *orderStr, NSError *error))callBack {
    if ([LCStringUtil isNullString:orderStr]) {
        orderStr = @"";
    }
    [[self getInstance] doPost:URL_TOURPIC_NOTIFICATIONS withParams:@{@"OrderStr":orderStr} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (!error) {
            NSDictionary *redDotDic = [dataDic objectForKey:@"RedDot"];
            LCRedDotModel *redDot = [[LCRedDotModel alloc] initWithDictionary:redDotDic];
            NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
            NSArray *jsonArr = [dataDic objectForKey:@"UserNotifications"];
            NSMutableArray *mutArr = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in jsonArr) {
                LCUserNotificationModel *model = [[LCUserNotificationModel alloc] initWithDictionary:dic];
                if (mutArr) {
                    [mutArr addObject:model];
                }
            }
            callBack(mutArr, redDot, orderStr, error);
        } else {
            callBack(nil, nil, @"", error);
        }
    }];
}

+ (void)setMyselfTourpicCover:(NSString *)coverUrl {
    [[self getInstance] doPost:URL_TOURPIC_SET_MYSELF_COVER withParams:@{@"CoverUrl": coverUrl} requestCallBack:nil];
}


+ (void)deleteTourpicWithGuid:(NSString *)tourpicGuid callBack:(void (^)(NSError *))callBack{
    if ([LCStringUtil isNullString:tourpicGuid]) {
        if (callBack) {
            callBack([NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        return;
    }
    
    [[self getInstance] doPost:URL_TOURPIC_DELETE withParams:@{@"Guid":tourpicGuid} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            callBack(error);
        }
    }];
}

+ (void)deleteTourpicCommentWithCommentID:(NSInteger)commentID callBack:(void (^)(NSError *))callBack{
    [[self getInstance] doPost:URL_TOURPIC_DELETE_COMMENT withParams:@{@"CommentId":[LCStringUtil integerToString:commentID]} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            callBack(error);
        }
    }];
}


#pragma mark - V5
@end
