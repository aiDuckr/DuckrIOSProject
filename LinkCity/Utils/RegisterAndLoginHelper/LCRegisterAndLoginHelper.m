//
//  LCRegisterAndLoginHelper.m
//  LinkCity
//
//  Created by roy on 2/9/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCRegisterAndLoginHelper.h"
#import "LinkCity-Swift.h"
#import "LCProvincePickerVC.h"
#import "LCSchoolPickerVC.h"
#import "LCChooseProfessionVC.h"

typedef enum : NSUInteger {
    WorkModeUnknown,
    WorkModeRegister,
    WorkModeLogin,
    WorkModeResetPassword,
} WorkMode;



@interface LCRegisterAndLoginHelper()<LCProvincePickerDelegate,LCSchoolPickerVCDelegate,LCChooseProfessionVCDelegate>
@property (nonatomic, assign) WorkMode workMode;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSMutableDictionary *authCodes;    //key:authCodeDate   value:string,authCode
@property (nonatomic, strong) NSString *authCode;   //经用户输入，验证后正确的验证码

@end
@implementation LCRegisterAndLoginHelper

+ (instancetype)sharedInstance{
    static LCRegisterAndLoginHelper *staticInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticInstance = [[LCRegisterAndLoginHelper alloc] init];
    });
    return staticInstance;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        self.dimmedMaskAlpha = LCAlertViewMaskAlpha;
        self.authCodes = [[NSMutableDictionary alloc]initWithCapacity:0];
        self.workMode = WorkModeUnknown;
    }
    return self;
}

- (void)startRegister{
    [self startRegisterWithDelegate:nil];
}
- (void)startRegisterWithDelegate:(id<LCRegisterAndLoginHelperDelegate>)delegate{
    self.delegate = delegate;
    self.workMode = WorkModeUnknown;

    //Roy 2015.5.23
    //如果已经在显示注册登录流程，则不显示
    //防止同时点两个按钮都触发PopUp
    if (self.startViewPopup &&
        (self.startViewPopup.isBeingShown || self.startViewPopup.isShowing)) {
        return;
    }
    
    [self showNewRegisterStartView];
}
- (void)startLoginWithDelegate:(id<LCRegisterAndLoginHelperDelegate>)delegate{
    self.delegate = delegate;
    self.workMode = WorkModeLogin;
    [self showNewLoginView];
}

- (BOOL)verifyAuthCode:(NSString *)code{
    BOOL ret = NO;
    for (NSDate *d in [self.authCodes allKeys]){
        LCAuthCode *a = [self.authCodes objectForKey:d];
        NSTimeInterval t = [d timeIntervalSinceNow];
        t = 0-t;
        
        if (t>0 && t<a.expireTime) {
            //验证码在有效期内
            if ([code isEqualToString:a.authCode]) {
                //匹配
                ret = YES;
                break;
            }else{
                //不匹配
            }
        }else{
            //验证码过期
            //[self.authCodes removeObjectForKey:d];
        }
    }
    
    return ret;
}


#pragma mark -
#pragma mark LCRegistarStartView Delegate
- (void)registerStartViewDidCancel:(LCRegisterStartView *)registerStartView{
    [self.startViewPopup dismissPresentingPopup];
    if ([self.delegate respondsToSelector:@selector(registerAndLoginHelperDidCancel)]) {
        [self.delegate registerAndLoginHelperDidCancel];
    }
}
- (void)registerStartViewDidChooseRegister:(LCRegisterStartView *)registerStartView{
    [self.startViewPopup dismissPresentingPopup];
    self.workMode = WorkModeRegister;
    [self showNewInputPhoneAndPasswordView];
}
- (void)registerStartViewDidChooseLogin:(LCRegisterStartView *)registerStartView{
    [self.startViewPopup dismissPresentingPopup];
    self.workMode = WorkModeLogin;
    [self showNewLoginView];
}

