//
//  LCSendCostPlanStageVC.m
//  LinkCity
//
//  Created by Roy on 12/15/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCSendCostPlanStageVC.h"
#import "LCSendCostPlanStageCell.h"
#import "LCOneDatePickView.h"
#import "KLCPopup.h"
#import "LCSendCostPlanRouteListVC.h"
#import "LCSendCostPlanFeeIncludeVC.h"

@interface LCSendCostPlanStageVC ()<UITableViewDataSource, UITableViewDelegate, LCSendCostPlanStageCellDelegate, LCOneDatePickViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTop;

@property (weak, nonatomic) IBOutlet UIButton *minusDayBtn;
@property (weak, nonatomic) IBOutlet UIButton *addDayBtn;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;

@property (weak, nonatomic) IBOutlet UILabel *routeLabel;

@property (weak, nonatomic) IBOutlet UIButton *addStageBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (nonatomic, strong) UIView *oneDatePickHolderView;
@property (nonatomic, strong) LCOneDatePickView *oneDatePickView;
@property (nonatomic, strong) KLCPopup *oneDatePickPopup;

//Inner Date
@property (nonatomic, strong) LCPartnerStageModel *selectedStage;

@end

@implementation LCSendCostPlanStageVC

+ (instancetype)createInstance{
    return (LCSendCostPlanStageVC *)[LCStoryboardManager viewControllerWithFileName:SBNameSendPlan identifier:NSStringFromClass([LCSendCostPlanStageVC class])];
}

- (void)commonInit{
    [super commonInit];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
    self.navigationItem.rightBarButtonItem = cancelBarButton;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 80;
    [self.tableView.panGestureRecognizer addTarget:self action:@selector(tableViewPanAction:)];
    
    self.addStageBtn.layer.masksToBounds = YES;
    self.addStageBtn.layer.cornerRadius = 3;
    self.addStageBtn.layer.borderWidth = 1;
    self.addStageBtn.layer.borderColor = DefaultSpalineColor.CGColor;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self updateShow];
}

- (void)setCurPlan:(LCPlanModel *)curPlan{
    [super setCurPlan:curPlan];
    
    LCPartnerStageModel *stage = [self.curPlan.stageArray firstObject];
    if (!stage ||
        [LCStringUtil isNullString:stage.startTime] ||
        [LCStringUtil isNullString:stage.endTime]) {
        self.curPlan.daysLong = 1;    //如果出发和结束日期不完整，默认设为1天
    }else{
        self.curPlan.daysLong = [LCDateUtil numberOfDaysFromDateStr:stage.startTime toAnotherStr:stage.endTime];
    }
}

- (void)updateShow{
    [self.tableView reloadData];
    
    self.dayLabel.text = [NSString stringWithFormat:@"%ld天",(long)self.curPlan.daysLong];
    if (self.curPlan.daysLong <= 1) {
        [self.minusDayBtn setImage:[UIImage imageNamed:@"SendPlanMinusDayIcon_gray"] forState:UIControlStateNormal];
        self.minusDayBtn.enabled = NO;
    }else{
        [self.minusDayBtn setImage:[UIImage imageNamed:@"SendPlanMinusDayIcon"] forState:UIControlStateNormal];
        self.minusDayBtn.enabled = YES;
    }
    
    if (self.curPlan.userRoute) {
        self.routeLabel.text = [LCStringUtil getNotNullStr:self.curPlan.userRoute.routeTitle];
    }else{
        self.routeLabel.text = @"选择";
    }
    
    [self updateNextBtnShow];
}

- (void)updateNextBtnShow{
    if ([LCStringUtil isNullString:[self checkInput]]) {
        //input correct
        [[LCUIConstants sharedInstance] setButtonAsSubmitButtonEnableStyle:self.nextBtn];
    }else{
        //input error
        [[LCUIConstants sharedInstance] setButtonAsSubmitButtonDisableStyle:self.nextBtn];
    }
}

