
//
//  LCUserPlanListVC.m
//  LinkCity
//
//  Created by lhr on 16/5/30.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCUserPlanListVC.h"
#import "LCFreePlanCell.h"
#import "LCCostPlanCell.h"
#import "LCDelegateManager.h"
#import "LCSendPlanInSameCityVC.h"
#import "LCPlanTabVC.h"
#import "LCTabBarVC.h"

typedef enum : NSUInteger {
    LCUserPlanListType_Raised,
    LCUserPlanListType_Joined,
    LCUserPlanListType_Favored,
} LCHomeRecmLocalDuckrsType;

@interface LCUserPlanListVC ()<UITableViewDelegate, UITableViewDataSource, LCTabViewDelegate, UIScrollViewDelegate, LCDelegateManagerDelegate>

@property (weak, nonatomic) IBOutlet UIView *tabBarView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITableView *raisedTableView;

@property (weak, nonatomic) IBOutlet UITableView *joinedTableView;

@property (weak, nonatomic) IBOutlet UITableView *favoredTableView;

@property (nonatomic, strong) LCTabView *tabView;


@property (nonatomic, strong) NSArray *raisedContentArr;

@property (nonatomic, strong) NSString *raisedOrderStr;

@property (nonatomic, strong) NSArray *joinedContentArr;

@property (nonatomic, strong) NSString *joinedOrderStr;

@property (nonatomic, strong) NSArray *favoredContentArr;

@property (nonatomic, strong) NSString *favoredOrderStr;

@property (weak, nonatomic) IBOutlet UIImageView *emptyImageIcon;

@property (weak, nonatomic) IBOutlet UIView *emptyView;

@property (weak, nonatomic) IBOutlet UILabel *emptyTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *emptyDescLabel;

@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;
@end

@implementation LCUserPlanListVC
#pragma mark - LifeCycle && Init Function

+ (instancetype)createInstance {
    return (LCUserPlanListVC *)[LCStoryboardManager viewControllerWithFileName:SBNameUserTab identifier:VCIDUserPlanListVC];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// 初始化顶部的两个按钮.
    [self initUpperTabbar];
    /// 初始化左右滚动视图.
    [self initScrollView];
    /// 初始化同城达客列表.
    [self initRaisedTableView];
    /// 初始化在线达客—正在发生列表.
    [self initJoinedTableView];
    [self initFavoredTableView];
    /// 从后台获取在线达客的内容.
    //[self headerRefreshAction];
    self.emptyView.hidden = YES;
    [self.nextStepButton addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [self.raisedTableView headerBeginRefreshing];
    //[self requestPlanDuckrs];
    [self addObserveToNotificationNameToRefreshData:URL_FAVOR_PLAN];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [LCDelegateManager sharedInstance].delegate = self;
    
}

- (void)commonInit {
    [super commonInit];
    self.joinedOrderStr = @"";
    self.favoredOrderStr = @"";
    self.raisedOrderStr = @"";
}

#pragma mark - Common Init.

/// 初始化顶部的两个按钮.
- (void)initUpperTabbar {
    LCTabView *tabView = [LCTabView createInstance];
    tabView.frame = CGRectMake(0, 0, DEVICE_WIDTH, LCTabViewHeight);
    [tabView updateButtons:@[@"我发起的", @"我加入的",@"我感兴趣的"] withMargin:0];
    tabView.delegate = self;
    tabView.selectIndex = LCUserPlanListType_Raised;
    //
    //
    self.tabView = tabView;
    [self.tabBarView addSubview:tabView];
}


/// 初始化左右滚动视图.
- (void)initScrollView {
    self.scrollView.delegate = self;
    self.scrollView.scrollsToTop = NO;
}

/// 初始化RaisedTableView.

- (void)initRaisedTableView {
    self.raisedTableView.delegate = self;
    self.raisedTableView.dataSource = self;
    self.raisedTableView.estimatedRowHeight = 100.0f;
    self.raisedTableView.rowHeight = UITableViewAutomaticDimension;
    self.raisedTableView.scrollsToTop = YES;
    
    [self.raisedTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCCostPlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCCostPlanCell class])];
    [self.raisedTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCFreePlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCFreePlanCell class])];
    [self.raisedTableView addFooterWithTarget:self action:@selector(footerRefreshAction)];
    [self.raisedTableView addHeaderWithTarget:self action:@selector(headerRefreshAction)];
}


