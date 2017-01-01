//
//  YSUserManager.m
//  CityLink
//
//  Created by zzs on 14-7-19.
//  Copyright (c) 2014年 yunshuo. All rights reserved.
//

#import "LCDataManager.h"
#import "LCDateUtil.h"
#import "LCUserInfo.h"


@interface LCDataManager()

@end

@implementation LCDataManager

+ (instancetype)sharedInstance{
    static LCDataManager *staticInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticInstance = [[LCDataManager alloc] init];
    });
    return staticInstance;
}

#pragma mark Back Compatible
- (void)doBackCompatible {
    NSArray *userInfos = [self readListsForKey:@"UserInfo"];
    LCUserInfo *userInfo = nil;
    if (nil != userInfos && userInfos.count >= 1) {
        //存在V3.0之前的UserModel，进行向后兼容
        
        //之前的用户信息
        userInfo = [userInfos objectAtIndex:0];
        LCLogInfo(@"%@,%@,%@,%@",userInfo.cid,userInfo.uuid,userInfo.nick,userInfo.telephone);
        
        //删除之前的配置
        NSUserDefaults *standardUserDefault = [NSUserDefaults standardUserDefaults];
        NSDictionary *allDic = [standardUserDefault dictionaryRepresentation];
        for (NSString *key in [allDic allKeys]){
            [standardUserDefault removeObjectForKey:key];
        }
        [standardUserDefault synchronize];
        
        //删除之前的聊天 通讯录、聊天记录
        [LCXMPPUtil deleteAllChatMsg];
        [LCXMPPUtil deleteAllChatContact];
        
        //使用之前数据建立新的用户
        LCUserModel *formerUser = [[LCUserModel alloc] init];
        formerUser.cID = userInfo.cid;
        formerUser.uUID = userInfo.uuid;
        formerUser.telephone = userInfo.telephone;
        formerUser.nick = userInfo.nick;
        formerUser.livingPlace = userInfo.livingPlace;
        formerUser.avatarUrl = userInfo.avatarUrl;
        formerUser.avatarThumbUrl = userInfo.avatarThumbUrl;
        
        [LCDataManager sharedInstance].userInfo = formerUser;
        //设置为不是第一次打开App，跳过Splash页面
        [LCDataManager sharedInstance].isFirstTimeOpenApp = 0;
        [[LCDataManager sharedInstance] saveData];
        
        //去Server更新用户信息
        [LCNetRequester getUserInfo:formerUser.uUID callBack:^(LCUserModel *user, NSError *error) {
            if (!error) {
                [LCDataManager sharedInstance].userInfo = user;
            }else{
                LCLogWarn(@"getUserInfoError:%@",error);
            }
        }];
        
    }else{
        // 没有上一版的UserInfo，不用管
    }
}
- (NSMutableArray *)readListsForKey:(NSString *)key {
    NSArray *lists = nil;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (nil != data) {
        lists = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    } else {
        lists = [[NSArray alloc] init];
    }
    return [NSMutableArray arrayWithArray:lists];
}


#pragma mark Save & Read
- (void)readData{
    #pragma mark 一次安装相关
    //进行过某些操作的标记
    self.isFirstTimeOpenApp = [self readIntegerForKey:NSStringFromSelector(@selector(isFirstTimeOpenApp)) withDefaultValue:1];
    self.shouldUMengActive = [self readIntegerForKey:NSStringFromSelector(@selector(shouldUMengActive)) withDefaultValue:1];
    
    #pragma mark 应用相关
    self.orderRule = (LCOrderRuleModel *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(orderRule))];
    
    #pragma mark 设备相关
    // App 初始化
    self.remoteNotificationToken = (NSString *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(remoteNotificationToken))];
    //client id
    //device id
    
    #pragma mark 用户相关
    ///多处用
    self.favorUserArr = (NSArray *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(favorUserArr))];
