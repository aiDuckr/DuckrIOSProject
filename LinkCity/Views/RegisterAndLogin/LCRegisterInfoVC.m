//
//  LCRegisterInfoVC.m
//  LinkCity
//
//  Created by roy on 11/10/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCRegisterInfoVC.h"
#import "YSAlbumImageView.h"
#import "YSAlertUtil.h"
#import "LCRegisterApi.h"

#define SEX_MALE_STR @"1"
#define SEX_FEMALE_STR @"2"

@interface LCRegisterInfoVC ()<YSAlbumImageViewDelegate,LCRegisterApiDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *usernameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet YSAlbumImageView *addPhotoImageView;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *haveAccountButton;

@property (weak, nonatomic) IBOutlet UIView *sexChoiceBgView;
@property (weak, nonatomic) IBOutlet UIButton *maleButton;
@property (weak, nonatomic) IBOutlet UIButton *femaleButton;

@property (nonatomic, strong) NSString *currentSex;

/** If want to request server to do request now, but the avatar image haven't upload,
        we have a blocked resgister request.
    Do request once upload avatar finished.
 */
@property (nonatomic, assign) BOOL haveBlockedRegisterRequest;
@end

@implementation LCRegisterInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //init scrollView
    self.scrollView.scrollEnabled = NO;
    
    //init YSAlbumImageView
    self.addPhotoImageView.albumDelegate = self;
    self.addPhotoImageView.imageCategory = ImageCategoryAvatar;
    
    //init sexChoice bg view
    self.sexChoiceBgView.layer.borderColor = UIColorFromR_G_B_A(239, 239, 239, 1).CGColor;
    self.sexChoiceBgView.layer.borderWidth = 1.0;
    self.sexChoiceBgView.layer.cornerRadius = 3;
    
    self.currentSex = SEX_MALE_STR;
    
    self.haveBlockedRegisterRequest = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

//Override
- (void)tapped:(id)sender{
    [self dismissKeyboard];
}

- (void)dismissKeyboard{
    [self.usernameText resignFirstResponder];
    [self.passwordText resignFirstResponder];
}


- (IBAction)doneButtonClick:(id)sender {
    [self dismissKeyboard];
    if ([self verfiyInput]) {
        [self doRegister];
    }
}
- (IBAction)haveAccountButtonClick:(id)sender {
    [self dismissKeyboard];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)maleButtonClick:(UIButton *)sender {
    [self dismissKeyboard];
    [self setSexButton:self.maleButton selected:YES];
    [self setSexButton:self.femaleButton selected:NO];
    self.currentSex = SEX_MALE_STR;
}
- (IBAction)femaleButtonClick:(UIButton *)sender {
    [self dismissKeyboard];
    [self setSexButton:self.maleButton selected:NO];
    [self setSexButton:self.femaleButton selected:YES];
    self.currentSex = SEX_FEMALE_STR;
}
- (IBAction)cancelButtonClick:(id)sender {
    [self dismissKeyboard];
    [[LCSharedFuncUtil getAppContentVC] hideCurrentPageWithAnimation:YES];
}

- (void)setSexButton:(UIButton *)btn selected:(BOOL)selected{
    if (selected) {
        [btn setImage:[UIImage imageNamed:@"RegisterSexSelected"] forState:UIControlStateNormal];
    }else{
        [btn setImage:[UIImage imageNamed:@"RegisterSexUnSelected"] forState:UIControlStateNormal];
    }
}


- (BOOL)verfiyInput{
    NSString *nickName = self.usernameText.text;
    NSString *password = self.passwordText.text;
    if (!nickName || nickName.length<=0) {
        [YSAlertUtil alertOneMessage:@"用户名不能为空"];
        return NO;
    }else if(!password || password.length<PASSWORD_MINIMAL_LENGTH){
        [YSAlertUtil alertOneMessage:@"密码最少4位"];
        return NO;
    }
    
    if (!self.addPhotoImageView.uploadImageURL) {
        [YSAlertUtil alertOneMessage:@"请先上传头像"];
        return NO;
    }
    
    return YES;
}
- (void)doRegister{
    [self showHudInView:self.view hint:nil];
    //如果没上传头像
    if ([LCStringUtil isNullString:self.addPhotoImageView.uploadImageURL]) {
        self.haveBlockedRegisterRequest = YES;
    }else{
        self.haveBlockedRegisterRequest = NO;
        
        LCRegisterApi *registerApi = [[LCRegisterApi alloc]init];
        registerApi.delegate = self;
        NSString *avatarURL = self.addPhotoImageView.uploadImageURL;
        NSString *avatarThumbURL = @""; //不用上传thumb头像，server自动生成
        [registerApi registerWith:self.phoneNumber
                         authCode:self.authCode
                         password:self.passwordText.text
                             nick:self.usernameText.text
                              sex:self.currentSex
                           avatar:avatarURL
                      avatarThumb:avatarThumbURL];
    }
}

#pragma mark - LCRegisterApiDelegate
- (void)registerApi:(LCRegisterApi *)registerApi registeredUser:(LCUserInfo *)userInfo withError:(NSError *)error{
    [self hideHudInView];
    if (error) {
        [YSAlertUtil tipOneMessage:error.domain delay:TIME_FOR_ERROR_TIP];
    }else{
        [YSAlertUtil tipOneMessage:@"注册成功!" delay:TIME_FOR_RIGHT_TIP];
        [LCDataManager sharedInstance].isHaveRegister = YES;
        [[LCDataManager sharedInstance] setUserInfo:userInfo];
        [[LCDataManager sharedInstance] saveData];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUserJustLogin object:nil];
        [[LCSharedFuncUtil getAppContentVC] hideCurrentPageWithAnimation:YES];
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}

#pragma mark - YSAlbumImageView Delegate
- (void)imageViewReadyImage:(UIImage *)image {
    RLog(@"finish compress image");
    self.addPhotoImageView.image = nil;
    self.addPhotoImageView.imageURL = [NSURL URLWithString:@""];
    self.addPhotoImageView.image = image;
}
- (void)imageViewReadyUploadURL:(YSAlbumImageView *)imageView{
    RLog(@"finish upload image %@",imageView.uploadImageURL);
    if (self.haveBlockedRegisterRequest) {
        [self doRegister];
    }
}
@end
