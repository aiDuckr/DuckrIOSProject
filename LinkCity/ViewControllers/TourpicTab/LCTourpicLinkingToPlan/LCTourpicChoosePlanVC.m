//
//  LCTourpicChoosePlanVC.m
//  LinkCity
//
//  Created by lhr on 16/5/6.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCTourpicChoosePlanVC.h"
#import "LCTourpicPlanInfoCell.h"
#import "LCViewSwitcher.h"
#import "LCSearchPlanVC.h"

@interface LCTourpicChoosePlanVC ()<UITableViewDataSource,UITableViewDelegate,LCTourpicPlanInfoCellDelegate, LCSearchPlanVCDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSString *orderString;

@property (strong, nonatomic) NSMutableArray *planList;


@property (strong, nonatomic) NSMutableArray *radioButtonArray;

@property (assign, nonatomic) NSInteger selectedIndex;

//@property (strong, nonatomic) LCPlanModel *plan;
@end

@implementation LCTourpicChoosePlanVC


#pragma mark - init Function
+ (instancetype)createInstance {
    return (LCTourpicChoosePlanVC *)[LCStoryboardManager viewControllerWithFileName:SBNameTourpicTab identifier: VCIDTourpicChoosePlanVC];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    self.title = @"关联活动";
    [self tableViewHeaderRereshing];
    [self initAllNotifications];
    self.planList = [[LCDataManager sharedInstance] joinedPlanArr];
    self.selectedIndex = - 1;
    [self checkSelected];
    [self.tableView headerBeginRefreshing];
    
    self.orderString = [[NSString alloc] init];
    self.radioButtonArray = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
}

- (void)initTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 130;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCTourpicPlanInfoCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCTourpicPlanInfoCell class])];
    
    [self.tableView addHeaderWithTarget:self action:@selector(tableViewHeaderRereshing)];
    [self.tableView addFooterWithTarget:self action:@selector(tableViewFooterRereshing)];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableViewHeaderRereshing {
    //Result
    [self requestDataFromServer:nil];
    
}


- (void)tableViewFooterRereshing {
    [self requestDataFromServer:self.orderString];
    
}
- (void)requestDataFromServer:(NSString *)OrderString {
    self.orderString = OrderString;
    NSString *uuid = [[LCDataManager sharedInstance].userInfo uUID];
    __weak typeof(self) weakSelf = self;
    [LCNetRequester getJoinedPlansOfUser:uuid orderString:OrderString callBack:^(NSArray *planList, NSString *orderStr, NSError *error){
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
        if (nil != error) {
            [YSAlertUtil tipOneMessage:error.domain];
        } else {
            if ([LCStringUtil isNullString:weakSelf.orderString]) {
                weakSelf.planList = [[NSMutableArray alloc] init];
                if (planList.count <= 0) {
                    [YSAlertUtil tipOneMessage:@"您还没有参加任何邀约！"];
                } else {
                    weakSelf.planList = [LCPlanModel addAndFiltDuplicateStagePlanArr:planList toOriginalPlanArr: nil];
                }
            } else {
                if (planList.count <= 0) {
                    [YSAlertUtil tipOneMessage:LCFooterRefreshEmptyTip];
                } else {
                    weakSelf.planList = [LCPlanModel addAndFiltDuplicateStagePlanArr:planList toOriginalPlanArr: weakSelf.planList];
                }
            }
            [weakSelf checkSelected];
            [LCDataManager sharedInstance].joinedPlanArr = weakSelf.planList;
            weakSelf.orderString = orderStr;
            [weakSelf updateShow];
        }
    }];
}
- (void)updateShow {
    [self.tableView reloadData];
//    if (nil != self.plan) {
//        [self popConfirmView:self.plan];
//        self.plan = nil;
//    }
}

- (void)checkSelected {
    if (self.selectedPlan != nil) {
        for (LCPlanModel *model in self.planList) {
            if ([model.planGuid isEqualToString:self.selectedPlan.planGuid]) {
                
                self.selectedIndex = [self.planList indexOfObject:model];
                self.selectedPlan = nil;
                [self updateShow];
                break;
            }
        }
    }
}

- (void)refreshData {
    [self.tableView headerBeginRefreshing];
}


