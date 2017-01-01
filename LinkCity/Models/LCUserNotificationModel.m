//
//  LCUserNotificationModel.m
//  LinkCity
//
//  Created by roy on 3/29/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCUserNotificationModel.h"

@implementation LCUserNotificationModel


- (NSString *)getTourWallGuid{
    return [self.notifyInfo objectForKey:@"TourWallGuid"];
}



#pragma mark base
- (id)initWithDictionary:(NSDictionary *)dic {
    self = [super initWithDictionary:dic];
    if (self) {
        self.userName = [LCStringUtil getNotNullStr:[dic objectForKey:@"UserName"]];
        self.avatarUrl = [LCStringUtil getNotNullStr:[dic objectForKey:@"AvatarUrl"]];
        self.content = [LCStringUtil getNotNullStr:[dic objectForKey:@"Content"]];
        self.picUrl = [LCStringUtil getNotNullStr:[dic objectForKey:@"PicUrl"]];
        
        self.guid = [LCStringUtil getNotNullStr:[dic objectForKey:@"Guid"]];
        self.userUUID = [LCStringUtil getNotNullStr:[dic objectForKey:@"UserUUID"]];
        self.closeTestId = [LCStringUtil getNotNullStr:[dic objectForKey:@"CloseTestId"]];
        self.eventUrl = [LCStringUtil getNotNullStr:[dic objectForKey:@"EventUrl"]];
        
        self.type = [LCStringUtil idToNSInteger:[dic objectForKey:@"Type"]];
        self.createdTime = [LCStringUtil getNotNullStr:[dic objectForKey:@"CreatedTime"]];
        
        self.notifyInfo = [dic objectForKey:@"NotifyInfo"];
    }
    return self;
}

- (void)encodeWithCoder: (NSCoder *)coder {
    [coder encodeObject:self.userName forKey:@"UserName"];
    [coder encodeObject:self.avatarUrl forKey:@"AvatarUrl"];
    [coder encodeObject:self.content forKey:@"Content"];
    [coder encodeObject:self.picUrl forKey:@"PicUrl"];
    
    [coder encodeObject:self.guid forKey:@"Guid"];
    [coder encodeObject:self.userUUID forKey:@"UserUUID"];
    [coder encodeObject:self.closeTestId forKey:@"CloseTestId"];
    [coder encodeObject:self.eventUrl forKey:@"EventUrl"];
    
    [coder encodeInteger:self.type forKey:@"Type"];
    [coder encodeObject:self.createdTime forKey:@"CreatedTime"];
    
    [coder encodeObject:self.notifyInfo forKey:@"NotifyInfo"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.userName = [coder decodeObjectForKey:@"UserName"];
        self.avatarUrl = [coder decodeObjectForKey:@"AvatarUrl"];
        self.content = [coder decodeObjectForKey:@"Content"];
        self.picUrl = [coder decodeObjectForKey:@"PicUrl"];
        
        self.guid = [coder decodeObjectForKey:@"Guid"];
        self.userUUID = [coder decodeObjectForKey:@"UserUUID"];
        self.closeTestId = [coder decodeObjectForKey:@"CloseTestId"];
        self.eventUrl = [coder decodeObjectForKey:@"EventUrl"];
        
        self.type = [coder decodeIntegerForKey:@"Type"];
        self.createdTime = [coder decodeObjectForKey:@"CreatedTime"];
        
        self.notifyInfo = [coder decodeObjectForKey:@"NotifyInfo"];
    }
    return self;
}
@end