#pragma mark LCInputPhoneAndPasswordView Delegate
- (void)inputPhoneAndPasswordViewDidCancel:(LCInputPhoneAndPasswordView *)inputView{
    [self.inputPhoneAndPasswordPopup dismissPresentingPopup];
    if ([self.delegate respondsToSelector:@selector(registerAndLoginHelperDidCancel)]) {
        [self.delegate registerAndLoginHelperDidCancel];
    }
}
- (void)inputPhoneAndPasswordView:(LCInputPhoneAndPasswordView *)inputView
         didClickNextWithPhoneNum:(NSString *)phone
                      andPassword:(NSString *)password{
    
    self.phone = phone;
    self.password = password;
    
    [YSAlertUtil showHudWithHint:nil];
    //请求发送验证码
    [LCNetRequester sendAuthCodeToTelephoneForRegister:self.phone callBack:^(LCAuthCode *authCode, NSError *error) {
        [YSAlertUtil hideHud];
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipAboveKeyboardYoffset delay:TipErrorDelay];
        }else{
            LCLogInfo(@"authCode:%@, expireTime:%ld",authCode.authCode,(long)authCode.expireTime);
            [self.authCodes setObject:authCode forKey:[NSDate date]];
            
            [self.inputPhoneAndPasswordPopup dismissPresentingPopup];
            [self showNewInputVerifyCodeViewWithPhone:self.phone];
            
            [self.inputVerifyCodeView startCountDown];//开始倒计时
        }
    }];
}

#pragma mark LCInputVerifyCodeView Delegate
- (void)inputVerifyCodeViewDidClickCancel:(LCInputVerifyCodeView *)verifyCodeView{
    [self.inputVerifyCodePopup dismissPresentingPopup];
    if ([self.delegate respondsToSelector:@selector(registerAndLoginHelperDidCancel)]) {
        [self.delegate registerAndLoginHelperDidCancel];
    }
}
- (void)inputVerifyCodeViewDidClickLastStep:(LCInputVerifyCodeView *)verifyCodeView{
    [self.inputVerifyCodePopup dismissPresentingPopup];
    
    if (self.workMode == WorkModeRegister) {
        [self showInputPhoneAndPasswordView];
    }else if(self.workMode == WorkModeResetPassword){
        [self showInputPhoneView];
    }
}
- (void)inputVerifyCodeViewDidClickResend:(LCInputVerifyCodeView *)verifyCodeView{
    
    void(^didGetAuthCodeCallBack)(LCAuthCode *authCode, NSError *error) = ^(LCAuthCode *authCode, NSError *error){
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipAboveKeyboardYoffset delay:TipErrorDelay];
        }else{
            LCLogInfo(@"authCode:%@, expireTime:%ld",authCode.authCode,(long)authCode.expireTime);
            [self.authCodes setObject:authCode forKey:[NSDate date]];
            [verifyCodeView startCountDown];
        }
    };
    
    //请求发送验证码
    if (self.workMode == WorkModeRegister) {
        [LCNetRequester sendAuthCodeToTelephoneForRegister:self.phone callBack:didGetAuthCodeCallBack];
    }else if(self.workMode == WorkModeResetPassword){
        [LCNetRequester sendAuthCodeToTelephoneForResetPassword:self.phone callBack:didGetAuthCodeCallBack];
    }
}
- (void)inputVerifyCodeView:(LCInputVerifyCodeView *)verifyCodeView askToVerifyCode:(NSString *)code{
    [YSAlertUtil showHudWithHint:nil];
    [LCNetRequester verifyAuthCodeWithTelephone:self.phone authCode:code callBack:^(NSError *error) {
        
        if (!error) {
            //verify succeed!
            self.authCode = code;
            
            if (self.workMode == WorkModeRegister) {
                //注册
                [LCNetRequester registerUserWithTelephone:self.phone password:self.password authCode:self.authCode callBack:^(LCUserModel *user, NSError *error) {
                    [YSAlertUtil hideHud];
                    
                    if (error) {
                        [YSAlertUtil tipOneMessage:error.domain yoffset:TipAboveKeyboardYoffset delay:TipErrorDelay];
                    }else{
                        //注册成功！
                        self.user = user;
                        [LCDataManager sharedInstance].userInfo = user;
                        [[LCDataManager sharedInstance] saveData];
                        [self.inputVerifyCodePopup dismissPresentingPopup];
                        [self showNewRegisterSucceedViewWithCallback:^(LCRegisterSucceedView *succeedView) {
                            [self.registerSucceedPopup dismissPresentingPopup];
                            [self showNewInputUserinfoView];
                        }];
                    }
                }];
            }else if(self.workMode == WorkModeResetPassword){
                [YSAlertUtil hideHud];
                [self.inputVerifyCodePopup dismissPresentingPopup];
                [self showNewResetPasswordView];
            }
        }else{
            [YSAlertUtil hideHud];
            
            //verify failed
            [self.inputVerifyCodePopup dismissPresentingPopup];
            [self showNewErrorTipViewWithTitle:@"错误代码" msg:error.domain btnTitle:@"重新验证" callBack:^(BOOL canceled){
                [self.errorTipPopup dismissPresentingPopup];
                
                if (!canceled) {
                    [self showInputVerifyCodeView];
                }else{
                    if ([self.delegate respondsToSelector:@selector(registerAndLoginHelperDidCancel)]) {
                        [self.delegate registerAndLoginHelperDidCancel];
                    }
                }
            }];
        }
    }];
    
//    if ([self verifyAuthCode:code]) {
//        //验证成功
//        self.authCode = code;
//        
//        if (self.workMode == WorkModeRegister) {
//            [YSAlertUtil showHudWithHint:nil];
//            //注册
//            [LCNetRequester registerUserWithTelephone:self.phone password:self.password authCode:self.authCode callBack:^(LCUserModel *user, NSError *error) {
//                [YSAlertUtil hideHud];
//                
//                if (error) {
//                    [YSAlertUtil tipOneMessage:error.domain yoffset:TipAboveKeyboardYoffset delay:TipErrorDelay];
//                }else{
//                    //注册成功！
//                    self.user = user;
//                    [LCDataManager sharedInstance].userInfo = user;
//                    [self.inputVerifyCodePopup dismissPresentingPopup];
//                    [self showNewRegisterSucceedViewWithCallback:^(LCRegisterSucceedView *succeedView) {
//                        [self.registerSucceedPopup dismissPresentingPopup];
//                        [self showNewInputUserinfoView];
//                    }];
//                }
//            }];
//        }else if(self.workMode == WorkModeResetPassword){
//            [self.inputVerifyCodePopup dismissPresentingPopup];
//            [self showNewResetPasswordView];
//        }
//        
//    }else{
//        //不匹配
//        [self.inputVerifyCodePopup dismissPresentingPopup];
//        [self showNewErrorTipViewWithTitle:@"错误代码" msg:@"呃，你们未能辩认您输入的验证码" btnTitle:@"重新验证" callBack:^(BOOL canceled){
//            [self.errorTipPopup dismissPresentingPopup];
//            
//            if (!canceled) {
//                [self showInputVerifyCodeView];
//            }else{
//                if ([self.delegate respondsToSelector:@selector(registerAndLoginHelperDidCancel)]) {
//                    [self.delegate registerAndLoginHelperDidCancel];
//                }
//            }
//        }];
//    }
}

