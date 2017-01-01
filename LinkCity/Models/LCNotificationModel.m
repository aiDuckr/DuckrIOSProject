//
//  LCNotificationModel.m
//  LinkCity
//
//  Created by lhr on 16/6/14.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCNotificationModel.h"


static NSString *const typeKey = @"Type";
static NSString *const contentKey = @"Content";
static NSString *const objKey = @"Obj";
static NSString *const fromUserKey = @"FromUser";
static NSString *const createTimeKey = @"CreatedTime";

@implementation LCNotificationModel
- (instancetype)initWithDictionary:(NSDictionary *)dic {
    self = [super initWithDictionary:dic];
    if (self) {
        self.fromUser = [[LCUserModel alloc] initWithDictionary:[dic objectForKey:fromUserKey]];
        self.notificaionType = [[dic objectForKey:typeKey] integerValue];
        self.createdTime = [LCStringUtil getNotNullStr:[dic objectForKey:createTimeKey]];
        self.content = [LCStringUtil getNotNullStr:[dic objectForKey:contentKey]];
        if (LCNotificationTypeUserFollow == self.notificaionType) {
            if ([dic objectForKey:objKey]) {
                self.toUser = [[LCUserModel alloc] initWithDictionary:[dic objectForKey:objKey]];
            }
        } else if (LCNotificationTypeTourpic == self.notificaionType) {
            if ([dic objectForKey:objKey]) {
                self.tourPicInfo = [[LCTourpic alloc] initWithDictionary:[dic objectForKey:objKey]];
            }
        } else if (LCNotificationTypePlan == self.notificaionType) {
            if ([dic objectForKey:objKey]) {
                self.planInfo = [[LCPlanModel alloc] initWithDictionary:[dic objectForKey:objKey]];
            }
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.fromUser forKey:fromUserKey];
    [coder encodeObject:self.createdTime forKey:createTimeKey];
    [coder encodeInteger:self.notificaionType forKey:typeKey];
    if (LCNotificationTypeUserFollow == self.notificaionType) {
        [coder encodeObject:self.toUser forKey:objKey];
    } else if (LCNotificationTypeTourpic == self.notificaionType) {
        [coder encodeObject:self.tourPicInfo forKey:objKey];
    } else if (LCNotificationTypePlan == self.notificaionType) {
        [coder encodeObject:self.planInfo  forKey:objKey];
    }
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.fromUser = [coder decodeObjectForKey:fromUserKey];
        self.createdTime = [coder decodeObjectForKey:createTimeKey];
        self.notificaionType = [coder decodeIntegerForKey:typeKey];
        if (LCNotificationTypeUserFollow == self.notificaionType) {
            self.toUser = [coder decodeObjectForKey:objKey];
        } else if (LCNotificationTypeTourpic == self.notificaionType) {
            self.tourPicInfo = [coder decodeObjectForKey:objKey];
        } else if (LCNotificationTypePlan == self.notificaionType) {
            self.planInfo = [coder decodeObjectForKey:objKey];
        }
    }
    return self;
}

@end
