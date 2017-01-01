//
//  LCPlanBaseinfoVC.m
//  LinkCity
//
//  Created by roy on 2/8/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCPlanBaseinfoVC.h"
#import "LCPlanImageVC.h"
#import "CalendarHomeViewController.h"
#import "LCDialogInputter.h"
#import "LCRoutePlaceAddCell.h"
#import "LCRoutePlaceDeleteCell.h"
#import "LCPlanDestinationCollectionLayout.h"
#import "LCDateUtil.h"
#import "SZTextView.h"
#import "LCBaiduMapManager.h"
#import "LCSendPlanPriceVC.h"

#define StartPlaceTop_Customer (0)
#define StartPlaceTop_Merchant (174)
#define DestinationSeparator @" "

@interface LCPlanBaseinfoVC ()<CalendarHomeViewDelegate,UITextViewDelegate,UITextFieldDelegate>

//UI

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewBottomConstraint;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *themeCellHeightContraint;
@property (weak, nonatomic) IBOutlet UIButton *themeBtnAA;
@property (weak, nonatomic) IBOutlet UIButton *themeBtnAB;
@property (weak, nonatomic) IBOutlet UIButton *themeBtnAC;
@property (weak, nonatomic) IBOutlet UIButton *themeBtnAD;
@property (weak, nonatomic) IBOutlet UIButton *themeBtnBA;
@property (weak, nonatomic) IBOutlet UIButton *themeBtnBB;
@property (weak, nonatomic) IBOutlet UIButton *themeBtnBC;
@property (weak, nonatomic) IBOutlet UIButton *themeBtnBD;
@property (weak, nonatomic) IBOutlet UIButton *themeBtnCA;
@property (weak, nonatomic) IBOutlet UIButton *themeBtnCB;
@property (weak, nonatomic) IBOutlet UIButton *themeBtnCC;
@property (weak, nonatomic) IBOutlet UIButton *themeBtnCD;
@property (nonatomic, strong) NSArray *themeBtnArray;

@property (weak, nonatomic) IBOutlet UIView *serviceView;
@property (weak, nonatomic) IBOutlet UILabel *carSelectLabel;
@property (weak, nonatomic) IBOutlet UIButton *carSelectBtn;
@property (weak, nonatomic) IBOutlet UILabel *leadSelectLabel;
@property (weak, nonatomic) IBOutlet UIButton *leadSelectBtn;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *startPlaceViewTopConstraint;
@property (weak, nonatomic) IBOutlet UIView *startPlaceBgView;
@property (weak, nonatomic) IBOutlet UITextField *startPlaceTextField;
@property (weak, nonatomic) IBOutlet UIView *destinationBgView;
@property (weak, nonatomic) IBOutlet UITextField *destinationTextField;


@property (weak, nonatomic) IBOutlet UIImageView *timeAndFeeIcon;
@property (weak, nonatomic) IBOutlet UILabel *timeAndFeeTitle;
@property (weak, nonatomic) IBOutlet UILabel *timeAndFeeLabel;

@property (weak, nonatomic) IBOutlet UIView *briefInfoBgView;
@property (weak, nonatomic) IBOutlet SZTextView *briefInfoTextView;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (nonatomic, retain) CalendarHomeViewController *calendarController;

@end

@implementation LCPlanBaseinfoVC

