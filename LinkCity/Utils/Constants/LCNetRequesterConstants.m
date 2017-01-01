//
//  LCNetRequesterConstants.m
//  LinkCity
//
//  Created by roy on 2/26/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCNetRequesterConstants.h"



#pragma mark - Server Request URL

#pragma mark User
NSString *const URL_FAVOR_USER = @"user/favor/add/";
NSString *const URL_SEARCH_USER_BY_KEYWORD = @"v3/user/search/list/";
NSString *const URL_GET_USERINFO = @"v3/user/info/";
NSString *const URL_ADD_EVALUATION = @"v3/user/evaluation/add/";
NSString *const URL_GET_EVALUATION = @"v3/user/evaluation/list/";
NSString *const URL_GET_USER_SERVICE = @"v3/user/service/list/";
NSString *const URL_FOLLOW_USER = @"v3/user/favor/add/";
NSString *const URL_UNFOLLOW_USER = @"v3/user/favor/cancel/";
NSString *const URL_GET_NEARBY_TOURIST = @"v3/nearby/tourists/list/";
NSString *const URL_GET_NEARBY_NATIVE = @"v3/nearby/duckr/all/";
NSString *const URL_USER_IDENTITY = @"v3/user/identity/commit/";
NSString *const URL_GET_USER_IDENTITY_INFO = @"v3/user/identity/status/";
NSString *const URL_CAR_IDENTITY = @"v3/user/car/identity/commit/";
NSString *const URL_GET_CAR_IDENTITY_INFO = @"v3/user/car/identity/status/";
NSString *const URL_GUIDE_IDENTITY_APPROVE = @"v3/user/tour/guide/approve/";
NSString *const URL_GUIDE_IDENTITY = @"v3/user/guider/identity/commit/";
NSString *const URL_GET_GUIDE_IDENTITY_INFO = @"v3/user/guider/identity/status/";
NSString *const URL_GET_FANS_LIST = @"v3/user/fans/getlist/";
NSString *const URL_GET_USERLIST_BY_PLACENAME = @"v3/user/local/duckr/list/";
NSString *const URL_GET_SCHOOL_LIST = @"v3/user/college/search/";
NSString *const URL_GET_USER_HOMEPAGE = @"v4/personal/homepage/";
NSString *const URL_REPORT_USER = @"v4/user/report/";
NSString *const URL_USER_MARGIN_ORDER_NEW = @"v4/user/margin/submit/";
NSString *const URL_USER_MARGIN_ORDER_QUERY = @"v4/user/margin/query/";
NSString *const URL_GET_FANS_LIST_V_FIVE = @"v5/user/fans/list/";
NSString *const URL_GET_FAVORS_LIST_V_FIVE = @"v5/user/favor/list/";
NSString *const URL_GET_FANS_DYNAMIC_V_FIVE = @"v5/user/fans/dynamic/";
NSString *const URL_GET_FAVORS_DYNAMIC_V_FIVE = @"v5/user/favor/dynamic/";
NSString *const URL_GET_FANS_SEARCH_RESULT_V_FIVE = @"v5/user/search/favor/";
NSString *const URL_GET_USER_RED_DOT_V_FIVE = @"v5/user/system/reddot/";
NSString *const URL_GET_USER_ALL_ORDER_V_FIVE = @"v5/user/order/list/";
NSString *const URL_GET_USER_PENDING_PAYMENT_ORDER_V_FIVE = @"v5/user/order/need/payment/list/";
NSString *const URL_GET_USER_TO_BE_EVALUATED_ORDER_V_FIVE = @"v5/user/need/eval/plan/list/";
NSString *const URL_GET_USER_REFUND_ORDER_V_FIVE = @"v5/user/order/refund/list/";
NSString *const URL_DELETE_USER_ORDER_V_FIVE = @"v5/user/order/del/";
NSString *const URL_GET_USER_RECM_DUCKR_V_FIVE = @"v5/user/recommend/duckr/list/";
NSString *const URL_SET_USER_REMARK_NAME = @"v5/user/remark/name/set/";
NSString *const URL_REPORT_USER_V_FIVE = @"v5/user/report/";
NSString *const URL_GET_NOTIFICATION = @"v5/user/notification/get/";
NSString *const URL_GET_MERCHANT_SERVICE_LIST = @"v5/user/service/list/";
NSString *const URL_GET_MERCHANT_BILL_LIST = @"v5/user/bill/list/";
NSString *const URL_GET_MERCHANT_REFUND_LIST = @"v5/user/myservice/refund/list/";
NSString *const URL_GET_MERCHANT_REFUND_DETAIL = @"v5/user/myservice/refund/detail/";
NSString *const URL_GET_MERCHANT_SIGN_UP_DETAIL = @"v5/user/myservice/signup/detail/";
NSString *const URL_GET_MERCHANT_AGREE_REFUND = @"v5/user/myservice/refund/confirm/";
NSString *const URL_GET_MERCHANT_ORDER_CHECK = @"v5/user/myservice/order/check/";
NSString *const URL_GET_MERCHANT_ADD_CARD = @"v5/user/bind/bankcard/";
NSString *const URL_GET_MERCHANT_WITHDRAW = @"v5/user/merchant/withdraw/";
NSString *const URL_GET_MERCHANT_WITHDRAW_LIST = @"v5/user/merchant/withdraw/record/";
NSString *const URL_GET_MERCHANT_BANK_LIST = @"v5/user/bank/list/";