//- (void)popConfirmView:(LCPlanModel *)plan {
//    [[LCPopViewHelper sharedInstance] popConfirmArrivalView:self withPlan:plan];
//    //popViewHelper.popConfirmArrivalView(self, withPlan: plan)
//}

- (void)initAllNotifications {
    [self addObserveToNotificationNameToRefreshData:URL_PLAN_ARRIVAL];
    [self addObserveToNotificationNameToRefreshData:URL_SEND_PLAN];
    [self addObserveToNotificationNameToRefreshData:URL_DELETE_PLAN];
    [self addObserveToNotificationNameToRefreshData:URL_JOIN_PLAN];
    [self addObserveToNotificationNameToRefreshData:URL_QUIT_PLAN];
    [self addObserveToNotificationNameToRefreshData:URL_KICKOFF_USRE_OF_PLAN];
    [self addObserveToNotificationNameToRefreshData:URL_PLAN_ORDER_NEW];
    [self addObserveToNotificationNameToRefreshData:URL_SEND_PLAN];
    [self addObserveToNotificationNameToRefreshData:URL_PLAN_ORDER_QUERY];
    [self addObserveToNotificationNameToRefreshData:URL_PLAN_ORDER_REFUND];
    
//    self.addObserveToNotificationNameToRefreshData(URL_JOIN_PLAN)
//    self.addObserveToNotificationNameToRefreshData(URL_QUIT_PLAN)
//    self.addObserveToNotificationNameToRefreshData(URL_DELETE_PLAN)
//    self.addObserveToNotificationNameToRefreshData(URL_KICKOFF_USRE_OF_PLAN)
//    self.addObserveToNotificationNameToRefreshData(URL_PLAN_ORDER_NEW)
//    self.addObserveToNotificationNameToRefreshData(URL_PLAN_ORDER_QUERY)
//    self.addObserveToNotificationNameToRefreshData(URL_PLAN_ORDER_REFUND)
}

- (IBAction)searchAction:(id)sender {
    LCSearchPlanVC *vc = [LCSearchPlanVC createInstance];
    vc.selectedPlan = self.selectedPlan;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:APP_ANIMATION];
}


- (IBAction)confirmAction:(id)sender {
    if (self.selectedIndex < 0) {
        [self.delegate didChoosePlanWithPlan:nil];
    } else {
        if (self.selectedIndex < self.planList.count) {
            LCPlanModel *model = [self.planList objectAtIndex:self.selectedIndex];
            [self.delegate didChoosePlanWithPlan:model];
        } else {
            [self.delegate didChoosePlanWithPlan:nil];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
//    if (self.selectedIndex < 0) {
//        [YSAlertUtil tipOneMessage:@"请选择一个活动关联！"];
//    } else {
//        [
//    }
   
}

- (void)didChoosePlanWithPlan:(LCPlanModel *)plan {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didChoosePlanWithPlan:)]) {
        [self.delegate didChoosePlanWithPlan:plan];
    }
    [self.navigationController popViewControllerAnimated:NO];
}

//- (void)resetGroupRadioButton {
    
#pragma mark - TableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //return nil;
    LCTourpicPlanInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCTourpicPlanInfoCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    BOOL isSelected = NO;
    if (indexPath.row == self.selectedIndex) {
        isSelected = YES;
    }
    [cell bindWithData:self.planList[indexPath.row] isSelected:isSelected];
    if ([self.radioButtonArray indexOfObject:cell.radioButton] == NSNotFound) {
        [self.radioButtonArray addObject:cell.radioButton];
    }
    
    cell.radioButton.groupButtons = self.radioButtonArray;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.planList.count;
}

#pragma mark - LCTourpicPlanInfoCell Delegate

- (void)didJumpInfoDetailCell:(LCTourpicPlanInfoCell *)cell {
    LCPlanModel * plan = [self.planList objectAtIndex:[self.tableView indexPathForCell:cell].row];
    [LCViewSwitcher pushToShowPlanDetailVCForPlan:plan recmdUuid:nil on:self.navigationController];
}

- (void)didSelectedDetailCell:(LCTourpicPlanInfoCell *)cell {
    if (self.selectedIndex != [self.tableView indexPathForCell:cell].row) {
        self.selectedIndex = [self.tableView indexPathForCell:cell].row;
    } else {
        self.selectedIndex = -1;
    }
    //self
}

//- (void)didUnSelectedDetailCell {
//    self.selectedIndex = -1;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
