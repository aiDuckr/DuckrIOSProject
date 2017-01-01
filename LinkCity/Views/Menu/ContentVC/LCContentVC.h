//
//  LCContentVC.h
//  LinkCity
//
//  Created by roy on 10/25/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCSlideVC.h"
#import "LCMenuVC.h"
#import "LCFavorListVC.h"
#import "LCNearbyUserVC.h"
#import "LCGuideVC.h"
#import "LCHomePageVC.h"
#import "LCLoginVC.h"
#import "LCUserInfo.h"
#import "LCUserInfoVC.h"
#import "LCSearchDestinationVC.h"
#import "LCParticipatedListVC.h"
#import "LCGuideVCTwo.h"

@interface LCContentVC : LCBaseVC<LCSlideContentVCDelegate>
@property (nonatomic,weak) LCSlideVC *slideVC;
@property (nonatomic, strong) LCGuideVCTwo *guideVC;
@property (nonatomic, strong) UINavigationController *selfNavigationController;
@property (nonatomic, strong) UINavigationController *homeNaviagtionController;
@property (nonatomic, strong) UINavigationController *chatNaviagtionController;
@property (nonatomic, strong) LCGuideVCTwo *guidePage;
@property (nonatomic, strong) LCLoginVC *loginPage;
@property (nonatomic, strong) UINavigationController *favorNavigationController;;
@property (nonatomic, strong) LCSearchDestinationVC *searchDestinationVC;
@property (nonatomic,strong) UIViewController *showingVC;   // the vc which is showing currently
@property (nonatomic,strong) UINavigationController *participatedListNavigationVC;
@property (nonatomic,strong) UINavigationController *nearbyUserNavigationVC;
@property (nonatomic,strong) UINavigationController *messageCenterNavigationVC;

- (void)showGuidePage;
- (void)showLoginPage;  
- (void)showSelfPage;
- (void)showHomePage;   //addChildViewController
- (void)showParticipatedListPage;   //addChildViewController
- (void)showChatPage;
- (void)showFavorPage;
- (void)showNearbyPage;
- (void)showPartnerPlanPage;
- (void)showReceptionPlanPage;

- (void)hideCurrentPageWithAnimation:(BOOL)animation;
@end
