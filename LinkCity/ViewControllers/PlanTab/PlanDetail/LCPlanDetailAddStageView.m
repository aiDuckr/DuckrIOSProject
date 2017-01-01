//
//  LCPlanDetailAddStageView.m
//  LinkCity
//
//  Created by Roy on 8/15/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCPlanDetailAddStageView.h"
#import "CalendarHomeViewController.h"


#define LCAnimationDuration (0.3)
@interface LCPlanDetailAddStageView()<CalendarHomeViewDelegate,UITextFieldDelegate>

@property (nonatomic, retain) CalendarHomeViewController *calendarController;

@property (nonatomic, assign) NSInteger curMaxMemberNum;
@property (nonatomic, strong) NSString *curStartTimeStr;
@property (nonatomic, strong) NSString *curEndTimeStr;
@property (nonatomic, strong) NSDecimalNumber *curPrice;
@end

@implementation LCPlanDetailAddStageView
+ (instancetype)createInstance{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([LCPlanDetailAddStageView class]) bundle:nil];
    
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    for (UIView *v in views) {
        if ([v isKindOfClass:[LCPlanDetailAddStageView class]]) {
            v.translatesAutoresizingMaskIntoConstraints = NO;
            return (LCPlanDetailAddStageView *)v;
        }
    }
    
    return nil;
}

- (void)dealloc{
    [self unregisterForKeyboardNotifications];
}

- (CGSize)intrinsicContentSize{
    return CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT);
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    /*
     初次显示时，根据已有数据显示后，
     sliderBar的位置、上方Label位置不对，需要调整
     */
    [self memberNumChangeAction];
}

- (void)awakeFromNib{
    [self registerForKeyboardNotifications];
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
    [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)]];
    
    self.timeAndFeeView.layer.masksToBounds = YES;
    self.timeAndFeeView.layer.cornerRadius = 4;
    self.timeAndFeeView.layer.borderWidth = 1;
    self.timeAndFeeView.layer.borderColor = UIColorFromR_G_B_A(232, 228, 221, 1).CGColor;
    
    self.priceTextField.delegate = self;
    
    [self.memberNumSlider addTarget:self action:@selector(memberNumChangeAction) forControlEvents:UIControlEventValueChanged];
    self.memberNumSlider.minimumValue = 1;
    if ([LCDataManager sharedInstance].userInfo) {
        self.memberNumSlider.maximumValue = [[LCDataManager sharedInstance].userInfo getMaxPlanMember]-1;
    }else{
        self.memberNumSlider.maximumValue = MaxPlanScaleOfUsualUser-1;
    }
    
    [[LCUIConstants sharedInstance] setButtonAsSubmitButtonEnableStyle:self.submitButton];
    
    [self updateShow];
}

- (void)showAsAddStageForPlan:(LCPlanModel *)plan{
    self.plan = plan;
    self.showingType = LCAddStageViewShowingType_Add;
    self.deleteButton.hidden = YES;
    [self.submitButton setTitle:@"发布" forState:UIControlStateNormal];
    
    self.curStartTimeStr = nil;
    self.curEndTimeStr = nil;
    self.curPrice = nil;
    self.curMaxMemberNum = self.memberNumSlider.maximumValue;
    
    self.timeAndPriceMaskView.hidden = YES;
    
    [self updateShow];
}

- (void)showAsEditStageForStage:(LCPartnerStageModel *)stage plan:(LCPlanModel *)plan{
    self.plan = plan;
    self.stage = stage;
    self.showingType = LCAddStageViewShowingType_Update;
    self.deleteButton.hidden = NO;
    [self.submitButton setTitle:@"保存" forState:UIControlStateNormal];
    
    self.curStartTimeStr = self.stage.startTime;
    self.curEndTimeStr = self.stage.endTime;
    self.curPrice = self.stage.price;
    self.curMaxMemberNum = self.stage.totalNumber;
    
    self.timeAndPriceMaskView.hidden = YES;
    
    [self updateShow];
}

