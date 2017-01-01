//
//  LCUserNotificationModel.h
//  LinkCity
//
//  Created by roy on 3/29/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

/*
 用于用户消息的Model
 */

#import "LCBaseModel.h"

typedef enum : NSUInteger {
    LCUserNotificationType_CommentPlan = 1,     //评论了计划
    LCUserNotificationType_FavorUser = 6,       //有人关注了你
    LCUserNotificationType_TourpicComment = 7,    ///> 旅图评论.
    LCUserNotificationType_ApplyPlan = 8,       //申请加入计划
    LCUserNotificationType_EvaluationUser = 9,  //对你进行评价
    LCUserNotificationType_CloseTestQuestion = 10, //收到密测提问
    LCUserNotificationType_CloseTestReply = 11, //收到别人对你发起的密测的回复
    LCUserNotificationType_CarIdentity = 12,
    LCUserNotificationType_UserIdentity = 13,
    LCUserNotificationType_TourguideIdentity = 14,
    LCUserNotificationType_TourpicLiked = 15,   ///> 旅图点赞.
    LCUserNotificationType_TourpicWithWho = 16,    ///> 对同伴的通知.
    LCUserNotificationType_System = 100,
} LCUserNotificationType;

@interface LCUserNotificationModel : LCBaseModel

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *avatarUrl;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *picUrl;
@property (nonatomic, strong) NSString *guid;   //plan guid
@property (nonatomic, strong) NSString *userUUID;
@property (nonatomic, strong) NSString *closeTestId;
@property (nonatomic, strong) NSString *eventUrl;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString *createdTime;
@property (nonatomic, strong) NSDictionary *notifyInfo;


- (NSString *)getTourWallGuid;

@end
