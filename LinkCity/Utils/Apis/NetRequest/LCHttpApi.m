//
//  YSHttpApi.m
//  YSAFNetworking
//
//  Created by zzs on 14-7-21.
//  Copyright (c) 2014年 yunshuo. All rights reserved.
//

#import "LCHttpApi.h"
#import "NSString+Additions.h"

@interface LCHttpApi()
@property (nonatomic, strong) requestCallBack callBack;
@end
@implementation LCHttpApi

- (id)init {
    self = [super init];
    if (self) {
        [self setCidCookieAndUserAgent];
    }
    return self;
}

- (void)setCidCookieAndUserAgent {
    manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"filename" ofType:@"der"];
//    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
//    [securityPolicy setAllowInvalidCertificates:NO];
//    [securityPolicy setValidatesCertificateChain:NO];
//    [securityPolicy setPinnedCertificates:@[certData]];
    [securityPolicy setValidatesDomainName:NO];
    [securityPolicy setAllowInvalidCertificates:YES];
//    [securityPolicy setValidatesCertificateChain:NO];
    manager.securityPolicy = securityPolicy; // SSL
    
    NSString *deviceType = @"0";
    NSString *cookieStr = [NSString stringWithFormat:@"DeviceType=%@;AppVer=%@", deviceType, APP_LOCAL_SHOT_VERSION_STRING];
    
    NSString *deviceUuid = [LCStringUtil getNotNullStr:[LCDataManager sharedInstance].deviceUUID];
    NSString *cidStr = @"";
    NSString *uuidStr = @"";
    
    if ([LCDataManager sharedInstance].userInfo) {
        LCUserModel *loginUser = [LCDataManager sharedInstance].userInfo;
        if ([LCStringUtil isNotNullString:loginUser.cID]) {
            cidStr = loginUser.cID;
        }
        if ([LCStringUtil isNotNullString:loginUser.uUID]) {
            uuidStr = loginUser.uUID;
        }
    }
    cookieStr = [cookieStr stringByAppendingFormat:@";CID=%@", cidStr];
    cookieStr = [cookieStr stringByAppendingFormat:@";UUID=%@", uuidStr];
    cookieStr = [cookieStr stringByAppendingFormat:@";DeviceUUID=%@",deviceUuid];
    
    NSString *tokenStr = [[LCDateUtil getUnixTimeStamp] md5];
    NSString *vUIDStr = [[NSString stringWithFormat:@"duckr_win%@%@", tokenStr, cidStr] md5];
    cookieStr = [cookieStr stringByAppendingFormat:@";Token=%@;VUID=%@", tokenStr, vUIDStr];
    
    NSString *idfaStr = [LCStringUtil getNotNullStr:[LCSharedFuncUtil getIdfa]];
    cookieStr = [cookieStr stringByAppendingFormat:@";IDFA=%@", idfaStr];
    
    NSString *cityId = @"";
    if (nil != [LCDataManager sharedInstance].currentCity) {
        cityId = [LCStringUtil getNotNullStr:[LCDataManager sharedInstance].currentCity.cityId];
    }
    cookieStr = [cookieStr stringByAppendingFormat:@";CityId=%@", cityId];
    //cookieStr拼接完成
    [requestSerializer setValue:cookieStr forHTTPHeaderField:@"cookie"];
    
    LCNetLogInfo(@"HttpCookie:%@", cookieStr);
    
    NSString *userAgentStr = [requestSerializer valueForHTTPHeaderField:UserAgentKey];
    NSString *channel = [[LCAppConfigManager sharedInstance] getChannel];
    NSString *deviceName = [LCSharedFuncUtil getDevicePlatform];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersionStr = [infoDictionary objectForKey:@"CFBundleVersion"];
    UIViewController *controller = [LCSharedFuncUtil getTopMostViewController];
    NSString *controllerName = NSStringFromClass([controller class]);
    controllerName = [LCStringUtil getNotNullStr:controllerName];
    NSString *lng = [NSString stringWithFormat:@"%f", [LCDataManager sharedInstance].userLocation.lng];
    lng = [LCStringUtil getNotNullStr:lng];
    NSString *lat = [NSString stringWithFormat:@"%f", [LCDataManager sharedInstance].userLocation.lat];
    lat = [LCStringUtil getNotNullStr:lat];
    
    userAgentStr = [NSString stringWithFormat:@"%@;%@;%@;%@;%@;%@;%@;%@", userAgentStr, channel, deviceName, appVersionStr, deviceUuid, controllerName, lng, lat];
    [requestSerializer setValue:userAgentStr forHTTPHeaderField:UserAgentKey];
    
    manager.requestSerializer = requestSerializer;
    [manager.reachabilityManager startMonitoring];
}