//    self.freeTimeArr = [NSMutableArray arrayWithArray:[self readArchivedObjectForKey:NSStringFromSelector(@selector(freeTimeArr))]];
    self.localSelectedTime=(NSDate*)[self readArchivedObjectForKey:NSStringFromSelector(@selector(localSelectedTime))];
    self.joinedPlanArr = [NSMutableArray arrayWithArray:[self readArchivedObjectForKey:NSStringFromSelector(@selector(joinedPlanArr))]];
    self.joinedChatGroupArr = [NSMutableArray arrayWithArray:[self readArchivedObjectForKey:NSStringFromSelector(@selector(joinedChatGroupArr))]];
    self.userLocation = (LCUserLocation *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(userLocation))];
    
    self.appInitData = (LCInitData *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(appInitData))];
    self.historySearchArray = (NSArray *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(historySearchArray))];
    self.redDot = (LCRedDotModel *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(redDot))];
    
    self.userInfo = (LCUserModel *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(userInfo))];
    self.merchantAccount = (LCUserAccount *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(merchantAccount))];
    self.sendingPlan = (LCPlanModel *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(sendingPlan))];
    self.modifyingPlan = (LCPlanModel *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(modifyingPlan))];
    
    self.lastUploadConatactDate = (NSDate *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(lastUploadConatactDate))];
    self.currentCity = (LCCityModel *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(currentCity))];
    self.locationCity = (LCCityModel *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(locationCity))];
    self.isAlertLocationCity = [self readIntegerForKey:NSStringFromSelector(@selector(isAlertLocationCity)) withDefaultValue:0];
    
    /// 首页的数据,存本地
