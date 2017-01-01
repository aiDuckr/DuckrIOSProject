//
//  LCHomeRecmCostPlansVC.m
//  LinkCity
//
//  Created by 张宗硕 on 5/18/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCHomeRecmCostPlansVC.h"
#import "LCFreePlanCell.h"
#import "LCCostPlanCell.h"

@interface LCHomeRecmCostPlansVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *contentArr;
@property (strong, nonatomic) NSString *orderStr;
@property (strong, nonatomic) LCCityModel *currentCity;

@end

@implementation LCHomeRecmCostPlansVC

#pragma mark - Public Interface
+ (instancetype)createInstance {
    return (LCHomeRecmCostPlansVC *)[LCStoryboardManager viewControllerWithFileName:SBNamePlanTab identifier:VCIDHomeRecmCostPlansVC];
}

#pragma mark - LifeCycle.
- (void)commonInit {
    [super commonInit];
    self.orderStr = @"";
    self.currentCity = [LCDataManager sharedInstance].currentCity;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTableView];
    [self updateTitle];
    if (LCHomeRecmCostPlansViewType_Selected == self.type) {
        self.contentArr = [LCDataManager sharedInstance].homeSelectedCostPlansArr;
    } else if (LCHomeRecmCostPlansViewType_LocalRecm == self.type) {
        self.contentArr = [LCDataManager sharedInstance].homeRecmedCostPlansArr;
    }
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

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCFreePlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCFreePlanCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCCostPlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCCostPlanCell class])];
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefreshAction)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefreshAction)];
}

- (void)updateTitle {
    if (LCHomeRecmCostPlansViewType_Selected == self.type) {
        self.title = @"精选活动";
    } else if (LCHomeRecmCostPlansViewType_LocalRecm == self.type) {
        self.title = @"本地玩乐";
    }
}

- (void)updateShow {
    if (LCHomeRecmCostPlansViewType_Selected == self.type) {
        [LCDataManager sharedInstance].homeSelectedCostPlansArr = self.contentArr;
    } else if (LCHomeRecmCostPlansViewType_LocalRecm == self.type) {
        [LCDataManager sharedInstance].homeRecmedCostPlansArr = self.contentArr;
    }
    [self.tableView reloadData];
}

#pragma makr - Server Request.
/// 下拉刷新.
- (void)headerRefreshAction {
    self.orderStr = @"";
    [self requestContentDatas];
}

/// 上拉加载更多.
- (void)footerRefreshAction {
    [self requestContentDatas];
}

- (void)requestContentDatas {
    if (LCHomeRecmCostPlansViewType_Selected == self.type) {
        [self requestSelectedCostPlans];
    } else if (LCHomeRecmCostPlansViewType_LocalRecm == self.type) {
        [self requestLocalCostPlans];
    }
}

- (void)requestSelectedCostPlans {
    [LCNetRequester getHomeRecmSelectedCostPlans:self.orderStr callBack:^(NSArray *contentArr, NSString *orderStr, NSError *error) {
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        if (!error) {
            if ([LCStringUtil isNullString:self.orderStr]) {
                if (nil != contentArr && contentArr.count > 0) {
                    self.contentArr = [LCSharedFuncUtil addFiltedArrayToArray:nil withUnfiltedArray:contentArr];
                } else {
                    [YSAlertUtil tipOneMessage:@"没有精选活动"];
                }
            } else {
                if (nil != contentArr && contentArr.count > 0) {
                    self.contentArr = [LCSharedFuncUtil addFiltedArrayToArray:self.contentArr withUnfiltedArray:contentArr];
                } else {
                    [YSAlertUtil tipOneMessage:@"没有更多精选活动"];
                }
            }
            self.orderStr = orderStr;
            [self updateShow];
        } else {
            [YSAlertUtil tipOneMessage:error.domain];
        }
    }];
}

- (void)requestLocalCostPlans {
    NSString *locName = @"";
    if (nil != self.currentCity) {
        locName = self.currentCity.cityName;
    }
    [LCNetRequester getHomeRecmLocalCostPlans:locName withOrderStr:self.orderStr callBack:^(NSArray *contentArr, NSString *orderStr, NSError *error) {
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        if (!error) {
            if ([LCStringUtil isNullString:self.orderStr]) {
                if (nil != contentArr && contentArr.count > 0) {
                    self.contentArr = contentArr;
                } else {
                    [YSAlertUtil tipOneMessage:@"没有本地推荐活动"];
                }
            } else {
                if (nil != contentArr && contentArr.count > 0) {
                    NSMutableArray *mutArr = [[NSMutableArray alloc] initWithArray:self.contentArr];
                    [mutArr addObjectsFromArray:contentArr];
                    self.contentArr = mutArr;
                } else {
                    [YSAlertUtil tipOneMessage:@"没有更多本地推荐活动"];
                }
            }
            self.orderStr = orderStr;
            [self updateShow];
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
        if (indexPath.row != ([tableView numberOfRowsInSection:indexPath.section] - 1))
            [freePlanCell updateShowWithPlan:plan hideThemeId:0 withSpaInset:YES];
        else
            [freePlanCell updateShowWithPlan:plan hideThemeId:0 withSpaInset:NO];
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
