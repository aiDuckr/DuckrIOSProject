//
//  LCNotification.m
//  LinkCity
//
//  Created by zzs on 14/12/2.
//  Copyright (c) 2014年 linkcity. All rights reserved.
//

#import "LCNotification.h"

@implementation LCNotification

- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super initWithDictionary:dic];
    if (self)
    {
        self.notfID = [LCStringUtil getNotNullStr:[dic objectForKey:@"Id"]];
        self.fromUserUuid = [LCStringUtil getNotNullStr:[dic objectForKey:@"FromUserUuid"]];
        self.type = [LCStringUtil idToInt:[dic objectForKey:@"Type"]];
        self.content = [LCStringUtil getNotNullStr:[dic objectForKey:@"Content"]];
        self.fromUserAvatar = [LCStringUtil getNotNullStr:[dic objectForKey:@"FromUserAvatar"]];
        self.planGuid = [LCStringUtil getNotNullStr:[dic objectForKey:@"PlanGuid"]];
        self.planType = [LCStringUtil getNotNullStr:[dic objectForKey:@"PlanType"]];
        self.eventUrl = [LCStringUtil getNotNullStr:[dic objectForKey:@"EventUrl"]];
        self.eventTitile = [LCStringUtil getNotNullStr:[dic objectForKey:@"EventTitile"]];
        self.createdTime = [LCStringUtil getNotNullStr:[dic objectForKey:@"CreatedTime"]];
        self.timestamp = [LCStringUtil getNotNullStr:[dic objectForKey:@"Timestamp"]];
        self.status = [LCStringUtil idToInt:[dic objectForKey:@"Status"]];
        self.notifTitle = [LCStringUtil getNotNullStr:[dic objectForKey:@"NotifTitle"]];
    }
    return self;
}

- (void)encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:self.notfID forKey:@"NotfID"];
    [coder encodeObject:self.fromUserUuid forKey:@"FromUserUuid"];
    [coder encodeInt:self.type forKey:@"Type"];
    [coder encodeObject:self.content forKey:@"Content"];
    [coder encodeObject:self.fromUserAvatar forKey:@"FromUserAvatar"];
    [coder encodeObject:self.planGuid forKey:@"PlanGuid"];
    [coder encodeObject:self.planType forKey:@"PlanType"];
    [coder encodeObject:self.eventUrl forKey:@"EventUrl"];
    [coder encodeObject:self.eventTitile forKey:@"EventTitile"];
    [coder encodeObject:self.createdTime forKey:@"CreatedTime"];
    [coder encodeObject:self.timestamp forKey:@"Timestamp"];
    [coder encodeInt:self.status forKey:@"Status"];
    [coder encodeObject:self.notifTitle forKey:@"NotifTitle"];
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        self.notfID = [coder decodeObjectForKey:@"NotfID"];
        self.fromUserUuid = [coder decodeObjectForKey:@"FromUserUuid"];
        self.type = [coder decodeIntForKey:@"Type"];
        self.content = [coder decodeObjectForKey:@"Content"];
        self.fromUserAvatar = [coder decodeObjectForKey:@"FromUserAvatar"];
        self.planGuid = [coder decodeObjectForKey:@"PlanGuid"];
        self.planType = [coder decodeObjectForKey:@"PlanType"];
        self.eventUrl = [coder decodeObjectForKey:@"EventUrl"];
        self.eventTitile = [coder decodeObjectForKey:@"EventTitile"];
        self.createdTime = [coder decodeObjectForKey:@"CreatedTime"];
        self.timestamp = [coder decodeObjectForKey:@"Timestamp"];
        self.status = [coder decodeIntForKey:@"Status"];
        self.notifTitle = [coder decodeObjectForKey:@"NotifTitle"];
    }
    return self;
}

@end
