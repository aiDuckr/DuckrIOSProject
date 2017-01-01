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
#import "LCHomeCellModel.h"

@interface LCNetRequester : LCHttpApi
+ (instancetype)getInstance;


#pragma mark Register & Login
+ (void)sendAuthCodeToTelephoneForRegister:(NSString *)phone callBack:(void(^)(LCAuthCode *authCode, NSError *error))callBack;
+ (void)sendAuthCodeToTelephoneForResetPassword:(NSString *)phone callBack:(void(^)(LCAuthCode *authCode, NSError *error))callBack;
+ (void)verifyAuthCodeWithTelephone:(NSString *)phone authCode:(NSString *)authCode callBack:(void(^)(NSError *error))callBack;
+ (void)registerUserWithTelephone:(NSString *)phone
                         password:(NSString *)password
                         authCode:(NSString *)authCode callBack:(void(^)(LCUserModel *user, NSError *error))callBack;
+ (void)updateUserInfoWithNick:(NSString *)nick
                           sex:(NSInteger)sex
                     avatarURL:(NSString *)avatarURL
                livingProvince:(NSString *)livingProvince
                   livingPlace:(NSString *)livingPlace
                      realName:(NSString *)realName
                        school:(NSString *)school
                       company:(NSString *)company
                      birthday:(NSString *)birthday
                     signature:(NSString *)signature
                    profession:(NSString *)professional
                  wantGoPlaces:(NSArray *)wantGoPlaces  //string array
                  haveGoPlaces:(NSArray *)haveGoPlaces  //string array
                      callBack:(void (^)(LCUserModel *, NSError *))callBack;

+ (void)loginWithPhone:(NSString *)phone password:(NSString *)password callBack:(void(^)(LCUserModel *user, NSError *error))callBack;
+ (void)resetPasswordWithTelephone:(NSString *)phone
                          password:(NSString *)password
                          authCode:(NSString *)authCode
                          callBack:(void(^)(LCUserModel *user, NSError *error))callBack;


#pragma mark Route
+ (void)sendRoute:(LCUserRouteModel *)userRoute type:(NSInteger)type callBack:(void(^)(LCUserModel *user, LCUserRouteModel *userRoute, NSError *error))callBack;
+ (void)deleteRoute:(NSInteger)userRouteID callBack:(void(^)(NSError *error))callBack;
+ (void)getRelevantPlanOfRoute:(NSInteger)userRouteID callBack:(void(^)(NSArray *plans, NSError *error))callBack;


#pragma mark Chat
+ (void)getNearbyChatGroupListByLocation:(LCUserLocation *)location callBack:(void(^)(NSArray *chatGroupArray, NSError *error))callBack;
+ (void)getMyChatGroupListWithCallBack:(void(^)(NSArray *chatGroupArray, NSError *error))callBack;
+ (void)getChatGroupListByPlaceName:(NSString *)placeName callBack:(void(^)(NSArray *chatGroupArray, NSError *error))callBack;
+ (void)getChatGroupInfoForGroupGuid:(NSString *)guid callBack:(void(^)(LCChatGroupModel *chatGroup, NSError *error))callBack;


+ (void)joinChatGroupWithChatGroupGuid:(NSString *)guid location:(LCUserLocation *)location callBack:(void(^)(LCChatGroupModel *chatGroup, NSError *error))callBack;
+ (void)quitChatGroupWithChatGroupGuid:(NSString *)guid callBack:(void(^)(NSError *error))callBack;
+ (void)getChatContactInfoWith:(NSArray *)jidStringArray callBack:(void(^)(NSArray *chatContactArray, NSError *error))callBack;
+ (void)getJoinedChatRoomJIDListWithCallback:(void(^)(NSArray *roomJidList, NSInteger maxAutoOnlineCount, NSError *error))callBack;

+ (void)getFavoredUserOfUserUuid:(NSString *)userUuid callBack:(void (^)(NSArray *, NSError *))callBack;
+ (void)getRecommendedUserListWithCallBack:(void(^)(NSArray *userArray, NSError *error))callBack;

/* @param registeredUserArray   array of LCUserModel
 @param invitedPhoneContactArray    array of LCPhoneContactModel
 */