- (NSString*)addQueryStringToUrlString:(NSString *)urlString withDictionary:(NSDictionary *)dictionary {
    NSMutableString *urlWithQuerystring = [[NSMutableString alloc] initWithString:urlString];
    NSInteger index = 0;
    for (NSString *keyString in dictionary) {
        NSString *valueString = [dictionary objectForKey:keyString];
        if (0 == index) {
            [urlWithQuerystring appendFormat:@"%@", [self urlEncode:valueString]];
        } else {
            [urlWithQuerystring appendFormat:@"/%@", [self urlEncode:valueString]];
        }
        index++;
    }
    return urlWithQuerystring;
}

- (NSString*)urlEncode:(id)object {
    NSString *string = [NSString stringWithFormat: @"%@", object];
    return [string stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
}

- (void)doGet:(NSString*)urlStr withParams:(NSDictionary*)params withTag:(NSInteger)tag {
    self.tag = tag;
    NSString *serverUrl = server_url([LCConstants serverUrlPrefix], urlStr);
    serverUrl = [self addQueryStringToUrlString:serverUrl withDictionary:params];
    [manager GET:serverUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        LCNetLogInfo(@"JSON: %@", responseObject);
        [self parseResponseObject:responseObject];
        [self requestFinished];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LCNetLogWarn(@"Error: %@", error);
        [self requestFailed];
    }];
}

- (void)doPost:(NSString*)urlStr withParams:(NSDictionary*)params withTag:(NSInteger)tag {
    self.tag = tag;
    NSString *serverUrl = server_url([LCConstants serverUrlPrefix], urlStr);
    LCNetLogInfo(@"the server url is %@ params is %@", serverUrl, params);
    [manager POST:serverUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self parseResponseObject:responseObject];
        [self requestFinished];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LCNetLogWarn(@"Error: %@", error);
        [self requestFailed];
    }];
}

- (void)doGet:(NSString *)urlStr withParams:(NSDictionary *)params requestCallBack:(requestCallBack)callback{
    self.callBack = callback;
    NSString *serverUrl = server_url([LCConstants serverUrlPrefix], urlStr);
    serverUrl = [self addQueryStringToUrlString:serverUrl withDictionary:params];
    LCNetLogInfo(@"the server url is %@ params is %@", serverUrl, params);
    [manager GET:serverUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self parseResponseObject:responseObject];
        LCNetLogInfo(@"request finished the json data is %@", self.jsonDic);
        
        NSError *error = nil;
        if (self.status != REQUEST_STATUS_OK) {
            error = [NSError errorWithDomain:self.msg code:self.status userInfo:nil];
        }
        
        if (self.callBack) {
            self.callBack(self.jsonDic,self.status,self.msg,self.dataDic,[self replaceEnglishErrorMsg:error]);
            self.callBack = nil;
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:urlStr object:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LCNetLogWarn(@"Error: %@", error);
        
        if ([[error.userInfo allKeys] containsObject:NSLocalizedDescriptionKey]) {
            error = [NSError errorWithDomain:[error.userInfo objectForKey:NSLocalizedDescriptionKey] code:error.code userInfo:error.userInfo];
        }
        
        if (self.callBack) {
            self.callBack(nil,0,nil,nil,[self replaceEnglishErrorMsg:error]);
            self.callBack = nil;
        }
    }];
}