#pragma mark Get & Set
- (LCOneDatePickView *)oneDatePickView{
    if (!_oneDatePickView) {
        _oneDatePickView = [LCOneDatePickView createInstanceWithVC:self];
    }
    return _oneDatePickView;
}
- (KLCPopup *)oneDatePickPopup{
    if (!_oneDatePickPopup) {
        _oneDatePickView.delegate = self;
        _oneDatePickPopup = [KLCPopup popupWithContentView:self.oneDatePickView
                                                  showType:KLCPopupShowTypeSlideInFromBottom
                                               dismissType:KLCPopupDismissTypeSlideOutToBottom
                                                  maskType:KLCPopupMaskTypeDimmed
                                  dismissOnBackgroundTouch:YES
                                     dismissOnContentTouch:NO];
        _oneDatePickPopup.dimmedMaskAlpha = 0.5;
    }
    return _oneDatePickPopup;
}

#pragma mark Button Action
- (void)tapAction:(id)sender{
    [self.view endEditing:YES];
}

- (void)cancelAction:(id)sender{
    [MobClick event:Mob_PublishPlanB_Cancel];
    [self cancelSendPlan];
}

- (void)backBarButtonAction{
    [self mergeUIDataIntoModel];
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)minusDayBtnAction:(id)sender {
    self.curPlan.daysLong--;
    [self updateStageEndTime];
    [self updateShow];
}

- (IBAction)addDayBtnAction:(id)sender {
    self.curPlan.daysLong++;
    [self updateStageEndTime];
    [self updateShow];
}

- (IBAction)selectRouteBtnAction:(id)sender {
    LCSendCostPlanRouteListVC *routeListVC = [LCSendCostPlanRouteListVC createInstance];
    routeListVC.curPlan = self.curPlan;
    routeListVC.isSendingPlan = self.isSendingPlan;
    [self.navigationController pushViewController:routeListVC animated:YES];
}

- (IBAction)addStageBtnAction:(id)sender {
    LCPartnerStageModel *stage = [[LCPartnerStageModel alloc] init];
    [self.curPlan addStage:stage];
    
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:(self.curPlan.stageArray.count-1) inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self updateNextBtnShow];
}

- (IBAction)nextBtnAction:(id)sender {
    [MobClick event:Mob_PublishPlanA_Next];
    [self mergeUIDataIntoModel];
    
    NSString *inputErrorMsg = [self checkInput];
    if ([LCStringUtil isNullString:inputErrorMsg]) {
        LCSendCostPlanFeeIncludeVC *feeIncludeVC = [LCSendCostPlanFeeIncludeVC createInstance];
        feeIncludeVC.curPlan = self.curPlan;
        feeIncludeVC.isSendingPlan = self.isSendingPlan;
        [self.navigationController pushViewController:feeIncludeVC animated:YES];
    }else{
        [YSAlertUtil tipOneMessage:inputErrorMsg yoffset:TipDefaultYoffset delay:TipErrorDelay];
    }
}


#pragma mark TableView Delegate
- (void)tableViewPanAction:(id)sender{
    [self.view endEditing:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.curPlan.stageArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LCSendCostPlanStageCell *stageCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCSendCostPlanStageCell class]) forIndexPath:indexPath];
    LCPartnerStageModel *stage = [self.curPlan.stageArray objectAtIndex:indexPath.row];
    stageCell.delegate = self;
    [stageCell updateShowWithStage:stage stageIndex:indexPath.row];
    
    stageCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return stageCell;
}

#pragma mark Edit Cell
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.curPlan.stageArray.count <= 1) {
        [YSAlertUtil tipOneMessage:@"至少保留一期"];
    }else{
        [self.curPlan removeStageAtIndex:indexPath.item];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView reloadData];
        [self updateNextBtnShow];
    }
}


#pragma mark Cell Delegate
- (void)sendCostPlanStageCellDidClickDate:(LCSendCostPlanStageCell *)cell{
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    self.selectedStage = [self.curPlan.stageArray objectAtIndex:cellIndexPath.row];
    [self.oneDatePickView setStartDate:self.selectedStage.startTime];
    [self.oneDatePickPopup showWithLayout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutBottom)];
}

