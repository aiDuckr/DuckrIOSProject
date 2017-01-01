//
//  LCMerchantRefundListVC.m
//  LinkCity
//
//  Created by 张宗硕 on 6/14/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCMerchantRefundListVC.h"
#import "LCMerchantRefundCell.h"
#import "LCMerchantRefundDetailVC.h"

@interface LCMerchantRefundListVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *planArr;
@property (strong, nonatomic) NSArray *userArr;
@property (strong, nonatomic) NSString *orderStr;
@end

@implementation LCMerchantRefundListVC

#pragma mark - Public Interface
+ (instancetype)createInstance {
    return (LCMerchantRefundListVC *)[LCStoryboardManager viewControllerWithFileName:SBNameUserTab identifier:VCIDMerchantRefundListVC];
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
    
    [self initAllObserverNotifications];
}

- (void)initTableView {
    self.tableView.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 180.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.scrollsToTop = YES;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCMerchantRefundCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCMerchantRefundCell class])];
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefreshAction)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefreshAction)];
}

- (void)updateShow {
    [self.tableView reloadData];
}

- (void)initAllObserverNotifications {
    [self addObserveToNotificationNameToRefreshData:URL_GET_MERCHANT_AGREE_REFUND];
}

- (void)refreshData {
    [self headerRefreshAction];
}

#pragma makr - Server Request.
/// 下拉刷新.
- (void)headerRefreshAction {
    self.orderStr = @"";
    [self requestMerchantRefundList];
}

/// 上拉加载更多.
- (void)footerRefreshAction {
    [self requestMerchantRefundList];
}

- (void)requestMerchantRefundList {
    [LCNetRequester requestMerchantRefundList:self.orderStr callBack:^(NSArray *planArr, NSArray *userArr, NSString *orderStr, NSError *error) {
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        if (!error) {
            if ([LCStringUtil isNullString:self.orderStr]) {
                if (nil != planArr && planArr.count > 0 && nil != userArr && userArr.count > 0) {
                    self.planArr = planArr;
                    self.userArr = userArr;
                } else {
                    [YSAlertUtil tipOneMessage:@"没有退款处理"];
                }
            } else {
                if (nil != planArr && planArr.count > 0 && nil != userArr && userArr.count > 0) {
                    NSMutableArray *mutArr = [[NSMutableArray alloc] initWithArray:self.planArr];
                    [mutArr addObjectsFromArray:planArr];
                    self.planArr = mutArr;
                    
                    mutArr = [[NSMutableArray alloc] initWithArray:self.userArr];
                    [mutArr addObjectsFromArray:userArr];
                    self.userArr = mutArr;
                } else {
                    [YSAlertUtil tipOneMessage:@"没有更多退款处理"];
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
    return self.planArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCMerchantRefundCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCMerchantRefundCell class]) forIndexPath:indexPath];
    LCPlanModel *plan = [self.planArr objectAtIndex:indexPath.row];
    LCUserModel *user = [self.userArr objectAtIndex:indexPath.row];
    [cell updateShowCell:plan withUser:user];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LCMerchantRefundDetailVC *vc = [LCMerchantRefundDetailVC createInstance];
    LCPlanModel *plan = [self.planArr objectAtIndex:indexPath.row];
    LCUserModel *user = [self.userArr objectAtIndex:indexPath.row];
    vc.plan = plan;
    vc.user = user;
    [self.navigationController pushViewController:vc animated:APP_ANIMATION];
}

@end
