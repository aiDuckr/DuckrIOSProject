//
//  LCSendPlanDetailVC.m
//  LinkCity
//
//  Created by lhr on 16/4/16.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCSendPlanDetailVC.h"
#import "LCSendFreePlanDescCell.h"
#import "LCSendFreePlanImageAndDescCell.h"
#import "LCSendPlanDetailTagCell.h"
#import "LCSendPlanAllowOtherGenderCell.h"
#import "LCSendFreePlanDestAndTimeCell.h"
#import "LCSendFreePlanFinishVC.h"
#import "LCProvincePickerVC.h"
#import "LCSendPlanFillUserInfoView.h"
#import "LCDatePicker.h"
#import "UIButton+BackgroundColor.h"
#import "UIView+BlocksKit.h"


@interface LCSendPlanDetailVC ()<UITableViewDelegate,UITableViewDataSource,LCSendPlanAllowOtherGenderCellDelegate,LCSendFreePlanImageAndDescCellDelegate,LCSendPlanFillUserInfoViewDelegate,LCProvincePickerDelegate,LCDatePickerDelegate,UITextViewDelegate, LCSendFreePlanDetailTagCellDeleagte,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *releaseButton;

@property (nonatomic, strong) LCSendPlanFillUserInfoView *fillUserInfoView;
@property (nonatomic, strong) KLCPopup *fillUserInfoPopup;

@property (nonatomic, strong) LCSendFreePlanImageAndDescCell *imageCell;

@property (nonatomic, strong) LCSendFreePlanDescCell * descCell;

@property (nonatomic, strong) LCSendPlanAllowOtherGenderCell *genderCell;

@property (nonatomic, strong) LCSendPlanDetailTagCell * tagCell;

@property (nonatomic, strong) LCSendFreePlanDestAndTimeCell * destAndTimeCell;

@property (nonatomic, strong) LCDatePicker *datePickerView;

@property (nonatomic, strong) LCDatePicker *startTimePickerView;

//@property (nonatomic, strong)
//@property (strong, nonatomic) NSMutableArray * cellArray;
@end

@implementation LCSendPlanDetailVC

+ (instancetype)createInstance {
    return (LCSendPlanDetailVC *)[LCStoryboardManager viewControllerWithFileName:SBNameSendPlan identifier:NSStringFromClass([LCSendPlanDetailVC class])];
    //    //LCSendPlanInSameCityVC
    //        return [[LCSendPlanInSameCityVC alloc] initWithNibName:NSStringFromClass([LCSendPlanInSameCityVC class]) bundle:nil];
}

