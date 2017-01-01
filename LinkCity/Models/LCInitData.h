//
//  LCInitData.h
//  LinkCity
//
//  Created by 张宗硕 on 12/5/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCUserTagModel.h"
#import "LCRouteThemeModel.h"
#import "LCBaseModel.h"
#import "LCRoutePlaceModel.h"
#import "LCVersionInfoModel.h"
#import "LCUserNotifyModel.h"
#import "LCRouteThemeModel.h"

@interface LCInitData : LCBaseModel

@property (nonatomic, strong) NSArray *serviceTags;
@property (nonatomic, strong) NSArray *planThemes;
@property (nonatomic, retain) NSArray *hotPlaceArr;
@property (nonatomic, strong) NSArray *routePlanTags;
@property (nonatomic, strong) NSArray *routeLocalThemes;
@property (nonatomic, strong) NSArray *routeLocalTags;
@property (strong, nonatomic) NSArray *inviteThemes;
@property (strong, nonatomic) NSArray *hotThemeArr;

@property (nonatomic, strong) LCVersionInfoModel *versionInfo;
@property (nonatomic, strong) LCUserNotifyModel *userNotify;

@property (nonatomic, assign) BOOL showSelfToContact;

@property (nonatomic, assign) BOOL notifWifiVedioAutoPlay;

@end