- (void)showAsEditScaleForStage:(LCPartnerStageModel *)stage plan:(LCPlanModel *)plan{
    self.plan = plan;
    self.stage = stage;
    self.showingType = LCAddStageViewShowingType_Update;
    self.deleteButton.hidden = YES;
    [self.submitButton setTitle:@"保存" forState:UIControlStateNormal];
    
    self.curStartTimeStr = self.stage.startTime;
    self.curEndTimeStr = self.stage.endTime;
    self.curPrice = self.stage.price;
    self.curMaxMemberNum = self.stage.totalNumber;
    
    self.timeAndPriceMaskView.hidden = NO;
    
    [self updateShow];
}

- (void)updateShow{
    NSInteger stageIndex = [self.plan.stageArray indexOfObject:self.stage];
    if (stageIndex >= 0) {
        self.stageLabel.text = [NSString stringWithFormat:@"第%ld期",(stageIndex+1)];
    }
    
    if ([LCStringUtil isNullString:self.curStartTimeStr] ||
        [LCStringUtil isNullString:self.curEndTimeStr]) {
        self.timeTextField.text = @"";
    }else{
        self.timeTextField.text = [self getTimeStrFromStartTime:self.curStartTimeStr endTime:self.curEndTimeStr];
    }
    
    if ([LCDecimalUtil isOverZero:self.curPrice]) {
        self.priceTextField.text = [NSString stringWithFormat:@"%@",self.curPrice];
    }else{
        self.priceTextField.text = @"";
    }
    
    if (self.curMaxMemberNum > self.memberNumSlider.maximumValue) {
        self.curMaxMemberNum = self.memberNumSlider.maximumValue;
    }
    self.memberNumSlider.value = self.curMaxMemberNum;
    
    [self memberNumChangeAction];
}


#pragma mark - Button Action
- (void)memberNumChangeAction{
    float max = self.memberNumSlider.maximumValue;
    float min = self.memberNumSlider.minimumValue;
    float cur = self.memberNumSlider.value;
    float left = 0;
    left -= self.memberNumLabel.frame.size.width/2.0;
    left += (cur-min)/(max-min) * (self.memberNumSlider.frame.size.width-28);
    left += 14;
    
    self.memberNumLabelLeftSpace.constant = left;
    self.memberNumLabel.text = [NSString stringWithFormat:@"%d",(int)cur];
    [self.memberNumLabel layoutIfNeeded];
    
    self.curMaxMemberNum = (int)cur;
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    
    if (!self.priceTextField.isEditing) {
        CGPoint p = [tap locationInView:self.contentView];
        if (p.x >= 0 && p.y >= 0) {
            // tap in content view
        }else{
            // tap out of content view
            // should dismiss popup, means cancel edit
            if ([self.delegate respondsToSelector:@selector(addStageViewCanceled:)]) {
                [self.delegate addStageViewCanceled:self];
            }
        }
    }
    
    [self endEditing:YES];
}

- (void)panAction:(id)sender{
    [self endEditing:YES];
}

- (IBAction)deleteButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(addStageViewDidClickDeleteBtn:)]) {
        [self.delegate addStageViewDidClickDeleteBtn:self];
    }
}

- (IBAction)timeButtonAction:(id)sender {
    [self dismissPresentingPopup];
    
    if (!self.calendarController) {
        self.calendarController = [[CalendarHomeViewController alloc] init];
    }
    self.calendarController.delegate = self;
    [self.calendarController setHotelToDay:365 selectStartDateforString:self.curStartTimeStr selectEndDateforString:self.curEndTimeStr];
    [[LCSharedFuncUtil getTopMostViewController] presentViewController:self.calendarController animated:YES completion:nil];
}