//    self.homeCellArray = (NSArray *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(homeCellArray))];
//    self.arrayOfHomeCellArray = [NSMutableArray arrayWithArray:[self readArchivedObjectForKey:NSStringFromSelector(@selector(arrayOfHomeCellArray))]];
//    self.homeUpdateTimeArray = [NSMutableArray arrayWithArray:[self readArchivedObjectForKey:NSStringFromSelector(@selector(homeUpdateTimeArray))]];
    self.suggHomeRcmd = (LCHomeRcmd *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(suggHomeRcmd))];
    self.rcmdTopArr = (NSArray *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(rcmdTopArr))];
    self.rcmdContentArr = (NSArray *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(rcmdContentArr))];
    self.inviteContentArr = (NSArray *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(inviteContentArr))];
    self.searchCostPlanResultArr = (NSArray *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(searchCostPlanResultArr))];
    self.searchFreePlanResultArr = (NSArray *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(searchFreePlanResultArr))];
    
    self.homeSearchMoreActiv = (NSArray *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(homeSearchMoreActiv))];
    self.homeSearchMoreInvite = (NSArray *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(homeSearchMoreInvite))];
    
    self.localTradeTopArr = (NSArray *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(localTradeTopArr))];
    self.localTradeContentArr = (NSArray *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(localTradeContentArr))];
    self.localInviteContentArr = (NSArray *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(localInviteContentArr))];
    self.localSearchActiv = (NSArray *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(localSearchActiv))];
    
    self.homeSelectedCostPlansArr = (NSArray *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(homeSelectedCostPlansArr))];
    self.homeRecmedCostPlansArr = (NSArray *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(homeRecmedCostPlansArr))];
    self.homeRecmTourpicArr = (NSArray *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(homeRecmTourpicArr))];
    self.homeRecmOnlineDuckrArr = (NSArray *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(homeRecmOnlineDuckrArr))];
    self.homeRecmOnlineHappenArr = (NSArray *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(homeRecmOnlineHappenArr))];
    self.localWeatherDay = (LCWeatherDay *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(localWeatherDay))];
    self.localContentArr = (NSArray *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(localContentArr))];
    self.provinceArr = (NSArray *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(provinceArr))];
    self.hotCityArr = (NSArray *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(hotCityArr))];
    self.planContentArr = (NSArray *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(planContentArr))];
    self.duckrStoryArr = (NSArray *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(duckrStoryArr))];
    self.duckrBoardArr = (NSArray *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(duckrBoardArr))];
    self.duckrBoardListArr = (NSArray *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(duckrBoardListArr))];
    self.duckrOnlineCategory = (LCHomeCategoryModel *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(duckrOnlineCategory))];
    self.duckrCityCategory = (LCHomeCategoryModel *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(duckrCityCategory))];
    
    self.duckrContentArr = (NSArray *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(duckrContentArr))];
    
    //附近页，用户之前选择的筛选项，存本地
    self.nearbyNativeFilterType = [self readIntegerForKey:NSStringFromSelector(@selector(nearbyNativeFilterType)) withDefaultValue:LCUserFilterType_All];
    self.nearbyTouristFilterType = [self readIntegerForKey:NSStringFromSelector(@selector(nearbyTouristFilterType)) withDefaultValue:LCUserFilterType_All];
    self.nearbyPlanOrderType = [self readIntegerForKey:NSStringFromSelector(@selector(nearbyPlanOrderType)) withDefaultValue:LCPlanOrderType_DepartTime];
    
    //本地
    self.nearbyTourpicArray = (NSArray *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(nearbyTourpicArray))];
    self.nearbyPlanArray = (NSArray *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(nearbyPlanArray))];
    
    //旅图
    self.popularTourpicArray = (NSArray *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(popularTourpicArray))];
    self.focusTourpicArr = (NSArray *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(focusTourpicArr))];
    self.squareTourpicStreamArr = (NSArray *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(squareTourpicStreamArr))];
    self.albumTourpicArr = (NSArray *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(albumTourpicArr))];
    self.latestTourpicPlaceNameArr = (NSArray *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(latestTourpicPlaceNameArr))];
    
    ///聊天
    NSDictionary *chatContactDic = (NSDictionary *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(chatContactDic))];
    self.chatContactDic = [NSMutableDictionary dictionaryWithDictionary:chatContactDic];
    NSDictionary *unreadNumDic = (NSDictionary *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(unreadNumDic))];
    self.unreadNumDic = [NSMutableDictionary dictionaryWithDictionary:unreadNumDic];
    
    //手机通讯录
    self.phoneContactList = (NSArray *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(phoneContactList))];
    
    //setting
    self.haveSetInviteUserTelephone = [self readIntegerForKey:NSStringFromSelector(@selector(haveSetInviteUserTelephone)) withDefaultValue:0];
    
    ///个人Tab
    self.favoredPlanArr = [NSMutableArray arrayWithArray: [self readArchivedObjectForKey:NSStringFromSelector(@selector(favoredPlanArr))]];
    
    ///order
    self.userRealName = (NSString *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(userRealName))];
    self.userRealId = (NSString *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(userRealId))];
    self.userRealTelephone = (NSString *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(userRealTelephone))];
    
    //For debug:
    self.useReleaseServerForDebug = [self readIntegerForKey:NSStringFromSelector(@selector(useReleaseServerForDebug)) withDefaultValue:0];
    
    self.orderPlanArray = (NSArray *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(orderPlanArray))];
    
    //通讯录
    self.contactUserList = (NSArray *)[self readArchivedObjectForKey:NSStringFromSelector(@selector(contactUserList))];
}
- (void)saveData{
    #pragma mark 一次安装相关
    //进行过某些操作的标记
    [self saveInteger:self.isFirstTimeOpenApp forKey:NSStringFromSelector(@selector(isFirstTimeOpenApp))];
    [self saveInteger:self.shouldUMengActive forKey:NSStringFromSelector(@selector(shouldUMengActive))];
    
    #pragma mark 应用相关
    [self archiveAndSaveObject:self.orderRule forKey:NSStringFromSelector(@selector(orderRule))];
    
    #pragma mark 设备相关
    // App 初始化
    [self archiveAndSaveObject:self.remoteNotificationToken forKey:NSStringFromSelector(@selector(remoteNotificationToken))];
    //client id
    //device id
    
    
    #pragma mark 用户相关
    ///多处用
    [self archiveAndSaveObject:self.favorUserArr forKey:NSStringFromSelector(@selector(favorUserArr))];
//    [self archiveAndSaveObject:self.freeTimeArr forKey:NSStringFromSelector(@selector(freeTimeArr))];
        [self archiveAndSaveObject:self.localSelectedTime forKey:NSStringFromSelector(@selector(localSelectedTime))];
    [self archiveAndSaveObject:self.joinedPlanArr forKey:NSStringFromSelector(@selector(joinedPlanArr))];
    [self archiveAndSaveObject:self.joinedChatGroupArr forKey:NSStringFromSelector(@selector(joinedChatGroupArr))];
    [self archiveAndSaveObject:self.userLocation forKey:NSStringFromSelector(@selector(userLocation))];
    
    [self archiveAndSaveObject:self.appInitData forKey:NSStringFromSelector(@selector(appInitData))];
    [self archiveAndSaveObject:self.historySearchArray forKey:NSStringFromSelector(@selector(historySearchArray))];
    [self archiveAndSaveObject:self.redDot forKey:NSStringFromSelector(@selector(redDot))];
    
    [self archiveAndSaveObject:self.userInfo forKey:NSStringFromSelector(@selector(userInfo))];
    [self archiveAndSaveObject:self.merchantAccount forKey:NSStringFromSelector(@selector(merchantAccount))];
    [self archiveAndSaveObject:self.sendingPlan forKey:NSStringFromSelector(@selector(sendingPlan))];
    [self archiveAndSaveObject:self.modifyingPlan forKey:NSStringFromSelector(@selector(modifyingPlan))];
    
    [self archiveAndSaveObject:self.lastUploadConatactDate forKey:NSStringFromSelector(@selector(lastUploadConatactDate))];
    [self archiveAndSaveObject:self.currentCity forKey:NSStringFromSelector(@selector(currentCity))];
    [self archiveAndSaveObject:self.locationCity forKey:NSStringFromSelector(@selector(locationCity))];
    [self saveInteger:self.isAlertLocationCity forKey:NSStringFromSelector(@selector(isAlertLocationCity))];
    
    /// 首页的数据,存本地
//    [self archiveAndSaveObject:self.homeCellArray forKey:NSStringFromSelector(@selector(homeCellArray))];
//    [self archiveAndSaveObject:self.arrayOfHomeCellArray forKey:NSStringFromSelector(@selector(arrayOfHomeCellArray))];
//    [self archiveAndSaveObject:self.homeUpdateTimeArray forKey:NSStringFromSelector(@selector(homeUpdateTimeArray))];
    
    [self archiveAndSaveObject:self.suggHomeRcmd forKey:NSStringFromSelector(@selector(suggHomeRcmd))];
    [self archiveAndSaveObject:self.rcmdTopArr forKey:NSStringFromSelector(@selector(rcmdTopArr))];
    [self archiveAndSaveObject:self.rcmdContentArr forKey:NSStringFromSelector(@selector(rcmdContentArr))];
    [self archiveAndSaveObject:self.inviteContentArr forKey:NSStringFromSelector(@selector(inviteContentArr))];
    [self archiveAndSaveObject:self.searchCostPlanResultArr forKey:NSStringFromSelector(@selector(searchCostPlanResultArr))];
    [self archiveAndSaveObject:self.searchFreePlanResultArr forKey:NSStringFromSelector(@selector(searchFreePlanResultArr))];
    [self archiveAndSaveObject:self.homeSearchMoreActiv forKey:NSStringFromSelector(@selector(homeSearchMoreActiv))];
    [self archiveAndSaveObject:self.homeSearchMoreInvite forKey:NSStringFromSelector(@selector(homeSearchMoreInvite))];
    [self archiveAndSaveObject:self.localTradeTopArr forKey:NSStringFromSelector(@selector(localTradeTopArr))];
    [self archiveAndSaveObject:self.localTradeContentArr forKey:NSStringFromSelector(@selector(localTradeContentArr))];
    [self archiveAndSaveObject:self.localInviteContentArr forKey:NSStringFromSelector(@selector(localInviteContentArr))];
    [self archiveAndSaveObject:self.localSearchActiv forKey:NSStringFromSelector(@selector(localSearchActiv))];
    
    [self archiveAndSaveObject:self.homeSelectedCostPlansArr forKey:NSStringFromSelector(@selector(homeSelectedCostPlansArr))];
    [self archiveAndSaveObject:self.homeRecmedCostPlansArr forKey:NSStringFromSelector(@selector(homeRecmedCostPlansArr))];
    [self archiveAndSaveObject:self.homeRecmTourpicArr forKey:NSStringFromSelector(@selector(homeRecmTourpicArr))];
    [self archiveAndSaveObject:self.homeRecmOnlineDuckrArr forKey:NSStringFromSelector(@selector(homeRecmOnlineDuckrArr))];
    [self archiveAndSaveObject:self.homeRecmOnlineHappenArr forKey:NSStringFromSelector(@selector(homeRecmOnlineHappenArr))];
    [self archiveAndSaveObject:self.localWeatherDay forKey:NSStringFromSelector(@selector(localWeatherDay))];
    [self archiveAndSaveObject:self.localContentArr forKey:NSStringFromSelector(@selector(localContentArr))];
    [self archiveAndSaveObject:self.provinceArr forKey:NSStringFromSelector(@selector(provinceArr))];
    [self archiveAndSaveObject:self.hotCityArr forKey:NSStringFromSelector(@selector(hotCityArr))];
    [self archiveAndSaveObject:self.planContentArr forKey:NSStringFromSelector(@selector(planContentArr))];
    [self archiveAndSaveObject:self.duckrStoryArr forKey:NSStringFromSelector(@selector(duckrStoryArr))];
    [self archiveAndSaveObject:self.duckrBoardArr forKey:NSStringFromSelector(@selector(duckrBoardArr))];
    [self archiveAndSaveObject:self.duckrBoardListArr forKey:NSStringFromSelector(@selector(duckrBoardListArr))];
    [self archiveAndSaveObject:self.duckrOnlineCategory forKey:NSStringFromSelector(@selector(duckrOnlineCategory))];
    [self archiveAndSaveObject:self.duckrCityCategory forKey:NSStringFromSelector(@selector(duckrCityCategory))];
    [self archiveAndSaveObject:self.duckrContentArr forKey:NSStringFromSelector(@selector(duckrContentArr))];
    
    
    //附近页，用户之前选择的筛选项，存本地
    [self saveInteger:self.nearbyNativeFilterType forKey:NSStringFromSelector(@selector(nearbyNativeFilterType))];
    [self saveInteger:self.nearbyPlanOrderType forKey:NSStringFromSelector(@selector(nearbyPlanOrderType))];
    [self saveInteger:self.nearbyTouristFilterType forKey:NSStringFromSelector(@selector(nearbyTouristFilterType))];
    
    //本地
    [self archiveAndSaveObject:self.nearbyTourpicArray forKey:NSStringFromSelector(@selector(nearbyTourpicArray))];
    [self archiveAndSaveObject:self.nearbyPlanArray forKey:NSStringFromSelector(@selector(nearbyPlanArray))];
    
    //旅图
    [self archiveAndSaveObject:self.popularTourpicArray forKey:NSStringFromSelector(@selector(popularTourpicArray))];
    [self archiveAndSaveObject:self.focusTourpicArr forKey:NSStringFromSelector(@selector(focusTourpicArr))];
    [self archiveAndSaveObject:self.squareTourpicStreamArr forKey:NSStringFromSelector(@selector(squareTourpicStreamArr))];
    [self archiveAndSaveObject:self.albumTourpicArr forKey:NSStringFromSelector(@selector(albumTourpicArr))];
    [self archiveAndSaveObject:self.latestTourpicPlaceNameArr forKey:NSStringFromSelector(@selector(latestTourpicPlaceNameArr))];
    
    
    ///聊天
    [self archiveAndSaveObject:self.chatContactDic forKey:NSStringFromSelector(@selector(chatContactDic))];
    [self archiveAndSaveObject:self.unreadNumDic forKey:NSStringFromSelector(@selector(unreadNumDic))];
    
    //手机通讯录
    [self archiveAndSaveObject:self.phoneContactList forKey:NSStringFromSelector(@selector(phoneContactList))];
    
    //setting
    [self saveInteger:self.haveSetInviteUserTelephone forKey:NSStringFromSelector(@selector(haveSetInviteUserTelephone))];
    
    ///个人Tab
    [self archiveAndSaveObject:self.favoredPlanArr forKey:NSStringFromSelector(@selector(favoredPlanArr))];
    
    ///order
    [self archiveAndSaveObject:self.userRealName forKey:NSStringFromSelector(@selector(userRealName))];
    [self archiveAndSaveObject:self.userRealId forKey:NSStringFromSelector(@selector(userRealId))];
    [self archiveAndSaveObject:self.userRealTelephone forKey:NSStringFromSelector(@selector(userRealTelephone))];
    
    
    //For debug:
    [self saveInteger:self.useReleaseServerForDebug forKey:NSStringFromSelector(@selector(useReleaseServerForDebug))];
    
    [self archiveAndSaveObject:self.orderPlanArray forKey:NSStringFromSelector(@selector(orderPlanArray))];
    //通讯录
    [self archiveAndSaveObject:self.contactUserList forKey:NSStringFromSelector(@selector(contactUserList))];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)clearOneActivityValidData{
//    self.homePageCity = nil;
//    self.homePageProvince = nil;
    
}

