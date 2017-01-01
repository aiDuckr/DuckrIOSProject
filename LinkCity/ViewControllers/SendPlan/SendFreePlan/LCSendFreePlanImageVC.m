//
//  LCSendFreePlanImageVC.m
//  LinkCity
//
//  Created by Roy on 12/13/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCSendFreePlanImageVC.h"
#import "LCSendFreePlanImageAndDescCell.h"
#import "LCSendFreePlanImageRouteTitleCell.h"
#import "LCSendFreePlanImageBottomCell.h"
#import "LCPickRouteCell.h"
#import "LCDatePicker.h"
#import "LCProvincePickerVC.h"
#import "LCSendPlanFillUserInfoView.h"
#import "LCSendFreePlanFinishVC.h"
#import "LinkCity-Swift.h"


#define CellTopSpaceOn (10)
#define CellTopSpaceOff (0)
@interface LCSendFreePlanImageVC ()<UITableViewDataSource, UITableViewDelegate, LCSendFreePlanImageBottomCellDelegate, LCSendFreePlanImageAndDescCellDelegate, LCSendPlanFillUserInfoViewDelegate, LCProvincePickerDelegate, LCDatePickerDelegate, LCPickRouteCellDelegate, LCSendFreePlanImageSeatCellDelegate, LCSendFreePlanImageCostCarryCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTop;

@property (nonatomic, strong) LCSendFreePlanImageCostCarryCell *costCell;
@property (nonatomic, strong) LCSendFreePlanImageAndDescCell *imageCell;
@property (nonatomic, strong) LCSendFreePlanImageBottomCell *bottomCell;

@property (nonatomic, strong) LCSendPlanFillUserInfoView *fillUserInfoView;
@property (nonatomic, strong) KLCPopup *fillUserInfoPopup;
@property (nonatomic, strong) LCDatePicker *datePickerView;

@property (nonatomic, strong) NSArray *routeArray;
@property (nonatomic, strong) NSMutableArray *routeSelectionArray;
@end

@implementation LCSendFreePlanImageVC

#pragma mark - PublicInterface
+ (instancetype)createInstance{
    return (LCSendFreePlanImageVC *)[LCStoryboardManager viewControllerWithFileName:SBNameSendPlan identifier:NSStringFromClass([LCSendFreePlanImageVC class])];
}
                                                                                                                                
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil]];
    UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
    self.navigationItem.rightBarButtonItem = cancelBarButton;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    [self.tableView.panGestureRecognizer addTarget:self action:@selector(panAction:)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 300;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCPickRouteCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCPickRouteCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCSendFreePlanImageAndDescCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCSendFreePlanImageAndDescCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCSendFreePlanImageSeatCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCSendFreePlanImageSeatCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCSendFreePlanImageCostCarryCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCSendFreePlanImageCostCarryCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCSendFreePlanImageAgreemengCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCSendFreePlanImageAgreemengCell class])];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateShow];
    
    [LCNetRequester getRouteForSendPlan:self.curPlan.departName
                              destNames:self.curPlan.destinationNames
                              startTime:[self.curPlan getFirstStageStartTime]
                                endTime:[self.curPlan getFirstStageEndTime]
                               daysLong:self.curPlan.daysLong
                               orderStr:nil
                               callBack:^(NSArray *userRoutes, NSString *orderStr, NSError *error)
     {
         if (error) {
             [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
         }else{
             self.routeArray = userRoutes;
             [self.tableView reloadData];
         }
         
     }];
}

- (void)updateShow{
    [self updateCellIndex];
    [self.tableView reloadData];
    [self updateSubmitBtnShow];
}

- (void)mergeUIDataIntoModel{
    // merge price
    if ([self.curPlan isCostCarryPlan]) {
        NSDecimalNumber *price = nil;
        if ([LCStringUtil isNotNullString:self.costCell.priceTextField.text]){
            price = [NSDecimalNumber decimalNumberWithString:self.costCell.priceTextField.text];
        }else{
            price = nil;
        }
        [self.curPlan setFirstStagePrice:price];
    }
    
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
    
    //self.curPlan.descriptionStr = [LCStringUtil trimSpaceAndEnter:self.imageCell.descTextView.text];
}