#pragma mark LCInputUserinfoView Delegate
- (void)inputUserinfoViewDidClickLivingPlaceButton:(LCInputUserinfoView *)inputUserinfoView{
    [self.inputUserinfoPopup dismissPresentingPopup];
    [self showProvincePicker];
}
- (void)inputUserinfoViewDidClickCancel:(LCInputUserinfoView *)inputUserinfoView{
    [self.inputUserinfoPopup dismissPresentingPopup];
    if ([self.delegate respondsToSelector:@selector(registerAndLoginHelperDidCancel)]) {
        [self.delegate registerAndLoginHelperDidCancel];
    }
}

- (void)inputUserinfoView:(LCInputUserinfoView *)inputUserinfoView didUpdateUserinfo:(LCUserModel *)user {
    [self.inputUserinfoPopup dismissPresentingPopup];
    //填写昵称、生日、性别、头像
    [self showNewInputSchoolView:user];
}

- (void)inputUserinfoViewDidClickPass:(LCInputUserinfoView *)inputUserinfoView{
    [self.inputUserinfoPopup dismissPresentingPopup];
    if ([self.delegate respondsToSelector:@selector(registerAndLoginhelperDidLogin)]) {
        [self.delegate registerAndLoginhelperDidLogin];
    }
}

#pragma mark LCInputSchoolAndHometownView Delegate
- (void)inputSchoolAndHometownViewDidClickPass:(LCInputSchoolAndHometownView *)inputSchoolAndHometownView{
    [self.inputSchoolinfoPopup dismissPresentingPopup];
    if ([self.delegate respondsToSelector:@selector(registerAndLoginhelperDidLogin)]) {
        [self.delegate registerAndLoginhelperDidLogin];
    }
}

