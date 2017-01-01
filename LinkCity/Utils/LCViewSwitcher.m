//
//  LCViewSwitcher.m
//  LinkCity
//
//  Created by roy on 12/3/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCViewSwitcher.h"
#import "LinkCity-Swift.h"
#import "LCHomeRecmLocalDuckrsVC.h"
#import "LCUserPlanListVC.h"
#import "LCUserInfoVC_5.h"
#import "LCCostPlanListVC.h"
#import "LCLocalCostPlanListVC.h"

@implementation LCViewSwitcher
#pragma mark Register And Login
+ (void)presentToShowRecommendUserAfterRegister{
    LCRecommendUserVC *recommendUserVC = [LCRecommendUserVC createInstance];
    [[LCSharedFuncUtil getTopMostViewController] presentViewController:[[UINavigationController alloc] initWithRootViewController:recommendUserVC] animated:YES completion:nil];
}

#pragma mark User
+ (void)pushToShowUserInfoVCForUser:(LCUserModel *)user on:(UINavigationController *)navVC{
    if ([user isMerchant] ||
        [user isCarServer]) {
        LCMerchantInfoVC *merchantInfoVC = [LCMerchantInfoVC createInstance];
        merchantInfoVC.user = user;
        [navVC pushViewController:merchantInfoVC animated:YES];
    }else{
        LCUserInfoVC_5 *userInfoVC = [LCUserInfoVC_5 createInstance];
        userInfoVC.user = user;
        [navVC pushViewController:userInfoVC animated:YES];
    }
}

+ (void)pushToShowUserEvaluationForUser:(LCUserModel *)user on:(UINavigationController *)navVC{
    LCUserEvaluationTableVC *evaluationTableVC = [LCUserEvaluationTableVC createInstance];
    evaluationTableVC.user = user;
    [navVC pushViewController:evaluationTableVC animated:YES];
}

+ (void)pushToReportUser:(LCUserModel *)user on:(UINavigationController *)navVC{
    LCReportUserVC *reportVC = [LCReportUserVC createInstance];
    reportVC.userToReport = user;
    [navVC pushViewController:reportVC animated:YES];
}


#pragma mark Plan
+ (void)pushToShowPlanDetailVCForPlan:(LCPlanModel *)plan recmdUuid:(NSString *)recmdUuid defaultTabIndex:(NSInteger)defaultTabIndex on:(UINavigationController *)navVC{
    if (!plan || [LCStringUtil isNullString:plan.planGuid]) {
        return;
    }
    
    /// 当要显示的是空计划时，是由于deeplink等跳转来的，不知道是免费还是收费邀约，显示hud，当从网络请求数据后会隐藏hud
    if ([plan isEmptyPlan]) {
        [YSAlertUtil showHudWithHint:nil];
        [LCNetRequester getPlanDetailFromPlanGuid:plan.planGuid callBack:^(LCPlanModel *plan,NSArray * tourpicArray, NSError *error) {
            [YSAlertUtil hideHud];
            if (error) {
                [YSAlertUtil tipOneMessage:error.domain];
            }else{
                [LCViewSwitcher pushToShowPlanDetailVCForPlan:plan recmdUuid:recmdUuid defaultTabIndex:defaultTabIndex on:navVC];
            }
        }];
        
        return;
    }
    
    if ([plan isMerchantCostPlan]) {
        // 跳转商家邀约详情.
        LCCostPlanDetailVC *vc = [LCCostPlanDetailVC createInstance];
        vc.plan = plan;
        vc.recmdUuid = recmdUuid;
        vc.defaultTabIndex = defaultTabIndex;
        [navVC pushViewController:vc animated:YES];
    }else{
        // 跳转普通邀约详情.
        LCFreePlanDetailVC *vc = [LCFreePlanDetailVC createInstance];
        vc.plan = plan;
        vc.recmdUuid = recmdUuid;
        [navVC pushViewController:vc animated:YES];
    }
}

+ (void)pushToShowPlanDetailVCForPlan:(LCPlanModel *)plan recmdUuid:(NSString *)recmdUuid on:(UINavigationController *)navVC{
    [self pushToShowPlanDetailVCForPlan:plan recmdUuid:recmdUuid defaultTabIndex:-1 on:navVC];
}

+ (void)pushToShowPlanMemberVCForPlan:(LCPlanModel *)plan on:(UINavigationController *)navVC{
    LCPlanMemeberVC *planMemberVC = [LCPlanMemeberVC createInstance];
    planMemberVC.plan = plan;
    [navVC pushViewController:planMemberVC animated:YES];
}
+ (void)pushToShowCommentForPlan:(LCPlanModel *)plan on:(UINavigationController *)navVC{
    LCPlanCommentTableVC *planCommentVC = [LCPlanCommentTableVC createInstance];
    planCommentVC.plan = plan;
    [navVC pushViewController:planCommentVC animated:YES];
}


