//
//  LCCommentModel.m
//  LinkCity
//
//  Created by roy on 11/17/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCCommentModel.h"

@implementation LCCommentModel



- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super initWithDictionary:dic];
    if (self)
    {
        self.commentId = [LCStringUtil getNotNullStr:[dic objectForKey:@"CommentId"]];
        self.planGuid = [LCStringUtil getNotNullStr:[dic objectForKey:@"PlanGuid"]];
        self.user = [[LCUserModel alloc]initWithDictionary:[dic objectForKey:@"User"]];
        self.title = [LCStringUtil getNotNullStr:[dic objectForKey:@"Title"]];
        if ([dic objectForKey:@"Score"]) {
            self.score = [[dic objectForKey:@"Score"] integerValue];
        }
        self.content = [LCStringUtil getNotNullStr:[dic objectForKey:@"Content"]];
        self.replyToId = [LCStringUtil getNotNullStr:[dic objectForKey:@"ReplyToId"]];
        self.createdTime = [LCStringUtil getNotNullStr:[dic objectForKey:@"CreatedTime"]];
        self.orderStr = [LCStringUtil getNotNullStr:[dic objectForKey:@"OrderStr"]];
        
        self.commentType = [LCStringUtil idToNSInteger:[dic objectForKey:@"CommentType"]];
        self.replyContent = [LCStringUtil getNotNullStr:[dic objectForKey:@"ReplyContent"]];
        self.replyToUserNick = [LCStringUtil getNotNullStr:[dic objectForKey:@"ReplyToUserNick"]];
    }
    return self;
}

- (void)encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:self.commentId forKey:@"CommentId"];
    [coder encodeObject:self.planGuid forKey:@"PlanGuid"];
    [coder encodeObject:self.user forKey:@"User"];
    [coder encodeObject:self.title forKey:@"Title"];
    [coder encodeObject:self.content forKey:@"Content"];
    [coder encodeObject:self.replyToId forKey:@"ReplyToId"];
    [coder encodeObject:self.createdTime forKey:@"CreatedTime"];
    [coder encodeObject:self.orderStr forKey:@"OrderStr"];
    [coder encodeInteger:self.score forKey:@"Score"];
    
    [coder encodeInteger:self.commentType forKey:@"CommentType"];
    [coder encodeObject:self.replyContent forKey:@"ReplyContent"];
    [coder encodeObject:self.replyToUserNick forKey:@"ReplyToUserNick"];
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        self.commentId = [coder decodeObjectForKey:@"CommentId"];
        self.planGuid = [coder decodeObjectForKey:@"PlanGuid"];
        self.user = [coder decodeObjectForKey:@"User"];
        self.title = [coder decodeObjectForKey:@"Title"];
        self.content = [coder decodeObjectForKey:@"Content"];
        self.replyToId = [coder decodeObjectForKey:@"ReplyToId"];
        self.createdTime = [coder decodeObjectForKey:@"CreatedTime"];
        self.orderStr = [coder decodeObjectForKey:@"OrderStr"];
        self.score = [coder decodeIntegerForKey:@"Score"];
        
        self.commentType = [coder decodeIntegerForKey:@"CommontType"];
        self.replyContent = [coder decodeObjectForKey:@"ReplyContent"];
        self.replyToUserNick = [coder decodeObjectForKey:@"ReplyToUserNick"];
    }
    return self;
}
@end
