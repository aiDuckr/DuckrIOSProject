//
//  LCUserServiceVC.m
//  LinkCity
//
//  Created by roy on 3/7/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCUserServiceVC.h"
#import "LCAgreementVC.h"
#import "LCCarIdentityVC.h"
#import "LCUserIdentityAlertView.h"
#import "KLCPopup.h"
#import "LCUserIdentifyVC.h"
#import "LCUserIdentityHelper.h"
#import "LCUserRouteListVC.h"
#import "LCBillCell.h"
#import "LCBillSummarizeCell.h"
#import "LCBillTitleCell.h"
#import "LCDepositIntroCell.h"

@interface LCUserServiceVC ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *guideLabel;
@property (weak, nonatomic) IBOutlet UILabel *guideStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *carLabel;
@property (weak, nonatomic) IBOutlet UILabel *carStatusLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;


//Data
@property (strong, nonatomic) NSDecimalNumber *profitIn;
@property (strong, nonatomic) NSDecimalNumber *profitOut;
@property (strong, nonatomic) NSDecimalNumber *profitClear;
@property (strong, nonatomic) NSArray *planArray;

@property (nonatomic, strong) NSMutableArray *profitOutPlanArray;
@property (nonatomic, strong) NSMutableArray *profitInPlanArray;

@end

@implementation LCUserServiceVC

+ (instancetype)createInstance{
    return (LCUserServiceVC *)[LCStoryboardManager viewControllerWithFileName:SBNameUserTab identifier:VCIDUserServiceVC];
}

- (void)commonInit{
    [super commonInit];
    self.type = LCUserServiceType_Normal;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *headerView = self.tableView.tableHeaderView;
    CGRect headerFrame = headerView.frame;
    headerFrame.size.height = 104;
    headerView.frame = headerFrame;
    
    [self addObserveToNotificationNameToRefreshData:URL_GUIDE_IDENTITY];
    [self addObserveToNotificationNameToRefreshData:URL_CAR_IDENTITY];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
    [self updateShow];
}

- (void)refreshData{
    [YSAlertUtil showHudWithHint:nil];
    [LCNetRequester getPlanProfitList:[LCDataManager sharedInstance].userInfo.uUID isClear:0 callBack:^(NSDecimalNumber *profitIn,
                                                                                                        NSDecimalNumber *profitOut,
                                                                                                        NSDecimalNumber *profitClear,
                                                                                                        NSArray *planArray,
                                                                                                        NSError *error) {
        [YSAlertUtil hideHud];
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
        }else{
            self.profitIn = profitIn;
            self.profitOut = profitOut;
            self.profitClear = profitClear;
            self.planArray = planArray;
            
            [self updateShow];
        }
    }];
    
    if ([self haveLogin]) {
        [LCNetRequester getUserInfo:[LCDataManager sharedInstance].userInfo.uUID callBack:^(LCUserModel *user, NSError *error) {
            if (error) {
                LCLogWarn(@"get user info error :%@",error);
            }else{
                [LCDataManager sharedInstance].userInfo = user;
                [[LCDataManager sharedInstance] saveData];
                
                [self updateShow];
            }
        }];
    }
}

