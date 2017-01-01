//
//  LCCarServiceAuthenticateVC.m
//  LinkCity
//
//  Created by roy on 3/12/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCCarIdentityVC.h"
#import "LCPickOneImageHelper.h"
#import "LinkCity-Swift.h"


@interface LCCarIdentityVC ()<UITextFieldDelegate,UITextViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate>
//Data
@property (nonatomic, strong) UIImage *pickedDrivingLicense;
@property (nonatomic, strong) UIImage *pickedCarPic;
@property (nonatomic, strong) UIImage *pickedVehicleLicense;
@property (nonatomic, assign) BOOL isProcessingDrivingLicense;
@property (nonatomic, assign) BOOL isProcessingCarPic;
@property (nonatomic, assign) BOOL isProcessingVehicleLicense;
@property (nonatomic, assign) BOOL haveClickFinishButton;


//UI
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIButton *drivingLicenseExampleButton;
@property (weak, nonatomic) IBOutlet UIButton *drivingLicenseUploadButton;
@property (weak, nonatomic) IBOutlet UIImageView *drivingLicenseImageView;
@property (nonatomic, assign) BOOL isDrivingLicenseButtonEnabled;


@property (weak, nonatomic) IBOutlet UIButton *carPicExampleButton;
@property (weak, nonatomic) IBOutlet UIButton *carPicUploadButton;
@property (weak, nonatomic) IBOutlet UIImageView *carPicImageView;
@property (nonatomic, assign) BOOL isCarPicButtonEnabled;

@property (weak, nonatomic) IBOutlet UIButton *vehicleLicenseExampleButton;
@property (weak, nonatomic) IBOutlet UIButton *vehicleLicenseUploadButton;
@property (weak, nonatomic) IBOutlet UIImageView *vehicleLicenseImageView;
@property (nonatomic, assign) BOOL isVehicleLicenseButtonEnabled;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;


@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (nonatomic, assign) BOOL isUserNameEnabled;

@property (weak, nonatomic) IBOutlet UITextField *idNumberTextField;
@property (nonatomic, assign) BOOL isIdNumberEnabled;

@property (weak, nonatomic) IBOutlet UITextField *carBrandTextField;
@property (nonatomic, assign) BOOL isCarBrandEnabled;

@property (weak, nonatomic) IBOutlet UITextField *carTypeTextField;
@property (nonatomic, assign) BOOL isCarTypeEnabled;

@property (weak, nonatomic) IBOutlet UITextField *carLicenseTextField;
@property (nonatomic, assign) BOOL isCarLicenseEnabled;

@property (weak, nonatomic) IBOutlet UITextField *carSeatTextField;
@property (nonatomic, assign) BOOL isCarSeatEnabled;

@property (weak, nonatomic) IBOutlet UITextField *carYearTextField;
@property (nonatomic, assign) BOOL isCarYearEnabled;

@property (weak, nonatomic) IBOutlet UITextField *drivingYearTextField;
@property (nonatomic, assign) BOOL isDrivingYearEnabled;

@property (weak, nonatomic) IBOutlet UITextField *carAreaTextField;
@property (nonatomic, assign) BOOL isCarAreaEnabled;

@property (weak, nonatomic) IBOutlet UITextField *dayPriceTextField;
@property (nonatomic, assign) BOOL isDayPriceEnabled;

@property (weak, nonatomic) IBOutlet UILabel *failReasonLabel;


@end

@implementation LCCarIdentityVC

+ (instancetype)createInstance{
    return (LCCarIdentityVC *)[LCStoryboardManager viewControllerWithFileName:SBNameUserTab identifier:VCIDCarIdentityVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isProcessingCarPic = NO;
    self.isProcessingDrivingLicense = NO;
    self.isProcessingVehicleLicense = NO;
    
    self.userNameTextField.delegate = self;
    self.idNumberTextField.delegate = self;
    self.carBrandTextField.delegate = self;
    self.carTypeTextField.delegate = self;
    self.carLicenseTextField.delegate = self;
    self.carSeatTextField.delegate = self;
    self.carYearTextField.delegate = self;
    self.drivingYearTextField.delegate = self;
    self.carAreaTextField.delegate = self;
    self.dayPriceTextField.delegate = self;
    self.carTypeTextField.delegate = self;
    self.scrollView.delegate = self;
    
    [[LCUIConstants sharedInstance] setButtonAsSubmitButtonEnableStyle:self.submitButton];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
    [self updateShow];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self mergeUIBackToDataModel];
}