- (void)bindWithData {
    //
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isInSameCity) {
        self.title = @"同城邀约";
    } else {
        self.title = @"旅行邀约";
    }
    if (!self.curPlan.photoUrls) {
        NSMutableArray * urlArray = [NSMutableArray arrayWithCapacity:0];
        if ([LCStringUtil isNotNullString: self.curPlan.firstPhotoUrl]) {
            [urlArray addObject:self.curPlan.firstPhotoUrl];
        }
        if ([LCStringUtil isNotNullString:self.curPlan.secondPhotoUrl]) {
            [urlArray addObject:self.curPlan.secondPhotoUrl];
        }
        if ([LCStringUtil isNotNullString:self.curPlan.thirdPhotoUrl]) {
            [urlArray addObject:self.curPlan.thirdPhotoUrl];
        }
        self.curPlan.photoUrls = urlArray;
        self.curPlan.imageUnits = nil;
    }
    [self initTableView];
    UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
    self.navigationItem.rightBarButtonItem = cancelBarButton;

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapAction:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
    [self.releaseButton setBackgroundColor:UIColorFromRGBA(0xd9d5d1, 1.0) forState:UIControlStateDisabled cornerRadius:3];
    [self.releaseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    self.releaseButton.enabled = NO;
    [self.releaseButton addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    
    //[self initCellArray];
    // Do any additional setup after loading the view.
}

- (void)dealloc {
    
}
- (void)initTableView {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight =  UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 160;
    self.tableView.allowsSelection = NO;
//    [self.tableView registerNib:<#(nullable UINib *)#> forCellReuseIdentifier:<#(nonnull NSString *)#>]
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCSendFreePlanDescCell class]) bundle:nil]  forCellReuseIdentifier:NSStringFromClass([LCSendFreePlanDescCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCSendFreePlanImageAndDescCell class]) bundle:nil]  forCellReuseIdentifier:NSStringFromClass([LCSendFreePlanImageAndDescCell class])];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCSendPlanDetailTagCell class]) bundle:nil]  forCellReuseIdentifier:NSStringFromClass([LCSendPlanDetailTagCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCSendPlanAllowOtherGenderCell class]) bundle:nil]  forCellReuseIdentifier:NSStringFromClass([LCSendPlanAllowOtherGenderCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCSendFreePlanDestAndTimeCell class]) bundle:nil]  forCellReuseIdentifier:NSStringFromClass([LCSendFreePlanDestAndTimeCell class])];
 

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.isInSameCity && section == 0)
        return 2;
    else if (self.isInSameCity && section == 1)
        return 2;
    else
        return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!self.isInSameCity)
        return 3;
    else
        return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell;
    NSInteger sectionIndex = indexPath.section;
    if (!self.isInSameCity) {
        sectionIndex += 1;
    }
    switch (sectionIndex) {
        case 0:
            //cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCSendFreePlanDestAndTimeCell class])];
            self.destAndTimeCell =(LCSendFreePlanDestAndTimeCell *) cell;
            [self.destAndTimeCell updateShowWithPlan:self.curPlan];
            [self addTimeBlock];
                                                 
                                                 
            break;
        case 1:
            if (indexPath.row == 0) {
                cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCSendFreePlanDescCell class])]; //[LCSendFreePlanDescCell createInstance];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                self.descCell = (LCSendFreePlanDescCell *)cell;
                [self.descCell updateShowWithPlan:self.curPlan];
            } else {
                cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCSendPlanDetailTagCell class])];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                self.tagCell = (LCSendPlanDetailTagCell *)cell;
                self.tagCell.delegate = self;
                self.tagCell.isInTheSameCity = self.isInSameCity;
                [self.tagCell updateShowWithPlan:self.curPlan];
                //self.tagCell.delegate = self;
            }
            break;
        case 2:
            // cell = [LCSendFreePlanImageAndDescCell createInstance];
            cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCSendFreePlanImageAndDescCell class])];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            self.imageCell = (LCSendFreePlanImageAndDescCell *)cell;
            [self.imageCell updateShowWithPlan:self.curPlan];
            self.imageCell.delegate = self;
            
            break;
        case 3:
           cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCSendPlanAllowOtherGenderCell class])];
            LCSendPlanAllowOtherGenderCell *genderCell = (LCSendPlanAllowOtherGenderCell *)cell;
            genderCell.delegate = self;
            genderCell.selectionStyle = UITableViewCellSelectionStyleNone;
            self.genderCell = genderCell;
            [self.genderCell updateShowWithPlan:self.curPlan];
            return genderCell;
            break;
        
    }

        return cell;
}
- (void)addTimeBlock {
        __weak typeof(self) weakSelf = self;
        [self.destAndTimeCell.timeView bk_whenTapped:^{
            [weakSelf showStartDatePicker];
            [weakSelf.view endEditing:YES];
        }];
    }
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 12.0f;
}

#pragma mark CalendarHomeViewControllerDelegate
- (void)viewTapAction:(id)sender{
    LCLogInfo(@"calendarViewTap");
    [self.view endEditing:YES];
    [self updateSubmitBtnShow];
}

- (void)cancelAction:(id)sender{
    [MobClick event:Mob_PublishPlanA_Cancel];
    //[self mergeUIDataIntoModel];
    [self cancelSendPlan];
}
#pragma mark -Cell Delegate
- (void)didStateChanged:(LCGenderLimit)genderLimit {
   
    BOOL willDown = NO;
    if (self.curPlan.genderLimit ==  LCGenderLimitNone && genderLimit != LCGenderLimitNone) {
        willDown = YES;
    }
        
        
    self.curPlan.genderLimit =genderLimit;
    [self.tableView reloadData];
    if (willDown == YES) {
        [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffset.x, self.tableView.contentOffset.y + 90) animated:YES];
    }
//    .contentOffset.x = self.tableView.contentOffset.x + 60;
//    reloadSections
//    CGPoint offset = self.tableView.contentOffset;
    
////    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:()];
//
//    
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:(self.tableView.numberOfSections - 1)] withRowAnimation:UITableViewRowAnimationNone];
//    [self.tableView setContentOffset:offset];
}

#pragma mark ImageAndDescCell
- (void)sendFreePlanImageAndDescCellDidUpdateImage:(LCSendFreePlanImageAndDescCell *)topCell{
    [self updateSubmitBtnShow];
}