+ (instancetype)createInstance{
    return (LCPlanBaseinfoVC *)[LCStoryboardManager viewControllerWithFileName:SBNameSendPlan identifier:VCIDPlanBaseinfoVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil]];
    
    UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
    self.navigationItem.rightBarButtonItem = cancelBarButton;
    
    
    UIPanGestureRecognizer *panGesture = self.scrollView.panGestureRecognizer;
    [panGesture addTarget:self action:@selector(panGestureAction:)];
    
    self.scrollView.delegate = self;
    
    self.themeBtnArray = @[self.themeBtnAA,self.themeBtnAB,self.themeBtnAC,self.themeBtnAD,
                           self.themeBtnBA,self.themeBtnBB,self.themeBtnBC,self.themeBtnBD,
                           self.themeBtnCA,self.themeBtnCB,self.themeBtnCC,self.themeBtnCD];
    
    [self.themeBtnArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *btn = (UIButton *)obj;
        btn.tag = idx;
        btn.layer.cornerRadius = 3;
        btn.layer.masksToBounds = YES;
        btn.backgroundColor = UIColorFromRGBA(LCThemeBtnNormalBg, 1);
        
        if ([LCDataManager sharedInstance].appInitData.planThemes.count > idx) {
            LCRouteThemeModel *planTheme = [LCDataManager sharedInstance].appInitData.planThemes[idx];
            [btn setTitle:planTheme.title forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(themeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            btn.hidden = NO;
        }else{
            btn.hidden = YES;
        }
    }];
    
    NSInteger planThemeCount = [LCDataManager sharedInstance].appInitData.planThemes.count;
    planThemeCount = MIN(planThemeCount, 12);
    NSInteger themeBtnLineNum = MAX((planThemeCount-1), 0)/4+1;
    self.themeCellHeightContraint.constant = themeBtnLineNum*32 + 44;
    
    
    [[LCUIConstants sharedInstance] setViewAsInputBg:self.startPlaceBgView];
    [[LCUIConstants sharedInstance] setViewAsInputBg:self.destinationBgView];
    [[LCUIConstants sharedInstance] setViewAsInputBg:self.briefInfoBgView];
    
    self.startPlaceTextField.delegate = self;
    self.destinationTextField.delegate = self;
    self.briefInfoTextView.delegate = self;
    [self.briefInfoTextView setPlaceholder:@"您的自我介绍、行程计划、路线是否可调整、是否已出票以及您对驴友的要求等都可以写在这里。"];
    
    
    [[LCUIConstants sharedInstance] setButtonAsSubmitButtonEnableStyle:self.nextButton];
    
    [[LCBaiduMapManager sharedInstance] startUpdateUserLocation];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:NO];
    [self.tabBarController.tabBar setHidden:YES];
    
    [self updateShow];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self mergeUIDataIntoModel];
}

- (void)setEditingPlan:(LCPlanModel *)editingPlan{
    [super setCurPlan:editingPlan];
}


- (void)updateShow{
    if (![LCDataManager sharedInstance].userInfo) {
        // have not login
    }else{
        [self updateThemeBtnAppearnce];
        
        if ([self isMerchant]) {
            self.serviceView.hidden = NO;
            self.startPlaceViewTopConstraint.constant = StartPlaceTop_Merchant;
            [self updateServiceShow];
        }else{
            self.serviceView.hidden = YES;
            self.startPlaceViewTopConstraint.constant = StartPlaceTop_Customer;
        }
        
        //出发地
        self.startPlaceTextField.text = [LCStringUtil getNotNullStr:self.curPlan.departName];
        self.destinationTextField.text = [self.curPlan getDestinationsStringWithSeparator:DestinationSeparator];
        
        //时间和费用
        if ([self isMerchant]) {
            self.timeAndFeeIcon.image = [UIImage imageNamed:@"SendPlanCostIcon"];
            self.timeAndFeeTitle.text = @"时间及费用";
            self.timeAndFeeLabel.text = @"必填";
        }else{
            self.timeAndFeeIcon.image = [UIImage imageNamed:@"SendPlanTimeIcon"];
            self.timeAndFeeTitle.text = @"起止时间";
            
            NSString *timeString = @"";
            if (self.curPlan.stageArray.count > 0 &&
                [LCStringUtil isNotNullString:[[self.curPlan.stageArray firstObject] startTime]] &&
                [LCStringUtil isNotNullString:[[self.curPlan.stageArray firstObject] endTime]]) {
                
                timeString = [self getTimePickerStringFromStartTimeString:[[self.curPlan.stageArray firstObject] startTime] andEndTimeString:[[self.curPlan.stageArray firstObject] endTime]];
            }else{
                timeString = @"必填";
            }
            
            self.timeAndFeeLabel.text = timeString;
        }
        
        if ([LCStringUtil isNotNullString:self.curPlan.descriptionStr]) {
            self.briefInfoTextView.text = self.curPlan.descriptionStr;
        }else{
            self.briefInfoTextView.text = @"";
        }
    }
}

- (void)updateThemeBtnAppearnce{
    NSArray *planThemeArr = [LCDataManager sharedInstance].appInitData.planThemes;
    
    [planThemeArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx < self.themeBtnArray.count) {
            LCRouteThemeModel *aTheme = (LCRouteThemeModel *)obj;
            UIButton *btn = [self.themeBtnArray objectAtIndex:idx];
            
            if ([self.curPlan haveTheme:aTheme.tourThemeId]) {
                btn.backgroundColor = UIColorFromRGBA(LCThemeBtnHighlightBg, 1);
            }else{
                btn.backgroundColor = UIColorFromRGBA(LCThemeBtnNormalBg, 1);
            }
        }
    }];
}

