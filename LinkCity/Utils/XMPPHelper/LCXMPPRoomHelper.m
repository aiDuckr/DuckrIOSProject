//
//  LCXMPPRoomHelper.m
//  LinkCity
//
//  Created by roy on 3/31/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCXMPPRoomHelper.h"

@implementation LCXMPPRoomHelper

+ (instancetype)sharedInstance{
    static LCXMPPRoomHelper *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LCXMPPRoomHelper alloc] init];
    });
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.onLineRoomDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)getAllRoomFromServerAndSetThemOnline{
//    if ([[LCDataManager sharedInstance] haveLogin]) {
//        [LCNetRequester getJoinedPlansOfUser:[LCDataManager sharedInstance].userInfo. orderString:<#(NSString *)#> callBack:<#^(NSArray *plans, NSString *orderStr, NSError *error)callBack#>]
//    }
}





@end
