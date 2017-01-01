//
//  LCMerchantWithdrawListVC.m
//  LinkCity
//
//  Created by 张宗硕 on 6/17/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCMerchantWithdrawListVC.h"
#import "LCMerchantWithdrawCell.h"

@interface LCMerchantWithdrawListVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *contentArr;
@property (strong, nonatomic) NSString *orderStr;
@end

@implementation LCMerchantWithdrawListVC

#pragma mark - Public Interface
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTableView];
    [self headerRefreshAction];
}

- (void)initTableView {
    self.tableView.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 180.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.scrollsToTop = YES;
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefreshAction)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefreshAction)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)updateShow {
    [self.tableView reloadData];
}

#pragma makr - Server Request.
/// 下拉刷新.
- (void)headerRefreshAction {
    self.orderStr = @"";
    [self requestWithdrawList];
}

/// 上拉加载更多.
- (void)footerRefreshAction {
    [self requestWithdrawList];
}

- (void)requestWithdrawList {
    [LCNetRequester requestMerchantWithdrawList:self.orderStr callBack:^(NSArray *contentArr, NSString *orderStr, NSError *error) {
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        if (!error) {
            if ([LCStringUtil isNullString:self.orderStr]) {
                if (nil != contentArr && contentArr.count > 0) {
                    self.contentArr = contentArr;
                } else {
                    [YSAlertUtil tipOneMessage:@"没有提现记录"];
                }
            } else {
                if (nil != contentArr && contentArr.count > 0) {
                    NSMutableArray *mutArr = [[NSMutableArray alloc] initWithArray:self.contentArr];
                    [mutArr addObjectsFromArray:contentArr];
                    self.contentArr = mutArr;
                } else {
                    [YSAlertUtil tipOneMessage:@"没有更多提现记录"];
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
    LCMerchantWithdrawCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCMerchantWithdrawCell class]) forIndexPath:indexPath];
    NSDictionary *dic = [self.contentArr objectAtIndex:indexPath.row];
    [cell updateShowCell:dic];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
