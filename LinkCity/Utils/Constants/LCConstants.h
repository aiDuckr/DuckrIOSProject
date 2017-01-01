//
//  LCConstants.h
//  LinkCity
//
//  Created by roy on 2/6/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCStoryboardConstants.h"
#import "LCUIConstants.h"
#import "LCNetRequesterConstants.h"


#define XMPP_SERVER_PORT 5222

//网址

extern NSString *const DEBUG_SERVER_HOST;
extern NSString *const DEBUG_SERVER_URL_PREFIX;
extern NSString *const DEBUG_S_SERVER_URL_PREFIX;
extern NSString *const DEBUG_XMPP_SERVER_NAME;
extern NSString *const DEBUG_XMPP_SERVER_IP;

extern NSString *const RELEASE_SERVER_HOST;
extern NSString *const RELEASE_SERVER_URL_PREFIX;
extern NSString *const RELEASE_S_SERVER_URL_PREFIX;
extern NSString *const RELEASE_XMPP_SERVER_NAME;
extern NSString *const RELEASE_XMPP_SERVER_IP;


typedef enum : NSUInteger {
    LCUserFilterType_All = 0,
    LCUserFilterType_Male = 1,
    LCUserFilterType_Female = 2,
    LCUserFilterType_Identified = 3,
} LCUserFilterType;

typedef enum : NSUInteger {
    LCPlanOrderType_Default = 0,
    LCPlanOrderType_Distance = 1,
    LCPlanOrderType_CreateTime = 2,
    LCPlanOrderType_DepartTime = 3,
} LCPlanOrderType;

typedef enum : NSUInteger {
    LCLocalSelectedType_DepartTime = 0,
    LCLocalSelectedType_Distance = 1,
} LCLocalSelectedType;

typedef enum : NSUInteger {
    LCIdentityStatus_None = 0,
    LCIdentityStatus_Done = 1,
    LCIdentityStatus_Failed = 2,
    LCIdentityStatus_Verifying = 3,
} LCIdentityStatus;

typedef enum : NSUInteger {
    UserSex_Default = 0,
    UserSex_Male = 1,
    UserSex_Female = 2,
} UserSex;

typedef enum : NSUInteger {
    LCChatContactType_Default = 0,
    LCChatContactType_User = 1,
    LCChatContactType_Plan = 2,
    LCChatContactType_Group = 3,    //聊天室
} LCChatContactType;

//用于密测中的人物关系
typedef enum : NSUInteger {
    LCUserRelation_AddressBookFriend = 1,
    LCUserRelation_TravelFriend = 2,
} LCUserRelation;

//任何LCUserModel中的人物关系
typedef enum : NSUInteger {
    LCUserModelRelation_None = 0,
    LCUserModelRelation_Favored = 1,
    LCUserModelRelation_Invited = 2,
    LCUserModelRelation_AddreeBookFriend = 3,
    LCUserModelRelation_TravelExpert = 4,
    LCUserModelRelation_TwoDimensionFriend = 5,
    LCUserModelRelation_EachFavored = 6,
    LCUserModelRelation_BeFavored = 7,
} LCUserModelRelation;

/// 推送类型，跳转
typedef enum {
    PUSH_TYPE_COMMENT_PLAN = 1,                         //!> 评论邀约计划.
    PUSH_TYPE_REPLY_COMMENT = 2,                        //!> 回复了邀约评论.
    PUSH_TYPE_CHAT = 5,                                 //!> 聊天消息.
    PUSH_TYPE_FAVOR_ME = 6,                             //!> 关注.
    PUSH_TYPE_COMMENT_TOURPIC = 7,                      //!> 旅图评论.
    PUSH_TYPE_IDENTITY = 13,                            //!> 实名认证通知.
    PUSH_TYPE_TOURGUIDE_IDENTITY = 14,                  //!> 领队认证通知.
    PUSH_TYPE_PRISE_TOURPIC_V3 = 15,                    //!> 旅图点赞.
    PUSH_TYPE_PLAN_DETAIL = 18,                         //!> 跳转到邀约详情.
    PUSH_TYPE_TOURPIC_DETAIL = 19,                      //!> 跳转到旅图详情.
    PUSH_TYPE_NEED_TO_EVALUATE_PLAN = 21,               //!> 评价推送商家邀约跳转.
    PUSH_TYPE_WEBPAGE = 23,                             //!> 推送跳转网页.
    PUSH_TYPE_THEME_LIST = 25,                          //!> 推送跳转到主题列表.
    PUSH_TYPE_SYSTEM_INFO = 100,                        //!> 系统消息.
} PushType;