- (void)doPost:(NSString *)urlStr withParams:(NSDictionary *)params requestCallBack:(requestCallBack)callback{
    self.callBack = callback;
    NSString *serverUrl = server_url([LCConstants serverUrlPrefix], urlStr);
    
    /*
     Roy 2015.9.10
     临时，对于发短信请求，使用https
     */
    if ([urlStr isEqualToString:URL_SEND_AUTHCODE]) {
        NSString *prefix = [LCConstants serverUrlPrefix];
        serverUrl = server_url(prefix, urlStr);
    }
    
    LCNetLogInfo(@"the server url is %@ params is: %@", serverUrl, params);
    [manager POST:serverUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self parseResponseObject:responseObject];
        LCNetLogInfo(@"Request Finished Succeed! Url:%@ param:%@ Json:%@ \r\nMsg:%@",urlStr, params,self.jsonDic, self.msg);
//        LCNetLogInfo(@"Request Finished Succeed! Url:%@ param:%@ ",urlStr, params);

        NSError *error = nil;
        if (self.status != REQUEST_STATUS_OK) {
            error = [NSError errorWithDomain:self.msg code:self.status userInfo:nil];
        }
        
        if (self.callBack) {
            self.callBack(self.jsonDic,self.status,self.msg,self.dataDic,[self replaceEnglishErrorMsg:error]);
            self.callBack = nil;
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:urlStr object:nil];//请求回调之后就发布一个通知，已url为明朝
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        /// TODO:: 是直接返回Request错误，还是返回一致的网络请求错误？
        LCNetLogWarn(@"Request Finished Failed! Error:%@", error);
        
        if ([[error.userInfo allKeys] containsObject:NSLocalizedDescriptionKey]) {
            error = [NSError errorWithDomain:[error.userInfo objectForKey:NSLocalizedDescriptionKey] code:error.code userInfo:error.userInfo];
        }
        
        if (self.callBack) {
            self.callBack(nil,0,nil,nil,[self replaceEnglishErrorMsg:error]);
            self.callBack = nil;
        }
    }];
    
}

- (void)parseResponseObject:(id)response{
    self.jsonDic = (NSDictionary *)response;
    /// 返回状态正确的情况下，表明获取数据成功.
    if (nil != self.jsonDic) {
        self.status = [[self.jsonDic objectForKey:@"Status"] intValue];
        self.msg = [self.jsonDic objectForKey:@"Msg"];
        /** Roy 2015.1.10
         后台返回的经转化后都是dictionary，data为空时，返回空括号，所以转换后类型为Array
         需要特殊处理
         */
        id obj = [self.jsonDic objectForKey:@"Data"];
        if ([obj isKindOfClass:[NSArray class]]) {
            self.dataDic = [[NSDictionary alloc] init];
        } else if ([obj isKindOfClass:[NSDictionary class]]) {
            self.dataDic = (NSDictionary *)obj;
        }
    }
}

- (void)requestFinished {
    //    LCNetLogInfo(@"request finished the json data is %@", self.jsonDic);
    //    /// 返回状态正确的情况下，表明获取数据成功.
    //    if (nil != self.jsonDic) {
    //        self.status = [[self.jsonDic objectForKey:@"Status"] intValue];
    //        self.msg = [self.jsonDic objectForKey:@"Msg"];
    //        /** Roy 2015.1.10
    //            后台返回的经转化后都是dictionary，data为空时，返回空括号，所以转换后类型为Array
    //            需要特殊处理
    //         */
    //        id obj = [self.jsonDic objectForKey:@"Data"];
    //        if ([obj isKindOfClass:[NSArray class]]) {
    //            self.dataDic = [[NSDictionary alloc] init];
    //        } else if ([obj isKindOfClass:[NSDictionary class]]) {
    //            self.dataDic = (NSDictionary *)obj;
    //        }
    //    }
}

- (void)requestFailed {
    LCNetLogWarn(@"YSHttpApi requestFailed...");
    self.jsonDic = [[NSDictionary alloc] init];
}

#pragma mark -
- (NSError *)replaceEnglishErrorMsg:(NSError *)err{
    NSError *ret = err;
    if (err && [LCStringUtil isNotNullString:err.domain] && [err.domain hasPrefix:@"Request failed"]) {
        ret = [NSError errorWithDomain:@"网络错误" code:err.code userInfo:err.userInfo];
    }
    return ret;
}

- (void)cancelAllOperations {
    [manager.operationQueue cancelAllOperations];
}

@end
