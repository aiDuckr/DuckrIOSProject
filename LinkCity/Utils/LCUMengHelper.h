//
//  LCUMengHelper.h
//  LinkCity
//
//  Created by roy on 2/6/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialQQHandler.h"
#import "UMMobClick/MobClick.h"

//for mac
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

//for idfa
#import <AdSupport/AdSupport.h>

@interface LCUMengHelper : NSObject
+ (instancetype)sharedInstance;
- (void)setup;
@end
