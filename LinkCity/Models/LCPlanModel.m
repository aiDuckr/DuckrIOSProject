//
//  LCPlanModel.m
//  LinkCity
//
//  Created by roy on 2/11/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCPlanModel.h"
#import "LCDateUtil.h"
#import "LCHomeCellModel.h"

//NSString *const refundIntroductionStringKey = @"RefundIntro";
NSString *const plantagsIndexArrayKey = @"PlanTags";
NSString *const favorNumberCountKey = @"FavorNum";
NSString *const routeTypeKey = @"Type";
NSString *const planTipsKey = @"PlanTip";
NSString *const FavorUserListKey = @"FavorUsers";
NSString *const routePlacesKey = @"RoutePlaces";
NSString *const refundIntroKey = @"RefundIntro";
NSString *const sexLimitKey = @"SexLimit";

@implementation LCPlanModel

#pragma mark - Public Interface
+ (instancetype)createEmptyPlanForEdit{
    LCPlanModel *planModel = [[LCPlanModel alloc] init];
    
    //如果是个人，人数上限传空
    //如果是领队，使用最大值
    planModel.scaleMax = -1;
    if ([[LCDataManager sharedInstance].userInfo isMerchant]) {
        planModel.scaleMax = 50;
        
        //根据包车、领队认证默认选中服务
        if ([LCDataManager sharedInstance].userInfo.isCarVerify == LCIdentityStatus_Done) {
            planModel.isProvideCar = YES;
            planModel.isProvideTourGuide = NO;
        }else if([LCDataManager sharedInstance].userInfo.isTourGuideVerify == LCIdentityStatus_Done){
            planModel.isProvideCar = NO;
            planModel.isProvideTourGuide = YES;
        }else{
            planModel.isProvideCar = NO;
            planModel.isProvideTourGuide = NO;
        }
    }
    
    //初始化分期，并添加内容为空的第一期
    planModel.stageArray = [[NSMutableArray alloc] init];
    [planModel.stageArray addObject:[[LCPartnerStageModel alloc] init]];
    
    //天数默认设为1天
    planModel.daysLong = 1;
    
    planModel.isNeedIdentity = NO;
    planModel.isNeedReview = NO;
    planModel.isAllowPhoneContact = YES;
    
    planModel.userRouteId = -1;
    
    //优先用定位位置，如果没有使用常在地，否则使用空
    if ([[LCDataManager sharedInstance].userLocation isUserLocationValid] &&
        [LCStringUtil isNotNullString:[LCDataManager sharedInstance].userLocation.cityName]) {
        planModel.departName = [LCDataManager sharedInstance].userLocation.cityName;
    }else if([LCStringUtil isNotNullString:[LCDataManager sharedInstance].userInfo.livingPlace]) {
        planModel.departName = [LCDataManager sharedInstance].userInfo.livingPlace;
    }else{
        planModel.departName = @"";
    }
    
    planModel.costPrice = [NSDecimalNumber zero];
    planModel.costInclude = nil;
    planModel.costExclude = nil;
    
    planModel.costRadio = nil;
    
    
    return planModel;
}

#pragma mark RouteTheme Functions
- (void)addRouteTheme:(LCRouteThemeModel *)theme{
    NSMutableArray *themes = [NSMutableArray arrayWithArray:self.tourThemes];
    if (!themes) {
        themes = [[NSMutableArray alloc] init];
    }
    [themes addObject:theme];
    self.tourThemes = themes;
}
- (void)removeRouteTheme:(NSInteger)themeID{
    NSMutableArray *themes = [NSMutableArray arrayWithArray:self.tourThemes];
    if (themes && themes.count>0) {
        for (LCRouteThemeModel *theme in themes){
            if (theme.tourThemeId == themeID) {
                [themes removeObject:theme];
                break;
            }
        }
    }
    self.tourThemes = themes;
}
- (BOOL)haveTheme:(NSInteger)themeID{
    if (self.tourThemes && self.tourThemes.count>0) {
        for (LCRouteThemeModel *theme in self.tourThemes){
            if (theme.tourThemeId == themeID) {
                return YES;
            }
        }
    }
    
    return NO;
}


#pragma mark Stage
- (void)addStage:(LCPartnerStageModel *)stage{
    [self.stageArray addObject:stage];
}
- (void)removeStageAtIndex:(NSInteger)stageIndex{
    if (stageIndex < self.stageArray.count) {
        [self.stageArray removeObjectAtIndex:stageIndex];
    }
}

#pragma mark Stage Operation
- (void)setFirstStageStartTime:(NSString *)startTime{
    if (self.stageArray.count < 1) {
        [self.stageArray addObject:[[LCPartnerStageModel alloc] init]];
    }
    
    LCPartnerStageModel *stage = [self.stageArray firstObject];
    stage.startTime = startTime;
}
- (void)setFirstStageEndTime:(NSString *)endTime{
    if (self.stageArray.count < 1) {
        [self.stageArray addObject:[[LCPartnerStageModel alloc] init]];
    }
    
    LCPartnerStageModel *stage = [self.stageArray firstObject];
    stage.endTime = endTime;
}
- (void)setFirstStagePrice:(NSDecimalNumber *)price{
    if (self.stageArray.count < 1) {
        [self.stageArray addObject:[[LCPartnerStageModel alloc] init]];
    }
    
    LCPartnerStageModel *stage = [self.stageArray firstObject];
    stage.price = price;
}
- (NSString *)getFirstStageStartTime{
    NSString *ret = nil;
    if (self.stageArray.count > 0) {
        LCPartnerStageModel *stage = [self.stageArray firstObject];
        ret = stage.startTime;
    }
    return ret;
}
- (NSString *)getFirstStageEndTime{
    NSString *ret = nil;
    if (self.stageArray.count > 0) {
        LCPartnerStageModel *stage = [self.stageArray firstObject];
        ret = stage.endTime;
    }
    return ret;
}
- (NSDecimalNumber *)getFirstStagePrice{
    NSDecimalNumber *price = nil;
    if (self.stageArray.count > 0) {
        LCPartnerStageModel *stage = [self.stageArray firstObject];
        price = stage.price;
    }
    return price;
}


