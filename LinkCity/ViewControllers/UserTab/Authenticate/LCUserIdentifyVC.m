//
//  LCUserIdentifyVC.m
//  LinkCity
//
//  Created by roy on 3/12/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCUserIdentifyVC.h"
#import "LCPickOneImageHelper.h"
#import "LCUserServiceVC.h"


@interface LCUserIdentifyVC ()
//Data
@property (nonatomic, assign) BOOL haveClickFinishButton;
@property (nonatomic, assign) BOOL isProcessingImage;
@property (nonatomic, strong) UIImage *pickedImg;

//UI
@property (weak, nonatomic) IBOutlet UITextField *realNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *userIDTextField;

@property (weak, nonatomic) IBOutlet UIButton *exampleButton;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton;
@property (weak, nonatomic) IBOutlet UIImageView *uploadImageView;


@property (weak, nonatomic) IBOutlet UILabel *exampleTipLabel;

@property (weak, nonatomic) IBOutlet UILabel *failReasonLabel;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;


@end

@implementation LCUserIdentifyVC

+ (instancetype)createInstance{
    return (LCUserIdentifyVC *)[LCStoryboardManager viewControllerWithFileName:SBNameUserTab identifier:VCIDUserIdentifyVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.haveClickFinishButton = NO;
    self.isProcessingImage = NO;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    [self.view addGestureRecognizer:tapGesture];
    
    UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBarButtonAction)];
    self.navigationItem.rightBarButtonItem = cancelBarButton;
    
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

- (LCUserIdentityModel *)userIdentityModel{
    if (!_userIdentityModel) {
        _userIdentityModel = [LCUserIdentityModel createEmptyInstance];
    }
    return _userIdentityModel;
}

- (void)refreshData{
    [LCNetRequester getUserIdentityInfoWithCallBack:^(LCUserIdentityModel *userIdentity, NSError *error) {
        if (error) {
            LCLogWarn(@"getUserIdentityInfoWithCallBack error:%@",error);
        }else{
            self.userIdentityModel = userIdentity;
            [self updateShow];
        }
    }];
}

- (void)updateShow{
    if (self.userIdentityModel && self.view) {
        self.realNameTextField.text = [LCStringUtil getNotNullStr:self.userIdentityModel.name];
        self.userIDTextField.text = [LCStringUtil getNotNullStr:self.userIdentityModel.idNumber];
        
        UIImage *placeHolderImage = nil;
        if (self.pickedImg) {
            placeHolderImage = self.pickedImg;
        }else{
            placeHolderImage = [UIImage imageNamed:LCDefaultUploadImageName];
        }
        [self.uploadImageView setImageWithURL:[NSURL URLWithString:self.userIdentityModel.idCardUrl] placeholderImage:placeHolderImage];
        
        switch ([self.userIdentityModel getUserIdentityStatus]) {
            case LCIdentityStatus_None:{
                [self.submitButton setTitle:@"提交审核" forState:UIControlStateNormal];
                [self setEditEnable:YES];
                self.failReasonLabel.hidden = YES;
            }
                break;
            case LCIdentityStatus_Verifying:{
                [self.submitButton setTitle:@"正在审核" forState:UIControlStateNormal];
                [self setEditEnable:NO];
                self.failReasonLabel.hidden = YES;
            }
                break;
            case LCIdentityStatus_Failed:{
                [self.submitButton setTitle:@"重新提交" forState:UIControlStateNormal];
                [self setEditEnable:YES];
                self.failReasonLabel.hidden = NO;
                self.failReasonLabel.text = [LCStringUtil getNotNullStr:self.userIdentityModel.reason];
            }
                break;
            case LCIdentityStatus_Done:{
                [self.submitButton setTitle:@"审核成功" forState:UIControlStateNormal];
                [self setEditEnable:NO];
                self.failReasonLabel.hidden = YES;
            }
                break;
        }
    }
}

- (void)setEditEnable:(BOOL)enable{
    self.realNameTextField.enabled = enable;
    self.userIDTextField.enabled = enable;
    self.uploadButton.enabled = enable;
    self.submitButton.enabled = enable;
    if (enable) {
        [[LCUIConstants sharedInstance] setButtonAsSubmitButtonEnableStyle:self.submitButton];
    }else{
        [[LCUIConstants sharedInstance] setButtonAsSubmitButtonDisableStyle:self.submitButton];
    }
}