#pragma mark Register & Login
NSString *const URL_SEND_AUTHCODE = @"phone/authcode/send/";
NSString *const URL_REGISTER_USER = @"v3/user/register/";
NSString *const URL_VERIFY_AUTHCODE = @"phone/authcode/verify/";
NSString *const URL_UPDATE_USER = @"v3/user/info/modify/";
NSString *const URL_LOGIN = @"v3/user/login/";
NSString *const URL_RESET_PASSWORD = @"v3/user/password/update/";



#pragma mark Route
NSString *const URL_SEND_ROUTE = @"v3/plan/route/create/";
NSString *const URL_DELETE_ROUTE = @"v3/plan/route/delete/";
NSString *const URL_GET_RELAVANT_PLAN_OF_ROUTE = @"v3/plan/relevant/get/";


#pragma mark Plan
NSString *const URL_SEND_PLAN = @"v4/plan/create/";
NSString *const URL_SEND_FREE_PLAN = @"v5/free/plan/create/";
NSString *const URL_GET_ROUTE_FRO_SEND_PLAN = @"v4/plan/create/getroute/";
NSString *const URL_RECOMMEND_OF_PLAN = @"v3/plan/dest/recommend/";
NSString *const URL_PLAN_LIKEDLIST = @"v5/user/plan/favor/list/";


//search
NSString *const URL_GET_CREATED_PLAN_OFUSER = @"v3/user/plan/create/list/";
NSString *const URL_GET_JOINED_PLAN_OFUSER = @"v3/user/plan/join/list/";
NSString *const URL_GET_USER_PLAN_HELPER_LIST = @"v4/user/plan/helper/";
NSString *const URL_GET_PLAN_DETAIL = @"v5/plan/detail/";
NSString *const URL_GET_PLAN_JOINED_USERLIST = @"v4/plan/joined/";
NSString *const URL_GET_FAVORED_PLAN_OFUSER = @"v3/user/plan/get/favorlist/";
NSString *const URL_SEARCH_PLAN_BY_DESTINATION = @"v3/plan/search/dest/";
NSString *const URL_V5_SEARCH_PLAN = @"v5/plan/search/dest/";
NSString *const URL_SEARCH_DESTINATION_FROM_HOMEPAGE = @"v41/plan/search/dest/";
NSString *const URL_SEARCH_PLAN_BY_THEME = @"v3/plan/search/theme/";
NSString *const URL_GET_NEARBY_PLAN = @"v3/nearby/plan/list/";
NSString *const URL_GET_CALENDAR_PLAN = @"v5/homepage/inhabitcity/partner/calendar/";
NSString *const URL_GET_LOCATION_TOURPIC = @"v5/homepage/inhabitcity/tourpic/local/";
NSString *const URL_GET_LOCATION_NEARBY_PLAN = @"v5/homepage/inhabitcity/partner/local/";

//comment
NSString *const URL_ADD_COMMENT_TO_PLAN = @"v3/plan/comment/add/";
NSString *const URL_GET_COMMENT_OF_PLAN = @"v3/plan/comment/get/";
NSString *const URL_DELETE_COMMENT_OF_PLAN = @"v3/plan/comment/delete/";

