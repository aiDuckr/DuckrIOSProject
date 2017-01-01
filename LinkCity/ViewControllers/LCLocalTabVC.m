//
//  LCLocalTabVC.m
//  LinkCity
//
//  Created by 张宗硕 on 7/27/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCLocalTabVC.h"
#import "LCLocalFreetimeVC.h"
#import "UIImage+Create.h"
#import "LCLocalCostPlanListVC.h"
#import "LCSearchDestinationVC.h"
#import "LCInviteFilterView.h"
#import "LCHomeRcmdCell.h"
#import "LCHomeBannerCell.h"
#import "LCFreePlanCell.h"
#import "LCCostPlanCell.h"
#import "LCHomeHotThemeCell.h"
#import "LCProvincePickerVC.h"
#import "LCSystemPermissionUtil.h"
#import "LCLocalSearchVC.h"
#import "LCCalendarSearchVC.h"
#define LocalTabVCTabNum (2)
#define LocalPlanRefreshMinSec (-120.0f)
#define TopLocalFreeViewHeight (62.0f)

@interface LCLocalTabVC ()<UITableViewDelegate, UITableViewDataSource, LCTabViewDelegate, UIScrollViewDelegate, LCDelegateManagerDelegate, LCInviteFilterViewDelegate, LCProvincePickerDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabTopHeightConstrint;

@property (weak, nonatomic) IBOutlet UIView *tabContainerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *hintResultView;
@property (weak, nonatomic) IBOutlet UILabel *joinNumLabel;//多少人加入
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;               //!> 首页左右滚动视图.
@property (weak, nonatomic) IBOutlet UITableView *tradeTableView;            //!> 首页推荐的上下滚动列表.
@property (weak, nonatomic) IBOutlet UITableView *inviteTableView;           //!> 首页本地的上下滚动的列表.
@property (weak, nonatomic) IBOutlet UIButton *filterButton;
@property (weak, nonatomic) IBOutlet UIView *localFreeView;
@property (weak, nonatomic) IBOutlet UIView *redDotView;//红点


@property (nonatomic, strong) LCProvincePickerVC *provincePickerVC;
@property (strong, nonatomic) NSArray *tradeContentArr;
@property (strong, nonatomic) NSArray *inviteContentArr;
@property (strong, nonatomic) NSMutableArray *orderStrArray;
@property (strong, nonatomic) NSMutableArray *refreshDateArray;

@property (strong, nonatomic) UIImage *formerNavbarShadowImage;             //!> 首页导航栏的背景图.
@property (strong, nonatomic) UIButton *topTitleButton;

@property (strong, nonatomic) LCCityModel *currentCity;
@property (nonatomic, strong) LCTabView *tabView;                           //!> 顶部的Tab视图.
@property (nonatomic, strong) KLCPopup *planFilterPopup;

@property (strong, nonatomic) NSArray *tradeTopArr;                         //!> 本地
@property (assign, nonatomic) NSInteger fitlerThemeId;
@property (assign, nonatomic) UserSex inviteSex;
@property (assign, nonatomic) LCPlanOrderType inviteOrderType;
@property (assign, nonatomic) BOOL changeCity;

@end

@implementation LCLocalTabVC

#pragma mark - LifeCycle.
+ (UINavigationController *)createNavInstance {
    return (UINavigationController *)[LCStoryboardManager viewControllerWithFileName:SBNameLocalTab identifier:VCIDLocalNav];
}

+ (instancetype)createInstance {
    return (LCLocalTabVC *)[LCStoryboardManager viewControllerWithFileName:SBNameLocalTab identifier:VCIDLocalTabVC];
}

