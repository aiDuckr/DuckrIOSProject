//
//  LCUMengHelper.m
//  LinkCity
//
//  Created by roy on 2/6/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCUMengHelper.h"

@implementation LCUMengHelper

#pragma mark - Public Interfaces
+ (instancetype)sharedInstance{
    static LCUMengHelper *umengHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        umengHelper = [[LCUMengHelper alloc] init];
    });
    return umengHelper;
}

- (void)setup {
    UMConfigInstance.appKey = UMENG_APP_KEY;
    UMConfigInstance.channelId = [[LCAppConfigManager sharedInstance] getChannel];
    [MobClick setAppVersion:APP_LOCAL_SHOT_VERSION_STRING];
    [MobClick startWithConfigure:UMConfigInstance];
    
    [UMSocialData setAppKey:UMENG_APP_KEY];
    [UMSocialWechatHandler setWXAppId:UMENG_WEIXIN_APP_ID appSecret:UMENG_WEIXIN_APP_SECRET url:@"http://www.umeng.com/social"];
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"4270549188"
                                              secret:@"5881fb57057afcf60aff8a81c624b9cd"
                                         RedirectURL:@"http://www.duckr.cn/weibo/auth/"];
    [UMSocialQQHandler setQQWithAppId:UMENG_QQ_APP_ID appKey:UMENG_QQ_APP_SECRET url:@"http://www.umeng.com/social"];
    [UMSocialConfig setFinishToastIsHidden:YES position:UMSocialiToastPositionCenter];
#if DEBUG
    [MobClick setCrashReportEnabled:NO];
#else
    [MobClick setCrashReportEnabled:YES];
#endif
    
    NSString * appKey = UMENG_APP_KEY;
    NSString * deviceName = [[[UIDevice currentDevice] name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * mac = [self macString];
    NSString * idfa = [self idfaString];
    NSString * idfv = [self idfvString];
    NSString * urlString = [NSString stringWithFormat:@"http://log.umtrack.com/ping/%@/?devicename=%@&mac=%@&idfa=%@&idfv=%@", appKey, deviceName, mac, idfa, idfv];
    [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL: [NSURL URLWithString:urlString]] delegate:nil];
}

#pragma mark - Inner Function
- (NSString * )macString{
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *macString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return macString;
}

- (NSString *)idfaString {
    
    NSBundle *adSupportBundle = [NSBundle bundleWithPath:@"/System/Library/Frameworks/AdSupport.framework"];
    [adSupportBundle load];
    
    if (adSupportBundle == nil) {
        return @"";
    }
    else{
        
        Class asIdentifierMClass = NSClassFromString(@"ASIdentifierManager");
        
        if(asIdentifierMClass == nil){
            return @"";
        }
        else{
            
            //for no arc
            //ASIdentifierManager *asIM = [[[asIdentifierMClass alloc] init] autorelease];
            //for arc
            ASIdentifierManager *asIM = [[asIdentifierMClass alloc] init];
            
            if (asIM == nil) {
                return @"";
            }
            else{
                
                if(asIM.advertisingTrackingEnabled){
                    return [asIM.advertisingIdentifier UUIDString];
                }
                else{
                    return [asIM.advertisingIdentifier UUIDString];
                }
            }
        }
    }
}

- (NSString *)idfvString
{
    if([[UIDevice currentDevice] respondsToSelector:@selector( identifierForVendor)]) {
        return [[UIDevice currentDevice].identifierForVendor UUIDString];
    }
    
    return @"";
}
@end