- (void)sendFreePlanImageAndDescCellDidEndUploadImage:(LCSendFreePlanImageAndDescCell *)topCell{
    [self updateSubmitBtnShow];
    
    if ([YSAlertUtil isShowingHud]) {
        [YSAlertUtil hideHud];
        // 如果正在显示hud，说明用户已经点了下一步按钮；上传图片完成后，自动下一步
        [self submitAction];
    }
}

- (void)sendFreePlanImageAndDescCellDidEndInputDescription:(LCSendFreePlanImageAndDescCell *)topCell{
    [self updateSubmitBtnShow];
}

- (void)updateSubmitBtnShow{
    
//    if (!self.isSendingPlan) {
//        [self.releaseButton setTitle:@"发布" forState:UIControlStateNormal];
//        //self.releaseButton
//    }else{
//        [self.releaseButton setTitle:@"保存修改" forState:UIControlStateNormal];
//    }
    NSLog(@"error:%@\n",[self checkInput]);
    if ([LCStringUtil isNullString:[self checkInput]]) {
        self.releaseButton.enabled = YES;
    }else{
        self.releaseButton.enabled = NO;
    }
}

- (NSString *)checkInput{
    [self mergeUIDataIntoModel];
    
    NSString *errorMsg = @"";
    
//    if ([self.curPlan isCostCarryPlan]) {
//        NSDecimalNumber *price = [NSDecimalNumber zero];
//        if (self.curPlan.stageArray.count > 0) {
//            LCPartnerStageModel *stage = [self.curPlan.stageArray firstObject];
//            price = stage.price;
//        }
//        
//        if (![LCDecimalUtil isOverZero:price]) {
//            errorMsg = [errorMsg stringByAppendingString:@"请输入每人需要承担的费用\r\n"];
//        }
//    }
    
    //如果未选照片，toast，不继续发邀约
    if (!self.curPlan.imageUnits || self.curPlan.imageUnits.count<1){
        errorMsg = [errorMsg stringByAppendingString:@"至少上传一张生活照\r\n"];
    }
    if (!self.isInSameCity && (!self.curPlan.departName || self.curPlan.departName.length < 1)) {
         errorMsg = [errorMsg stringByAppendingString:@"出发地不能为空\r\n"];
    }
    if (!self.curPlan.destinationNames || [self.curPlan.destinationNames count] < 1) {
         errorMsg = [errorMsg stringByAppendingString:@"目的地不能为空\r\n"];
    }
    if (!self.curPlan.descriptionStr || self.curPlan.descriptionStr.length < 1) {
        errorMsg = [errorMsg stringByAppendingString:@"描述不能为空\r\n"];
    }
    
    
    errorMsg = [LCStringUtil trimSpaceAndEnter:errorMsg];
    
    return errorMsg;
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
- (void)submitAction {
    [MobClick event:Mob_PublishPlanB_Publish];
    [self mergeUIDataIntoModel];
    
    //如果用户个人信息不全，弹出补全信息页
    //不继续发邀约
    if ([self showFillUserInfoView]) {
        return;
    }
    
    //如果正在上传照片，显示hud，不继续发邀约
    if (self.imageCell.uploadingImageNum > 0) {
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
                self.curPlan = nil;
                LCSendFreePlanFinishVC *finishVC = [LCSendFreePlanFinishVC createInstance];
                finishVC.plan = planSent;
                
                //[self presentViewController:finishVC animated:YES completion:^{}];
                [self.navigationController pushViewController:finishVC animated:YES];
                //[self presentationController]
            }else{
                [LCDataManager sharedInstance].modifyingPlan = nil;
                [YSAlertUtil tipOneMessage:@"修改邀约成功!" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
                
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }];

}

#pragma mark 

- (void)mergeUIDataIntoModel {
    if (self.isInSameCity) {
        self.curPlan.startTime = self.destAndTimeCell.timeField.text;
        self.curPlan.destinationNames = @[self.destAndTimeCell.destField.text];
        self.curPlan.routeType = LCRouteTypeFreePlanSameCity;
    } else {
        self.curPlan.routeType = LCRouteTypeFreePlanCommon;
    }
    self.curPlan.descriptionStr = self.descCell.descTextView.text;
    //self.curPlan.photoUrls
    //self.curPlan.destinationNames =
    self.curPlan.genderLimit = self.genderCell.genderLimit;
    // set PlanModel's imageurl with ImageUnit's imageurl
    NSMutableArray *urlArray = [NSMutableArray arrayWithCapacity:0];
    for (int i=0; i<self.curPlan.imageUnits.count; i++){
        LCImageUnit *unit = (LCImageUnit *)[self.curPlan.imageUnits objectAtIndex:i];
        if (unit.url) {
            [urlArray addObject:unit.url];
        }
//        if (i == 0) {
//            self.curPlan.firstPhotoUrl = unit.url;
//            self.curPlan.firstPhotoThumbUrl = unit.thumbUrl;
//        }else if(i == 1){
//            self.curPlan.secondPhotoUrl = unit.url;
//            self.curPlan.secondPhotoThumbUrl = unit.thumbUrl;
//        }else if(i == 2){
//            self.curPlan.thirdPhotoUrl = unit.url;
//            self.curPlan.thirdPhotoThumbUrl = unit.thumbUrl;
//        }
    }
    self.curPlan.photoUrls = urlArray;
    self.curPlan.tagsArray = self.tagCell.selectedItemArrStr;
}


#pragma mark ProvincePicker
- (void)showProvincePicker{
    LCProvincePickerVC *provincePicker = [LCProvincePickerVC createInstance];
    provincePicker.delegate = self;
    [[LCSharedFuncUtil getTopMostNavigationController] pushViewController:provincePicker animated:YES];
}
- (void)provincePicker:(LCProvincePickerVC *)provincePickerVC didSelectProvince:(NSString *)provinceName didSelectCity:(LCCityModel *)city {
    if (self.fillUserInfoView) {
        self.fillUserInfoView.livingPlaceTextField.text = [NSString stringWithFormat:@"%@%@%@", provinceName, LOCATION_CITY_SEPARATER, city.cityName];
    }
    
    [self showFillUserInfoView];
}

#pragma mark - BirthdayPicker
#pragma mark - BirthDay
- (void)showStartDatePicker{
    if (!self.datePickerView) {
        _startTimePickerView = [LCDatePicker createInstance];
        self.startTimePickerView.delegate = self;
        //self.datePickerView.withWeekDayLabel = YES;
    }
    self.startTimePickerView.frame = self.view.bounds;
    self.startTimePickerView.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    self.startTimePickerView.datePicker.minimumDate = [NSDate date];
    self.startTimePickerView.datePicker.maximumDate = nil;
    self.startTimePickerView.backgroundColor = UIColorFromRGBA(0x000000, 0);
    CGRect f = self.startTimePickerView.datePickerContainerView.frame;
    f.origin.y += f.size.height;
    self.startTimePickerView.datePickerContainerView.frame = f;
    [self.view addSubview:self.startTimePickerView];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^(){
        self.startTimePickerView.backgroundColor = UIColorFromRGBA(0x000000, 0.3);
        CGRect f = self.startTimePickerView.datePickerContainerView.frame;
        f.origin.y -= f.size.height;
        self.startTimePickerView.datePickerContainerView.frame = f;
    } completion:nil];
}
- (void)dismissStartDatePicker{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^(){
        self.startTimePickerView.backgroundColor = UIColorFromRGBA(0x000000, 0);
        CGRect f = self.startTimePickerView.datePickerContainerView.frame;
        f.origin.y += f.size.height;
        self.startTimePickerView.datePickerContainerView.frame = f;
    } completion:^(BOOL finished){
        [self.startTimePickerView removeFromSuperview];
    }];
}