- (void)commonInit {
    [super commonInit];
    self.orderStrArray = [[NSMutableArray alloc] initWithCapacity:LocalTabVCTabNum];
    /// 一开始两个模块的排序字符串都为空.
    for (int i = 0; i < LocalTabVCTabNum; i++) {
        [self.orderStrArray addObject:@""];
    }
    self.refreshDateArray = [[NSMutableArray alloc] initWithCapacity:LocalTabVCTabNum];
    for (int i = 0; i < LocalTabVCTabNum; i++) {
        [self.refreshDateArray addObject:@""];
    }
    
    LCDataManager *manager = [LCDataManager sharedInstance];
    self.currentCity = manager.currentCity;
    self.tradeTopArr = manager.localTradeTopArr;
    self.tradeContentArr = manager.localTradeContentArr;
    self.inviteContentArr = manager.localInviteContentArr;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:UIColorFromRGBA(0xfedd00, 1.0f)] forBarMetrics:UIBarMetricsDefault];
    if (self.isViewWillAppearCalledFirstTime) {
        if (![CLLocationManager locationServicesEnabled]) {
            [LCSystemPermissionUtil isHaveLocationServicePermission:YES withText:@"定位开启后才能发现本地同城玩乐哦~"];
        } else {
            if (kCLAuthorizationStatusDenied == [CLLocationManager authorizationStatus]) {
                [LCSystemPermissionUtil isHaveLocationServicePermission:NO withText:@"定位开启后才能发现本地同城玩乐哦~"];
            }
        }
        [self updateShow];
    }
    else {//每次进入更新下同城有空加入人数
    LCDataManager *manager = [LCDataManager sharedInstance];
    if (manager.redDot.localLeisureNum > 0) {
        self.redDotView.hidden = NO;
        self.joinNumLabel.hidden = NO;
        self.joinNumLabel.text = [NSString stringWithFormat:@"%zd人刚刚加入", manager.redDot.localLeisureNum];
    } else {
        self.redDotView.hidden = YES;
        self.joinNumLabel.hidden = YES;
    }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[LCUIConstants sharedInstance].navBarOpaqueImage forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:self.formerNavbarShadowImage];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.changeCity=NO;
    [self initNavigationBar];
    /// 初始化顶部的两个模块按钮.
    [self initUpperTabbar];
    /// 初始化左右滚动视图.
    [self initScrollView];
    /// 初始化首页推荐列表.
    [self initTradeTableView];
    /// 初始化首页本地列表.
    [self initInviteTableView];
    [self initNotification];
    if (self.tradeContentArr.count > 0) {
        [self headerRefreshAction];
    } else {
        [self.tradeTableView headerBeginRefreshing];
    }
    [self requestLocalInvites];
}

- (void)refreshData {
    self.tradeTopArr = [[LCDataBufferManager sharedInstance] refreshHomeRcmdArr:self.tradeTopArr];
    self.tradeContentArr = [[LCDataBufferManager sharedInstance] refreshPlanTourpicUserArr:self.tradeContentArr];
    self.inviteContentArr = [[LCDataBufferManager sharedInstance] refreshPlanTourpicUserArr:self.inviteContentArr];
    [self updateShow];
}

#pragma mark - Server Request.
/// 下拉刷新.
- (void)headerRefreshAction {
    NSInteger index = self.tabView.selectIndex;
    if (index < self.orderStrArray.count) {
        self.orderStrArray[index] = @"";
    }
    [self requestContentDatas];
}

/// 上拉加载更多.
- (void)footerRefreshAction {
    [self requestContentDatas];
}

/// 重新请求数据.
- (void)requestContentDatas {
    switch (self.tabView.selectIndex) {
        case LCLocalTabVCTab_Trade:
            [self requestLocalTrades];
            break;
        case LCLocalTabVCTab_Invite:
            [self requestLocalInvites];
            break;
        default:
            break;
    }
}

