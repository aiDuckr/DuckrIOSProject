//
//  LCGuideIdentityVC.m
//  LinkCity
//
//  Created by roy on 5/9/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCGuideIdentityVC.h"
#import "SZTextView.h"
#import "LCPickOneImageHelper.h"

@interface LCGuideIdentityVC ()<UITextViewDelegate>
//Data
@property (nonatomic, strong) UIImage *pickedGuideLicenseImage;
@property (nonatomic, assign) BOOL isProcessingGuideLicense;
@property (nonatomic, assign) BOOL haveClickedFinishButton;

//UI
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *guideLicenseImageView;
@property (weak, nonatomic) IBOutlet UIButton *guideLicenseButton;
@property (weak, nonatomic) IBOutlet SZTextView *noteTextView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UILabel *failReasonLabel;


@end

@implementation LCGuideIdentityVC


+ (instancetype)createInstance{
    return (LCGuideIdentityVC *)[LCStoryboardManager viewControllerWithFileName:SBNameUserTab identifier:VCIDGuideIdentityVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.isProcessingGuideLicense = NO;
    self.haveClickedFinishButton = NO;
    
    self.scrollView.delegate = self;
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)]];
    self.noteTextView.placeholder = @"输入备注说明";
    self.noteTextView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
    [self updateShow];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self mergeUIBackToDataModel];
}

- (void)refreshData{
    [YSAlertUtil showHudWithHint:nil];
    [LCNetRequester getGuideIdentityInfoWithCallBack:^(LCGuideIdentityModel *guideIdentity, NSError *error) {
        [YSAlertUtil hideHud];
        
        if (error) {
            LCLogWarn(@"getGuideIdentityInfoWithCallBack error:%@",error);
        }else{
            self.guideIdentityModel = guideIdentity;
            [self updateShow];
        }
    }];
}

- (void)updateShow{
    UIImage *placeHolderImage = nil;
    if (self.pickedGuideLicenseImage) {
        placeHolderImage = self.pickedGuideLicenseImage;
    }else{
        placeHolderImage = [UIImage imageNamed:LCDefaultUploadImageName];
    }
    [self.guideLicenseImageView setImageWithURL:[NSURL URLWithString:self.guideIdentityModel.clubPhotoThumbUrl] placeholderImage:placeHolderImage];
    
    self.noteTextView.text = [LCStringUtil getNotNullStr:self.guideIdentityModel.note];

    LCIdentityStatus status = [LCDataManager sharedInstance].userInfo.isTourGuideVerify;
    //update editable
    switch (status) {
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
            self.failReasonLabel.text = [LCStringUtil getNotNullStr:self.guideIdentityModel.reason];
        }
            break;
        case LCIdentityStatus_Done:{
            [self.submitButton setTitle:@"审核通过" forState:UIControlStateNormal];
            self.submitButton.enabled = NO;
            self.failReasonLabel.hidden = YES;
            [self setEditEnable:NO];
            [[LCUIConstants sharedInstance] setButtonAsSubmitButtonDisableStyle:self.submitButton];
        }
            break;
        case LCIdentityStatus_Verifying:{
            [self.submitButton setTitle:@"正在审核" forState:UIControlStateNormal];
            self.failReasonLabel.hidden = YES;
            [self setEditEnable:NO];
        }
            break;
    }
}

- (void)setEditEnable:(BOOL)enable{
    self.guideLicenseButton.enabled = enable;
    self.noteTextView.editable = enable;
    self.submitButton.enabled = enable;
    if (enable) {
        [[LCUIConstants sharedInstance] setButtonAsSubmitButtonEnableStyle:self.submitButton];
    }else{
        [[LCUIConstants sharedInstance] setButtonAsSubmitButtonDisableStyle:self.submitButton];
    }
}

- (void)mergeUIBackToDataModel{
    // merge ui back to data
    self.guideIdentityModel.note = self.noteTextView.text;
}

- (LCGuideIdentityModel *)guideIdentityModel{
    if (!_guideIdentityModel) {
        _guideIdentityModel = [[LCGuideIdentityModel alloc] init];
        _guideIdentityModel.clubPhotoUrl = nil;
        _guideIdentityModel.note = nil;
    }
    return _guideIdentityModel;
}


#pragma mark Button Action

- (void)didTap:(id)sender{
    [self.view endEditing:YES];
}

- (IBAction)guideLicenseButtonAction:(id)sender {
    [[LCPickOneImageHelper sharedInstance] pickImageFromAlbum:YES camera:YES allowEdit:YES completion:^(UIImage *image) {
        if (image) {
            self.isProcessingGuideLicense = YES;
            self.pickedGuideLicenseImage = image;
            self.guideIdentityModel.clubPhotoThumbUrl = nil;
            self.guideIdentityModel.clubPhotoUrl = nil;
            [self.guideLicenseImageView setImageWithURL:nil placeholderImage:self.pickedGuideLicenseImage];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *imageDataToUpload = [LCImageUtil getDataOfCompressImage:image toSize:MAX_IMAGE_SIZE_TO_UPLOAD];
                [LCImageUtil uploadImageDataToQinu:imageDataToUpload imageType:ImageCategoryCarProvider completion:^(NSString *imgUrl) {
                    self.isProcessingGuideLicense = NO;
                    [YSAlertUtil hideHud];
                    
                    if ([LCStringUtil isNullString:imgUrl]) {
                        LCLogWarn(@"upload image failed");
                    }else{
                        self.guideIdentityModel.clubPhotoUrl = imgUrl;
                        LCLogInfo(@"Finish Upload Image: %@",imgUrl);
                    }
                    if (self.haveClickedFinishButton) {
                        [self submitButtonAction:nil];
                    }
                }];
            });
        }
    }];
}

- (IBAction)submitButtonAction:(id)sender {
    self.haveClickedFinishButton = YES;
    [self mergeUIBackToDataModel];
    
    if (![self checkInput]) {
        return;
    }
    
    self.haveClickedFinishButton = NO;
    LCLogInfo(@"do submit identity guide");
    [LCNetRequester guideIdentityWith:self.guideIdentityModel callBack:^(LCGuideIdentityModel *guideIdentity, LCUserModel *user, NSError *error) {
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipDefaultDelay];
        }else{
            self.guideIdentityModel = guideIdentity;
            [LCDataManager sharedInstance].userInfo = user;
            [[LCDataManager sharedInstance] saveData];
            [self updateShow];
            
            [YSAlertUtil tipOneMessage:@"提交审核成功，正在等待管理员审核" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}


- (BOOL)checkInput{
    self.haveClickedFinishButton = NO;
    
    if (!self.isProcessingGuideLicense && [LCStringUtil isNullString:self.guideIdentityModel.clubPhotoUrl]) {
        [YSAlertUtil tipOneMessage:@"请上传领队认证照片" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
        return NO;
    }
    
    if (self.isProcessingGuideLicense) {
        self.haveClickedFinishButton = YES;
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

#pragma mark TextView Delegate
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [self.view endEditing:YES];
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    CGRect r = [textView convertRect:textView.bounds toView:self.scrollView];
    r.origin.y += LCTextKeyboardHeight + 20;
    [self.scrollView scrollRectToVisible:r animated:YES];
    
    return YES;
}

@end