typedef enum : NSUInteger {
    LCRefundStatus_CanNot = 0,
    LCRefundStatus_Can = 1,
} LCRefundStatusType;

typedef enum : NSInteger {
    LCNewOrHotType_Default = 0,
    LCNewOrHotType_New = 1,
    LCNewOrHotType_Hot = 10,
} LCNewOrHotType;

// 四种状态，-1正常邀约或未有人付款的邀约，0，未入账，1已入账，2已结算
#define LCPlanOrderStatus_None (-1)
#define LCPlanOrderStatus_OutBill (0)
#define LCPlanOrderStatus_InBill (1)
#define LCPlanOrderStatus_Checked (2)



#pragma mark - For Test
extern NSString *const TestUserUUID;
extern NSString *const TestUserCID;

#pragma mark - App 常数
extern NSString *const BaiduMapAppID;
extern const NSInteger MaxPlanScaleOfMerchant;
extern const NSInteger MaxPlanScaleOfUsualUser;
extern const NSInteger AutoRefreshRedDotTimeInterval;
extern const NSInteger MinRefreshRedDotTimeIntervalWhenGexinNotify;
extern const NSInteger MaxThemeNumWhenSendPlan;
extern NSString *const DuckrWebSite;
extern const NSInteger MaxNickLength;
extern const NSInteger MinNickLength;
extern NSString *const NickLengthErrMsg;
extern const NSInteger MaxTagNumWhenEvaluateUser;
extern const NSInteger UserLocationValidTimeInterval;
extern NSString *const UserAgentKey;

extern const NSInteger UrbanThemeId;
extern const NSInteger TourOutdoorThemeId;
extern const NSInteger CostCarryThemeId;
extern const NSInteger FreeCarryThemeId;
extern const NSInteger NoneHideThemeId;

extern const NSInteger SearchHistoryMaxNum;

#pragma mark - URL
extern NSString *const LCUserUseAgreementURL;       //用户使用协议
extern NSString *const LCUserIdentityAgreementURL;  //实名认证协议
extern NSString *const LCGuideIdentityAgreementURL; //领队认证协议
extern NSString *const LCCarIdentityAgreementURL;   //包车认证协议
extern NSString *const LCPointIntroURL;             //积分说明网页
extern NSString *const LCAppRecommendURL;           //应用推荐网页
extern NSString *const LCEarnestIntroURL;
extern NSString *const LCOrderAgreementURL;         //预定说明协议
extern NSString *const LCCostCarryAgreementURL;     //发收费拼车邀约时的协议
extern NSString *const LCCostCarryRefundAgreementURL;    //AA拼车退款协议
extern NSString *const LCUserMarginAgreementURL;    //用户保证金协议
extern NSString *const LCAccountRulesIntroURL;      //商家入账协议

#pragma mark - 通知
//V3
extern NSString *const NotificationUserJustLogin;
extern NSString *const NotificationUserJustLogout;
extern NSString *const NotificationUserJustResetPassword;
extern NSString *const NotificationJustUpdateLocation;
extern NSString *const NotificationJustFailUpdateLocation;
extern NSString *const NotificationJustRegisterGexinClientID;
extern NSString *const NotificationJustFailRegisterGexinClientID;

extern NSString *const NotificationUnreadNumDidChange;
extern NSString *const NotificationRedDotNumDidChange;

extern NSString *const NotificationAliPay;
extern NSString *const NotificationAliPayResultKey;

extern NSString *const NotificationWechatPay;
extern NSString *const NotificationWechatPayResultKey;

//V4
//for detailVC update model of maskterVC
extern NSString *const NotificationPlanModelUpdate;
extern NSString *const NotificationPlanModelKey;
extern NSString *const NotificationTourpicModelUpdate;
extern NSString *const NotificationTourpicModelKey;


#pragma mark Chat
///receive apple remote push notificaiton of XMPP chat message.
extern NSString *const NotificationReceiveChatMessageAPN;
extern NSString *const NotificationReceiveChatMessageAddContact;
extern NSString *const NotificationReceiveXMPPConnected;