//my plan
NSString *const URL_USER_JOINED_PLAN = @"v5/user/plan/user/joined/";
NSString *const URL_USER_FAVORED_PLAN = @"v5/user/plan/user/favored/";
NSString *const URL_USER_RAISED_PLAN = @"v5/user/plan/user/raised/";

//userSetting
NSString *const URL_USER_SETTING_WIFI_VEDIO_AUTOPLAY = @"v5/set/wifi/vedio/auto/play/";
NSString *const URL_USER_SETTING_SHOWSELFTOCONTACT = @"v5/set/show/self/to/contact/";

NSString *const URL_USER_CONTACT = @"v5/user/address/list/";
//favor, unfavor
NSString *const URL_FAVOR_PLAN = @"v5/user/plan/favor/";

//apply, approve, refuse, quit, delete
NSString *const URL_JOIN_PLAN = @"v5/user/join/plan/";
NSString *const URL_APPROVE_JOIN_PLAN = @"v3/user/plan/join/approve/";
NSString *const URL_REFUSE_JOIN_PLAN = @"v3/user/plan/join/refuse/";
NSString *const URL_QUIT_PLAN = @"v3/user/plan/quit/";
NSString *const URL_DELETE_PLAN = @"v3/plan/delete/";
NSString *const URL_CHECKIN_PLAN = @"v3/plan/checkin/";
NSString *const URL_KICKOFF_USRE_OF_PLAN = @"v3/plan/kick/user/";
NSString *const URL_FORWARD_PLAN = @"v3/plan/partner/forward/";
// add to cart
NSString *const URL_ADD_TO_CART = @"v5/plan/buy/cart/add/";

//stage
NSString *const URL_PLAN_STAGE_UPDATE = @"v4/plan/stage/save/";
NSString *const URL_PLAN_STAGE_REMOVE = @"v4/plan/stage/remove/";

#pragma mark Chat
NSString *const URL_GET_NEARBY_CHATGROUP = @"v3/nearby/chat/group/list/";
NSString *const URL_GET_MY_CHATGROUP = @"v3/chat/local/group/list/";
NSString *const URL_GET_CHATGROUPLIST_BY_PLACENAME = @"v3/group/search/dest/";
NSString *const URL_GET_CHATGROUP_INFO = @"v3/chat/group/info/";
NSString *const URL_QUIT_CHATGROUP = @"v3/chat/group/quit/";
NSString *const URL_JOINE_CHATGROUP = @"v3/chat/local/group/join/";
NSString *const URL_GET_CHAT_CONTACT_INFO = @"v3/chat/recent/list/";
NSString *const URL_GET_JOINED_CHATROOM_LIST = @"v3/chat/joined/jidlist/";
NSString *const URL_GET_FAVED_USER_IN_CHAT_CONTACT = @"v3/user/favor/get/";
NSString *const URL_GET_RECOMMEND_USER_LIST = @"v3/chat/recommend/list/";
NSString *const URL_GET_INVITE_USER_LIST_IN_ADDRESSBOOK = @"v3/phone/book/getaddlist/";
NSString *const URL_INVITE_USER_IN_ADDRESSBOOK = @"v3/chat/contact/invite/";
NSString *const URL_GET_USERINFO_BY_TELEPHONE = @"v3/chat/getuser/bytelephone/";
NSString *const URL_SET_PLAN_ALERT = @"v3/chat/plan/push/set/";
NSString *const URL_SET_CHATGROUP_ALERT = @"v3/chat/group/push/set/";


