//
//  LCUserEvaluationModel.m
//  LinkCity
//
//  Created by roy on 3/3/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCUserEvaluationModel.h"

@implementation LCUserEvaluationModel

#pragma mark Public Interface
+ (BOOL)isAnonymousOfType:(NSInteger)type{
    BOOL ret = NO;
    
    if(type == 2){
        ret = YES;
    }
    
    return ret;
}
+ (NSInteger)getTypeForAnonymous:(BOOL)isAnonymous{
    NSInteger type = 0;
    
    if (isAnonymous) {
        type = 2;
    }else{
        type = 1;
    }
    
    return type;
}


- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super initWithDictionary:dic];
    if (self)
    {
        NSNumber *evaluationIdNum = [dic objectForKey:@"EvaluationId"];
        self.evaluationId = [evaluationIdNum integerValue];
        self.evaluationUuid = [dic objectForKey:@"EvaluationUuid"];
        self.avatarUrl = [LCStringUtil getNotNullStr:[dic objectForKey:@"AvatarUrl"]];
        self.nick = [LCStringUtil getNotNullStr:[dic objectForKey:@"Nick"]];
        self.content = [LCStringUtil getNotNullStr:[dic objectForKey:@"Content"]];
        NSNumber *scoreNum = [dic objectForKey:@"Score"];
        self.score = [scoreNum floatValue];
        
        self.tags = [dic arrayForKey:@"Tags"]; //NSArray
        
        NSNumber *typeNum = [dic objectForKey:@"Type"];
        self.type = [typeNum integerValue];
        self.createdTime = [LCStringUtil getNotNullStr:[dic objectForKey:@"CreatedTime"]];
        self.updatedTime = [LCStringUtil getNotNullStr:[dic objectForKey:@"UpdatedTime"]];
        
    }
    return self;
}

- (void)encodeWithCoder: (NSCoder *)coder
{
    [coder encodeInteger:self.evaluationId forKey:@"EvaluationId"];
    [coder encodeObject:self.evaluationUuid forKey:@"EvaluationUuid"];
    [coder encodeObject:self.avatarUrl forKey:@"AvatarUrl"];
    [coder encodeObject:self.nick forKey:@"Nick"];
    [coder encodeObject:self.content forKey:@"Content"];
    [coder encodeFloat:self.score forKey:@"Score"];
    [coder encodeObject:self.tags forKey:@"Tags"];
    [coder encodeInteger:self.type forKey:@"Type"];
    [coder encodeObject:self.createdTime forKey:@"CreatedTime"];
    [coder encodeObject:self.updatedTime forKey:@"UpdatedTime"];
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        self.evaluationId = [coder decodeIntegerForKey:@"EvaluationId"];
        self.evaluationUuid = [coder decodeObjectForKey:@"EvaluationUuid"];
        self.avatarUrl = [coder decodeObjectForKey:@"AvatarUrl"];
        self.nick = [coder decodeObjectForKey:@"Nick"];
        self.content = [coder decodeObjectForKey:@"Content"];
        self.score = [coder decodeFloatForKey:@"Score"];
        self.tags = [coder decodeObjectForKey:@"Tags"];
        self.type = [coder decodeIntegerForKey:@"Type"];
        self.createdTime = [coder decodeObjectForKey:@"CreatedTime"];
        self.updatedTime = [coder decodeObjectForKey:@"UpdatedTime"];
    }
    return self;
}
@end

