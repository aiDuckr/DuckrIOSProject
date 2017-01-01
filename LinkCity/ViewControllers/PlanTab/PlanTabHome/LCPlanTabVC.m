//
//  LCPlanTabVC.m
//  LinkCity
//
//  Created by 张宗硕 on 5/13/16.
//  Copyright © 2016 linkcity. All rights reserved.
//


#import "LCPlanTabVC.h"
#import "LCTabView.h"
#import "LCPlanTabSearchView.h"
#import "LCMainSearchPlanVC.h"
#import "UIImage+Create.h"
#import "LCHomeRcmdCell.h"
#import "LCHomeRecmTabCell.h"
#import "LCFreePlanCell.h"
#import "LCCostPlanCell.h"
#import "LCTourpicCell.h"
#import "LCHomeUserCell.h"
#import "LCFreePlanCell.h"
#import "LCCostPlanCell.h"
#import "LCHomeHotThemeTitleCell.h"
#import "LCHomeLocalPlaceCell.h"
#import "LCHomeLocalTabCell.h"
#import "LCDestinationPlaceModel.h"
#import "LCHomeDuckrBoardCell.h"
#import "LCOnlineLocalCoverCell.h"
#import "LCPopViewHelper.h"
#import "LCHomeBannerCell.h"
#import "LCHomeHotThemeCell.h"
#import "LCInviteFilterView.h"
#import "LCSearchDestinationVC.h"
#import "LCCalendarSearchVC.h"

#define PlanTabVCTabNum (2)
#define HomePlanRefreshMinSec (-120.0f)

@interface LCPlanTabVC ()<UITableViewDelegate, UITableViewDataSource, LCTabViewDelegate, UIScrollViewDelegate, LCDelegateManagerDelegate, LCRegisterAndLoginHelperDelegate, LCInviteFilterViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *tabBarView;                    //!> 首页顶部的Tab视图的StoryBoard的容器.
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;              //!> 首页左右滚动视图.
@property (weak, nonatomic) IBOutlet UITableView *rcmdTableView;            //!> 首页推荐的上下滚动列表.
@property (weak, nonatomic) IBOutlet UITableView *inviteTableView;           //!> 首页本地的上下滚动的列表.
@property (weak, nonatomic) IBOutlet UIView *hintResultView;

@property (weak, nonatomic) IBOutlet UIButton *filterButton;

@property (strong, nonatomic) NSMutableArray *orderStrArray;                //!> 首页推荐、本地、邀约、达客数据表的排序表.
@property (strong, nonatomic) NSMutableArray *refreshDateArray;             //!> 首页各个Tab上次刷新的时间.
@property (strong, nonatomic) NSArray *rcmdTopArr;                          //!> 首页上方推荐.
@property (strong, nonatomic) NSArray *rcmdContentArr;                      //!> ???
@property (strong, nonatomic) NSArray *inviteContentArr;

@property (nonatomic, strong) LCTabView *tabView;                           //!> 首页顶部的Tab视图.
@property (nonatomic, strong) KLCPopup *planFilterPopup;

@property (strong, nonatomic) UIImage *formerNavbarShadowImage;             //!> 首页导航栏的背景图.
@property (strong, nonatomic) LCPlanTabSearchView *searchView;              //!> 首页导航栏的搜索框.

@property (assign, nonatomic) NSInteger fitlerThemeId;
@property (assign, nonatomic) UserSex inviteSex;
@property (assign, nonatomic) LCPlanOrderType inviteOrderType;
@property (strong, nonatomic) NSString *whatHotStr;
@end

@implementation LCPlanTabVC

#pragma mark - Public Interface
/// 首页的导航控制器.
+ (UINavigationController *)createNavInstance {
    return (UINavigationController *)[[UINavigationController alloc] initWithRootViewController:[self createInstance]];
}

/// 首页控制器.
+ (instancetype)createInstance {
    return (LCPlanTabVC *)[LCStoryboardManager viewControllerWithFileName:SBNamePlanTab identifier:NSStringFromClass([LCPlanTabVC class])];
}