#pragma mark NetRequest
- (NSMutableDictionary *)getDicForNetRequest{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    
    if ([LCStringUtil isNotNullString:self.planGuid]) {
        [paramDic setObject:self.planGuid forKey:@"PlanGuid"];
    }
    if (self.tourThemes && self.tourThemes.count>0) {
        NSMutableArray *tourIDArray = [[NSMutableArray alloc]init];
        for (LCRouteThemeModel *routeTheme in self.tourThemes){
            [tourIDArray addObject:[NSNumber numberWithInteger:routeTheme.tourThemeId]];
        }
        NSString *themesStr = [LCStringUtil getJsonStrFromArray:tourIDArray];
        [paramDic setObject:themesStr forKey:@"ThemeIds"];
    }
    
    if ([LCStringUtil isNotNullString:self.departName]) {
        [paramDic setObject:self.departName forKey:@"DepartName"];
    }
    if (self.destinationNames && self.destinationNames.count > 0) {
        NSString *destinationNamesStr = [LCStringUtil getJsonStrFromArray:self.destinationNames];
        [paramDic setObject:destinationNamesStr forKey:@"DestPlaces"];
    }
    
    if (self.photoUrls && self.photoUrls.count > 0) {
        NSMutableArray *urlArray = [[NSMutableArray alloc]init];
        for (NSString *photoUrl in self.photoUrls){
            [urlArray addObject:photoUrl];
        }
        NSString *themesStr = [LCStringUtil getJsonStrFromArray:urlArray];
        [paramDic setObject:themesStr forKey:@"PhotoUrls"];
    }
    if (self.selectedThemeArr && self.selectedThemeArr.count > 0) {
        NSMutableArray *mutArr = [[NSMutableArray alloc]init];
        [mutArr addObject:[NSNumber numberWithInteger:UrbanThemeId]];
        for (LCRouteThemeModel *routeTheme in self.selectedThemeArr) {
            [mutArr addObject:[NSNumber numberWithInteger:routeTheme.tourThemeId]];
        }
        NSString *themesStr = [LCStringUtil getJsonStrFromArray:mutArr];
        [paramDic setObject:themesStr forKey:@"ThemeIds"];
    }
    
    
    if (self.tagsArray && self.tagsArray.count > 0) {
        NSMutableArray *mutArr = [[NSMutableArray alloc]init];
        for (LCRouteThemeModel *routeTheme in self.tagsArray){
            [mutArr addObject:[NSNumber numberWithInteger:routeTheme.tourThemeId]];
        }
        NSString *themesStr = [LCStringUtil getJsonStrFromArray:mutArr];
        [paramDic setObject:themesStr forKey:@"TagIds"];
    }
    [paramDic setObject:[NSNumber numberWithInteger:self.genderLimit] forKey:@"SexLimit"];
    [paramDic setObject:[NSNumber numberWithInteger:self.routeType] forKey:@"Type"];
    [paramDic setObject:self.startTime forKey:@"StartTime"];
    [paramDic setObject:[NSNumber numberWithInteger:self.daysLong] forKey:@"DaysLong"];
    
    //如果有设置scaleMax，即大于等于0时，上传参数
    if (self.scaleMax >= 0) {
        [paramDic setObject:[NSNumber numberWithInteger:self.scaleMax] forKey:@"ScaleMax"];
    }
    
    if ([LCStringUtil isNotNullString:self.descriptionStr]) {
        [paramDic setObject:self.descriptionStr forKey:@"Description"];
    }
    
    if ([LCStringUtil isNotNullString:self.participateNote]) {
        [paramDic setObject:self.participateNote forKey:@"ParticipateNote"];
    }
    
    if ([LCStringUtil isNotNullString:self.firstPhotoUrl]) {
        [paramDic setObject:self.firstPhotoUrl forKey:@"FirstPhotoUrl"];
    }
    if ([LCStringUtil isNotNullString:self.secondPhotoUrl]) {
        [paramDic setObject:self.secondPhotoUrl forKey:@"SecondPhotoUrl"];
    }
    if ([LCStringUtil isNotNullString:self.thirdPhotoUrl]) {
        [paramDic setObject:self.thirdPhotoUrl forKey:@"ThirdPhotoUrl"];
    }
    
    
    [paramDic setObject:[NSNumber numberWithInteger:self.isProvideTourGuide] forKey:@"IsProvideTourGuide"];
    [paramDic setObject:[NSNumber numberWithInteger:self.isProvideCar] forKey:@"IsProvideCar"];
    [paramDic setObject:[NSNumber numberWithInteger:self.isNeedReview] forKey:@"IsNeedReview"];
    [paramDic setObject:[NSNumber numberWithInteger:self.isNeedIdentity] forKey:@"IsNeedIdentity"];
    [paramDic setObject:[NSNumber numberWithInteger:self.isAllowPhoneContact] forKey:@"IsAllowPhoneContact"];
    
    if ([LCStringUtil isNotNullString:self.publishPlace]) {
        [paramDic setObject:self.publishPlace forKey:@"PublishPlace"];
    }
    
    if (self.userRouteId >= 0) {
        [paramDic setObject:[NSString stringWithFormat:@"%ld",(long)self.userRouteId] forKey:@"UserRouteId"];
    }
    
    if ([[LCDataManager sharedInstance].userLocation isUserLocationValid]) {
        // 有位置
        [paramDic setObject:[NSNumber numberWithDouble:[LCDataManager sharedInstance].userLocation.lat] forKey:@"Lat"];
        [paramDic setObject:[NSNumber numberWithDouble:[LCDataManager sharedInstance].userLocation.lng] forKey:@"Lng"];
        //[paramDic setObject:[NSNumber numberWithInteger:[LCDataManager sharedInstance].userLocation.type] forKey:@"LocationType"];
    }else{
        // 无位置
    }
    
    if ([LCStringUtil isNotNullString:self.costInclude]) {
        [paramDic setObject:self.costInclude forKey:@"CostInclude"];
    }
    if ([LCStringUtil isNotNullString:self.costExclude]) {
        [paramDic setObject:self.costExclude forKey:@"CostExclude"];
    }
    
    if ([LCDecimalUtil isOverZero:self.costRadio]) {
        [paramDic setObject:self.costRadio forKey:@"CostRatio"];
    }
    
    //StageArray
    if (self.stageArray && self.stageArray.count > 0) {
        NSMutableArray *stageDicArray = [[NSMutableArray alloc] init];
        for (LCPartnerStageModel *aStage in self.stageArray){
            NSMutableDictionary *aStageDic = [[NSMutableDictionary alloc] init];
            if ([LCStringUtil isNotNullString:aStage.startTime]) {
                [aStageDic setObject:aStage.startTime forKey:@"StartTime"];
            }
            if ([LCStringUtil isNotNullString:aStage.endTime]) {
                [aStageDic setObject:aStage.endTime forKey:@"EndTime"];
            }
            if ([LCDecimalUtil isOverZero:aStage.price]) {
                [aStageDic setObject:aStage.price forKey:@"Price"];
            }
            [stageDicArray addObject:aStageDic];
        }
        
        NSString *stageStr = [LCStringUtil getJsonStrFromArray:stageDicArray];
        if ([LCStringUtil isNotNullString:stageStr]) {
            [paramDic setObject:stageStr forKey:@"Stage"];
        }
    }
    
    if ([LCStringUtil isNotNullString:self.declaration]) {
        [paramDic setObject:self.declaration forKey:@"Declaration"];
    }
    
    if ([LCStringUtil isNotNullString:self.gatherTime]) {
        [paramDic setObject:self.gatherTime forKey:@"GatherTime"];
    }
    
    if ([LCStringUtil isNotNullString:self.gatherPlace]) {
        [paramDic setObject:self.gatherPlace forKey:@"GatherPlace"];
    }

    return paramDic;
}

