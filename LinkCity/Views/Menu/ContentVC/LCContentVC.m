//
//  LCContentVC.m
//  LinkCity
//
//  Created by roy on 10/25/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCContentVC.h"
#import "LCMenuVC.h"

#define MAX_CACHE_VCNUM 10
@interface LCContentVC ()
@property (nonatomic, strong) NSMutableArray *showingVCStack;



@end

static BOOL didLayoutSubviews;  // flag of wether viewDidLayoutSubviews have been called


@implementation LCContentVC

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.statisticByMob = NO;
    didLayoutSubviews = NO;
    self.showingVCStack = [[NSMutableArray alloc]initWithCapacity:0];
    [self observeNotification];
}

- (void)dealloc{
    [self removeObserveNotification];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    didLayoutSubviews = YES;
    if (self.homeNaviagtionController) {
        self.homeNaviagtionController.view.frame = self.view.bounds;
    }

    if (self.chatNaviagtionController)
    {
        self.chatNaviagtionController.view.frame = self.view.bounds;
    }
    
    if (self.messageCenterNavigationVC)
    {
        self.messageCenterNavigationVC.view.frame = self.view.bounds;
    }
}

#pragma mark - Public Interface
- (void)showGuidePage{
//    if (!self.guidePage) {
//        self.guidePage = [LCGuideVC createInstance];
//    }
//    self.showingVC = self.guidePage;
//    
//    if (!didLayoutSubviews) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self showGuidePage];
//        });
//    }else{
//        //self.guidePage.view.frame = self.view.bounds;
//        [self presentViewController:self.guidePage animated:NO completion:nil];
//    }
    
    if (!self.guidePage) {
        self.guidePage = [LCGuideVCTwo createInstance];
        [self addPageOnContentView:self.guidePage];
    }
    [self showPageOnContentView:self.guidePage];
}

- (void)showLoginPage{
//    if (!self.loginPage) {
//        self.loginPage = [LCLoginVC createInstance];
//    }
//    self.showingVC = self.loginPage;
//     
//    if (!didLayoutSubviews) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*0.05), dispatch_get_main_queue(), ^(){
//            [self showLoginPage];
//        });
//    }else{
//        self.loginPage.view.frame = self.view.bounds;
//        [self presentViewController:self.loginPage animated:YES completion:nil];
//    }
    
    if (!self.loginPage) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        UINavigationController *naviVC = [LCLoginVC createInstance];
        [naviVC popToRootViewControllerAnimated:NO];
        self.loginPage = (LCLoginVC *)naviVC;
        [self addPageOnContentView:self.loginPage];
    }
    [self showPageOnContentView:self.loginPage];
}

- (void)showSelfPage{
    if (!self.selfNavigationController) {
        self.selfNavigationController = [LCUserInfoVC createNavigationVCInstance];
        [self addPageOnContentView:self.selfNavigationController];
    }
    LCUserInfoVC *userInfoVC = [self.selfNavigationController.viewControllers objectAtIndex:0];
    [userInfoVC showUserinfo:nil showSelfInfo:YES];
    [self showPageOnContentView:self.selfNavigationController];
}

- (void)showHomePage {
    [LCDataManager sharedInstance].isClickedMenu = YES;
    if (!self.homeNaviagtionController) {
        self.homeNaviagtionController = (UINavigationController *)[LCStoryboardManager viewControllerWithFileName:SBNameHomePage identifier:VCIDHomeNavigationVC];
        [self addPageOnContentView:self.homeNaviagtionController];
    }
    [self showPageOnContentView:self.homeNaviagtionController];
}

- (void)showParticipatedListPage{
    [LCDataManager sharedInstance].isClickedMenu = YES;
    if (!self.participatedListNavigationVC) {
        self.participatedListNavigationVC = [LCParticipatedListVC createInstance];
        [self addPageOnContentView:self.participatedListNavigationVC];
    }
    [self showPageOnContentView:self.participatedListNavigationVC];
}