- (void)sendCostPlanStageCell:(LCSendCostPlanStageCell *)cell willChangePriceTextTo:(NSString *)priceText{
    
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    LCPartnerStageModel *stage = [self.curPlan.stageArray objectAtIndex:cellIndexPath.row];
    if ([LCStringUtil isNotNullString:priceText]){
        stage.price = [NSDecimalNumber decimalNumberWithString:priceText];
    }else{
        stage.price = nil;
    }
    [self updateNextBtnShow];
    
}

- (void)sendCostPlanStageCellDidInputPrice:(LCSendCostPlanStageCell *)cell{
    [self updateNextBtnShow];
}

#pragma mark OneDatePickView Delegate
- (void)oneDatePickView:(LCOneDatePickView *)v didSelectOneDate:(NSString *)dateStr{
    if (self.selectedStage) {
        self.selectedStage.startTime = dateStr;
        NSDate *startDate = [LCDateUtil dateFromString:dateStr];
        NSDate *endDate = [startDate dateByAddingTimeInterval:(SEC_PER_DAY * (self.curPlan.daysLong-1))];
        self.selectedStage.endTime = [LCDateUtil stringFromDate:endDate];
    }
    
    [self.oneDatePickPopup dismiss:YES];
    [self updateShow];
}

#pragma mark
- (NSString *)checkInput{
    NSString *errorMsg = @"";
    
    //分期邀约，必须收费
    for (LCPartnerStageModel *stage in self.curPlan.stageArray){
        if ([LCStringUtil isNullString:stage.startTime] ||
            [LCStringUtil isNullString:stage.endTime]) {
            errorMsg = [errorMsg stringByAppendingString:@"请填写活动日期\r\n"];
            break;
        }
        
        if (![LCDecimalUtil isOverZero:stage.price]) {
            errorMsg = [errorMsg stringByAppendingString:@"请填写活动金额\r\n"];
            break;
        }
    }
    
    if (self.curPlan.stageArray.count > 1) {
        NSString *lastStageStartTime = @"";
        for(LCPartnerStageModel *stage in self.curPlan.stageArray){
            NSString *curStageStartTime = stage.startTime;
            if ([curStageStartTime compare:lastStageStartTime] != NSOrderedDescending) {
                errorMsg = [errorMsg stringByAppendingString:@"后一期邀约的出发时间必须晚于上一期\r\n"];
                break;
            }
            lastStageStartTime = curStageStartTime;
        }
    }
    
    //如果最后多回车符，去掉
    errorMsg = [LCStringUtil trimSpaceAndEnter:errorMsg];
    
    LCLogInfo(@"checkInput :%@",errorMsg);
    return errorMsg;
}

- (void)mergeUIDataIntoModel{
    
}

- (void)updateStageEndTime{
    for (LCPartnerStageModel *stage in self.curPlan.stageArray){
        if ([LCStringUtil isNotNullString:stage.startTime]) {
            NSDate *startDate = [LCDateUtil dateFromString:stage.startTime];
            NSDate *endDate = [startDate dateByAddingTimeInterval:(SEC_PER_DAY * (self.curPlan.daysLong-1))];
            stage.endTime = [LCDateUtil stringFromDate:endDate];
        }
    }
}

#pragma mark KeyBoard
//当输入框在scrollview最下时，键盘弹出后即使scrollview滚到底，输入框也显示不出
//为此每当显示键盘时，将scrollview上提
- (void)keyboardWillShow:(NSNotification *)aNotification{
    [super keyboardWillShow:aNotification];
    
    UIView *firstResponder = [self getFirstResponderOfView:self.view];
    if (firstResponder) {
        CGRect r = [firstResponder convertRect:firstResponder.bounds toView:self.view];
        
        if (r.origin.y > 120) {
            self.tableViewTop.constant = 120 - r.origin.y;
        }
        [self.view layoutIfNeeded];
    }
}

- (void)keyboardWillBeHidden:(NSNotification *)aNotification{
    [super keyboardWillBeHidden:aNotification];
    self.tableViewTop.constant = 0;
    [self.view layoutIfNeeded];
}



@end