- (LCCarIdentityModel *)carModel{
    if (!_carModel) {
        _carModel = [LCCarIdentityModel createInstance];
        _carModel.carSeat = -1;
        _carModel.carYear = -1;
        _carModel.drivingYear = -1;
    }
    return _carModel;
}

- (void)refreshData{
    [LCNetRequester getCarIdentityInfoWithCallBack:^(LCCarIdentityModel *carIdentity, NSError *error) {
        if (error) {
            LCLogWarn(@"getCarIdentityInfoWithCallBack error:%@",error);
        }else{
            self.carModel = carIdentity;
            [self updateShow];
        }
    }];
}

- (void)updateShow{
    //update text
    self.userNameTextField.text = [LCStringUtil getNotNullStr:self.carModel.userName];
    self.idNumberTextField.text = [LCStringUtil getNotNullStr:self.carModel.idNumber];
    self.carBrandTextField.text = [LCStringUtil getNotNullStr:self.carModel.carBrand];
    self.carTypeTextField.text = [LCStringUtil getNotNullStr:self.carModel.carType];
    self.carLicenseTextField.text = [LCStringUtil getNotNullStr:self.carModel.carLicense];
    
    if (self.carModel.carSeat <= 0) {
        self.carSeatTextField.text = @"";
    }else{
        self.carSeatTextField.text = [NSString stringWithFormat:@"%ld",(long)self.carModel.carSeat];
    }
    
    if (self.carModel.carYear < 0) {
        self.carYearTextField.text = @"";
    }else{
        self.carYearTextField.text = [NSString stringWithFormat:@"%ld",(long)self.carModel.carYear];
    }
    
    if (self.carModel.drivingYear < 0) {
        self.drivingYearTextField.text = @"";
    }else{
        self.drivingYearTextField.text = [NSString stringWithFormat:@"%ld",(long)self.carModel.drivingYear];
    }
    
    self.carAreaTextField.text = [LCStringUtil getNotNullStr:self.carModel.carArea];
    
    if (![LCDecimalUtil isOverZero:self.carModel.dayPrice]) {
        self.dayPriceTextField.text = @"";
    }else{
        self.dayPriceTextField.text = [NSString stringWithFormat:@"%@",self.carModel.dayPrice];
    }
    
    //update image button
    UIImage *placeHolderImage = nil;
    if (self.pickedDrivingLicense) {
        placeHolderImage = self.pickedDrivingLicense;
    }else{
        placeHolderImage = [UIImage imageNamed:LCDefaultUploadImageName];
    }
    [self.drivingLicenseImageView setImageWithURL:[NSURL URLWithString:self.carModel.drivingLicenseThumbUrl] placeholderImage:placeHolderImage];
    
    if (self.pickedCarPic) {
        placeHolderImage = self.pickedCarPic;
    }else{
        placeHolderImage = [UIImage imageNamed:LCDefaultUploadImageName];
    }
    [self.carPicImageView setImageWithURL:[NSURL URLWithString:self.carModel.carPictureThumbUrl] placeholderImage:placeHolderImage];
    
    if (self.pickedVehicleLicense) {
        placeHolderImage = self.pickedVehicleLicense;
    }else{
        placeHolderImage = [UIImage imageNamed:LCDefaultUploadImageName];
    }
    [self.vehicleLicenseImageView setImageWithURL:[NSURL URLWithString:self.carModel.vehicleLicenseThumbUrl] placeholderImage:placeHolderImage];
    
    //update editable
    switch ([self.carModel getIdentityStatus]) {
        case LCIdentityStatus_None:{
            [self.submitButton setTitle:@"提交审核" forState:UIControlStateNormal];
            [self setEditEnable:YES];
            self.failReasonLabel.hidden = YES;
        }
            break;
        case LCIdentityStatus_Failed:{
            [self.submitButton setTitle:@"重新提交" forState:UIControlStateNormal];
            [self setEditEnable:YES];
            self.failReasonLabel.hidden = NO;
            self.failReasonLabel.text = [LCStringUtil getNotNullStr:self.carModel.reason];
        }
            break;
        case LCIdentityStatus_Done:{
            [self.submitButton setTitle:@"修改车辆信息" forState:UIControlStateNormal];
            [self setEditEnable:NO];
            
            self.isCarAreaEnabled = YES;
            self.isDayPriceEnabled = YES;
            self.submitButton.enabled = YES;
            [[LCUIConstants sharedInstance] setButtonAsSubmitButtonEnableStyle:self.submitButton];
        }
            break;
        case LCIdentityStatus_Verifying:{
            [self.submitButton setTitle:@"正在审核" forState:UIControlStateNormal];
            [self setEditEnable:NO];
            self.failReasonLabel.hidden = YES;
        }
            break;
    }
}

