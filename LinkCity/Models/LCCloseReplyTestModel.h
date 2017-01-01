//
//  LCCloseReplyTestModel.h
//  LinkCity
//
//  Created by roy on 3/23/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCBaseModel.h"

@interface LCCloseReplyTestModel : LCBaseModel
@property (nonatomic, assign) NSInteger crtId;
@property (nonatomic, strong) NSString *replyUserNick;
@property (nonatomic, assign) NSInteger relation;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) float reliable;
@property (nonatomic, assign) float charm;
@property (nonatomic, assign) float experience;
@property (nonatomic, strong) NSString *updatedTime;

- (LCUserRelation)getUserRelation;

@end


