//
//  YSHttpApi.h
//  YSAFNetworking
//
//  Created by zzs on 14-7-21.
//  Copyright (c) 2014年 yunshuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "LCDataManager.h"
#import "LCUserModel.h"

#define HINT_NOT_CONNECTION_TIME 1.0
#define REQUEST_STATUS_OK 0

#define NETWORK_ERROR_CODE 9876
#define NETWORK_ERROR_MESSAGE @"网络请求错误，请检查您的网络"
#define INPUT_ERROR_CODE 9877
#define INPUT_ERROR_MESSAGE @"网络请求参数错误，请检查您的输入"

/**
 * @brief   生成访问后台的url地址.
 *
 * @param   prefix  网址的前缀.
 * @param   suffix  网址的后缀.
 *
 * @return  返回访问后台的网址.
 */
#define server_url(prefix, suffix)  [NSString stringWithFormat:@"%@%@", prefix, suffix]

typedef void(^requestCallBack)(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error);


/// 访问后台Tag.
enum RequestTags {
    QINIU_UPLOAD_TOKEN_TAG,             //!< 获取七牛上传Token字符串.
    PUBLISH_NEW_PARTNER_TAG,            //!< 发布新的邀约计划.
    SEARCH_DESTINATION_LIST_TAG,        //!< 搜索目的地列表.
    GET_HOT_DESTINATION_LIST_TAG,       //!< 获取热门目的地列表.

    PLAN_SEARCH_TAG,                    //!< 按照条件搜索计划.

    
    LOGIN_TAG,                          //!< 用户登录
    REGISTER_SEND_AUTHCODE_TAG,         //!< 向手机发送验证码
    REGISTER_USER_TAG,                  //!< 注册用户
    REGISTER_RESET_PASSWORD_TAG,        //!< 重置密码
    UPDATE_REMOTENOTIFICATION_DEVICETOKEN_TAG, //!< 更新远程通知的token
    UPDATE_USER_LOCATION_TAG,           //!< 更新用户位置信息
    GET_USER_INFO_TAG,                  //!< 获取用户信息
    UPDATE_USER_INFO_TAG,               //!< 更新用户信息
    GET_USER_PHOTOTS_TAG,               //!< 获取用户相册
    ADD_PHOTOT_TAG,                     //!< 添加用户照片到相册
    DELETE_PHOTOT_TAG,                  //!< 删除用户照片
    GET_USERINFO_LSIT_BY_TELEPHONE_TAG, //!< 通过手机号数组，获取用户信息数组
    GET_RECEPTION_DETAIL_TAG,            //!< 获取招待详情
    PUBLISH_RECEPTION_TAG,              //!< 发布招待计划.
    GET_PARTNER_DETAIL_TAG,             //!< 获取邀约详情
    
    GET_NEARBY_USERS_TAG,               //!< 获取附近用户
    
    JOIN_PLAN_TAG,                      //!< 加入计划
    QUIT_PLAN_TAG,                      //!< 退出计划
    DELETE_PLAN_TAG,                    //!< 删除计划
    GET_PLAN_COMMENT_TAG,               //!< 获得计划评论
    ADD_COMMENT_TAG,                    //!< 添加评论
    DELETE_COMMENT_TAG,                 //!< 删除评论

    PRISE_PLAN_TAG,                     //!< 赞
    CANCEL_PRISE_PLAN_TAG,              //!< 取消赞
    FAVOR_PLAN_TAG,                     //!< 收藏
    CANCEL_FAVOR_PLAN_TAG,              //!< 取消收藏
    ADD_SHARE_NUMBER_TOPLAN_TAG,        //!< 添加分享数
    GET_SHARE_NUMBER_FROMPLAN_TAG,      //!< 获取分享数
    SIGN_PLAN_TAG,                      //!< 签到
    
    GET_PARTICIPATED_PLAN_TAG,              //!< 获取参加的计划列表
    GET_FAVOR_PLAN_TAG,                 //!< 获取收藏的技术列表
    GET_UNREAD_MSG_COUNT_TAG,           //!< 获取未读消息数.
    
    
    GET_APP_VERSION_TAG,                    //!< 获取APP的版本号.
    SET_APP_NOTIFIY_SWITCH_TAG,             //!< 设置推送通知开关.
    
    GET_CHAT_CONTACTS_TAG,                  //!< 获取联系人信息.
    KICK_OFF_USER_TAG,                      //!< 剔除群里面的某人.
    SET_WHETHER_PUSH_NOTIFICATION_OFCHAT_TAG,   //!< 设置某个聊天，是否push notification
    
    MESSAGE_CENTER_NOTIFY_TAG,              //!< 获取消息列表.
    UPLOAD_TELEPHONE_CONTACT_TAG,           //!< 上传通讯录.
    FAVOR_USER_TAG,                         //!< 收藏某人.
    CANCEL_FAVOR_USER_TAG,                  //!< 取消收藏某人.
    SET_READ_MESSAGE_TAG,                   //!< 通知变已读.
    SET_READ_ALL_MESSAGE_TAG,               //!< 全部通知变已读.
    SET_USER_UNREAD_EMPTY_TAG,              //!< 清空某条聊天消息的提醒数目.
    GET_SYSTEM_USERINFO_TAG,                //!< 获取系统意见反馈客服对象.
    GET_UNREAD_NOTIFICATION_TAG,            //!< 获取整体未读数目.
    FAVOR_USER_LIST_TAG,                    //!< 获取用户收藏人的列表.
    
    HOMEPAGE_PLAN_LIST_TAG,               //!< 新版本获取主页的计划列表.
    GET_INIT_CONFIG_TAG,                   //!< 获取初始化配置信息.
};

/// 访问后台类.
@interface LCHttpApi : NSObject {
    AFHTTPRequestOperationManager *manager;
}

- (void)doGet:(NSString*)urlStr withParams:(NSDictionary*)params withTag:(NSInteger)tag;
- (void)doPost:(NSString*)urlStr withParams:(NSDictionary*)params withTag:(NSInteger)tag;

- (void)doGet:(NSString *)urlStr withParams:(NSDictionary *)params requestCallBack:(requestCallBack)callback;
- (void)doPost:(NSString *)urlStr withParams:(NSDictionary *)params requestCallBack:(requestCallBack)callback;

- (void)requestFinished;
- (void)requestFailed;

- (void)cancelAllOperations;

/// 访问后台接口标志.
@property (assign, nonatomic) NSInteger tag;    //一次请求的标志
@property (assign, nonatomic) int status;   //请求的结果状态
@property (retain, nonatomic) NSDictionary *dataDic;    //请求的结果Dic
@property (retain, nonatomic) NSString *msg;    //请求的结果Message
@property (retain, nonatomic) NSDictionary *jsonDic;    //请求的总结果Dic

@end