+ (void)getInviteUserListInAddressBookWithCallBack:(void(^)(NSArray *registeredPhoneContactArray, NSArray *invitedPhoneContactArray, NSError *error))callBack;
+ (void)inviteUserInAddressBookWithTelephone:(NSString *)telephone callBack:(void(^)(NSError *error))callBack;

+ (void)getUserInfoByTelephone:(NSString *)telephone planOrGroupGuid:(NSString *)guid callBack:(void(^)(LCUserModel *user, NSError *error))callBack;

+ (void)setPlanAlert:(NSInteger)isAlert planGuid:(NSString *)planGuid callBack:(void(^)(NSInteger isAlert, NSError *error))callBack;
+ (void)setChatGroupAlert:(NSInteger)isAlert groupGuid:(NSString *)groupGuid callBack:(void(^)(NSInteger isAlert, NSError *error))callBack;

#pragma mark SearchResult
+ (void)searchMixPlanForDestionation:(NSString *)placeName
                          orderType:(LCPlanOrderType)orderType
                             themeId:(NSInteger)themeId
                         orderString:(NSString *)orderString
                            isDepart:(BOOL)isDepart    // 为1则根据出发地进行搜索,否则根据目的地
                            callBack:(void(^)(NSArray *typeList,
                                              NSArray *planList,
                                              LCDestinationPlaceModel *place,
                                              NSString *orderString,
                                              NSError *error))callBack;

+ (void)searchHereForDestination:(NSString *)placeName callBack:(void(^)(NSArray *tourPicList, NSArray *duckrList, NSError *error))callBack;

+ (void)searchMixPlanForTheme:(NSInteger)themeId
                      locName:(NSString *)locName
                  orderString:(NSString *)orderString
                     callBack:(void(^)(NSArray *planList,
                                       LCRouteThemeModel *theme,
                                       NSString *orderString,
                                       NSError *error))callBack;

#pragma mark Setting
+ (void)setInvitedUserTelephone:(NSString *)telephone callBack:(void(^)(NSError *error))callBack;
+ (void)getSystemUserInfoWithCallback:(void(^)(LCUserModel *systemUser, NSError *error))callBack;

//！！！接口暂不返回notifyModel
+ (void)setNotify:(LCUserNotifyModel *)notifyModel callBack:(void(^)(LCUserNotifyModel *notifyModel, NSError *error))callBack;
//获取个人Tab中，通知列表中的通知
+ (void)getUserNotificationListWithOrderStr:(NSString *)orderStr callBack:(void(^)(NSArray *userNotificationArray, NSString *orderStr, LCRedDotModel *redDot, NSError *error))callBack;

#pragma mark Common
+ (void)updateRemoteNotificationDeviceToken:(NSString *)deviceToken
                                   callBack:(void(^)(NSError *error))callBack;


+ (void)updateLocationWithLat:(double)lat
                          lon:(double)lon
                 provinceName:(NSString *)provinceName
                     cityName:(NSString *)cityName
                     areaName:(NSString *)areaName
                     callBack:(void(^)(LCUserLocation *location, NSError *error))callBack;


+ (void)getQiniuUploadTokenOfImageType:(NSString *)imageType
                              callBack:(void(^)(NSString *uploadToken, NSString *picKey, NSError *error))callBack;

/// 获取应用初始化数据.
+ (void)getInitConfigWithCallBack:(void(^)(LCInitData *initData, NSError *error))callBack;
/// 应用启动设置初始化数据.
+ (void)setAppConfigWithCallBack:(void(^)(NSError *error))callBack;


+ (void)getRouteThemesWithCallBack:(void(^)(NSArray *themeArray, NSError *error))callBack;

+ (void)searchRelatedPlaceFor:(NSString *)placeName callBack:(void(^)(NSArray *placeArray, NSError *error))callBack;
+ (void)uploadAddressBookWithDic:(NSDictionary *)addressBookDic callBack:(void(^)(NSError *error))callBack;
+ (void)getRedDotNumWithCallBack:(void(^)(LCRedDotModel *redDot, NSError *error))callBack;
+ (void)didBlockUMengWithCallBack:(void(^)(NSError *error))callBack;


