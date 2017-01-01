//
//  LCTabBarVC.m
//  LinkCity
//
//  Created by roy on 3/20/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCTabBarVC.h"
#import "LinkCity-Swift.h"
#import "LCSendPlanHelper.h"
#import "UIView+BlocksKit.h"

#define DUCKR_TAB_HOME_ICON 0
#define DUCKR_TAB_FIND_ICON 1
#define DUCKR_TAB_LOCAL_ICON 2
#define DUCKR_TAB_CHAT_ICON 3
#define DUCKR_TAB_USER_ICON 4

@interface LCTabBarVC ()<UITabBarControllerDelegate,UITabBarDelegate>
@property (nonatomic, strong) UIImage *planTabImage;
@property (nonatomic, strong) UIImage *planTabHighlightImage;

@property (nonatomic, strong) UIImage *findTabImage;
@property (nonatomic, strong) UIImage *findTabHighlightImage;

@property (nonatomic, strong) UIImage *localTabImage;
@property (nonatomic, strong) UIImage *localTabHighlightImage;

@property (nonatomic, strong) UIImage *chatTabImage;
@property (nonatomic, strong) UIImage *chatTabHighlightImage;
@property (nonatomic, strong) UIImage *chatTabRDImage;
@property (nonatomic, strong) UIImage *chatTabRDHighlightImage;

@property (nonatomic, strong) UIImage *userTabImage;
@property (nonatomic, strong) UIImage *userTabHighlightImage;
@property (nonatomic, strong) UIImage *userTabRDImage;
@property (nonatomic, strong) UIImage *userTabRDHighlightImage;

@end

@implementation LCTabBarVC

+ (LCTabBarVC *)createInstance {
    return (LCTabBarVC *)[LCStoryboardManager viewControllerWithFileName:SBNameMain identifier:VCIDTabBarVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    _planTabImage = [[UIImage imageNamed:@"PlanTab"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _planTabHighlightImage = [[UIImage imageNamed:@"PlanTabHighlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    _findTabImage = [[UIImage imageNamed:@"TourTab"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _findTabHighlightImage = [[UIImage imageNamed:@"TourTabHighlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    _localTabImage = [[UIImage imageNamed:@"LocalTab"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _localTabHighlightImage = [[UIImage imageNamed:@"LocalTabHighlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    _chatTabImage = [[UIImage imageNamed:@"ChatTab"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _chatTabHighlightImage = [[UIImage imageNamed:@"ChatTabHighlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    _userTabImage = [[UIImage imageNamed:@"UserTab"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _userTabHighlightImage = [[UIImage imageNamed:@"UserTabHighlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _userTabRDImage = [[UIImage imageNamed:@"UserTabRD"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _userTabRDHighlightImage = [[UIImage imageNamed:@"UserTabRDHighlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.planTabNavVC = [LCPlanTabVC createNavInstance];
    self.planTabNavVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:_planTabImage selectedImage:_planTabHighlightImage];
    self.planTabNavVC.tabBarItem.tag = DUCKR_TAB_HOME_ICON;
    
    self.tourpicTabVC = [LCTourpicTabVC createNavInstance];
    self.tourpicTabVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"发现" image:_findTabImage selectedImage:_findTabHighlightImage];
    self.tourpicTabVC.tabBarItem.tag = DUCKR_TAB_FIND_ICON;
    
    self.localTabVC = [LCLocalTabVC createNavInstance];
    self.localTabVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"本地" image:_localTabImage selectedImage:_localTabHighlightImage];
    self.localTabVC.tabBarItem.tag = DUCKR_TAB_LOCAL_ICON;
    
    self.chatTabVC = [LCChatTabVC createNavInstance];
    self.chatTabVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"消息" image:_chatTabImage selectedImage:_chatTabHighlightImage];
    self.chatTabVC.tabBarItem.tag = DUCKR_TAB_CHAT_ICON;
    
    self.userTabVC = [LCUserTabVC createNavInstance];
    self.userTabVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我" image:_userTabImage selectedImage:_userTabHighlightImage];
    self.userTabVC.tabBarItem.tag = DUCKR_TAB_USER_ICON;
    
    NSArray *tabViewControllers = @[self.planTabNavVC,
                                    self.tourpicTabVC,
                                    self.localTabVC,
                                    self.chatTabVC,
                                    self.userTabVC];
    [self setViewControllers:tabViewControllers];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:NotificationUnreadNumDidChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:NotificationRedDotNumDidChange object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)notificationAction:(NSNotification *)notify {
    NSInteger unreadNum = [[LCDataManager sharedInstance] getUnreadNumSum];
    unreadNum += [LCDataManager sharedInstance].redDot.msgNum;
    if (unreadNum <= 0) {
        self.chatTabVC.tabBarItem.badgeValue = nil;
    } else {
        self.chatTabVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%zd", unreadNum];
    }
    NSInteger userTabRedDotNum = [LCDataManager sharedInstance].redDot.myselfNum;
    if (userTabRedDotNum <= 0) {
        [self.userTabVC.tabBarItem setImage:_userTabImage];
        [self.userTabVC.tabBarItem setSelectedImage:_userTabHighlightImage];
    } else {
        [self.userTabVC.tabBarItem setImage:_userTabRDImage];
        [self.userTabVC.tabBarItem setSelectedImage:_userTabRDHighlightImage];
    }
}

#pragma mark UITabBarController Delegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    BOOL ret = YES;
    if ([[LCDataManager sharedInstance] haveLogin]) {
        ret = YES;
    } else {
        if (viewController == self.planTabNavVC || viewController == self.tourpicTabVC) {
            ret = YES;
        } else if(viewController == self.chatTabVC || viewController == self.userTabVC){
            ret = NO;
            [[LCRegisterAndLoginHelper sharedInstance] startRegister];
        }
    }
    
    return ret;
}

#pragma mark - Sender
- (void)sendPlan {
    [MobClick event:V5_ADD_TAB_CLICK];
    if ([[LCDataManager sharedInstance] haveLogin]) {
        [[LCSendPlanHelper sharedInstance] sendNewPlanWithPlaceName:@""];
    } else {
        [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
    }
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item; {
    NSInteger itemTag = item.tag;
    if (DUCKR_TAB_HOME_ICON == itemTag) {
        [MobClick event:V5_HOMEPAGE_TAB_CLICK];
    } else if (DUCKR_TAB_FIND_ICON == itemTag) {
        [MobClick event:V5_TOURPIC_TAB_CLICK];
    } else if (DUCKR_TAB_LOCAL_ICON == itemTag) {
        [MobClick event:V5_LOCAL_TAB_CLICK];
    } else if (DUCKR_TAB_CHAT_ICON == itemTag) {
        [MobClick event:V5_MSG_TAB_CLICK];
    } else if (DUCKR_TAB_USER_ICON == itemTag) {
        [MobClick event:V5_MYSELF_TAB_CLICK];
    }
    NSLog(@"%ld",(long)itemTag);
}

@end
