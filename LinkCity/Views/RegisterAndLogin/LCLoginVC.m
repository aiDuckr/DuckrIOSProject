//
//  LCLoginVC.m
//  LinkCity
//
//  Created by roy on 11/10/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCLoginVC.h"
#import "LCLoginApi.h"
#import "YSAlertUtil.h"
#import "LCPhoneUtil.h"
#import "LCRegisterVerifyPhoneVC.h"
#import "LCSlideVC.h"

@interface LCLoginVC ()<LCLoginApiDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *lostPasswordButton;

@end

@implementation LCLoginVC

+ (UINavigationController *)createInstance{
    return (UINavigationController *)[LCStoryboardManager viewControllerWithFileName:SBNameRegisterAndLogin identifier:VCIDRegisterAndLoginNavigation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (NO == [LCDataManager sharedInstance].isHaveRegister) {
        ZLog(@"come in to register...");
        [self performSegueWithIdentifier:@"SegueToRegister" sender:self];
    }
    
    //init scroll view
    [self.scrollView setScrollEnabled:NO];
    
    //init textField
    self.phoneNumberText.delegate = self;
    self.passwordText.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.destinationViewController isKindOfClass:[LCRegisterVerifyPhoneVC class]]) {
        LCRegisterVerifyPhoneVC *verifyVC = (LCRegisterVerifyPhoneVC *)segue.destinationViewController;
        if (sender == self.registerButton) {
            //点加入Ducker按钮，进行注册流程
            verifyVC.verifyPhoneType = VerifyPhoneTypeRegister;
        }else if(sender == self.lostPasswordButton){
            //点忘记密码，进行重置密码流程
            verifyVC.verifyPhoneType = VerifyPhoneTypeResetPassword;
        } else if (sender == self) {
            verifyVC.verifyPhoneType = VerifyPhoneTypeRegister;
        }
    }
}

//Override
- (void)tapped:(id)sender{
    [self dismissKeyboard];
}

- (IBAction)loginButtonClick:(id)sender {
    [self dismissKeyboard];
    if ([self checkInput]) {
        [self doLogin];
    }
}

- (void)dismissKeyboard{
    [self.phoneNumberText resignFirstResponder];
    [self.passwordText resignFirstResponder];
}

- (BOOL)checkInput{
    NSString *phoneNo = self.phoneNumberText.text;
    NSString *password = self.passwordText.text;
    NSString *errorMsg = nil;
    if (!phoneNo || phoneNo.length!=11 || ![LCPhoneUtil isPhoneNum:phoneNo]) {
        errorMsg = @"请输入正确的手机号";
    }else if(!password || password.length == 0){
        errorMsg = @"请输入正确的密码";
    }
    
    if (errorMsg) {
        [YSAlertUtil tipOneMessage:errorMsg delay:TIME_FOR_ERROR_TIP];
        return NO;
    }else{
        return YES;
    }
}

- (void)doLogin{
    [self showHudInView:self.view hint:nil];
    LCLoginApi *loginAPI = [[LCLoginApi alloc]init];
    loginAPI.delegate = self;
    [loginAPI loginWithPhoneNumber:self.phoneNumberText.text andPassword:self.passwordText.text];
}

#pragma mark - LoginApi Delegate
- (void)loginApi:(LCLoginApi *)loginApi loginWithError:(NSError *)error userInfo:(LCUserInfo *)userInfo{
    [self hideHudInView];
    if (error) {
        RLog(@"LoginError: %@",error);
        [YSAlertUtil tipOneMessage:error.domain delay:TIME_FOR_ERROR_TIP];
    }else{
        RLog(@"LoginSucceed with userinfo:%@",userInfo);
        [YSAlertUtil tipOneMessage:@"登录成功" delay:TIME_FOR_RIGHT_TIP];
        [LCDataManager sharedInstance].isHaveRegister = YES;
        [[LCDataManager sharedInstance] setUserInfo:userInfo];
        [[LCDataManager sharedInstance] saveData];
        [[NSNotificationCenter defaultCenter]postNotificationName:NotificationUserJustLogin object:nil];
        [[LCSharedFuncUtil getAppContentVC] hideCurrentPageWithAnimation:YES];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isEqual:self.passwordText]) {
        [self dismissKeyboard];
        if ([self checkInput]) {
            [self doLogin];
        }
    }
    return YES;
}

@end