extern NSString *const NotificationDidReceiveXMPPMessage;
extern NSString *const NotificationDidReceiveXMPPChatMessage;
extern NSString *const NotificationDidReceiveXMPPGroupMessage;
extern NSString *const XMPPMessageKey;
extern NSString *const BareJidStringKey;
extern NSString *const XMPPPrivacyListName;

extern NSString *const NotificationJustDeleteChat;  //刚删除了某一个聊天会话  聊天列表页刷新

#pragma mark 3D Touch
extern NSString *const UITouchSendPlan;
extern NSString *const UITouchSendTourpic;
extern NSString *const UITouchBestTourpic;

#pragma mark Deeplink
extern NSString *const DeepLinkHostForPlanDetail;
extern NSString *const DeepLinkParamPlanGuid;
extern NSString *const DeepLinkParamRecmdUuid;

extern NSString *const DeepLinkHostForTourPic;
extern NSString *const DeepLinkParamTourpicId;

extern NSString *const DeepLinkHostForThemePlanList;
extern NSString *const DeepLinkParamThemeTitle;
extern NSString *const DeepLinkParamThemeId;

extern NSString *const DeepLinkHostForPlacePlanList;
extern NSString *const DeepLinkParamPlaceName;

extern NSString *const DeepLinkHostForUser;
extern NSString *const DeepLinkParamUserGuid;
extern NSString *const DeepLinkParamUserIsCarIdentity;
extern NSString *const DeepLinkParamUserIsTourGuideIdentity;

extern NSString *const DeepLinkHostForWeb;
extern NSString *const DeepLinkParamWebUrl;

extern NSString *const DeepLinkHostForUserInfoTab;
extern NSString *const DeepLinkParamUserInfoTabType;

#pragma mark --
extern NSString *const LCRightAlignSpace;


#pragma mark - MobClick 事件统计
extern NSString *const V5_HOMEPAGE_RECM_REQUEST; //首页推荐刷新请求数
extern NSString *const V5_HOMEPAGE_SEARCH_CLICK; //首页搜索点击
extern NSString *const V5_HOMEPAGE_SEARCH_REQUEST; //首页搜索搜索页面请求
extern NSString *const V5_HOMEPAGE_LOCAL_CLICK; //首页上方Tab本地点击
extern NSString *const V5_HOMEPAGE_PLAN_CLICK; //首页上方Tab邀约点击
extern NSString *const V5_HOMEPAGE_DUCKR_CLICK; //首页上方Tab达客点击
extern NSString *const V5_HOMEPAGE_BANNER_CLICK; //首页上方banner点击
extern NSString *const V5_HOMEPAGE_RECM_SELCECTED_CLICK; //首页推荐精选活动点击
extern NSString *const V5_HOMEPAGE_RECM_LOCAL_CLICK; //首页推荐本地玩乐点击
extern NSString *const V5_HOMEPAGE_RECM_TOURPIC_CLICK; //首页推荐热门旅图点击
extern NSString *const V5_HOMEPAGE_RECM_DUCKR_CLICK; //首页推荐在线达客点击
extern NSString *const V5_HOMEPAGE_TAB_CLICK; //底部Tab首页点击
extern NSString *const V5_TOURPIC_TAB_CLICK; //底部Tab旅图点击
extern NSString *const V5_ADD_TAB_CLICK; //底部Tab加号点击
extern NSString *const V5_MSG_TAB_CLICK; //底部Tab消息点击
extern NSString *const V5_MYSELF_TAB_CLICK; //底部Tab我点击
extern NSString *const V5_ADD_PLAN_CLICK; //加号发布邀约点击
extern NSString *const V5_LOCAL_TAB_CLICK; //本地点击
extern NSString *const V5_ADD_TOURPIC_CLICK; //加号发布旅图点击
extern NSString *const V5_ADD_VIDEO_CLICK; //加号发布视频点击
extern NSString *const V5_HOMEPAGE_RECM_MORE_REQUEST; //首页推荐加载更多请求
extern NSString *const V5_HOMEPAGE_LOCAL_MORE_REQUEST; //首页本地加载更多请求
extern NSString *const V5_HOMEPAGE_PLAN_MORE_REQUEST; //首页邀约加载更多请求
extern NSString *const V5_HOMEPAGE_DUCKR_MORE_REQUEST; //首页达客加载更多请求
extern NSString *const V5_HOMEPAGE_RECM_SELECTED_MORE_REQUEST; //首页精选活动加载更多请求
extern NSString *const V5_HOMEPAGE_RECM_LOCAL_MORE_REQUEST; //首页本地玩乐加载更多请求
extern NSString *const V5_HOMEPAGE_LOCAL_NEARBY_CLICK; //首页本地附近约人点击
extern NSString *const V5_HOMEPAGE_LOCAL_CALENDAR_CLICK; //首页本地活动日历点击
extern NSString *const V5_HOMEPAGE_LOCAL_TOURPIC_CLICK; //首页本地本地旅图点击
extern NSString *const V5_HOMEPAGE_LOCAL_DUCKR_CLICK; //首页本地同城达客点击
extern NSString *const V5_TOURPIC_DETAIL_PLAN_CLICK; //旅图详情来源点击
extern NSString *const V5_HOMEPAGE_RECM_DUCKR_HAPPENING_CLICK; //首页在线达客-正在发生点击
extern NSString *const V5_HOMEPAGE_LOCAL_DUCKR_HAPPENING_CLICK; //首页本地同城达客-正在发生点击