- (void)mergeUIBackToDataModel{
    // merge ui back to data
    self.userIdentityModel.name = self.realNameTextField.text;
    self.userIdentityModel.idNumber = self.userIDTextField.text;
}

#pragma mark - ButtonAction
- (void)cancelBarButtonAction{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didTap:(id)sender{
    if (self.isShowingKeyboard) {
        [self.view endEditing:YES];
    }
}
- (IBAction)exampleButtonAction:(id)sender {
    
}
- (IBAction)uploadButtonAction:(id)sender {
    [[LCPickOneImageHelper sharedInstance] pickImageFromAlbum:YES camera:YES allowEdit:YES completion:^(UIImage *image) {
        [self didPickImage:image];
    }];
}
- (IBAction)submitButtonAction:(id)sender {
    self.haveClickFinishButton = YES;
    [self mergeUIBackToDataModel];
    
    // check input
    if (![self checkInput]) {
        return;
    }
    
    self.haveClickFinishButton = NO;
    [LCNetRequester userIdentityWith:self.userIdentityModel callBack:^(LCUserIdentityModel *userIdentity, LCUserModel *user, NSError *error) {
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipDefaultDelay];
        }else{
            self.userIdentityModel = userIdentity;
            [LCDataManager sharedInstance].userInfo = user;
            [[LCDataManager sharedInstance] saveData];
            [self updateShow];
            
            [YSAlertUtil tipOneMessage:@"提交审核成功，正在等待管理员审核" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
            
            //如果是从服务认证页面开始的实名认证，应该弹出到服务认证页面
            if (self.popToVC && [self.navigationController.viewControllers containsObject:self.popToVC]) {
                [self.navigationController popToViewController:self.popToVC animated:YES];
            }else{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
    }];
}

- (BOOL)checkInput{
    
    if ([LCStringUtil isNullString:self.userIdentityModel.name]) {
        [YSAlertUtil tipOneMessage:@"请输入真实姓名" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
        return NO;
    }
    
    if(![LCStringUtil validateIDCardNumber:self.userIdentityModel.idNumber]){
        [YSAlertUtil tipOneMessage:@"请输入正确的身份证号" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
        return NO;
    }
    
    if(self.isProcessingImage) {
        [YSAlertUtil showHudWithHint:nil];
        return NO;
    }
    
    if ([LCStringUtil isNullString:self.userIdentityModel.idCardUrl]) {
        [YSAlertUtil tipOneMessage:@"请上传您的认证照片" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
        return NO;
    }
    
    return YES;
}


- (void)didPickImage:(UIImage *)img{
    if (img) {
        self.isProcessingImage = YES;
        self.pickedImg = img;
        //如果重选了照片，把之前的URL设为空，否则更新显示时去下载之前的图片
        self.userIdentityModel.idCardUrl = nil;
        self.userIdentityModel.idCardThumbUrl = nil;
        [self.uploadImageView setImageWithURL:nil placeholderImage:self.pickedImg];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *imageDataToUpload = [LCImageUtil getDataOfCompressImage:img toSize:MAX_IMAGE_SIZE_TO_UPLOAD];
            [LCImageUtil uploadImageDataToQinu:imageDataToUpload imageType:ImageCategoryIdentity completion:^(NSString *imgUrl) {
                self.isProcessingImage = NO;
                [YSAlertUtil hideHud];
                
                if ([LCStringUtil isNullString:imgUrl]) {
                    LCLogWarn(@"upload image failed");
                }else{
                    //这里都设为url，为了方便上传
                    self.userIdentityModel.idCardUrl = imgUrl;
                    LCLogInfo(@"Finish Upload Image: %@",imgUrl);
                }
                
                //如果已经点过FinishButton，说明在上传图片过程中，用户点过FinishButton
                //现在上传完成了，继续更新用户信息
                if (self.haveClickFinishButton) {
                    [self submitButtonAction:nil];
                }
            }];
        });
    }
}
@end