#pragma mark Profession
- (NSArray *)professionNameArray{
    return @[@"计算机/互联网/通讯",
             @"商业/服务业/个体经营",
             @"金融/银行/投资/保险",
             @"文化/广告/传媒",
             @"娱乐/艺术/表演",
             @"医疗/护理/制药",
             @"律师/法务",
             @"教育/培训",
             @"公务员/事业单位",
             @"学生",
             @"无"];
}
- (NSDictionary *)professionDic{
    return @{@"计算机/互联网/通讯":@"ProfessionIT",
             @"商业/服务业/个体经营":@"ProfessionBiz",
             @"金融/银行/投资/保险":@"ProfessionFinance",
             @"文化/广告/传媒":@"ProfessionLiterature",
             @"娱乐/艺术/表演":@"ProfessionArt",
             @"医疗/护理/制药":@"ProfessionDoc",
             @"律师/法务":@"ProfessionLaw",
             @"教育/培训":@"ProfessionEdu",
             @"公务员/事业单位":@"ProfessionPolity",
             @"学生":@"ProfessionStudent",
             @"无":@"Translucent"};
}

#pragma mark RedDot Num
- (void)setRedDot:(LCRedDotModel *)redDot{
    _redDot = redDot;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationRedDotNumDidChange object:nil];
}