///初始化joinedTableView
- (void)initJoinedTableView {
    self.joinedTableView.delegate = self;
    self.joinedTableView.dataSource = self;
    self.joinedTableView.estimatedRowHeight = 100.0f;
    self.joinedTableView.rowHeight = UITableViewAutomaticDimension;
    self.joinedTableView.scrollsToTop = YES;
    
    [self.joinedTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCCostPlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCCostPlanCell class])];
    [self.joinedTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCFreePlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCFreePlanCell class])];
    [self.joinedTableView addFooterWithTarget:self action:@selector(footerRefreshAction)];
    [self.joinedTableView addHeaderWithTarget:self action:@selector(headerRefreshAction)];
}

///初始化joinedTableView
- (void)initFavoredTableView {
    self.favoredTableView.delegate = self;
    self.favoredTableView.dataSource = self;
    self.favoredTableView.estimatedRowHeight = 100.0f;
    self.favoredTableView.rowHeight = UITableViewAutomaticDimension;
    self.favoredTableView.scrollsToTop = YES;
    
    [self.favoredTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCCostPlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCCostPlanCell class])];
    [self.favoredTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCFreePlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCFreePlanCell class])];
    [self.favoredTableView addFooterWithTarget:self action:@selector(footerRefreshAction)];
    [self.favoredTableView addHeaderWithTarget:self action:@selector(headerRefreshAction)];
}


#pragma mark - Common Func.
/// 获取到新的数据刷新视图.
- (void)updateShow {
    
    
    
    NSInteger index = self.tabView.selectIndex;
    [self.scrollView scrollRectToVisible:CGRectMake(index * DEVICE_WIDTH, 0, DEVICE_WIDTH, self.scrollView.height) animated:NO];
    switch (index) {
        case LCUserPlanListType_Raised:
            [self.raisedTableView reloadData];
            if (self.raisedContentArr && self.raisedContentArr.count > 0) {
                self.emptyView.hidden = YES;
            } else {
                self.emptyView.hidden = NO;
            }
            break;
        case LCUserPlanListType_Joined:
            [self.joinedTableView reloadData];
            if (self.joinedContentArr && self.joinedContentArr.count > 0) {
                self.emptyView.hidden = YES;
            } else {
                self.emptyView.hidden = NO;
            }
            break;
        case LCUserPlanListType_Favored:
            [self.favoredTableView reloadData];
            if (self.favoredContentArr && self.favoredContentArr.count > 0) {
                self.emptyView.hidden = YES;
            } else {
                self.emptyView.hidden = NO;
            }
    }
    if (self.emptyView.hidden == NO) {
        [self configEmptyView];
    }
    
}

- (void)configEmptyView {
    switch (self.tabView.selectIndex) {
        case LCUserPlanListType_Raised:
            self.emptyDescLabel.text = @"发布自己的第一个邀约吧";
            self.emptyTitleLabel.text = @"还木有发起的邀约";
            [self.nextStepButton setTitle:@"发布邀约" forState:UIControlStateNormal];
            self.emptyImageIcon.image = [UIImage imageNamed:@"UserTabNoRaisedPlanIcon"];
            break;
        case LCUserPlanListType_Joined:
            self.emptyDescLabel.text = @"去寻找自己感兴趣的邀约活动吧";
            self.emptyTitleLabel.text = @"还木有加入的邀约";
            [self.nextStepButton setTitle:@"去看看" forState:UIControlStateNormal];
            self.emptyImageIcon.image = [UIImage imageNamed:@"UserTabNoJoinedPlanIcon"];
            break;
        case LCUserPlanListType_Favored:
            self.emptyDescLabel.text = @"去发现自己感兴趣的活动吧";
            self.emptyTitleLabel.text = @"还木有感兴趣的邀约";
            [self.nextStepButton setTitle:@"去看看" forState:UIControlStateNormal];
            self.emptyImageIcon.image = [UIImage imageNamed:@"UserTabNoFavoredPlanIcon"];
            break;
        default:
            break;
    }
}


- (void)refreshData {
    [self.favoredTableView reloadData];
    [self.joinedTableView reloadData];
    [self.raisedTableView reloadData];
}