#pragma mark Set&Get
- (void)setRouteArray:(NSArray *)routeArray{
    _routeArray = routeArray;
    
    if (self.routeArray.count > 0) {
        self.routeSelectionArray = [[NSMutableArray alloc] initWithCapacity:self.routeArray.count];
        for(int i=0; i<self.routeArray.count; i++){
            LCUserRouteModel *anRoute = self.routeArray[i];
            if (self.curPlan.userRouteId != anRoute.userRouteId) {
                [self.routeSelectionArray addObject:[NSNumber numberWithBool:NO]];
            }else{
                [self.routeSelectionArray addObject:[NSNumber numberWithBool:YES]];
            }
        }
    }
}

#pragma mark Button Actions
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

- (void)submitAction{
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
                
                LCSendFreePlanFinishVC *finishVC = [LCSendFreePlanFinishVC createInstance];
                finishVC.plan = planSent;
                [self.navigationController pushViewController:finishVC animated:YES];
            }else{
                [LCDataManager sharedInstance].modifyingPlan = nil;
                [YSAlertUtil tipOneMessage:@"修改邀约成功!" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }];
}



#pragma mark - UITableView

#pragma mark Caculate TableView
static NSInteger cellNum = 0;
static NSInteger seatIndex = 0;
static NSInteger costIndex = 0;
static NSInteger imageIndex = 0;
static NSInteger routeTitleIndex = 0;
static NSInteger agreementIndex = 0;
static NSInteger bottomIndex = 0;

- (void)updateCellIndex{
    cellNum = 0;
    
    if ([self.curPlan isCostCarryPlan]) {
        seatIndex = 0;
        costIndex = 1;
        cellNum += 2;
    }else if([self.curPlan isFreeCarryPlan]){
        seatIndex = 0;
        costIndex = -1;
        cellNum += 1;
    }else{
        seatIndex = -1;
        costIndex = -1;
    }
    
    imageIndex = cellNum++;
    
    if (self.routeArray.count > 0) {
        routeTitleIndex = cellNum++;
        
        cellNum += self.routeArray.count;
    }else{
        routeTitleIndex = -1;
    }
    
    if ([self.curPlan isCostCarryPlan]) {
        agreementIndex = cellNum++;
    }else{
        agreementIndex = -1;
    }
    
    bottomIndex = cellNum++;
    
    NSDictionary *cellInfoDic = @{@"cellNum" : [NSNumber numberWithInteger:cellNum],
                                  @"seatIndex" : [NSNumber numberWithInteger:seatIndex],
                                  @"costIndex" : [NSNumber numberWithInteger:costIndex],
                                  @"imageIndex" : [NSNumber numberWithInteger:imageIndex],
                                  @"routeTitleIndex" : [NSNumber numberWithInteger:routeTitleIndex],
                                  @"agreementIndex" : [NSNumber numberWithInteger:agreementIndex],
                                  @"bottomIndex" : [NSNumber numberWithInteger:bottomIndex]};
    LCLogInfo(@"updateCellIndex:\r\n %@", cellInfoDic);
}

- (LCUserRouteModel *)routeForIndexPath:(NSIndexPath *)indexPath{
    NSInteger routeIndex = indexPath.row - routeTitleIndex - 1;
    if (routeIndex >= 0 &&
        routeIndex < self.routeArray.count) {
        return self.routeArray[routeIndex];
    }
    
    return nil;
}