- (void)showBirthdayPicker{
    if (!self.datePickerView) {
        self.datePickerView = [LCDatePicker createInstance];
        self.datePickerView.delegate = self;
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
    if (datePicker == self.datePickerView) {
        [self dismissBirthdayPicker];
    } else {
        [self dismissStartDatePicker];
    }
}
- (void)datePickerDidCancel:(LCDatePicker *)datePicker{
    if (datePicker == self.datePickerView) {
        [self dismissBirthdayPicker];
    } else {
        [self dismissStartDatePicker];
    }
    
}
- (void)datePickerDidConfirm:(LCDatePicker *)datePicker{
    if (datePicker == self.datePickerView) {
        [self dismissBirthdayPicker];
    NSDate *d = [datePicker.datePicker date];
    self.fillUserInfoView.birthdayTextField.text = [LCDateUtil stringFromDate:d];
    } else {
        [self dismissStartDatePicker];
        NSDate *d = [datePicker.datePicker date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        self.destAndTimeCell.timeField.text = [formatter stringFromDate:d];
        // = [[LCDateUtil stringFromDate:d];
                                               //[LCDateUtil getHourAndMinuteFormatter:d];
    }
}

- (void)didSelectTag {
    [self.view endEditing:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}
#pragma mark - UITextView Delegate

//- (void)textViewDidChange:(UITextView *)textView {
//    [self updateSubmitBtnShow];
//}

- (void)textViewDidEndEditing:(UITextView *)textView {
     [self updateSubmitBtnShow];
}
@end