#pragma mark - LifeCycle.
/// 初始化变量.
- (void)commonInit {
    [super commonInit];
    self.isHaveTabBar = YES;
    self.inviteSex = 0;
    self.inviteOrderType = 0;
    self.orderStrArray = [[NSMutableArray alloc] initWithCapacity:PlanTabVCTabNum];
    /// 一开始两个模块的排序字符串都为空.
    for (int i = 0; i < PlanTabVCTabNum; i++) {
        [self.orderStrArray addObject:@""];
    }
    self.refreshDateArray = [[NSMutableArray alloc] initWithCapacity:PlanTabVCTabNum];
    for (int i = 0; i < PlanTabVCTabNum; i++) {
        [self.refreshDateArray addObject:@""];
    }
    /// 读取缓存数据.
    LCDataManager *manager = [LCDataManager sharedInstance];
    self.rcmdTopArr = manager.rcmdTopArr;
    self.rcmdContentArr = manager.rcmdContentArr;
    self.inviteContentArr = manager.inviteContentArr;
}

- (void)refreshData {
    self.rcmdTopArr = [[LCDataBufferManager sharedInstance] refreshHomeRcmdArr:self.rcmdTopArr];
    self.rcmdContentArr = [[LCDataBufferManager sharedInstance] refreshPlanTourpicUserArr:self.rcmdContentArr];
    self.inviteContentArr = [[LCDataBufferManager sharedInstance] refreshPlanTourpicUserArr:self.inviteContentArr];
    [self updateShow];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /// 初始化导航栏.
    [self initNavBar];
    /// 初始化首页顶部的两个模块按钮.
    [self initUpperTabbar];
    /// 初始化左右滚动视图.
    [self initScrollView];
    /// 初始化首页推荐列表.
    [self initRcmdTableView];
    /// 初始化首页本地列表.
    [self initInviteTableView];
    if (self.rcmdContentArr.count > 0) {
        [self headerRefreshAction];
    } else {
        [self.rcmdTableView headerBeginRefreshing];
    }
    /// 初始化通知.
    [self initNotification];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:UIColorFromRGBA(0xfedd00, 1.0f)] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [LCDelegateManager sharedInstance].delegate = self;
    
    if ([LCDataManager sharedInstance].isFirstTimeOpenApp) {
        [LCDataManager sharedInstance].isFirstTimeOpenApp = NO;
        [[LCDataManager sharedInstance] saveData];
        if ([LCDataManager sharedInstance].isFirstInUseLogin) {
            [[LCRegisterAndLoginHelper sharedInstance] startLoginWithDelegate:self];
            [LCDataManager sharedInstance].isFirstInUseLogin = NO;
        } else {
            [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:self];
        }
    }

    switch ([[LCDataManager sharedInstance] jumpSourceType]) {
        case planTabJumpSourceTypeNone:
            break;
        case planTabJumpSourceTypeRecommend:
            [self tabView:self.tabView didSelectIndex:LCPlanTabVCTab_Invite];
            break;
        case planTabJumpSourceTypeSendPlan:
            [[LCSendPlanHelper sharedInstance] pushToSendFreePlanDestVC];
            break;
        case planTabJumpSourceTypeFavor:
            [self tabView:self.tabView didSelectIndex:LCPlanTabVCTab_Rcmd];
            break;
        default:
            break;
    }
    [LCDataManager sharedInstance].jumpSourceType = planTabJumpSourceTypeNone;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[LCUIConstants sharedInstance].navBarOpaqueImage forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:self.formerNavbarShadowImage];
}

