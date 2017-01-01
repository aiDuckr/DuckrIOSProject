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
#import "LCWxPrepayModel.h"
#import "LCNotificationModel.h"
#import "LCPlanBillModel.h"
#import "LCUserAccount.h"
#import "LCBankcard.h"

@interface LCNetRequester (User)

+ (void)getUserInfo:(NSString *)uuid callBack:(void(^)(LCUserModel *user, NSError *error))callBack;
+ (void)searchUserByKeyWord:(NSString *)keyword callBack:(void(^)(NSArray *userArray, NSError *error))callBack;
+ (void)evaluateUser:(NSString *)userUUID
                type:(NSInteger)type    //1 realName    2 anonymous
               score:(float)score
             content:(NSString *)content
                tags:(NSArray *)tags
            callBack:(void(^)(LCUserEvaluationModel *userEvaluation, NSError *error))callBack;
+ (void)getEvaluationForUser:(NSString *)userUUID orderStr:(NSString *)orderStr callBack:(void(^)(NSArray *evaluationArray, NSString *orderStr, NSError *error))callBack;
+ (void)getUserService:(NSString *)userUUID callBack:(void(^)(LCCarIdentityModel *userCar, NSMutableArray *userRoutes, NSError *error))callBack;
+ (void)followUser:(NSArray *)userUuidArray callBack:(void(^)(NSError *error))callBack;
+ (void)unfollowUser:(NSString *)uuid callBack:(void(^)(LCUserModel *user, NSError *error))callBack;
+ (void)getNearbyTouristByLocation:(LCUserLocation *)location skip:(NSInteger)skipNum filterType:(LCUserFilterType)filterType callBack:(void(^)(NSArray *touristArray, NSError *error))callBack;
+ (void)getNearbyDuckrByLocation:(LCUserLocation *)location
                            skip:(NSInteger)skipNum
                      filterType:(LCUserFilterType)filterType
                         locName:(NSString *)locName
                        callBack:(void(^)(NSArray *nativeArray, NSError *error))callBack;

+ (void)userIdentityWith:(LCUserIdentityModel *)userIdentity callBack:(void(^)(LCUserIdentityModel *userIdentity, LCUserModel *user, NSError *error))callBack;
+ (void)getUserIdentityInfoWithCallBack:(void(^)(LCUserIdentityModel *userIdentity, NSError *error))callBack;
+ (void)carIdentityWith:(LCCarIdentityModel *)carIdentity callBack:(void(^)(LCCarIdentityModel *carIdentity, LCUserModel *user, NSError *error))callBack;
+ (void)userMarginOrderNew:(NSDecimalNumber *)marginValue
                     wxPay:(NSInteger)isWxPay
                  callBack:(void(^)(NSString *orderGuid, NSDecimalNumber *marginValue, LCWxPrepayModel *wxPrepay, NSError *error))callBack;
+ (void)userMarginOrderQuery:(NSString *)orderGuide       // 必填，订单的Guid
                    callBack:(void(^)(LCUserModel *user, NSError *error))callBack;
+ (void)getCarIdentityInfoWithCallBack:(void(^)(LCCarIdentityModel *carIdentity, NSError *error))callBack;
+ (void)guideIdentityApproveWithCallBack:(void(^)(LCUserModel *user, NSError *error))callBack;
+ (void)guideIdentityWith:(LCGuideIdentityModel *)guideIdentity callBack:(void(^)(LCGuideIdentityModel *guideIdentity, LCUserModel *user, NSError *error))callBack;
+ (void)getGuideIdentityInfoWithCallBack:(void(^)(LCGuideIdentityModel *guideIdentity, NSError *error))callBack;

+ (void)getFansListOfUser:(NSString *)userUuid orderStr:(NSString *)orderStr callBack:(void (^)(NSArray *, NSString *, NSError *))callBack;
+ (void)getUserListByPlaceName:(NSString *)placeName orderStr:(NSString *)orderStr callBack:(void(^)(NSArray *userArray, NSString *orderStr, NSError *error))callBack;
+ (void)getSchoolListByString:(NSString *)str callBack:(void(^)(NSArray *schoolArray, NSError *error))callBack;

+ (void)getUserHomepage:(NSString *)userUuid callBack:(void(^)(LCUserModel *user,
                                                               NSArray *planArray,
                                                               NSArray *tourpicArray,
                                                               LCCarIdentityModel *carService,
                                                               NSError *error))callBack;

+ (void)reportUser:(NSString *)userUuid reason:(NSString *)reason callBack:(void(^)(NSString *msg, NSError *error))callBack;
+ (void)reportUser_V_FIVE:(NSString *)target reportType:(NSString *)reportType reason:(NSString *)reason photoUrls:(NSArray *)photoUrls callBack:(void (^)(NSString *msg,
                                                                                                                                                           NSError *error))callBack;


// v5.1
+ (void)getFansListOfUser_V_FIVE:(NSString *)userUuid orderStr:(NSString *)orderStr callBack:(void (^)(NSArray *userArray,
                                                                                                      NSString *orderStr,
                                                                                                      NSError *error))callBack;
+ (void)getFansDynamic_V_FIVE:(NSString *)userUuid orderStr:(NSString *)orderStr callBack:(void (^)(NSArray *contentArray,
                                                                                                    NSString *orderStr,
                                                                                                    NSError *error))callBack;

+ (void)getFavorsListOfUser_V_FIVE:(NSString *)userUuid orderStr:(NSString *)orderStr callBack:(void (^)(NSArray *userArray,
                                                                                                         NSString *orderStr,
                                                                                                         NSError *error))callBack;