- (void)mergeUIDataIntoModel{
    self.curPlan.departName = self.startPlaceTextField.text;
    self.curPlan.destinationNames = [self getDestinationArrayByString:self.destinationTextField.text];
    if (self.calendarController && [LCStringUtil isNotNullString:self.calendarController.startDateStr]) {
        [self setFirstStageStartTime:self.calendarController.startDateStr];
    }
    if (self.calendarController && [LCStringUtil isNotNullString:self.calendarController.endDateStr]) {
        [self setFirstStageEndTime:self.calendarController.endDateStr];
    }
    self.curPlan.descriptionStr = self.briefInfoTextView.text;
}

#pragma mark ButtonAction
- (void)themeBtnAction:(UIButton *)sender{
    NSArray *planThemeArr = [LCDataManager sharedInstance].appInitData.planThemes;
    if (sender.tag < planThemeArr.count) {
        LCRouteThemeModel *aTheme = [planThemeArr objectAtIndex:sender.tag];
        
        if ([self.curPlan haveTheme:aTheme.tourThemeId]) {
            [self.curPlan removeRouteTheme:aTheme.tourThemeId];
            sender.backgroundColor = UIColorFromRGBA(LCThemeBtnNormalBg, 1);
        }else{
            [self.curPlan addRouteTheme:aTheme];
            sender.backgroundColor = UIColorFromRGBA(LCThemeBtnHighlightBg, 1);
        }
    }
}

- (IBAction)carCellButtonAction:(id)sender {
    if ([LCDataManager sharedInstance].userInfo.isCarVerify == LCIdentityStatus_Done) {
        self.curPlan.isProvideCar = 1;
        self.curPlan.isProvideTourGuide = 0;
        [self updateServiceShow];
    }else{
        [YSAlertUtil tipOneMessage:@"认证包车后才能提供包车服务" yoffset:TipDefaultYoffset delay:TipErrorDelay];
    }
}
- (IBAction)leadCellButtonAction:(id)sender {
    if ([LCDataManager sharedInstance].userInfo.isTourGuideVerify == LCIdentityStatus_Done) {
        self.curPlan.isProvideCar = 0;
        self.curPlan.isProvideTourGuide = 1;
        [self updateServiceShow];
    }else{
        [YSAlertUtil tipOneMessage:@"认证领队后才能提供领队服务" yoffset:TipDefaultYoffset delay:TipErrorDelay];
    }
}
- (IBAction)timeAndFeeButtonAction:(id)sender {
    [MobClick event:Mob_PublishPlanA_Time];
    if ([self isMerchant]) {
        if (self.curPlan.userNum > 1) {
            [YSAlertUtil tipOneMessage:@"已经有人加入的约伴，不能修改费用" yoffset:TipAboveKeyboardYoffset delay:TipErrorDelay];
        }else{
            [self mergeUIDataIntoModel];
            LCSendPlanPriceVC *priceVC = [LCSendPlanPriceVC createInstance];
            priceVC.curPlan = self.curPlan;
            priceVC.isSendingPlan = self.isSendingPlan;
            [self.navigationController pushViewController:priceVC animated:YES];
        }
    }else{
        if (!self.calendarController) {
            self.calendarController = [[CalendarHomeViewController alloc] init];
        }
        self.calendarController.delegate = self;
        [self.calendarController setHotelToDay:365 selectStartDateforString:[self getFirstStageStartTime] selectEndDateforString:[self getFirstStageEndTime]];
        [self.navigationController pushViewController:self.calendarController animated:YES];
    }
}

- (IBAction)nextButtonAction:(id)sender {
    [MobClick event:Mob_PublishPlanA_Next];
    [self mergeUIDataIntoModel];
    if ([self checkInput]) {
        LCPlanImageVC *planImageVC = [LCPlanImageVC createInstance];
        planImageVC.curPlan = self.curPlan;
        planImageVC.isSendingPlan = self.isSendingPlan;
        [self.navigationController pushViewController:planImageVC animated:YES];
    }
}

- (void)cancelAction:(id)sender{
    [MobClick event:Mob_PublishPlanA_Cancel];
    [self mergeUIDataIntoModel];
    [self cancelSendPlan];
}

- (void)panGestureAction:(id)sender{
    [self.view endEditing:YES];
}

