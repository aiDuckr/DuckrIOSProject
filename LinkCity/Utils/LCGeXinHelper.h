//
//  LCGeXinHelper.h
//  LinkCity
//
//  Created by roy on 2/8/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GexinSdk.h"


#define kAppId           @"YBq32rTNEy7aRaOn3TPi41"
#define kAppKey          @"3VwKJ0X4JAA5TODZKpQgR7"
#define kAppSecret       @"JaAxb41SEM7k74h9JrYUn3"

@interface LCGeXinHelper : NSObject<GexinSdkDelegate>
@property (strong, nonatomic) GexinSdk *gexinPusher;

@property (retain, nonatomic) NSString *appKey;
@property (retain, nonatomic) NSString *appSecret;
@property (retain, nonatomic) NSString *appID;
@property (retain, nonatomic) NSString *clientId;

@property (assign, nonatomic) int lastPayloadIndex;

+ (instancetype)sharedInstance;
- (void)startSdk;
- (void)stopSdk;
- (void)registerDeviceToken:(NSString *)deviceToken;


- (NSString *)sendMessage:(NSData *)body error:(NSError **)error;

@end