- (void)setEditEnable:(BOOL)enable{
    self.isDrivingLicenseButtonEnabled = enable;
    self.isCarPicButtonEnabled = enable;
    self.isVehicleLicenseButtonEnabled = enable;
    
    self.isUserNameEnabled = enable;
    self.isIdNumberEnabled = enable;
    self.isCarBrandEnabled = enable;
    self.isCarTypeEnabled = enable;
    self.isCarLicenseEnabled = enable;
    self.isCarSeatEnabled = enable;
    self.isCarYearEnabled = enable;
    self.isDrivingYearEnabled = enable;
    self.isCarAreaEnabled = enable;
    self.isDayPriceEnabled = enable;
    
    self.submitButton.enabled = enable;
    if (enable) {
        [[LCUIConstants sharedInstance] setButtonAsSubmitButtonEnableStyle:self.submitButton];
    }else{
        [[LCUIConstants sharedInstance] setButtonAsSubmitButtonDisableStyle:self.submitButton];
    }
}

- (void)mergeUIBackToDataModel{
    // merge ui back to data
    self.carModel.userName = self.userNameTextField.text;
    self.carModel.idNumber = self.idNumberTextField.text;
    self.carModel.carBrand = self.carBrandTextField.text;
    self.carModel.carType = self.carTypeTextField.text;
    self.carModel.carLicense = self.carLicenseTextField.text;
    
    self.carModel.carSeat = [LCStringUtil idToNSInteger:self.carSeatTextField.text];
    self.carModel.carYear = [LCStringUtil idToNSInteger:self.carYearTextField.text];
    self.carModel.drivingYear = [LCStringUtil idToNSInteger:self.drivingYearTextField.text];
    
    self.carModel.carArea = self.carAreaTextField.text;
    self.carModel.dayPrice = [NSDecimalNumber decimalNumberWithString:self.dayPriceTextField.text];
}

#pragma mark UIButton Action
- (IBAction)drivieLicenseButtonAction:(id)sender {
    if (!self.isDrivingLicenseButtonEnabled) {
        [YSAlertUtil tipOneMessage:@"已经提交审核后，不能修改" yoffset:TipDefaultYoffset delay:TipErrorDelay];
        return;
    }
    
    [[LCPickOneImageHelper sharedInstance] pickImageFromAlbum:YES camera:YES allowEdit:YES completion:^(UIImage *image) {
        if (image) {
            self.isProcessingDrivingLicense = YES;
            self.pickedDrivingLicense = image;
            self.carModel.drivingLicenseUrl = nil;
            self.carModel.drivingLicenseThumbUrl = nil;
            [self.drivingLicenseImageView setImageWithURL:nil placeholderImage:self.pickedDrivingLicense];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *imageDataToUpload = [LCImageUtil getDataOfCompressImage:image toSize:MAX_IMAGE_SIZE_TO_UPLOAD];
                [LCImageUtil uploadImageDataToQinu:imageDataToUpload imageType:ImageCategoryCarProvider completion:^(NSString *imgUrl) {
                    self.isProcessingDrivingLicense = NO;
                    [YSAlertUtil hideHud];
                    
                    if ([LCStringUtil isNullString:imgUrl]) {
                        LCLogWarn(@"upload image failed");
                    }else{
                        //这里都设为url，为了方便上传
                        self.carModel.drivingLicenseUrl = imgUrl;
                        LCLogInfo(@"Finish Upload Image: %@",imgUrl);
                    }
                    if (self.haveClickFinishButton) {
                        [self submitButtonAction:nil];
                    }
                }];
            });
        }
    }];
}