#pragma mark CalendarHomeView Delegate
/// 选择起止时间完成.
- (void)chooseDateFinished:(CalendarHomeViewController *)controller {
    NSString *startDateStr = controller.startDateStr;
    NSString *endDateStr = controller.endDateStr;
    LCLogInfo(@"Date: %@ - %@",startDateStr,endDateStr);
    
    [self setFirstStageStartTime:startDateStr];
    [self setFirstStageEndTime:endDateStr];
    
    self.timeAndFeeLabel.text = [self getTimePickerStringFromStartTimeString:startDateStr andEndTimeString:endDateStr];
}

#pragma mark - UITextView Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    LCLogInfo(@"should begin edit");
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    CGRect rect = textView.bounds;
    rect = [textView convertRect:textView.bounds toView:self.scrollView];
    [self.scrollView setContentOffset:CGPointMake(0, rect.origin.y-60) animated:YES];
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    [self.view endEditing:YES];
}
#pragma mark - UITextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //Roy 2015.5.30
    //如果直接执行，在点目的地输入框时，有时候会被键盘挡住——因为scrollview距底部的距离还没调整，就滚动，造成结果不确定
    //所以改成延时执行
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGRect rect = textField.bounds;
        rect = [textField convertRect:textField.bounds toView:self.scrollView];
        [self.scrollView setContentOffset:CGPointMake(0, rect.origin.y-60) animated:YES];
    });
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.startPlaceTextField) {
        [self.destinationTextField becomeFirstResponder];
    }else if(textField == self.destinationTextField) {
        [self.briefInfoTextView becomeFirstResponder];
    }
    return YES;
}


#pragma mark - HelperFunc
- (NSString *)getTimePickerStringFromStartTimeString:(NSString *)startTime andEndTimeString:(NSString *)endTime{
    NSInteger dayNum = [LCDateUtil numberOfDaysFromDateStr:startTime toAnotherStr:endTime];
    startTime = [LCDateUtil getDotDateFromHorizontalLineStr:startTime];
    return [startTime stringByAppendingFormat:@" | %ld天",(long)dayNum];
}

- (BOOL)checkInput{
    BOOL valid = YES;
    NSString *errorToastString = @"";
    
    /*********检查出发地、目的地、描述等基本信息***********/
    if ([LCStringUtil isNullString:[LCStringUtil trimSpaceAndEnter:self.startPlaceTextField.text]]) {
        valid = NO;
        errorToastString = [errorToastString stringByAppendingString:@"出发地不能为空;"];
    }
    
    if (!self.curPlan.destinationNames || self.curPlan.destinationNames.count<1 ) {
        valid = NO;
        errorToastString = [errorToastString stringByAppendingString:@"目的地不能为空;"];
    }
    
    if ([LCStringUtil isNullString:[self getFirstStageStartTime]] ||
        [LCStringUtil isNullString:[self getFirstStageEndTime]]) {
        
        valid = NO;
        errorToastString = [errorToastString stringByAppendingString:@"必须选择起止时间;"];
    }
    
    if ([LCStringUtil isNullString:[LCStringUtil trimSpaceAndEnter:self.briefInfoTextView.text]]) {
        valid = NO;
        errorToastString = [errorToastString stringByAppendingString:@"约伴简介不能为空;"];
    }
    
    
    /*********检查多期的内容***********/
    if ([[LCDataManager sharedInstance].userInfo isMerchant]) {
        if (self.curPlan.stageArray.count < 1) {
            errorToastString = [errorToastString stringByAppendingString:@"必须填写时间及费用;"];
            valid = NO;
        }
        
        for (LCPartnerStageModel *stage in self.curPlan.stageArray){
            if ([LCStringUtil isNullString:stage.startTime] ||
                [LCStringUtil isNullString:stage.endTime]) {
                errorToastString = [errorToastString stringByAppendingString:@"约伴日期不能为空;"];
                valid = NO;
                break;
            }
            
            if (![LCDecimalUtil isOverZero:stage.price]) {
                errorToastString = [errorToastString stringByAppendingString:@"价格不能为0;"];
                valid = NO;
                break;
            }
        }
        
        if ([LCStringUtil isNullString:[LCStringUtil trimSpaceAndEnter:self.curPlan.costInclude]]) {
            errorToastString = [errorToastString stringByAppendingString:@"费用包含项目不能为空;"];
            valid = NO;
        }
        
        if ([LCStringUtil isNullString:[LCStringUtil trimSpaceAndEnter:self.curPlan.costExclude]]) {
            errorToastString = [errorToastString stringByAppendingString:@"费用不包含的项目不能为空;"];
            valid = NO;
        }
        
        
        if (self.curPlan.stageArray.count > 1) {
            NSString *lastStageStartTime = @"";
            for(LCPartnerStageModel *stage in self.curPlan.stageArray){
                NSString *curStageStartTime = stage.startTime;
                if ([curStageStartTime compare:lastStageStartTime] != NSOrderedDescending) {
                    errorToastString = [errorToastString stringByAppendingString:@"后一期约伴的出发时间必须晚于上一期；"];
                    valid = NO;
                    break;
                }
                lastStageStartTime = curStageStartTime;
            }
        }
    }
    
    
    
    
    if (!valid) {
        [YSAlertUtil tipOneMessage:errorToastString yoffset:TipDefaultYoffset delay:TipErrorDelay];
    }
    
    return valid;
}



