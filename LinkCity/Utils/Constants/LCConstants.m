//
//  LCConstants.m
//  LinkCity
//
//  Created by roy on 2/6/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCConstants.h"

NSString *const DEBUG_SERVER_HOST = @"http://182.92.230.117/zzsduckr/";
NSString *const DEBUG_SERVER_URL_PREFIX = @"http://182.92.230.117/zzsduckr/api/";
NSString *const DEBUG_S_SERVER_URL_PREFIX = @"http://182.92.230.117/zzsduckr/api/";
NSString *const DEBUG_XMPP_SERVER_NAME = @"182.92.230.117";
NSString *const DEBUG_XMPP_SERVER_IP = @"182.92.230.117";

//NSString *const DEBUG_SERVER_HOST = @"http://www.duckr.cn/";
//NSString *const DEBUG_SERVER_URL_PREFIX = @"http://www.duckr.cn/api/";
//NSString *const DEBUG_S_SERVER_URL_PREFIX = @"https://www.duckr.cn/api/";
//NSString *const DEBUG_XMPP_SERVER_NAME = @"duckrchat";
//NSString *const DEBUG_XMPP_SERVER_IP = @"chat.duckr.cn";

//NSString *const RELEASE_SERVER_HOST = @"http://182.92.230.117/";
//NSString *const RELEASE_SERVER_URL_PREFIX = @"http://182.92.230.117/api/";
//NSString *const RELEASE_S_SERVER_URL_PREFIX = @"http://182.92.230.117/api/";
//NSString *const RELEASE_XMPP_SERVER_NAME = @"182.92.230.117";
//NSString *const RELEASE_XMPP_SERVER_IP = @"182.92.230.117";

NSString *const RELEASE_SERVER_HOST = @"http://www.duckr.cn/";
NSString *const RELEASE_SERVER_URL_PREFIX = @"http://www.duckr.cn/api/";
NSString *const RELEASE_S_SERVER_URL_PREFIX = @"https://www.duckr.cn/api/";
NSString *const RELEASE_XMPP_SERVER_NAME = @"127.0.0.1";
NSString *const RELEASE_XMPP_SERVER_IP = @"chat.duckr.cn";

#pragma mark - For Test
NSString *const TestUserUUID = @"23aee904e21f74b36aef669d46a07613";
NSString *const TestUserCID = @"4e551767655d62c57263987b64a7087a";

#pragma mark - App 常数
NSString *const BaiduMapAppID = @"ucTfmijOotOmjleGZt22xCHK";
const NSInteger MaxPlanScaleOfMerchant = 100;
const NSInteger MaxPlanScaleOfUsualUser = 20;
const NSInteger AutoRefreshRedDotTimeInterval = 30 * 10000;
const NSInteger MinRefreshRedDotTimeIntervalWhenGexinNotify = 5;
const NSInteger MaxThemeNumWhenSendPlan = 4;
NSString *const DuckrWebSite = @"http://www.duckr.cn";
const NSInteger MaxNickLength = 12;
const NSInteger MinNickLength = 2;
NSString *const NickLengthErrMsg = @"昵称必须是2~12个字";
const NSInteger MaxTagNumWhenEvaluateUser = 4;
const NSInteger UserLocationValidTimeInterval = 60*60*24;
NSString *const UserAgentKey = @"User-Agent";

const NSInteger UrbanThemeId = 30000;
const NSInteger TourOutdoorThemeId = 30004;
const NSInteger CostCarryThemeId = 100017;
const NSInteger FreeCarryThemeId = 100016;
const NSInteger NoneHideThemeId = -1;

const NSInteger SearchHistoryMaxNum = 100;

#pragma mark - URL

