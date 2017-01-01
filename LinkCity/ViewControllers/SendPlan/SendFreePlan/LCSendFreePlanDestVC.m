//
//  LCSendFreePlanDestVC.m
//  LinkCity
//
//  Created by Roy on 12/12/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCSendFreePlanDestVC.h"
//#import "CalendarHomeViewController.h"
#import "LCDateUtil.h"
#import "LCAreaPickHelper.h"
#import "UIView+BlocksKit.h"
#import "LCDatePicker.h"
#import "LCSendPlanDetailVC.h"
#import "LCPlanModel.h"
#import "UIButton+BackgroundColor.h"
//CalendarHomeViewDelegate,
@interface LCSendFreePlanDestVC ()<UITextFieldDelegate,LCDatePickerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *departTextField;
@property (weak, nonatomic) IBOutlet UITextField *destTextField;

@property (weak, nonatomic) IBOutlet UIView *calendarTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *urbanPlanDepartPlaceBtn;
@property (weak, nonatomic) IBOutlet UIView *destCell;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarTitleCellTop;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastDayLabel;

@property (assign ,nonatomic) NSInteger lastDayCount;

//@property (weak, nonatomic) IBOutlet UIView *calendarView;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *minusButton;
@property (weak, nonatomic) IBOutlet UIButton *plusButton;
@property (strong, nonatomic) LCDatePicker * datePickerView;


//@property (nonatomic, strong) LCAreaPickHelper *areaPickHelper;

@property (nonatomic, strong) NSDateFormatter * formatter;

@end

@implementation LCSendFreePlanDestVC


