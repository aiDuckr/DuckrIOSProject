//
//  YSUserManager.h
//  CityLink
//
//  Created by zzs on 14-7-19.
//  Copyright (c) 2014年 yunshuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCStringUtil.h"
#import "LCUserModel.h"
#import "LCUserLocation.h"
#import "LCInitData.h"
#import "LCPlanModel.h"
#import "LCRedDotModel.h"
#import "LCBaseDataManager.h"
#import "LCOrderRuleModel.h"
#import "LCDestinationPlaceModel.h"
#import "LCWeatherDay.h"
#import "LCHomeCategoryModel.h"
#import "LCCityModel.h"
#import "LCUserAccount.h"
#import "LCHomeRcmd.h"

typedef NS_ENUM(NSUInteger, planTabJumpSourceType)
{
    planTabJumpSourceTypeNone,
    planTabJumpSourceTypeRecommend,
    planTabJumpSourceTypeSendPlan,
    planTabJumpSourceTypeFavor,
};
@interface LCDataManager : LCBaseDataManager

#pragma mark 一次安装相关
//进行过某些操作的标记
@property (nonatomic, assign) NSInteger isFirstTimeOpenApp; //是否第一次打开App    用于显示SplashView
@property (nonatomic, assign) BOOL isFirstInUseLogin;
@property (nonatomic, assign) NSInteger shouldUMengActive; //是否启动友盟统计

#pragma mark 一次使用相关
@property (nonatomic, strong) NSString *homePageProvince;
@property (nonatomic, strong) NSString *homePageCity;
@property (nonatomic, assign) planTabJumpSourceType jumpSourceType;
#pragma mark 设备相关
// App 初始化
@property (nonatomic, strong) NSString *remoteNotificationToken;    ///用于远程推送消息的deviceToken, 存本地
@property (nonatomic, strong) NSString *clientID;   //用于个推的客户端ID 
@property (nonatomic, strong) NSString *deviceUUID; //设备唯一标志  在这里不负责保存，而是在app初始化时，通过keychain存取

#pragma mark 应用相关
@property (nonatomic, strong) LCOrderRuleModel *orderRule;  

#pragma mark 用户相关
///多处用
@property (nonatomic, strong) NSArray *favorUserArr;    /// 关注的用户列表，存本地.
@property (nonatomic, strong) NSMutableArray *joinedPlanArr;    //用户参加的邀约列表，缓存本地.
@property (nonatomic, strong) NSMutableArray *favoredPlanArr;  // array of LCPlanModel
@property (nonatomic, strong) NSMutableArray *joinedChatGroupArr;   //用户参加的聊天室的列表，缓存本地.
@property (nonatomic, strong) LCUserLocation *userLocation; //用户当前位置信息，存本地  //TODO: 失效机制

@property (nonatomic, strong) LCInitData *appInitData; //App 初始化信息，存本地
@property (nonatomic, retain) NSArray *historySearchArray;    // 首页搜索历史.
@property (nonatomic, retain) NSArray *searchCostPlanResultArr; //首页文字搜索付费结果
@property (nonatomic, retain) NSArray *searchFreePlanResultArr; //首页文字搜索免费邀约结果
@property (nonatomic, strong) NSArray *homeSearchMoreActiv;//首页文字搜索更多付费结果
@property (nonatomic, strong) NSArray *homeSearchMoreInvite;//首页文字搜索更多免费邀约结果
@property (nonatomic, strong) LCRedDotModel *redDot;    //红点数量信息，存本地

@property (nonatomic, strong) LCUserModel *userInfo;       //当前用户信息~未登录时为nil
@property (nonatomic, strong) LCUserAccount *merchantAccount;
@property (nonatomic, strong) LCPlanModel *sendingPlan; //发新邀约，正在编辑的计划，草稿
@property (nonatomic, strong) LCPlanModel *modifyingPlan;   //正在修改的邀约(已经发布的，进行修改)

@property (nonatomic, retain) NSDate *lastUploadConatactDate;   //上次上传通讯录的时间,存本地

@property (nonatomic, strong) LCCityModel *currentCity;                 //!> 在首页选取的地点，可以是根据定位后台生成的，也可能是用户手动选的.
@property (nonatomic, strong) LCCityModel *locationCity;                //!> 根据定位得到的地点.
@property (assign, nonatomic) BOOL isAlertLocationCity;                    //!> 是否提示过当前定位地点.

@property (strong, nonatomic) LCHomeRcmd *suggHomeRcmd;
@property (strong, nonatomic) NSArray *rcmdTopArr;                   //!> 首页推荐上面Banner的数据表.
@property (strong, nonatomic) NSArray *rcmdContentArr;                  //!> 首页推荐.
@property (strong, nonatomic) NSArray *inviteContentArr;                  //!> 首页邀约.