+ (void)pushToShowPlanTableVCForPlace:(NSString *)planceName on:(UINavigationController *)navVC{
    LCPlanTableVC *planTableVC = [LCPlanTableVC createInstance];
    planTableVC.showingType = LCPlanTableForSearchDestination;
    planTableVC.placeName = planceName;
    [navVC pushViewController:planTableVC animated:YES];
}

+ (void)pushToShowPlanTableVCForHomePageFavorPlanOn:(UINavigationController *)navVC{
    LCPlanTableVC *planTableVC = [LCPlanTableVC createInstance];
    planTableVC.showingType = LCPlanTableForHomePageFavorPlan;
    [navVC pushViewController:planTableVC animated:YES];
}

+ (void)pushToShowCostPlanListVC:(LCHomeRcmd *)homeRcmd on:(UINavigationController *)navVC {
    LCCostPlanListVC *vc = [LCCostPlanListVC createInstance];
    vc.homeRcmd = homeRcmd;
    [navVC pushViewController:vc animated:APP_ANIMATION];
}

#pragma mark Homepage.
+ (void)pushToShowHomeRecmCostPlans:(LCHomeRecmCostPlansViewType)type on:(UINavigationController *)navVC {
    LCHomeRecmCostPlansVC *vc = [LCHomeRecmCostPlansVC createInstance];
    vc.type = type;
    [navVC pushViewController:vc animated:APP_ANIMATION];
}

+ (void)pushToShowHomeRecmHotTourpicsOn:(UINavigationController *)navVC {
    LCHomeRecmHotTourpicsVC *vc = [LCHomeRecmHotTourpicsVC createInstance];
    [navVC pushViewController:vc animated:APP_ANIMATION];
}

+ (void)pushToShowHomeRecmOnlineDuckrsOn:(UINavigationController *)navVC {
    LCHomeRecmOnlineDuckrsVC *vc = [LCHomeRecmOnlineDuckrsVC createInstance];
    [navVC pushViewController:vc animated:APP_ANIMATION];
}
+ (void)pushToShowHomeRecmLocalDuckrsOn:(UINavigationController *)navVC {
    LCHomeRecmLocalDuckrsVC *vc = [LCHomeRecmLocalDuckrsVC createInstance];
    [navVC pushViewController:vc animated:APP_ANIMATION];
}

+ (void)pushToShowThemeWithFilterWithHomeRcmd:(LCHomeRcmd *)homeRcmd on:(UINavigationController *)navVC {
    LCLocalCostPlanListVC*vc = [LCLocalCostPlanListVC createInstance];
    vc.homeRcmd = homeRcmd;
    [navVC pushViewController:vc animated:APP_ANIMATION];
}
#pragma mark SearchResult
+ (void)pushToShowPlaceSearchResultForPlace:(NSString *)placeName isDepart:(BOOL)isDepart on:(UINavigationController *)navVC{
    LCPlaceSearchResultVC *placeSearchResultVC = [LCPlaceSearchResultVC createInstance];
    placeSearchResultVC.placeName = placeName;
    [navVC pushViewController:placeSearchResultVC animated:YES];
}

+ (void)pushToShowPlaceSearchMorePlan:(NSString *)placeName on:(UINavigationController *)navVC {
    LCPlaceSearchMorePlanVC *vc = [LCPlaceSearchMorePlanVC createInstance];
    vc.placeName = placeName;
    [navVC pushViewController:vc animated:YES];
}

+ (void)pushToShowThemeSearchResultForThemeId:(NSInteger)themeId themeName:(NSString *)themeName on:(UINavigationController *)navVC{
    LCThemeSearchResultVC *themeSearchResultVC = [LCThemeSearchResultVC createInstance];
    themeSearchResultVC.themeId = themeId;
    themeSearchResultVC.themeName = themeName;
    [navVC pushViewController:themeSearchResultVC animated:YES];
}

#pragma mark Route
+ (void)pushToShowRouteDetailVCForRoute:(LCUserRouteModel *)route routeOwner:(LCUserModel *)owner editable:(BOOL)editable showDayIndex:(NSInteger)showDayIndex on:(UINavigationController *)navVC callBack:(void(^)(BOOL choose))callBack{
    LCUserRouteDetailVC *routeDetailVC = [LCUserRouteDetailVC createInstance];
    routeDetailVC.userRoute = route;
    routeDetailVC.routeOwner = owner;
    routeDetailVC.gonaShowDayIndex = showDayIndex;
    routeDetailVC.editable = editable;
    routeDetailVC.chooseCallBack = callBack;
    [navVC pushViewController:routeDetailVC animated:YES];
}

