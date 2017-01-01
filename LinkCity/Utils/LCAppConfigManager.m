//
//  LCAppConfigManager.m
//  LinkCity
//
//  Created by roy on 6/6/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCAppConfigManager.h"

@implementation LCAppConfigManager


+ (instancetype)sharedInstance{
    static LCAppConfigManager *staticInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticInstance = [[LCAppConfigManager alloc] init];
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"];
        NSDictionary *appConfigDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        staticInstance.appConfigDic = appConfigDic;
    });
    
    return staticInstance;
}


- (NSString *)getChannel{
    NSNumber *currentChannel = [self.appConfigDic objectForKey:@"currentChannel"];
    NSArray *channels = [self.appConfigDic objectForKey:@"channels"];
    
    NSString *currentChannelStr = @"";
    
    if (channels.count > [currentChannel integerValue]) {
        currentChannelStr = [channels objectAtIndex:[currentChannel integerValue]];
    }
    
    return currentChannelStr;
}

@end