- (void)showChatPage {
    [LCDataManager sharedInstance].isClickedMenu = YES;
    if (!self.chatNaviagtionController) {
        self.chatNaviagtionController = (UINavigationController *)[LCStoryboardManager viewControllerWithFileName:SBNameChat identifier:VCIDChatNavigationVC];
        [self addPageOnContentView:self.chatNaviagtionController];
    }
    [self showPageOnContentView:self.chatNaviagtionController];
}

- (void)showFavorPage {
    [LCDataManager sharedInstance].isClickedMenu = YES;
    if (!self.favorNavigationController) {
        self.favorNavigationController = [LCFavorListVC createInstance];
        [self addPageOnContentView:self.favorNavigationController];
    }
    [self showPageOnContentView:self.favorNavigationController];
}

- (void)showNearbyPage{
    [LCDataManager sharedInstance].isClickedMenu = YES;
    if (!self.nearbyUserNavigationVC) {
        self.nearbyUserNavigationVC = [LCNearbyUserVC createNavigationVCInstance];
        [self addPageOnContentView:self.nearbyUserNavigationVC];
    }
    [self showPageOnContentView:self.nearbyUserNavigationVC];
}
/// 显示消息中心.
- (void)showMessageCenterPage {
    if (!self.messageCenterNavigationVC) {
        self.messageCenterNavigationVC = (UINavigationController *)[LCStoryboardManager viewControllerWithFileName:SBMessageCenter identifier:VCIDMessageCenterNavigationVC];
        [self addPageOnContentView:self.messageCenterNavigationVC];
    }
    [self showPageOnContentView:self.messageCenterNavigationVC];
}
- (void)showPartnerPlanPage
{
    [self showHomePage];
    if (!self.searchDestinationVC)
    {
        self.searchDestinationVC = [LCSearchDestinationVC createInstance];
    }
    self.searchDestinationVC.searchType = SEARCH_DESTINATION_PARTNER;
    [self.homeNaviagtionController pushViewController:self.searchDestinationVC animated:APP_ANIMATION];
}

- (void)showReceptionPlanPage
{
    [self showHomePage];
    if (!self.searchDestinationVC)
    {
        self.searchDestinationVC = [LCSearchDestinationVC createInstance];
    }
    self.searchDestinationVC.searchType = SEARCH_DESTINATION_RECEPTION;
    [self.homeNaviagtionController pushViewController:self.searchDestinationVC animated:APP_ANIMATION];
}


- (void)hideCurrentPageWithAnimation:(BOOL)animation{
//    if (!animation) {
//        [self.view insertSubview:self.showingVC.view atIndex:self.view.subviews.count-self.showingVCNumber];
//        self.showingVC = (UIViewController *)[[self.view.subviews objectAtIndex:self.view.subviews.count-1]nextResponder];
//    }else{
//        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^(){
//            self.showingVC.view.alpha = 0;
//        } completion:^(BOOL finished){
//            [self.view insertSubview:self.showingVC.view atIndex:0];
//            self.showingVC.view.alpha = 1;
//            [self.view insertSubview:self.showingVC.view atIndex:self.view.subviews.count-self.showingVCNumber];
//            self.showingVC = (UIViewController *)[[self.view.subviews objectAtIndex:self.view.subviews.count-1]nextResponder];
//        }];
//    }
    if (self.showingVCStack && self.showingVCStack.count>=2) {
        UIViewController *lastShow = [self.showingVCStack objectAtIndex:self.showingVCStack.count-2];
        [self transitionFromViewController:self.showingVC toViewController:lastShow duration:0 options:UIViewAnimationOptionCurveEaseOut animations:^(){} completion:^(BOOL finished){ }];
        [self.showingVCStack removeLastObject];
        self.showingVC = lastShow;
    }
}