- (NSArray *)showThemeArr {
    if (nil == _showThemeArr) {
        NSMutableArray *mutArr = [[NSMutableArray alloc] initWithArray:self.tourThemes];
        [mutArr addObjectsFromArray:self.tagsArray];
        _showThemeArr = mutArr;
    }
    if (nil == _showThemeArr) {
        _showThemeArr = [[NSArray alloc] init];
    }
    return _showThemeArr;
}

#pragma mark Set & Get
- (void)setCostPrice:(NSDecimalNumber *)costPrice{
    if ([costPrice compare:[NSDecimalNumber notANumber]] == NSOrderedSame) {
        costPrice = [NSDecimalNumber zero];
    }
    
    _costPrice = costPrice;
}

- (NSArray *)stageArray{
    if (!_stageArray) {
        _stageArray = [[NSMutableArray alloc] init];
    }
    return _stageArray;
}

#pragma mark -
- (NSString *)getPlanTimeString{
    NSString *startStr = [LCDateUtil getDotDateFromHorizontalLineStr:self.startTime];
    return [startStr stringByAppendingFormat:@"  全程%ld天",(long)self.daysLong];
}

- (NSInteger)getRouteDayNum{
    NSInteger dayNum;
    if (self.userRoute.routePlaces && self.userRoute.routePlaces.count>0) {
        LCRoutePlaceModel *aPlace = [self.userRoute.routePlaces lastObject];
        dayNum = aPlace.routeDay;
    }else{
        dayNum = 0;
    }
    
    LCLogInfo(@"getRouteDayNum: %ld",(long)dayNum);
    return dayNum;
}
- (NSString *)getDestinationsStringWithSeparator:(NSString *)sep{
    __block NSString *destinationStr = @"";
    [self.destinationNames enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx !=0) {
            destinationStr = [destinationStr stringByAppendingString:sep];
        }
        destinationStr = [destinationStr stringByAppendingString:(NSString *)obj];
    }];
    
    return destinationStr;
}

- (NSString *)getDepartAndDestString {
    NSString *departAndDestStr = @"";
    if ([LCStringUtil isNotNullString:self.departName]) {
        departAndDestStr = [departAndDestStr stringByAppendingFormat:@"%@",self.departName];
    }
    switch (self.routeType) {
        case LCPlanType_FreeLocal: {
            if (self.destinationNames.count >= 1) {
                departAndDestStr = [NSString stringWithFormat:@"%@ - %@", departAndDestStr, self.destinationNames[0]];
            }
        }
            break;
        case LCPlanType_CostLocal: {
            departAndDestStr = self.destinationNames[0];
        }
            break;
        case LCPlanType_CostPlan:
        case LCPlanType_FreePlan: {
            for (int i = 0; i < self.destinationNames.count; i++) {
                NSString *destName = self.destinationNames[i];
                if ([LCStringUtil isNotNullString:departAndDestStr]) {
                    departAndDestStr = [departAndDestStr stringByAppendingFormat:@" - %@", destName];
                }else{
                    departAndDestStr = [departAndDestStr stringByAppendingString:destName];
                }
            }
        }
            break;
        default:
            break;
    }
    departAndDestStr = [LCStringUtil getNotNullStr:departAndDestStr];
    return departAndDestStr;
}

- (NSString *)getStartEndTimeText {
    NSString *resStr = @"";
    NSString *startDayStr = [LCDateUtil getMonthDayByDateStr:self.startTime];
    
    switch (self.routeType) {
        case LCPlanType_FreePlan: {
            resStr = [NSString stringWithFormat:@"%@出发  全程%zd天", startDayStr, self.daysLong];
        }
            break;
        case LCPlanType_CostPlan: {
            resStr = [self getPlanStartDateText];
        }
            
        case LCPlanType_FreeLocal: {
            resStr = [self getFreeLocalStartEndText];
        }
            break;
        case LCPlanType_CostLocal: {
            resStr = [self getPlanStartDateText];
        }
            break;
        default:
            break;
    }
    resStr = [LCStringUtil getNotNullStr:resStr];
    return resStr;
}

- (NSString *)getFreeLocalStartEndText {
    NSString *resStr = @"";
    NSArray *arr = [LCStringUtil splitStrBySpace:self.startTime];
    if (nil != arr && 2 == arr.count) {
        resStr = [NSString stringWithFormat:@"%@  %@  %@开始", arr[0], [LCDateUtil getWeekStrByDateStr:arr[0]], arr[1]];
    }
    resStr = [LCStringUtil getNotNullStr:resStr];
    return resStr;
}

- (NSString *)getSingleStartDateText {
    NSString *timeStr = [NSString stringWithFormat:@"%@ 全程%ld天",
                         [LCDateUtil getDotDateFromHorizontalLineStr:self.startTime],
                         (long)self.daysLong];
    return timeStr;
}

- (NSString *)getPlanStartDateText {
    NSString *timeStr = @"";//商品如果只有一天且是多期，就只显示多期，不显示“全程1天”；如果是单期活动且只有一天，那就显示具体的日期；如果是单期活动，连续三天，那就显示xx月xx日 —— xx月xx日
    if (self.canSelectedStage && self.canSelectedStage.count > 1) {//商品多期，就只显示多期活动
        timeStr = [NSString stringWithFormat:@"多期活动"];
    }
    else if(self.canSelectedStage && self.canSelectedStage.count == 1 &&self.daysLong > 1) {//如果是单期活动，连续三天，那就显示xx月xx日 —— xx月xx日
        timeStr = [NSString stringWithFormat:@"%@ - %@", [LCDateUtil getMonthAndDayStrfromStr:self.startTime], [LCDateUtil getMonthAndDayStrfromStr:self.endTime]];
    }
    else if(self.canSelectedStage && self.canSelectedStage.count == 1 &&self.daysLong == 1){//；如果是单期活动且只有一天,那就显示具体的日期
        timeStr = [NSString stringWithFormat:@"%@ %@", [LCDateUtil getMonthAndDayStrfromStr:self.startTime],[LCDateUtil getHourAndMinuteStrfromStr:self.gatherTime]];
    }
    else {//多期多天
        timeStr = [NSString stringWithFormat:@"多期活动"];
    }
    return timeStr;
}

- (NSString *)getPlanLastDateText {
    NSString *timeStr = @"";
    if (self.canSelectedStage && self.canSelectedStage.count > 1) {
        timeStr = [NSString stringWithFormat:@"全程%ld天 多期活动", (long)self.daysLong];
    } else {
        timeStr = [NSString stringWithFormat:@"%@ 全程%ld天", [LCDateUtil getMonthAndDayStrfromStr:self.startTime], (long)self.daysLong];
    }
    return timeStr;
}