#pragma mark - Common Init.
/// 初始化导航栏.
- (void)initNavBar {
    self.title = nil;
    self.formerNavbarShadowImage = self.navigationController.navigationBar.shadowImage;
    
    /// 首页顶部搜索视图.
    self.searchView = [LCPlanTabSearchView createInstance];
    self.searchView.frame = CGRectMake(0, (NAVIGATION_BAR_HEIGHT - 28.0f) / 2.0f, DEVICE_WIDTH - 104.0f, 28.0f);
    [self.searchView.searchButton addTarget:self action:@selector(searchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.searchView.alpha = 0.5;
    self.navigationItem.titleView = self.searchView;
}

/// 初始化首页顶部的两个模块按钮.
- (void)initUpperTabbar {
    LCTabView *tabView = [LCTabView createInstance];
    tabView.frame = CGRectMake(0, 0, DEVICE_WIDTH, LCTabViewHeight);
    [tabView updateButtons:@[@"推荐", @"邀约"] withMargin:(DEVICE_WIDTH - 270.0f) / 2.0f];
    tabView.delegate = self;
    tabView.selectIndex = LCPlanTabVCTab_Rcmd;
    self.tabView = tabView;
    [self.tabBarView addSubview:tabView];
}

/// 初始化左右滚动视图.
- (void)initScrollView {
    self.scrollView.delegate = self;
    self.scrollView.scrollsToTop = NO;
}

/// 初始化监听的通知.
- (void)initNotification {
    [self addObserveToNotificationNameToRefreshData:UIApplicationDidBecomeActiveNotification];
    [self addObserveToNotificationNameToRefreshData:UIApplicationDidBecomeActiveNotification];
    [self addObserveToNotificationNameToRefreshData:URL_FAVOR_PLAN];
    [self addObserveToNotificationNameToRefreshData:URL_ADD_COMMENT_TO_PLAN];
    [self addObserveToNotificationNameToRefreshData:URL_DELETE_COMMENT_OF_PLAN];
    [self addObserveToNotificationNameToRefreshData:NotificationJustUpdateLocation];
    [self addObserveToNotificationNameToRefreshData:URL_TOURPIC_PUBLISH];
    [self addObserveToNotificationNameToRefreshData:URL_LOGIN];
    [self addObserveToNotificationNameToRefreshData:URL_QUIT_PLAN];
}

/// 初始化首页推荐列表.
- (void)initRcmdTableView {
    self.rcmdTableView.delegate = self;
    self.rcmdTableView.dataSource = self;
    self.rcmdTableView.estimatedRowHeight = 180.0f;
    self.rcmdTableView.rowHeight = UITableViewAutomaticDimension;
    self.rcmdTableView.scrollsToTop = YES;
    
    [self.rcmdTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCHomeRcmdCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCHomeRcmdCell class])];
    [self.rcmdTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCHomeBannerCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCHomeBannerCell class])];
    [self.rcmdTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCFreePlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCFreePlanCell class])];
    [self.rcmdTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCCostPlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCCostPlanCell class])];
    [self.rcmdTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCHomeHotThemeCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCHomeHotThemeCell class])];
    [self.rcmdTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCHomeHotThemeTitleCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCHomeHotThemeTitleCell class])];

    
    [self.rcmdTableView addHeaderWithTarget:self action:@selector(headerRefreshAction)];
    [self.rcmdTableView addFooterWithTarget:self action:@selector(footerRefreshAction)];
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
    
    self.inviteTableView.scrollsToTop = NO;
}

#pragma mark - Common Func.
/// 获取到新的数据刷新视图.
- (void)updateShow {
    //[self.planHeaderView sizeToFit];
    
    NSInteger index = self.tabView.selectIndex;
    [self.scrollView scrollRectToVisible:CGRectMake(index * DEVICE_WIDTH, 0, DEVICE_WIDTH, 10) animated:NO];
    
    self.rcmdTableView.scrollsToTop = NO;
    self.inviteTableView.scrollsToTop = NO;
    
    switch (index) {
        case LCPlanTabVCTab_Rcmd:
            self.rcmdTableView.scrollsToTop = YES;
            [self.rcmdTableView reloadData];
            break;
        case LCPlanTabVCTab_Invite:
            self.inviteTableView.scrollsToTop = YES;
            [self.inviteTableView reloadData];
            break;
    }
    /// 缓存数据.
    LCDataManager *manager = [LCDataManager sharedInstance];
    manager.rcmdTopArr = self.rcmdTopArr;
    manager.rcmdContentArr = self.rcmdContentArr;
    manager.inviteContentArr = self.inviteContentArr;
}

/// 跳转到发布邀约页面.
- (void)sendPlan {
    [MobClick event:Mob_PublishPlan];
    if ([self haveLogin]) {
        [[LCSendPlanHelper sharedInstance] pushToSendFreePlanDestVC];
    } else {
        [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
    }
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
        centerY = DEVICE_HEIGHT - [planFilterView intrinsicContentSize].height / 2;
    }
    
    [self.planFilterPopup showAtCenter:CGPointMake(DEVICE_WIDTH / 2, centerY) inView:nil];
}

