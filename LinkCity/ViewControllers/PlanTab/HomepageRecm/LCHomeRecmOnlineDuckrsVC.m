//
//  LCHomeRecmOnlineDuckrsVC.m
//  LinkCity
//
//  Created by 张宗硕 on 5/18/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCHomeRecmOnlineDuckrsVC.h"
#import "LCHomeUserCell.h"
#import "LCTourpicCell.h"
#import "LCFreePlanCell.h"
#import "LCCostPlanCell.h"

@interface LCHomeRecmOnlineDuckrsVC ()<UITableViewDelegate, UITableViewDataSource, LCTabViewDelegate, UIScrollViewDelegate, LCTourpicCellDelegate, LCDelegateManagerDelegate>
@property (nonatomic, strong) LCTabView *tabView;                           //!> 顶部的Tab视图.
@property (weak, nonatomic) IBOutlet UIView *tabBarView;                    //!> 顶部的Tab视图的StoryBoard的容器.
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;              //!> 左右滚动视图.
@property (weak, nonatomic) IBOutlet UITableView *onlineTableView;          //!> 在线达客的上下滚动列表.
@property (weak, nonatomic) IBOutlet UITableView *happenTableView;          //!> 正在发生的上下滚动的列表.

@property (strong, nonatomic) NSArray *onlineContentArr;                    //!> 在线达客数据表.
@property (strong, nonatomic) NSArray *happenContentArr;                    //!> 正在发生数据表.
@property (strong, nonatomic) NSString *onlineOrderStr;                     //!> 在线达客排序字符串.
@property (strong, nonatomic) NSString *happenOrderStr;                     //!> 正在发生排序字符串.
@end

@implementation LCHomeRecmOnlineDuckrsVC

#pragma mark - Public Interface
+ (instancetype)createInstance {
    return (LCHomeRecmOnlineDuckrsVC *)[LCStoryboardManager viewControllerWithFileName:SBNamePlanTab identifier:VCIDHomeRecmOnlineDuckrsVC];
}

#pragma mark - LifeCycle.
- (void)viewDidLoad {
    [super viewDidLoad];
    /// 初始化顶部的两个按钮.
    [self initUpperTabbar];
    /// 初始化左右滚动视图.
    [self initScrollView];
    /// 初始化在线达客列表.
    [self initOnlineTableView];
    /// 初始化在线达客—正在发生列表.
    [self initHappenTableView];
    /// 从后台获取在线达客的内容.
    self.onlineContentArr = [LCDataManager sharedInstance].homeRecmOnlineDuckrArr;
    if (nil == self.onlineContentArr || 0 == self.onlineContentArr.count) {
        [self.onlineTableView headerBeginRefreshing];
    } else {
        [self headerRefreshAction];
    }
    self.happenContentArr = [LCDataManager sharedInstance].homeRecmOnlineHappenArr;
    /// 从后台获取在线达客—正在发生的内容.
    [self requestOnlineHappens];
     [self addObserveToNotificationNameToRefreshData:URL_FAVOR_PLAN];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [LCDelegateManager sharedInstance].delegate = self;
}

#pragma mark - LifeCycle.
/// 初始化变量.
- (void)commonInit {
    [super commonInit];
    self.onlineOrderStr = @"";
    self.happenOrderStr = @"";
}

#pragma mark - Common Init.
/// 初始化顶部的两个按钮.
- (void)initUpperTabbar {
    LCTabView *tabView = [LCTabView createInstance];
    tabView.frame = CGRectMake(0, 0, DEVICE_WIDTH, LCTabViewHeight);
    [tabView updateButtons:@[@"在线达客", @"正在发生"] withMargin:0];
    tabView.delegate = self;
    tabView.selectIndex = LCHomeRecmOnlineDuckrsType_Online;
    self.tabView = tabView;
    [self.tabBarView addSubview:tabView];
}

/// 初始化左右滚动视图.
- (void)initScrollView {
    self.scrollView.delegate = self;
    self.scrollView.scrollsToTop = NO;
}

/// 初始化在线达客列表.
- (void)initOnlineTableView {
    self.onlineTableView.delegate = self;
    self.onlineTableView.dataSource = self;
    self.onlineTableView.estimatedRowHeight = 180.0f;
    self.onlineTableView.rowHeight = UITableViewAutomaticDimension;
    self.onlineTableView.scrollsToTop = YES;
    
    [self.onlineTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCHomeUserCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCHomeUserCell class])];
    
    [self.onlineTableView addHeaderWithTarget:self action:@selector(headerRefreshAction)];
    [self.onlineTableView addFooterWithTarget:self action:@selector(footerRefreshAction)];
}

