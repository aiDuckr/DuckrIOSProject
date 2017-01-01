//
//  LCNetRequesterConstants.h
//  LinkCity
//
//  Created by roy on 2/26/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark - Server Request URL
#pragma mark User
extern NSString *const URL_FAVOR_USER;
extern NSString *const URL_SEARCH_USER_BY_KEYWORD;
extern NSString *const URL_GET_USERINFO;
extern NSString *const URL_ADD_EVALUATION;
extern NSString *const URL_GET_EVALUATION;
extern NSString *const URL_GET_USER_SERVICE;
extern NSString *const URL_FOLLOW_USER;
extern NSString *const URL_UNFOLLOW_USER;
extern NSString *const URL_GET_NEARBY_TOURIST;
extern NSString *const URL_GET_NEARBY_NATIVE;
extern NSString *const URL_USER_IDENTITY;
extern NSString *const URL_GET_USER_IDENTITY_INFO;
extern NSString *const URL_CAR_IDENTITY;
extern NSString *const URL_GET_CAR_IDENTITY_INFO;
extern NSString *const URL_GUIDE_IDENTITY_APPROVE;
extern NSString *const URL_GUIDE_IDENTITY;
extern NSString *const URL_GET_GUIDE_IDENTITY_INFO;
extern NSString *const URL_GET_FANS_LIST;
extern NSString *const URL_GET_USERLIST_BY_PLACENAME;
extern NSString *const URL_GET_SCHOOL_LIST;
extern NSString *const URL_GET_USER_HOMEPAGE;
extern NSString *const URL_REPORT_USER;
extern NSString *const URL_USER_MARGIN_ORDER_NEW;
extern NSString *const URL_USER_MARGIN_ORDER_QUERY;
extern NSString *const URL_GET_FANS_LIST_V_FIVE;
extern NSString *const URL_GET_FAVORS_LIST_V_FIVE;
extern NSString *const URL_GET_FANS_DYNAMIC_V_FIVE;
extern NSString *const URL_GET_FAVORS_DYNAMIC_V_FIVE;
extern NSString *const URL_GET_FANS_SEARCH_RESULT_V_FIVE;
extern NSString *const URL_GET_USER_RED_DOT_V_FIVE;
extern NSString *const URL_GET_USER_ALL_ORDER_V_FIVE;
extern NSString *const URL_GET_USER_PENDING_PAYMENT_ORDER_V_FIVE;
extern NSString *const URL_GET_USER_TO_BE_EVALUATED_ORDER_V_FIVE;
extern NSString *const URL_GET_USER_REFUND_ORDER_V_FIVE;
extern NSString *const URL_DELETE_USER_ORDER_V_FIVE;
extern NSString *const URL_GET_USER_RECM_DUCKR_V_FIVE;
extern NSString *const URL_SET_USER_REMARK_NAME;
extern NSString *const URL_REPORT_USER_V_FIVE;
extern NSString *const URL_GET_NOTIFICATION;
extern NSString *const URL_GET_MERCHANT_SERVICE_LIST;
extern NSString *const URL_GET_MERCHANT_BILL_LIST;
extern NSString *const URL_GET_MERCHANT_REFUND_LIST;
extern NSString *const URL_GET_MERCHANT_REFUND_DETAIL;
extern NSString *const URL_GET_MERCHANT_SIGN_UP_DETAIL;
extern NSString *const URL_GET_MERCHANT_AGREE_REFUND;
extern NSString *const URL_GET_MERCHANT_ORDER_CHECK;
extern NSString *const URL_GET_MERCHANT_ADD_CARD;
extern NSString *const URL_GET_MERCHANT_WITHDRAW;
extern NSString *const URL_GET_MERCHANT_WITHDRAW_LIST;
extern NSString *const URL_GET_MERCHANT_BANK_LIST;


#pragma mark Register & Login
extern NSString *const URL_SEND_AUTHCODE;
extern NSString *const URL_VERIFY_AUTHCODE;
extern NSString *const URL_REGISTER_USER;
extern NSString *const URL_UPDATE_USER;
extern NSString *const URL_LOGIN;
extern NSString *const URL_RESET_PASSWORD;

#pragma mark Route
extern NSString *const URL_SEND_ROUTE;
extern NSString *const URL_DELETE_ROUTE;
extern NSString *const URL_GET_RELAVANT_PLAN_OF_ROUTE;

#pragma mark Plan
extern NSString *const URL_SEND_PLAN;
extern NSString *const URL_SEND_FREE_PLAN;
extern NSString *const URL_GET_ROUTE_FRO_SEND_PLAN;
extern NSString *const URL_PLAN_LIKEDLIST;

