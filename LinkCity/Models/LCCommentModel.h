//
//  LCCommentModel.h
//  LinkCity
//
//  Created by roy on 11/17/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCStringUtil.h"
#import "LCUserModel.h"
#import "LCBaseModel.h"

#define DefaultCommentReplyToId -1
#define DefaultPlanCommentScore 0
#define PlanCommentTypePlan @"1"
#define PlanCommentTypeEvalPlan @"10"

@interface LCCommentModel : LCBaseModel
- (id)initWithDictionary:(NSDictionary *)dic;
- (void)encodeWithCoder:(NSCoder *)coder;
- (id)initWithCoder:(NSCoder *)coder;

@property (nonatomic, retain) NSString *commentId;//评论的ID
@property (nonatomic, retain) NSString *planGuid;
@property (nonatomic, retain) LCUserModel *user;//创建者
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *content;//评论内容
@property (nonatomic, retain) NSString *replyToId;//回复的上一条ID。默认值为-1
@property (nonatomic, retain) NSString *createdTime;//评论的时间
@property (nonatomic, retain) NSString *orderStr;
@property (nonatomic, assign) NSInteger score;
@property (assign, nonatomic) NSInteger commentType;
@property (retain, nonatomic) NSString *replyContent;
@property (retain, nonatomic) NSString *replyToUserNick;
@end
