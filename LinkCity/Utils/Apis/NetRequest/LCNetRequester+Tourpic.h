//
//  LCNetRequester.h
//  LinkCity
//
//  Created by roy on 2/5/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCHttpApi.h"
#import "LCInitData.h"
#import "LCUserLocation.h"
#import "LCPlanModel.h"
#import "LCCommentModel.h"
#import "LCAuthCode.h"
#import "LCUserModel.h"
#import "LCUserEvaluationModel.h"
#import "LCUserRouteModel.h"
#import "LCHomeCategoryModel.h"
#import "LCUserLocation.h"
#import "LCUserIdentityModel.h"
#import "LCCarIdentityModel.h"
#import "LCChatGroupModel.h"
#import "LCPhoneContactorModel.h"
#import "LCChatContactModel.h"
#import "LCCloseReplyTestModel.h"
#import "LCTourpic.h"
#import "LCUserNotifyModel.h"
#import "LCRedDotModel.h"
#import "LCUserNotificationModel.h"
#import "LCTourpicComment.h"
#import "LCGuideIdentityModel.h"
#import "LCWebPlanModel.h"
#import "LCDestinationPlaceModel.h"


@interface LCNetRequester (Tourpic)

+ (void)publishTourPic:(NSString *)picUrl
             secondPic:(NSString *)secondPicUrl
              thirdPic:(NSString *)thirdPicUrl
             placeName:(NSString *)placeName
           description:(NSString *)description
           companyList:(NSString *)companyJsonStr
              callBack:(void(^)(NSError *error))callBack;
+ (void)sendTourPic:(NSArray *)tourPicArray
           withType:(NSInteger)type
       userLocation:(LCUserLocation *)location
          placeName:(NSString *)placeName
        description:(NSString *)description
        planGuid:(NSString *)planGuid
           callBack:(void(^)(NSError *error))callBack;
+ (void)getPopularTourpic:(NSString *)orderStr callBack:(void(^)(NSArray *tourpicList, NSString *orderStr, NSError *error))callBack;
+ (void)getFocusTourpicWithOrderString:(NSString *)orderStr callBack:(void(^)(NSArray *tourpicList, NSString *orderStr, NSError *error))callBack;
+ (void)getSquareTourpic:(NSString *)orderStr callBack:(void(^)(NSArray *tourpicList, NSString *orderStr, NSError *error))callBack;
+ (void)getTourpicByPlaceName:(NSString *)placeName orderString:(NSString *)orderString callBack:(void(^)(NSArray *tourpicList, NSString *orderStr, NSError *error))callBack;
+ (void)likeTourpic:(NSString *)tourpicGuid withType:(NSString *)typeStr callBack:(void(^)(NSInteger likeNum, NSInteger forwardNum, NSInteger isLike, NSError *error))callBack;
+ (void)unlikeTourpic:(NSString *)tourpicGuid callBack:(void(^)(NSInteger likeNum, NSInteger isLike, NSError *error))callBack;
+ (void)getTourpicDetail:(NSString *)tourpicGuid callBack:(void(^)(LCTourpic *tourpic,LCPlanModel *planModel, NSError *error))callBack;
+ (void)addTourpicComment:(NSString *)tourpicGuid withContent:(NSString *)content replyToId:(NSInteger)replyToId callBack:(void(^)(LCTourpic *tourpic, NSError *error))callBack;
+ (void)getUserTourpics:(NSString *)userUuid withOrderStr:(NSString *)orderStr callBack:(void(^)(NSArray *tourpicArr, NSString *orderStr, NSError *error))callBack;
+ (void)getTourpicLikedList:(NSString *)guid withOrderStr:(NSString *)orderStr callBack:(void(^)(NSArray *likedArr, NSString *orderStr, NSError *error))callBack;
+ (void)getTourpicMoreComment:(NSString *)guid withOrderStr:(NSString *)orderStr callBack:(void(^)(NSArray *commentArr, NSString *orderStr, NSError *error))callBack;
+ (void)getTourpicNotificationsWithOrderStr:(NSString *)orderStr callBack:(void(^)(NSArray *notifyArr, LCRedDotModel *redDot, NSString *orderStr, NSError *error))callBack;
+ (void)setMyselfTourpicCover:(NSString *)coverUrl;
+ (void)deleteTourpicWithGuid:(NSString *)tourpicGuid callBack:(void(^)(NSError *error))callBack;
+ (void)deleteTourpicCommentWithCommentID:(NSInteger)commentID callBack:(void(^)(NSError *error))callBack;
+ (void)getTourpicCostPlans:(NSString *)placeName withOrderStr:(NSString *)orderStr callBack:(void(^)(NSArray *planArr, NSString *orderStr, NSError *error))callBack;

+ (void)getPlanLinkingTourpicWithPlanGuid:(NSString *)planGuid orderStr:(NSString *)orderStr callBack:(void(^)(NSArray *tourpicList, NSString *orderStr, NSError *error))callBack;

@end