#pragma mark - Configure Cells.
/// 首页推荐的Cell.
- (UITableViewCell *)configureRcmdCell:(UITableView*)tableView withIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.section == self.rcmdTopArr.count) {//热门活动
        if (indexPath.row == 0) {
            LCHomeHotThemeTitleCell *titlePlanCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCHomeHotThemeTitleCell class]) forIndexPath:indexPath];
            cell = titlePlanCell;
        }else {
            LCPlanModel *plan = [self.rcmdContentArr objectAtIndex:indexPath.row-1];
            cell = [self configurePlanCell:tableView withIndexPath:indexPath withPlan:plan];
        }
    } else {
        LCHomeRcmd *homeRcmd = [self.rcmdTopArr objectAtIndex:indexPath.section];
        switch (homeRcmd.type) {
            case LCHomeRcmdType_ToDoList:
            case LCHomeRcmdType_Traing: {
                LCHomeBannerCell *bannerCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCHomeBannerCell class]) forIndexPath:indexPath];
                [bannerCell updateHomeBannerCell:homeRcmd];
                cell = bannerCell;
            }
                break;
            case LCHomeRcmdType_HotThemes: {
                LCHomeHotThemeCell *hotThemeCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCHomeHotThemeCell class]) forIndexPath:indexPath];
                [hotThemeCell updateHomeHotThemeCell:homeRcmd];
                cell = hotThemeCell;
            }
                break;
            case LCHomeRcmdType_Default:
            case LCHomeRcmdType_Nearby:
            case LCHomeRcmdType_Today:
            case LCHomeRcmdType_Tomorrow:
            case LCHomeRcmdType_Week:
            case LCHomeRcmdType_Rcmd: {
                if (0 == indexPath.row) {
                    cell = [self configureHomeRcmdCell:tableView withIndexPath:indexPath withHomeRcmd:homeRcmd];
                } else {
                    LCPlanModel *plan = homeRcmd.invitePlan;
                    cell = [self configurePlanCell:tableView withIndexPath:indexPath withPlan:plan];
                }
                
            }
                break;
            default:
                break;
        }
    }
    return cell;
}

- (UITableViewCell *)configurePlanCell:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath withPlan:(LCPlanModel *)plan {
    UITableViewCell *cell = nil;
    if (LCPlanType_CostPlan == plan.routeType || LCPlanType_CostLocal == plan.routeType) {
        LCCostPlanCell *costPlanCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCCostPlanCell class]) forIndexPath:indexPath];
        [costPlanCell updateShowWithPlan:plan];
        cell = costPlanCell;
    } else {
        LCFreePlanCell *freePlanCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCFreePlanCell class]) forIndexPath:indexPath];
        [freePlanCell updateShowWithPlan:plan hideThemeId:0 withSpaInset:YES];
        freePlanCell.delegate = [LCDelegateManager sharedInstance];
        cell = freePlanCell;
    }
    return cell;
}

- (UITableViewCell *)configureHomeRcmdCell:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath withHomeRcmd:(LCHomeRcmd *)homeRcmd {
    UITableViewCell *cell = nil;
    LCHomeRcmdCell *homeRcmdCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCHomeRcmdCell class]) forIndexPath:indexPath];
    [homeRcmdCell updateHomeRcmdCell:homeRcmd];
    cell = homeRcmdCell;
    return cell;
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
    if (nil == self.rcmdContentArr || 0 == self.rcmdContentArr.count) {
        [self.rcmdTableView footerEndRefreshing];
    } else {
        [self requestContentDatas];
    }
}

/// 重新请求数据.
- (void)requestContentDatas {
    switch (self.tabView.selectIndex) {
        case LCPlanTabVCTab_Rcmd:
            [self requestHomeRcmds];
            break;
        case LCPlanTabVCTab_Invite:
            [self requestHomeInvites];
            break;
        default:
            break;
    }
}