- (IBAction)carPicButtonAction:(id)sender {
    if (!self.isCarPicButtonEnabled) {
        [YSAlertUtil tipOneMessage:@"已经提交审核后，不能修改" yoffset:TipDefaultYoffset delay:TipErrorDelay];
        return;
    }
    
    [[LCPickOneImageHelper sharedInstance] pickImageFromAlbum:YES camera:YES allowEdit:YES completion:^(UIImage *image) {
        if (image) {
            self.isProcessingCarPic = YES;
            self.pickedCarPic = image;
            self.carModel.carPictureUrl = nil;
            self.carModel.carPictureThumbUrl = nil;
            [self.carPicImageView setImageWithURL:nil placeholderImage:self.pickedCarPic];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *imageDataToUpload = [LCImageUtil getDataOfCompressImage:image toSize:MAX_IMAGE_SIZE_TO_UPLOAD];
                [LCImageUtil uploadImageDataToQinu:imageDataToUpload imageType:ImageCategoryCarProvider completion:^(NSString *imgUrl) {
                    self.isProcessingCarPic = NO;
                    [YSAlertUtil hideHud];
                    
                    if ([LCStringUtil isNullString:imgUrl]) {
                        LCLogWarn(@"upload image failed");
                    }else{
                        //这里都设为url，为了方便上传
                        self.carModel.carPictureUrl = imgUrl;
                        LCLogInfo(@"Finish Upload Image: %@",imgUrl);
                    }
                    if (self.haveClickFinishButton) {
                        [self submitButtonAction:nil];
                    }
                }];
            });
        }
    }];
}
- (IBAction)vehicleLicenseButtonAction:(id)sender {
    if (!self.isVehicleLicenseButtonEnabled) {
        [YSAlertUtil tipOneMessage:@"已经提交审核后，不能修改" yoffset:TipDefaultYoffset delay:TipErrorDelay];
        return;
    }
    
    [[LCPickOneImageHelper sharedInstance] pickImageFromAlbum:YES camera:YES allowEdit:YES completion:^(UIImage *image) {
        if (image) {
            self.isProcessingVehicleLicense = YES;
            self.pickedVehicleLicense = image;
            self.carModel.vehicleLicenseUrl = nil;
            self.carModel.vehicleLicenseThumbUrl = nil;
            [self.vehicleLicenseImageView setImageWithURL:nil placeholderImage:self.pickedVehicleLicense];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *imageDataToUpload = [LCImageUtil getDataOfCompressImage:image toSize:MAX_IMAGE_SIZE_TO_UPLOAD];
                [LCImageUtil uploadImageDataToQinu:imageDataToUpload imageType:ImageCategoryCarProvider completion:^(NSString *imgUrl) {
                    self.isProcessingVehicleLicense = NO;
                    [YSAlertUtil hideHud];
                    
                    if ([LCStringUtil isNullString:imgUrl]) {
                        LCLogWarn(@"upload image failed");
                    }else{
                        //这里都设为url，为了方便上传
                        self.carModel.vehicleLicenseUrl = imgUrl;
                        LCLogInfo(@"Finish Upload Image: %@",imgUrl);
                    }
                    if (self.haveClickFinishButton) {
                        [self submitButtonAction:nil];
                    }
                }];
            });
        }
    }];
}