#pragma mark TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return cellNum;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = nil;
    
    if (indexPath.row == seatIndex) {
        //seat cell
        LCSendFreePlanImageSeatCell *seatCell = [tableView dequeueReusableCellWithIdentifier:[LCSharedFuncUtil classNameOfClass:[LCSendFreePlanImageSeatCell class]] forIndexPath:indexPath];
        seatCell.topSpace.constant = CellTopSpaceOn;
        seatCell.seatNumLabel.text = [NSString stringWithFormat:@"%ld", (long)(self.curPlan.scaleMax - 1)];
        if (self.curPlan.scaleMax <= 2) {
            seatCell.minusBtn.enabled = NO;
            [seatCell.minusBtn setImage:[UIImage imageNamed:@"SendPlanMinusDayIcon_gray"] forState:UIControlStateNormal];
        }else{
            seatCell.minusBtn.enabled = YES;
            [seatCell.minusBtn setImage:[UIImage imageNamed:@"SendPlanMinusDayIcon"] forState:UIControlStateNormal];
        }
        
        if (self.curPlan.scaleMax >= MaxPlanScaleOfMerchant) {
            seatCell.plusBtn.enabled = NO;
            [seatCell.plusBtn setImage:[UIImage imageNamed:@"SendPlanAddDayIcon_gray"] forState:UIControlStateNormal];
        }else{
            seatCell.plusBtn.enabled = YES;
            [seatCell.plusBtn setImage:[UIImage imageNamed:@"SendPlanAddDayIcon"] forState:UIControlStateNormal];
        }
        
        
        seatCell.delegate = self;
        cell = seatCell;
    }else if(indexPath.row == costIndex){
        //cost cell
        LCSendFreePlanImageCostCarryCell *costCell = [tableView dequeueReusableCellWithIdentifier:[LCSharedFuncUtil classNameOfClass:[LCSendFreePlanImageCostCarryCell class]] forIndexPath:indexPath];
        costCell.delegate = self;
        self.costCell = costCell;
        NSDecimalNumber *price = [self.curPlan getFirstStagePrice];
        if ([LCDecimalUtil isOverZero:price]) {
            costCell.priceTextField.text = [NSString stringWithFormat:@"%@", price];
        }else{
            costCell.priceTextField.text = @"";
        }
        
        cell = costCell;
    }else if(indexPath.row == imageIndex){
        //iamge cell
        LCSendFreePlanImageAndDescCell *imageCell = [tableView dequeueReusableCellWithIdentifier:[LCSharedFuncUtil classNameOfClass:[LCSendFreePlanImageAndDescCell class]] forIndexPath:indexPath];
        
        self.imageCell = imageCell;
        [self.imageCell updateShowWithPlan:self.curPlan];
        self.imageCell.delegate = self;
        //self.imageCell.topSpace.constant = CellTopSpaceOn;
        
        cell = imageCell;
    }else if(indexPath.row == routeTitleIndex){
        //route title cell
        LCSendFreePlanImageRouteTitleCell *titleCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCSendFreePlanImageRouteTitleCell class]) forIndexPath:indexPath];
        cell = titleCell;
    }else if(self.routeArray.count > 0 &&
             indexPath.row > routeTitleIndex &&
             indexPath.row <= routeTitleIndex + self.routeArray.count){
        //route cell
        LCPickRouteCell *pickRouteCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCPickRouteCell class]) forIndexPath:indexPath];
        LCUserRouteModel *route = [self routeForIndexPath:indexPath];
        NSInteger routeIndex = [self.routeArray indexOfObject:route];
        [pickRouteCell updateShowWithRoute:route selected:[[self.routeSelectionArray objectAtIndex:routeIndex] boolValue]];
        pickRouteCell.delegate = self;
        
        cell = pickRouteCell;
    }else if(indexPath.row == agreementIndex){
        //agreement cell
        LCSendFreePlanImageAgreemengCell *agreementCell = [tableView dequeueReusableCellWithIdentifier:[LCSharedFuncUtil classNameOfClass:[LCSendFreePlanImageAgreemengCell class]] forIndexPath:indexPath];
        cell = agreementCell;
    }else if(indexPath.row == bottomIndex){
        //bottom cell
        LCSendFreePlanImageBottomCell *bottomCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCSendFreePlanImageBottomCell class]) forIndexPath:indexPath];
        if ([self.curPlan isCostCarryPlan]) {
            bottomCell.backgroundColor = [UIColor clearColor];
        }else{
            bottomCell.backgroundColor = UIColorFromRGBA(0xF2F0ED, 1);
        }
        
        self.bottomCell = bottomCell;
        self.bottomCell.delegate = self;
        [self updateSubmitBtnShow];
        
        cell = bottomCell;
    }
    
    
    LCLogInfo(@"cell: %ld, forRow: %@", (long)indexPath.row, [cell class]);
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == seatIndex) {
        //seat cell
    }else if(indexPath.row == costIndex){
        //cost cell
    }else if(indexPath.row == imageIndex){
        //iamge cell
    }else if(indexPath.row == routeTitleIndex){
        //route title cell
    }else if(self.routeArray.count > 0 &&
             indexPath.row > routeTitleIndex &&
             indexPath.row <= routeTitleIndex + self.routeArray.count){
        //route cell
        LCUserRouteModel *route = [self routeForIndexPath:indexPath];
        [LCViewSwitcher pushToShowRouteDetailVCForRoute:route routeOwner:[LCDataManager sharedInstance].userInfo editable:NO showDayIndex:0 on:self.navigationController callBack:^(BOOL choose) {
            
            if (choose) {
                LCPickRouteCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
                [self pickRouteCellDidClickSelect:selectedCell];
            }
        }];
    }else if(indexPath.row == agreementIndex){
        //agreement cell
        NSString *url = server_url([LCConstants serverHost], LCCostCarryAgreementURL);
        [LCViewSwitcher presentWebVCtoShowURL:url withTitle:nil];
    }else if(indexPath.row == bottomIndex){
        //bottom cell
    }
}