#pragma mark UnreadNum
- (NSMutableDictionary *)unreadNumDic{
    if (!_unreadNumDic) {
        _unreadNumDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return _unreadNumDic;
}
- (void)addUnreadNumForBareJidStr:(NSString *)bareJidStr{
    NSNumber *unreadNum = [self.unreadNumDic objectForKey:bareJidStr];
    NSInteger unreadInteger = 0;
    if (!unreadNum) {
        unreadInteger = 1;
    }else{
        unreadInteger = [unreadNum integerValue] + 1;
    }
    [self.unreadNumDic setObject:[NSNumber numberWithInteger:unreadInteger] forKey:bareJidStr];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUnreadNumDidChange object:nil];
    //LCLogInfo(@"UnreadNum :%@",self.unreadNumDic);
}
- (void)clearUnreadNumForBareJidStr:(NSString *)bareJidStr{
    if ([LCStringUtil isNotNullString:bareJidStr]) {
        [self.unreadNumDic removeObjectForKey:bareJidStr];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUnreadNumDidChange object:nil];
}
- (void)clearUnreadNumForAll{
    [self.unreadNumDic removeAllObjects];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUnreadNumDidChange object:nil];
}
- (NSInteger)getUnreadNumForBareJidStr:(NSString *)bareJidStr{
    NSNumber *unreadNum = [self.unreadNumDic objectForKey:bareJidStr];
    if (!unreadNum) {
        return 0;
    }
    return [unreadNum integerValue];
}
- (NSInteger)getUnreadNumSum{
    NSInteger sum = 0;
    for (NSNumber *num in [self.unreadNumDic allValues]){
        if ([num isKindOfClass:[NSNumber class]]) {
            sum += [num integerValue];
        }
    }
    return sum;
}