/// 初始化在线达客—正在发生列表.
- (void)initHappenTableView {
    self.happenTableView.delegate = self;
    self.happenTableView.dataSource = self;
    self.happenTableView.estimatedRowHeight = 180.0f;
    self.happenTableView.rowHeight = UITableViewAutomaticDimension;
    self.happenTableView.scrollsToTop = YES;
    
    [self.happenTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCTourpicCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCTourpicCell class])];
    [self.happenTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCFreePlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCFreePlanCell class])];
    [self.happenTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCCostPlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCCostPlanCell class])];
    
    [self.happenTableView addHeaderWithTarget:self action:@selector(headerRefreshAction)];
    [self.happenTableView addFooterWithTarget:self action:@selector(footerRefreshAction)];
}

- (void)refreshData {
    [self.happenTableView reloadData];
}
#pragma mark - Common Func.
/// 获取到新的数据刷新视图.
- (void)updateShow {
    [LCDataManager sharedInstance].homeRecmOnlineDuckrArr = self.onlineContentArr;
    [LCDataManager sharedInstance].homeRecmOnlineHappenArr = self.happenContentArr;
    NSInteger index = self.tabView.selectIndex;
    [self.scrollView scrollRectToVisible:CGRectMake(index * DEVICE_WIDTH, 0, DEVICE_WIDTH, self.scrollView.height) animated:NO];
    switch (index) {
        case LCHomeRecmOnlineDuckrsType_Online:
            [self.onlineTableView reloadData];
            break;
        case LCHomeRecmOnlineDuckrsType_Happen:
            [self.happenTableView reloadData];
            break;
    }
}

#pragma mark - Server Request.
/// 下拉刷新.
- (void)headerRefreshAction {
    self.onlineOrderStr = @"";
    self.happenOrderStr = @"";
    [self requestContentDatas];
}

/// 上拉加载更多.
- (void)footerRefreshAction {
    [self requestContentDatas];
}

/// 重新请求数据.
- (void)requestContentDatas {
    switch (self.tabView.selectIndex) {
        case LCHomeRecmOnlineDuckrsType_Online:
            [self requestOnlineDuckrs];
            break;
        case LCHomeRecmOnlineDuckrsType_Happen:
            [self requestOnlineHappens];
            break;
        default:
            break;
    }
}

/// 从后台获取在线达客数据.
- (void)requestOnlineDuckrs {
    [LCNetRequester getHomeRecmOnlineDuckrs:self.onlineOrderStr callBack:^(NSArray *contentArr, NSString *orderStr, NSError *error) {
        [self.onlineTableView headerEndRefreshing];
        [self.onlineTableView footerEndRefreshing];
        if (!error) {
            if ([LCStringUtil isNullString:self.onlineOrderStr]) {
                if (nil != contentArr && contentArr.count > 0) {
                    self.onlineContentArr = [LCSharedFuncUtil addFiltedArrayToArray:nil withUnfiltedArray:contentArr];
                } else {
                    [YSAlertUtil tipOneMessage:@"没有在线达客"];
                }
            } else {
                if (nil != contentArr && contentArr.count > 0) {
                    self.onlineContentArr = [LCSharedFuncUtil addFiltedArrayToArray:self.onlineContentArr withUnfiltedArray:contentArr];
                } else {
                    [YSAlertUtil tipOneMessage:@"没有更多在线达客"];
                }
            }
            self.onlineOrderStr = orderStr;
            [self updateShow];
        } else {
            [YSAlertUtil tipOneMessage:error.domain];
        }
    }];
}

/// 从后台获取在线达客—正在发生数据.
- (void)requestOnlineHappens {
    [LCNetRequester getHomeRecmOnlineHappens:self.happenOrderStr callBack:^(NSArray *contentArr, NSString *orderStr, NSError *error) {
        [self.happenTableView headerEndRefreshing];
        [self.happenTableView footerEndRefreshing];
        if (!error) {
            if ([LCStringUtil isNullString:self.happenOrderStr]) {
                if (nil != contentArr && contentArr.count > 0) {
                    self.happenContentArr = contentArr;
                } else {
                    [YSAlertUtil tipOneMessage:@"没有在线达客发布的内容"];
                }
            } else {
                if (nil != contentArr && contentArr.count > 0) {
                    NSMutableArray *mutArr = [[NSMutableArray alloc] initWithArray:self.happenContentArr];
                    [mutArr addObjectsFromArray:contentArr];
                    self.happenContentArr = mutArr;
                } else {
                    [YSAlertUtil tipOneMessage:@"没有更多在线达客发布的内容"];
                }
            }
            self.happenOrderStr = orderStr;
            [self updateShow];
        } else {
            [YSAlertUtil tipOneMessage:error.domain];
        }
    }];
}