#pragma mark Tourpic
NSString *const URL_TOURPIC_PUBLISH = @"v5/tourpic/add/";
NSString *const URL_TOURPIC_GET_POPULAR = @"v5/tourpic/popular/list/";
NSString *const URL_TOURPIC_GET_FROMPLANGUID = @"v5/tourpic/plandetail/more/";
NSString *const URL_TOURPIC_GET_FAVOR = @"v5/tourpic/concern/list/";
NSString *const URL_TOURPIC_GET_SQUARE = @"v5/tourpic/sequare/list/";
NSString *const URL_TOURPIC_GET_BY_PLACE = @"v5/tourpic/search/list/";
NSString *const URL_TOURPIC_LIKE = @"v3/photo/tourpic/like/";
NSString *const URL_TOURPIC_UNLIKE = @"v3/photo/tourpic/cancellike/";
NSString *const URL_TOURPIC_DETAIL = @"v5/tourpic/detail/";
NSString *const URL_TOURPIC_ADD_COMMENT = @"v3/photo/tourpic/comment/";
NSString *const URL_TOURPIC_MYSELFS = @"v5/tourpic/myself/list/";
NSString *const URL_TOURPIC_LIKEDLIST = @"v3/photo/tourpic/likelist/get/";
NSString *const URL_TOURPIC_MORE_COMMENTS = @"v3/photo/tourpic/morecomment/";
NSString *const URL_TOURPIC_NOTIFICATIONS = @"v3/photo/tourpic/notification/get/";
NSString *const URL_TOURPIC_SET_MYSELF_COVER = @"v3/tourpic/myself/cover/";
NSString *const URL_TOURPIC_DELETE = @"v3/photo/tourpic/delete/";
NSString *const URL_TOURPIC_DELETE_COMMENT = @"v3/photo/tourpic/deletecomment/";
NSString *const URL_TOURPIC_SEARCH_DEST = @"v5/tourpic/search/dest/";

#pragma mark Search
NSString *const URL_SEARCH_MIX_PLAN_FOR_DESTINATION = @"v4/plan/search/mixed/dest/";
NSString *const URL_SEARCH_HERE_FOR_DESTINATION = @"v3/search/here/list/";
NSString *const URL_SEARCH_MIX_PLAN_FOR_THEME = @"v4/search/theme/plans/";


#pragma mark Setting
NSString *const URL_SET_INVITEUSER_TELEPHONE = @"v3/user/inviteduser/source/";
NSString *const URL_GET_SYSTEM_USERINFO = @"v3/user/info/system/";
NSString *const URL_SET_NOTIFY = @"v3/usernotify/set/";
NSString *const URL_GET_USER_NOTIFICATION_LIST = @"v3/user/notification/get/";

#pragma mark Common API
NSString *const URL_UPDATE_REMOTENOTIFICATION_DEVICETOKEN = @"user/status/update/";
NSString *const URL_UPDATE_USER_LOCATION = @"place/location/update/";
NSString *const URL_GET_QINIU_UPLOAD_TOKEN = @"qiniu/uptoken/";
NSString *const URL_GET_INIT_CONFIG = @"v5/homepage/app/config/init/";
NSString *const URL_SET_APP_CONFIG = @"v5/homepage/app/config/set/";
NSString *const URL_GET_ROUTE_THEME = @"plan/theme/list";
NSString *const URL_SEARCH_RELATED_PLACE = @"v3/place/destination/search/";
NSString *const URL_UPLOAD_ADDRESSBOOK = @"v3/phone/book/upload/";
NSString *const URL_GET_REDDOT_NUM = @"v3/user/system/reddot/";
NSString *const URL_BLOCK_UMENG = @"v4/user/umeng/set/";
NSString *const URL_COMMON_PROVINCE = @"v5/place/provinces/";
NSString *const URL_COMMON_CITY = @"v5/place/provinces/cities/";

#pragma mark Local
NSString *const URL_LOCAL_LIST = @"v5/local/leisure/list/";
NSString *const URL_LOCAL_JOIN = @"v5/local/leisure/join/";
NSString *const URL_LOCAL_TRADE = @"v5/local/product/";
NSString *const URL_LOCAL_INVITE = @"v5/local/invitation/";
NSString *const URL_LOCAL_THEME_CALENDAR = @"v5/local/product/theme/";

#pragma mark Home
NSString *const URL_HOME_RCMD = @"v5/home/rcmd/";
NSString *const URL_HOME_RCMD_MODULE = @"v5/home/rcmd/module/personal/";
NSString *const URL_HOME_INVITE = @"v5/home/invitation/";
NSString *const URL_HOME_RCMD_PERSONAL = @"v5/home/rcmd/personal/";
NSString *const URL_HOME_RCMD_NEARBY = @"v5/home/rcmd/nearby/";
NSString *const URL_HOME_RCMD_TODAY = @"v5/home/rcmd/today/";
NSString *const URL_HOME_RCMD_TOMORROW = @"v5/home/rcmd/tomorrow/";
NSString *const URL_HOME_RCMD_WEEKEND = @"v5/home/rcmd/weekend/";
NSString *const URL_HOME_SEARCH_TEXT = @"v5/home/search/text/";
NSString *const URL_HOME_SEARCH_CALENDAR = @"v5/home/search/calendar/";
NSString *const URL_HOME_SEARCH_TEXT_MORE_ACTIV = @"v5/home/search/text/more/activ/";
NSString *const URL_HOME_SEARCH_TEXT_MORE_INVITE = @"v5/home/search/text/more/invite/";