- (void)updateShow{
    if (LCUserServiceType_Bill == self.type) {
        self.tableView.tableHeaderView.hidden = YES;
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.title = @"我的账单";
    } else if (LCUserServiceType_Normal == self.type && [LCDataManager sharedInstance].userInfo) {
        self.tableView.tableHeaderView.hidden = NO;
        self.title = @"我的服务";
        LCUserModel *user = [LCDataManager sharedInstance].userInfo;
        if (user.isCarVerify == LCIdentityStatus_Done) {
            self.carLabel.text = @"我的车辆信息";
            self.carStatusLabel.hidden = YES;
        }else{
            self.carLabel.text = @"车辆信息认证";
            self.carStatusLabel.hidden = NO;
            
            if (user.isCarVerify == LCIdentityStatus_None) {
                self.carStatusLabel.text = @"未认证";
            }else if(user.isCarVerify == LCIdentityStatus_Verifying) {
                self.carStatusLabel.text = @"审核中";
            }else if(user.isCarVerify == LCIdentityStatus_Failed) {
                self.carStatusLabel.text = @"审核失败";
            }
        }
        
        if (user.isTourGuideVerify == LCIdentityStatus_Done) {
            self.guideLabel.text = @"我的服务路线";
            self.guideStatusLabel.hidden = YES;
        }else{
            self.guideLabel.text = @"领队服务认证";
            self.guideStatusLabel.hidden = NO;
            
            if (user.isTourGuideVerify == LCIdentityStatus_None) {
                self.guideStatusLabel.text = @"未认证";
            }else if(user.isTourGuideVerify == LCIdentityStatus_Verifying) {
                self.guideStatusLabel.text = @"审核中";
            }else if(user.isTourGuideVerify == LCIdentityStatus_Failed) {
                self.guideStatusLabel.text = @"审核失败";
            }
        }
    }
    [self updateCellIndex];
    [self.tableView reloadData];
}

#pragma mark Set & Get
- (void)setPlanArray:(NSArray *)planArray{
    _planArray = planArray;
    
    self.profitInPlanArray = [[NSMutableArray alloc] init];
    self.profitOutPlanArray = [[NSMutableArray alloc] init];
    
    for (LCPlanModel *aPlan in planArray){
        if (aPlan.totalOrderStatus == LCPlanOrderStatus_InBill) {
            [self.profitInPlanArray addObject:aPlan];
        }else if(aPlan.totalOrderStatus == LCPlanOrderStatus_OutBill) {
            [self.profitOutPlanArray addObject:aPlan];
        }
    }
}

#pragma mark Button Action
- (IBAction)guideAuthenticateButtonAction:(id)sender {
    LCUserModel *user = [LCDataManager sharedInstance].userInfo;
    
    if (user && user.isTourGuideVerify!=LCIdentityStatus_Done) {
        [[LCUserIdentityHelper sharedInstance] starGuideIdentityWithUser:[LCDataManager sharedInstance].userInfo fromVC:self];
    }else{
        [LCViewSwitcher pushToShowRouteListVCOn:self.navigationController];
    }
}

- (IBAction)carAuthenticateButtonAction:(id)sender {
    [[LCUserIdentityHelper sharedInstance] startCarIdentityWithUser:[LCDataManager sharedInstance].userInfo fromVC:self];
}


