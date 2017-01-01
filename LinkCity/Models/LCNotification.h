//
//  LCNotification.h
//  LinkCity
//
//  Created by zzs on 14/12/2.
//  Copyright (c) 2014年 linkcity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCBaseModel.h"

typedef enum {NOTIFY_TYPE_REPLY_PLAN = 1, NOTIFY_TYPE_REPLY_COMMENT, NOTIFY_TYPE_PRAISE, NOTIFY_TYPE_EVENT, NOTIFY_TYPE_SYSTEM = 100, NOTIFY_TYPE_SYSTEM_GOTO_PLAN} NotifType;
typedef enum {NOTIF_STATUS_UNREAD = 1, NOTIF_STATUS_READ} NotifStatus;

@interface LCNotification : LCBaseModel

- (id)initWithDictionary:(NSDictionary *)dic;
- (void)encodeWithCoder:(NSCoder *)coder;
- (id)initWithCoder:(NSCoder *)coder;

@property (nonatomic, retain) NSString *notfID;
@property (nonatomic, retain) NSString *fromUserUuid;
@property (nonatomic, assign) NotifType type;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSString *fromUserAvatar;
@property (nonatomic, retain) NSString *planGuid;
@property (nonatomic, retain) NSString *planType;
@property (nonatomic, retain) NSString *eventUrl;
@property (nonatomic, retain) NSString *eventTitile;
@property (nonatomic, retain) NSString *createdTime;
@property (nonatomic, retain) NSString *timestamp;
@property (nonatomic, assign) NotifStatus status;
@property (nonatomic, retain) NSString *notifTitle;

@end