- (void)inputSchoolAndHometownViewDidClickCancel:(LCInputSchoolAndHometownView *)inputSchoolAndHometownView{
    [self.inputSchoolinfoPopup dismissPresentingPopup];
    if ([self.delegate respondsToSelector:@selector(registerAndLoginHelperDidCancel)]) {
        [self.delegate registerAndLoginHelperDidCancel];
    }
}
//完成学校行业
- (void)inputSchoolAndHometownView:(LCInputSchoolAndHometownView *)inputSchoolAndHometownView didUpdateinfo:(LCUserModel *)user {
    
    [self.inputSchoolinfoPopup dismissPresentingPopup];
    
    self.user = user;
    [LCDataManager sharedInstance].userInfo = user;
    [[LCDataManager sharedInstance] saveData];
    //填写昵称、生日、性别、头像
    [self showNewRegisterFinishViewWithUser:user];
}

- (void)inputUserinfoViewDidClickHomeButton:(LCInputSchoolAndHometownView *)inputSchoolAndHometownView {
    [self.inputSchoolinfoPopup dismissPresentingPopup];
    [self showProvincePicker];
}

- (void)inputUserinfoViewDidClickSchoolButton:(LCInputSchoolAndHometownView *)inputSchoolAndHometownView {
    [self.inputSchoolinfoPopup dismissPresentingPopup];
    [self showSchoolPicker];
}

- (void)inputUserinfoViewDidClickTradeButton:(LCInputSchoolAndHometownView *)inputSchoolAndHometownView {
    [self.inputSchoolinfoPopup dismissPresentingPopup];
    [self showTradePicker];
}

#pragma mark LCRegisterFinishView Delegate
- (void)registerFinishViewDidSubmit:(LCRegisterFinishView *)finishView{
    [self.registerFinishPopup dismissPresentingPopup];
    if ([self.delegate respondsToSelector:@selector(registerAndLoginhelperDidLogin)]) {
        [self.delegate registerAndLoginhelperDidLogin];
    }
    
    //显示推荐关注用户的列表
    [LCViewSwitcher presentToShowRecommendUserAfterRegister];
}
- (void)registerFinishViewDidSkip:(LCRegisterFinishView *)finishView{
    [self.registerFinishPopup dismissPresentingPopup];
    if ([self.delegate respondsToSelector:@selector(registerAndLoginhelperDidLogin)]) {
        [self.delegate registerAndLoginhelperDidLogin];
    }
}

