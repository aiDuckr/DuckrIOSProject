//
//  LCChatContactModel.h
//  LinkCity
//
//  Created by roy on 3/19/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCBaseModel.h"
#import "LCPlanModel.h"
#import "LCUserModel.h"
#import "LCChatGroupModel.h"


//聊天会话列表
@interface LCChatContactModel : LCBaseModel
@property (nonatomic, assign) NSInteger type;       
@property (nonatomic, assign) NSInteger unreadNum;  //废掉不用了

@property (nonatomic, strong) NSDate *lastUpdateContactInfoFromServerTime;
@property (nonatomic, strong) LCUserModel *chatWithUser;
@property (nonatomic, strong) LCPlanModel *chatWithPlan;
@property (nonatomic, strong) LCChatGroupModel *chatWithGroup;

- (NSString *)getBareJidString;
+ (instancetype)chatContactModelWithPlan:(LCPlanModel *)plan;
+ (instancetype)chatContactModelWithUser:(LCUserModel *)user;
+ (instancetype)chatContactModelWithGroup:(LCChatGroupModel *)group;

@end