NSString *const URL_PLAN_HOMEPAGE_LOCAL = @"v5/homepage/inhabitcity/";
NSString *const URL_PLAN_HOMEPAGE_PLAN = @"v5/homepage/partner/";
NSString *const URL_PLAN_HOMEPAGE_DUCKR = @"v5/homepage/duckr/";
NSString *const URL_PLAN_HOMEPAGE_RECM_SELECTED = @"v5/homepage/recommend/select/activities/";
NSString *const URL_PLAN_HOMEPAGE_RECM_LOCAL = @"v5/homepage/recommend/select/activities/local/";
NSString *const URL_PLAN_HOMEPAGE_RECM_HOT_TOURPICS = @"v5/homepage/recommend/tourpic/hotlist/";
NSString *const URL_PLAN_HOMEPAGE_RECM_ONLINE_DUCKRS = @"v5/homepage/recommend/online/duckr/";
NSString *const URL_PLAN_HOMEPAGE_RECM_ONLINE_HAPPENS = @"v5/homepage/recommend/online/happening/";
NSString *const URL_PLAN_HOMEPAGE_RECM_LOCAL_DUCKRS = @"v5/homepage/inhabitcity/user/";
NSString *const URL_PLAN_HOMEPAGE_RECM_LOCAL_DUCKRS_PLAN = @"v5/homepage/inhabitcity/dynamic/";

NSString *const URL_GET_HOMEPAGE_DUCKR_BOARD_LIST = @"v5/homepage/duckr/borad/more/";

NSString *const URL_GET_HOMEPAGE_CONTENT = @"v3/plan/homepage/";
NSString *const URL_GET_HOMEPAGE_CONTENT_V3_1 = @"v3/partner/homepage/";
NSString *const URL_GET_HOMEPAGE_RECMD_PLAN = @"v3/plan/recmd/list/";
NSString *const URL_GET_HOMEPAGE_RECMD_USER = @"v3/duckr/recmd/list/";
NSString *const URL_GET_HOMEPAGE_FAVOR_PLAN = @"v3/plan/favor/list/";

NSString *const URL_GET_HOMEPAGE_CONTENT_V4 = @"v41/plan/homepage/";
NSString *const URL_GET_HOMEPAGE_RECMD_PLAN_V4 = @"v4/plan/more/list/";

#pragma mark Order
NSString *const URL_GET_ORDER_RULE = @"v3/plan/order/rule/";
NSString *const URL_GET_PROFIT_PLAN_LIST = @"v3/user/plan/profit/list/";
NSString *const URL_PLAN_ORDER_NEW = @"v3/plan/order/new/";
NSString *const URL_PLAN_TAIL_ORDER_NEW = @"v3/plan/order/tail/";
NSString *const URL_PLAN_ORDER_QUERY = @"v3/plan/order/query/";
NSString *const URL_PLAN_ORDER_REFUND = @"v3/plan/order/refund/";
NSString *const URL_PLAN_ORDER_REFUND_V_FIVE = @"v5/user/order/refund/";
NSString *const URL_PLAN_ORDER_LIST = @"v4/user/order/list/";
NSString *const URL_ANALYSE_SHARECODE = @"v4/plan/share/getrecmd/";   //解析达客口令
NSString *const URL_PLAN_ARRIVAL = @"v4/plan/arrive/";
NSString *const URL_PLAN_FAVOR = @"v5/user/plan/favor/";

#pragma mark - Server Error Code
const NSInteger ErrCodeJoinMultiPlanConflict = -52;
const NSInteger ErrCodePlanNotExist = -57;
const NSInteger ErrCodeHaveSetInvitedUserTelephone = -220;
const NSInteger ErrCodePlanOrderHavePaid = -157;



@implementation LCNetRequesterConstants

@end
