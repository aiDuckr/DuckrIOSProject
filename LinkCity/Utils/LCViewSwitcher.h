//
//  LCViewSwitcher.h
//  LinkCity
//
//  Created by roy on 12/3/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCUserModel.h"
#import "LCDataManager.h"
#import "LCWebVC.h"
#import "LCSharedFuncUtil.h"
#import "LCUserInfoVC.h"
#import "LCPlanModel.h"
#import "LCUserRouteModel.h"
#import "LCUserRouteDetailVC.h"
#import "LCUserRouteModel.h"
#import "LCPlanRouteEditVC.h"
#import "LCUserRouteListVC.h"
#import "LCChatGroupModel.h"
#import "LCChatGroupMemberVC.h"
#import "LCPlanMemeberVC.h"
#import "LCAddFriendVC.h"
#import "LCPhotoScanner.h"
#import "LCChatWithPlanVC.h"
#import "LCChatWithUserVC.h"
#import "LCChatWithGroupVC.h"
#import "LCPlanCommentTableVC.h"
#import "LCUserEvaluationTableVC.h"
#import "LCNotifyTableVC.h"
#import "LCRecommendUserVC.h"
#import "LCTourpicTabVC.h"
#import "LCTourpic.h"
#import "LCTourpicDetailVC.h"
#import "LCPlanTableVC.h"
#import "LCRouteThemeModel.h"
#import "LCPlaceSearchResultVC.h"
#import "LCPlaceSearchResultVC.h"
#import "LCThemeSearchResultVC.h"
#import "LCTourpicTableVC.h"
#import "LCMerchantInfoVC.h"
#import "LCFreePlanDetailVC.h"
#import "LCPlaceSearchMorePlanVC.h"
#import "LCCostPlanDetailVC.h"
#import "LCReportUserVC.h"
#import "LCUserOrderDetailVC.h"
#import "LCHomeRecmCostPlansVC.h"
#import "LCHomeRecmHotTourpicsVC.h"
#import "LCHomeRecmCostPlansVC.h"
#import "LCHomeRecmOnlineDuckrsVC.h"


@interface LCViewSwitcher : NSObject
#pragma mark Register And Login
+ (void)presentToShowRecommendUserAfterRegister;

#pragma mark UserInfo
+ (void)pushToShowUserInfoVCForUser:(LCUserModel *)user on:(UINavigationController *)navVC;
+ (void)pushToShowUserEvaluationForUser:(LCUserModel *)user on:(UINavigationController *)navVC;
+ (void)pushToReportUser:(LCUserModel *)user on:(UINavigationController *)navVC;

#pragma mark Plan
+ (void)pushToShowPlanDetailVCForPlan:(LCPlanModel *)plan recmdUuid:(NSString *)recmdUuid defaultTabIndex:(NSInteger)defaultTabIndex on:(UINavigationController *)navVC;
+ (void)pushToShowPlanDetailVCForPlan:(LCPlanModel *)plan recmdUuid:(NSString *)recmdUuid on:(UINavigationController *)navVC;
+ (void)pushToShowPlanMemberVCForPlan:(LCPlanModel *)plan on:(UINavigationController *)navVC;
+ (void)pushToShowCommentForPlan:(LCPlanModel *)plan on:(UINavigationController *)navVC;

+ (void)pushToShowPlanTableVCForPlace:(NSString *)planceName on:(UINavigationController *)navVC;
+ (void)pushToShowPlanTableVCForHomePageFavorPlanOn:(UINavigationController *)navVC;
+ (void)pushToShowCostPlanListVC:(LCHomeRcmd *)homeRcmd on:(UINavigationController *)navVC;

#pragma mark Homepage.
+ (void)pushToShowHomeRecmCostPlans:(LCHomeRecmCostPlansViewType)type on:(UINavigationController *)navVC;
+ (void)pushToShowHomeRecmHotTourpicsOn:(UINavigationController *)navVC;
+ (void)pushToShowHomeRecmOnlineDuckrsOn:(UINavigationController *)navVC;
+ (void)pushToShowHomeRecmLocalDuckrsOn:(UINavigationController *)navVC;
#pragma mark SearchResult
+ (void)pushToShowPlaceSearchResultForPlace:(NSString *)placeName isDepart:(BOOL)isDepart on:(UINavigationController *)navVC;
+ (void)pushToShowPlaceSearchMorePlan:(NSString *)placeName on:(UINavigationController *)navVC;
+ (void)pushToShowThemeSearchResultForThemeId:(NSInteger)themeId themeName:(NSString *)themeName on:(UINavigationController *)navVC;
+ (void)pushToShowThemeWithFilterWithHomeRcmd:(LCHomeRcmd *)homeRcmd on:(UINavigationController *)navVC;

#pragma mark Route
+ (void)pushToShowRouteDetailVCForRoute:(LCUserRouteModel *)route routeOwner:(LCUserModel *)owner editable:(BOOL)editable showDayIndex:(NSInteger)showDayIndex on:(UINavigationController *)navVC;
+ (void)pushToShowRouteDetailVCForRoute:(LCUserRouteModel *)route routeOwner:(LCUserModel *)owner editable:(BOOL)editable showDayIndex:(NSInteger)showDayIndex on:(UINavigationController *)navVC callBack:(void(^)(BOOL choose))callBack;
+ (void)pushToShowRouteListVCOn:(UINavigationController *)navVC;
+ (void)pushToShowRouteEditVCForRoute:(LCUserRouteModel *)route editType:(LCRouteEditType)editType delegate:(id<LCPlanRouteEditVCDelegate>)delegate on:(UINavigationController *)navVC;

#pragma mark Chat
+ (void)pushToShowChatGroupMemberVCForGroup:(LCChatGroupModel *)chatGroup on:(UINavigationController *)navVC;
+ (void)presentToShowAddFriendVCShowingTab:(LCAddFriendVCTab)showingTab;

+ (void)pushToShowChatWithUserVC:(LCUserModel *)user on:(UINavigationController *)navVC;
+ (LCChatWithPlanVC *)pushToShowChatWithPlanVC:(LCPlanModel *)plan on:(UINavigationController *)navVC;
+ (void)pushToShowChatWithGroupVC:(LCChatGroupModel *)chatGroup on:(UINavigationController *)navVC;


+ (void)presentWebVCtoShowURL:(NSString *)url withTitle:(NSString *)title;
+ (void)pushWebVCtoShowURL:(NSString *)url withTitle:(NSString *)title on:(UINavigationController *)navVC;
+ (void)presentPhotoScannerToShow:(NSArray *)photoArray fromIndex:(NSInteger)index;


#pragma mark - UserTab
+ (void)pushToShowNotifyTableVCOn:(UINavigationController *)navVC;
+ (void)pushToShowOrderDetail:(LCPlanModel *)plan withType:(LCUserOrderDetailType)type on:(UINavigationController *)navVC;
+ (void)pushToShowUserPlanList:(LCPlanModel *)plan on:(UINavigationController *)navVC;

#pragma mark - Tourpic
+ (void)pushToShowTourPicTableVCForKeyWord:(NSString *)keyWord on:(UINavigationController *)navVC;
+ (void)pushToShowTourPicTableVCForUser:(LCUserModel *)user on:(UINavigationController *)navVC;
+ (void)pushToShowTourPicDetail:(LCTourpic *)tourpic withType:(LCTourpicDetailVCViewType)type on:(UINavigationController *)navVC;

+ (void)pushToShowHomeCategory:(LCHomeCategoryModel *)aCategory on:(UINavigationController *)navVC;
@end