#pragma mark - Server Request.
/// 下拉刷新.
- (void)headerRefreshAction {
    NSInteger index = self.tabView.selectIndex;
    switch (index) {
        case LCUserPlanListType_Raised:
            self.raisedOrderStr = @"";
            break;
        case LCUserPlanListType_Joined:
            self.joinedOrderStr = @"";
            break;
        case LCUserPlanListType_Favored:
            self.favoredOrderStr = @"";
    }
    [self requestContentDatas];
}
/// 上拉加载更多.
- (void)footerRefreshAction {
    [self requestContentDatas];
}

/// 重新请求数据.
- (void)requestContentDatas {
    NSInteger index = self.tabView.selectIndex;
    switch (index) {
        case LCUserPlanListType_Raised:
            [self requestRaisedUserPlanList];
            break;
        case LCUserPlanListType_Joined:
            [self requestJoinedUserPlanList];
            break;
        case LCUserPlanListType_Favored:
            [self requestFavoredUserPlanList];
            break;
    }
}
- (void)requestRaisedUserPlanList {
    __weak typeof(self) weakSelf = self;
    
    [LCNetRequester getUserRaisedPlan:[[LCDataManager sharedInstance] userInfo].uUID orderString:self.raisedOrderStr callBack:^(NSArray *contentArr,NSString *orderStr,NSError *error){
        [weakSelf.raisedTableView headerEndRefreshing];
        [weakSelf.raisedTableView footerEndRefreshing];
        
        if (!error) {
            if ([LCStringUtil isNullString:weakSelf.raisedOrderStr]) {
                if (nil != contentArr && contentArr.count > 0) {
                    weakSelf.raisedContentArr = contentArr;
                } else {
                    //[YSAlertUtil tipOneMessage:@"没有你发起的活动"];
                }
            } else {
                if (nil != contentArr && contentArr.count > 0) {
                    NSMutableArray *mutArr = [[NSMutableArray alloc] initWithArray:self.raisedContentArr];
                    [mutArr addObjectsFromArray:contentArr];
                    weakSelf.raisedContentArr = mutArr;
                } else {
                    [YSAlertUtil tipOneMessage:@"没有更多你发起的活动"];
                }
            }
            weakSelf.raisedOrderStr = orderStr;
            [weakSelf updateShow];
        } else {
            [YSAlertUtil tipOneMessage:error.domain];
        }
    }];
    
}

- (void)requestJoinedUserPlanList {
    __weak typeof(self) weakSelf = self;
    
    [LCNetRequester getUserJoinedPlan:[[LCDataManager sharedInstance] userInfo].uUID orderString:self.joinedOrderStr callBack:^(NSArray *contentArr,NSString *orderStr,NSError *error){
        [weakSelf.joinedTableView headerEndRefreshing];
        [weakSelf.joinedTableView footerEndRefreshing];
        if (!error) {
            if ([LCStringUtil isNullString:weakSelf.joinedOrderStr]) {
                if (nil != contentArr && contentArr.count > 0) {
                    weakSelf.joinedContentArr = contentArr;
                } else {
                    //[YSAlertUtil tipOneMessage:@"没有你参加的活动"];
                }
            } else {
                if (nil != contentArr && contentArr.count > 0) {
                    NSMutableArray *mutArr = [[NSMutableArray alloc] initWithArray:self.joinedContentArr];
                    [mutArr addObjectsFromArray:contentArr];
                    weakSelf.joinedContentArr = mutArr;
                } else {
                    [YSAlertUtil tipOneMessage:@"没有更多你参加的活动"];
                }
            }
            weakSelf.joinedOrderStr = orderStr;
            [weakSelf updateShow];
        } else {
            [YSAlertUtil tipOneMessage:error.domain];
        }
    }];

}



- (void)requestFavoredUserPlanList {
    __weak typeof(self) weakSelf = self;
    
    [LCNetRequester getUserFavoredPlan:[[LCDataManager sharedInstance] userInfo].uUID orderString:self.favoredOrderStr callBack:^(NSArray *contentArr,NSString *orderStr,NSError *error){
        [weakSelf.favoredTableView headerEndRefreshing];
        [weakSelf.favoredTableView footerEndRefreshing];
        if (!error) {
            if ([LCStringUtil isNullString:weakSelf.favoredOrderStr]) {
                if (nil != contentArr && contentArr.count > 0) {
                    weakSelf.favoredContentArr = contentArr;
                } else {
                    //[YSAlertUtil tipOneMessage:@"没有你参加的活动"];
                }
            } else {
                if (nil != contentArr && contentArr.count > 0) {
                    NSMutableArray *mutArr = [[NSMutableArray alloc] initWithArray:self.joinedContentArr];
                    [mutArr addObjectsFromArray:contentArr];
                    weakSelf.favoredContentArr = mutArr;
                } else {
                    [YSAlertUtil tipOneMessage:@"没有更多你参加的活动"];
                }
            }
            weakSelf.favoredOrderStr = orderStr;
            [weakSelf updateShow];
        } else {
            [YSAlertUtil tipOneMessage:error.domain];
        }
    }];
    
    
}


