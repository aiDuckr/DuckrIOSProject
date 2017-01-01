//
//  LCCloseReplyTestModel.m
//  LinkCity
//
//  Created by roy on 3/23/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCCloseReplyTestModel.h"

@implementation LCCloseReplyTestModel


- (LCUserRelation)getUserRelation{
    if (self.relation == 1) {
        return LCUserRelation_AddressBookFriend;
    }else if(self.relation == 2) {
        return LCUserRelation_TravelFriend;
    }
    
    //默认通讯录好友
    return LCUserRelation_AddressBookFriend;
}

#pragma mark
- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super initWithDictionary:dic];
    if (self)
    {
        self.crtId = [LCStringUtil idToNSInteger:[dic objectForKey:@"CrtId"]];
        self.replyUserNick = [LCStringUtil getNotNullStr:[dic objectForKey:@"ReplyUserNick"]];
        self.relation = [LCStringUtil idToNSInteger:[dic objectForKey:@"Relation"]];
        self.content = [LCStringUtil getNotNullStr:[dic objectForKey:@"Content"]];
        
        NSNumber *reliableNum = [dic objectForKey:@"Reliable"];
        self.reliable = [reliableNum floatValue];
        
        NSNumber *charmNum = [dic objectForKey:@"Charm"];
        self.charm = [charmNum floatValue];
        
        NSNumber *experienceNum = [dic objectForKey:@"Experience"];
        self.experience = [experienceNum floatValue];
        
        self.updatedTime = [LCStringUtil getNotNullStr:[dic objectForKey:@"UpdatedTime"]];
    }
    return self;
}

- (void)encodeWithCoder: (NSCoder *)coder
{
    [coder encodeInteger:self.crtId forKey:@"CrtId"];
    [coder encodeObject:self.replyUserNick forKey:@"ReplyUserNick"];
    [coder encodeInteger:self.relation forKey:@"Relation"];
    [coder encodeObject:self.content forKey:@"Content"];
    [coder encodeFloat:self.reliable forKey:@"Reliable"];
    [coder encodeFloat:self.charm forKey:@"Charm"];
    [coder encodeFloat:self.experience forKey:@"Experience"];
    [coder encodeObject:self.updatedTime forKey:@"UpdatedTime"];
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        self.crtId = [coder decodeIntegerForKey:@"CrtId"];
        self.replyUserNick = [coder decodeObjectForKey:@"ReplyUserNick"];
        self.relation = [coder decodeIntegerForKey:@"Relation"];
        self.content = [coder decodeObjectForKey:@"Content"];
        self.reliable = [coder decodeFloatForKey:@"Reliable"];
        self.charm = [coder decodeFloatForKey:@"Charm"];
        self.experience = [coder decodeFloatForKey:@"Experience"];
        self.updatedTime = [coder decodeObjectForKey:@"UpdatedTime"];
    }
    return self;
}
@end