- (IBAction)submitButtonAction:(id)sender {
    self.haveClickFinishButton = YES;
    [self mergeUIBackToDataModel];
    
    if (![self checkInput]) {
        return;
    }
    
    self.haveClickFinishButton = NO;
    LCLogInfo(@"do submit identity car");
    [LCNetRequester carIdentityWith:self.carModel callBack:^(LCCarIdentityModel *carIdentity, LCUserModel *user, NSError *error) {
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipDefaultDelay];
        }else{
            
            NSString *tipMsg = @"";
            switch ([self.carModel getIdentityStatus]) {
                case LCIdentityStatus_None:{
                    tipMsg = @"提交成功，正在等待管理员审核";
                }
                    break;
                case LCIdentityStatus_Failed:{
                    tipMsg = @"提交成功，正在等待管理员审核";
                }
                    break;
                case LCIdentityStatus_Done:{
                    tipMsg = @"修改成功";
                }
                    break;
                case LCIdentityStatus_Verifying:{
                    //此状态按钮不能点
                }
                    break;
            }
            [YSAlertUtil tipOneMessage:tipMsg yoffset:TipDefaultYoffset delay:TipDefaultDelay];
            
            self.carModel = carIdentity;
            [LCDataManager sharedInstance].userInfo = user;
            [[LCDataManager sharedInstance] saveData];
            [self updateShow];
            
            if ([[LCDataManager sharedInstance].userInfo isMerchant] ||
                [LCDecimalUtil isOverZero:[LCDataManager sharedInstance].userInfo.marginValue]) {
                //是商家，或者已经交过保证金，不需要再交
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                LCUserMarginVC *marginVC = [LCUserMarginVC createInstance];
                NSMutableArray *vcs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                [vcs replaceObjectAtIndex:(vcs.count-1) withObject:marginVC];
                [self.navigationController setViewControllers:vcs animated:YES];
            }
        }
    }];
}


