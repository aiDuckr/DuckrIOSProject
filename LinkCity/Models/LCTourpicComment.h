//
//  LCTourpicComment.h
//  LinkCity
//
//  Created by 张宗硕 on 3/27/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DefaultTourpicCommentReplyToId -1

@interface LCTourpicComment : LCBaseModel

@property (assign, nonatomic) NSInteger commentId;
@property (retain, nonatomic) NSString *guid;
@property (retain, nonatomic) NSString *title;
@property (retain, nonatomic) NSString *content;
@property (assign, nonatomic) NSInteger replyToId;
@property (retain, nonatomic) NSString *createdTime;
@property (retain, nonatomic) LCUserModel *user;
@property (assign, nonatomic) NSInteger commentType;
@property (retain, nonatomic) NSString *replyContent;
@property (retain, nonatomic) NSString *replyToUserNick;

@end