- (NSString *)getPlanCostPerPerson {
    NSString *priceStr = [NSString stringWithFormat:@"￥%@起/人", _costPrice];
    return priceStr;
}

- (NSString *)getPlanCostPerPersonForUserOrder {
    NSString *priceStr = [NSString stringWithFormat:@"￥%@/人", _costPrice];
    return priceStr;
}

- (NSString *)getPlanCostAndMemberNumberText {
    NSString *returnStr = [self getPlanCostPerPerson];
    if (self.userNum > 0) {
        returnStr = [returnStr stringByAppendingFormat:@"  %ld人已报名", (long)self.userNum];
    }
    return returnStr;
}

+ (NSArray *)getDestinationsStringArrayWithSeparator:(NSString *)sep fromString:(NSString *)destinationsString{
    if ([LCStringUtil isNotNullString:sep]) {
        return [destinationsString componentsSeparatedByString:sep];
    }else{
        return nil;
    }
}

- (NSString *)getRoutePlaceStringForDay:(NSInteger)routeDay withSeparator:(NSString *)sep{
    return [self.userRoute getRoutePlaceStringForDay:routeDay withSeparator:sep];
}


- (LCPlanRelation)getPlanRelation{
    LCPlanRelation ret = LCPlanRelationScanner;
    
    switch (self.relation) {
        case 0:
            ret = LCPlanRelationScanner;
            break;
        case 1:
            ret = LCPlanRelationCreater;
            break;
        case 2:
            ret = LCPlanRelationMember;
            break;
        case 3:
            ret = LCPlanRelationApplying;
            break;
        case 4:
            ret = LCPlanRelationRejected;
            break;
        case 5:
            ret = LCPlanRelationKicked;
            break;
    }
    
    return ret;
}

- (BOOL)isCreater:(LCUserModel *)user{
    BOOL ret = NO;
    
    LCUserModel *creater = nil;
    if (self.memberList && self.memberList.count>0) {
        creater = [self.memberList firstObject];
    }
    
    if (creater && [user.uUID isEqualToString:creater.uUID]) {
        ret = YES;
    }
    
    return ret;
}

/// v3.3删除了[LCStringUtil isNullString:self.descriptionStr].

- (BOOL)isEmptyPlan{
    if ([LCStringUtil isNullString:self.startTime] &&
        [LCStringUtil isNullString:self.endTime]) {
        return YES;
    }
    return NO;
}

- (BOOL)isMerchantCostPlan{
    if (self.memberList.count > 0) {
        LCUserModel *creater = [self.memberList firstObject];
        if (creater.isTourGuideVerify == LCIdentityStatus_Done &&
            ![self isFreePlan]) {
            return YES;
        }
    }
    
    return NO;
}
- (BOOL)isFreePlan{
    if ([LCDecimalUtil isOverZero:self.costPrice]) {
        return NO;
    }else{
        return YES;
    }
}

- (BOOL)isStagePlan {
    if (self.canSelectedStage && self.canSelectedStage.count > 1) {
        return YES;
    }
    return NO;
}

- (NSInteger)getCurStageIndex{
    NSInteger curIndex = -1;
    for (int i=0; i<self.stageArray.count; i++){
        LCPartnerStageModel *aStage = self.stageArray[i];
        if ([self.planGuid isEqualToString:aStage.planGuid]) {
            curIndex = i;
            break;
        }
    }
    return curIndex;
}

- (BOOL)isUrbanPlan {
    if (LCPlanType_FreeLocal == self.routeType || LCPlanType_CostLocal == self.routeType) {
        return YES;
    }
    return NO;
}

- (BOOL)isCostCarryPlan{
    for (LCRouteThemeModel *theme in self.tourThemes){
        if (theme.tourThemeId == CostCarryThemeId) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isFreeCarryPlan{
    for (LCRouteThemeModel *theme in self.tourThemes){
        if (theme.tourThemeId == FreeCarryThemeId) {
            return YES;
        }
    }
    return NO;
}


- (NSInteger)getCurPlanTotalOrderNumber{
    if ([LCDecimalUtil isOverZero:self.costPrice]) {
        //收费邀约
        return self.totalOrderNumber+1;
    }else{
        //普通邀约
        return self.userNum;
    }
}


+ (NSMutableArray *)addAndFiltDuplicateStagePlanArr:(NSArray *)planArr toOriginalPlanArr:(NSArray *)originalPlanArr{
    NSMutableArray *retArr = [NSMutableArray new];
    if (originalPlanArr.count > 0) {
        [retArr addObjectsFromArray:originalPlanArr];
    }
    
    [planArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[LCPlanModel class]]) {
            LCPlanModel *aPlan = (LCPlanModel *)obj;
            if (![self isStageMaster:aPlan.stageMaster inPlanArray:retArr]) {
                [retArr addObject:obj];
            }
        }else if([obj isKindOfClass:[LCHomeCellModel class]]){
            LCHomeCellModel *homeModel = (LCHomeCellModel *)obj;
            if ([homeModel getCellType] == LCHomeCellType_Plan) {
                LCPlanModel *aPlan = homeModel.partnerPlan;
                if (![self isStageMaster:aPlan.stageMaster inPlanArray:retArr]) {
                    [retArr addObject:obj];
                }
            }else{
                [retArr addObject:obj];
            }
        }else{
            [retArr addObject:obj];
        }
    }];
    
    return retArr;
}

+ (NSArray *)getDestinationArrayByString:(NSString *)destinationStr{
    if ([LCStringUtil isNullString:destinationStr]) {
        return nil;
    }
    
    NSArray *splitStrArray = [destinationStr componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@",/; :，、；：\u00a0"]];
    return splitStrArray;
}

+ (BOOL)isStageMaster:(NSString *)stageMaster inPlanArray:(NSArray *)planArray{
    BOOL ret = NO;
    
    for (id obj in planArray){
        if ([obj isKindOfClass:[LCPlanModel class]]) {
            LCPlanModel *aPlan = (LCPlanModel *)obj;
            if ([aPlan.stageMaster isEqualToString:stageMaster]) {
                ret = YES;
                break;
            }
        }else if([obj isKindOfClass:[LCHomeCellModel class]]){
            LCHomeCellModel *homeModel = (LCHomeCellModel *)obj;
            if ([homeModel getCellType] == LCHomeCellType_Plan) {
                LCPlanModel *aPlan = homeModel.partnerPlan;
                if ([aPlan.stageMaster isEqualToString:stageMaster]) {
                    ret = YES;
                    break;
                }
            }
        }
    }
    
    return ret;
}

- (NSDecimalNumber *)lowestPrice {
    if (nil == _lowestPrice) {
        NSArray *stages = self.canSelectedStage;
        for (LCPartnerStageModel *stage in stages) {
            if (nil == _lowestPrice) {
                _lowestPrice = stage.price;
                continue ;
            }
            if (stage.price < _lowestPrice) {
                _lowestPrice = stage.price;
            }
        }
        if (nil == _lowestPrice) {
            _lowestPrice = [NSDecimalNumber decimalNumberWithString:@"0.00"];
        }
    }
    return _lowestPrice;
}

