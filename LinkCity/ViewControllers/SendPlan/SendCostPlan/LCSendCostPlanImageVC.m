//
//  LCSendCostPlanImageVC.m
//  LinkCity
//
//  Created by Roy on 12/16/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCSendCostPlanImageVC.h"
#import "LCSendPlanImageAndDescView.h"
#import "LCSendPlanFillUserInfoView.h"
#import "LCProvincePickerVC.h"
#import "LCDatePicker.h"
#import "LCSendCostPlanFinishVC.h"
#import "LCTimePickerView.h"
#import "KLCPopup.h"

@interface LCSendCostPlanImageVC ()<LCSendPlanImageAndDescViewDelegate, LCSendPlanFillUserInfoViewDelegate, LCProvincePickerDelegate, LCDatePickerDelegate, UITextFieldDelegate, LCTimePickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewTop;

@property (weak, nonatomic) IBOutlet UIView *imageAndDescViewHolder;
@property (nonatomic, strong) LCSendPlanImageAndDescView *imageAndDescView;

@property (weak, nonatomic) IBOutlet UITextField *gatherTimeTextField;
@property (weak, nonatomic) IBOutlet UITextField *gatherPlaceTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (nonatomic, strong) LCSendPlanFillUserInfoView *fillUserInfoView;
@property (nonatomic, strong) KLCPopup *fillUserInfoPopup;
@property (nonatomic, strong) LCDatePicker *datePickerView;

@property (nonatomic, strong) LCTimePickerView *timePickerView;
@property (nonatomic, strong) KLCPopup *timePickerPopup;

@end

@implementation LCSendCostPlanImageVC

+ (instancetype)createInstance{
    return (LCSendCostPlanImageVC *)[LCStoryboardManager viewControllerWithFileName:SBNameSendPlan identifier:NSStringFromClass([LCSendCostPlanImageVC class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    pan.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:pan];
    
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil]];
    UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
    self.navigationItem.rightBarButtonItem = cancelBarButton;
    
    self.imageAndDescView = [LCSendPlanImageAndDescView createInstance];
    UIView *holderV = self.imageAndDescViewHolder;
    UIView *imageV = self.imageAndDescView;
    
    [holderV addSubview:imageV];
    [holderV addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[imageV]-(0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(holderV, imageV)]];
    [holderV addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[imageV]-(0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(holderV, imageV)]];
    self.gatherPlaceTextField.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self updateShow];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)updateShow{
    [self.imageAndDescView updateShowWithPlan:self.curPlan];
    self.imageAndDescView.delegate = self;
    self.gatherTimeTextField.text = [LCDateUtil getHourAndMinuteStrfromStr:[LCStringUtil getNotNullStr:self.curPlan.gatherTime]];
    self.gatherPlaceTextField.text = [LCStringUtil getNotNullStr:self.curPlan.gatherPlace];
    
    [self updateSubmitBtnShow];
}


#pragma mark ButtonAction
- (void)tapAction:(id)sender{
    [self.view endEditing:YES];
}

- (void)panAction:(id)sender{
    [self.view endEditing:YES];
}

- (void)cancelAction:(id)sender{
    [MobClick event:Mob_PublishPlanB_Cancel];
    [self cancelSendPlan];
}

- (IBAction)gatherTimeBtnAction:(id)sender {
    if (!self.timePickerView) {
        self.timePickerView = [LCTimePickerView createInstance];
        self.timePickerView.delegate = self;
    }
    if (!self.timePickerPopup) {
        self.timePickerPopup = [KLCPopup popupWithContentView:self.timePickerView
                                                     showType:KLCPopupShowTypeSlideInFromBottom
                                                  dismissType:KLCPopupDismissTypeSlideOutToBottom
                                                     maskType:KLCPopupMaskTypeDimmed
                                     dismissOnBackgroundTouch:YES
                                        dismissOnContentTouch:NO];
        self.timePickerPopup.dimmedMaskAlpha = 0.5;
    }
    
    NSDate *date = [self getDateFromTimeStr:self.curPlan.gatherTime];
    if (date) {
        [self.timePickerView.timePicker setDate:date];
    }
    [self.timePickerPopup showWithLayout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutBottom)];
    
}


