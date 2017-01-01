//
//  LCUserNotifyModel.m
//  LinkCity
//
//  Created by roy on 3/26/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCUserNotifyModel.h"

@implementation LCUserNotifyModel

- (NSDictionary *)getNetRequestDic {
    return @{@"NotifPlanComment":[LCStringUtil integerToString:self.notifPlanComment],
//             @"NotifPlanApply":[LCStringUtil integerToString:self.notifPlanApply],
             @"NotifTourpicLike":[LCStringUtil integerToString:self.notifTourpicLike],
             @"NotifTourPicComment":[LCStringUtil integerToString:self.notifTourPicComment],
             
//             @"NotifCloseTestQuestion":[LCStringUtil integerToString:self.notifCloseTestQuestion],
//             @"NotifCloseTestAnswer":[LCStringUtil integerToString:self.notifCloseTestAnswer],
//             @"NotifUserEvaluation":[LCStringUtil integerToString:self.notifUserEvaluation],
             @"NotifUserIdentity":[LCStringUtil integerToString:self.notifUserIdentity],
//             @"NotifTourWallReply":[LCStringUtil integerToString:self.notifTourWallReply]
             };
}


- (id)initWithDictionary:(NSDictionary *)dic {
    self = [super initWithDictionary:dic];
    if (self) {
        self.notifPlanComment = [LCStringUtil idToNSInteger:[dic objectForKey:@"NotifPlanComment"]];
//        self.notifPlanApply = [LCStringUtil idToNSInteger:[dic objectForKey:@"NotifPlanApply"]];
        self.notifTourpicLike = [LCStringUtil idToNSInteger:[dic objectForKey:@"NotifTourpicLike"]];
        self.notifTourPicComment = [LCStringUtil idToNSInteger:[dic objectForKey:@"NotifTourPicComment"]];
        
//        self.notifCloseTestQuestion = [LCStringUtil idToNSInteger:[dic objectForKey:@"NotifCloseTestQuestion"]];
//        self.notifCloseTestAnswer = [LCStringUtil idToNSInteger:[dic objectForKey:@"NotifCloseTestAnswer"]];
        
//        self.notifUserEvaluation = [LCStringUtil idToNSInteger:[dic objectForKey:@"NotifUserEvaluation"]];
        self.notifUserIdentity = [LCStringUtil idToNSInteger:[dic objectForKey:@"NotifUserIdentity"]];
        
//        self.notifTourWallReply = [LCStringUtil idToNSInteger:[dic objectForKey:@"NotifTourWallReply"]];
    }
    return self;
}

- (void)encodeWithCoder: (NSCoder *)coder {
    [coder encodeInteger:self.notifPlanComment forKey:@"NotifPlanComment"];
//    [coder encodeInteger:self.notifPlanApply forKey:@"NotifPlanApply"];
    [coder encodeInteger:self.notifTourpicLike forKey:@"NotifTourpicLike"];
    [coder encodeInteger:self.notifTourPicComment forKey:@"NotifTourPicComment"];
    
//    [coder encodeInteger:self.notifCloseTestQuestion forKey:@"NotifCloseTestQuestion"];
//    [coder encodeInteger:self.notifCloseTestAnswer forKey:@"NotifCloseTestAnswer"];
    
//    [coder encodeInteger:self.notifUserEvaluation forKey:@"NotifUserEvaluation"];
    [coder encodeInteger:self.notifUserIdentity forKey:@"NotifUserIdentity"];
    
//    [coder encodeInteger:self.notifTourWallReply forKey:@"NotifTourWallReply"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.notifPlanComment = [coder decodeIntegerForKey:@"NotifPlanComment"];
//        self.notifPlanApply = [coder decodeIntegerForKey:@"NotifPlanApply"];
        self.notifTourpicLike = [coder decodeIntegerForKey:@"NotifTourpicLike"];
        self.notifTourPicComment = [coder decodeIntegerForKey:@"NotifTourPicComment"];
        
//        self.notifCloseTestQuestion = [coder decodeIntegerForKey:@"NotifCloseTestQuestion"];
//        self.notifCloseTestAnswer = [coder decodeIntegerForKey:@"NotifCloseTestAnswer"];
        
//        self.notifUserEvaluation = [coder decodeIntegerForKey:@"NotifUserEvaluation"];
        self.notifUserIdentity = [coder decodeIntegerForKey:@"NotifUserIdentity"];
        
//        self.notifTourWallReply = [coder decodeIntegerForKey:@"NotifTourWallReply"];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@",[self getNetRequestDic]];
}

@end



