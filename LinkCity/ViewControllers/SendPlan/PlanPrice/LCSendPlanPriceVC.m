//
//  LCSendPlanPriceVC.m
//  LinkCity
//
//  Created by Roy on 6/25/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCSendPlanPriceVC.h"
#import "LCSendPlanPriceCell.h"
#import "LCSendPlanPriceHeaderCell.h"
#import "LCSendPlanPriceFooterCell.h"

@interface LCSendPlanPriceVC ()<UITextFieldDelegate, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, LCSendPlanPriceFooterCellDelegate,LCSendPLanPriceCellDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) LCSendPlanPriceFooterCell *footerCell;

@end

@implementation LCSendPlanPriceVC

+ (instancetype)createInstance{
    return (LCSendPlanPriceVC *)[LCStoryboardManager viewControllerWithFileName:SBNameSendPlan identifier:VCIDSendPlanPriceVC];
}

- (void)commonInit{
    [super commonInit];
    
    //    self.earnestRadioIndex = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"费用说明";
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:LCNavBarBackBarButtonImageName] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonAction)];
    self.navigationItem.leftBarButtonItem = backBarButton;
    
    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(submitButtonAction:)];
    self.navigationItem.rightBarButtonItem = submitButton;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView.panGestureRecognizer addTarget:self action:@selector(panAction:)];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    /*Roy 2015.8.24
     有可能以前版本发约伴保存了草稿，草稿中的stageArray不存在
     新版本的发约伴初始化草稿时，都至少添加一个stage
     */
    if ([[LCDataManager sharedInstance].userInfo isMerchant] &&
        self.curPlan.stageArray.count < 1) {
        
        self.curPlan.stageArray = [[NSMutableArray alloc] init];
        [self.curPlan.stageArray addObject:[[LCPartnerStageModel alloc] init]];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)mergeUIDataIntoModel{
    if (self.footerCell) {
        [self.footerCell mergeUIDataIntoModel];
    }
}


#pragma mark Set & Get
- (void)setEditingPlan:(LCPlanModel *)editingPlan{
    [super setCurPlan:editingPlan];
    
    if (!self.curPlan.costPrice) {
        self.curPlan.costPrice = [NSDecimalNumber zero];
    }
}

#pragma mark ButtonAction
- (void)backBarButtonAction{
    [self mergeUIDataIntoModel];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)panAction:(id)sender{
    [self.view endEditing:YES];
}

- (void)submitButtonAction:(id)sender{
    [self doSubmitAction];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.curPlan.stageArray.count + 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    
    if (indexPath.row == 0) {
        height = [LCSendPlanPriceHeaderCell getCellHeight];
    }else if(indexPath.row <= self.curPlan.stageArray.count) {
        height = [LCSendPlanPriceCell getCellHeight];
    }else if(indexPath.row == self.curPlan.stageArray.count + 1) {
        height = [LCSendPlanPriceFooterCell getCellHeight];
    }
    
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    
    if (indexPath.row == 0) {
        LCSendPlanPriceHeaderCell *headerCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCSendPlanPriceHeaderCell class])];
        cell = headerCell;
    }else if(indexPath.row <= self.curPlan.stageArray.count) {
        NSInteger stageIndex = indexPath.row - 1;
        LCSendPlanPriceCell *priceCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCSendPlanPriceCell class]) forIndexPath:indexPath];
        [priceCell updateShowWithStage:[self.curPlan.stageArray objectAtIndex:stageIndex] isFirstStage:(stageIndex==0)];
        priceCell.delegate = self;
        cell = priceCell;
    }else if(indexPath.row == self.curPlan.stageArray.count + 1) {
        self.footerCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCSendPlanPriceFooterCell class])];
        self.footerCell.editingPlan = self.curPlan;
        self.footerCell.delegate = self;
        cell = self.footerCell;
    }
    
    return cell;
}

#pragma mark Inner Func
- (NSDecimalNumber *)getEarnestRadioByIndex:(NSInteger)index{
    if ([LCDataManager sharedInstance].orderRule &&
        [LCDataManager sharedInstance].orderRule.earnestRadioList.count > index) {
        return [[LCDataManager sharedInstance].orderRule.earnestRadioList objectAtIndex:index];
    }else{
        return [NSDecimalNumber decimalNumberWithString:@"1"];
    }
}