#pragma mark Home//before V3.1
+ (void)getHomePageContentWithLocation:(LCUserLocation *)location
                              callBack:(void(^)(NSArray *topList,            //array of LCPlanCategoryModel
                                                NSArray *nearbyPlanList,     //array of LCPlanModel
                                                NSArray *domesticList,       //array of LCPlanCategoryModel
                                                NSArray *foreignList,        //array of LCPlanCategoryModel
                                                NSArray *themeList,          //array of LCPlanCategoryModel
                                                LCPlanModel *myselfPlan,
                                                NSError *error))callBack;

//For V3.1
+ (void)getHomePageContentWithLocation:(LCUserLocation *)location
                              province:(NSString *)province
                                  city:(NSString *)city
                          locationName:(NSString *)locName
                              callBack:(void(^)(NSString *locName,
                                                NSInteger recmdPlanNum,
                                                NSArray *planArray,
                                                NSArray *favorPlanArray,
                                                NSArray *placeArray,
                                                NSInteger recmdUserNum,
                                                NSArray *userArray,
                                                NSArray *prmtArray,
                                                NSError *error))callBack;


+ (void)getHomePageRecmdPlanByLocation:(LCUserLocation *)location
                               locName:(NSString *)locName
                            filterType:(LCPlanOrderType)filterType
                           orderString:(NSString *)orderStr
                              callBack:(void(^)(NSArray *planArray,
                                                NSString *orderStr,
                                                NSError *error))callBack;
+ (void)getHomePageRecmdUserByLocation:(LCUserLocation *)location
                               locName:(NSString *)locName
                            filterType:(LCUserFilterType)filterType
                           orderString:(NSString *)orderStr
                              callBack:(void(^)(NSArray *userArray,
                                                NSString *orderStr,
                                                NSError *error))callBack;

+ (void)getHomePageFavorPlanByOrderString:(NSString *)orderStr
                                 callBack:(void(^)(NSArray *planArray,
                                                   NSString *orderStr,
                                                   NSError *error))callBack;


//For V4
//+ (void)getHomePageContent_V_Four_WithLocation:(LCUserLocation *)location
//                                      province:(NSString *)province
//                                          city:(NSString *)city
//                                  locationName:(NSString *)locName
//                                   tourThemeId:(NSInteger)tourThemeId
//                                     orderType:(LCPlanOrderType)orderType
//                                      orderStr:(NSString *)orderStr
//                                      callBack:(void(^)(NSString *locName,
//                                                        NSArray *homeCellArray,
//                                                        NSInteger tourThemeId,
//                                                        LCPlanOrderType orderType,
//                                                        NSString *orderStr,
//                                                        NSString *requestOrderStr,
//                                                        NSError *error))callBack;

+ (void)getHomePageRecmdPlan_V_Four_ByLocation:(LCUserLocation *)location
                                       locName:(NSString *)locName
                                    filterType:(LCPlanOrderType)filterType
                                   orderString:(NSString *)orderStr
                                      planType:(NSInteger)planType
                                       themeId:(NSInteger)themeId
                                      callBack:(void(^)(NSArray *planArray,
                                                        NSString *orderStr,
                                                        NSError *error))callBack;

;

//For V5
+ (void)getCalendarPlan_V_Five_ByLocationName:(NSString *)locName
                                 startDate:(NSDate *)date
                                  orderStr:(NSString *)orderStr
                                  callBack:(void(^)(NSArray *planArray,
                                                   NSString *orderStr,
                                                   NSError *error))callBack;

+ (void)getLocationTourpic_V_Five_ByLocationName:(NSString *)locName
                                        orderStr:(NSString *)orderStr
                                        callBack:(void(^)(NSArray *tourpicArray,
                                                          NSString *orderStr,
                                                          NSError *error))callBack;

+ (void)getLocationNearbyPlan_V_Five_ByLocationName:(NSString *)locName
                                           location:(LCUserLocation *)location
                                           orderStr:(NSString *)orderStr
                                           callBack:(void(^)(NSArray *planArray,
                                                             NSString *orderStr,
                                                             NSError *error))callBack;
/// 获取省份.
+ (void)getHotCitysAndProvincesWithCallBack:(void(^)(NSArray *provinceArr, NSArray *hotCityArr, NSError *error))callBack;
/// 获取省份的城市.
+ (void)getCitysByProvinceID:(NSString *)provinceID callBack:(void(^)(NSArray *contentArr, NSError *error))callBack;
@end