NSString *const LCUserUseAgreementURL = @"web/user/policy/";
NSString *const LCUserIdentityAgreementURL = @"web/user/policy/identity/";
NSString *const LCGuideIdentityAgreementURL = @"web/user/policy/car/";
NSString *const LCCarIdentityAgreementURL = @"web/user/policy/guide/";
NSString *const LCPointIntroURL = @"web/user/policy/credit/";
NSString *const LCAppRecommendURL = @"web/mobile/recommend/";
NSString *const LCEarnestIntroURL = @"web/order/earnest/policy/";
NSString *const LCOrderAgreementURL = @"web/order/reserve/policy/";
NSString *const LCCostCarryAgreementURL = @"web/order/cost/policy/";
NSString *const LCCostCarryRefundAgreementURL = @"web/order/aacar/refund/policy/";
NSString *const LCUserMarginAgreementURL = @"web/order/margin/policy/";
NSString *const LCAccountRulesIntroURL = @"web/account/entry/policy/";


NSString *const NotificationShouldRefreshPlanListFromServer = @"NotificationShouldRefreshPlanListFromServer";
NSString *const NotificationReceiveChatMessageAddContact = @"NotificationReceiveChatMessageAddContact";
NSString *const NotificationReceiveChatMessageAPN = @"NotificationReceiveChatMessage";
NSString *const NotificationReceiveXMPPConnected = @"NotificationReceiveXMPPConnected";

//V3
NSString *const NotificationUserJustLogin = @"NotificationUserJustLogin";
NSString *const NotificationUserJustLogout = @"NotificationUserJustLogout";
NSString *const NotificationUserJustResetPassword = @"NotificationUserJustResetPassword";
NSString *const NotificationJustUpdateLocation = @"NotificationUserUpdateLocation";
NSString *const NotificationJustFailUpdateLocation = @"NotificationJustFailUpdateLocation";
NSString *const NotificationJustRegisterGexinClientID = @"NotificationJustRegisterGexinClientID";
NSString *const NotificationJustFailRegisterGexinClientID = @"NotificationJustFailRegisterGexinClientID";

NSString *const NotificationUnreadNumDidChange = @"NotificationUnreadNumDidChange";
NSString *const NotificationRedDotNumDidChange = @"NotificationRedDotNumDidChange";

NSString *const NotificationAliPay = @"NotificationAliPay";
NSString *const NotificationAliPayResultKey = @"NotificationAliPayResultKey";

NSString *const NotificationWechatPay = @"NotificationWechatPay";
NSString *const NotificationWechatPayResultKey = @"NotificationWechatPayResultKey";

//V4

NSString *const NotificationPlanModelUpdate = @"NotificationPlanModelUpdate";
NSString *const NotificationPlanModelKey = @"NotificationPlanModelKey";
NSString *const NotificationTourpicModelUpdate = @"NotificationTourpicModelUpdate";
NSString *const NotificationTourpicModelKey = @"NotificationTourpicModelKey";

#pragma mark Chat
NSString *const NotificationDidReceiveXMPPMessage = @"NotificationDidReceiveXMPPMessage";
NSString *const NotificationDidReceiveXMPPChatMessage = @"NotificationDidReceiveXMPPChatMessage";
NSString *const NotificationDidReceiveXMPPGroupMessage = @"NotificationDidReceiveXMPPGroupMessage";
NSString *const XMPPMessageKey = @"XMPPMessageKey";
NSString *const BareJidStringKey = @"BareJidStringKey";
NSString *const XMPPPrivacyListName = @"public";

NSString *const NotificationJustDeleteChat = @"NotificationJustDeleteChat";

#pragma mark 3D Touch
NSString *const UITouchSendPlan = @"UITouchSendPlan";
NSString *const UITouchSendTourpic = @"UITouchSendTourpic";
NSString *const UITouchBestTourpic = @"UITouchBestTourpic";

#pragma mark Deeplink
NSString *const DeepLinkHostForPlanDetail = @"plandetail";
NSString *const DeepLinkParamPlanGuid = @"planguid";
NSString *const DeepLinkParamRecmdUuid = @"recmduuid";

NSString *const DeepLinkHostForTourPic = @"tourpicdetail";
NSString *const DeepLinkParamTourpicId = @"tourpicguid";

NSString *const DeepLinkHostForThemePlanList = @"themeplanlist";
NSString *const DeepLinkParamThemeTitle = @"themetitle";
NSString *const DeepLinkParamThemeId = @"themeid";

NSString *const DeepLinkHostForPlacePlanList = @"placeplanlist";
NSString *const DeepLinkParamPlaceName = @"placename";

