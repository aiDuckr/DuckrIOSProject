//
//  LCUserRefundVC.m
//  LinkCity
//
//  Created by godhangyu on 16/5/31.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCUserRefundOrderVC.h"
#import "LCUserOrderCell.h"
#import "LCUserRefundingVC.h"

@interface LCUserRefundOrderVC ()<UITableViewDataSource, UITableViewDelegate, LCUserOrderCellDelegate>

//Data
@property (nonatomic, strong) NSMutableArray *planArray;
@property (nonatomic, strong) NSMutableArray *orderArray;
@property (nonatomic, strong) NSString *orderStr;
@property (nonatomic, strong) LCUserOrderCell *deleteCell;

//UI
@property (weak, nonatomic) IBOutlet UITableView *orderTableView;

@end

@implementation LCUserRefundOrderVC

+ (instancetype)createInstance {
    return (LCUserRefundOrderVC *)[LCStoryboardManager viewControllerWithFileName:SBNameUserOrder identifier:VCIDUserRefundOrderVC];
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

- (void)requestUserRefundOrderFromOrderString {
    __weak typeof(self) weakSelf = self;
    [LCNetRequester getUserRefundOrder_V_FIVE:self.orderStr callBack:^(NSArray *planArray, NSArray *orderArray, NSString *orderStr, NSError *error) {
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
        } else {
            if ([LCStringUtil isNullString:self.orderStr]) {
                // refresh
                weakSelf.planArray = [NSMutableArray arrayWithArray:planArray];
                weakSelf.orderArray = [NSMutableArray arrayWithArray:orderArray];
            } else {
                if (!planArray || planArray.count <= 0) {
                    [YSAlertUtil tipOneMessage:LCFooterRefreshEmptyTip yoffset:TipDefaultYoffset delay:TipDefaultDelay];
                } else {
                    if (!weakSelf.planArray) {
                        weakSelf.planArray = [[NSMutableArray alloc] initWithCapacity:0];
                    }
                    if (!weakSelf.orderArray) {
                        weakSelf.orderArray = [[NSMutableArray alloc] initWithCapacity:0];
                    }
                    
                    [weakSelf.planArray addObjectsFromArray:planArray];
                    [weakSelf.orderArray addObjectsFromArray:orderArray];
                }
            }
        }
        [self updateShow];
    }];
}

#pragma mark - Refresh

- (void)headerRefreshing {
    self.orderStr = nil;
    [self requestUserRefundOrderFromOrderString];
}

- (void)footerRefreshing {
    [self requestUserRefundOrderFromOrderString];
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
    userOrderCell.delegate = self;
    if (indexPath.row != ([tableView numberOfRowsInSection:indexPath.section] - 1)) {
        [userOrderCell updateCell:[self.planArray objectAtIndex:indexPath.row] partnerOrderModel:[self.orderArray objectAtIndex:indexPath.row] withSpaInset:YES];
    } else {
        [userOrderCell updateCell:[self.planArray objectAtIndex:indexPath.row] partnerOrderModel:[self.orderArray objectAtIndex:indexPath.row] withSpaInset:NO];
    }
    return userOrderCell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LCPlanModel *plan = [self.planArray objectAtIndex:indexPath.row];
    [LCViewSwitcher pushToShowPlanDetailVCForPlan:plan recmdUuid:@"" on:self.navigationController];
}

#pragma mark - LCUserOrderCell Delegate

- (void)orderRefundButtonClicked:(LCUserOrderCell *)cell {
    LCUserRefundingVC *refundingVC = [LCUserRefundingVC createInstance];
    refundingVC.orderGuid = cell.order.guid;
    refundingVC.planRoomId = cell.plan.roomId;
    if ([LCStringUtil isNullString:cell.plan.refundIntro]) {
        refundingVC.refundIntro = @"暂无退款说明信息\n请联系客服010-53347735";
    } else {
        refundingVC.refundIntro = cell.plan.refundIntro;
    }
    [self.navigationController pushViewController:refundingVC animated:APP_ANIMATION];
}

- (void)orderDeleteButtonClicked:(LCUserOrderCell *)cell {
    self.deleteCell = cell;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"删除订单吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    [alert show];
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        __weak typeof(self) weakSelf = self;
        [LCNetRequester deleteUserOrderWithOrderGuid_V_FIVE:self.deleteCell.order.guid callBack:^(NSString *msg, NSError *error) {
            if (error) {
                [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipDefaultDelay];
            } else {
                [YSAlertUtil tipOneMessage:msg yoffset:TipDefaultYoffset delay:TipDefaultDelay];
                NSInteger index = [weakSelf.orderTableView indexPathForCell:weakSelf.deleteCell].row;
                [weakSelf.planArray removeObjectAtIndex:index];
                [weakSelf.orderArray removeObjectAtIndex:index];
                [weakSelf.orderTableView beginUpdates];
                NSArray *_tempIndexPathArr = [NSArray arrayWithObject:[weakSelf.orderTableView indexPathForCell:weakSelf.deleteCell]];
                [weakSelf.orderTableView deleteRowsAtIndexPaths:_tempIndexPathArr withRowAnimation:UITableViewRowAnimationFade];
                [weakSelf.orderTableView endUpdates];
            }
        }];
    }
}

@end