extern NSString *const URL_RECOMMEND_OF_PLAN;
extern NSString *const URL_GET_CREATED_PLAN_OFUSER;
extern NSString *const URL_GET_JOINED_PLAN_OFUSER;
extern NSString *const URL_GET_FAVORED_PLAN_OFUSER;
extern NSString *const URL_GET_USER_PLAN_HELPER_LIST; //邀约助手
extern NSString *const URL_GET_PLAN_DETAIL;
extern NSString *const URL_GET_PLAN_JOINED_USERLIST;
extern NSString *const URL_SEARCH_PLAN_BY_DESTINATION;
extern NSString *const URL_V5_SEARCH_PLAN;
extern NSString *const URL_SEARCH_DESTINATION_FROM_HOMEPAGE;
extern NSString *const URL_SEARCH_PLAN_BY_THEME;
extern NSString *const URL_ADD_COMMENT_TO_PLAN;
extern NSString *const URL_GET_COMMENT_OF_PLAN;
extern NSString *const URL_DELETE_COMMENT_OF_PLAN;
extern NSString *const URL_FAVOR_PLAN;
extern NSString *const URL_GET_NEARBY_PLAN;
extern NSString *const URL_CHECKIN_PLAN;


// v5 my plan

extern NSString *const URL_USER_JOINED_PLAN;
extern NSString *const URL_USER_FAVORED_PLAN;
extern NSString *const URL_USER_RAISED_PLAN;

//user Setting
extern NSString *const URL_USER_SETTING_WIFI_VEDIO_AUTOPLAY;
extern NSString *const URL_USER_SETTING_SHOWSELFTOCONTACT;

extern NSString *const URL_USER_CONTACT;
// v5 首页本地
extern NSString *const URL_GET_CALENDAR_PLAN;
extern NSString *const URL_GET_LOCATION_TOURPIC;
extern NSString *const URL_GET_LOCATION_NEARBY_PLAN;

//apply, approve, refuse, quit, delete
extern NSString *const URL_JOIN_PLAN;
extern NSString *const URL_APPROVE_JOIN_PLAN;
extern NSString *const URL_REFUSE_JOIN_PLAN;
extern NSString *const URL_QUIT_PLAN;
extern NSString *const URL_DELETE_PLAN;
extern NSString *const URL_KICKOFF_USRE_OF_PLAN;
extern NSString *const URL_FORWARD_PLAN;
// add to cart
extern NSString *const URL_ADD_TO_CART;

//stage
extern NSString *const URL_PLAN_STAGE_UPDATE;
extern NSString *const URL_PLAN_STAGE_REMOVE;

#pragma mark Chat
extern NSString *const URL_GET_NEARBY_CHATGROUP;
extern NSString *const URL_GET_MY_CHATGROUP;
extern NSString *const URL_GET_CHATGROUPLIST_BY_PLACENAME;
extern NSString *const URL_GET_CHATGROUP_INFO;
extern NSString *const URL_JOINE_CHATGROUP;
extern NSString *const URL_QUIT_CHATGROUP;

extern NSString *const URL_GET_CHAT_CONTACT_INFO;   //获取最近聊天列表
extern NSString *const URL_GET_FAVED_USER_IN_CHAT_CONTACT;  //聊天列表中，获取收藏的人列表
extern NSString *const URL_GET_JOINED_CHATROOM_LIST;    //获取加入的聊天群JID， 包括计划和聊天室

extern NSString *const URL_GET_RECOMMEND_USER_LIST; //获取推荐关注的人列表
extern NSString *const URL_GET_INVITE_USER_LIST_IN_ADDRESSBOOK; //获取通讯录中已经邀请过的好友
extern NSString *const URL_INVITE_USER_IN_ADDRESSBOOK;

extern NSString *const URL_GET_USERINFO_BY_TELEPHONE;

extern NSString *const URL_SET_PLAN_ALERT;
extern NSString *const URL_SET_CHATGROUP_ALERT;

#pragma mark Tourpic
extern NSString *const URL_TOURPIC_PUBLISH;
extern NSString *const URL_TOURPIC_GET_POPULAR;
extern NSString *const URL_TOURPIC_GET_FAVOR;
extern NSString *const URL_TOURPIC_GET_SQUARE;
extern NSString *const URL_TOURPIC_GET_BY_PLACE;
extern NSString *const URL_TOURPIC_GET_FROMPLANGUID;
extern NSString *const URL_TOURPIC_LIKE;
extern NSString *const URL_TOURPIC_UNLIKE;
extern NSString *const URL_TOURPIC_DETAIL;
extern NSString *const URL_TOURPIC_ADD_COMMENT;
extern NSString *const URL_TOURPIC_MYSELFS;
extern NSString *const URL_TOURPIC_LIKEDLIST;
extern NSString *const URL_TOURPIC_MORE_COMMENTS;
extern NSString *const URL_TOURPIC_NOTIFICATIONS;
extern NSString *const URL_TOURPIC_SET_MYSELF_COVER;
extern NSString *const URL_TOURPIC_DELETE;
extern NSString *const URL_TOURPIC_DELETE_COMMENT;
extern NSString *const URL_TOURPIC_SEARCH_DEST;

#pragma mark Setting
extern NSString *const URL_SET_INVITEUSER_TELEPHONE;
extern NSString *const URL_GET_SYSTEM_USERINFO; //获取系统用户Duckr的用户信息
extern NSString *const URL_SET_NOTIFY;
extern NSString *const URL_GET_USER_NOTIFICATION_LIST;