/// 从后台获取首页推荐的数据列表.本地活动？
- (void)requestLocalTrades {
    __weak typeof(self) weakSelf = self;
    [LCNetRequester requestLocalTrades:self.orderStrArray[LCLocalTabVCTab_Trade] withCallBack:^(NSArray *rcmdArr, NSArray *contentArr, NSString *orderStr, NSError *error) {
        [weakSelf.tradeTableView headerEndRefreshing];
        [weakSelf.tradeTableView footerEndRefreshing];
        if (!error) {
            if (nil != rcmdArr && rcmdArr.count > 0) {
                weakSelf.tradeTopArr = rcmdArr;
            }
            if ([LCStringUtil isNullString:self.orderStrArray[LCLocalTabVCTab_Trade]]) {
                weakSelf.tradeContentArr = [[NSArray alloc] init];
            }
            if (nil != contentArr && contentArr.count > 0) {
                weakSelf.tradeContentArr = [LCSharedFuncUtil addFiltedArrayToArray:weakSelf.tradeContentArr withUnfiltedArray:contentArr];
                weakSelf.refreshDateArray[LCLocalTabVCTab_Trade] = [LCDateUtil getCurrentDate];
                [self hideNotFoundPage];
            } else if ([LCStringUtil isNotNullString:weakSelf.orderStrArray[LCLocalTabVCTab_Trade]]) {
                if (LCLocalTabVCTab_Trade == weakSelf.tabView.selectIndex) {
                    [YSAlertUtil tipOneMessage:@"没有更多本地内容"];
                }
            } else {
                [self showNotFoundPage];
            }
            weakSelf.orderStrArray[LCLocalTabVCTab_Trade] = orderStr;
            [weakSelf updateShow];
        } else {
            [YSAlertUtil tipOneMessage:error.domain];
        }
    }];
}

/// 从后台获取首页本地的数据列表.//本地邀约
- (void)requestLocalInvites {
    __weak typeof(self) weakSelf = self;
    [LCNetRequester requestLocalInvites:self.orderStrArray[LCLocalTabVCTab_Invite] themeId:self.fitlerThemeId sex:self.inviteSex orderType:self.inviteOrderType withCallBack:^(NSArray *contentArr, NSString *orderStr, NSError *error) {
        [weakSelf.inviteTableView headerEndRefreshing];
        [weakSelf.inviteTableView footerEndRefreshing];
        if (!error) {
            if ([LCStringUtil isNullString:self.orderStrArray[LCLocalTabVCTab_Invite]]) {
                weakSelf.inviteContentArr = [[NSArray alloc] init];
            }
            if (nil != contentArr && contentArr.count > 0) {
                weakSelf.inviteContentArr = [LCSharedFuncUtil addFiltedArrayToArray:weakSelf.inviteContentArr withUnfiltedArray:contentArr];
                self.refreshDateArray[LCLocalTabVCTab_Invite] = [LCDateUtil getCurrentDate];
                [self hideNotFoundPage];
            } else if ([LCStringUtil isNotNullString:weakSelf.orderStrArray[LCLocalTabVCTab_Invite]]) {
                if (LCLocalTabVCTab_Invite == weakSelf.tabView.selectIndex) {
                    [YSAlertUtil tipOneMessage:@"没有更多邀约内容"];
                }
            } else {
                [self showNotFoundPage];
            }
            weakSelf.orderStrArray[LCLocalTabVCTab_Invite] = orderStr;
            [weakSelf updateShow];
        } else {
            [YSAlertUtil tipOneMessage:error.domain];
        }
    }];
}

#pragma mark - Common Init.
- (void)initNavigationBar {
    self.formerNavbarShadowImage = self.navigationController.navigationBar.shadowImage;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(45.0f, 0.0f, (DEVICE_WIDTH - 45.0f * 3), 44.0f)];
    self.topTitleButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, (DEVICE_WIDTH - 45.0f * 3), 40.0f)];
    [self updateTopTitleButton];
    [view addSubview:self.topTitleButton];
    
    self.navigationItem.titleView = view;
}

/// 初始化首页顶部的两个模块按钮.
- (void)initUpperTabbar {
    LCTabView *tabView = [LCTabView createInstance];
    tabView.frame = CGRectMake(0, 0, DEVICE_WIDTH, LCTabViewHeight);
    [tabView updateButtons:@[@"本地活动", @"本地邀约"] withMargin:0];
    tabView.delegate = self;
    tabView.selectIndex = LCLocalTabVCTab_Trade;
    self.tabView = tabView;
    [self.tabContainerView addSubview:tabView];
}

/// 初始化左右滚动视图.
- (void)initScrollView {
    self.scrollView.delegate = self;
    self.scrollView.scrollsToTop = NO;
}

/// 初始化监听的通知.
- (void)initNotification {
    [self addObserveToNotificationNameToRefreshData:NotificationJustUpdateLocation];
    [self addObserveToNotificationNameToRefreshData:UIApplicationDidBecomeActiveNotification];
    [self addObserveToNotificationNameToRefreshData:URL_FAVOR_PLAN];
    [self addObserveToNotificationNameToRefreshData:UIApplicationDidBecomeActiveNotification];
    [self addObserveToNotificationNameToRefreshData:URL_TOURPIC_PUBLISH];
    [self addObserveToNotificationNameToRefreshData:URL_LOGIN];
    [self addObserveToNotificationNameToRefreshData:URL_QUIT_PLAN];
}

