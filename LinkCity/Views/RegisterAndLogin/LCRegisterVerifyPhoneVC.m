//
//  LCRegisterVerifyPhoneVC.m
//  LinkCity
//
//  Created by roy on 11/10/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCRegisterVerifyPhoneVC.h"
#import "LCRegisterApi.h"
#import "YSAlertUtil.h"
#import "LCRegisterInfoVC.h"
#import "LCResetPasswordVC.h"
#import "LCViewSwitcher.h"
#import "LCPhoneUtil.h"

#define INTERVAL_FOR_SEND_AUTHCODE 60
#define AUTHCODE_BUTTON_ENABLE_TITTLE @"获取验证码"
#define AUTHCODE_BUTTON_DISABLE_TITTLE @"重新获取"

@interface LCRegisterVerifyPhoneVC ()<UITextFieldDelegate,LCRegisterApiDelegate>


@property (weak, nonatomic) IBOutlet UILabel *titleText;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberText;
@property (weak, nonatomic) IBOutlet UIButton *getAuthCodeButton;
@property (weak, nonatomic) IBOutlet UITextField *authCodeText;
@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;

@property (weak, nonatomic) IBOutlet UIView *haveAccountButtonHolder;
@property (weak, nonatomic) IBOutlet UIButton *haveAccountButton;
@property (weak, nonatomic) IBOutlet UIButton *backToLoginButton;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic,strong) NSMutableDictionary *authCodes;

@property (weak, nonatomic) IBOutlet UIButton *userPolicyButton;

@end

@implementation LCRegisterVerifyPhoneVC

static NSInteger countDownTime;

- (void)viewDidLoad {
    [super viewDidLoad];

    //init scroll view
    [self.scrollView setScrollEnabled:NO];
    
    //init textField
    self.phoneNumberText.delegate = self;
    self.authCodeText.delegate = self;
    
    //init for Authcode
    self.authCodes = [[NSMutableDictionary alloc]initWithCapacity:0];
    [self resetAuthcodeButtonState];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.verifyPhoneType == VerifyPhoneTypeRegister) {
        self.titleText.text = @"注册Duckr";
        self.haveAccountButtonHolder.hidden = NO;
        self.haveAccountButton.hidden = NO;
        self.backToLoginButton.hidden = YES;
    }else if(self.verifyPhoneType == VerifyPhoneTypeResetPassword){
        self.titleText.text = @"忘记密码?";
        self.haveAccountButtonHolder.hidden = YES;
        self.haveAccountButton.hidden = YES;
        self.backToLoginButton.hidden = NO;
    }
    [self resetAuthcodeButtonState];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self resetAuthcodeButtonState];
    
    [super viewWillDisappear:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"SegueToRegisterInfo"] &&
        [segue.destinationViewController isKindOfClass:[LCRegisterInfoVC class]]) {
        
        //If push to LCRegisterInfoVC, send data to it
        LCRegisterInfoVC *registerInfoVC = (LCRegisterInfoVC *)[segue destinationViewController];
        registerInfoVC.phoneNumber = self.phoneNumberText.text;
        registerInfoVC.authCode = self.authCodeText.text;
    }else if([segue.identifier isEqualToString:@"SegueToResetPassword"] &&
             [segue.destinationViewController isKindOfClass:[LCResetPasswordVC class]]){
        
        //If push to LCResetPasswordVC, send data to it
        LCResetPasswordVC *resetPasswordVC = (LCResetPasswordVC *)[segue destinationViewController];
        resetPasswordVC.phoneNumber = self.phoneNumberText.text;
        resetPasswordVC.authCode = self.authCodeText.text;
    }
}

- (void)tapped:(id)sender{
    [self dismissKeyboard];
}
- (IBAction)panAction:(id)sender {
    [self dismissKeyboard];
}


- (IBAction)getVerifyCodeButtonClick:(id)sender {
    [self dismissKeyboard];
    NSString *phoneText = self.phoneNumberText.text;
    if (!phoneText || [LCStringUtil isNullString:phoneText] || ![LCPhoneUtil isPhoneNum:phoneText]) {
        [YSAlertUtil alertOneMessage:@"请输入正确的手机号"];
    }else{
        LCRegisterApi *registerApi = [[LCRegisterApi alloc]init];
        registerApi.delegate = self;
        [registerApi sendAuthCodeToPhone:phoneText type:self.verifyPhoneType];
        
        [self startCountDown];
    }
}