#pragma mark UserLocation
- (LCUserLocation *)userLocation{
    if (!_userLocation) {
        _userLocation = [[LCUserLocation alloc] init];
        _userLocation.type = LocationTypeError;
        _userLocation.lat = 0;
        _userLocation.lng = 0;
        _userLocation.updateTime = [NSDate dateWithTimeIntervalSince1970:1];
    }
    return _userLocation;
}

#pragma mark lastUploadConatactDate
- (NSDate *)lastUploadConatactDate{
    if (!_lastUploadConatactDate) {
        _lastUploadConatactDate = [NSDate dateWithTimeIntervalSince1970:0];
    }
    return _lastUploadConatactDate;
}

#pragma mark Logout
- (void)clearUserDefaultForLogout{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    ///多处用
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(favorUserArr))];
//    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(freeTimeArr))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(localSelectedTime))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(joinedPlanArr))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(joinedChatGroupArr))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(appInitData))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(historySearchArray))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(redDot))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(userInfo))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(merchantAccount))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(sendingPlan))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(modifyingPlan))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(lastUploadConatactDate))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(currentCity))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(locationCity))];
    
    
    /// 首页的数据,存本地
//    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(homeCellArray))];
//    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(arrayOfHomeCellArray))];
//    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(homeUpdateTimeArray))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(suggHomeRcmd))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(rcmdTopArr))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(rcmdContentArr))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(inviteContentArr))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(searchCostPlanResultArr))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(searchFreePlanResultArr))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(homeSearchMoreActiv))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(homeSearchMoreInvite))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(localTradeTopArr))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(localTradeContentArr))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(localInviteContentArr))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(homeSelectedCostPlansArr))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(homeRecmedCostPlansArr))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(homeRecmTourpicArr))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(homeRecmOnlineDuckrArr))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(homeRecmOnlineHappenArr))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(localWeatherDay))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(localContentArr))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(localSearchActiv))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(provinceArr))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(hotCityArr))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(planContentArr))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(duckrStoryArr))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(duckrBoardArr))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(duckrBoardListArr))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(duckrOnlineCategory))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(duckrCityCategory))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(duckrContentArr))];
    
    //附近页，用户之前选择的筛选项，存本地
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(nearbyNativeFilterType))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(nearbyPlanOrderType))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(nearbyTouristFilterType))];
    
    //本地
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(nearbyTourpicArray))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(nearbyPlanArray))];
    
    //旅图
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(popularTourpicArray))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(focusTourpicArr))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(squareTourpicStreamArr))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(albumTourpicArr))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(latestTourpicPlaceNameArr))];
    
    ///聊天
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(chatContactDic))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(unreadNumDic))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(contactUserList))];
    
    //手机通讯录
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(phoneContactList))];
    
    ///个人Tab
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(favoredPlanArr))];
    
    ///order
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(userRealName))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(userRealId))];
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(userRealTelephone))];
    
    //setting
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(haveSetInviteUserTelephone))];
    
    [userDefaults removeObjectForKey:NSStringFromSelector(@selector(orderPlanArray))];
    
    [userDefaults synchronize];
}


