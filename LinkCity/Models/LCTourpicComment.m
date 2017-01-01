//
//  LCTourpicComment.m
//  LinkCity
//
//  Created by 张宗硕 on 3/27/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCTourpicComment.h"

@implementation LCTourpicComment

- (id)initWithDictionary:(NSDictionary *)dic {
    self = [super initWithDictionary:dic];
    if (self) {
        self.commentId = [LCStringUtil idToNSInteger:[dic objectForKey:@"CommentId"]];
        self.guid = [LCStringUtil getNotNullStr:[dic objectForKey:@"Guid"]];
        self.title = [LCStringUtil getNotNullStr:[dic objectForKey:@"Title"]];
        self.content = [LCStringUtil getNotNullStr:[dic objectForKey:@"Content"]];
        self.replyToId = [LCStringUtil idToNSInteger:[dic objectForKey:@"ReplyToId"]];
        self.createdTime = [LCStringUtil getNotNullStr:[dic objectForKey:@"CreatedTime"]];
        self.commentType = [LCStringUtil idToNSInteger:[dic objectForKey:@"CommentType"]];
        self.replyContent = [LCStringUtil getNotNullStr:[dic objectForKey:@"ReplyContent"]];
        self.replyToUserNick = [LCStringUtil getNotNullStr:[dic objectForKey:@"ReplyToUserNick"]];
        NSDictionary *userDic = [dic objectForKey:@"User"];
        if (nil != dic) {
            self.user = [[LCUserModel alloc] initWithDictionary:userDic];
        }
    }
    return self;
}

- (void)encodeWithCoder: (NSCoder *)coder {
    [coder encodeInteger:self.commentId forKey:@"CommentId"];
    [coder encodeObject:self.guid forKey:@"Guid"];
    [coder encodeObject:self.title forKey:@"Title"];
    [coder encodeObject:self.content forKey:@"Content"];
    [coder encodeInteger:self.replyToId forKey:@"ReplyToId"];
    [coder encodeObject:self.createdTime forKey:@"CreatedTime"];
    [coder encodeInteger:self.commentType forKey:@"CommentType"];
    [coder encodeObject:self.replyContent forKey:@"ReplyContent"];
    [coder encodeObject:self.replyToUserNick forKey:@"ReplyToUserNick"];
    if (nil != self.user) {
        [coder encodeObject:self.user forKey:@"User"];
    }
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.commentId = [coder decodeIntegerForKey:@"CommentId"];
        self.guid = [coder decodeObjectForKey:@"Guid"];
        self.title = [coder decodeObjectForKey:@"Title"];
        self.content = [coder decodeObjectForKey:@"Content"];
        self.replyToId = [coder decodeIntegerForKey:@"ReplyToId"];
        self.createdTime = [coder decodeObjectForKey:@"CreatedTime"];
        self.commentType = [coder decodeIntegerForKey:@"CommontType"];
        self.replyContent = [coder decodeObjectForKey:@"ReplyContent"];
        self.replyToUserNick = [coder decodeObjectForKey:@"ReplyToUserNick"];
    }
    return self;
}

@end