#pragma mark - LCTourpicCell Delegate.
/// 旅图点击评论的回调函数.
- (void)tourpicCommentSelected:(LCTourpicCell *)cell {
    if (![self haveLogin]) {
        [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
        return ;
    }
    [LCViewSwitcher pushToShowTourPicDetail:cell.tourpic withType:LCTourpicDetailVCViewType_Comment on:self.navigationController];
}

#pragma mark - LCTabView Delegate.
- (void)tabView:(LCTabView *)tabView didSelectIndex:(NSInteger)index {
    self.tabView.selectIndex = index;
    if (LCHomeRecmOnlineDuckrsType_Online == self.tabView.selectIndex) {
        if (nil == self.onlineContentArr || 0 == self.onlineContentArr) {
            [self.onlineTableView headerBeginRefreshing];
        } else {
            [self requestOnlineDuckrs];
        }
    } else if (LCHomeRecmOnlineDuckrsType_Happen == self.tabView.selectIndex) {
        [MobClick event:V5_HOMEPAGE_RECM_DUCKR_HAPPENING_CLICK];
        if (nil == self.happenContentArr || 0 == self.happenContentArr) {
            [self.happenTableView headerBeginRefreshing];
        } else {
            [self requestOnlineHappens];
        }
    }
    [self updateShow];
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.scrollView == scrollView) {
        int index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
        [self.tabView setSelectIndex:index];
        [self tabView:self.tabView didSelectIndex:index];
        [self.scrollView setContentOffset:CGPointMake(index * DEVICE_WIDTH, 0.0f) animated:YES];
    }
}

#pragma mark - Configure Cells.
- (UITableViewCell *)configureTourpicPlanUserCell:(UITableView *)tableView data:(id)obj withIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if ([obj isKindOfClass:[LCTourpic class]]) {
        LCTourpic *tourpic = (LCTourpic *)obj;
        LCTourpicCell *tourpicCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCTourpicCell class]) forIndexPath:indexPath];
        tourpicCell.delegate = self;
        [tourpicCell updateTourpicCell:tourpic withType:LCTourpicCellViewType_Cell];
        cell = tourpicCell;
    } else if ([obj isKindOfClass:[LCPlanModel class]]) {
        LCPlanModel *plan = (LCPlanModel *)obj;
        if (LCPlanType_CostPlan == plan.routeType || LCPlanType_CostLocal == plan.routeType) {
            LCCostPlanCell *costPlanCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCCostPlanCell class]) forIndexPath:indexPath];
            [costPlanCell updateShowWithPlan:plan];
            cell = costPlanCell;
        } else {
            LCFreePlanCell *freePlanCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCFreePlanCell class]) forIndexPath:indexPath];
            if (indexPath.row != ([tableView numberOfRowsInSection:indexPath.section] - 1)) {
                [freePlanCell updateShowWithPlan:plan hideThemeId:0 withSpaInset:YES];
            } else {
                [freePlanCell updateShowWithPlan:plan hideThemeId:0 withSpaInset:NO];
            }
            freePlanCell.delegate = [LCDelegateManager sharedInstance];
            cell = freePlanCell;
        }
    } else if ([obj isKindOfClass:[LCUserModel class]]) {
        LCUserModel *user = (LCUserModel *)obj;
        LCHomeUserCell *homeUserCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCHomeUserCell class]) forIndexPath:indexPath];
        [homeUserCell updateShowCell:user withType:LCHomeUserCellViewType_HomeRecmOnlineDuckr];
        cell = homeUserCell;
    }
    return cell;
}

#pragma mark - UITableView Delegate.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger number = 0;
    if (tableView == self.onlineTableView) {
        number = self.onlineContentArr.count;
    } else if (tableView == self.happenTableView) {
        number = self.happenContentArr.count;
    }
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    id obj = nil;
    if (tableView == self.onlineTableView) {
        obj = [self.onlineContentArr objectAtIndex:indexPath.row];
    } else if (tableView == self.happenTableView) {
        obj = [self.happenContentArr objectAtIndex:indexPath.row];
    }
    cell = [self configureTourpicPlanUserCell:tableView data:obj withIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id obj = nil;
    if (tableView == self.onlineTableView) {
        obj = [self.onlineContentArr objectAtIndex:indexPath.row];
    } else if (tableView == self.happenTableView) {
        obj = [self.happenContentArr objectAtIndex:indexPath.row];
    }
    if ([obj isKindOfClass:[LCTourpic class]]) {
        LCTourpic *tourpic = (LCTourpic *)obj;
        [LCViewSwitcher pushToShowTourPicDetail:tourpic withType:LCTourpicDetailVCViewType_Normal on:self.navigationController];
    } else if ([obj isKindOfClass:[LCPlanModel class]]) {
        LCPlanModel *plan = (LCPlanModel *)obj;
        [LCViewSwitcher pushToShowPlanDetailVCForPlan:plan recmdUuid:@"" on:self.navigationController];
    } else if ([obj isKindOfClass:[LCUserModel class]]) {
        LCUserModel *user = (LCUserModel *)obj;
        [LCViewSwitcher pushToShowUserInfoVCForUser:user on:[LCSharedFuncUtil getTopMostNavigationController]];
    }
}

#pragma mark - LCDelegateManager Delegate
- (void)updateViewShow {
    [self updateShow];
}
@end