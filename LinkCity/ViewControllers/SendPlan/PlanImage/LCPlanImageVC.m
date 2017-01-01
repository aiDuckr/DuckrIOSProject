//
//  LCPlanImageVC.m
//  LinkCity
//
//  Created by roy on 2/8/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCPlanImageVC.h"
#import "LCPlanRouteEditVC.h"
#import "LCPlanImageVC.h"
#import "LCRecommendPlanVC.h"
#import "LCSendPlanFillUserInfoView.h"
#import "LCProvincePickerVC.h"
#import "LCDatePicker.h"
#import "LCSendPlanPriceVC.h"
#import "LCPickMultiImageHelper.h"

@interface LCPlanImageVC ()<UIActionSheetDelegate,LCPlanRouteEditVCDelegate,LCSendPlanFillUserInfoViewDelegate,LCProvincePickerDelegate,LCDatePickerDelegate>

//选图片
@property (weak, nonatomic) IBOutlet UIButton *imgBtnOne;
@property (weak, nonatomic) IBOutlet UIButton *imgBtnTwo;
@property (weak, nonatomic) IBOutlet UIButton *imgBtnThree;

//商家发约伴设置
@property (weak, nonatomic) IBOutlet UIView *merchantView;
@property (weak, nonatomic) IBOutlet UILabel *memberNumLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *memberNumLabelLeftSpace;
@property (weak, nonatomic) IBOutlet UISlider *memberNumSlider;

//普通发约伴设置
@property (weak, nonatomic) IBOutlet UIView *customerView;
@property (weak, nonatomic) IBOutlet UILabel *isNeedIdentityLabel;
@property (weak, nonatomic) IBOutlet UISwitch *isNeedIdentitySwitch;
@property (weak, nonatomic) IBOutlet UILabel *isAllowPhoneContactLabel;
@property (weak, nonatomic) IBOutlet UISwitch *isAllowPhoneContactSwitch;

//普通发约伴，行程详情
@property (weak, nonatomic) IBOutlet UIView *routeCellView;

//提交按钮
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (nonatomic, strong) LCSendPlanFillUserInfoView *fillUserInfoView;
@property (nonatomic, strong) KLCPopup *fillUserInfoPopup;
@property (nonatomic, strong) LCDatePicker *datePickerView;


//Data
@property (nonatomic, strong) UIButton *justClickedButton;



@end


static const int Max_Pick_Image_Count = 3;

#define EMPTY_IMAGE [[UIImage alloc]init]
#define PLACEHOLDER_IMAGE [UIImage imageNamed:LCDefaultUploadImageName]

@implementation LCPlanImageVC

