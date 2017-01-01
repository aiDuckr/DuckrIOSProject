//
//  LCNotificationModel.h
//  LinkCity
//
//  Created by lhr on 16/6/14.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCBaseModel.h"

typedef NS_ENUM(NSInteger, LCNotificationType) {
    LCNotificationTypeUserFollow = 0,
    LCNotificationTypeTourpic = 1,
    LCNotificationTypePlan = 2,
};

@interface LCNotificationModel : LCBaseModel

@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) LCUserModel *fromUser;

@property (nonatomic, strong) LCUserModel *toUser;

@property (nonatomic, strong) LCPlanModel *planInfo;

@property (nonatomic, strong) LCTourpic *tourPicInfo;

@property (nonatomic, strong) NSString *createdTime;

@property (nonatomic, assign) LCNotificationType notificaionType;

//@property (nonatomic, assign) BOOL isCommontNotification;
@end