- (IBAction)nextStepButtonClick:(id)sender {
//    
//    [self performSegueWithIdentifier:@"SegueToRegisterInfo" sender:self];
//    return;
    
    [self dismissKeyboard];
    NSString *authCode = self.authCodeText.text;
    if ([LCStringUtil isNullString:authCode]) {
        //用户未输入验证码
        [YSAlertUtil alertOneMessage:@"请输入验证码"];
    }else{
        //用户已输入验证码
        for (NSDate *d in [self.authCodes allKeys]){
            LCAuthCode *a = [self.authCodes objectForKey:d];
            NSTimeInterval t = [d timeIntervalSinceNow];
            t = 0-t;
            //RLog(@"timeInterval:%f, authcode:%ld",t,(long)[a getIntegerAuthcode]);
            if (t>0 && t<[a getIntegerExpireTime]) {
                //验证码在有效期内
                if ([authCode isEqualToString:a.authCode]) {
                    //匹配
                    [self resetAuthcodeButtonState];
                    
                    if (self.verifyPhoneType == VerifyPhoneTypeRegister) {
                        [self performSegueWithIdentifier:@"SegueToRegisterInfo" sender:self];
                    }else if(self.verifyPhoneType == VerifyPhoneTypeResetPassword){
                        [self performSegueWithIdentifier:@"SegueToResetPassword" sender:self];
                    }
                    return;
                }else{
                    //不匹配
                    
                }
            }else{
                //验证码过期
                [self.authCodes removeObjectForKey:d];
            }
        }
        
        //未与任何验证码匹配
        [YSAlertUtil alertOneMessage:@"请输入正确的验证码"];
    }
}

- (IBAction)haveAccountButtonClick:(id)sender {
    [self dismissKeyboard];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)backToLoginButtonClick:(id)sender {
    [self dismissKeyboard];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)userPolicyButtonClick:(id)sender {
    [LCViewSwitcher presentWebVCtoShowURL:@"http://duckr.linkcity.cc/web/user/policy/" withTitle:@"用户协议"];
}



- (void)dismissKeyboard{
    [self.phoneNumberText resignFirstResponder];
    [self.authCodeText resignFirstResponder];
}


#pragma mark - LCRegisterApiDelegate
- (void)registerApi:(LCRegisterApi *)registerApi sendAuthcode:(LCAuthCode *)authCode withError:(NSError *)error{
    if (error) {
        [YSAlertUtil tipOneMessage:error.domain delay:TIME_FOR_ERROR_TIP];
        [self resetAuthcodeButtonState];
    }else{
        RLog(@"time:%ld, code:%ld",(long)[authCode getIntegerExpireTime],(long)[authCode getIntegerAuthcode]);
        [self.authCodes setObject:authCode forKey:[NSDate date]];
    }
}


#pragma mark - CountDown & Button state
- (void)resetAuthcodeButtonState{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startCountDown) object:nil];
    countDownTime = INTERVAL_FOR_SEND_AUTHCODE;
    [self setAuthcodeButtonEnable];
}
- (void)setAuthcodeButtonEnable{
    [self.getAuthCodeButton setEnabled:YES];
    self.getAuthCodeButton.alpha = 1.0;
    [self.getAuthCodeButton setTitle:AUTHCODE_BUTTON_ENABLE_TITTLE forState:UIControlStateNormal];
}
- (void)startCountDown{
    countDownTime--;
    if (countDownTime > 0) {
        [self.getAuthCodeButton setEnabled:NO];
        self.getAuthCodeButton.alpha = 0.5;
        [self.getAuthCodeButton setTitle:[NSString stringWithFormat:@"%@(%ld)",AUTHCODE_BUTTON_DISABLE_TITTLE,(long)countDownTime] forState:UIControlStateNormal];
        //have to do this for iOS7.   Doesn't setNeedsLayout mannually for iOS8 to update title.
        [self.getAuthCodeButton setNeedsLayout];
        [self performSelector:@selector(startCountDown) withObject:nil afterDelay:1];
    }else{
        [self resetAuthcodeButtonState];
    }
}

@end
