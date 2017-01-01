//
//  LCChatContactModel.m
//  LinkCity
//
//  Created by roy on 3/19/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCChatContactModel.h"

@implementation LCChatContactModel

- (NSDate *)lastUpdateContactInfoFromServerTime{
    if (!_lastUpdateContactInfoFromServerTime) {
        _lastUpdateContactInfoFromServerTime = [NSDate dateWithTimeIntervalSince1970:0];
    }
    return _lastUpdateContactInfoFromServerTime;
}

- (NSString *)getBareJidString{
    NSString *bareJidString = nil;
    switch (self.type) {
        case LCChatContactType_Default:
            break;
        case LCChatContactType_User:{
            if (self.chatWithUser) {
                bareJidString = self.chatWithUser.openfireAccount;
            }
        }
            break;
        case LCChatContactType_Plan:{
            if (self.chatWithPlan) {
                bareJidString = self.chatWithPlan.roomId;
            }
        }
            break;
        case LCChatContactType_Group:{
            if (self.chatWithGroup) {
                bareJidString = self.chatWithGroup.groupJid;
            }
        }
            break;
    }
    return bareJidString;
}

+ (instancetype)chatContactModelWithPlan:(LCPlanModel *)plan{
    LCChatContactModel *chatContactModel = [[LCChatContactModel alloc] init];
    chatContactModel.type = LCChatContactType_Plan;
    chatContactModel.unreadNum = 0;
    chatContactModel.lastUpdateContactInfoFromServerTime = [NSDate date];
    chatContactModel.chatWithPlan = plan;
    return chatContactModel;
}
+ (instancetype)chatContactModelWithUser:(LCUserModel *)user{
    LCChatContactModel *chatContactModel = [[LCChatContactModel alloc] init];
    chatContactModel.type = LCChatContactType_User;
    chatContactModel.unreadNum = 0;
    chatContactModel.lastUpdateContactInfoFromServerTime = [NSDate date];
    chatContactModel.chatWithUser = user;
    return chatContactModel;
}
+ (instancetype)chatContactModelWithGroup:(LCChatGroupModel *)group{
    LCChatContactModel *chatContactModel = [[LCChatContactModel alloc] init];
    chatContactModel.type = LCChatContactType_Group;
    chatContactModel.unreadNum = 0;
    chatContactModel.lastUpdateContactInfoFromServerTime = [NSDate date];
    chatContactModel.chatWithGroup = group;
    return chatContactModel;
}

- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super initWithDictionary:dic];
    if (self)
    {
        self.type = [LCStringUtil idToNSInteger:[dic objectForKey:@"Type"]];
        self.unreadNum = [LCStringUtil idToNSInteger:[dic objectForKey:@"UnreadNum"]];
        
        switch (self.type) {
            case LCChatContactType_Default:
                break;
            case LCChatContactType_User:{
                self.chatWithUser = [[LCUserModel alloc] initWithDictionary:[dic dicOfObjectForKey:@"ContactInfo"]];
            }
                break;
            case LCChatContactType_Plan:{
                self.chatWithPlan = [[LCPlanModel alloc] initWithDictionary:[dic dicOfObjectForKey:@"ContactInfo"]];
            }
                break;
            case LCChatContactType_Group:{
                self.chatWithGroup = [[LCChatGroupModel alloc] initWithDictionary:[dic dicOfObjectForKey:@"ContactInfo"]];
            }
                break;
        }
    }
    return self;
}

- (void)encodeWithCoder: (NSCoder *)coder
{
    [coder encodeInteger:self.type forKey:@"Type"];
    [coder encodeInteger:self.unreadNum forKey:@"UnreadNum"];
    [coder encodeObject:self.chatWithUser forKey:@"ChatWithUser"];
    [coder encodeObject:self.chatWithPlan forKey:@"ChatWithPlan"];
    [coder encodeObject:self.chatWithGroup forKey:@"ChatWithGroup"];
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        self.type = [coder decodeIntegerForKey:@"Type"];
        self.unreadNum = [coder decodeIntegerForKey:@"UnreadNum"];
        self.chatWithUser = [coder decodeObjectForKey:@"ChatWithUser"];
        self.chatWithPlan = [coder decodeObjectForKey:@"ChatWithPlan"];
        self.chatWithGroup = [coder decodeObjectForKey:@"ChatWithGroup"];
    }
    return self;
}


@end