+ (void)getFavorsDynamic_V_FIVE:(NSString *)userUuid orderStr:(NSString *)orderStr callBack:(void (^)(NSArray *contentArray,
                                                                                                      NSString *orderStr,
                                                                                                      NSError *error))callBack;

+ (void)getFansSearchResult_V_FIVE:(NSString *)keyWord callBack:(void (^)(NSArray *userArray,
                                                                          NSError *error))callBack;

+ (void)getUserRedDot_V_FIVE:(void (^)(LCRedDotModel *redDot, NSError *error))callBack;

+ (void)getUserAllOrder_V_FIVE:(NSString *)orderStr callBack:(void (^)(NSArray *planArray,
                                                                       NSArray *orderArray,
                                                                       NSString *orderStr,
                                                                       NSError *error))callBack;

+ (void)getUserPendingPaymentOrder_V_FIVE:(NSString *)orderStr callBack:(void (^)(NSArray *planArray,
                                                                                  NSString *orderStr,
                                                                                  NSError *error))callBack;

+ (void)getUserToBeEvaluatedOrder_V_FIVE:(NSString *)orderStr callBack:(void (^)(NSArray *planArray,
                                                                                 NSArray *orderArray,
                                                                                 NSString *orderStr,
                                                                                 NSError *error))callBack;

+ (void)getUserRefundOrder_V_FIVE:(NSString *)orderStr callBack:(void (^)(NSArray *planArray,
                                                                          NSArray *orderArray,
                                                                          NSString *orderStr,
                                                                          NSError *error))callBack;

+ (void)deleteUserOrderWithOrderGuid_V_FIVE:(NSString *)orderGuid callBack:(void (^)(NSString *msg,
                                                                                     NSError *error))callBack;

+ (void)getUserRecmDuckrListWithLocName_V_FIVE:(NSString *)locName location:(LCUserLocation *)location orderStr:(NSString *)orderStr callBack:(void (^)(NSArray *userArray,
                                                                                                                                                        NSArray *mixedArray,
                                                                                                                                                        NSString *orderStr,
                                                                                                                                                        NSError *error))callBack;

+ (void)setUserRemarkName:(NSString *)remarkName remarkUUID:(NSString *)remarkUuid callBack:(void (^)(NSString *message,
                                                                                                      NSError *error))callBack;


//v5 get user plan
+ (void)getUserJoinedPlan:(NSString *)userUuid orderString:(NSString *)orderString callBack:(void(^)(NSArray *planList,NSString *orderStr,NSError *error))callBack;

+ (void)getUserFavoredPlan:(NSString *)userUuid orderString:(NSString *)orderString callBack:(void(^)(NSArray *planList,NSString *orderStr,NSError *error))callBack;

+ (void)getUserRaisedPlan:(NSString *)userUuid orderString:(NSString *)orderString callBack:(void(^)(NSArray *planList,NSString *orderStr,NSError *error))callBack;

//v5.1 for user setting
+ (void)getAllContactUserWithCallBack:(void(^)(NSArray *userList, NSError *error))callBack;
+ (void)setWifiVedioAutoPlay:(BOOL)isAutoPlay callBack:(void(^)(NSString *message, NSError *error))callBack;

+ (void)setShowSelfToContact:(BOOL)isShowSelfToContract callBack:(void(^)(NSString *message, NSError *error))callBack;
/// 获取我的服务列表.
+ (void)requestMerchantServiceList:(NSString *)orderStr callBack:(void(^)(NSArray *contentArr, NSString *orderStr, NSError *error))callBack;
/// 获取我的账单列表.
+ (void)requestMerchantBillList:(NSString *)orderStr callBack:(void(^)(NSArray *contentArr, LCUserAccount *account, NSString *orderStr, NSError *error))callBack;
/// 获取退款处理列表.
+ (void)requestMerchantRefundList:(NSString *)orderStr callBack:(void(^)(NSArray *planArr, NSArray *userArr, NSString *orderStr, NSError *error))callBack;
/// 我的—商家主页—退款申请详情.
+ (void)requestMerchantRefundDetail:(NSString *)orderGuid callBack:(void(^)(LCPlanModel *plan, LCUserModel *user, NSError *error))callBack;
/// 我的—商家主页—我的服务列表—报名详情.
+ (void)requestMerchantSignUpDetail:(NSString *)planGuid callBack:(void(^)(NSArray *planArr, NSError *error))callBack;
/// 我的—商家主页—退款申请—确认退款.
+ (void)requestMerchantAgreeRefund:(NSString *)orderGuid withMoney:(NSString *)refundNumStr callBack:(void(^)(NSError *error))callBack;
/// 我的—商家主页—验票.
+ (void)requestMerchantCheckTicket:(NSString *)code callBack:(void(^)(LCPlanModel *plan, LCUserModel *user, NSError *error))callBack;
/// 我的—商家主页—绑定银行卡.
+ (void)requestMerchantAddBankcard:(LCBankcard *)bankcard callBack:(void(^)(LCUserAccount *account, NSError *error))callBack;
/// 我的—商家主页—确认提现.
+ (void)requestMerchantWithdraw:(LCBankcard *)bankcard withAmount:(NSString *)amount callBack:(void(^)(NSError *error))callBack;
/// 我的—商家主页—提现记录.
+ (void)requestMerchantWithdrawList:(NSString *)orderStr callBack:(void(^)(NSArray *contentArr, NSString *orderStr, NSError *error))callBack;
/// 我的—商家主页—银行列表.
+ (void)requestMerchantBankWithcallBack:(void(^)(NSArray *hotBankArr, NSArray *letterBankArr, NSError *error))callBack;
+ (void)getNotificationListWithOrderStr:(NSString *)orderStr callBack:(void (^)(NSArray *,NSString *, NSError *))callBack;
@end


