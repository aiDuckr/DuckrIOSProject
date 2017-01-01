//
//  LCUserEvaluationModel.h
//  LinkCity
//
//  Created by roy on 3/3/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCBaseModel.h"

@interface LCUserEvaluationModel : LCBaseModel
@property (nonatomic, assign) NSInteger evaluationId;
@property (nonatomic, strong) NSString *evaluationUuid;
@property (nonatomic, strong) NSString *avatarUrl;
@property (nonatomic, strong) NSString *nick;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) float score;
@property (nonatomic, strong) NSArray *tags;    //array of nsstring,   server return a json array for this
@property (nonatomic, assign) NSInteger type;   //1:real   2:anonymous
@property (nonatomic, strong) NSString *createdTime;
@property (nonatomic, strong) NSString *updatedTime;

+ (BOOL)isAnonymousOfType:(NSInteger)type;
+ (NSInteger)getTypeForAnonymous:(BOOL)isAnonymous;
@end