/// 从后台获取首页推荐的数据列表.
- (void)requestHomeRcmds {
    __weak typeof(self) weakSelf = self;
    [LCNetRequester requestHomeRcmds:self.orderStrArray[LCPlanTabVCTab_Rcmd] withCallBack:^(NSArray *rcmdArr, NSArray *contentArr, NSString *orderStr, NSString *whatHotStr, NSError *error) {
        [weakSelf.rcmdTableView headerEndRefreshing];
        [weakSelf.rcmdTableView footerEndRefreshing];
        if (!error) {
            if (nil != rcmdArr && rcmdArr.count > 0) {
                weakSelf.rcmdTopArr = rcmdArr;
            }
            if ([LCStringUtil isNullString:self.orderStrArray[LCPlanTabVCTab_Rcmd]]) {
                weakSelf.rcmdContentArr = [[NSArray alloc] init];
            }
            if (nil != contentArr && contentArr.count > 0) {
                weakSelf.rcmdContentArr = [LCSharedFuncUtil addFiltedArrayToArray:weakSelf.rcmdContentArr withUnfiltedArray:contentArr];
                self.refreshDateArray[LCPlanTabVCTab_Rcmd] = [LCDateUtil getCurrentDate];
                [self hideNotFoundPage];
            } else if ([LCStringUtil isNotNullString:weakSelf.orderStrArray[LCPlanTabVCTab_Rcmd]]) {
                if (LCPlanTabVCTab_Rcmd == weakSelf.tabView.selectIndex) {
                    [YSAlertUtil tipOneMessage:@"没有更多推荐内容"];
                }
            } else {
                [self showNotFoundPage];
            }
            weakSelf.orderStrArray[LCPlanTabVCTab_Rcmd] = orderStr;
            weakSelf.whatHotStr = whatHotStr;
            [weakSelf updateShow];
        } else {
            [YSAlertUtil tipOneMessage:error.domain];
        }
    }];
}

/// 从后台获取首页本地的数据列表.邀约
- (void)requestHomeInvites {
    __weak typeof(self) weakSelf = self;
    [LCNetRequester requestHomeInvites:self.orderStrArray[LCPlanTabVCTab_Invite] themeId:self.fitlerThemeId sex:self.inviteSex orderType:self.inviteOrderType withCallBack:^(NSArray *contentArr, NSString *orderStr, NSError *error) {
        [weakSelf.inviteTableView headerEndRefreshing];
        [weakSelf.inviteTableView footerEndRefreshing];
        if (!error) {
            if ([LCStringUtil isNullString:self.orderStrArray[LCPlanTabVCTab_Invite]]) {
                weakSelf.inviteContentArr = [[NSArray alloc] init];
            }
            if (nil != contentArr && contentArr.count > 0) {
                weakSelf.inviteContentArr = [LCSharedFuncUtil addFiltedArrayToArray:weakSelf.inviteContentArr withUnfiltedArray:contentArr];
                self.refreshDateArray[LCPlanTabVCTab_Invite] = [LCDateUtil getCurrentDate];
                [self hideNotFoundPage];
            } else if ([LCStringUtil isNotNullString:weakSelf.orderStrArray[LCPlanTabVCTab_Invite]]) {
                if (LCPlanTabVCTab_Invite == weakSelf.tabView.selectIndex) {
                    [YSAlertUtil tipOneMessage:@"没有更多邀约内容"];
                }
            } else {
                [self showNotFoundPage];
            }
            weakSelf.orderStrArray[LCPlanTabVCTab_Invite] = orderStr;
            [weakSelf updateShow];
        } else {
            [YSAlertUtil tipOneMessage:error.domain];
        }
    }];
}

#pragma mark - Button Action.

/// 点击搜索跳转搜索界面.
- (void)searchButtonAction:(id)sender {
    [MobClick event:V5_HOMEPAGE_SEARCH_CLICK];
    LCSearchDestinationVC *vc = [LCSearchDestinationVC createInstance];
    [self.navigationController pushViewController:vc animated:YES];
}

/// 右上角发布邀约.
- (IBAction)addPlanAction:(id)sender {
    [self sendPlan];
}

/// 左上角日历.
- (IBAction)calendarAction:(id)sender {
    LCCalendarSearchVC *vc = [LCCalendarSearchVC createInstance];
    vc.isCalenderSearch = YES;
    [self.navigationController pushViewController:vc animated:APP_ANIMATION];
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
    /// 点击了筛选按钮，然后刷新数据
    [self.inviteTableView headerBeginRefreshing];
    [self.inviteTableView scrollsToTop];
//    [self.inviteTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    

}