#pragma mark - ContentView Operation
- (void)addPageOnContentView:(UIViewController *)vc{
    [self addChildViewController:vc];
    vc.view.frame = self.view.bounds;
    [self.view addSubview:vc.view];
    [vc didMoveToParentViewController:self];
}
- (void)showPageOnContentView:(UIViewController *)vc{
//    //如果切换了view，手动调用viewWillDisappear，来更新操作
//    if (self.showingVC != vc) {
//        [self.showingVC viewWillDisappear:NO];
//    }
//    
//    //将contentVC 中将要显示的viewcontroller，及navigationViewController的子vc，update显示
//    if([vc isKindOfClass:[UINavigationController class]]){
//        UINavigationController *navVC = (UINavigationController *)vc;
//        for (UIViewController *vcInNavVC in navVC.viewControllers) {
//            [vcInNavVC viewWillAppear:NO];
//        }
//    }else{
//        [vc viewWillAppear:NO];
//    }
//    [self.view bringSubviewToFront:vc.view];
//    self.showingVC = vc;
//    self.showingVCNumber++;
    
    if (self.showingVC == vc) {
        return;
    }
    
    if (self.showingVC) {
        [self transitionFromViewController:self.showingVC toViewController:vc duration:0 options:UIViewAnimationOptionCurveEaseOut animations:^(){} completion:^(BOOL finished){}];
    }
    self.showingVC = vc;
    [self.showingVCStack addObject:vc];
    if (self.showingVCStack.count > MAX_CACHE_VCNUM) {
        [self.showingVCStack removeObjectAtIndex:0];
    }
}

#pragma mark - LCSlideContentVCDelegate
///当前是否允许滑动显示菜单
- (BOOL)canSlideToShowMenu{
    //如果当前是注册登录页，不允许滑动显示
    if (self.showingVC == self.loginPage) {
        return NO;
    }
    
    UINavigationController *navVC;
    if ([self.showingVC isKindOfClass:[UINavigationController class]]) {
        navVC = (UINavigationController *)self.showingVC;
    }else if(self.showingVC.navigationController){
        navVC = self.showingVC.navigationController;
    }
    
    //如果当前正在显示的是UINavigationViewController，并且栈中只有一个VC，允许滑动
    if (navVC && navVC.viewControllers.count == 1) {
        return YES;
    }
    
    return NO;
}


#pragma mark - Notification
- (void)observeNotification{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showGuideView:) name:NotificationShowGuidePage object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showSelfView:) name:NotificationShowSelfView object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showHomeNotify:) name:NotificationShowHomePage object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showLogin:) name:NotificationShowLogin object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showPlanList:) name:NotificationShowPlanList object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showChat:) name:NotificationShowChat object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showMessageCenter:) name:NotificationShowMessageCenter object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showFavorList:) name:NotificationShowFavorList object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showNearby:) name:NotificationShowNearbyPage object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showSendPartnerPlan:) name:NotificationShowSendPartnerPlan object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showSendReceptionPlan:) name:NotificationShowSendReceptionPlan object:nil];
}
- (void)removeObserveNotification{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NotificationShowGuidePage object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NotificationShowSelfView object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NotificationShowLogin object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NotificationShowPlanList object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NotificationShowChat object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NotificationShowMessageCenter object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NotificationShowFavorList object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NotificationShowNearbyPage object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NotificationShowSendPartnerPlan object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NotificationShowSendReceptionPlan object:nil];
    
}

- (void)showGuideView:(NSNotification *)notify{
    [self showGuidePage];
}
- (void)showSelfView:(NSNotification *)notify{
    [self showSelfPage];
}
- (void)showHomeNotify:(NSNotification *)notify{
    [self showHomePage];
}
- (void)showLogin:(NSNotification *)notify{
    [self showLoginPage];
}
- (void)showPlanList:(NSNotification *)notify{
    [self showParticipatedListPage];
}
- (void)showChat:(NSNotification *)notify{
    [self showChatPage];
}
/// 显示消息中心.
- (void)showMessageCenter:(NSNotification *)notify{
    [self showMessageCenterPage];
}
- (void)showFavorList:(NSNotification *)notify{
    [self showFavorPage];
}
- (void)showNearby:(NSNotification *)notify{
    [self showNearbyPage];
}
- (void)showSendPartnerPlan:(NSNotification *)notify{
    [self showPartnerPlanPage];
}
- (void)showSendReceptionPlan:(NSNotification *)notify{
    [self showReceptionPlanPage];
}
@end