#pragma mark - TableView Cell Delegate


#pragma mark SeatsCell
- (void)sendFreePlanImageSeatCellDidClickMinus{
    self.curPlan.scaleMax -= 1;
    self.curPlan.scaleMax = self.curPlan.scaleMax < 2 ? 2 : self.curPlan.scaleMax;
    [self updateShow];
}
- (void)sendFreePlanImageSeatCellDidClickPlus{
    self.curPlan.scaleMax += 1;
    [self updateShow];
}

#pragma mark CostCarryCell
- (void)sendFreePlanImageCostCarryCellDidEditPrice{
    [self updateSubmitBtnShow];
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

#pragma mark PickRouteCell
- (void)pickRouteCellDidClickSelect:(LCPickRouteCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSInteger routeIndex = indexPath.row - routeTitleIndex - 1;
    if (self.routeArray.count > 0 &&
        routeIndex >=0 &&
        routeIndex < self.routeArray.count) {
        
        for (int i=0; i<self.routeArray.count; i++){
            if (i != routeIndex) {
                [self.routeSelectionArray replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];
            }else{
                BOOL lastSelection = [self.routeSelectionArray[i] boolValue];
                if (lastSelection) {
                    [self.routeSelectionArray replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];
                    self.curPlan.userRouteId = -1;
                }else{
                    [self.routeSelectionArray replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:YES]];
                    LCUserRouteModel *theRoute = self.routeArray[i];
                    self.curPlan.userRouteId = theRoute.userRouteId;
                }
            }
        }
    }
    [self.tableView reloadData];
}

#pragma mark BottomCell
- (void)sendFreePlanImageBottomCellDidClickSubmitBtn:(LCSendFreePlanImageBottomCell *)bottomCell{
    
    [self submitAction];
}


- (void)updateSubmitBtnShow{
    if (!self.bottomCell) {
        return;
    }
    
    
    if (self.isSendingPlan) {
        [self.bottomCell.submibBtn setTitle:@"发布" forState:UIControlStateNormal];
    }else{
        [self.bottomCell.submibBtn setTitle:@"保存修改" forState:UIControlStateNormal];
    }
    
    if ([LCStringUtil isNullString:[self checkInput]]) {
        [[LCUIConstants sharedInstance] setButtonAsSubmitButtonEnableStyle:self.bottomCell.submibBtn];
    }else{
        [[LCUIConstants sharedInstance] setButtonAsSubmitButtonDisableStyle:self.bottomCell.submibBtn];
    }
}
- (NSString *)checkInput {
    [self mergeUIDataIntoModel];
    
    NSString *errorMsg = @"";
    
    if ([self.curPlan isCostCarryPlan]) {
        NSDecimalNumber *price = [NSDecimalNumber zero];
        if (self.curPlan.stageArray.count > 0) {
            LCPartnerStageModel *stage = [self.curPlan.stageArray firstObject];
            price = stage.price;
        }
        
        if (![LCDecimalUtil isOverZero:price]) {
            errorMsg = [errorMsg stringByAppendingString:@"请输入每人需要承担的费用\r\n"];
        }
    }
    
    //如果未选照片，toast，不继续发邀约
    if (!self.curPlan.imageUnits || self.curPlan.imageUnits.count<1){
        errorMsg = [errorMsg stringByAppendingString:@"至少上传一张生活照\r\n"];
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

#pragma mark - BirthdayPicker
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
    if (self.fillUserInfoView) {
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
