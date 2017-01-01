//
//  LCUserOrderListVC.m
//  LinkCity
//
//  Created by 张宗硕 on 12/20/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCUserOrderListVC.h"
#import "LCUserTabOrderCell.h"
#import "LCUserOrderDetailVC.h"

@interface LCUserOrderListVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSArray *planArray;
@property (retain, nonatomic) NSString *orderStr;
@property (weak, nonatomic) IBOutlet UIView *noOrderView;
@end

@implementation LCUserOrderListVC

+ (instancetype)createInstance {
    return (LCUserOrderListVC *)[LCStoryboardManager viewControllerWithFileName:SBNameOrder identifier:VCIDUserOrderListVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initVariable];
    [self initTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initVariable {
    self.title = @"我的订单";
    self.planArray = [[NSArray alloc] init];
    self.orderStr = nil;
    self.planArray = [LCDataManager sharedInstance].orderPlanArray;
}

- (void)refreshData {
    [self.tableView headerBeginRefreshing];
}

- (void)updateShow {
    [self.tableView reloadData];
}

- (void)initTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 250.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView addHeaderWithTarget:self action:@selector(tableViewHeaderRereshing) dateKey:@"table"];
    [self.tableView addFooterWithTarget:self action:@selector(tableViewFooterRereshing)];
}

- (void)tableViewHeaderRereshing {
    self.orderStr = nil;
    [self searchPlanOrderList];
}

- (void)tableViewFooterRereshing {
    [self searchPlanOrderList];
}

- (void)searchPlanOrderList {
    [LCNetRequester planOrderList:self.orderStr callBack:^(NSArray *planArray, NSString *orderStr, NSError *error) {
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];

        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipDefaultDelay];
        } else {
            if ([LCStringUtil isNullString:self.orderStr]) {
                if (nil != planArray) {
                    self.planArray = planArray;
                } else {
                    self.planArray = [[NSArray alloc] init];
                }
            } else {
                if (nil != planArray && planArray.count > 0) {
                    NSMutableArray *mutArr = [[NSMutableArray alloc] initWithArray:self.planArray];
                    [mutArr addObjectsFromArray:planArray];
                    self.planArray = mutArr;
                } else {
                    [YSAlertUtil tipOneMessage:LCFooterRefreshEmptyTip yoffset:TipDefaultYoffset delay:TipDefaultDelay];
                }
            }
            [LCDataManager sharedInstance].orderPlanArray = self.planArray;
            self.orderStr = orderStr;
            if (self.planArray.count <= 0) {
                self.noOrderView.hidden = NO;
            } else {
                self.noOrderView.hidden = YES;
            }
            [self updateShow];
        }
    }];
}

- (IBAction)viewHomePageAction:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
    [[LCSharedFuncUtil getAppDelegate].tabBarVC setSelectedIndex:0];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.planArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCPlanModel *plan = [self.planArray objectAtIndex:indexPath.row];
    
    LCUserTabOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCUserTabOrderCell" forIndexPath:indexPath];
    plan = [self.planArray objectAtIndex:indexPath.row];
    [cell updateShowOrderCell:plan];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LCPlanModel *plan = [self.planArray objectAtIndex:indexPath.row];
    LCUserOrderDetailVC *vc = [LCUserOrderDetailVC createInstance];
    vc.plan = plan;
    [self.navigationController pushViewController:vc animated:APP_ANIMATION];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
