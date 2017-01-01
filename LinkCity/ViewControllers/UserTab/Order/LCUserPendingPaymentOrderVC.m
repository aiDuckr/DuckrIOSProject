//
//  LCUserPendingPaymentOrderVC.m
//  LinkCity
//
//  Created by godhangyu on 16/5/31.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCUserPendingPaymentOrderVC.h"
#import "LCUserOrderCell.h"

@interface LCUserPendingPaymentOrderVC ()<UITableViewDataSource, UITableViewDelegate>

//Data
@property (nonatomic, strong) NSMutableArray *planArray;
@property (nonatomic, strong) NSString *orderStr;

//UI
@property (weak, nonatomic) IBOutlet UITableView *orderTableView;

@end

@implementation LCUserPendingPaymentOrderVC

+ (instancetype)createInstance {
    return (LCUserPendingPaymentOrderVC *)[LCStoryboardManager viewControllerWithFileName:SBNameUserOrder identifier:VCIDUserPendingPaymentOrderVC];
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.orderTableView headerBeginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Common Init

- (void)initTableView {
    self.orderTableView.delegate = self;
    self.orderTableView.dataSource = self;
    self.orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.orderTableView.estimatedRowHeight = 100.0f;
    self.orderTableView.rowHeight = UITableViewAutomaticDimension;
    [self.orderTableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    [self.orderTableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    [self.orderTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCUserOrderCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCUserOrderCell class])];
}

- (void)updateShow {
    [self.orderTableView reloadData];
    
    [self.orderTableView headerEndRefreshing];
    [self.orderTableView footerEndRefreshing];
}

#pragma mark - Net

- (void)requestUserPendingPaymentOrderFromOrderString {
    __weak typeof(self) weakSelf = self;
    [LCNetRequester getUserPendingPaymentOrder_V_FIVE:self.orderStr callBack:^(NSArray *planArray, NSString *orderStr, NSError *error) {
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
        } else {
            if ([LCStringUtil isNullString:self.orderStr]) {
                // refresh
                weakSelf.planArray = [NSMutableArray arrayWithArray:planArray];
            } else {
                if (!planArray || planArray.count <= 0) {
                    [YSAlertUtil tipOneMessage:LCFooterRefreshEmptyTip yoffset:TipDefaultYoffset delay:TipDefaultDelay];
                } else {
                    if (!weakSelf.planArray) {
                        weakSelf.planArray = [[NSMutableArray alloc] initWithCapacity:0];
                    }
                    [weakSelf.planArray addObjectsFromArray:planArray];
                }
            }
        }
        [self updateShow];
    }];
}

#pragma mark - Refresh

- (void)headerRefreshing {
    self.orderStr = nil;
    [self requestUserPendingPaymentOrderFromOrderString];
}

- (void)footerRefreshing {
    [self requestUserPendingPaymentOrderFromOrderString];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.planArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCUserOrderCell *userOrderCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCUserOrderCell class]) forIndexPath:indexPath];
    if (indexPath.row != ([tableView numberOfRowsInSection:indexPath.section] - 1)) {
        [userOrderCell updateCell:[self.planArray objectAtIndex:indexPath.row] partnerOrderModel:nil withSpaInset:YES];
    } else {
        [userOrderCell updateCell:[self.planArray objectAtIndex:indexPath.row] partnerOrderModel:nil withSpaInset:NO];
    }
    return userOrderCell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LCPlanModel *plan = [self.planArray objectAtIndex:indexPath.row];
    [LCViewSwitcher pushToShowPlanDetailVCForPlan:plan recmdUuid:@"" on:self.navigationController];
}

@end