#pragma mark LCSendPlanPriceCell Delegate
- (void)sendPlanPriceCell:(LCSendPlanPriceCell *)cell requestToShowView:(UIView *)v{
    CGRect f = [v convertRect:v.bounds toView:self.tableView];
    f.origin.y += 240;
    
    [self.tableView scrollRectToVisible:f animated:YES];
}

- (void)sendPlanPriceCellDidClickDeleteStageButton:(LCSendPlanPriceCell *)cell{
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    NSInteger stageIndex = cellIndexPath.row - 1;
    [self.curPlan removeStageAtIndex:stageIndex];
    
    [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark LCSendPlanPriceFooterCell Delegate
- (void)sendPlanPriceFooterCell:(LCSendPlanPriceFooterCell *)footerCell requestToShowView:(UIView *)v{
    CGRect f = [v convertRect:v.bounds toView:self.tableView];
    f.origin.y += 260;
    
    [self.tableView scrollRectToVisible:f animated:YES];
}

- (void)sendPlanPriceFooterCellDidClickAddStageButton:(LCSendPlanPriceFooterCell *)footerCell{
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:footerCell];
    
    LCPartnerStageModel *stage = [[LCPartnerStageModel alloc] init];
    [self.curPlan addStage:stage];
    
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:cellIndexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)sendPlanPriceFooterCellDidClickEarnestIntroButton:(LCSendPlanPriceFooterCell *)footerCell{
    [LCViewSwitcher pushWebVCtoShowURL:server_url(SERVER_HOST, LCEarnestIntroURL) withTitle:@"订金说明" on:self.navigationController];
}

- (void)sendPlanPriceFooterCellDidClickSubmitButton:(LCSendPlanPriceFooterCell *)footerCell{
    [self doSubmitAction];
}

#pragma mark -
- (void)doSubmitAction{
    [self.view endEditing:YES];
    [self mergeUIDataIntoModel];
    
    if ([self checkInput]) {
        if (self.curPlan.stageArray.count == 1) {
            //只有一期，可以不收费
            LCPartnerStageModel *stage = self.curPlan.stageArray[0];
            if (![LCDecimalUtil isOverZero:stage.price]) {
                //不收费
                [YSAlertUtil alertTwoButton:@"取消" btnTwo:@"退出" withTitle:nil msg:@"单人费用为0，您的约伴将不会收费，确定要退出吗？" callBack:^(NSInteger chooseIndex) {
                    if (chooseIndex == 1) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }else{
                        // user cancel to quit, do nothing
                        return;
                    }
                }];
            }else{
                //收费
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else{
            //多期约伴，收费
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (BOOL)checkInput{
    BOOL ret = YES;
    NSString *errMsg = @"";
    
    //分期约伴，必须收费
    for (LCPartnerStageModel *stage in self.curPlan.stageArray){
        if ([LCStringUtil isNullString:stage.startTime] ||
            [LCStringUtil isNullString:stage.endTime]) {
            errMsg = [errMsg stringByAppendingString:@"约伴日期不能为空;"];
            ret = NO;
            break;
        }
        
        if (![LCDecimalUtil isOverZero:stage.price]) {
            errMsg = [errMsg stringByAppendingString:@"价格不能为0;"];
            ret = NO;
            break;
        }
    }
    
    if ([LCStringUtil isNullString:[LCStringUtil trimSpaceAndEnter:self.curPlan.costInclude]]) {
        errMsg = [errMsg stringByAppendingString:@"费用包含项目不能为空;"];
        ret = NO;
    }
    
    if ([LCStringUtil isNullString:[LCStringUtil trimSpaceAndEnter:self.curPlan.costExclude]]) {
        errMsg = [errMsg stringByAppendingString:@"费用不包含的项目不能为空;"];
        ret = NO;
    }
    
    if (self.curPlan.stageArray.count > 1) {
        NSString *lastStageStartTime = @"";
        for(LCPartnerStageModel *stage in self.curPlan.stageArray){
            NSString *curStageStartTime = stage.startTime;
            if ([curStageStartTime compare:lastStageStartTime] != NSOrderedDescending) {
                errMsg = [errMsg stringByAppendingString:@"后一期约伴的出发时间必须晚于上一期；"];
                ret = NO;
                break;
            }
            lastStageStartTime = curStageStartTime;
        }
    }
    
    if ([LCStringUtil isNotNullString:errMsg]) {
        [YSAlertUtil tipOneMessage:errMsg yoffset:TipAboveKeyboardYoffset delay:TipErrorDelay];
    }
    
    return ret;
}


@end