#pragma mark LCLoginView Delegate
- (void)loginViewDidCancel:(LCLoginView *)loginView{
    [self.loginPopup dismissPresentingPopup];
    if ([self.delegate respondsToSelector:@selector(registerAndLoginHelperDidCancel)]) {
        [self.delegate registerAndLoginHelperDidCancel];
    }
}
- (void)loginViewDidClickForgetPassword:(LCLoginView *)loginView{
    [self.loginPopup dismissPresentingPopup];
    self.workMode = WorkModeResetPassword;
    [self showNewInputPhoneView];
}
- (void)loginViewDidClickLogin:(LCLoginView *)loginView withPhone:(NSString *)phone password:(NSString *)password{
    self.workMode = WorkModeLogin;
    
    [YSAlertUtil showHudWithHint:nil];
    [LCNetRequester loginWithPhone:phone password:password callBack:^(LCUserModel *user, NSError *error) {
        [YSAlertUtil hideHud];
        
        if (error) {
            [self.loginPopup dismissPresentingPopup];
            [self showNewErrorTipViewWithTitle:@"账户问题" msg:error.domain btnTitle:@"好的" callBack:^(BOOL canceled) {
                [self.errorTipPopup dismissPresentingPopup];
                
                if (!canceled) {
                    [self showLoginView];
                }else{
                    if ([self.delegate respondsToSelector:@selector(registerAndLoginHelperDidCancel)]) {
                        [self.delegate registerAndLoginHelperDidCancel];
                    }
                }
            }];
        }else{
            self.user = user;
            [LCDataManager sharedInstance].userInfo = user;
            [[LCDataManager sharedInstance] saveData];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUserJustLogin object:nil];
            
            [self.loginPopup dismissPresentingPopup];
            [YSAlertUtil tipOneMessage:@"登录成功!" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
            
            if ([self.delegate respondsToSelector:@selector(registerAndLoginhelperDidLogin)]) {
                [self.delegate registerAndLoginhelperDidLogin];
            }
        }
    }];
}
#pragma mark LCInputPhoneView Delegate
- (void)inputPhoneViewDidCancel:(LCInputPhoneView *)phoneView{
    [self.inputPhonePopup dismissPresentingPopup];
    if ([self.delegate respondsToSelector:@selector(registerAndLoginHelperDidCancel)]) {
        [self.delegate registerAndLoginHelperDidCancel];
    }
}
- (void)inputPhoneViewDidClickNext:(LCInputPhoneView *)phoneView withPhone:(NSString *)phone{
    self.phone = phone;
    
    [YSAlertUtil showHudWithHint:nil];
    //请求发送验证码
    [LCNetRequester sendAuthCodeToTelephoneForResetPassword:self.phone callBack:^(LCAuthCode *authCode, NSError *error) {
        [YSAlertUtil hideHud];
        
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipAboveKeyboardYoffset delay:TipErrorDelay];
        }else{
            LCLogInfo(@"authCode:%@, expireTime:%ld",authCode.authCode,(long)authCode.expireTime);
            [self.authCodes setObject:authCode forKey:[NSDate date]];
            
            [self.inputPhonePopup dismissPresentingPopup];
            [self showNewInputVerifyCodeViewWithPhone:self.phone];
            
            [self.inputVerifyCodeView startCountDown];
        }
    }];
}
#pragma mark LCResetPasswordView Delegate
- (void)resetPasswordViewDidCancel:(LCResetPasswordView *)resetPasswordView{
    [self.resetPasswordPopup dismissPresentingPopup];
    if ([self.delegate respondsToSelector:@selector(registerAndLoginHelperDidCancel)]) {
        [self.delegate registerAndLoginHelperDidCancel];
    }
}
- (void)resetPasswordViewDidSubmit:(LCResetPasswordView *)resetPasswordView withPassword:(NSString *)password{
    self.password = password;
    
    [YSAlertUtil showHudWithHint:nil];
    [LCNetRequester resetPasswordWithTelephone:self.phone password:self.password authCode:self.authCode callBack:^(LCUserModel *user, NSError *error) {
        [YSAlertUtil hideHud];
        
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipAboveKeyboardYoffset delay:TipErrorDelay];
        }else{
            self.user = user;
            [LCDataManager sharedInstance].userInfo = user;
            [[LCDataManager sharedInstance] saveData];
    
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUserJustResetPassword object:nil];
            [self.resetPasswordPopup dismissPresentingPopup];
            [YSAlertUtil tipOneMessage:@"重置密码成功" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
            
            if ([self.delegate respondsToSelector:@selector(registerAndLoginhelperDidLogin)]) {
                [self.delegate registerAndLoginhelperDidLogin];
            }
        }
    }];
}



#pragma mark ProvincePicker
- (void)showProvincePicker{
    LCProvincePickerVC *provincePicker = [LCProvincePickerVC createInstance];
    provincePicker.delegate = self;
    [[LCSharedFuncUtil getTopMostViewController] presentViewController:[[UINavigationController alloc] initWithRootViewController:provincePicker] animated:YES completion:nil];
}
- (void)provincePicker:(LCProvincePickerVC *)provincePickerVC didSelectProvince:(NSString *)provinceName didSelectCity:(LCCityModel *)city {
    if (provincePickerVC.navigationController) {
        [provincePickerVC.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    //存储
    
    self.user.livingPlace= city.cityName;
    [self showNewInputSchoolView:self.user];
}

#pragma mark SchoolPicker
- (void)showSchoolPicker{
    LCSchoolPickerVC *schoolPicker = [LCSchoolPickerVC createInstance];
    schoolPicker.delegate = self;
    [[LCSharedFuncUtil getTopMostViewController] presentViewController:[[UINavigationController alloc] initWithRootViewController:schoolPicker] animated:YES completion:nil];
}
- (void)schoolPickerVC:(LCSchoolPickerVC *)schoolPickerVC didPickSchool:(NSString *)school {
    if (schoolPickerVC.navigationController) {
        [schoolPickerVC.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    //存储
    self.user.school= school;
    [self showNewInputSchoolView:self.user];
}

#pragma mark TradePicker
- (void)showTradePicker{
    LCChooseProfessionVC *tradePicker = [LCChooseProfessionVC createInstance];
    tradePicker.delegate = self;
    [[LCSharedFuncUtil getTopMostViewController] presentViewController:[[UINavigationController alloc] initWithRootViewController:tradePicker] animated:YES completion:nil];
}

- (void)chooseProfessionVC:(LCChooseProfessionVC *)chooseProfessionVC didChooseProfession:(NSString *)pro {
    if (chooseProfessionVC.navigationController) {
        [chooseProfessionVC.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    //存储
    self.user.professional= pro;
    [self showNewInputSchoolView:self.user];
}

@end
