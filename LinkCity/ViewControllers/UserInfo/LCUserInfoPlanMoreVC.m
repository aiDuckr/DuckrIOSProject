//
//  LCUserInfoPlanMoreVC.m
//  LinkCity
//
//  Created by godhangyu on 16/6/10.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCUserInfoPlanMoreVC.h"
#import "LCFreePlanCell.h"
#import "LCCostPlanCell.h"

@interface LCUserInfoPlanMoreVC ()<UITableViewDataSource, UITableViewDelegate, LCTabViewDelegate, UIScrollViewDelegate>

// Data
@property (nonatomic, strong) NSMutableArray *planOrganizeArray;
@property (nonatomic, strong) NSString *planOrganizeOrderStr;
@property (nonatomic, strong) NSMutableArray *planJoinArray;
@property (nonatomic, strong) NSString *planJoinOrderStr;
@property (nonatomic, strong) NSMutableArray *planLikedArray;
@property (nonatomic, strong) NSString *planLikedOrderStr;

@property (nonatomic, assign) NSInteger tabViewIndex;


// UI
@property (nonatomic, strong) LCTabView *tabView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *tabViewContainer;
@property (weak, nonatomic) IBOutlet UITableView *planOrganizeTableView;
@property (weak, nonatomic) IBOutlet UITableView *planJoinTableView;
@property (weak, nonatomic) IBOutlet UITableView *planLikedTableView;


@end

@implementation LCUserInfoPlanMoreVC

+ (instancetype)createInstance {
    return (LCUserInfoPlanMoreVC *)[LCStoryboardManager viewControllerWithFileName:SBNameUser identifier:VCIDUserInfoPlanMoreVC];
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNavigationBar];
    [self initTabView];
    [self initTableView];
    [self initScrollView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self initNavigationBar];
    [self updateShow];
}

#pragma mark - Common Init

- (void)initNavigationBar {
    self.navigationController.navigationBar.tintColor = UIColorFromRGBA(NavigationBarTintColor, 1);
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

- (void)initTabView {
    LCTabView *tabView = [LCTabView createInstance];
    tabView.frame = CGRectMake(0, 0, DEVICE_WIDTH, LCTabViewHeight);
    tabView.delegate = self;
    tabView.selectIndex = 0;
    self.tabView = tabView;
    [self.tabView updateButtons:@[@"Ta发起的", @"Ta加入的", @"Ta感兴趣的"] withMargin:0];
    [self.tabViewContainer addSubview:self.tabView];
}

- (void)initTableView {
    self.planOrganizeTableView.delegate = self;
    self.planOrganizeTableView.dataSource = self;
    self.planOrganizeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.planOrganizeTableView.estimatedRowHeight = 180.0f;
    self.planOrganizeTableView.rowHeight = UITableViewAutomaticDimension;
    [self.planOrganizeTableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    [self.planOrganizeTableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    [self.planOrganizeTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCFreePlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCFreePlanCell class])];
    [self.planOrganizeTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCCostPlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCCostPlanCell class])];
    
    self.planJoinTableView.delegate = self;
    self.planJoinTableView.dataSource = self;
    self.planJoinTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.planJoinTableView.estimatedRowHeight = 180.0f;
    self.planJoinTableView.rowHeight = UITableViewAutomaticDimension;
    [self.planJoinTableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    [self.planJoinTableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    [self.planJoinTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCFreePlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCFreePlanCell class])];
    [self.planJoinTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCCostPlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCCostPlanCell class])];
    
    self.planLikedTableView.delegate = self;
    self.planLikedTableView.dataSource = self;
    self.planLikedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.planLikedTableView.estimatedRowHeight = 180.0f;
    self.planLikedTableView.rowHeight = UITableViewAutomaticDimension;
    [self.planLikedTableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    [self.planLikedTableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    [self.planLikedTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCFreePlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCFreePlanCell class])];
    [self.planLikedTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCCostPlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCCostPlanCell class])];
}

- (void)initScrollView {
    self.scrollView.delegate = self;
}

