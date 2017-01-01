//
//  LCMerchantOrderDetailVC.m
//  LinkCity
//
//  Created by 张宗硕 on 12/25/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCMerchantOrderDetailVC.h"
#import "LCMerchantOrderDetailCell.h"

@interface LCMerchantOrderDetailVC ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *planArr;
@end

@implementation LCMerchantOrderDetailVC
+ (instancetype)createInstance {
    return (LCMerchantOrderDetailVC *)[LCStoryboardManager viewControllerWithFileName:SBNameOrder identifier:VCIDMerchantOrderDetailVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initVariable];
    [self initTableView];
    [self requestPartnerOrderFromServer];
//    [self updateShow];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

#pragma mark - init
- (void)initVariable {
    self.title = self.plan.declaration;
    self.planArr = [[NSArray alloc] init];
}

- (void)initTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 104.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)requestPartnerOrderFromServer {
    [LCNetRequester requestMerchantSignUpDetail:self.plan.planGuid callBack:^(NSArray *planArr, NSError *error) {
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipDefaultDelay];
        } else {
            self.planArr = planArr;
            [self updateShow];
        }
    }];
}

- (void)updateShow {
    [self.tableView reloadData];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.planArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    LCPlanModel *plan = [self.planArr objectAtIndex:section];
    return plan.memberList.count - 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCPlanModel *plan = [self.planArr objectAtIndex:indexPath.section];
    LCUserModel *user = [plan.memberList objectAtIndex:indexPath.row + 1];

    LCMerchantOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCMerchantOrderDetailCell" forIndexPath:indexPath];
    [cell updateShowOrderCell:user];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    LCPlanModel *plan = [self.planArr objectAtIndex:section];
    NSInteger checkedNum = 0;
    for (int i = 1; i < plan.memberList.count; i++){
        LCUserModel *user = plan.memberList[i];
        if (user.partnerOrder) {
            LCPartnerOrderModel *order = user.partnerOrder;
            if (1 == order.orderCheck) {
                checkedNum += order.orderNumber;
            }
        }
    }
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = UIColorFromRGBA(0xf5f4f2, 1.0);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12.0f, 13.0f, 250.0f, 17.0f)];
    label.textColor = UIColorFromRGBA(0x2c2a28, 1.0f);
    label.font = [UIFont fontWithName:APP_CHINESE_FONT size:14.0f];
    label.text = [NSString stringWithFormat:@"出发时间：%@   %ld人已验票", plan.startTime, (long)checkedNum];
    [headerView addSubview:label];

    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(DEVICE_WIDTH - 17.0f - 24.0f, 12.0f, 24.0f, 17.0f)];
    btn.tag = section;
    [btn setBackgroundImage:[UIImage imageNamed:@"UserTabMerchantSignupGroupIcon"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(enterGroupButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:btn];
    return headerView;
}

#pragma mark UIButton Action
- (void)enterGroupButtonAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    LCPlanModel *plan = [self.planArr objectAtIndex:btn.tag];
    [LCViewSwitcher pushToShowChatWithPlanVC:plan on:self.navigationController];
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