#pragma mark TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    /* Roy 2015.8.17
     for merchant, show BillSummarizeCell
     for normal user, only show TableViewHeaderView
     */
    if ([[LCDataManager sharedInstance].userInfo isMerchant] ||
        [[LCDataManager sharedInstance].userInfo isCarServer]) {
        return 1;
    }else{
        return 0;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowNum = depositCellIndex + 1;
    
    return rowNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    
    if (indexPath.row == 0) {
        LCBillSummarizeCell *summarizeCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCBillSummarizeCell class]) forIndexPath:indexPath];
        [summarizeCell updateShowWithProfitIn:self.profitIn isLastCell:(self.planArray.count>0?NO:YES)];
        cell = summarizeCell;
    }else if(indexPath.row == profitOutTitleIndex){
        // profit out title cell
        LCBillTitleCell *titleCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCBillTitleCell class]) forIndexPath:indexPath];
        titleCell.titleLabel.text = @"未入账记录";
        cell = titleCell;
    }else if(self.profitOutPlanArray.count > 0 &&
             (indexPath.row > profitOutTitleIndex && indexPath.row <= profitOutTitleIndex+self.profitOutPlanArray.count)){
        // profit out cell
        NSInteger planIndex = indexPath.row - profitOutTitleIndex - 1;
        LCBillCell *billCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCBillCell class]) forIndexPath:indexPath];
        BOOL isLastCell = NO;
        if (planIndex == (self.profitOutPlanArray.count-1) &&
            self.profitInPlanArray.count <= 0) {
            isLastCell = YES;
        }
        [billCell updateShowWithPlan:self.profitOutPlanArray[planIndex] isLastCell:isLastCell];
        cell = billCell;
    }else if(indexPath.row == profitInTitleIndex){
        // profit in title cell
        LCBillTitleCell *titleCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCBillTitleCell class]) forIndexPath:indexPath];
        NSDateComponents *comps = [LCDateUtil getComps:[NSDate date]];
        NSInteger month = [comps month];
        titleCell.titleLabel.text = [NSString stringWithFormat:@"%ld月入账记录",(long)month];
        cell = titleCell;
    }else if(self.profitInPlanArray.count > 0 &&
             (indexPath.row > profitInTitleIndex && indexPath.row <= profitInTitleIndex+self.profitInPlanArray.count)){
        /// profit in cell
        NSInteger planIndex = indexPath.row - profitInTitleIndex -1;
        LCBillCell *billCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCBillCell class]) forIndexPath:indexPath];
        BOOL isLastCell = planIndex == (self.profitInPlanArray.count-1) ? YES : NO;
        [billCell updateShowWithPlan:self.profitInPlanArray[planIndex] isLastCell:isLastCell];
        cell = billCell;
    }else if(indexPath.row == depositCellIndex){
        LCDepositIntroCell *depositCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCDepositIntroCell class]) forIndexPath:indexPath];
        
        cell = depositCell;
    }
    
    
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    
    if (indexPath.row == 0) {
        height = [LCBillSummarizeCell getCellHeight];
    }else if(indexPath.row == profitInTitleIndex ||
             indexPath.row == profitOutTitleIndex){
        height = [LCBillTitleCell getCellHeight];
    }else if(indexPath.row == depositCellIndex){
        height = [LCDepositIntroCell getCellHeight];
    }else{
        height = [LCBillCell getCellHeight];
    }
    
    return height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(self.profitOutPlanArray.count > 0 &&
       (indexPath.row > profitOutTitleIndex && indexPath.row <= profitOutTitleIndex+self.profitOutPlanArray.count)){
        NSInteger planIndex = indexPath.row - profitOutTitleIndex - 1;
        [LCViewSwitcher pushToShowPlanDetailVCForPlan:self.profitOutPlanArray[planIndex] recmdUuid:nil on:self.navigationController];
    }else if(self.profitInPlanArray.count > 0 &&
             (indexPath.row > profitInTitleIndex && indexPath.row <= profitInTitleIndex+self.profitInPlanArray.count)){
        NSInteger planIndex = indexPath.row - profitInTitleIndex -1;
        [LCViewSwitcher pushToShowPlanDetailVCForPlan:self.profitInPlanArray[planIndex] recmdUuid:nil on:self.navigationController];
    }
}


#pragma mark Calculate Cell
static NSInteger profitOutTitleIndex;
static NSInteger profitInTitleIndex;
static NSInteger depositCellIndex;
- (void)updateCellIndex{
    profitOutTitleIndex = -1;
    if (self.profitOutPlanArray.count > 0) {
        profitOutTitleIndex = 1;
    }
    
    profitInTitleIndex = -1;
    if (self.profitInPlanArray.count <= 0) {
        profitInTitleIndex = -1;
    }else {
        if (self.profitOutPlanArray.count > 0) {
            profitInTitleIndex = profitOutTitleIndex + self.profitOutPlanArray.count + 1;
        }else{
            profitInTitleIndex = 1;
        }
    }
    
    
    if (self.profitInPlanArray.count > 0) {
        depositCellIndex = profitInTitleIndex + self.profitInPlanArray.count + 1;
    }else if(self.profitOutPlanArray.count > 0) {
        depositCellIndex = profitOutTitleIndex + self.profitOutPlanArray.count + 1;
    }else{
        depositCellIndex = 1;
    }
}


#pragma mark Inner Function
- (BOOL)checkUserIdentity{
    if ([LCDataManager sharedInstance].userInfo &&
        [LCDataManager sharedInstance].userInfo.isIdentify) {
        return YES;
    }else{
        return NO;
    }
}

@end
