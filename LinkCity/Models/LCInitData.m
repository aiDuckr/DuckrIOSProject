//
//  LCInitData.m
//  LinkCity
//
//  Created by 张宗硕 on 12/5/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCInitData.h"

static  NSString *const showSelfToContactKey = @"ShowSelfToContact";
static  NSString *const notifWifiVedioAutoPlayKey = @"NotifWifiVedioAutoPlay";

@implementation LCInitData

- (id)initWithDictionary:(NSDictionary *)dic {
    self = [super initWithDictionary:dic];
    if (self) {
        /// 是否删除本地过期的CID私钥.
        BOOL isDelCID = [[LCStringUtil getNotNullStr:[dic objectForKey:@"IsCIDExpired"]] boolValue];
        if (isDelCID) {
            [LCSharedFuncUtil quitLoginApp];
        }
        
        NSMutableArray *serverTagArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSDictionary *tagDic in [dic arrayForKey:@"ServiceTags"]){
            LCUserTagModel *tag = [[LCUserTagModel alloc] initWithDictionary:tagDic];
            [serverTagArray addObject:tag];
        }
        self.serviceTags = serverTagArray;
        
        NSMutableArray *hotPlaceArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSDictionary *placeDic in [dic arrayForKey:@"HotPlaces"]){
            LCHomeCategoryModel *aPlace = [[LCHomeCategoryModel alloc] initWithDictionary:placeDic];
            [hotPlaceArray addObject:aPlace];
        }
        self.hotPlaceArr = hotPlaceArray;
        
        NSMutableArray *planThemeArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSDictionary *themeDic in [dic arrayForKey:@"PlanThemes"]){
            LCRouteThemeModel *theme = [[LCRouteThemeModel alloc] initWithDictionary:themeDic];
            [planThemeArray addObject:theme];
        }
        self.planThemes = planThemeArray;
        
        NSMutableArray *planTagsArr = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSDictionary *themeDic in [dic arrayForKey:@"PlanTags"]) {
            LCRouteThemeModel *theme = [[LCRouteThemeModel alloc] initWithDictionary:themeDic];
            [planTagsArr addObject:theme];
        }
        self.routePlanTags = planTagsArr;
        
        NSMutableArray *localTagsArr = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSDictionary *themeDic in [dic arrayForKey:@"LocalTags"]) {
            LCRouteThemeModel *theme = [[LCRouteThemeModel alloc] initWithDictionary:themeDic];
            [localTagsArr addObject:theme];
        }
        self.routeLocalTags = localTagsArr;
        
        NSMutableArray *LocalThemesArr = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSDictionary *themeDic in [dic arrayForKey:@"LocalThemes"]) {
            LCRouteThemeModel *theme = [[LCRouteThemeModel alloc] initWithDictionary:themeDic];
            [LocalThemesArr addObject:theme];
        }
        self.routeLocalThemes = LocalThemesArr;
        
        NSMutableArray *inviteThemesArr = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSDictionary *themeDic in [dic arrayForKey:@"InviteThemes"]) {
            LCRouteThemeModel *theme = [[LCRouteThemeModel alloc] initWithDictionary:themeDic];
            [inviteThemesArr addObject:theme];
        }
        self.inviteThemes = inviteThemesArr;
        
        NSMutableArray *mutArr = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSDictionary *themeDic in [dic arrayForKey:@"HotThemes"]) {
            LCRouteThemeModel *theme = [[LCRouteThemeModel alloc] initWithDictionary:themeDic];
            [mutArr addObject:theme];
        }
        self.hotThemeArr = mutArr;
        
        self.versionInfo = [[LCVersionInfoModel alloc] initWithDictionary:[dic dicOfObjectForKey:@"VersionInfo"]];
        self.userNotify = [[LCUserNotifyModel alloc] initWithDictionary:[dic dicOfObjectForKey:@"UserNotify"]];
        self.showSelfToContact = [[dic objectForKey:showSelfToContactKey] boolValue];
        self.notifWifiVedioAutoPlay = [[dic objectForKey:notifWifiVedioAutoPlayKey] boolValue];
    }
    return self;
}


- (void)encodeWithCoder: (NSCoder *)coder {
    [coder encodeObject:self.serviceTags forKey:@"ServiceTags"];
    [coder encodeObject:self.planThemes forKey:@"PlanThemes"];
    [coder encodeObject:self.routeLocalThemes forKey:@"LocalThemes"];
    [coder encodeObject:self.routeLocalTags forKey:@"PlanThemes"];
    [coder encodeObject:self.routePlanTags forKey:@"PlanTags"];
    [coder encodeObject:self.routeLocalTags forKey:@"LocalTags"];
    [coder encodeObject:self.inviteThemes forKey:@"InviteThemes"];
    
    [coder encodeObject:self.versionInfo forKey:@"VersionInfo"];
    [coder encodeObject:self.userNotify forKey:@"UserNotify"];
    [coder encodeObject:self.hotThemeArr forKey:NSStringFromSelector(@selector(hotThemeArr))];
    [coder encodeBool:self.showSelfToContact forKey:showSelfToContactKey];
    [coder encodeBool:self.notifWifiVedioAutoPlay forKey:notifWifiVedioAutoPlayKey];
    
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.serviceTags = [coder decodeObjectForKey:@"ServiceTags"];
        self.planThemes = [coder decodeObjectForKey:@"PlanThemes"];
        self.routePlanTags = [coder decodeObjectForKey:@"PlanTags"];
        self.routeLocalTags = [coder decodeObjectForKey:@"LocalTags"];
        self.routeLocalThemes = [coder decodeObjectForKey:@"LocalThemes"];
        self.inviteThemes = [coder decodeObjectForKey:@"InviteThemes"];
        
        self.versionInfo = [coder decodeObjectForKey:@"VersionInfo"];
        self.userNotify = [coder decodeObjectForKey:@"UserNotify"];
        self.hotThemeArr = [coder decodeObjectForKey:NSStringFromSelector(@selector(hotThemeArr))];
        self.showSelfToContact = [coder decodeBoolForKey:showSelfToContactKey];
        self.notifWifiVedioAutoPlay = [coder decodeBoolForKey:notifWifiVedioAutoPlayKey];
    }
    return self;
}

@end