NSString *const DeepLinkHostForUser = @"userdetail";
NSString *const DeepLinkParamUserGuid = @"userguid";
NSString *const DeepLinkParamUserIsCarIdentity = @"iscar";
NSString *const DeepLinkParamUserIsTourGuideIdentity = @"istourguide";

NSString *const DeepLinkHostForWeb = @"webpage";
NSString *const DeepLinkParamWebUrl = @"url";

NSString *const DeepLinkHostForUserInfoTab = @"myuserinfo";
NSString *const DeepLinkParamUserInfoTabType = @"type";


#pragma mark --
NSString *const LCRightAlignSpace = @"\u00a0";

#pragma mark - MobClick 事件统计
NSString *const V5_HOMEPAGE_RECM_REQUEST = @"V5_HOMEPAGE_RECM_REQUEST";
NSString *const V5_HOMEPAGE_SEARCH_CLICK = @"V5_HOMEPAGE_SEARCH_CLICK";
NSString *const V5_HOMEPAGE_SEARCH_REQUEST = @"V5_HOMEPAGE_SEARCH_REQUEST";
NSString *const V5_HOMEPAGE_LOCAL_CLICK = @"V5_HOMEPAGE_LOCAL_CLICK";
NSString *const V5_HOMEPAGE_PLAN_CLICK = @"V5_HOMEPAGE_PLAN_CLICK";
NSString *const V5_HOMEPAGE_DUCKR_CLICK = @"V5_HOMEPAGE_DUCKR_CLICK";
NSString *const V5_HOMEPAGE_BANNER_CLICK = @"V5_HOMEPAGE_BANNER_CLICK";
NSString *const V5_HOMEPAGE_RECM_SELCECTED_CLICK = @"V5_HOMEPAGE_RECM_SELCECTED_CLICK";
NSString *const V5_HOMEPAGE_RECM_LOCAL_CLICK = @"V5_HOMEPAGE_RECM_LOCAL_CLICK";
NSString *const V5_HOMEPAGE_RECM_TOURPIC_CLICK = @"V5_HOMEPAGE_RECM_TOURPIC_CLICK";
NSString *const V5_HOMEPAGE_RECM_DUCKR_CLICK = @"V5_HOMEPAGE_RECM_DUCKR_CLICK";
NSString *const V5_HOMEPAGE_TAB_CLICK = @"V5_HOMEPAGE_TAB_CLICK";
NSString *const V5_TOURPIC_TAB_CLICK = @"V5_TOURPIC_TAB_CLICK";
NSString *const V5_ADD_TAB_CLICK = @"V5_ADD_TAB_CLICK";
NSString *const V5_LOCAL_TAB_CLICK = @"V5_LOCAL_TAB_CLICK";
NSString *const V5_MSG_TAB_CLICK = @"V5_MSG_TAB_CLICK";
NSString *const V5_MYSELF_TAB_CLICK = @"V5_MYSELF_TAB_CLICK";
NSString *const V5_ADD_PLAN_CLICK = @"V5_ADD_PLAN_CLICK";
NSString *const V5_ADD_TOURPIC_CLICK = @"V5_ADD_TOURPIC_CLICK";
NSString *const V5_ADD_VIDEO_CLICK = @"V5_ADD_VIDEO_CLICK";
NSString *const V5_HOMEPAGE_RECM_MORE_REQUEST = @"V5_HOMEPAGE_RECM_MORE_REQUEST";
NSString *const V5_HOMEPAGE_LOCAL_MORE_REQUEST = @"V5_HOMEPAGE_LOCAL_MORE_REQUEST";
NSString *const V5_HOMEPAGE_PLAN_MORE_REQUEST = @"V5_HOMEPAGE_PLAN_MORE_REQUEST";
NSString *const V5_HOMEPAGE_DUCKR_MORE_REQUEST = @"V5_HOMEPAGE_DUCKR_MORE_REQUEST";
NSString *const V5_HOMEPAGE_RECM_SELECTED_MORE_REQUEST = @"V5_HOMEPAGE_RECM_SELECTED_MORE_REQUEST";
NSString *const V5_HOMEPAGE_RECM_LOCAL_MORE_REQUEST = @"V5_HOMEPAGE_RECM_LOCAL_MORE_REQUEST";
NSString *const V5_HOMEPAGE_LOCAL_NEARBY_CLICK = @"V5_HOMEPAGE_LOCAL_NEARBY_CLICK";
NSString *const V5_HOMEPAGE_LOCAL_CALENDAR_CLICK = @"V5_HOMEPAGE_LOCAL_CALENDAR_CLICK";
NSString *const V5_HOMEPAGE_LOCAL_TOURPIC_CLICK = @"V5_HOMEPAGE_LOCAL_TOURPIC_CLICK";
NSString *const V5_HOMEPAGE_LOCAL_DUCKR_CLICK = @"V5_HOMEPAGE_LOCAL_DUCKR_CLICK";
NSString *const V5_TOURPIC_DETAIL_PLAN_CLICK = @"V5_TOURPIC_DETAIL_PLAN_CLICK";
NSString *const V5_HOMEPAGE_RECM_DUCKR_HAPPENING_CLICK = @"V5_HOMEPAGE_RECM_DUCKR_HAPPENING_CLICK";
NSString *const V5_HOMEPAGE_LOCAL_DUCKR_HAPPENING_CLICK = @"V5_HOMEPAGE_LOCAL_DUCKR_HAPPENING_CLICK";

