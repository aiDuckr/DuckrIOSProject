//
//  LCUserNotifyModel.h
//  LinkCity
//
//  Created by roy on 3/26/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

/*
 用于用户推送通知设置的Model
 */

#import "LCBaseModel.h"

@interface LCUserNotifyModel : LCBaseModel
@property (nonatomic, assign) NSInteger notifPlanComment;
//@property (nonatomic, assign) NSInteger notifPlanApply;
@property (nonatomic, assign) NSInteger notifTourpicLike;
@property (nonatomic, assign) NSInteger notifTourPicComment;

//@property (nonatomic, assign) NSInteger notifCloseTestQuestion;
//@property (nonatomic, assign) NSInteger notifCloseTestAnswer;

//@property (nonatomic, assign) NSInteger notifUserEvaluation;
@property (nonatomic, assign) NSInteger notifUserIdentity;

//@property (nonatomic, assign) NSInteger notifTourWallReply;

- (NSDictionary *)getNetRequestDic;

@end