#pragma mark KeyBoard
//当输入框在scrollview最下时，键盘弹出后即使scrollview滚到底，输入框也显示不出
//为此每当显示键盘时，将scrollview上提
- (void)keyboardWillShow:(NSNotification *)aNotification{
    [super keyboardWillShow:aNotification];
    self.scrollViewBottomConstraint.constant = 200;
    [self.view layoutIfNeeded];
}
- (void)keyboardWillBeHidden:(NSNotification *)aNotification{
    [super keyboardWillBeHidden:aNotification];
    self.scrollViewBottomConstraint.constant = 0;
    [self.view layoutIfNeeded];
}

#pragma mark - InnerFunction
- (void)updateServiceShow{
    if ([self isMerchant]) {
        if (self.curPlan.isProvideCar) {
            [self setLabel:self.carSelectLabel selection:YES];
            [self setButton:self.carSelectBtn selection:YES];
        }else{
            [self setLabel:self.carSelectLabel selection:NO];
            [self setButton:self.carSelectBtn selection:NO];
        }
        if (self.curPlan.isProvideTourGuide) {
            [self setLabel:self.leadSelectLabel selection:YES];
            [self setButton:self.leadSelectBtn selection:YES];
        }else{
            [self setLabel:self.leadSelectLabel selection:NO];
            [self setButton:self.leadSelectBtn selection:NO];
        }
    }
}

- (void)setLabel:(UILabel *)label selection:(BOOL)selected{
    if (selected) {
        [label setTextColor:UIColorFromRGBA(0x706b66, 1)];
    }else{
        [label setTextColor:UIColorFromRGBA(0xa8a4a0, 1)];
    }
}
- (void)setButton:(UIButton *)button selection:(BOOL)selected{
    if (selected) {
        [button setImage:[UIImage imageNamed:@"ServiceSelected"] forState:UIControlStateNormal];
    }else{
        [button setImage:[UIImage imageNamed:@"ServiceUnSelected"] forState:UIControlStateNormal];
    }
}

- (BOOL)isMerchant{
    BOOL ret = NO;
    if ([LCDataManager sharedInstance].userInfo &&
        [[LCDataManager sharedInstance].userInfo isMerchant]) {
        ret = YES;
    }
    return ret;
}

- (NSArray *)getDestinationArrayByString:(NSString *)destinationStr{
    if ([LCStringUtil isNullString:destinationStr]) {
        return nil;
    }
    
    NSArray *splitStrArray = [destinationStr componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@",/; :，、；： "]];
    return splitStrArray;
}






- (void)setFirstStageStartTime:(NSString *)startTime{
    if (self.curPlan.stageArray.count < 1) {
        [self.curPlan.stageArray addObject:[[LCPartnerStageModel alloc] init]];
    }
    
    LCPartnerStageModel *stage = [self.curPlan.stageArray firstObject];
    stage.startTime = startTime;
}
- (void)setFirstStageEndTime:(NSString *)endTime{
    if (self.curPlan.stageArray.count < 1) {
        [self.curPlan.stageArray addObject:[[LCPartnerStageModel alloc] init]];
    }
    
    LCPartnerStageModel *stage = [self.curPlan.stageArray firstObject];
    stage.endTime = endTime;
}
- (NSString *)getFirstStageStartTime{
    NSString *ret = nil;
    if (self.curPlan.stageArray.count > 0) {
        LCPartnerStageModel *stage = [self.curPlan.stageArray firstObject];
        ret = stage.startTime;
    }
    return ret;
}
- (NSString *)getFirstStageEndTime{
    NSString *ret = nil;
    if (self.curPlan.stageArray.count > 0) {
        LCPartnerStageModel *stage = [self.curPlan.stageArray firstObject];
        ret = stage.endTime;
    }
    return ret;
}

@end