/// 初始化首页推荐列表.
- (void)initTradeTableView {
    self.tradeTableView.delegate = self;
    self.tradeTableView.dataSource = self;
    self.tradeTableView.estimatedRowHeight = 180.0f;
    self.tradeTableView.rowHeight = UITableViewAutomaticDimension;
    //self.tradeTableView.scrollsToTop = YES;
    
    [self.tradeTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCHomeRcmdCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCHomeRcmdCell class])];
    [self.tradeTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCHomeBannerCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCHomeBannerCell class])];
    [self.tradeTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCFreePlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCFreePlanCell class])];
    [self.tradeTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCCostPlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCCostPlanCell class])];
    [self.tradeTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCHomeHotThemeCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCHomeHotThemeCell class])];
    
    [self.tradeTableView addHeaderWithTarget:self action:@selector(headerRefreshAction)];
    [self.tradeTableView addFooterWithTarget:self action:@selector(footerRefreshAction)];
}

/// 初始化首页本地列表.
- (void)initInviteTableView {
    self.inviteTableView.delegate = self;
    self.inviteTableView.dataSource = self;
    self.inviteTableView.estimatedRowHeight = 180.0f;
    self.inviteTableView.rowHeight = UITableViewAutomaticDimension;
    //self.inviteTableView.scrollsToTop = YES;
    
    [self.inviteTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCFreePlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCFreePlanCell class])];
    [self.inviteTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCCostPlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCCostPlanCell class])];
    
    [self.inviteTableView addHeaderWithTarget:self action:@selector(headerRefreshAction)];
    [self.inviteTableView addFooterWithTarget:self action:@selector(footerRefreshAction)];
}

