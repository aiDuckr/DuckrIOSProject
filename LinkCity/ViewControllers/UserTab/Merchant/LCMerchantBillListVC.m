//
//  LCMerchantBillListVC.m
//  LinkCity
//
//  Created by godhangyu on 16/6/14.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCMerchantBillListVC.h"
#import "LCMerchantBillCell.h"
#import "LCMerchantAccountVC.h"

@interface LCMerchantBillListVC ()<UITableViewDelegate, UITableViewDataSource>

// UI
@property (weak, nonatomic) IBOutlet UITableView *billTableView;

// Data
@property (strong, nonatomic) NSMutableArray *billArray;
@property (strong, nonatomic) NSString *orderStr;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (strong, nonatomic) LCUserAccount *account;

@end

@implementation LCMerchantBillListVC

+ (instancetype)createInstance {
    return (LCMerchantBillListVC *)[LCStoryboardManager viewControllerWithFileName:SBNameUserTab identifier:VCIDMerchantBillListVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTableView];
    self.account = [LCDataManager sharedInstance].merchantAccount;
    [self initAllObserverNotifications];
}

- (void)initAllObserverNotifications {
    [self addObserveToNotificationNameToRefreshData:URL_GET_MERCHANT_ADD_CARD];
    [self addObserveToNotificationNameToRefreshData:URL_GET_MERCHANT_AGREE_REFUND];
    [self addObserveToNotificationNameToRefreshData:URL_GET_MERCHANT_ORDER_CHECK];
    [self addObserveToNotificationNameToRefreshData:URL_GET_MERCHANT_WITHDRAW];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateShow];
}

- (void)refreshData {
    [self.billTableView headerBeginRefreshing];
}

#pragma Common Init

- (void)initNavigationBar {
    self.title = @"我的账单";
}

- (void)initTableView {
    self.billTableView.delegate = self;
    self.billTableView.dataSource = self;
    self.billTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.billTableView.estimatedRowHeight = 90.0f;
    self.billTableView.rowHeight = UITableViewAutomaticDimension;
    [self.billTableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    [self.billTableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    [self.billTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCMerchantBillCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCMerchantBillCell class])];
}

- (void)updateShow {
    [LCDataManager sharedInstance].merchantAccount = self.account;
    
    [self.billTableView reloadData];
    
    if (nil != self.account) {
        self.accountLabel.text = [NSString stringWithFormat:@"￥%@", self.account.totalBalance];
    }
}

- (IBAction)accountRuleAction:(id)sender {
    [LCViewSwitcher pushWebVCtoShowURL:server_url([LCConstants serverHost], LCAccountRulesIntroURL)  withTitle:@"入账规则" on:self.navigationController];
}


#pragma mark - Net Request

- (void)requestMerchantBillListFromOrderString:(NSString *)orderStr {
    __weak typeof(self) weakSelf = self;
    [LCNetRequester requestMerchantBillList:self.orderStr callBack:^(NSArray *contentArr, LCUserAccount *account, NSString *orderStr, NSError *error) {
        [weakSelf.billTableView headerEndRefreshing];
        [weakSelf.billTableView footerEndRefreshing];
        if (!error) {
            if ([LCStringUtil isNullString:self.orderStr]) {
                weakSelf.account = account;
                if (nil != contentArr && contentArr.count > 0) {
                    weakSelf.billArray = [[NSMutableArray alloc] initWithArray:contentArr];
                } else {
                    [YSAlertUtil tipOneMessage:@"没有账单"];
                }
            } else {
                if (nil != contentArr && contentArr.count > 0) {
                    [weakSelf.billArray addObjectsFromArray:contentArr];
                } else {
                    [YSAlertUtil tipOneMessage:@"没有更多账单"];
                }
            }
            weakSelf.orderStr = orderStr;
            [weakSelf updateShow];
        } else {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
        }
    }];
}

#pragma mark - Refresh

- (void)headerRefreshing {
    self.orderStr = nil;
    [self requestMerchantBillListFromOrderString:nil];
}

- (void)footerRefreshing {
    [self requestMerchantBillListFromOrderString:self.orderStr];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.billArray) {
        return self.billArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LCMerchantBillCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCMerchantBillCell class]) forIndexPath:indexPath];
    [cell updateCellWithPlanBill:[self.billArray objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


@end