NSString *const Mob_Home_SwitchPlace = @"Home_SwitchPlace"; //首页切换地点
NSString *const Mob_Home_Search = @"Home_Search"; //首页搜索
NSString *const Mob_Home_SeeMore = @"Home_SeeMore"; //首页查看更多
NSString *const Mob_Home_SeeBanner = @"Home_SeeBanner"; //首页看Banner
NSString *const Mob_PlanList_Filt = @"PlanList_Filt"; //邀约列表点筛选
NSString *const Mob_PlanList_Image = @"PlanList_Image"; //邀约列表看大图
NSString *const Mob_PlanDetail_Place = @"PlanDetail_Place"; //邀约详情点地点
NSString *const Mob_PlanDetail_Favor = @"PlanDetail_Favor"; //邀约详情收藏
NSString *const Mob_PlanDetail_UnFavor = @"PlanDetail_UnFavor"; //邀约详情取消收藏
NSString *const Mob_PlanDetail_Share = @"PlanDetail_Share"; //邀约详情分享
NSString *const Mob_PlanDetail_SeeMember = @"PlanDetail_SeeMember"; //邀约详情查看全部成员
NSString *const Mob_PlanDetail_Theme = @"PlanDetail_Theme"; //邀约详情点主题
NSString *const Mob_PlanDetail_Comment = @"PlanDetail_Comment"; //邀约详情评论
NSString *const Mob_PlanDetail_Join = @"PlanDetail_Join"; //邀约详情加入
NSString *const Mob_PlanDetail_Quit = @"PlanDetail_Quit"; //邀约详情退出
NSString *const Mob_PlanDetail_Call = @"PlanDetail_Call"; //邀约详情电话联系
NSString *const Mob_PlanDetail_SeeMoreComment = @"PlanDetail_SeeMoreComment"; //邀约详情查看全部评论
NSString *const Mob_PlanDetail_Image = @"PlanDetail_Image"; //邀约详情看大图
NSString *const Mob_Payment_Begin = @"Payment_Begin"; //支付页面出现
NSString *const Mob_Payment_Cancel = @"Payment_Cancel"; //支付页面取消
NSString *const Mob_Payment_Confirm = @"Payment_Confirm"; //支付页面点确认付款
NSString *const Mob_Payment_Former = @"Payment_Former"; //支付页面点上一步
NSString *const Mob_Payment_Succeed = @"Payment_Succeed"; //支付成功
NSString *const Mob_Payment_Failed = @"Payment_Failed"; //支付失败
NSString *const Mob_TourPicTab_Search = @"TourPicTab_Search"; //旅图Tab搜索
NSString *const Mob_TourPicList_Prise = @"TourPicList_Prise"; //旅图列表点赞
NSString *const Mob_TourPicList_Comment = @"TourPicList_Comment"; //旅图列表评论
NSString *const Mob_TourPicList_Share = @"TourPicList_Share"; //旅图列表分享
NSString *const Mob_TourPicList_Place = @"TourPicList_Place"; //旅图列表点地点
NSString *const Mob_TourPicDetail_Place = @"TourPicDetail_Place"; //旅图详情点地点
NSString *const Mob_TourPicDetail_Prise = @"TourPicDetail_Prise"; //旅图详情点赞
NSString *const Mob_TourPicDetail_Comment = @"TourPicDetail_Comment"; //旅图详情评论
NSString *const Mob_TourPicDetail_Share = @"TourPicDetail_Share"; //旅图详情分享
NSString *const Mob_TourPicDetail_SeeMember = @"TourPicDetail_SeeMember"; //旅图详情看全部点赞成员
NSString *const Mob_TourPicDetail_Image = @"TourPicDetail_Image"; //旅图详情看大图
NSString *const Mob_ChatTab_AddFriend = @"ChatTab_AddFriend"; //聊天Tab添加朋友
NSString *const Mob_Chat_ChooseCamera = @"Chat_ChooseCamera"; //聊天选拍照
NSString *const Mob_Chat_ChooseLocation = @"Chat_ChooseLocation"; //聊天选地点
NSString *const Mob_Chat_ChoosePic = @"Chat_ChoosePic"; //聊天选相册
NSString *const Mob_UserTab_Set = @"UserTab_Set"; //用户Tab设置
NSString *const Mob_UserTab_NotifyList = @"UserTab_NotifyList"; //用户Tab通知列表
NSString *const Mob_UserTab_MyPlanList = @"UserTab_MyPlanList"; //用户Tab我的邀约
NSString *const Mob_UserTab_MyTourPicList = @"UserTab_MyTourPicList"; //用户Tab我的旅图
NSString *const Mob_UserTab_Identity = @"UserTab_Identity"; //用户Tab实名认证
NSString *const Mob_UserTab_MyService = @"UserTab_MyService"; //用户Tab我的服务
NSString *const Mob_UserTab_PlanHelper = @"UserTab_PlanHelper"; //用户Tab邀约助手
NSString *const Mob_UserTab_FollowedList = @"UserTab_FollowedList"; //用户Tab关注列表
NSString *const Mob_UserTab_FollowerList = @"UserTab_FollowerList"; //用户Tab粉丝列表
NSString *const Mob_UserTab_MyInfo = @"UserTab_MyInfo"; //用户Tab我的信息
NSString *const Mob_UserInfo_Avatar = @"UserInfo_Avatar"; //个人主页看头像
NSString *const Mob_UserInfo_FollowedList = @"UserInfo_FollowedList"; //个人主页关注列表
NSString *const Mob_UserInfo_FollowerList = @"UserInfo_FollowerList"; //个人主页粉丝列表
NSString *const Mob_UserInfo_SeeMorePlan = @"UserInfo_SeeMorePlan"; //个人主页看更多邀约
NSString *const Mob_UserInfo_Evaluat = @"UserInfo_Evaluat"; //个人主页评价
NSString *const Mob_UserInfo_Follow = @"UserInfo_Follow"; //个人主页关注
NSString *const Mob_UserInfo_Chat = @"UserInfo_Chat"; //个人主页聊天
NSString *const Mob_UserInfo_Block = @"UserInfo_Block"; //个人主页屏蔽
NSString *const Mob_PublishPlan = @"PublishPlan"; //发邀约
NSString *const Mob_PublishPlanA_Cancel = @"PublishPlanA_Cancel"; //发邀约第一页取消
NSString *const Mob_PublishPlanA_Time = @"PublishPlanA_Time"; //发邀约第一页选时间
NSString *const Mob_PublishPlanA_Next = @"PublishPlanA_Next"; //发邀约第一页下一步
NSString *const Mob_PublishPlanB_Cancel = @"PublishPlanB_Cancel"; //发邀约第二页取消
NSString *const Mob_PublishPlanB_AddImage = @"PublishPlanB_AddImage"; //发邀约第二页添加图片
NSString *const Mob_PublishPlanB_AddRoute = @"PublishPlanB_AddRoute"; //发邀约第二页点路线
NSString *const Mob_PublishPlanB_Publish = @"PublishPlanB_Publish"; //发邀约第二页发布
NSString *const Mob_PublishTourPic = @"PublishTourPic"; //发旅图
NSString *const Mob_PublishTourPic_AddImage = @"PublishTourPic_AddImage"; //发旅图添加图片
NSString *const Mob_PublishTourPic_Where = @"PublishTourPic_Where"; //发旅图在哪
NSString *const Mob_PublishTourPic_Who = @"PublishTourPic_Who"; //发旅图和谁
NSString *const Mob_PublishTourPic_Publish = @"PublishTourPic_Publish"; //发旅图发布
NSString *const Mob_PublishTourPic_Cancel = @"PublishTourPic_Cancel"; //发旅图取消
NSString *const Mob_Splash_Regist = @"Splash_Regist"; //启动页注册
NSString *const Mob_Splash_Jump = @"Splash_Jump"; //启动页跳过
NSString *const Mob_RegistBegin_Next = @"RegistBegin_Next"; //注册第一页下一步
NSString *const Mob_RegistBegin_Cancel = @"RegistBegin_Cancel"; //注册第一页取消
NSString *const Mob_RegistAccount_Next = @"RegistAccount_Next"; //注册账号页下一步
NSString *const Mob_RegistAccount_Cancel = @"RegistAccount_Cancel"; //注册账号页取消
NSString *const Mob_RegistVerifyCode_Cancel = @"RegistVerifyCode_Cancel"; //注册验证码页取消
NSString *const Mob_RegistVerifyCode_Resend = @"RegistVerifyCode_Resend"; //注册验证码页重发
NSString *const Mob_RegistVerifyCode_Verify = @"RegistVerifyCode_Verify"; //注册验证码页验证
NSString *const Mob_RegistVerifyCodeError_ReVerify = @"RegistVerifyCodeError_ReVerify"; //注册验证码错误页重新验证
NSString *const Mob_RegistWelcome_Next = @"RegistWelcome_Next"; //注册成功下一步
NSString *const Mob_RegistWelcome_Cancel = @"RegistWelcome_Cancel"; //注册成功叉号
NSString *const Mob_RegistInfo_Done = @"RegistInfo_Done"; //注册用户信息页完成
NSString *const Mob_RegistInfo_Cancel = @"RegistInfo_Cancel"; //注册用户信息页取消
NSString *const Mob_RegistFinish_Done = @"RegistFinish_Done"; //注册完成页完成


