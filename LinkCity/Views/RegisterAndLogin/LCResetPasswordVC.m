//
//  LCResetPasswordVC.m
//  LinkCity
//
//  Created by roy on 11/10/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCResetPasswordVC.h"
#import "LCRegisterApi.h"
#import "YSAlertUtil.h"

@interface LCResetPasswordVC ()<LCRegisterApiDelegate>
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UITextField *repeatPasswordText;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *backToLoginButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation LCResetPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView.scrollEnabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

//Override
- (void)tapped:(id)sender{
    [self.passwordText resignFirstResponder];
    [self.repeatPasswordText resignFirstResponder];
}

- (IBAction)doneButtonClick:(id)sender {
    if ([self verfiyInput]) {
        [self doResetPassword];
    }
}
- (IBAction)backToLoginButtonClick:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (BOOL)verfiyInput{
    NSString *password = self.passwordText.text;
    NSString *repeatPassword = self.repeatPasswordText.text;
    if (!password || password.length<PASSWORD_MINIMAL_LENGTH) {
        [YSAlertUtil alertOneMessage:@"密码最少4位"];
        return NO;
    }
    
    if (![password isEqualToString:repeatPassword]) {
        [YSAlertUtil alertOneMessage:@"两次输入密码不一致"];
        return NO;
    }
    
    return YES;
}
- (void)doResetPassword{
    [self showHudInView:self.view hint:nil];
    LCRegisterApi *registerApi = [[LCRegisterApi alloc]init];
    registerApi.delegate = self;
    [registerApi resetPassword:self.phoneNumber
                      authCode:self.authCode
                      password:self.passwordText.text];
}

#pragma mark - LCRegisterApiDelegate
- (void)registerApi:(LCRegisterApi *)registerApi resetPasswordUser:(LCUserInfo *)userInfo withError:(NSError *)error{
    [self hideHudInView];
    if (error) {
        [YSAlertUtil tipOneMessage:error.domain delay:TIME_FOR_ERROR_TIP];
    }else{
        [YSAlertUtil tipOneMessage:@"修改密码成功" delay:TIME_FOR_RIGHT_TIP];
        [[LCDataManager sharedInstance] setUserInfo:userInfo];
        [[LCDataManager sharedInstance]saveData];
        [[NSNotificationCenter defaultCenter]postNotificationName:NotificationUserJustLogin object:nil];
        [[LCSharedFuncUtil getAppContentVC] hideCurrentPageWithAnimation:YES];
    }
}

@end