extern NSString *const Mob_Home_SwitchPlace; //首页切换地点
extern NSString *const Mob_Home_Search; //首页搜索
extern NSString *const Mob_Home_SeeMore; //首页查看更多
extern NSString *const Mob_Home_SeeBanner; //首页看Banner
extern NSString *const Mob_PlanList_Filt; //邀约列表点筛选
extern NSString *const Mob_PlanList_Image; //邀约列表看大图
extern NSString *const Mob_PlanDetail_Place; //邀约详情点地点
extern NSString *const Mob_PlanDetail_Favor; //邀约详情收藏
extern NSString *const Mob_PlanDetail_UnFavor; //邀约详情取消收藏
extern NSString *const Mob_PlanDetail_Share; //邀约详情分享
extern NSString *const Mob_PlanDetail_SeeMember; //邀约详情查看全部成员
extern NSString *const Mob_PlanDetail_Theme; //邀约详情点主题
extern NSString *const Mob_PlanDetail_Comment; //邀约详情评论
extern NSString *const Mob_PlanDetail_Join; //邀约详情加入
extern NSString *const Mob_PlanDetail_Quit; //邀约详情退出
extern NSString *const Mob_PlanDetail_Call; //邀约详情电话联系
extern NSString *const Mob_PlanDetail_SeeMoreComment; //邀约详情查看全部评论
extern NSString *const Mob_PlanDetail_Image; //邀约详情看大图
extern NSString *const Mob_Payment_Begin; //支付页面出现
extern NSString *const Mob_Payment_Cancel; //支付页面取消
extern NSString *const Mob_Payment_Confirm; //支付页面点确认付款
extern NSString *const Mob_Payment_Former; //支付页面点上一步
extern NSString *const Mob_Payment_Succeed; //支付成功
extern NSString *const Mob_Payment_Failed; //支付失败
extern NSString *const Mob_TourPicTab_Search; //旅图Tab搜索
extern NSString *const Mob_TourPicList_Prise; //旅图列表点赞
extern NSString *const Mob_TourPicList_Comment; //旅图列表评论
extern NSString *const Mob_TourPicList_Share; //旅图列表分享
extern NSString *const Mob_TourPicList_Place; //旅图列表点地点
extern NSString *const Mob_TourPicDetail_Place; //旅图详情点地点
extern NSString *const Mob_TourPicDetail_Prise; //旅图详情点赞
extern NSString *const Mob_TourPicDetail_Comment; //旅图详情评论
extern NSString *const Mob_TourPicDetail_Share; //旅图详情分享
extern NSString *const Mob_TourPicDetail_SeeMember; //旅图详情看全部点赞成员
extern NSString *const Mob_TourPicDetail_Image; //旅图详情看大图
extern NSString *const Mob_ChatTab_AddFriend; //聊天Tab添加朋友
extern NSString *const Mob_Chat_ChooseCamera; //聊天选拍照
extern NSString *const Mob_Chat_ChooseLocation; //聊天选地点
extern NSString *const Mob_Chat_ChoosePic; //聊天选相册
extern NSString *const Mob_UserTab_Set; //用户Tab设置
extern NSString *const Mob_UserTab_NotifyList; //用户Tab通知列表
extern NSString *const Mob_UserTab_MyPlanList; //用户Tab我的邀约
extern NSString *const Mob_UserTab_MyTourPicList; //用户Tab我的旅图
extern NSString *const Mob_UserTab_Identity; //用户Tab实名认证
extern NSString *const Mob_UserTab_MyService; //用户Tab我的服务
extern NSString *const Mob_UserTab_PlanHelper; //用户Tab邀约助手
extern NSString *const Mob_UserTab_FollowedList; //用户Tab关注列表
extern NSString *const Mob_UserTab_FollowerList; //用户Tab粉丝列表
extern NSString *const Mob_UserTab_MyInfo; //用户Tab我的信息
extern NSString *const Mob_UserInfo_Avatar; //个人主页看头像
extern NSString *const Mob_UserInfo_FollowedList; //个人主页关注列表
extern NSString *const Mob_UserInfo_FollowerList; //个人主页粉丝列表
extern NSString *const Mob_UserInfo_SeeMorePlan; //个人主页看更多邀约
extern NSString *const Mob_UserInfo_Evaluat; //个人主页评价
extern NSString *const Mob_UserInfo_Follow; //个人主页关注
extern NSString *const Mob_UserInfo_Chat; //个人主页聊天
extern NSString *const Mob_UserInfo_Block; //个人主页屏蔽
extern NSString *const Mob_PublishPlan; //发邀约
extern NSString *const Mob_PublishPlanA_Cancel; //发邀约第一页取消
extern NSString *const Mob_PublishPlanA_Time; //发邀约第一页选时间
extern NSString *const Mob_PublishPlanA_Next; //发邀约第一页下一步
extern NSString *const Mob_PublishPlanB_Cancel; //发邀约第二页取消
extern NSString *const Mob_PublishPlanB_AddImage; //发邀约第二页添加图片
extern NSString *const Mob_PublishPlanB_AddRoute; //发邀约第二页点路线
extern NSString *const Mob_PublishPlanB_Publish; //发邀约第二页发布
extern NSString *const Mob_PublishTourPic; //发旅图
extern NSString *const Mob_PublishTourPic_AddImage; //发旅图添加图片
extern NSString *const Mob_PublishTourPic_Where; //发旅图在哪
extern NSString *const Mob_PublishTourPic_Who; //发旅图和谁
extern NSString *const Mob_PublishTourPic_Publish; //发旅图发布
extern NSString *const Mob_PublishTourPic_Cancel; //发旅图取消
extern NSString *const Mob_Splash_Regist; //启动页注册
extern NSString *const Mob_Splash_Jump; //启动页跳过
extern NSString *const Mob_RegistBegin_Next; //注册第一页下一步
extern NSString *const Mob_RegistBegin_Cancel; //注册第一页取消
extern NSString *const Mob_RegistAccount_Next; //注册账号页下一步
extern NSString *const Mob_RegistAccount_Cancel; //注册账号页取消
extern NSString *const Mob_RegistVerifyCode_Cancel; //注册验证码页取消
extern NSString *const Mob_RegistVerifyCode_Resend; //注册验证码页重发
extern NSString *const Mob_RegistVerifyCode_Verify; //注册验证码页验证
extern NSString *const Mob_RegistVerifyCodeError_ReVerify; //注册验证码错误页重新验证
extern NSString *const Mob_RegistWelcome_Next; //注册成功下一步
extern NSString *const Mob_RegistWelcome_Cancel; //注册成功叉号
extern NSString *const Mob_RegistInfo_Done; //注册用户信息页完成
extern NSString *const Mob_RegistInfo_Cancel; //注册用户信息页取消
extern NSString *const Mob_RegistFinish_Done; //注册完成页完成


@interface LCConstants : NSObject
+ (NSString *)serverHost;
+ (NSString *)serverUrlPrefix;
+ (NSString *)httpsServerUrlPrefix;
+ (NSString *)xmppServerName;
+ (NSString *)xmppServerIp;
@end