#pragma mark - Actions.
- (IBAction)searchAction:(id)sender {
#if 1
    //先借用一下calender的vc
    LCCalendarSearchVC *vc = [LCCalendarSearchVC createInstance];
    vc.isCalenderSearch = NO;
    vc.searchText = [LCStringUtil getNotNullStr:self.currentCity.cityName];
    vc.isNeedRefresh = YES;
#else
    LCLocalSearchVC *vc = [LCLocalSearchVC createInstance];//含商圈一栏。如果开发好了，就打开此选项。而且LCLocalSearchVC需要加些商圈的东西才可以
#endif
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)addPlanAction:(id)sender {
    if ([self haveLogin]) {
        [[LCSendPlanHelper sharedInstance] pushToSendFreePlanDestVC];
    } else {
        [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
    }
}

- (IBAction)pushToLocalFreetimeAction:(id)sender {
    if ([self haveLogin]) {
        LCLocalFreetimeVC *vc = [LCLocalFreetimeVC createInstance];
        [self.navigationController pushViewController:vc animated:APP_ANIMATION];
    } else {
        [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
    }
}

- (IBAction)testAction:(id)sender {
    LCLocalCostPlanListVC*vc = [LCLocalCostPlanListVC createInstance];
    [self.navigationController pushViewController:vc animated:APP_ANIMATION];
}

- (IBAction)showPlanFilterViewAction:(id)sender {
    static CGFloat centerY = 0;
    if (!self.planFilterPopup) {
        LCInviteFilterView *planFilterView = [LCInviteFilterView createInstance];
        planFilterView.delegate = self;
        self.planFilterPopup = [KLCPopup popupWithContentView:planFilterView
                                                     showType:KLCPopupShowTypeSlideInFromBottom
                                                  dismissType:KLCPopupDismissTypeSlideOutToBottom
                                                     maskType:KLCPopupMaskTypeDimmed
                                     dismissOnBackgroundTouch:YES
                                        dismissOnContentTouch:NO];
        //        [planFilterView sizeToFit];
        centerY = DEVICE_HEIGHT - [planFilterView intrinsicContentSize].height / 2;
        //        centerY = DEVICE_HEIGHT - planFilterView.frame.size.height / 2;
        //        NSLog(@"zzs size is %@", NSStringFromCGSize([planFilterView intrinsicContentSize]));
        //        centerY = DEVICE_HEIGHT / 2;
    }
    
    [self.planFilterPopup showAtCenter:CGPointMake(DEVICE_WIDTH / 2, centerY) inView:nil];
}

- (void)changeCityAction:(id)sender {
    if (!self.provincePickerVC) {
        self.provincePickerVC = [LCProvincePickerVC createInstance];
        self.provincePickerVC.isChosingLocalCity = YES;
        self.provincePickerVC.delegate = self;
    }
    [[LCSharedFuncUtil getTopMostNavigationController] pushViewController:self.provincePickerVC animated:YES];
}

#pragma mark - LCProvincePicker Delegate
- (void)provincePicker:(LCProvincePickerVC *)provincePickerVC didSelectProvince:(NSString *)provinceName didSelectCity:(LCCityModel *)city {
    [LCDataManager sharedInstance].isAlertLocationCity = YES;
    NSString *locName = @"";
    if (nil != [LCDataManager sharedInstance].currentCity) {
        locName = [LCDataManager sharedInstance].currentCity.cityName;
    }
    if ([LCStringUtil isNotNullString:city.cityName] && ![city.cityName isEqualToString:locName]) {
        [LCDataManager sharedInstance].currentCity = city;
        [self updateTopTitleButton];
        self.changeCity=YES;
        if (self.currentCity.isOpened == NO)
        {
            self.tabTopHeightConstrint.constant = -50.0f;
            self.tabView.selectIndex = LCPlanTabVCTab_Invite;
            [self.inviteTableView headerBeginRefreshing];
            self.scrollView.scrollEnabled = NO;
        }
        
        else if (YES == self.currentCity.isOpened && self.tabView.selectIndex == LCPlanTabVCTab_Rcmd) {
            self.tabTopHeightConstrint.constant = 0.0f;
            [self.tradeTableView headerBeginRefreshing];
            self.scrollView.scrollEnabled = YES;
        }
        else if (YES == self.currentCity.isOpened && self.tabView.selectIndex == LCPlanTabVCTab_Invite) {
            self.tabTopHeightConstrint.constant = 0.0f;
            [self.inviteTableView headerBeginRefreshing];
            self.scrollView.scrollEnabled = YES;
        }
        else {
            self.tabTopHeightConstrint.constant = -50.0f;
            self.tabView.selectIndex = LCPlanTabVCTab_Invite;
            [self.inviteTableView headerBeginRefreshing];
            self.scrollView.scrollEnabled = NO;
        }
        
        NSInteger index = self.tabView.selectIndex;
        [self.scrollView scrollRectToVisible:CGRectMake(index * DEVICE_WIDTH, 0, DEVICE_WIDTH, 10) animated:NO];
        
        self.tradeTableView.scrollsToTop = NO;
        self.inviteTableView.scrollsToTop = NO;
        
    }
}

#pragma mark - Common Func.
- (void)updateShow {
    [self updateTopTitleButton];
    if (YES == self.currentCity.isOpened) {
        self.tabTopHeightConstrint.constant = 0.0f;
        self.scrollView.scrollEnabled = YES;
    } else {
        self.tabTopHeightConstrint.constant = -50.0f;
        self.tabView.selectIndex = LCPlanTabVCTab_Invite;
        self.scrollView.scrollEnabled = NO;
    }
    
    NSInteger index = self.tabView.selectIndex;
    [self.scrollView scrollRectToVisible:CGRectMake(index * DEVICE_WIDTH, 0, DEVICE_WIDTH, 10) animated:NO];
    
    self.tradeTableView.scrollsToTop = NO;
    self.inviteTableView.scrollsToTop = NO;
    
    switch (index) {
        case LCPlanTabVCTab_Rcmd:
            self.tradeTableView.scrollsToTop = YES;
            [self.tradeTableView reloadData];
            break;
        case LCPlanTabVCTab_Invite:
            self.inviteTableView.scrollsToTop = YES;
            [self.inviteTableView reloadData];
            break;
    }
    /// 缓存数据.
    LCDataManager *manager = [LCDataManager sharedInstance];
    manager.localTradeTopArr = self.tradeTopArr;
    manager.localTradeContentArr = self.tradeContentArr;
    manager.localInviteContentArr = self.inviteContentArr;
    
    if (manager.redDot.localLeisureNum > 0) {
        self.redDotView.hidden = NO;
        self.joinNumLabel.hidden = NO;
        self.joinNumLabel.text = [NSString stringWithFormat:@"%zd人已加入", manager.redDot.localLeisureNum];
    } else {
        self.redDotView.hidden = YES;
        self.joinNumLabel.hidden = YES;
    }
}

- (void)updateTopTitleButton {
    NSString *str = @"北京";

    if (nil != [LCDataManager sharedInstance].locationCity) {
        NSString *locName = @"";
        if (nil != self.currentCity) {
            locName = [LCStringUtil getNotNullStr:self.currentCity.cityName];
        }
        NSString *locationName = [LCStringUtil getNotNullStr:[LCDataManager sharedInstance].locationCity.cityName];
        
        if (NO == [locName isEqualToString:locationName] && NO == [LCDataManager sharedInstance].isAlertLocationCity) {
            [LCDataManager sharedInstance].isAlertLocationCity = YES;
            NSString *alertStr = @"是否切换城市到 %@ ？";
            if (nil == self.currentCity) {
                alertStr = @"你是否在 %@ ?";
            }
            NSString *tipStr = [NSString stringWithFormat:alertStr, locationName];
            [YSAlertUtil alertTwoButton:@"否" btnTwo:@"是" withTitle:nil msg:tipStr callBack:^(NSInteger chooseIndex) {
                if (1 == chooseIndex) {
                    [LCDataManager sharedInstance].currentCity = [LCDataManager sharedInstance].locationCity;
                    if (YES == [LCDataManager sharedInstance].currentCity.isOpened) {
                        [self tabView:self.tabView didSelectIndex:LCLocalTabVCTab_Trade];
                    }
                    [self headerRefreshAction];
                } else if (0 == chooseIndex){
                    if (nil == self.currentCity) {
                         [self changeCityAction:nil];
                    }
                }
            }];
        }
    }
    
    self.currentCity = [LCDataManager sharedInstance].currentCity;
    if (nil != self.currentCity && [LCStringUtil isNotNullString:self.currentCity.cityName]) {
        str = self.currentCity.cityShortName;
    }
    [self.topTitleButton setTitle:str forState:UIControlStateNormal];
    [self.topTitleButton setImage:[UIImage imageNamed:@"LocalTabTopCityArrow"] forState:UIControlStateNormal];
    self.topTitleButton.titleLabel.font = [UIFont fontWithName:APP_CHINESE_FONT size:17.0f];
    [self.topTitleButton setTitleColor:UIColorFromRGBA(0x7f4802, 1.0f) forState:UIControlStateNormal];
    [LCSharedFuncUtil updateButtonTextImageRight:self.topTitleButton withSpacing:6.0f];
    [self.topTitleButton addTarget:self action:@selector(changeCityAction:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)showNotFoundPage {
    self.hintResultView.hidden = NO;
    self.inviteTableView.hidden = YES;
}

- (void)hideNotFoundPage {
    self.hintResultView.hidden = YES;
    self.inviteTableView.hidden = NO;
}

#pragma mark - LCDelegateManager Delegate
- (void)updateViewShow {
    [self updateShow];
}

#pragma mark - LCInviteFilterView Delegate.
- (void)inviteFilterViewDidFilter:(LCInviteFilterView *)userFilterView fitlerThemeId:(NSInteger)themeId userSex:(UserSex)sex filtType:(LCPlanOrderType)type {
    [self hideNotFoundPage];
    [self.planFilterPopup dismissPresentingPopup];
    self.inviteSex = sex;
    self.fitlerThemeId = themeId;
    self.inviteOrderType = type;
    [self.inviteTableView scrollsToTop];
//    [self.inviteTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [self.inviteTableView headerBeginRefreshing];
}

#pragma mark - LCTabView Delegate.
- (void)tabView:(LCTabView *)tabView didSelectIndex:(NSInteger)index {
    self.tabView.selectIndex = index;
    
    switch (self.tabView.selectIndex) {
        case LCLocalTabVCTab_Trade: {
            if ([LCStringUtil isNullString:[self.refreshDateArray objectAtIndex:LCLocalTabVCTab_Trade]]) {
                [self.tradeTableView headerBeginRefreshing];
            } else {
                NSInteger interval = [LCDateUtil getTwoDateInterval:[LCDateUtil getCurrentDate] withDate2:[self.refreshDateArray objectAtIndex:LCLocalTabVCTab_Trade]];
                if (interval < LocalPlanRefreshMinSec || self.changeCity) {
                    self.changeCity = NO;
                    [self.tradeTableView headerBeginRefreshing];
                }
            }
        }
            break;
        case LCLocalTabVCTab_Invite: {
            if ([LCStringUtil isNullString:[self.refreshDateArray objectAtIndex:LCLocalTabVCTab_Invite]]) {
                [self.inviteTableView headerBeginRefreshing];
            } else {
                NSInteger interval = [LCDateUtil getTwoDateInterval:[LCDateUtil getCurrentDate] withDate2:[self.refreshDateArray objectAtIndex:LCLocalTabVCTab_Invite]];
                if (interval < LocalPlanRefreshMinSec || self.changeCity) {
                    self.changeCity = NO;
                    [self.inviteTableView headerBeginRefreshing];
                }
            }
        }
            break;
        default:
            break;
    }
    
    [self updateShow];
}

#pragma mark - UIScrollView Delegate.
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.inviteTableView) {
        [UIView animateWithDuration:0.5 animations:^{
            self.filterButton.frame = CGRectMake(DEVICE_WIDTH * 2, self.filterButton.frame.origin.y, 43, 43);//隐藏
        }];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == self.inviteTableView) {
        [UIView animateWithDuration:0.5 animations:^{
            self.filterButton.frame = CGRectMake(DEVICE_WIDTH * 2 - 43 - 15, self.filterButton.frame.origin.y, 43, 43);//显示
        }];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.scrollView == scrollView) {
        int index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
        [self.tabView setSelectIndex:index];
        [self tabView:self.tabView didSelectIndex:index];
        [self.scrollView setContentOffset:CGPointMake(index * DEVICE_WIDTH, 0.0f) animated:YES];
    } else if (self.inviteTableView == scrollView ){
        [UIView animateWithDuration:0.5 animations:^{
            self.filterButton.frame = CGRectMake(DEVICE_WIDTH * 2 - 43 - 15, self.filterButton.frame.origin.y, 43, 43);//显示
        }];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
    /// 手往下，内容往下滚，contentOffset变负.
    CGFloat localFreeHeight = TopLocalFreeViewHeight - scrollView.contentOffset.y;
    if (localFreeHeight < 0.0f) {//小于零
        [self.view layoutIfNeeded];
        //[self.view setNeedsLayout];
        [UIView animateWithDuration:0.3  animations:^{
            self.topHeightConstraint.constant = 0;//小于零设为0.
            self.localFreeView.hidden = YES;
            [self.view layoutIfNeeded]; // Called on parent view
        }];
    } else {//大于零
        [self.view layoutIfNeeded];
        //[self.view setNeedsLayout];//???
        [UIView animateWithDuration:0.3 animations:^{
            self.topHeightConstraint.constant = TopLocalFreeViewHeight;//大于零设为62
            self.localFreeView.hidden = NO;
            [self.view layoutIfNeeded]; // Called on parent view
        }];
    }
    if (scrollView == self.inviteTableView) {
        if (self.inviteContentArr.count > 0) {
            [UIView animateWithDuration:0.5 animations:^{
                self.filterButton.frame = CGRectMake(DEVICE_WIDTH * 2, self.filterButton.frame.origin.y, 43, 43);//隐藏
            }];
        } else {
            [UIView animateWithDuration:0.5 animations:^{
                self.filterButton.frame = CGRectMake(DEVICE_WIDTH * 2 - 43 - 15, self.filterButton.frame.origin.y, 43, 43);//显示
            }];
        }
    }
}

#pragma mark - Configure Cells.
/// 本地的Cell.
- (UITableViewCell *)configureLocalCell:(UITableView*)tableView withIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.section == self.tradeTopArr.count) {
        LCPlanModel *plan = [self.tradeContentArr objectAtIndex:indexPath.row];
        if (LCPlanType_CostPlan == plan.routeType || LCPlanType_CostLocal == plan.routeType) {
            LCCostPlanCell *costPlanCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCCostPlanCell class]) forIndexPath:indexPath];
            [costPlanCell updateShowWithPlan:plan];
            cell = costPlanCell;
        } else {
            LCFreePlanCell *freePlanCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCFreePlanCell class]) forIndexPath:indexPath];
            if (indexPath.row != self.tradeContentArr.count - 1) {
                [freePlanCell updateShowWithPlan:plan hideThemeId:0 withSpaInset:YES];
            } else {
                [freePlanCell updateShowWithPlan:plan hideThemeId:0 withSpaInset:NO];
            }
            freePlanCell.delegate = [LCDelegateManager sharedInstance];
            cell = freePlanCell;
        }
    } else {
        LCHomeRcmd *homeRcmd = [self.tradeTopArr objectAtIndex:indexPath.section];
        switch (homeRcmd.type) {
            case LCHomeRcmdType_LocalRcmd: {
                LCHomeBannerCell *bannerCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCHomeBannerCell class]) forIndexPath:indexPath];
                [bannerCell updateHomeBannerCell:homeRcmd];
                cell = bannerCell;
            }
                break;
            case LCHomeRcmdType_LocalTrade:{
                
            }
                break;
            case LCHomeRcmdType_LocalTheme: {
                LCHomeRcmdCell *homeRcmdCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCHomeRcmdCell class]) forIndexPath:indexPath];
                [homeRcmdCell updateHomeRcmdCell:homeRcmd];
                cell = homeRcmdCell;
            }
                break;
            
            default:
                break;
        }
    }
    return cell;
}

