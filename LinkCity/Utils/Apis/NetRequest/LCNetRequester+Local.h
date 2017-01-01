//
//  LCNetRequester+Local.h
//  LinkCity
//
//  Created by linkcity on 16/8/3.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCNetRequester.h"
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

@interface LCNetRequester (Local)
+ (void)requestLocalList:(NSString *)orderStr themeId:(NSInteger)themeId sex:(NSInteger)sex orderType:(NSInteger)type withCallBack:(void(^)(NSArray *contentArr, NSString *orderStr, NSError *error))callBack;
+ (void)requestToJoinLocalwiththemeId:(NSInteger)themeId ThemeStr:(NSString*)themeStr withCallBack:(void(^)(NSArray *contentArr, NSError *error))callBack;

/// 本地—活动页.
+ (void)requestLocalTrades:(NSString *)orderStr withCallBack:(void(^)(NSArray *rcmdArr, NSArray *contentArr, NSString *orderStr, NSError *error))callBack;
/// 本地—邀约页.
+ (void)requestLocalInvites:(NSString *)orderStr themeId:(NSInteger)themeId sex:(NSInteger)sex orderType:(NSInteger)type withCallBack:(void(^)(NSArray *contentArr, NSString *orderStr, NSError *error))callBack;
/// 本地-主题页筛选
+ (void)requestThemeCalendar:(NSArray *)dateArr priceArr:(NSArray *)priceArr themeID:(NSInteger )themeId OrderType:(NSString*)orderType orderStr:(NSString *)orderStr withCallBack:(void(^)(NSArray *contentArr, NSString *orderStr, NSError *error))callBack;

@end
