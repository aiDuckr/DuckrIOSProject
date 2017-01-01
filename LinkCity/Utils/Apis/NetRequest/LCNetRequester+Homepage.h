//
//  LCNetRequester.h
//  LinkCity
//
//  Created by 张宗硕 on 5/18/16.
//  Copyright (c) 2016 linkcity. All rights reserved.
//

#import "LCHttpApi.h"
#import "LCInitData.h"
#import "LCUserLocation.h"
#import "LCPlanModel.h"
#import "LCUserModel.h"
#import "LCHomeCategoryModel.h"
#import "LCUserLocation.h"
#import "LCTourpic.h"
#import "LCUserNotifyModel.h"
#import "LCWeatherDay.h"
#import "LCHomeRcmd.h"

typedef enum {
    LCNetRequesterType_Tourpic = 0,
    LCNetRequesterType_Plan = 1,
    LCNetRequesterType_User = 2,
} LCNetRequesterType;

typedef enum {
    LCNetRequesterPlanFilterType_Default = 0,
    LCNetRequesterPlanFilterType_Plan = 1,
    LCNetRequesterPlanFilterType_Local = 2,
} LCNetRequesterPlanFilterType;

@interface LCNetRequester (Homepage)
/// 首页推荐.
+ (void)requestHomeRcmds:(NSString *)orderStr withCallBack:(void(^)(NSArray *rcmdArr, NSArray *contentArr, NSString *orderStr, NSString *whatHotStr, NSError *error))callBack;
/// 首页邀约.
+ (void)requestHomeInvites:(NSString *)orderStr themeId:(NSInteger)themeId sex:(NSInteger)sex orderType:(NSInteger)type withCallBack:(void(^)(NSArray *contentArr, NSString *orderStr, NSError *error))callBack;

/// 首页—推荐页—为你精选.
+ (void)requestHomeRcmdPersonal:(NSString *)orderStr withCallBack:(void(^)(NSArray *contentArr, NSString *orderStr, NSError *error))callBack;
/// 首页—推荐页—模块—为你精选.
+ (void)requestHomeRcmdModulePersonalWithCallBack:(void(^)(LCHomeRcmd *homeRcmd, NSError *error))callBack;

/// 首页—推荐页—附近精选.
+ (void)requestHomeRcmdNearby:(NSString *)orderStr withCallBack:(void(^)(NSArray *contentArr, NSString *orderStr, NSError *error))callBack;
/// 首页—推荐页—今日精选.
+ (void)requestHomeRcmdToday:(NSString *)orderStr withCallBack:(void(^)(NSArray *contentArr, NSString *orderStr, NSError *error))callBack;
/// 首页—推荐页—明日精选.
+ (void)requestHomeRcmdTomorrow:(NSString *)orderStr withCallBack:(void(^)(NSArray *contentArr, NSString *orderStr, NSError *error))callBack;
/// 首页—推荐页—周末精选.
+ (void)requestHomeRcmdWeekend:(NSString *)orderStr withCallBack:(void(^)(NSArray *contentArr, NSString *orderStr, NSError *error))callBack;

/// 首页—文字搜索.
+ (void)requestHomeSearchText:(NSString *)text withCallBack:(void(^)(NSArray *activList, NSArray *inviteList, NSNumber *activNumber, NSNumber *inviteNumber, NSError *error))callBack;
/// 首页—日历搜索.
+ (void)requestHomeCalendar:(NSArray *)dateArr priceArr:(NSArray *)priceArr themeArr:(NSArray *)themeArr searchText:(NSString *)text orderType:(NSInteger)orderType orderStr:(NSString *)orderStr withCallBack:(void(^)(NSArray *contentArr, NSString *orderStr, NSError *error))callBack;
/// 首页-更多活动
+ (void)requestMoreActiv:(NSArray *)dateArr priceArr:(NSArray *)priceArr themeArr:(NSArray *)themeArr searchText:(NSString *)text orderType:(NSInteger)orderType orderStr:(NSString *)orderStr withCallBack:(void(^)(NSArray *contentArr, NSString *orderStr, NSError *error))callBack;
/// 首页-更多邀约
+ (void)requestMoreInvites:(NSString *)orderStr themeId:(NSInteger)themeId sex:(NSInteger)sex orderType:(NSInteger)type withCallBack:(void(^)(NSArray *contentArr, NSString *orderStr, NSError *error))callBack ;

/// 首页本地.
+ (void)getHomepageLocals:(NSString *)localName withOrderStr:(NSString *)orderStr callBack:(void(^)(LCCityModel *cityObj, LCWeatherDay *weatherDay, NSArray *contentArr, NSString *orderStr, NSError *error))callBack;
/// 首页达客.
+ (void)getHomepageDuckrs:(NSString *)localName withOrderStr:(NSString *)orderStr callBack:(void(^)(NSArray *storyArr, NSArray *duckrBoardArr, LCHomeCategoryModel *onlineCategory, LCHomeCategoryModel *cityCategory, NSArray *contentArr, NSString *orderStr, NSError *error))callBack;
/// 首页推荐-精选活动.
+ (void)getHomeRecmSelectedCostPlans:(NSString *)orderStr callBack:(void(^)(NSArray *contentArr, NSString *orderStr, NSError *error))callBack;
/// 首页推荐-本地推荐.
+ (void)getHomeRecmLocalCostPlans:(NSString *)localName withOrderStr:(NSString *)orderStr callBack:(void(^)(NSArray *contentArr, NSString *orderStr, NSError *error))callBack;
/// 首页推荐-热门旅图.
+ (void)getHomeRecmHotTourpics:(NSString *)orderStr callBack:(void(^)(NSArray *contentArr, NSString *orderStr, NSError *error))callBack;
/// 首页推荐-在线达客.
+ (void)getHomeRecmOnlineDuckrs:(NSString *)orderStr callBack:(void(^)(NSArray *contentArr, NSString *orderStr, NSError *error))callBack;
/// 首页推荐-在线达客—正在发生.
+ (void)getHomeRecmOnlineHappens:(NSString *)orderStr callBack:(void(^)(NSArray *contentArr, NSString *orderStr, NSError *error))callBack;

/// 首页推荐-同城达客。
+ (void)getHomeRecmLocalDuckrs:(NSString *)orderStr callBack:(void(^)(NSArray *contentArr, NSString *orderStr, NSError *error))callBack;
/// 首页推荐-同城达客动态。
+ (void)getHomeRecmLocalDuckrsPlan:(NSString *)orderStr localName:(NSString *)localName  callBack:(void(^)(NSArray *contentArr, NSString *orderStr, NSError *error))callBack;
/// 首页-达客榜.
+ (void)getHomepageDuckrBroadList:(NSString *)orderString callBack:(void(^)(NSArray *userList, NSString *orderStr, NSError *error))callBack;
@end