- (UITableViewCell *)configureInviteCell:(UITableView*)tableView withIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    LCPlanModel *plan = [self.inviteContentArr objectAtIndex:indexPath.row];
    if (LCPlanType_CostPlan == plan.routeType || LCPlanType_CostLocal == plan.routeType) {
        LCCostPlanCell *costPlanCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCCostPlanCell class]) forIndexPath:indexPath];
        [costPlanCell updateShowWithPlan:plan];
        cell = costPlanCell;
    } else {
        LCFreePlanCell *freePlanCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCFreePlanCell class]) forIndexPath:indexPath];
        if (indexPath.row != self.inviteContentArr.count - 1) {
            [freePlanCell updateShowWithPlan:plan hideThemeId:0 withSpaInset:YES];
        } else {
            [freePlanCell updateShowWithPlan:plan hideThemeId:0 withSpaInset:NO];
        }
        freePlanCell.delegate = [LCDelegateManager sharedInstance];
        cell = freePlanCell;
    }
    return cell;
}

#pragma mark - UITableView Delegate.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger number = 0;
    if (tableView == self.tradeTableView) {
        number = self.tradeTopArr.count + 1;
    } else if (tableView == self.inviteTableView) {
        number = 1;
    }
    return number;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger number = 0;
    if (tableView == self.tradeTableView) {
        number = 1;
        if (section == self.tradeTopArr.count) {
            number = self.tradeContentArr.count;
        }
    } else if (tableView == self.inviteTableView) {
        number = self.inviteContentArr.count;
    }
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (tableView == self.tradeTableView) {
        //本地精选
        cell = [self configureLocalCell:tableView withIndexPath:indexPath];
    } else if (tableView == self.inviteTableView) {
        cell = [self configureInviteCell:tableView withIndexPath:indexPath];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tradeTableView) {
        if (indexPath.section == self.tradeTopArr.count) {
            LCPlanModel *model = [self.tradeContentArr objectAtIndex:indexPath.row];
            [LCViewSwitcher pushToShowPlanDetailVCForPlan:model recmdUuid:@"" on:self.navigationController];
        }
    } else if (tableView == self.inviteTableView) {
        LCPlanModel *model = [self.inviteContentArr objectAtIndex:indexPath.row];
        [LCViewSwitcher pushToShowPlanDetailVCForPlan:model recmdUuid:@"" on:self.navigationController];
    }
}


@end
