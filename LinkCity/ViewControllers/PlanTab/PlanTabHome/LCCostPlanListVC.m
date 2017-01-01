//
//  LCCostPlanListVC.m
//  LinkCity
//
//  Created by 张宗硕 on 7/30/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCCostPlanListVC.h"
#import "LCCostPlanCell.h"

@interface LCCostPlanListVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *contentArr;
@property (strong, nonatomic) NSString *orderStr;

@end

@implementation LCCostPlanListVC

#pragma mark - Public Interface
+ (instancetype)createInstance {
    return (LCCostPlanListVC *)[LCStoryboardManager viewControllerWithFileName:SBNamePlanTab identifier:VCIDCostPlanListVC];
}

#pragma mark - LifeCycle.
- (void)commonInit {
    [super commonInit];
    self.orderStr = @"";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTableView];
    [self updateTitle];
    if (nil == self.contentArr || 0 == self.contentArr.count) {
        [self.tableView headerBeginRefreshing];
    } else {
        [self headerRefreshAction];
    }
}

- (void)initTableView {
    self.tableView.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 180.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.scrollsToTop = YES;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCCostPlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCCostPlanCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCFreePlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCFreePlanCell class])];
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefreshAction)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefreshAction)];
}

- (void)updateTitle {
    self.title = self.homeRcmd.title;
}

- (void)updateShow {
//    [LCDataManager sharedInstance].homeSelectedCostPlansArr = self.contentArr;
    [self.tableView reloadData];
}

#pragma makr - Server Request.
/// 下拉刷新.
- (void)headerRefreshAction {
    self.orderStr = @"";
    [self requestCostPlans];
}

/// 上拉加载更多.
- (void)footerRefreshAction {
    [self requestCostPlans];
}

- (void)requestCostPlans {
    switch (self.homeRcmd.type) {
        case LCHomeRcmdType_Rcmd:
            [self requestHomeRcmdPersonal];
            break;
        case LCHomeRcmdType_Nearby:
            [self requestHomeRcmdNearby];
            break;
        case LCHomeRcmdType_Today:
            [self requestHomeRcmdToday];
            break;
        case LCHomeRcmdType_Tomorrow:
            [self requestHomeRcmdTomorrow];
            break;
        case LCHomeRcmdType_Week:
            [self requestHomeRcmdWeekend];
            break;
        default:
            break;
    }
}

- (void)requestHomeRcmdPersonal {
    __weak typeof(self) weakSelf = self;
    [LCNetRequester requestHomeRcmdPersonal:self.orderStr withCallBack:^(NSArray *contentArr, NSString *orderStr, NSError *error) {
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
        if (!error) {
            if ([LCStringUtil isNullString:weakSelf.orderStr]) {
                weakSelf.contentArr = [[NSArray alloc] init];
            }
            if (nil != contentArr && contentArr.count > 0) {
                weakSelf.contentArr = [LCSharedFuncUtil addFiltedArrayToArray:weakSelf.contentArr withUnfiltedArray:contentArr];
            } else if ([LCStringUtil isNotNullString:weakSelf.orderStr]) {
                [YSAlertUtil tipOneMessage:@"没有更多内容"];
            }
            weakSelf.orderStr = orderStr;
            [weakSelf updateShow];
        } else {
            [YSAlertUtil tipOneMessage:error.domain];
        }
    }];
}

- (void)requestHomeRcmdNearby {
    __weak typeof(self) weakSelf = self;
    [LCNetRequester requestHomeRcmdNearby:self.orderStr withCallBack:^(NSArray *contentArr, NSString *orderStr, NSError *error) {
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
        if (!error) {
            if ([LCStringUtil isNullString:weakSelf.orderStr]) {
                weakSelf.contentArr = [[NSArray alloc] init];
            }
            if (nil != contentArr && contentArr.count > 0) {
                weakSelf.contentArr = [LCSharedFuncUtil addFiltedArrayToArray:weakSelf.contentArr withUnfiltedArray:contentArr];
            } else if ([LCStringUtil isNotNullString:weakSelf.orderStr]) {
                [YSAlertUtil tipOneMessage:@"没有更多内容"];
            }
            weakSelf.orderStr = orderStr;
            [weakSelf updateShow];
        } else {
            [YSAlertUtil tipOneMessage:error.domain];
        }
    }];
}

