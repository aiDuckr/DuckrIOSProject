//
//  LCAppConfigManager.h
//  LinkCity
//
//  Created by roy on 6/6/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCAppConfigManager : NSObject
@property (nonatomic, strong) NSDictionary *appConfigDic;

+ (instancetype)sharedInstance;

- (NSString *)getChannel;

@end