+ (void)pushToShowRouteDetailVCForRoute:(LCUserRouteModel *)route routeOwner:(LCUserModel *)owner editable:(BOOL)editable showDayIndex:(NSInteger)showDayIndex on:(UINavigationController *)navVC{
    [LCViewSwitcher pushToShowRouteDetailVCForRoute:route routeOwner:owner editable:editable showDayIndex:showDayIndex on:navVC callBack:nil];
}


+ (void)pushToShowRouteListVCOn:(UINavigationController *)navVC{
    LCUserRouteListVC *routeListVC = [LCUserRouteListVC createInstance];
    [navVC pushViewController:routeListVC animated:YES];
}

+ (void)pushToShowRouteEditVCForRoute:(LCUserRouteModel *)route editType:(LCRouteEditType)editType delegate:(id<LCPlanRouteEditVCDelegate>)delegate on:(UINavigationController *)navVC{
    LCPlanRouteEditVC *routeEditVC = [LCPlanRouteEditVC createInstance];
    if (!route) {
        route = [LCUserRouteModel createInstanceForEdit];
    }
    routeEditVC.editingUserRoute = route;
    routeEditVC.routeEditType = editType;
    routeEditVC.delegate = delegate;
    [navVC pushViewController:routeEditVC animated:YES];
}


#pragma mark Chat
+ (void)pushToShowChatGroupMemberVCForGroup:(LCChatGroupModel *)chatGroup on:(UINavigationController *)navVC{
    LCChatGroupMemberVC *groupMemberVC = [LCChatGroupMemberVC createInstance];
    groupMemberVC.chatGroup = chatGroup;
    [navVC pushViewController:groupMemberVC animated:YES];
}
+ (void)presentToShowAddFriendVCShowingTab:(LCAddFriendVCTab)showingTab{
    LCAddFriendVC *addFriendVC = [LCAddFriendVC createInstance];
    addFriendVC.showingTab = showingTab;
    [[LCSharedFuncUtil getTopMostViewController] presentViewController:[[UINavigationController alloc] initWithRootViewController:addFriendVC] animated:YES completion:nil];
}
+ (void)pushToShowChatWithUserVC:(LCUserModel *)user on:(UINavigationController *)navVC{
    LCChatWithUserVC *chatVC = [[LCChatWithUserVC alloc] initWithUser:user];
    [navVC pushViewController:chatVC animated:YES];
}
+ (LCChatWithPlanVC *)pushToShowChatWithPlanVC:(LCPlanModel *)plan on:(UINavigationController *)navVC{
    LCChatWithPlanVC *chatVC = [[LCChatWithPlanVC alloc] initWithPlan:plan];
    [navVC pushViewController:chatVC animated:YES];
    return chatVC;
}
+ (void)pushToShowChatWithGroupVC:(LCChatGroupModel *)chatGroup on:(UINavigationController *)navVC{
    LCChatWithGroupVC *chatVC = [[LCChatWithGroupVC alloc] initWithChatGroup:chatGroup];
    [navVC pushViewController:chatVC animated:YES];
}

#pragma mark - Present to show WebVC
+ (void)presentWebVCtoShowURL:(NSString *)url withTitle:(NSString *)title{
    LCWebVC *webVC= [LCWebVC createVC];
    webVC.title = title;
    webVC.webUrlStr = url;
    webVC.isPresented = YES;
    
    UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:webVC];
    [[LCSharedFuncUtil getTopMostViewController] presentViewController:navVC animated:YES completion:nil];
}
+ (void)pushWebVCtoShowURL:(NSString *)url withTitle:(NSString *)title on:(UINavigationController *)navVC{
    LCWebVC *webVC= [LCWebVC createVC];
    webVC.title = title;
    webVC.webUrlStr = url;
    webVC.isPresented = NO;
    [navVC pushViewController:webVC animated:YES];
}

#pragma mark - PhotoScanner
+ (void)presentPhotoScannerToShow:(NSArray *)photoArray fromIndex:(NSInteger)index{
    LCPhotoScanner *photoScanner = [LCPhotoScanner createInstance];
    [photoScanner showImageModels:photoArray fromIndex:index];
    [[LCSharedFuncUtil getTopMostViewController] presentViewController:photoScanner animated:YES completion:nil];
}

#pragma mark - UserTab
+ (void)pushToShowNotifyTableVCOn:(UINavigationController *)navVC{
    LCNotifyTableVC *userNotificationVC = [LCNotifyTableVC createInstance];
    [navVC pushViewController:userNotificationVC animated:YES];
}

