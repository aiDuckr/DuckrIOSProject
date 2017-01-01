//
//  LCMerchantServiceListVC.m
//  LinkCity
//
//  Created by 张宗硕 on 6/12/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCMerchantServiceListVC.h"
#import "LCMerchantServiceCell.h"

@interface LCMerchantServiceListVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *contentArr;
@property (strong, nonatomic) NSString *orderStr;

@end

@implementation LCMerchantServiceListVC

#pragma mark - Public Interface
+ (instancetype)createInstance {
    return (LCMerchantServiceListVC *)[LCStoryboardManager viewControllerWithFileName:SBNameUserTab identifier:VCIDMerchantServiceListVC];
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
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCMerchantServiceCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCMerchantServiceCell class])];
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefreshAction)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefreshAction)];
}

- (void)updateShow {
    [self.tableView reloadData];
}

#pragma makr - Server Request.
/// 下拉刷新.
- (void)headerRefreshAction {
    self.orderStr = @"";
    [self requestMerchantServiceList];
}

/// 上拉加载更多.
- (void)footerRefreshAction {
    [self requestMerchantServiceList];
}

/// 拉取我的服务列表.
- (void)requestMerchantServiceList {
    [LCNetRequester requestMerchantServiceList:self.orderStr callBack:^(NSArray *contentArr, NSString *orderStr, NSError *error) {
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        if (!error) {
            if ([LCStringUtil isNullString:self.orderStr]) {
                if (nil != contentArr && contentArr.count > 0) {
                    self.contentArr = [LCSharedFuncUtil addFiltedArrayToArray:nil withUnfiltedArray:contentArr];
                } else {
                    [YSAlertUtil tipOneMessage:@"没有服务活动"];
                }
            } else {
                if (nil != contentArr && contentArr.count > 0) {
                    self.contentArr = [LCSharedFuncUtil addFiltedArrayToArray:self.contentArr withUnfiltedArray:contentArr];
                } else {
                    [YSAlertUtil tipOneMessage:@"没有更多服务活动"];
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
    LCMerchantServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCMerchantServiceCell class]) forIndexPath:indexPath];
    LCPlanModel *plan = [self.contentArr objectAtIndex:indexPath.row];
    [cell updateShowCell:plan];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LCPlanModel *plan = [self.contentArr objectAtIndex:indexPath.row];
    [LCViewSwitcher pushToShowPlanDetailVCForPlan:plan recmdUuid:@"" on:self.navigationController];
}

@end