- (void)updateShow {
    if (self.tabViewIndex != self.tabView.selectIndex) {
        self.tabViewIndex = self.tabView.selectIndex;
        [self.scrollView scrollRectToVisible:CGRectMake(self.tabViewIndex * DEVICE_WIDTH, 0, DEVICE_WIDTH, 10) animated:NO];
    }
    
    switch (self.tabViewIndex) {
        case 0:
            if ([LCStringUtil isNullString:self.planOrganizeOrderStr]) {
                [self.planOrganizeTableView headerBeginRefreshing];
                return;
            }
            [self.planOrganizeTableView reloadData];
            break;
        case 1:
            if ([LCStringUtil isNullString:self.planJoinOrderStr]) {
                [self.planJoinTableView headerBeginRefreshing];
                return;
            }
            [self.planJoinTableView reloadData];
            break;
        case 2:
            if ([LCStringUtil isNullString:self.planLikedOrderStr]) {
                [self.planLikedTableView headerBeginRefreshing];
                return;
            }
            [self.planLikedTableView reloadData];
            break;
    }
    
    [self.planOrganizeTableView headerEndRefreshing];
    [self.planOrganizeTableView footerEndRefreshing];
    [self.planOrganizeTableView headerEndRefreshing];
    [self.planOrganizeTableView footerEndRefreshing];
    [self.planLikedTableView headerEndRefreshing];
    [self.planLikedTableView footerEndRefreshing];
    
}

#pragma mark - Net Request

- (void)requestOrganizePlanArrayFromOrderString:(NSString *)orderStr {
    __weak typeof(self) weakSelf = self;
    
    [LCNetRequester getUserRaisedPlan:self.user.uUID orderString:orderStr callBack:^(NSArray *planList, NSString *orderStr, NSError *error) {
        if (!error) {
            [self.planOrganizeTableView headerEndRefreshing];
            [self.planOrganizeTableView footerEndRefreshing];
            if ([LCStringUtil isNullString:weakSelf.planOrganizeOrderStr]) {
                if (nil != planList && planList.count > 0) {
                    weakSelf.planOrganizeArray = [[NSMutableArray alloc] initWithArray:planList];
                } else {
                    [YSAlertUtil tipOneMessage:@"Ta没有发起的活动"];
                }
            } else {
                if (nil != planList && planList.count > 0) {
                    [weakSelf.planOrganizeArray addObjectsFromArray:planList];
                } else {
                    [YSAlertUtil tipOneMessage:@"没有更多Ta发起的活动"];
                }
            }
            weakSelf.planOrganizeOrderStr = orderStr;
            [self updateShow];
        } else {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
        }
    }];
}

- (void)requestJoinPlanArrayFromOrderString:(NSString *)orderStr {
    __weak typeof(self) weakSelf = self;
    
    [LCNetRequester getUserJoinedPlan:self.user.uUID orderString:orderStr callBack:^(NSArray *planList, NSString *orderStr, NSError *error) {
        if (!error) {
            [self.planJoinTableView headerEndRefreshing];
            [self.planJoinTableView footerEndRefreshing];
            if ([LCStringUtil isNullString:weakSelf.planJoinOrderStr]) {
                if (nil != planList && planList.count > 0) {
                    weakSelf.planJoinArray = [[NSMutableArray alloc] initWithArray:planList];
                } else {
                    [YSAlertUtil tipOneMessage:@"Ta没有加入的活动"];
                }
            } else {
                if (nil != planList && planList.count > 0) {
                    [weakSelf.planJoinArray addObjectsFromArray:planList];
                } else {
                    [YSAlertUtil tipOneMessage:@"没有更多Ta加入的活动"];
                }
            }
            weakSelf.planJoinOrderStr = orderStr;
            [self updateShow];
        } else {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
        }
    }];
}