+ (void)pushToShowOrderDetail:(LCPlanModel *)plan withType:(LCUserOrderDetailType)type on:(UINavigationController *)navVC {
    
    if (!plan || [LCStringUtil isNullString:plan.planGuid]) {
        return ;
    }
    
    /// 当要显示的是空计划时，是由于deeplink等跳转来的，不知道是免费还是收费邀约，显示hud，当从网络请求数据后会隐藏hud
    if ([plan isEmptyPlan]) {
        [YSAlertUtil showHudWithHint:nil];
        [LCNetRequester getPlanDetailFromPlanGuid:plan.planGuid callBack:^(LCPlanModel *plan,NSArray * tourpicArray, NSError *error) {
            [YSAlertUtil hideHud];
            if (error) {
                [YSAlertUtil tipOneMessage:error.domain];
            } else {
                [self pushToShowOrderDetailForPlan:plan withType:type on:navVC];
            }
        }];
        
        return;
    } else {
        [self pushToShowOrderDetailForPlan:plan withType:type on:navVC];
    }
}

+ (void)pushToShowOrderDetailForPlan:(LCPlanModel *)plan withType:(LCUserOrderDetailType)type on:(UINavigationController *)navVC {
    LCUserOrderDetailVC *vc = [LCUserOrderDetailVC createInstance];
    vc.type = type;
    vc.plan = plan;
    [navVC pushViewController:vc animated:APP_ANIMATION];
}

+ (void)pushToShowUserPlanList:(LCPlanModel *)plan on:(UINavigationController *)navVC {
    
    if (!plan || [LCStringUtil isNullString:plan.planGuid]) {
        return ;
    }
    
    /// 当要显示的是空计划时，是由于deeplink等跳转来的，不知道是免费还是收费邀约，显示hud，当从网络请求数据后会隐藏hud
    if ([plan isEmptyPlan]) {
        [YSAlertUtil showHudWithHint:nil];
        [LCNetRequester getPlanDetailFromPlanGuid:plan.planGuid callBack:^(LCPlanModel *plan,NSArray * tourpicArray, NSError *error) {
            [YSAlertUtil hideHud];
            if (error) {
                [YSAlertUtil tipOneMessage:error.domain];
            } else {
                [self pushToShowUserPlanListWithPlan:plan on:navVC];
            }
        }];
        
        return;
    } else {
        [self pushToShowUserPlanListWithPlan:plan on:navVC];
    }
}

+ (void)pushToShowUserPlanListWithPlan:(LCPlanModel *)plan on:(UINavigationController *)navVC {
    LCUserPlanListVC *vc = [LCUserPlanListVC createInstance];
    vc.plan = plan;
    [navVC pushViewController:vc animated:APP_ANIMATION];
}

#pragma mark Tourpic
+ (void)pushToShowTourPicDetail:(LCTourpic *)tourpic withType:(LCTourpicDetailVCViewType)type on:(UINavigationController *)navVC {
    LCTourpicDetailVC *vc = [LCTourpicDetailVC createInstance];
    vc.tourpic = tourpic;
    vc.type = type;
    [navVC pushViewController:vc animated:APP_ANIMATION];
}

+ (void)pushToShowTourPicTableVCForKeyWord:(NSString *)keyWord on:(UINavigationController *)navVC{
    LCTourpicTableVC *tourpicTableVC = [LCTourpicTableVC createInstance];
    tourpicTableVC.tourpicTableType = LCTourpicTableType_Search;
    tourpicTableVC.searchKeyWord = keyWord;
    [navVC pushViewController:tourpicTableVC animated:YES];
}

+ (void)pushToShowTourPicTableVCForUser:(LCUserModel *)user on:(UINavigationController *)navVC{
    LCTourpicTableVC *tourpicTableVC = [LCTourpicTableVC createInstance];
    tourpicTableVC.tourpicTableType = LCTourpicTableType_User;
    tourpicTableVC.user = user;
    [navVC pushViewController:tourpicTableVC animated:YES];
}

+ (void)pushToShowHomeCategory:(LCHomeCategoryModel *)aCategory on:(UINavigationController *)navVC {
    switch (aCategory.type) {
        case LCHomeCategoryType_BannerPlan:{
            LCPlanModel *plan = [LCPlanModel createEmptyPlanForEdit];
            plan.planGuid = aCategory.content;
            [LCViewSwitcher pushToShowPlanDetailVCForPlan:plan recmdUuid:@"" on:navVC];
        }
            break;
        case LCHomeCategoryType_BannerWeb: {
            [LCViewSwitcher presentWebVCtoShowURL:aCategory.content withTitle:aCategory.title];
        }
            break;
        case LCHomeCategoryType_BannerTheme: {
            [LCViewSwitcher pushToShowThemeSearchResultForThemeId:[LCStringUtil idToNSInteger:aCategory.content] themeName:aCategory.title on:navVC];
        }
            break;
        case LCHomeCategoryType_BannerDuckr: {
            [LCViewSwitcher presentWebVCtoShowURL:aCategory.content withTitle:aCategory.title];
        }
            break;
        case LCHomeCategoryType_Unknown:
            break;
    }
}


@end
