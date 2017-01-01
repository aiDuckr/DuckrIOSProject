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
#import "LCWeatherDay.h"

@interface LCNetRequester (Plan)

+ (void)sendPlan:(LCPlanModel *)plan callBack:(void(^)(LCPlanModel *planSent, NSError *error))callBack;
+ (void)getRouteForSendPlan:(NSString *)departName
                  destNames:(NSArray *)destNames
                  startTime:(NSString *)startTimeStr
                    endTime:(NSString *)endTimeStr
                   daysLong:(NSInteger)daysLong
                   orderStr:(NSString *)orderStr
                   callBack:(void(^)(NSArray *userRoutes, NSString *orderStr, NSError *error))callBack;

+ (void)getRecommendOfPlan:(NSString *)planGuid callBack:(void(^)(NSArray *userArray, NSArray *planArray, NSArray *webPlanArray, NSError *error))callBack;

//search
+ (void)getCreatedPlansOfUser:(NSString *)uuid orderString:(NSString *)orderString callBack:(void(^)(NSArray *plans, NSString *orderStr, NSError *error))callBack;
+ (void)getJoinedPlansOfUser:(NSString *)uuid orderString:(NSString *)orderString callBack:(void(^)(NSArray *plans, NSString *orderStr, NSError *error))callBack;
+ (void)getFavoredPlansWithOrderString:(NSString *)orderString callBack:(void(^)(NSArray *plans, NSString *orderStr, NSError *error))callBack;
+ (void)getUserPlanHelperListWithCallBack:(void(^)(NSArray *byJoinePlanList, NSArray *byWantGoPlanList, NSError *error))callBack;
+ (void)getPlanDetailFromPlanGuid:(NSString *)planGuid callBack:(void(^)(LCPlanModel *plan,NSArray * tourpicArray, NSError *error))callBack;
+ (void)getPlanJoinedUserListFromPlanGuid:(NSString *)planGuid callBack:(void(^)(NSArray *stageArray, NSDecimalNumber *totalStageIncome, NSError *error))callBack;
+ (void)searchPlanByDestination:(NSString *)dest orderString:(NSString *)orderString callBack:(void(^)(NSArray *plans, NSString *orderStr,NSError *error))callBack;
+ (void)searchPlanByDestination:(NSString *)dest PlanType:(NSInteger)planType DepartName:(NSString *)departName StartDate:(NSString *)startDate endDate:(NSString *)endDate orderString:(NSString *)orderString callBack:(void (^)(NSArray *, NSString *, NSError *))callBack;
+ (void)searchDestinationFromHomePage:(NSString *)dest callBack:(void(^)(NSArray *weatherArray, NSArray *routeArray, NSArray *tourpicArray, NSArray *planArray, LCDestinationPlaceModel *place, NSError *error))callBack;
+ (void)searchPlanByTheme:(NSInteger)themeID orderString:(NSString *)orderString callBack:(void(^)(NSArray *plans, NSString *orderStr, NSError *error))callBack;
+ (void)getNearbyPlanByLocation:(LCUserLocation *)location
                           skip:(NSInteger)skipNum
                      orderType:(LCPlanOrderType)orderType
                        locName:(NSString *)locName
                       callBack:(void(^)(NSArray *planArray, NSArray *webPlanArray, NSError *error))callBack;

//comment
+ (void)addCommentToPlan:(NSString *)planGuid
                 content:(NSString *)content
               replyToId:(NSInteger)replyToId
                   score:(NSInteger)score
                withType:(NSString *)type
                callBack:(void (^)(LCCommentModel *, NSError *))callBack;
+ (void)getCommentOfPlan:(NSString *)planGuid corderString:(NSString *)orderString callBack:(void(^)(NSArray *commentArray, NSString *orderStr, NSError *error))callBack;
+ (void)deleteCommentOfPlanWithCommentID:(NSString *)commentID callBack:(void(^)(NSError *error))callBack;

//apply, approve, refuse, quit, delete
+ (void)joinPlan:(NSString *)planGuid callBack:(void(^)(LCPlanModel *plan,NSError *error))callBack;
+ (void)approveUser:(NSString *)userUuid toJoinPlan:(NSString *)planGuid callBack:(void(^)(NSError *error))callBack;
+ (void)refuseUser:(NSString *)userUuid toJoinPlan:(NSString *)planGuid callBack:(void(^)(NSError *error))callBack;
+ (void)quitPlan:(NSString *)planGuid callBack:(void(^)(NSError *error))callBack;
+ (void)deletePlan:(NSString *)planGuid callBack:(void(^)(NSError *error))callBack;
+ (void)kickOffUser:(NSString *)userUUID ofPlan:(NSString *)planGuid callBack:(void(^)(LCPlanModel *plan, NSError *error))callBack;
+ (void)forwardPlan:(NSString *)planGuid callBack:(void(^)(NSInteger forwardNum, NSError *error))callBack;
+ (void)favorPlan:(NSString *)planGuid withType:(NSInteger)type callBack:(void (^)(LCPlanModel *plan, NSError *error))callBack;
+ (void)checkInPlan:(NSString *)planGuid location:(LCUserLocation *)location callBack:(void(^)(NSError *error))callBack;
// add to cart
+ (void)addToCartByPlanGuid:(NSString *)planGuid callBack:(void (^)(NSError *error))callBack;

//Stage
+ (void)planStageUpdate:(NSString *)planGuid
                  price:(NSDecimalNumber *)price
                 maxNum:(NSInteger)maxNum
              startTime:(NSString *)startTime
                endTime:(NSString *)endTime
                  isAdd:(BOOL)isAdd
               callBack:(void(^)(LCPlanModel *plan, NSError *error))callBack;

+ (void)planStageRemove:(NSString *)planGuid
               callBack:(void(^)(NSError *error))callBack;

+ (void)getPlanLikedList:(NSString *)guid withOrderStr:(NSString *)orderStr callBack:(void(^)(NSArray *likedArr, NSString *orderStr, NSError *error))callBack;


@end