- (void)requestLikePlanArrayFromOrderString:(NSString *)orderStr {
    __weak typeof(self) weakSelf = self;
    
    [LCNetRequester getUserFavoredPlan:self.user.uUID orderString:orderStr callBack:^(NSArray *planList, NSString *orderStr, NSError *error) {
        if (!error) {
            [self.planLikedTableView headerEndRefreshing];
            [self.planLikedTableView footerEndRefreshing];
            if ([LCStringUtil isNullString:weakSelf.planLikedOrderStr]) {
                if (nil != planList && planList.count > 0) {
                    weakSelf.planLikedArray = [[NSMutableArray alloc] initWithArray:planList];
                } else {
                    [YSAlertUtil tipOneMessage:@"Ta没有感兴趣的活动"];
                }
            } else {
                if (nil != planList && planList.count > 0) {
                    [weakSelf.planLikedArray addObjectsFromArray:planList];
                } else {
                    [YSAlertUtil tipOneMessage:@"没有更多Ta感兴趣的活动"];
                }
            }
            weakSelf.planLikedOrderStr = orderStr;
            [self updateShow];
        } else {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
        }
    }];
}

#pragma mark - Refresh

- (void)refreshData {
    switch (self.tabViewIndex) {
        case 0:
            [self.planOrganizeTableView headerBeginRefreshing];
            break;
        case 1:
            [self.planJoinTableView headerBeginRefreshing];
            break;
        case 2:
            [self.planLikedTableView headerBeginRefreshing];
            break;
    }
}

- (void)headerRefreshing {
    switch (self.tabViewIndex) {
        case 0:
            self.planOrganizeOrderStr = nil;
            [self requestOrganizePlanArrayFromOrderString:@""];
            break;
        case 1:
            self.planJoinOrderStr = nil;
            [self requestJoinPlanArrayFromOrderString:@""];
            break;
        case 2:
            self.planLikedOrderStr = nil;
            [self requestLikePlanArrayFromOrderString:@""];
            break;
    }
}

- (void)footerRefreshing {
    switch (self.tabViewIndex) {
        case 0:
            [self requestOrganizePlanArrayFromOrderString:self.planOrganizeOrderStr];
            break;
        case 1:
            [self requestJoinPlanArrayFromOrderString:self.planJoinOrderStr];
            break;
        case 2:
            [self requestLikePlanArrayFromOrderString:self.planLikedOrderStr];
            break;
    }
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.planOrganizeTableView]) {
        return self.planOrganizeArray.count;
    }
    if ([tableView isEqual:self.planJoinTableView]) {
        return self.planJoinArray.count;
    }
    if ([tableView isEqual:self.planLikedTableView]) {
        return self.planLikedArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    LCPlanModel *plan = nil;
    if ([tableView isEqual:self.planOrganizeTableView]) {
        plan = [self.planOrganizeArray objectAtIndex:indexPath.row];
    }
    if ([tableView isEqual:self.planJoinTableView]) {
        plan = [self.planJoinArray objectAtIndex:indexPath.row];
    }
    if ([tableView isEqual:self.planLikedTableView]) {
        plan = [self.planLikedArray objectAtIndex:indexPath.row];
    }
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
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LCPlanModel *plan = nil;
    if ([tableView isEqual:self.planOrganizeTableView]) {
        plan = [self.planOrganizeArray objectAtIndex:indexPath.row];
    }
    if ([tableView isEqual:self.planJoinTableView]) {
        plan = [self.planJoinArray objectAtIndex:indexPath.row];
    }
    if ([tableView isEqual:self.planLikedTableView]) {
        plan = [self.planLikedArray objectAtIndex:indexPath.row];
    }
    [LCViewSwitcher pushToShowPlanDetailVCForPlan:plan recmdUuid:@"" on:self.navigationController];
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.scrollView == scrollView) {
        int index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
        [self.tabView setSelectIndex:index];
        [self tabView:self.tabView didSelectIndex:index];
        [self.scrollView setContentOffset:CGPointMake(index * DEVICE_WIDTH, 0.0f) animated:YES];
    }
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self.view endEditing:YES];
//}

#pragma mark - LCTabView Delegate

- (void)tabView:(LCTabView *)tabView didSelectIndex:(NSInteger)index {
    self.tabView.selectIndex = index;
    [self updateShow];
}


@end