#pragma mark - LCTabView Delegate.
- (void)tabView:(LCTabView *)tabView didSelectIndex:(NSInteger)index {
    self.tabView.selectIndex = index;
    switch (self.tabView.selectIndex) {
        case LCUserPlanListType_Raised:
            if ((!self.raisedContentArr) || self.raisedContentArr.count == 0) {
                [self.raisedTableView headerBeginRefreshing];
            }
            break;
        case LCUserPlanListType_Joined:
            if ((!self.joinedContentArr) || self.joinedContentArr.count == 0) {
                [self.joinedTableView headerBeginRefreshing];
            }
            break;
        case LCUserPlanListType_Favored:
            if ((!self.favoredContentArr) || self.favoredContentArr.count == 0) {
                [self.favoredTableView headerBeginRefreshing];
            }
            break;
        default:
            break;
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

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger number = 0;
    if (tableView == self.raisedTableView) {
        number = self.raisedContentArr.count;
    } else if (tableView == self.favoredTableView) {
        number = self.favoredContentArr.count;
    } else if (tableView == self.joinedTableView) {
        number = self.joinedContentArr.count;
    }
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    LCPlanModel *plan;
    if (tableView == self.raisedTableView) {
        plan = [self.raisedContentArr objectAtIndex:indexPath.row];
    } else if (tableView == self.favoredTableView) {
        plan = [self.favoredContentArr objectAtIndex:indexPath.row];
    } else if (tableView == self.joinedTableView) {
        plan = [self.joinedContentArr objectAtIndex:indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (LCPlanType_CostPlan == plan.routeType || LCPlanType_CostLocal == plan.routeType) {
        LCCostPlanCell *costPlanCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCCostPlanCell class]) forIndexPath:indexPath];
        [costPlanCell updateShowWithPlan:plan];
        cell = costPlanCell;
    } else {
        LCFreePlanCell *freePlanCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCFreePlanCell class]) forIndexPath:indexPath];
        if (indexPath.row != ([tableView numberOfRowsInSection:indexPath.section] - 1))
            [freePlanCell updateShowWithPlan:plan hideThemeId:0 withSpaInset:YES];
        else
            [freePlanCell updateShowWithPlan:plan hideThemeId:0 withSpaInset:NO];
        freePlanCell.delegate = [LCDelegateManager sharedInstance];
        cell = freePlanCell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LCPlanModel *plan;
    if (tableView == self.raisedTableView) {
        plan = [self.raisedContentArr objectAtIndex:indexPath.row];
    } else if (tableView == self.favoredTableView) {
        plan = [self.favoredContentArr objectAtIndex:indexPath.row];
    } else if (tableView == self.joinedTableView) {
        plan = [self.joinedContentArr objectAtIndex:indexPath.row];
    }
     [LCViewSwitcher pushToShowPlanDetailVCForPlan:plan recmdUuid:@"" on:self.navigationController];
}

#pragma mark - LCDelegateManager Delegate
- (void)updateViewShow {
    [self updateShow];
}

- (void)nextAction {
    [self.navigationController popViewControllerAnimated:NO];
    
    switch (self.tabView.selectIndex) {
        case LCUserPlanListType_Raised:
            // 发邀约.
            [LCDataManager sharedInstance].jumpSourceType = planTabJumpSourceTypeSendPlan;
            break;
        case LCUserPlanListType_Joined:
            //首页邀约，得切换
            [LCDataManager sharedInstance].jumpSourceType = planTabJumpSourceTypeRecommend;
            break;
        case LCUserPlanListType_Favored:
           //推荐，啥也不用做
            [LCDataManager sharedInstance].jumpSourceType = planTabJumpSourceTypeFavor;
            break;
        default:
            break;
    }
    [[LCSharedFuncUtil getAppDelegate].tabBarVC setSelectedIndex:0];
}

@end
