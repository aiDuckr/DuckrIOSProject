//
//  LCRedDotHelper.m
//  LinkCity
//
//  Created by roy on 3/27/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCRedDotHelper.h"

@implementation LCRedDotHelper

+ (instancetype)sharedInstance{
    static LCRedDotHelper *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LCRedDotHelper alloc] init];
    });
    
    return instance;
}

- (void)startUpdateRedDot{
    [self stopUpdateRedDot];
    [self automaticallyUpateRedDot];
}
- (void)stopUpdateRedDot{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(automaticallyUpateRedDot) object:nil];
}


- (void)automaticallyUpateRedDot{
    
    [LCNetRequester  getUserRedDot_V_FIVE:^(LCRedDotModel *redDot, NSError *error) {
        if (error) {
            LCLogWarn(@"getRedDotNumWithCallBack %@",error);
        }else{
            [LCDataManager sharedInstance].redDot = redDot;
        }
    }];
    
    [self performSelector:@selector(automaticallyUpateRedDot) withObject:nil afterDelay:AutoRefreshRedDotTimeInterval];
}

@end