- (IBAction)submitBtnAction:(id)sender {
    [MobClick event:Mob_PublishPlanB_Publish];
    [self mergeUIDataIntoModel];
    
    //如果用户个人信息不全，弹出补全信息页
    //不继续发邀约
    if ([self showFillUserInfoView]) {
        return;
    }
    
    //如果正在上传照片，显示hud，不继续发邀约
    if (self.imageAndDescView.uploadingImageNum > 0) {
        [YSAlertUtil showHudWithHint:@"正在上传图片"];
        return;
    }
    
    //如果输入不合法，提示错误信息
    NSString *inputErrorMsg = [self checkInput];
    if ([LCStringUtil isNotNullString:inputErrorMsg]) {
        [YSAlertUtil tipOneMessage:inputErrorMsg yoffset:TipDefaultYoffset delay:TipErrorDelay];
        return;
    }
    
    //发邀约
    [YSAlertUtil showHudWithHint:nil];
    [LCNetRequester sendPlan:self.curPlan callBack:^(LCPlanModel *planSent, NSError *error) {
        LCLogInfo(@"Did send plan with Plan:%@  Error:%@",planSent,error);
        [YSAlertUtil hideHud];
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
        }else{
            if (self.isSendingPlan) {
                [LCDataManager sharedInstance].sendingPlan = nil;
                [YSAlertUtil tipOneMessage:@"发布邀约成功!" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
                
                LCSendCostPlanFinishVC *finishVC = [LCSendCostPlanFinishVC createInstance];
                finishVC.curPlan = planSent;
                finishVC.isSendingPlan = self.isSendingPlan;
                [self.navigationController pushViewController:finishVC animated:YES];
            }else{
                [LCDataManager sharedInstance].modifyingPlan = nil;
                [YSAlertUtil tipOneMessage:@"修改邀约成功!" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }];
}

#pragma mark UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.gatherPlaceTextField) {
        [self mergeUIDataIntoModel];
        NSString *endStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        self.curPlan.gatherPlace = endStr;
    }
    
    [self updateSubmitBtnShow];
    
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self mergeUIDataIntoModel];
    [self updateSubmitBtnShow];
}

#pragma mark LCTimePicker Delegate
- (void)timePickerViewDidClickCancel:(LCTimePickerView *)v{
    [self.timePickerPopup dismiss:YES];
}

- (void)timePickerViewDidClickConfirm:(LCTimePickerView *)v{
    [self.timePickerPopup dismiss:YES];
    
    self.curPlan.gatherTime = [self getTimeStrFromDate:self.timePickerView.timePicker.date];
    self.gatherTimeTextField.text = [LCStringUtil getNotNullStr:[LCStringUtil getNotNullStr:self.curPlan.gatherTime]];
}

#pragma mark ImageAndDescView Delegate
- (void)sendPlanImageAndDescViewDidEndInputDescription:(LCSendPlanImageAndDescView *)topView{
    [self mergeUIDataIntoModel];
    [self updateSubmitBtnShow];
}
- (void)sendPlanImageAndDescViewDidEndUploadImage:(LCSendPlanImageAndDescView *)topView{
    [self updateSubmitBtnShow];
    
    if ([YSAlertUtil isShowingHud]) {
        [YSAlertUtil hideHud];
        // 如果正在显示hud，说明用户已经点了下一步按钮；上传图片完成后，自动下一步
        [self submitBtnAction:nil];
    }
}
- (void)sendPlanImageAndDescViewDidUpdateImage:(LCSendPlanImageAndDescView *)topView{
    [self updateSubmitBtnShow];
}


#pragma mark Inner

- (void)updateSubmitBtnShow{
    
    if (self.isSendingPlan) {
        [self.submitBtn setTitle:@"发布" forState:UIControlStateNormal];
    }else{
        [self.submitBtn setTitle:@"保存修改" forState:UIControlStateNormal];
    }
    
    if ([LCStringUtil isNullString:[self checkInput]]) {
        [[LCUIConstants sharedInstance] setButtonAsSubmitButtonEnableStyle:self.submitBtn];
    }else{
        [[LCUIConstants sharedInstance] setButtonAsSubmitButtonDisableStyle:self.submitBtn];
    }
}

- (NSString *)checkInput{
    NSString *errorMsg = @"";
    
    //如果未选照片，toast，不继续发邀约
    if (!self.curPlan.imageUnits || self.curPlan.imageUnits.count<1){
        errorMsg = [errorMsg stringByAppendingString:@"至少上传一张生活照\r\n"];
    }
    
    if ([LCStringUtil isNullString:self.curPlan.gatherTime]) {
        errorMsg = [errorMsg stringByAppendingString:@"请填写集合时间\r\n"];
    }
    
    if ([LCStringUtil isNullString:self.curPlan.gatherPlace]) {
        errorMsg = [errorMsg stringByAppendingString:@"请填写集合地点\r\n"];
    }
    
    errorMsg = [LCStringUtil trimSpaceAndEnter:errorMsg];
    
    return errorMsg;
}

- (void)mergeUIDataIntoModel{
    // clear image urls
    self.curPlan.firstPhotoUrl = nil;
    self.curPlan.firstPhotoThumbUrl = nil;
    self.curPlan.secondPhotoUrl = nil;
    self.curPlan.secondPhotoThumbUrl = nil;
    self.curPlan.thirdPhotoUrl = nil;
    self.curPlan.thirdPhotoThumbUrl = nil;
    
    // set PlanModel's imageurl with ImageUnit's imageurl
    for (int i=0; i<self.curPlan.imageUnits.count; i++){
        LCImageUnit *unit = (LCImageUnit *)[self.curPlan.imageUnits objectAtIndex:i];
        if (i == 0) {
            self.curPlan.firstPhotoUrl = unit.url;
            self.curPlan.firstPhotoThumbUrl = unit.thumbUrl;
        }else if(i == 1){
            self.curPlan.secondPhotoUrl = unit.url;
            self.curPlan.secondPhotoThumbUrl = unit.thumbUrl;
        }else if(i == 2){
            self.curPlan.thirdPhotoUrl = unit.url;
            self.curPlan.thirdPhotoThumbUrl = unit.thumbUrl;
        }
    }
    
    self.curPlan.gatherPlace = [LCStringUtil trimSpaceAndEnter:self.gatherPlaceTextField.text];
}