#pragma mark Search
extern NSString *const URL_SEARCH_MIX_PLAN_FOR_DESTINATION;
extern NSString *const URL_SEARCH_HERE_FOR_DESTINATION;
extern NSString *const URL_SEARCH_MIX_PLAN_FOR_THEME;



#pragma mark Common API
extern NSString *const URL_UPDATE_REMOTENOTIFICATION_DEVICETOKEN;
extern NSString *const URL_UPDATE_USER_LOCATION;
extern NSString *const URL_GET_QINIU_UPLOAD_TOKEN;
extern NSString *const URL_GET_INIT_CONFIG;
extern NSString *const URL_SET_APP_CONFIG;
extern NSString *const URL_GET_ROUTE_THEME;
extern NSString *const URL_SEARCH_RELATED_PLACE;
extern NSString *const URL_UPLOAD_ADDRESSBOOK;
extern NSString *const URL_GET_REDDOT_NUM;
extern NSString *const URL_BLOCK_UMENG;
extern NSString *const URL_COMMON_PROVINCE;
extern NSString *const URL_COMMON_CITY;

#pragma mark Local
extern NSString *const URL_LOCAL_LIST;
extern NSString *const URL_LOCAL_JOIN;
extern NSString *const URL_LOCAL_TRADE;
extern NSString *const URL_LOCAL_INVITE;
extern NSString *const URL_LOCAL_THEME_CALENDAR;
#pragma mark Home
extern NSString *const URL_HOME_RCMD;
extern NSString *const URL_HOME_RCMD_MODULE;
extern NSString *const URL_HOME_INVITE;
extern NSString *const URL_HOME_RCMD_PERSONAL;
extern NSString *const URL_HOME_RCMD_NEARBY;
extern NSString *const URL_HOME_RCMD_TODAY;
extern NSString *const URL_HOME_RCMD_TOMORROW;
extern NSString *const URL_HOME_RCMD_WEEKEND;
extern NSString *const URL_HOME_SEARCH_TEXT;
extern NSString *const URL_HOME_SEARCH_CALENDAR;
extern NSString *const URL_HOME_SEARCH_TEXT_MORE_ACTIV;
extern NSString *const URL_HOME_SEARCH_TEXT_MORE_INVITE;

extern NSString *const URL_PLAN_HOMEPAGE_LOCAL;
extern NSString *const URL_PLAN_HOMEPAGE_PLAN;
extern NSString *const URL_PLAN_HOMEPAGE_DUCKR;
extern NSString *const URL_PLAN_HOMEPAGE_RECM_SELECTED;
extern NSString *const URL_PLAN_HOMEPAGE_RECM_LOCAL;
extern NSString *const URL_PLAN_HOMEPAGE_RECM_HOT_TOURPICS;
extern NSString *const URL_PLAN_HOMEPAGE_RECM_ONLINE_DUCKRS;
extern NSString *const URL_PLAN_HOMEPAGE_RECM_ONLINE_HAPPENS;
extern NSString *const URL_PLAN_HOMEPAGE_RECM_LOCAL_DUCKRS;
extern NSString *const URL_PLAN_HOMEPAGE_RECM_LOCAL_DUCKRS_PLAN;
extern NSString *const URL_GET_HOMEPAGE_DUCKR_BOARD_LIST;
extern NSString *const URL_GET_HOMEPAGE_CONTENT;
extern NSString *const URL_GET_HOMEPAGE_CONTENT_V3_1;   //for version after v3.1
extern NSString *const URL_GET_HOMEPAGE_RECMD_PLAN;
extern NSString *const URL_GET_HOMEPAGE_RECMD_USER;
extern NSString *const URL_GET_HOMEPAGE_FAVOR_PLAN;

extern NSString *const URL_GET_HOMEPAGE_CONTENT_V4;
extern NSString *const URL_GET_HOMEPAGE_RECMD_PLAN_V4;


#pragma mark Order
extern NSString *const URL_GET_ORDER_RULE;
extern NSString *const URL_GET_PROFIT_PLAN_LIST;
extern NSString *const URL_PLAN_ORDER_NEW;
extern NSString *const URL_PLAN_TAIL_ORDER_NEW;
extern NSString *const URL_PLAN_ORDER_QUERY;    //支付成功查询订单
extern NSString *const URL_PLAN_ORDER_REFUND;
extern NSString *const URL_PLAN_ORDER_REFUND_V_FIVE;
extern NSString *const URL_PLAN_ORDER_LIST;
extern NSString *const URL_ANALYSE_SHARECODE;   //解析达客口令
extern NSString *const URL_PLAN_ARRIVAL;
extern NSString *const URL_PLAN_FAVOR;

#pragma mark - Server Error Code
extern const NSInteger ErrCodeJoinMultiPlanConflict;
extern const NSInteger ErrCodePlanNotExist;
extern const NSInteger ErrCodeHaveSetInvitedUserTelephone;
extern const NSInteger ErrCodePlanOrderHavePaid;   //已经加入邀约了(付款了)，不能再发起付款



@interface LCNetRequesterConstants : NSObject

@end