- (BOOL)checkInput{
    self.haveClickFinishButton = NO;
    
    if ([LCStringUtil isNullString:self.carModel.userName]) {
        [YSAlertUtil tipOneMessage:@"请输入车主姓名" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
        return NO;
    }
    
    if ([LCStringUtil isNullString:self.carModel.idNumber]) {
        [YSAlertUtil tipOneMessage:@"请输入身份证号" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
        return NO;
    }
    
    if ([LCStringUtil isNullString:self.carModel.carBrand]) {
        [YSAlertUtil tipOneMessage:@"请输入汽车品牌" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
        return NO;
    }
    
    if ([LCStringUtil isNullString:self.carModel.carType]) {
        [YSAlertUtil tipOneMessage:@"请输入汽车型号" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
        return NO;
    }
    
    if ([LCStringUtil isNullString:self.carModel.carLicense]) {
        [YSAlertUtil tipOneMessage:@"请输入车牌号" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
        return NO;
    }
    
    if ([LCStringUtil isNullString:self.carSeatTextField.text]) {
        [YSAlertUtil tipOneMessage:@"请输入载客数" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
        return NO;
    }else{
        if (![LCStringUtil isPureInt:self.carSeatTextField.text]) {
            [YSAlertUtil tipOneMessage:@"请输入正确的载客数" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
            return NO;
        }
    }
    
    if ([LCStringUtil isNullString:self.carYearTextField.text]) {
        [YSAlertUtil tipOneMessage:@"请输入车龄" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
        return NO;
    }else{
        if (![LCStringUtil isPureInt:self.carYearTextField.text]) {
            [YSAlertUtil tipOneMessage:@"请输入正确的车龄" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
            return NO;
        }
    }
    
    if ([LCStringUtil isNullString:self.drivingYearTextField.text]) {
        [YSAlertUtil tipOneMessage:@"请输入您的驾龄" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
        return NO;
    }else{
        if (![LCStringUtil isPureInt:self.drivingYearTextField.text]) {
            [YSAlertUtil tipOneMessage:@"请输入正确的驾龄" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
            return NO;
        }
    }
    
    if ([LCStringUtil isNullString:self.carModel.carArea]) {
        [YSAlertUtil tipOneMessage:@"请输入服务路线" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
        return NO;
    }
    
    if(![LCDecimalUtil isOverZero:self.carModel.dayPrice]){
        [YSAlertUtil tipOneMessage:@"请输入价格" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
        return NO;
    }
    
    if (!self.isProcessingDrivingLicense && [LCStringUtil isNullString:self.carModel.drivingLicenseUrl]) {
        [YSAlertUtil tipOneMessage:@"请上传驾驶证照片" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
        return NO;
    }
    
    if (!self.isProcessingCarPic && [LCStringUtil isNullString:self.carModel.carPictureUrl]) {
        [YSAlertUtil tipOneMessage:@"请上传您与座驾的合影" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
        return NO;
    }
    
    if (!self.isProcessingVehicleLicense && [LCStringUtil isNullString:self.carModel.vehicleLicenseUrl]) {
        [YSAlertUtil tipOneMessage:@"请上传行驶证照片" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
        return NO;
    }
    
    if (self.isProcessingDrivingLicense || self.isProcessingCarPic || self.isProcessingVehicleLicense) {
        self.haveClickFinishButton = YES;
        [YSAlertUtil showHudWithHint:nil];
        return NO;
    }
    
    
    return YES;
}

#pragma mark UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.isShowingKeyboard && !self.isJustShowKeyboard) {
        [self.view endEditing:YES];
    }
}

#pragma mark TextView/TextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    CGRect r = [textField convertRect:textField.bounds toView:self.scrollView];
    r.origin.y += LCTextKeyboardHeight + 20;
    [self.scrollView scrollRectToVisible:r animated:YES];
    
    if (textField == self.userNameTextField) {
        if (self.isUserNameEnabled) {
            return YES;
        }else{
            [YSAlertUtil tipOneMessage:@"已经提交审核后，不能修改" yoffset:TipDefaultYoffset delay:TipErrorDelay];
            return NO;
        }
    }else if (textField == self.idNumberTextField) {
        if (self.isIdNumberEnabled) {
            return YES;
        }else{
            [YSAlertUtil tipOneMessage:@"已经提交审核后，不能修改" yoffset:TipDefaultYoffset delay:TipErrorDelay];
            return NO;
        }
    }else if (textField == self.carBrandTextField) {
        if (self.isCarBrandEnabled) {
            return YES;
        }else{
            [YSAlertUtil tipOneMessage:@"已经提交审核后，不能修改" yoffset:TipDefaultYoffset delay:TipErrorDelay];
            return NO;
        }
    }else if (textField == self.carTypeTextField) {
        if (self.isCarTypeEnabled) {
            return YES;
        }else{
            [YSAlertUtil tipOneMessage:@"已经提交审核后，不能修改" yoffset:TipDefaultYoffset delay:TipErrorDelay];
            return NO;
        }
    }else if(textField == self.carLicenseTextField) {
        if (self.isCarLicenseEnabled) {
            return YES;
        }else{
            [YSAlertUtil tipOneMessage:@"已经提交审核后，不能修改" yoffset:TipDefaultYoffset delay:TipErrorDelay];
            return NO;
        }
    }else if(textField == self.carSeatTextField) {
        if (self.isCarSeatEnabled) {
            return YES;
        }else{
            [YSAlertUtil tipOneMessage:@"已经提交审核后，不能修改" yoffset:TipDefaultYoffset delay:TipErrorDelay];
            return NO;
        }
    }else if(textField == self.carYearTextField) {
        if (self.isCarYearEnabled) {
            return YES;
        }else{
            [YSAlertUtil tipOneMessage:@"已经提交审核后，不能修改" yoffset:TipDefaultYoffset delay:TipErrorDelay];
            return NO;
        }
    }else if(textField == self.drivingYearTextField) {
        if (self.isDrivingYearEnabled) {
            return YES;
        }else{
            [YSAlertUtil tipOneMessage:@"已经提交审核后，不能修改" yoffset:TipDefaultYoffset delay:TipErrorDelay];
            return NO;
        }
    }else if(textField == self.carAreaTextField) {
        if (self.isCarAreaEnabled) {
            return YES;
        }else{
            [YSAlertUtil tipOneMessage:@"已经提交审核后，不能修改" yoffset:TipDefaultYoffset delay:TipErrorDelay];
            return NO;
        }
    }else if(textField == self.dayPriceTextField) {
        if (self.isDayPriceEnabled) {
            return YES;
        }else{
            [YSAlertUtil tipOneMessage:@"已经提交审核后，不能修改" yoffset:TipDefaultYoffset delay:TipErrorDelay];
            return NO;
        }
    }
    
    
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    CGRect r = [textView convertRect:textView.bounds toView:self.scrollView];
    r.origin.y += LCTextKeyboardHeight + 20;
    [self.scrollView scrollRectToVisible:r animated:YES];
    
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [self.view endEditing:YES];
    return YES;
}


@end
