//
//  LCChatGroupModel.m
//  LinkCity
//
//  Created by roy on 3/15/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCChatGroupModel.h"

@implementation LCChatGroupModel

- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super initWithDictionary:dic];
    if (self)
    {
        self.guid = [LCStringUtil getNotNullStr:[dic objectForKey:@"Guid"]];
        self.groupJid = [LCStringUtil getNotNullStr:[dic objectForKey:@"GroupJid"]];
        self.name = [LCStringUtil getNotNullStr:[dic objectForKey:@"Name"]];
        self.descriptionStr = [LCStringUtil getNotNullStr:[dic objectForKey:@"Description"]];
        self.coverUrl = [LCStringUtil getNotNullStr:[dic objectForKey:@"CoverUrl"]];
        self.coverThumbUrl = [LCStringUtil getNotNullStr:[dic objectForKey:@"CoverThumbUrl"]];
        self.longitude = [LCStringUtil getNotNullStr:[dic objectForKey:@"Longitude"]];
        self.latitude = [LCStringUtil getNotNullStr:[dic objectForKey:@"Latitude"]];
        self.isMember = [LCStringUtil idToNSInteger:[dic objectForKey:@"IsMember"]];
        self.isAlert = [LCStringUtil idToNSInteger:[dic objectForKey:@"IsAlert"]];
        self.maxScale = [LCStringUtil idToNSInteger:[dic objectForKey:@"MaxScale"]];
        self.userNum = [LCStringUtil idToNSInteger:[dic objectForKey:@"UserNum"]];
        self.distance = [LCStringUtil idToNSInteger:[dic objectForKey:@"Distance"]];
        
        NSMutableArray *memberArray = [[NSMutableArray alloc] init];
        for (NSDictionary *aMemberDic in [dic arrayForKey:@"MemberList"]){
            LCUserModel *aUser = [[LCUserModel alloc] initWithDictionary:aMemberDic];
            [memberArray addObject:aUser];
        }
        self.memberList = memberArray;
    }
    return self;
}

- (void)encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:self.guid forKey:@"Guid"];
    [coder encodeObject:self.groupJid forKey:@"GroupJid"];
    [coder encodeObject:self.name forKey:@"Name"];
    [coder encodeObject:self.descriptionStr forKey:@"Description"];
    [coder encodeObject:self.coverUrl forKey:@"CoverUrl"];
    [coder encodeObject:self.coverThumbUrl forKey:@"CoverThumbUrl"];
    [coder encodeObject:self.longitude forKey:@"Longitude"];
    [coder encodeObject:self.latitude forKey:@"Latitude"];
    [coder encodeInteger:self.isMember forKey:@"IsMember"];
    [coder encodeInteger:self.isAlert forKey:@"IsAlert"];
    [coder encodeInteger:self.maxScale forKey:@"MaxScale"];
    [coder encodeInteger:self.userNum forKey:@"UserNum"];
    [coder encodeInteger:self.distance forKey:@"Distance"];
    [coder encodeObject:self.memberList forKey:@"MemberList"];
    
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        self.guid = [coder decodeObjectForKey:@"Guid"];
        self.groupJid = [coder decodeObjectForKey:@"GroupJid"];
        self.name = [coder decodeObjectForKey:@"Name"];
        self.descriptionStr = [coder decodeObjectForKey:@"Description"];
        self.coverUrl = [coder decodeObjectForKey:@"CoverUrl"];
        self.coverThumbUrl = [coder decodeObjectForKey:@"CoverThumbUrl"];
        self.longitude = [coder decodeObjectForKey:@"Longitude"];
        self.latitude = [coder decodeObjectForKey:@"Latitude"];
        self.isMember = [coder decodeIntegerForKey:@"IsMember"];
        self.isAlert = [coder decodeIntegerForKey:@"IsAlert"];
        self.maxScale = [coder decodeIntegerForKey:@"MaxScale"];
        self.userNum = [coder decodeIntegerForKey:@"UserNum"];
        self.distance = [coder decodeIntegerForKey:@"Distance"];
        self.memberList = [coder decodeObjectForKey:@"MemberList"];
    }
    return self;
}

@end