- (void)requestHomeRcmdToday {
    __weak typeof(self) weakSelf = self;
    [LCNetRequester requestHomeRcmdToday:self.orderStr withCallBack:^(NSArray *contentArr, NSString *orderStr, NSError *error) {
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
        if (!error) {
            if ([LCStringUtil isNullString:weakSelf.orderStr]) {
                weakSelf.contentArr = [[NSArray alloc] init];
            }
            if (nil != contentArr && contentArr.count > 0) {
                weakSelf.contentArr = [LCSharedFuncUtil addFiltedArrayToArray:weakSelf.contentArr withUnfiltedArray:contentArr];
            } else if ([LCStringUtil isNotNullString:weakSelf.orderStr]) {
                [YSAlertUtil tipOneMessage:@"没有更多内容"];
            }
            weakSelf.orderStr = orderStr;
            [weakSelf updateShow];
        } else {
            [YSAlertUtil tipOneMessage:error.domain];
        }
    }];
}

- (void)requestHomeRcmdTomorrow {
    __weak typeof(self) weakSelf = self;
    [LCNetRequester requestHomeRcmdTomorrow:self.orderStr withCallBack:^(NSArray *contentArr, NSString *orderStr, NSError *error) {
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
        if (!error) {
            if ([LCStringUtil isNullString:weakSelf.orderStr]) {
                weakSelf.contentArr = [[NSArray alloc] init];
            }
            if (nil != contentArr && contentArr.count > 0) {
                weakSelf.contentArr = [LCSharedFuncUtil addFiltedArrayToArray:weakSelf.contentArr withUnfiltedArray:contentArr];
            } else if ([LCStringUtil isNotNullString:weakSelf.orderStr]) {
                [YSAlertUtil tipOneMessage:@"没有更多内容"];
            }
            weakSelf.orderStr = orderStr;
            [weakSelf updateShow];
        } else {
            [YSAlertUtil tipOneMessage:error.domain];
        }
    }];
}

- (void)requestHomeRcmdWeekend {
    __weak typeof(self) weakSelf = self;
    [LCNetRequester requestHomeRcmdWeekend:self.orderStr withCallBack:^(NSArray *contentArr, NSString *orderStr, NSError *error) {
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
        if (!error) {
            if ([LCStringUtil isNullString:weakSelf.orderStr]) {
                weakSelf.contentArr = [[NSArray alloc] init];
            }
            if (nil != contentArr && contentArr.count > 0) {
                weakSelf.contentArr = [LCSharedFuncUtil addFiltedArrayToArray:weakSelf.contentArr withUnfiltedArray:contentArr];
            } else if ([LCStringUtil isNotNullString:weakSelf.orderStr]) {
                [YSAlertUtil tipOneMessage:@"没有更多内容"];
            }
            weakSelf.orderStr = orderStr;
            [weakSelf updateShow];
        } else {
            [YSAlertUtil tipOneMessage:error.domain];
        }
    }];
}

#pragma mark - UITableView Delegate.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    LCPlanModel *plan = [self.contentArr objectAtIndex:indexPath.row];
    if (LCPlanType_CostPlan == plan.routeType || LCPlanType_CostLocal == plan.routeType) {
        LCCostPlanCell *costPlanCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCCostPlanCell class]) forIndexPath:indexPath];
    [costPlanCell updateShowWithPlan:plan];
        cell = costPlanCell;
    } else {
        LCFreePlanCell *freePlanCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCFreePlanCell class]) forIndexPath:indexPath];
        if (indexPath.row != self.contentArr.count - 1) {
                [freePlanCell updateShowWithPlan:plan hideThemeId:0 withSpaInset:YES];
        }
        else {
                [freePlanCell updateShowWithPlan:plan hideThemeId:0 withSpaInset:NO];
        }
        cell = freePlanCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LCPlanModel *plan = [self.contentArr objectAtIndex:indexPath.row];
    [LCViewSwitcher pushToShowPlanDetailVCForPlan:plan recmdUuid:@"" on:self.navigationController];
}

@end