- (NSArray *)canSelectedStage {
    if (nil == _canSelectedStage) {
        NSMutableArray *selectableStageArray = [[NSMutableArray alloc] init];
        for (LCPartnerStageModel *stage in self.stageArray){
            NSDate *startTime = [LCDateUtil dateFromString:stage.startTime];
            
            BOOL canBuy = NO;
            if (startTime && [startTime timeIntervalSinceNow] > 0-SEC_PER_DAY && stage.joinNumber < stage.totalNumber) {
                
                canBuy = YES;
            }
            
            if (canBuy) {
                [selectableStageArray addObject:stage];
            }
        }
        return selectableStageArray;
    }
    return [[NSArray alloc] init];
}

#pragma mark - Init and Encode Decode
- (id)initWithDictionary:(NSDictionary *)dic {
    self = [super initWithDictionary:dic];
    if (self) {
        self.roomTitle = [LCStringUtil getNotNullStr:[dic objectForKey:@"RoomTitle"]];
        self.updatedTime = [LCStringUtil getNotNullStr:[dic objectForKey:@"UpdatedTime"]];
        NSNumber *isNeedIdentityNum = [dic objectForKey:@"IsNeedIdentity"];
        self.isNeedIdentity = [isNeedIdentityNum integerValue];
        self.planShareTitle = [LCStringUtil getNotNullStr:[dic objectForKey:@"PlanShareTitle"]];
        self.orderStr = [LCStringUtil getNotNullStr:[dic objectForKey:@"OrderStr"]];
        self.departName = [LCStringUtil getNotNullStr:[dic objectForKey:@"DepartName"]];
        
        self.userRoute = [[LCUserRouteModel alloc] initWithDictionary:[dic dicOfObjectForKey:@"UserRoute"]];
        
        NSNumber *browseNumberNum = [dic objectForKey:@"BrowseNumber"];
        self.browseNumber = [browseNumberNum integerValue];
        self.roomAvatar = [LCStringUtil getNotNullStr:[dic objectForKey:@"RoomAvatar"]];
        NSNumber *commentNumberNum = [dic objectForKey:@"CommentNumber"];
        self.commentNumber = [commentNumberNum integerValue];
        NSNumber *scaleMaxNum = [dic objectForKey:@"ScaleMax"];
        self.scaleMax = [scaleMaxNum integerValue];
        NSNumber *isProvideCarNum = [dic objectForKey:@"IsProvideCar"];
        self.isProvideCar = [isProvideCarNum integerValue];
        self.carIdentity = [[LCCarIdentityModel alloc] initWithDictionary:[dic objectForKey:@"CarIdentity"]];
        NSNumber *userRouteIdNum = [dic objectForKey:@"UserRouteId"];
        self.userRouteId = [userRouteIdNum integerValue];
        self.thirdPhotoUrl = [LCStringUtil getNotNullStr:[dic objectForKey:@"ThirdPhotoUrl"]];
        self.publishPlace = [LCStringUtil getNotNullStr:[dic objectForKey:@"PublishPlace"]];
        self.secondPhotoUrl = [LCStringUtil getNotNullStr:[dic objectForKey:@"SecondPhotoUrl"]];
        self.endTime = [LCStringUtil getNotNullStr:[dic objectForKey:@"EndTime"]];
        NSNumber *unreadCommentNumNum = [dic objectForKey:@"UnreadCommentNum"];
        self.unreadCommentNum = [unreadCommentNumNum integerValue];
        NSNumber *isNeedReviewNum = [dic objectForKey:@"IsNeedReview"];
        self.isNeedReview = [isNeedReviewNum integerValue];
        self.roomId = [LCStringUtil getNotNullStr:[dic objectForKey:@"RoomId"]];
        
        NSMutableArray *memberArray = [[NSMutableArray alloc]initWithCapacity:0];
        for (NSDictionary *memberDic in [dic arrayForKey:@"MemberList"]) {
            LCUserModel *userModel = [[LCUserModel alloc] initWithDictionary:memberDic];
            if (userModel) {
                [memberArray addObject:userModel];
            }
        }
        self.memberList = memberArray;
        
        NSMutableArray *applyingArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSDictionary *applyingDic in [dic arrayForKey:@"ApplyingList"]) {
            LCUserModel *userModel = [[LCUserModel alloc] initWithDictionary:applyingDic];
            if (userModel) {
                [applyingArray addObject:userModel];
            }
        }
        self.applyingList = applyingArray;
        
        NSNumber *isCheckedInNum = [dic objectForKey:@"IsCheckedIn"];
        self.isCheckedIn = [isCheckedInNum integerValue];
        NSNumber *isEvaluedNum = [dic objectForKey:@"IsEvalued"];
        self.isEvalued = [isEvaluedNum integerValue];
        self.firstPhotoUrl = [LCStringUtil getNotNullStr:[dic objectForKey:@"FirstPhotoUrl"]];
        self.secondPhotoThumbUrl = [LCStringUtil getNotNullStr:[dic objectForKey:@"SecondPhotoThumbUrl"]];
        NSNumber *userNumNum = [dic objectForKey:@"UserNum"];
        self.userNum = [userNumNum integerValue];
        self.planShareUrl = [LCStringUtil getNotNullStr:[dic objectForKey:@"PlanShareUrl"]];
        self.planGuid = [LCStringUtil getNotNullStr:[dic objectForKey:@"PlanGuid"]];
        NSNumber *daysLongNum = [dic objectForKey:@"DaysLong"];
        self.daysLong = [daysLongNum integerValue];
        if (0 == self.daysLong) {
            self.daysLong = 1;
        }
        self.createdTime = [LCStringUtil getNotNullStr:[dic objectForKey:@"CreatedTime"]];
        self.descriptionStr = [LCStringUtil getNotNullStr:[dic objectForKey:@"Description"]];
        self.participateNote = [LCStringUtil getNotNullStr:[dic objectForKey:@"ParticipateNote"]];
        NSNumber *isAllowPhoneContactNum = [dic objectForKey:@"IsAllowPhoneContact"];
        self.isAllowPhoneContact = [isAllowPhoneContactNum integerValue];
        self.startTime = [LCStringUtil getNotNullStr:[dic objectForKey:@"StartTime"]];
        self.firstPhotoThumbUrl = [LCStringUtil getNotNullStr:[dic objectForKey:@"FirstPhotoThumbUrl"]];
        
        NSMutableArray *routeThemeArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSDictionary *themeDic in [dic arrayForKey:@"TourThemes"]) {
            LCRouteThemeModel *routeTheme = [[LCRouteThemeModel alloc] initWithDictionary:themeDic];
            if (routeTheme) {
                [routeThemeArray addObject:routeTheme];
            }
        }
        self.tourThemes = routeThemeArray;
        
        NSMutableArray *commentArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSDictionary *commentDic in [dic arrayForKey:@"CommentList"]){
            LCCommentModel *aComment = [[LCCommentModel alloc] initWithDictionary:commentDic];
            if (aComment) {
                [commentArray addObject:aComment];
            }
        }
        self.commentList = commentArray;
        
        NSNumber *relationNum = [dic objectForKey:@"Relation"];
        self.relation = [relationNum integerValue];
        NSNumber *isMemberNum = [dic objectForKey:@"IsMember"];
        self.isMember = [isMemberNum integerValue];
        NSNumber *isFavoredNum = [dic objectForKey:@"IsFavored"];
        self.isFavored = [isFavoredNum integerValue];
        self.isAlert = [LCStringUtil idToNSInteger:[dic objectForKey:@"IsAlert"]];
        self.isArrived = [LCStringUtil idToNSInteger:[dic objectForKey:@"IsArrived"]];
        
        NSMutableArray *destinationNameArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSString *destinationName in [dic arrayForKey:@"DestinationNames"]){
            if (destinationName) {
                [destinationNameArray addObject:destinationName];
            }
        }
        self.destinationNames = destinationNameArray;
        
        NSNumber *isProvideTourGuideNum = [dic objectForKey:@"IsProvideTourGuide"];
        self.isProvideTourGuide = [isProvideTourGuideNum integerValue];
        self.thirdPhotoThumbUrl = [LCStringUtil getNotNullStr:[dic objectForKey:@"ThirdPhotoThumbUrl"]];
        
        self.scoreUpper = [[dic objectForKey:@"ScoreUpper"] integerValue];
        self.avgPoint = [dic objectForKey:@"AvgPoint"];
        
        self.distance = [[dic objectForKey:@"Distance"] integerValue];
        self.costInclude = [LCStringUtil getNotNullStr:[dic objectForKey:@"CostInclude"]];
        self.costExclude = [LCStringUtil getNotNullStr:[dic objectForKey:@"CostExclude"]];
        self.costPrice = [NSDecimalNumber decimalNumberWithDecimal:[[dic objectForKey:@"CostPrice"]decimalValue]];
        self.costPrice = [LCDecimalUtil getTwoDigitRoundDecimal:self.costPrice];
        self.costEarnest = [NSDecimalNumber decimalNumberWithDecimal:[[dic objectForKey:@"CostEarnest"]decimalValue]];
        self.costEarnest = [LCDecimalUtil getTwoDigitRoundDecimal:self.costEarnest];
        self.totalOrderNumber = [[dic objectForKey:@"TotalOrderNumber"] integerValue];
        self.totalEarnest = [NSDecimalNumber decimalNumberWithDecimal:[[dic objectForKey:@"TotalEarnest"]decimalValue]];
        self.totalEarnest = [LCDecimalUtil getTwoDigitRoundDecimal:self.totalEarnest];
        self.totalOrderStatus = [[dic objectForKey:@"TotalOrderStatus"] integerValue];
        self.totalStageOrderNumber = [[dic objectForKey:@"TotalStageOrderNumber"] integerValue];
        
        if ([LCDecimalUtil isOverZero:self.costPrice] &&
            [LCDecimalUtil isOverZero:self.costEarnest]) {
            self.costRadio = [self.costEarnest decimalNumberByDividingBy:self.costPrice withBehavior:[LCDecimalUtil getTwoDigitDecimalHandler]];
        }
        
        NSMutableArray *stageArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSDictionary *stageDic in [dic arrayForKey:@"Stage"]){
            LCPartnerStageModel *aStage = [[LCPartnerStageModel alloc] initWithDictionary:stageDic];
            if (aStage) {
                [stageArray addObject:aStage];
            }
        }
        self.stageArray = stageArray;
        
        self.stageMaster = [LCStringUtil getNotNullStr:[dic objectForKey:@"StageMaster"]];
        
        self.declaration = [LCStringUtil getNotNullStr:[dic objectForKey:@"Declaration"]];
        self.gatherTime = [LCStringUtil getNotNullStr:[dic objectForKey:@"GatherTime"]];
        self.gatherPlace = [LCStringUtil getNotNullStr:[dic objectForKey:@"GatherPlace"]];
        
        self.currentPlanOrderNumber = 0;
        self.currentMerchantEarning = [[NSDecimalNumber alloc] initWithFloat:0.0f];
        for (LCUserModel *user in self.memberList) {
            if (nil != user.partnerOrder) {
                self.currentPlanOrderNumber += user.partnerOrder.orderNumber;
                NSNumber *payNum = [NSNumber numberWithInteger:user.partnerOrder.orderNumber];
                NSDecimalNumber *payNumDecimal = [NSDecimalNumber decimalNumberWithDecimal:[payNum decimalValue]];
                NSDecimalNumber *totalPay = [user.partnerOrder.orderPrice decimalNumberByMultiplyingBy:payNumDecimal withBehavior:[LCDecimalUtil getTwoDigitDecimalHandler]];
                self.currentMerchantEarning = [self.currentMerchantEarning decimalNumberByAdding:totalPay];
            }
        }
        
        //5.0 新增解析
        NSMutableArray *thumbListArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSDictionary *applyingDic in [dic arrayForKey:FavorUserListKey]) {
            LCUserModel *userModel = [[LCUserModel alloc] initWithDictionary:applyingDic];
            if (userModel) {
                [thumbListArray addObject:userModel];
            }
        }
        self.favorUserArr = thumbListArray;
        
        self.favorNumber = [[dic objectForKey:favorNumberCountKey] integerValue];
        NSMutableArray *selectedTagsArray = [[NSMutableArray alloc] initWithCapacity:0];
       // NSArray *array = [dic arrayForKey:plantagsIndexArrayKey];
        for (NSDictionary *selectedTagsDic in [dic arrayForKey:plantagsIndexArrayKey]) {
            LCRouteThemeModel *userModel = [[LCRouteThemeModel alloc] initWithDictionary:selectedTagsDic];
            if (userModel) {
                [selectedTagsArray addObject:userModel];
            }
        }
        self.tagsArray = selectedTagsArray;
        NSMutableArray *photoUrlArray = [[NSMutableArray alloc] initWithCapacity:0];
        if ([LCStringUtil isNotNullString:self.firstPhotoUrl]) {
            [photoUrlArray addObject:self.firstPhotoUrl];
        }
        
        if ([LCStringUtil isNotNullString:self.secondPhotoUrl]) {
            [photoUrlArray addObject:self.secondPhotoUrl];
        }
        if ([LCStringUtil isNotNullString:self.thirdPhotoUrl]) {
            [photoUrlArray addObject:self.thirdPhotoUrl];
        }
        self.photoUrls = photoUrlArray;
        self.routeType = [[dic objectForKey:routeTypeKey] integerValue];
        self.refundIntro = [dic objectForKey:refundIntroKey];
        self.planTips = [dic objectForKey:planTipsKey];
        
        self.newOrHotType = [LCStringUtil idToNSInteger:[dic objectForKey:@"IsNewOrHot"]];
        
        
        NSMutableArray *mutArr = [[NSMutableArray alloc]initWithCapacity:0];
        for (NSDictionary *showingDic in [dic arrayForKey:@"ShowingList"]) {
            LCUserModel *userModel = [[LCUserModel alloc] initWithDictionary:showingDic];
            if (nil != userModel) {
                [mutArr addObject:userModel];
            }
        }
        self.showingList = mutArr;
        self.showingText = [LCStringUtil getNotNullStr:[dic objectForKey:@"ShowingText"]];
        self.reason = [LCStringUtil getNotNullStr:[dic objectForKey:@"RcmdReason"]];
    }
    return self;
}