@property (strong, nonatomic) NSArray *localTradeTopArr;
@property (strong, nonatomic) NSArray *localTradeContentArr;
@property (strong, nonatomic) NSArray *localInviteContentArr;
@property (strong, nonatomic) NSArray *localSearchActiv;
@property (strong, nonatomic) NSArray *homeSelectedCostPlansArr;        //!> 首页推荐精品活动数据表.
@property (strong, nonatomic) NSArray *homeRecmedCostPlansArr;          //!> 首页推荐本地推荐数据表.
@property (strong, nonatomic) NSArray *homeRecmTourpicArr;              //!> 首页推荐热门旅图数据表.
@property (strong, nonatomic) NSArray *homeRecmOnlineDuckrArr;          //!> 首页推荐在线达客数据表.
@property (strong, nonatomic) NSArray *homeRecmOnlineHappenArr;         //!> 首页推荐在线达客正在发生数据表.
@property (strong, nonatomic) LCWeatherDay *localWeatherDay;            //!> 首页本地顶部地点数据.
@property (strong, nonatomic) NSArray *localContentArr;                 //!> 首页本地旅图、邀约混排数据表.
@property (strong, nonatomic) NSArray *provinceArr;              //!> 首页本地省份数据表.
@property (strong, nonatomic) NSArray *hotCityArr;              //!> 首页本地热门城市数据表.
@property (strong, nonatomic) NSArray *planContentArr;                  //!> 首页邀约数据表.
@property (strong, nonatomic) NSArray *duckrStoryArr;                   //!> 首页达客达客故事滚动视图数据表.
@property (strong, nonatomic) NSArray *duckrBoardArr;                   //!> 首页达客达客榜数据表.
@property (strong, nonatomic) NSArray *duckrBoardListArr;
@property (strong, nonatomic) LCHomeCategoryModel *duckrOnlineCategory; //!> 首页达客在线达客数据.
@property (strong, nonatomic) LCHomeCategoryModel *duckrCityCategory;   //!> 首页达客同城达客数据.
@property (strong, nonatomic) NSArray *duckrContentArr;                 //!> 首页达客人气达客数据表.


//@property (nonatomic, strong) NSArray *homeCellArray;
//@property (nonatomic, strong) NSMutableArray *arrayOfHomeCellArray; //array of HomeCellModel Array
//@property (nonatomic, strong) NSMutableArray *homeUpdateTimeArray;  //array of NSDate

//附近页，用户之前选择的筛选项，存本地
@property (nonatomic, assign) LCUserFilterType nearbyTouristFilterType;
@property (nonatomic, assign) LCUserFilterType nearbyNativeFilterType;
@property (nonatomic, assign) LCPlanOrderType nearbyPlanOrderType;

//本地
@property (nonatomic, strong) NSArray *nearbyTourpicArray;
@property (nonatomic, strong) NSArray *nearbyPlanArray;

//旅图
@property (nonatomic, retain) NSArray *popularTourpicArray;
@property (nonatomic, retain) NSArray *focusTourpicArr;
@property (nonatomic, retain) NSArray *squareTourpicStreamArr;
@property (nonatomic, strong) NSArray *latestTourpicPlaceNameArr;    //最近使用过的地点名； array of NSString

//同城有空列表
//@property(nonatomic,strong)NSArray*freeTimeArr;
@property(nonatomic,strong)NSDate*localSelectedTime;//选择主题时间


@property (nonatomic, strong) NSArray *contactUserList;
///聊天
@property (nonatomic, strong) NSMutableDictionary *chatContactDic;  // key: jidStr,    value: LCChatContactModel
@property (nonatomic, strong) NSMutableDictionary *unreadNumDic;    // key: jidStr,    value: NSNumber

// 手机通讯录
@property (nonatomic, strong) NSArray *phoneContactList;

///个人Tab
@property (nonatomic, assign) NSInteger haveSetInviteUserTelephone; //是否已经提交过邀请人手机号

///支付
@property (nonatomic, strong) NSString *userRealName;
@property (nonatomic, strong) NSString *userRealId;
@property (nonatomic, strong) NSString *userRealTelephone;

#pragma mark 其它
//职业信息， 写死在本地
@property (nonatomic, strong) NSArray *professionNameArray; // array of string,   for profession's name
@property (nonatomic, strong) NSDictionary *professionDic;  // key: professionName, value: iconImageName    !是写死的
@property (nonatomic, retain) NSArray *albumTourpicArr;

//For debug:
@property (nonatomic, assign) BOOL useReleaseServerForDebug;

@property (nonatomic, retain) NSArray *orderPlanArray;

//日历筛选保存当前储存的日期
@property (nonatomic, retain) NSArray *currentSelectedArray;


+ (instancetype)sharedInstance;
- (void)saveData;
- (void)readData;
- (void)doBackCompatible;
//清理只在一次使用中有效的数据
- (void)clearOneActivityValidData;


#pragma Chat
- (void)addUnreadNumForBareJidStr:(NSString *)bareJidStr;
- (void)clearUnreadNumForBareJidStr:(NSString *)bareJidStr;
- (void)clearUnreadNumForAll;
- (NSInteger)getUnreadNumForBareJidStr:(NSString *)bareJidStr;
- (NSInteger)getUnreadNumSum;


#pragma mark Logout
- (void)clearUserDefaultForLogout;

#pragma CheckLogin
- (BOOL)haveLogin;

#pragma Tourpic
- (void)addLatestTourpicPlaceName:(NSString *)placeName;

@end