+ (instancetype)createInstance{
    return (LCPlanImageVC *)[LCStoryboardManager viewControllerWithFileName:SBNameSendPlan identifier:VCIDPlanImageVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil]];
    
    UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
    self.navigationItem.rightBarButtonItem = cancelBarButton;
    
    [self.imgBtnOne addTarget:self action:@selector(imgBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.imgBtnTwo addTarget:self action:@selector(imgBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.imgBtnThree addTarget:self action:@selector(imgBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.submitButton addTarget:self action:@selector(submitButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.imgBtnOne.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imgBtnTwo.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imgBtnThree.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.memberNumSlider addTarget:self action:@selector(memberNumChangeAction) forControlEvents:UIControlEventValueChanged];
    self.memberNumSlider.minimumValue = 1;
    if ([LCDataManager sharedInstance].userInfo) {
        self.memberNumSlider.maximumValue = [[LCDataManager sharedInstance].userInfo getMaxPlanMember]-1;
    }else{
        self.memberNumSlider.maximumValue = MaxPlanScaleOfUsualUser-1;
    }
    
    [self.isNeedIdentitySwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [self.isAllowPhoneContactSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    
    [[LCUIConstants sharedInstance] setButtonAsSubmitButtonEnableStyle:self.submitButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self updateShow];
}

//页面layout之后
//初始化num label显示的内容和位置
- (void)viewDidLayoutSubviews{
    [self memberNumChangeAction];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self mergeUIDataIntoModel];
}

- (void)setEditingPlan:(LCPlanModel *)editingPlan{
    [super setCurPlan:editingPlan];
    [self initImageUnits];
}

- (void)updateShow{
    if (self.curPlan) {
        if ([[LCDataManager sharedInstance].userInfo isMerchant]) {
            self.merchantView.hidden = NO;
            self.customerView.hidden = YES;
            self.routeCellView.hidden = YES;
        }else{
            self.merchantView.hidden = YES;
            self.customerView.hidden = NO;
            self.routeCellView.hidden = NO;
        }
        
        [self updateImgBtnAppearance];
        
        self.memberNumSlider.value = self.curPlan.scaleMax;
        
        self.isNeedIdentityLabel.text = self.curPlan.isNeedIdentity?@"需要":@"无需";
        self.isNeedIdentitySwitch.on = self.curPlan.isNeedIdentity;
        self.isAllowPhoneContactLabel.text = self.curPlan.isAllowPhoneContact?@"允许":@"暂不";
        self.isAllowPhoneContactSwitch.on = self.curPlan.isAllowPhoneContact;
  
        if (self.isSendingPlan) {
            [self.submitButton setTitle:@"发布" forState:UIControlStateNormal];
        }else{
            [self.submitButton setTitle:@"保存修改" forState:UIControlStateNormal];
        }
    }
}

#pragma mark Button Actions
- (void)cancelAction:(id)sender{
    [MobClick event:Mob_PublishPlanB_Cancel];
    [self cancelSendPlan];
}
- (void)submitButtonAction {
    [MobClick event:Mob_PublishPlanB_Publish];
    [self mergeUIDataIntoModel];
    
    //如果用户个人信息不全，弹出补全信息页
    //不继续发约伴
    if ([self showFillUserInfoView]) {
        return;
    }
    
    //如果正在上传照片，显示hud，不继续发约伴
    if (uploadingImageNum > 0) {
        [YSAlertUtil showHudWithHint:@"正在上传图片"];
        return;
    }
    
    //如果未选照片，toast，不继续发约伴
    if (!self.curPlan.imageUnits || self.curPlan.imageUnits.count<1){
        [YSAlertUtil tipOneMessage:@"至少上传一张照片" yoffset:TipDefaultYoffset delay:TipErrorDelay];
        return;
    }
    
    //发约伴
    [YSAlertUtil showHudWithHint:nil];
    [LCNetRequester sendPlan:self.curPlan callBack:^(LCPlanModel *planSent, NSError *error) {
        LCLogInfo(@"Did send plan with Plan:%@  Error:%@",planSent,error);
        [YSAlertUtil hideHud];
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
        }else{
            [LCDataManager sharedInstance].editingPlan = nil;
            if (self.isSendingPlan) {
                [YSAlertUtil tipOneMessage:@"发布约伴成功!" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
                //上线room
                [[LCXMPPMessageHelper sharedInstance] getRoomOnlineWithRoomBareJid:planSent.roomId];
                
                LCRecommendPlanVC *recommendPlanVC = [LCRecommendPlanVC createInstance];
                recommendPlanVC.plan = planSent;
                [self.navigationController pushViewController:recommendPlanVC animated:YES];
            }else{
                [YSAlertUtil tipOneMessage:@"修改约伴成功!" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }];
}


- (void)imgBtnAction:(UIButton *)sender{
    [MobClick event:Mob_PublishPlanB_AddImage];
    
    self.justClickedButton = sender;
    if (sender == self.imgBtnOne) {
        if ([self haveImageAtIndex:0]) {
            // already have image, show delete action
            [self showDeletePicActionSheet];
        }else{
            // doesn't have image, show select photo view
            [self showImagePickerView];
        }
    }else if (sender == self.imgBtnTwo){
        if ([self haveImageAtIndex:1]) {
            // already have image, show delete action
            [self showDeletePicActionSheet];
        }else{
            // doesn't have image, show select photo view
            [self showImagePickerView];
        }
    }else if (sender == self.imgBtnThree){
        if ([self haveImageAtIndex:2]) {
            // already have image, show delete action
            [self showDeletePicActionSheet];
        }else{
            // doesn't have image, show select photo view
            [self showImagePickerView];
        }
    }
}

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

- (void)updateImgBtnAppearance{
    if ([self haveImageAtIndex:0]) {
        [self setImageAtIndex:0 toButton:self.imgBtnOne];
    }else{
        [self.imgBtnOne setImage:PLACEHOLDER_IMAGE forState:UIControlStateNormal];
    }
    if ([self haveImageAtIndex:1]) {
        [self setImageAtIndex:1 toButton:self.imgBtnTwo];
    }else{
        if ([self haveImageAtIndex:0]) {
            [self.imgBtnTwo setImage:PLACEHOLDER_IMAGE forState:UIControlStateNormal];
        }else{
            [self.imgBtnTwo setImage:EMPTY_IMAGE forState:UIControlStateNormal];
        }
    }
    if ([self haveImageAtIndex:2]) {
        [self setImageAtIndex:2 toButton:self.imgBtnThree];
    }else{
        if ([self haveImageAtIndex:1]) {
            [self.imgBtnThree setImage:PLACEHOLDER_IMAGE forState:UIControlStateNormal];
        }else{
            [self.imgBtnThree setImage:EMPTY_IMAGE forState:UIControlStateNormal];
        }
    }
}

- (IBAction)journeyDetailButtonAction:(id)sender {
    [MobClick event:Mob_PublishPlanB_AddRoute];
    LCPlanRouteEditVC *routeListVC = [LCPlanRouteEditVC createInstance];
    routeListVC.routeEditType = LCRouteEditType_ForSendPlan;
    routeListVC.delegate = self;
    if (!self.curPlan.userRoute) {
        self.curPlan.userRoute = [LCUserRouteModel createInstanceForEdit];
    }
    routeListVC.editingUserRoute = self.curPlan.userRoute;
    [self.navigationController pushViewController:routeListVC animated:YES];
}



#pragma mark - 
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
}
- (void)switchAction:(UISwitch *)sender{
    [self mergeUIDataIntoModel];
    [self updateShow];
}

#pragma mark Deal with Image Data
- (void)setImageAtIndex:(NSInteger)index toButton:(UIButton *)btn{
    if (self.curPlan.imageUnits.count > index) {
        LCImageUnit *unit = [self.curPlan.imageUnits objectAtIndex:index];
        if (unit.image) {
            [btn setImage:unit.image forState:UIControlStateNormal];
        }else{
            [btn setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:unit.thumbUrl] placeholderImage:EMPTY_IMAGE];
        }
    }
}
- (BOOL)haveImageAtIndex:(NSInteger)index{
    return self.curPlan.imageUnits.count > index;
}
- (NSInteger)remainingImageCount{
    return Max_Pick_Image_Count - self.curPlan.imageUnits.count;
}

- (void)initImageUnits{
    if (!self.curPlan.imageUnits) {
        self.curPlan.imageUnits = [[NSMutableArray alloc] init];
        if (self.curPlan && [LCStringUtil isNotNullString:self.curPlan.firstPhotoUrl]) {
            [self.curPlan.imageUnits addObject:[[LCImageUnit alloc] initWithUrl:self.curPlan.firstPhotoUrl thumbUrl:self.curPlan.firstPhotoThumbUrl image:nil]];
        }
        if (self.curPlan && [LCStringUtil isNotNullString:self.curPlan.secondPhotoUrl]) {
            [self.curPlan.imageUnits addObject:[[LCImageUnit alloc] initWithUrl:self.curPlan.secondPhotoUrl thumbUrl:self.curPlan.secondPhotoThumbUrl image:nil]];
        }
        if (self.curPlan && [LCStringUtil isNotNullString:self.curPlan.thirdPhotoUrl]) {
            [self.curPlan.imageUnits addObject:[[LCImageUnit alloc] initWithUrl:self.curPlan.thirdPhotoUrl thumbUrl:self.curPlan.thirdPhotoThumbUrl image:nil]];
        }
    }
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
    
    // set mount and authority
    self.curPlan.scaleMax = (NSInteger)self.memberNumSlider.value+1;
    self.curPlan.isNeedIdentity = self.isNeedIdentitySwitch.on;
    self.curPlan.isAllowPhoneContact = self.isAllowPhoneContactSwitch.on;
}


#pragma mark - ActionSheet
- (void)showDeletePicActionSheet{
    UIActionSheet *pickImageSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除", nil];
    [pickImageSheet showInView:[UIApplication sharedApplication].delegate.window];
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIView *subViwe in actionSheet.subviews) {
        if ([subViwe isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton*)subViwe;
            [button setTitleColor:UIColorFromRGBA(BUTTON_TITLE_COLOR, 1.0) forState:UIControlStateNormal];
        }
    }
}

- (UIViewController *)viewController {
    /// Finds the view's view controller.
    // Traverse responder chain. Return first found view controller, which will be the view's view controller.
    UIResponder *responder = self;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: [UIViewController class]])
            return (UIViewController *)responder;
    
    // If the view controller isn't found, return nil.
    return nil;
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // delete pic
        if (self.justClickedButton == self.imgBtnOne) {
            [self.curPlan.imageUnits removeObjectAtIndex:0];
        }else if (self.justClickedButton == self.imgBtnTwo) {
            [self.curPlan.imageUnits removeObjectAtIndex:1];
        }else if (self.justClickedButton == self.imgBtnThree) {
            [self.curPlan.imageUnits removeObjectAtIndex:2];
        }
    }else{
        // cancel
        
    }
    
    [self updateImgBtnAppearance];
}


#pragma mark - Assets Picker
- (void)showImagePickerView{
    if (!self.curPlan.imageUnits) {
        self.curPlan.imageUnits = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    [[LCPickMultiImageHelper sharedInstance] pickImageWithMaxNum:[self remainingImageCount] completion:^(NSArray *pickedImageArray) {
        for (UIImage *img in pickedImageArray){
            [self.curPlan.imageUnits addObject:[[LCImageUnit alloc] initWithUrl:nil thumbUrl:nil image:img]];
        }
        [self updateImgBtnAppearance];
        [self startUploadImage];
    }];
}

#pragma mark - Deal with upload Pic
static int uploadingImageNum = 0;
- (void)startUploadImage{
    //异步上传图片
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        //对每个有Asset，但没有URL的图片，进行上传
        [self.curPlan.imageUnits enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            LCImageUnit *unit = (LCImageUnit *)obj;
            if ([LCStringUtil isNullString:unit.url] && unit.image) {
                // url为空，asset不空， 需要上传图片
                uploadingImageNum ++;
                NSData *imgData = [LCImageUtil getDataOfCompressImage:unit.image toSize:MAX_IMAGE_SIZE_TO_UPLOAD];
                LCLogInfo(@"UploadImg uploadingNum:%d, imgSize:%ld",uploadingImageNum,(long)[imgData length]);
                [LCImageUtil uploadImageDataToQinu:imgData imageType:ImageCategoryPlan completion:^(NSString *imgUrl) {
                    uploadingImageNum --;
                    LCLogInfo(@"DiduploadImg uploadingNum:%d url:%@",uploadingImageNum,imgUrl);
        
                    if ([LCStringUtil isNullString:imgUrl]) {
                        //上传图片失败
                        [YSAlertUtil tipOneMessage:@"上传图片失败" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
                    }else{
                        unit.url = imgUrl;
                        unit.thumbUrl = [LCImageUtil getThumbImageUrlFromOrigionalImageUrl:imgUrl];
                    }
                    
                    if (uploadingImageNum <= 0) {
                        [self didFinishUploadImages];
                    }
                }];
            }
        }];
    });
}

- (void)didFinishUploadImages{
    if ([YSAlertUtil isShowingHud]) {
        [YSAlertUtil hideHud];
        // 如果正在显示hud，说明用户已经点了下一步按钮；上传图片完成后，自动下一步
        [self submitButtonAction];
    }
}


#pragma mark - LCPlanRouteEditVC Delegate
- (void)planRouteEditVC:(LCPlanRouteEditVC *)routeEditVC didSaveUserRoute:(LCUserRouteModel *)userRoute{
    self.curPlan.userRouteId = userRoute.userRouteId;
}
- (void)planRouteEditVCDidCancel:(LCPlanRouteEditVC *)routeEditVC{
    
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
    [[LCSharedFuncUtil getTopMostViewController] presentViewController:[[UINavigationController alloc] initWithRootViewController:provincePicker] animated:YES completion:nil];
}
- (void)provincePrcker:(LCProvincePickerVC *)provincePickerVC didSelectCity:(NSString *)cityName{
    if (provincePickerVC.navigationController) {
        [provincePickerVC.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    
    if (self.fillUserInfoView) {
        self.fillUserInfoView.livingPlaceTextField.text = [LCStringUtil getNotNullStr:cityName];
    }
    
    [self showFillUserInfoView];
}

@end