#pragma mark - LCTabView Delegate.
- (void)tabView:(LCTabView *)tabView didSelectIndex:(NSInteger)index {
    self.tabView.selectIndex = index;
    
    switch (self.tabView.selectIndex) {
        case LCPlanTabVCTab_Rcmd: {
            if ([LCStringUtil isNullString:[self.refreshDateArray objectAtIndex:LCPlanTabVCTab_Rcmd]]) {
                [self.rcmdTableView headerBeginRefreshing];
            } else {
                NSInteger interval = [LCDateUtil getTwoDateInterval:[LCDateUtil getCurrentDate] withDate2:[self.refreshDateArray objectAtIndex:LCPlanTabVCTab_Rcmd]];
                if (interval < HomePlanRefreshMinSec) {
                    [self.rcmdTableView headerBeginRefreshing];
                }
            }
        }
            break;
        case LCPlanTabVCTab_Invite: {
            if ([LCStringUtil isNullString:[self.refreshDateArray objectAtIndex:LCPlanTabVCTab_Invite]]) {
                [self.inviteTableView headerBeginRefreshing];
            } else {
                NSInteger interval = [LCDateUtil getTwoDateInterval:[LCDateUtil getCurrentDate] withDate2:[self.refreshDateArray objectAtIndex:LCPlanTabVCTab_Invite]];
                if (interval < HomePlanRefreshMinSec) {
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

#pragma mark - ScrollView Delegate
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
    } else if (scrollView == self.inviteTableView) {
        [UIView animateWithDuration:0.5 animations:^{
            self.filterButton.frame = CGRectMake(DEVICE_WIDTH * 2 - 43 - 15, self.filterButton.frame.origin.y, 43, 43);//显示
        }];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.inviteTableView) {
        if (self.inviteContentArr.count > 0) {
            [UIView animateWithDuration:0.5 animations:^{
                self.filterButton.frame = CGRectMake(DEVICE_WIDTH * 2, self.filterButton.frame.origin.y, 43, 43);//隐藏
            }];
        }
    }
}

#pragma mark - UITableView Delegate.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger number = 0;
    if (tableView == self.rcmdTableView) {
        number = self.rcmdTopArr.count + 1;
    } else if (tableView == self.inviteTableView) {
        number = 1;
    }
    return number;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger number = 0;
    if (tableView == self.rcmdTableView) {
        if (section < self.rcmdTopArr.count) {
            number = 1;
            LCHomeRcmd *homeRcmd = [self.rcmdTopArr objectAtIndex:section];
            if (LCHomeRcmdType_Rcmd == homeRcmd.type && NO == [homeRcmd.invitePlan isEmptyPlan]) {
                number = 2;
            }
        } else {
            if (self.rcmdTopArr.count>1)
                number = self.rcmdContentArr.count+1;
            else {
                number = self.rcmdContentArr.count;
            }
        }
    } else if (tableView == self.inviteTableView) {
        number = self.inviteContentArr.count;
    }
    
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (tableView == self.rcmdTableView) {
        cell = [self configureRcmdCell:tableView withIndexPath:indexPath];
    } else if (tableView == self.inviteTableView) {
        LCPlanModel *plan = [self.inviteContentArr objectAtIndex:indexPath.row];
        cell = [self configurePlanCell:tableView withIndexPath:indexPath withPlan:plan];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.rcmdTableView) {
        if (indexPath.section < self.rcmdTopArr.count) {
            if (0 == indexPath.section && indexPath.row == 1) {//suggest中的推荐
                LCHomeRcmd *homeRcmd = [self.rcmdTopArr objectAtIndex:indexPath.section];
                if (LCHomeRcmdType_Rcmd == homeRcmd.type && NO == [homeRcmd.invitePlan isEmptyPlan]) {
                    [LCViewSwitcher pushToShowPlanDetailVCForPlan:homeRcmd.invitePlan recmdUuid:@"" on:self.navigationController];
                }
            }
            }else if (self.rcmdTopArr.count == indexPath.section && indexPath.row > 0) {//显示热门活动
                LCPlanModel *model = [self.rcmdContentArr objectAtIndex:indexPath.row-1];
                [LCViewSwitcher pushToShowPlanDetailVCForPlan:model recmdUuid:@"" on:self.navigationController];
            }
        } else if (tableView == self.inviteTableView) {
        LCPlanModel *model = [self.inviteContentArr objectAtIndex:indexPath.row];
        [LCViewSwitcher pushToShowPlanDetailVCForPlan:model recmdUuid:@"" on:self.navigationController];
        }
}

#pragma mark 显示和隐藏“未找到结果页面”

- (void)showNotFoundPage {
    self.hintResultView.hidden = NO;
    self.inviteTableView.hidden = YES;
    [UIView animateWithDuration:0.5 animations:^{
        self.filterButton.frame = CGRectMake(DEVICE_WIDTH * 2 - 43 - 15, self.filterButton.frame.origin.y, 43, 43);//显示
    }];
}

- (void)hideNotFoundPage {
    self.hintResultView.hidden = YES;
    self.inviteTableView.hidden = NO;
}
@end
