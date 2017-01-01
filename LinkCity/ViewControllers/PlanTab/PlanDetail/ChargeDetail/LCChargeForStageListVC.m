//
//  LCChargeDetailVC.m
//  LinkCity
//
//  Created by Roy on 6/25/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCChargeForStageListVC.h"
#import "LCChargeDetailUserCell.h"
#import "LCChargeDetailTitleCell.h"
#import "LCShareUtil.h"
#import "LCChargeDetailTipCell.h"
#import "LCChargeDetailStageCell.h"
#import "LCChargeForAStageVC.h"

@interface LCChargeForStageListVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LCChargeForStageListVC

+ (instancetype)createInstance{
    return (LCChargeForStageListVC *)[LCStoryboardManager viewControllerWithFileName:SBNamePlanDetail identifier:NSStringFromClass([LCChargeForStageListVC class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self updateShow];
}

- (void)refreshData{
    [YSAlertUtil showHudWithHint:nil inView:[UIApplication sharedApplication].delegate.window enableUserInteraction:YES];
    [LCNetRequester getPlanJoinedUserListFromPlanGuid:self.plan.planGuid callBack:^(NSArray *stageArray, NSDecimalNumber *totalStageIncome, NSError *error) {
        [YSAlertUtil hideHud];
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain];
        }else{
            self.stageArray = stageArray;
            self.totalStageIncome = totalStageIncome;
            
            [self updateShow];
        }
    }];
}

- (void)updateShow{
    self.title = @"报名详情";
    
    [self.tableView reloadData];
}

#pragma mark TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowNum = 0;
    
    rowNum = self.stageArray.count + 1;
    
    return rowNum;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    
    if (indexPath.row == 0) {
        LCChargeDetailTitleCell *titleCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCChargeDetailTitleCell class]) forIndexPath:indexPath];
        NSDecimalNumber *totalEarnest = [NSDecimalNumber decimalNumberWithString:@"0"];
        for (LCPartnerStageModel *aStage in self.stageArray){
            totalEarnest = [totalEarnest decimalNumberByAdding:aStage.totalEarnest];
        }
        [titleCell updateShowAsStageArrayForTotalEarnest:totalEarnest];
        cell = titleCell;
    }else if(indexPath.row > 0 && indexPath.row < self.stageArray.count + 1){
        
        NSInteger stageIndex = indexPath.row - 1;
        BOOL isFirst = (stageIndex == 0 ? YES : NO);
        BOOL isLast = (stageIndex == (self.stageArray.count-1) ? YES : NO);
        
        LCChargeDetailStageCell *stageCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCChargeDetailStageCell class]) forIndexPath:indexPath];
        [stageCell updateShowWithStage:[self.stageArray objectAtIndex:indexPath.row - 1] isFirstCell:isFirst isLastCell:isLast];
        
        stageCell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell = stageCell;
    }
    
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = [UIColor yellowColor];
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    
    if (indexPath.row == 0) {
        height = [LCChargeDetailTitleCell getCellHeightWhetherShowMemberTitle:NO];
    }else if(indexPath.row > 0 && indexPath.row < self.stageArray.count + 1){
        height = [LCChargeDetailStageCell getCellHeight];
    }
    
    return height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger stageIndex = indexPath.row - 1;
    if (stageIndex >= 0 && stageIndex < self.stageArray.count) {
        LCChargeForAStageVC *chargeStageVC = [LCChargeForAStageVC createInstance];
        chargeStageVC.stage = [self.stageArray objectAtIndex:stageIndex];
        [self.navigationController pushViewController:chargeStageVC animated:YES];
    }
    
}

@end