+ (instancetype)createInstance{
    return (LCSendFreePlanDestVC *)[LCStoryboardManager viewControllerWithFileName:SBNameSendPlan identifier:NSStringFromClass([LCSendFreePlanDestVC class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
    self.navigationItem.rightBarButtonItem = cancelBarButton;
    [self.nextBtn setBackgroundColor:UIColorFromRGBA(0xd9d5d1, 1.0) forState:UIControlStateDisabled cornerRadius:3];
   // [self.nextBtn setBackgroundColor:UIColorFromRGBA(0xd9d5d1, 1.0) forState:UIControlStateDisabled cornerRadius:3];
    self.departTextField.delegate = self;
    self.destTextField.delegate = self;
    _lastDayCount = 1;
    self.minusButton.enabled = NO;
   
    self.lastDayLabel.text = [NSString stringWithFormat:@"%ld天",(long)self.lastDayCount];
    //_datePicker = [[LCDatePicker alloc] init];
    __weak typeof(self) weakSelf = self;
    [self.calendarTitleLabel bk_whenTapped:^{
        [weakSelf.view endEditing:YES];
        [weakSelf showStartDatePicker];
       // NSLog(@"datePicker");
    }];
    //self.calendarView.layer.masksToBounds = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapAction:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
    [self.plusButton addTarget:self action:@selector(plusLastDayAction) forControlEvents:UIControlEventTouchUpInside];
    [self.minusButton addTarget:self action:@selector(minusLastDayAction) forControlEvents:UIControlEventTouchUpInside];
    self.curPlan.routeType = LCRouteTypeFreePlanCommon;

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:NO];
    [self.tabBarController.tabBar setHidden:YES];
    
    [self updateShow];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}
- (void)updateShow{
    if (![LCDataManager sharedInstance].userInfo) {
        // have not login
    }else{
        //出发地
        self.departTextField.text = [LCStringUtil getNotNullStr:self.curPlan.departName];
        self.destTextField.text = [self.curPlan getDestinationsStringWithSeparator:DestinationSeparator];
        [self updateNextBtnShow];
        
        
        if ([self.curPlan isCostCarryPlan] ||
            [self.curPlan isFreeCarryPlan]) {
            self.destTextField.placeholder = @"输入途经地、目的地，用空格隔开";
        }else{
            self.destTextField.placeholder = @"目的地(多个目的地用空格隔开)";
        }
        //NSDate *d = [datePicker.datePicker date];
        if (self.curPlan.startTime == nil) {

            //ABA7A2
            _formatter = [[NSDateFormatter alloc] init];
            self.formatter.dateFormat = @"yyyy-MM-dd";
            self.formatter.locale = [NSLocale currentLocale];
            self.curPlan.startTime = [self.formatter stringFromDate:[NSDate date]];
            self.dateLabel.textColor = UIColorFromRGBA(0xABA7A2, 1.0);
        } else {
            self.dateLabel.textColor = UIColorFromRGBA(0x2C2A28, 1.0);
        }
        self.dateLabel.text =self.curPlan.startTime; //[LCDateUtil stringFromDate:d];
        self.lastDayCount = self.curPlan.daysLong;
        self.lastDayLabel.text = [NSString stringWithFormat:@"%ld天",(long)self.lastDayCount];

//        if ([self.curPlan isUrbanPlan]) {
//            self.destCell.hidden = YES;
////            self.calendarTitleCellTop.constant = 10;
//            self.urbanPlanDepartPlaceBtn.hidden = NO;
//        }else{
//            self.destCell.hidden = NO;
//           // self.calendarTitleCellTop.constant = 55;
//            self.urbanPlanDepartPlaceBtn.hidden = YES;
//        }
    }
}

#pragma mark ButtonAction
- (void)cancelAction:(id)sender{
    [MobClick event:Mob_PublishPlanA_Cancel];
    [self mergeUIDataIntoModel];
    [self cancelSendPlan];
}

//- (IBAction)urbanPlanDepartBtnAction:(id)sender {
//    if (!self.areaPickHelper) {
//        self.areaPickHelper = [LCAreaPickHelper instanceWithNavVC:self.navigationController];
//    }
//    
//    NSString *cityName = nil;
//    NSString *areaName = nil;
//    if ([LCStringUtil isNotNullString:self.curPlan.departName]) {
//        NSArray *strArr = [self.curPlan.departName componentsSeparatedByString:@"-"];
//        if (strArr.count >= 1) {
//            cityName = strArr[0];
//        }
//        if (strArr.count >= 2) {
//            areaName = strArr[1];
//        }
//    }
//    [self.areaPickHelper startAreaPickWithCityName:cityName areaName:areaName callBack:^(NSString *cityAreaName) {
//        self.curPlan.departName = cityAreaName;
//        //self.curPlan.destinationNames = @[cityAreaName];
//        [self updateShow];
//    }];
//}


- (IBAction)nextBtnAction:(id)sender {
    [MobClick event:Mob_PublishPlanA_Next];
    [self mergeUIDataIntoModel];
    
    NSString *inputErrorMsg = [self checkInput];
    if ([LCStringUtil isNullString:inputErrorMsg]) {
        //input correct
        LCSendPlanDetailVC *vc = [LCSendPlanDetailVC createInstance];
        vc.isInSameCity = NO;
        vc.curPlan = self.curPlan;
//        if ([[LCDataManager sharedInstance] userLocation]) {
//            vc.curPlan.location = userLocation;
//        }
        vc.isSendingPlan = self.isSendingPlan;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        [YSAlertUtil tipOneMessage:inputErrorMsg yoffset:TipDefaultYoffset delay:TipErrorDelay];
    }
}

- (void)updateNextBtnShow{
    if ([LCStringUtil isNullString:[self checkInput]]) {
        //input correct
        self.nextBtn.enabled = YES;
       // [[LCUIConstants sharedInstance] setButtonAsSubmitButtonEnableStyle:self.nextBtn];
    }else{
        self.nextBtn.enabled = NO;
        
        //input error
       // [[LCUIConstants sharedInstance] setButtonAsSubmitButtonDisableStyle:self.nextBtn];
    }
}

#pragma mark - UITextView Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.destTextField &&
        range.location == textField.text.length &&
        [string isEqualToString:@" "]) {
        // ignore replacement string and add your own
        textField.text = [textField.text stringByAppendingString:LCRightAlignSpace];
        return NO;
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self updateNextBtnShow];
}



#pragma mark CalendarHomeViewControllerDelegate
- (void)viewTapAction:(id)sender{
    LCLogInfo(@"calendarViewTap");
    [self.view endEditing:YES];
}
- (void)calendarPanAction:(id)sender{
    [self.view endEditing:YES];
}


