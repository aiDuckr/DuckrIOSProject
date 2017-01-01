//
//  LCChatGroupModel.h
//  LinkCity
//
//  Created by roy on 3/15/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCBaseModel.h"

@interface LCChatGroupModel : LCBaseModel
@property (nonatomic, strong) NSString *guid;
@property (nonatomic, strong) NSString *groupJid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *descriptionStr;
@property (nonatomic, strong) NSString *coverUrl;
@property (nonatomic, strong) NSString *coverThumbUrl;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, assign) NSInteger isMember;
@property (nonatomic, assign) NSInteger isAlert;
@property (nonatomic, assign) NSInteger maxScale;
@property (nonatomic, assign) NSInteger userNum;
@property (nonatomic, assign) NSInteger distance;   // when <0, treat as no distance info
@property (nonatomic, strong) NSArray *memberList;
@end