- (IBAction)submitButtonAction:(id)sender {
    self.curMaxMemberNum = self.memberNumSlider.value;
    self.curPrice = [NSDecimalNumber decimalNumberWithString:self.priceTextField.text];
    
    BOOL isInputValid = YES;
    NSString *errMsg = @"";
    
    if ([LCStringUtil isNullString:self.curStartTimeStr] ||
        [LCStringUtil isNullString:self.curEndTimeStr]) {
        errMsg = [errMsg stringByAppendingString:@"邀约日期不能为空;"];
        isInputValid = NO;
    }
    
    if (![LCDecimalUtil isOverZero:self.curPrice]) {
        errMsg = [errMsg stringByAppendingString:@"多期的邀约价格不能为0;"];
        isInputValid = NO;
    }
    
    if (!isInputValid && [LCStringUtil isNotNullString:errMsg]) {
        [YSAlertUtil tipOneMessage:errMsg yoffset:TipAboveKeyboardYoffset delay:TipErrorDelay];
    }
    
    if (isInputValid) {
        [self endEditing:YES];
        
        NSString *planGuid = nil;
        BOOL isAddStage = NO;
        if (self.showingType == LCAddStageViewShowingType_Add) {
            planGuid = self.plan.planGuid;
            isAddStage = YES;
        }else if(self.showingType == LCAddStageViewShowingType_Update) {
            planGuid = self.stage.planGuid;
            isAddStage = NO;
        }
        
        [YSAlertUtil showHudWithHint:nil];
        [LCNetRequester planStageUpdate:planGuid
                                  price:self.curPrice
                                 maxNum:(self.curMaxMemberNum+1)
                              startTime:self.curStartTimeStr
                                endTime:self.curEndTimeStr
                                  isAdd:isAddStage
                               callBack:^(LCPlanModel *plan, NSError *error)
        {
            [YSAlertUtil hideHud];
            if (error) {
                [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipDefaultDelay];
            }else{
                if ([self.delegate respondsToSelector:@selector(addStageView:didAddOrUpdateStage:)]) {
                    [self.delegate addStageView:self didAddOrUpdateStage:plan];
                }
            }
        }];
    }
}



#pragma mark CalendarHomeView Delegate
/// 选择起止时间完成.
- (void)chooseDateFinished:(CalendarHomeViewController *)controller {
    self.curStartTimeStr = controller.startDateStr;
    self.curEndTimeStr = controller.endDateStr;
    [self updateShow];
    
    if ([self.delegate respondsToSelector:@selector(addStageView:didChooseStartDate:endDate:)]) {
        [self.delegate addStageView:self didChooseStartDate:controller.startDateStr endDate:controller.endDateStr];
    }
}

#pragma mark - UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    NSString *endStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    BOOL ret = YES;
    
    return ret;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    self.curPrice = [NSDecimalNumber decimalNumberWithString:textField.text];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self endEditing:YES];
    self.curPrice = [NSDecimalNumber decimalNumberWithString:textField.text];
    return YES;
}

#pragma mark KeyBoard
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
}
- (void)unregisterForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

//当输入框在scrollview最下时，键盘弹出后即使scrollview滚到底，输入框也显示不出
//为此每当显示键盘时，将scrollview上提
- (void)keyboardWillShow:(NSNotification *)aNotification{
    self.contentViewBottom.constant = 210;
    [UIView animateWithDuration:LCAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self layoutIfNeeded];
    } completion:nil];
}
- (void)keyboardWasShown:(NSNotification *)aNotification{
    
}
- (void)keyboardWillBeHidden:(NSNotification *)aNotification{
    self.contentViewBottom.constant = 0;
    [UIView animateWithDuration:LCAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self layoutIfNeeded];
    } completion:nil];
}

#pragma mark InnerFunc
- (NSString *)getTimeStrFromStartTime:(NSString *)startTimeStr endTime:(NSString *)endTimeStr{
    NSDate *startDate = [LCDateUtil dateFromString:startTimeStr];
    NSDate *endDate = [LCDateUtil dateFromString:endTimeStr];
    static NSDateFormatter *monthAndDayFormatter = nil;
    if (!monthAndDayFormatter) {
        monthAndDayFormatter = [[NSDateFormatter alloc] init];
        monthAndDayFormatter.dateFormat = @"MM.dd";
    }
    return [NSString stringWithFormat:@"%@-%@",[monthAndDayFormatter stringFromDate:startDate],[monthAndDayFormatter stringFromDate:endDate]];
}

@end