- (void)encodeWithCoder: (NSCoder *)coder {
    [coder encodeObject:self.roomTitle forKey:@"RoomTitle"];
    [coder encodeObject:self.updatedTime forKey:@"UpdatedTime"];
    [coder encodeInteger:self.isNeedIdentity forKey:@"IsNeedIdentity"];
    [coder encodeObject:self.planShareTitle forKey:@"PlanShareTitle"];
    [coder encodeObject:self.orderStr forKey:@"OrderStr"];
    [coder encodeObject:self.departName forKey:@"DepartName"];
    [coder encodeObject:self.userRoute forKey:@"UserRoute"];
    [coder encodeInteger:self.browseNumber forKey:@"BrowseNumber"];
    [coder encodeObject:self.roomAvatar forKey:@"RoomAvatar"];
    [coder encodeInteger:self.commentNumber forKey:@"CommentNumber"];
    [coder encodeInteger:self.scaleMax forKey:@"ScaleMax"];
    [coder encodeInteger:self.isProvideCar forKey:@"IsProvideCar"];
    [coder encodeObject:self.carIdentity forKey:@"CarIdentity"];
    [coder encodeInteger:self.userRouteId forKey:@"UserRouteId"];
    [coder encodeObject:self.thirdPhotoUrl forKey:@"ThirdPhotoUrl"];
    [coder encodeObject:self.publishPlace forKey:@"PublishPlace"];
    [coder encodeObject:self.secondPhotoUrl forKey:@"SecondPhotoUrl"];
    [coder encodeObject:self.endTime forKey:@"EndTime"];
    [coder encodeInteger:self.unreadCommentNum forKey:@"UnreadCommentNum"];
    [coder encodeInteger:self.isNeedReview forKey:@"IsNeedReview"];
    [coder encodeInteger:self.isAlert forKey:@"IsAlert"];
    [coder encodeInteger:self.isArrived forKey:@"IsArrived"];
    [coder encodeObject:self.roomId forKey:@"RoomId"];
    [coder encodeObject:self.memberList forKey:@"MemberList"];
    [coder encodeObject:self.applyingList forKey:@"ApplyingList"];
    [coder encodeInteger:self.isCheckedIn forKey:@"IsCheckedIn"];
    [coder encodeInteger:self.isEvalued forKey:@"IsEvalued"];
    [coder encodeObject:self.firstPhotoUrl forKey:@"FirstPhotoUrl"];
    [coder encodeObject:self.secondPhotoThumbUrl forKey:@"SecondPhotoThumbUrl"];
    [coder encodeInteger:self.userNum forKey:@"UserNum"];
    [coder encodeObject:self.planShareUrl forKey:@"PlanShareUrl"];
    [coder encodeObject:self.planGuid forKey:@"PlanGuid"];
    [coder encodeInteger:self.daysLong forKey:@"DaysLong"];
    [coder encodeObject:self.createdTime forKey:@"CreatedTime"];
    [coder encodeObject:self.descriptionStr forKey:@"Description"];
    [coder encodeObject:self.participateNote forKey:@"ParticipateNote"];
    [coder encodeInteger:self.isAllowPhoneContact forKey:@"IsAllowPhoneContact"];
    [coder encodeObject:self.startTime forKey:@"StartTime"];
    [coder encodeObject:self.firstPhotoThumbUrl forKey:@"FirstPhotoThumbUrl"];
    [coder encodeObject:self.tourThemes forKey:@"TourThemes"];
    [coder encodeObject:self.commentList forKey:@"CommentList"];
    [coder encodeInteger:self.relation forKey:@"Relation"];
    [coder encodeInteger:self.isMember forKey:@"IsMember"];
    [coder encodeInteger:self.isFavored forKey:@"IsFavored"];
    [coder encodeObject:self.destinationNames forKey:@"DestinationNames"];
    [coder encodeInteger:self.isProvideTourGuide forKey:@"IsProvideTourGuide"];
    [coder encodeObject:self.thirdPhotoThumbUrl forKey:@"ThirdPhotoThumbUrl"];
    
    
    [coder encodeInteger:self.scoreUpper forKey:@"ScoreUpper"];
    [coder encodeObject:self.avgPoint forKey:@"AvgPoint"];
    [coder encodeInteger:self.distance forKey:@"Distance"];
    [coder encodeObject:self.costInclude forKey:@"CostInclude"];
    [coder encodeObject:self.costExclude forKey:@"CostExclude"];
    [coder encodeObject:self.costPrice forKey:@"CostPrice"];
    [coder encodeObject:self.costEarnest forKey:@"CostEarnest"];
    [coder encodeInteger:self.totalOrderNumber forKey:@"TotalOrderNumber"];
    [coder encodeObject:self.totalEarnest forKey:@"TotalEarnest"];
    [coder encodeInteger:self.totalOrderStatus forKey:@"TotalOrderStatus"];
    [coder encodeInteger:self.totalStageOrderNumber forKey:@"TotalStageOrderNumber"];
    
    [coder encodeObject:self.stageArray forKey:@"Stage"];
    [coder encodeObject:self.stageMaster forKey:@"StageMaster"];
    
    [coder encodeObject:self.costRadio forKey:@"CostRadio"];
    
    [coder encodeObject:self.declaration forKey:@"Declaration"];
    [coder encodeObject:self.gatherTime forKey:@"GatherTime"];
    [coder encodeObject:self.gatherPlace forKey:@"GatherPlace"];
    
    //5.0接口
    //需要接收的内容
    [coder encodeObject:self.favorUserArr forKey:FavorUserListKey];
    [coder encodeInteger:self.favorNumber forKey:favorNumberCountKey];
    [coder encodeObject:self.tagsArray forKey:plantagsIndexArrayKey];
    [coder encodeInteger:self.routeType forKey:routeTypeKey];
    //[coder encodeObject:self.routePlaces forKey:routePlacesKey];
    [coder encodeObject:self.refundIntro forKey:refundIntroKey];
    [coder encodeObject:self.planTips forKey:planTipsKey];
    [coder encodeInteger:self.newOrHotType forKey:@"IsNewOrHot"];
    [coder encodeObject:self.selectedThemeArr forKey:@"SelectedThemeArr"];
    [coder encodeObject:self.showingList forKey:@"ShowingList"];
    [coder encodeObject:self.showingText forKey:@"ShowingText"];
    [coder encodeObject:self.reason forKey:@"Reason"];
}


- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.roomTitle = [coder decodeObjectForKey:@"RoomTitle"];
        self.updatedTime = [coder decodeObjectForKey:@"UpdatedTime"];
        self.isNeedIdentity = [coder decodeIntegerForKey:@"IsNeedIdentity"];
        self.planShareTitle = [coder decodeObjectForKey:@"PlanShareTitle"];
        self.orderStr = [coder decodeObjectForKey:@"OrderStr"];
        self.departName = [coder decodeObjectForKey:@"DepartName"];
        self.userRoute = [coder decodeObjectForKey:@"UserRoute"];
        self.browseNumber = [coder decodeIntegerForKey:@"BrowseNumber"];
        self.roomAvatar = [coder decodeObjectForKey:@"RoomAvatar"];
        self.commentNumber = [coder decodeIntegerForKey:@"CommentNumber"];
        self.scaleMax = [coder decodeIntegerForKey:@"ScaleMax"];
        self.isProvideCar = [coder decodeIntegerForKey:@"IsProvideCar"];
        self.carIdentity = [coder decodeObjectForKey:@"CarIdentity"];
        self.userRouteId = [coder decodeIntegerForKey:@"UserRouteId"];
        self.thirdPhotoUrl = [coder decodeObjectForKey:@"ThirdPhotoUrl"];
        self.publishPlace = [coder decodeObjectForKey:@"PublishPlace"];
        self.secondPhotoUrl = [coder decodeObjectForKey:@"SecondPhotoUrl"];
        self.endTime = [coder decodeObjectForKey:@"EndTime"];
        self.unreadCommentNum = [coder decodeIntegerForKey:@"UnreadCommentNum"];
        self.isNeedReview = [coder decodeIntegerForKey:@"IsNeedReview"];
        self.roomId = [coder decodeObjectForKey:@"RoomId"];
        self.memberList = [coder decodeObjectForKey:@"MemberList"];
        self.applyingList = [coder decodeObjectForKey:@"ApplyingList"];
        self.isCheckedIn = [coder decodeIntegerForKey:@"IsCheckedIn"];
        self.isEvalued = [coder decodeIntegerForKey:@"IsEvalued"];
        self.firstPhotoUrl = [coder decodeObjectForKey:@"FirstPhotoUrl"];
        self.secondPhotoThumbUrl = [coder decodeObjectForKey:@"SecondPhotoThumbUrl"];
        self.userNum = [coder decodeIntegerForKey:@"UserNum"];
        self.planShareUrl = [coder decodeObjectForKey:@"PlanShareUrl"];
        self.planGuid = [coder decodeObjectForKey:@"PlanGuid"];
        self.daysLong = [coder decodeIntegerForKey:@"DaysLong"];
        self.createdTime = [coder decodeObjectForKey:@"CreatedTime"];
        self.descriptionStr = [coder decodeObjectForKey:@"Description"];
        self.participateNote = [coder decodeObjectForKey:@"ParticipateNote"];
        self.isAllowPhoneContact = [coder decodeIntegerForKey:@"IsAllowPhoneContact"];
        self.isAlert = [coder decodeIntegerForKey:@"IsAlert"];
        self.isArrived = [coder decodeIntegerForKey:@"IsArrived"];
        self.startTime = [coder decodeObjectForKey:@"StartTime"];
        self.firstPhotoThumbUrl = [coder decodeObjectForKey:@"FirstPhotoThumbUrl"];
        self.tourThemes = [coder decodeObjectForKey:@"TourThemes"];
        self.commentList = [coder decodeObjectForKey:@"CommentList"];
        self.relation = [coder decodeIntegerForKey:@"Relation"];
        self.isMember = [coder decodeIntegerForKey:@"IsMember"];
        self.isFavored = [coder decodeIntegerForKey:@"IsFavored"];
        self.destinationNames = [coder decodeObjectForKey:@"DestinationNames"];
        self.isProvideTourGuide = [coder decodeIntegerForKey:@"IsProvideTourGuide"];
        self.thirdPhotoThumbUrl = [coder decodeObjectForKey:@"ThirdPhotoThumbUrl"];
        
        
        self.scoreUpper = [coder decodeIntegerForKey:@"ScoreUpper"];
        self.avgPoint = [coder decodeObjectForKey:@"AvgPoint"];
        self.distance = [coder decodeIntegerForKey:@"Distance"];
        self.costInclude = [coder decodeObjectForKey:@"CostInclude"];
        self.costExclude = [coder decodeObjectForKey:@"CostExclude"];
        self.costPrice = [coder decodeObjectForKey:@"CostPrice"];
        self.costEarnest = [coder decodeObjectForKey:@"CostEarnest"];
        self.totalOrderNumber = [coder decodeIntegerForKey:@"TotalOrderNumber"];
        self.totalEarnest = [coder decodeObjectForKey:@"TotalEarnest"];
        self.totalOrderStatus = [coder decodeIntegerForKey:@"TotalOrderStatus"];
        self.totalStageOrderNumber = [coder decodeIntegerForKey:@"TotalStageOrderNumber"];
        
        self.stageArray = [coder decodeObjectForKey:@"Stage"];
        self.stageMaster = [coder decodeObjectForKey:@"StageMaster"];
        
        self.costRadio = [coder decodeObjectForKey:@"CostRadio"];
        
        self.declaration = [coder decodeObjectForKey:@"Declaration"];
        self.gatherPlace = [coder decodeObjectForKey:@"GatherPlace"];
        self.gatherTime = [coder decodeObjectForKey:@"GatherTime"];
        //5.0接口
        self.favorUserArr = [coder decodeObjectForKey:FavorUserListKey];
        self.favorNumber = [coder decodeIntegerForKey:favorNumberCountKey];
        self.tagsArray = [coder decodeObjectForKey:plantagsIndexArrayKey];
        self.routeType = [coder decodeIntegerForKey:routeTypeKey];
        //self.routePlaces = [coder decodeObjectForKey:routePlacesKey];
        self.refundIntro = [coder decodeObjectForKey:refundIntroKey];
        self.planTips = [coder decodeObjectForKey:planTipsKey];
        self.selectedThemeArr = [coder decodeObjectForKey:@"SelectedThemeArr"];
        self.newOrHotType = [coder decodeIntegerForKey:@"IsNewOrHot"];
        self.showingList = [coder decodeObjectForKey:@"ShowingList"];
        self.showingText = [coder decodeObjectForKey:@"ShowingText"];
        self.reason = [coder decodeObjectForKey:@"Reason"];
    }
    return self;
}
@end