@implementation LCConstants
+ (NSString *)serverHost {
#ifdef DEBUG
    return [LCDataManager sharedInstance].useReleaseServerForDebug ? RELEASE_SERVER_HOST : DEBUG_SERVER_HOST;
#else
    return RELEASE_SERVER_HOST;
#endif
}

+ (NSString *)serverUrlPrefix {
#ifdef DEBUG
    return [LCDataManager sharedInstance].useReleaseServerForDebug ? RELEASE_SERVER_URL_PREFIX : DEBUG_SERVER_URL_PREFIX;
#else
    return RELEASE_SERVER_URL_PREFIX;
#endif
}

+ (NSString *)httpsServerUrlPrefix {
#ifdef DEBUG
    return [LCDataManager sharedInstance].useReleaseServerForDebug ? RELEASE_S_SERVER_URL_PREFIX : DEBUG_S_SERVER_URL_PREFIX;
#else
    return RELEASE_S_SERVER_URL_PREFIX;
#endif
}

+ (NSString *)xmppServerName {
#ifdef DEBUG
    return [LCDataManager sharedInstance].useReleaseServerForDebug ? RELEASE_XMPP_SERVER_NAME : DEBUG_XMPP_SERVER_NAME;
#else
    return RELEASE_XMPP_SERVER_NAME;
#endif
}

+ (NSString *)xmppServerIp {
#ifdef DEBUG
    return [LCDataManager sharedInstance].useReleaseServerForDebug ? RELEASE_XMPP_SERVER_IP : DEBUG_XMPP_SERVER_IP;
#else
    return RELEASE_XMPP_SERVER_IP;
#endif
}
@end