#pragma CheckLogin
- (BOOL)haveLogin {
    if (nil == self.userInfo || [LCStringUtil isNullString:self.userInfo.cID] || [LCStringUtil isNullString:self.userInfo.uUID]) {
        return NO;
    }
    return YES;
}


#pragma Tourpic
- (void)addLatestTourpicPlaceName:(NSString *)placeName{
    if (!self.latestTourpicPlaceNameArr) {
        self.latestTourpicPlaceNameArr = @[placeName];
    }else{
        NSMutableArray *mutPlaceNameArr = [[NSMutableArray alloc] initWithArray:self.latestTourpicPlaceNameArr];
        
        //如果数据中有该地名了，删掉
        for (int i=0; i<mutPlaceNameArr.count; i++){
            if ([placeName isEqualToString:[mutPlaceNameArr objectAtIndex:i]]) {
                [mutPlaceNameArr removeObjectAtIndex:i];
                break;
            }
        }
        //新地名插到第一个
        [mutPlaceNameArr insertObject:placeName atIndex:0];
        //如果数组长度过长，截断
        if (mutPlaceNameArr.count > 3) {
            self.latestTourpicPlaceNameArr = [mutPlaceNameArr subarrayWithRange:NSMakeRange(0, 3)];
        }else{
            self.latestTourpicPlaceNameArr = mutPlaceNameArr;
        }
    }
}


@end