#pragma mark - BirthDay
- (void)showStartDatePicker{
    if (!self.datePickerView) {
        _datePickerView = [LCDatePicker createInstance];
        self.datePickerView.delegate = self;
        //self.datePickerView.withWeekDayLabel = YES;
    }
    self.datePickerView.frame = self.view.bounds;
    self.datePickerView.datePicker.minimumDate = [NSDate date];
    self.datePickerView.datePicker.maximumDate = nil;
    self.datePickerView.backgroundColor = UIColorFromRGBA(0x000000, 0);
    CGRect f = self.datePickerView.datePickerContainerView.frame;
    f.origin.y += f.size.height;
    self.datePickerView.datePickerContainerView.frame = f;
    [self.view addSubview:self.datePickerView];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^(){
        self.datePickerView.backgroundColor = UIColorFromRGBA(0x000000, 0.3);
        CGRect f = self.datePickerView.datePickerContainerView.frame;
        f.origin.y -= f.size.height;
        self.datePickerView.datePickerContainerView.frame = f;
    } completion:nil];
}
- (void)dismissBirthdayPicker{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^(){
        self.datePickerView.backgroundColor = UIColorFromRGBA(0x000000, 0);
        CGRect f = self.datePickerView.datePickerContainerView.frame;
        f.origin.y += f.size.height;
        self.datePickerView.datePickerContainerView.frame = f;
    } completion:^(BOOL finished){
        [self.datePickerView removeFromSuperview];
    }];
}
- (void)datePickerDidTap:(LCDatePicker *)datePicker{
    [self dismissBirthdayPicker];
}
- (void)datePickerDidCancel:(LCDatePicker *)datePicker{
    [self dismissBirthdayPicker];
}
- (void)datePickerDidConfirm:(LCDatePicker *)datePicker{
    [self dismissBirthdayPicker];
    NSDate *d = [datePicker.datePicker date];
    self.dateLabel.text = [LCDateUtil stringFromDate:d];
    self.dateLabel.textColor = UIColorFromRGBA(0x2C2A28, 1.0);
    //self.editingUser.birthday = [LCDateUtil stringFromDate:d];
    //self.birthLabel.text = self.editingUser.birthday;
}

//- (void)calendarHomeVCDidSelectOneDate:(CalendarHomeViewController *)controller{
//    NSString *startStr = [controller.Logic.startCalendarDay toString];
//    NSString *endStr = [controller.Logic.endCalendarDay toString];
//    LCLogInfo(@"Date: %@ - %@",startStr,endStr);
//    
//    
//    [self.curPlan setFirstStageStartTime:startStr];
//    [self.curPlan setFirstStageEndTime:endStr];
//    
//    [self updateNextBtnShow];
//}

//- (void)chooseDateFinished:(CalendarHomeViewController *)controller{
//    
//}






#pragma mark 
- (NSString *)checkInput{
    NSString *errorMsg = @"";
    
    if ([LCStringUtil isNullString:[LCStringUtil trimSpaceAndEnter:self.departTextField.text]]) {
        errorMsg = [errorMsg stringByAppendingString:@"请填写出发地\r\n"];
    }
    
    if ([LCStringUtil isNullString:[LCStringUtil trimSpaceAndEnter:self.destTextField.text]]) {
        errorMsg = [errorMsg stringByAppendingString:@"请填写目的地\r\n"];
    }
    if ([LCStringUtil isNullString:[LCStringUtil trimSpaceAndEnter:self.dateLabel.text]]) {
        errorMsg = [errorMsg stringByAppendingString:@"请填写出发日期\r\n"];
    }
//    if ([LCStringUtil isNullString:[self.curPlan getFirstStageEndTime]] ||
//        [LCStringUtil isNullString:[self.curPlan getFirstStageStartTime]]) {
//        errorMsg = [errorMsg stringByAppendingString:@"请选择起止日期\r\n"];
//    }
//    
    //如果最后多回车符，去掉
    errorMsg = [LCStringUtil trimSpaceAndEnter:errorMsg];
    
    LCLogInfo(@"checkInput :%@",errorMsg);
    return errorMsg;
}

- (void)mergeUIDataIntoModel{
    self.curPlan.departName = self.departTextField.text;
    self.curPlan.destinationNames = [LCPlanModel getDestinationArrayByString:self.destTextField.text];
    self.curPlan.startTime = self.dateLabel.text;
    self.curPlan.daysLong = self.lastDayCount;

//    if ([self.curPlan isUrbanPlan]) {
//        self.curPlan.destinationNames = @[self.curPlan.departName];
//    }else{
//        
//    }
    
//    NSString *startStr = [self.calendarHomeViewController.Logic.startCalendarDay toString];
//    NSString *endStr = [self.calendarHomeViewController.Logic.endCalendarDay toString];
//    [self.curPlan setFirstStageStartTime:startStr];
//    [self.curPlan setFirstStageEndTime:endStr];
}

#pragma mark - Action
- (void)plusLastDayAction {
    if (self.lastDayCount < 99) {
        self.lastDayCount += 1;
        self.lastDayLabel.text = [NSString stringWithFormat:@"%ld天",(long)self.lastDayCount];
        self.minusButton.enabled = YES;
    }
    if (self.lastDayCount == 99) {
        self.plusButton.enabled = NO;
    }
}

- (void)minusLastDayAction {
    if (self.lastDayCount > 1) {
        self.lastDayCount -= 1;
        self.lastDayLabel.text = [NSString stringWithFormat:@"%ld天",(long)self.lastDayCount];
        self.plusButton.enabled = YES;
        
    }
    if (self.lastDayCount == 1) {
        self.minusButton.enabled = NO;
    }
}

@end