#pragma mark - Fill User Info
- (BOOL)showFillUserInfoView{
    LCUserModel *user = [LCDataManager sharedInstance].userInfo;
    
    if (user &&
        [LCStringUtil isNotNullString:user.livingPlace] &&
        [LCStringUtil isNotNullString:user.birthday]) {
        
        return NO;
    }else{
        if (!self.fillUserInfoView) {
            self.fillUserInfoView = [LCSendPlanFillUserInfoView createInstance];
            self.fillUserInfoView.delegate = self;
            
            self.fillUserInfoPopup = [KLCPopup popupWithContentView:self.fillUserInfoView
                                                           showType:KLCPopupShowTypeBounceInFromTop
                                                        dismissType:KLCPopupDismissTypeBounceOutToBottom
                                                           maskType:KLCPopupMaskTypeDimmed
                                           dismissOnBackgroundTouch:NO
                                              dismissOnContentTouch:NO];
            self.fillUserInfoPopup.dimmedMaskAlpha = LCAlertViewMaskAlpha;
            
            self.fillUserInfoView.editingUser = [LCDataManager sharedInstance].userInfo;
        }
        
        
        [self.fillUserInfoPopup showAtCenter:CGPointMake(DEVICE_WIDTH/2, DEVICE_HEIGHT/2-30) inView:nil];
        
        return YES;
    }
}


- (void)sendPlanFillUserInfoViewPickBirthday:(LCSendPlanFillUserInfoView *)view{
    [self showBirthdayPicker];
}
- (void)sendPlanFillUserInfoViewPickLivingPlace:(LCSendPlanFillUserInfoView *)view{
    [self.fillUserInfoPopup dismissPresentingPopup];
    [self showProvincePicker];
}
- (void)sendPlanFillUserInfoView:(LCSendPlanFillUserInfoView *)view finishSucceed:(BOOL)succeed{
    [self.fillUserInfoPopup dismissPresentingPopup];
}

#pragma mark - BirthdayPicker
- (void)showBirthdayPicker{
    if (!self.datePickerView) {
        self.datePickerView = [LCDatePicker createInstance];
        self.datePickerView.delegate = self;
        //self.datePickerView.withWeekDayLabel = NO;
    }
    self.datePickerView.frame = self.view.bounds;
    self.datePickerView.backgroundColor = UIColorFromRGBA(0x000000, 0);
    CGRect f = self.datePickerView.datePickerContainerView.frame;
    f.origin.y += f.size.height;
    self.datePickerView.datePickerContainerView.frame = f;
    [self.fillUserInfoPopup addSubview:self.datePickerView];
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
    self.fillUserInfoView.birthdayTextField.text = [LCDateUtil stringFromDate:d];
}

#pragma mark ProvincePicker
- (void)showProvincePicker{
    LCProvincePickerVC *provincePicker = [LCProvincePickerVC createInstance];
    provincePicker.delegate = self;
    [[LCSharedFuncUtil getTopMostNavigationController] pushViewController:provincePicker animated:YES];
}
- (void)provincePicker:(LCProvincePickerVC *)provincePickerVC didSelectProvince:(NSString *)provinceName didSelectCity:(LCCityModel *)city {
    if (self.fillUserInfoView && nil != city) {
        self.fillUserInfoView.livingPlaceTextField.text = [NSString stringWithFormat:@"%@%@%@", provinceName, LOCATION_CITY_SEPARATER, city.cityName];
    }
    
    [self showFillUserInfoView];
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
            self.scrollViewTop.constant = 120 - r.origin.y;
        }
        [self.view layoutIfNeeded];
    }
}

- (void)keyboardWillBeHidden:(NSNotification *)aNotification{
    [super keyboardWillBeHidden:aNotification];
    self.scrollViewTop.constant = 0;
    [self.view layoutIfNeeded];
}

#pragma mark Time And Date
- (NSDate *)getDateFromTimeStr:(NSString *)timeStr{
    if ([LCStringUtil isNullString:timeStr]) {
        return nil;
    }
    
    NSMutableString *dateStr = [NSMutableString stringWithFormat:@"2015-01-01 %@",timeStr];
    [dateStr replaceCharactersInRange:NSMakeRange(timeStr.length-2, 2) withString:@"00"];
    
    NSDateFormatter *fm = [[NSDateFormatter alloc] init];
    fm.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [fm dateFromString:dateStr];
}

- (NSString *)getTimeStrFromDate:(NSDate *)date{
    if (!date) {
        return nil;
    }
    
    NSDateFormatter *fm = [[NSDateFormatter alloc] init];
    fm.dateFormat = @"HH:mm:ss";
    
    NSMutableString *timeStr = [NSMutableString stringWithString:[fm stringFromDate:date]];
    [timeStr replaceCharactersInRange:NSMakeRange(timeStr.length-2, 2) withString:@"00"];
    return timeStr;
}

@end
