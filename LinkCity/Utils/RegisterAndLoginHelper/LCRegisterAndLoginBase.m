//
//  LCRegisterAndLoginBase.m
//  LinkCity
//
//  Created by roy on 3/1/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCRegisterAndLoginBase.h"
#import "LinkCity-Swift.h"

@interface LCRegisterAndLoginBase()<LCRegisterUserInfoViewDelegate>
@end

@implementation LCRegisterAndLoginBase

#pragma mark StartRegister
- (void)showNewRegisterStartView{
    self.startView = [LCRegisterStartView createInstance];
    self.startView.delegate = self;
    
    self.startViewPopup = [KLCPopup popupWithContentView:self.startView
                                                showType:KLCPopupShowTypeBounceInFromTop
                                             dismissType:KLCPopupDismissTypeBounceOutToBottom
                                                maskType:KLCPopupMaskTypeDimmed
                                dismissOnBackgroundTouch:NO
                                   dismissOnContentTouch:NO];
    self.startViewPopup.dimmedMaskAlpha = self.dimmedMaskAlpha;
    
    [self showRegisterStartView];
}
- (void)showRegisterStartView{
    [self.startViewPopup showAtCenter:CGPointMake(DEVICE_WIDTH/2, DEVICE_HEIGHT/2) inView:nil];
}

#pragma mark InputPhoneAndPasswordView
- (void)showNewInputPhoneAndPasswordView{
    self.inputPhoneAndPasswordView = [LCInputPhoneAndPasswordView createInstance];
    self.inputPhoneAndPasswordView.delegate = self;
    
    self.inputPhoneAndPasswordPopup = [KLCPopup popupWithContentView:self.inputPhoneAndPasswordView
                                                            showType:KLCPopupShowTypeBounceInFromTop
                                                         dismissType:KLCPopupDismissTypeBounceOutToBottom
                                                            maskType:KLCPopupMaskTypeDimmed
                                            dismissOnBackgroundTouch:NO
                                               dismissOnContentTouch:NO];
    self.inputPhoneAndPasswordPopup.dimmedMaskAlpha = self.dimmedMaskAlpha;
    
    [self showInputPhoneAndPasswordView];
}
- (void)showInputPhoneAndPasswordView{
    CGFloat topSpace = (DEVICE_HEIGHT - [self.inputPhoneAndPasswordView intrinsicContentSize].height - LCNumKeyboardHeight) / 2;
    topSpace = MAX(topSpace, 4);
    CGFloat centerY = topSpace + [self.inputPhoneAndPasswordView intrinsicContentSize].height/2;
    [self.inputPhoneAndPasswordPopup showAtCenter:CGPointMake(DEVICE_WIDTH/2, centerY) inView:nil];
    
    [self.inputPhoneAndPasswordView.phoneInputTextField becomeFirstResponder];
}

#pragma mark InputVerifyCodeView
- (void)showNewInputVerifyCodeViewWithPhone:(NSString *)phone{
    self.inputVerifyCodeView = [LCInputVerifyCodeView createInstanceWithPhoneNum:phone];
    self.inputVerifyCodeView.delegate = self;
    
    self.inputVerifyCodePopup = [KLCPopup popupWithContentView:self.inputVerifyCodeView
                                                      showType:KLCPopupShowTypeBounceInFromTop
                                                   dismissType:KLCPopupDismissTypeBounceOutToBottom
                                                      maskType:KLCPopupMaskTypeDimmed
                                      dismissOnBackgroundTouch:NO
                                         dismissOnContentTouch:NO];
    self.inputVerifyCodePopup.dimmedMaskAlpha = self.dimmedMaskAlpha;
    
    [self showInputVerifyCodeView];
}
- (void)showInputVerifyCodeView{
    CGFloat topSpace = (DEVICE_HEIGHT - [self.inputVerifyCodeView intrinsicContentSize].height - LCNumKeyboardHeight) / 2;
    topSpace = MAX(topSpace, 4);
    CGFloat centerY = topSpace + [self.inputVerifyCodeView intrinsicContentSize].height/2;
    [self.inputVerifyCodePopup showAtCenter:CGPointMake(DEVICE_WIDTH/2, centerY) inView:nil];
    
    [self.inputVerifyCodeView.verifyCodeTextField becomeFirstResponder];
}

#pragma mark ErrorTipView
- (void)showNewErrorTipViewWithTitle:(NSString *)title msg:(NSString *)msg btnTitle:(NSString *)btnTitle callBack:(void(^)(BOOL canceled))callBack{
    self.errorTipView = [LCErrorTipView createInstanceWithTitle:title msg:msg buttonTitle:btnTitle callBack:callBack];
    
    self.errorTipPopup = [KLCPopup popupWithContentView:self.errorTipView
                                               showType:KLCPopupShowTypeBounceInFromTop
                                            dismissType:KLCPopupDismissTypeBounceOutToBottom
                                               maskType:KLCPopupMaskTypeDimmed
                               dismissOnBackgroundTouch:NO
                                  dismissOnContentTouch:NO];
    self.errorTipPopup.dimmedMaskAlpha = self.dimmedMaskAlpha;
    
    [self showErrorTipView];
}
- (void)showErrorTipView{
    [self.errorTipPopup showAtCenter:CGPointMake(DEVICE_WIDTH/2, DEVICE_HEIGHT/2) inView:nil];
}

#pragma mark RegisterSucceedView
- (void)showNewRegisterSucceedViewWithCallback:(void(^)(LCRegisterSucceedView *succeedView))callBack{
    self.registerSucceedView = [LCRegisterSucceedView createInstanceWithCallBack:callBack];
    
    self.registerSucceedPopup = [KLCPopup popupWithContentView:self.registerSucceedView
                                                      showType:KLCPopupShowTypeBounceInFromTop
                                                   dismissType:KLCPopupDismissTypeBounceOutToBottom
                                                      maskType:KLCPopupMaskTypeDimmed
                                      dismissOnBackgroundTouch:NO
                                         dismissOnContentTouch:NO];
    self.registerSucceedPopup.dimmedMaskAlpha = self.dimmedMaskAlpha;
    
    [self.registerSucceedPopup showAtCenter:CGPointMake(DEVICE_WIDTH/2, DEVICE_HEIGHT/2) inView:nil];
}

#pragma mark InputUserinfoView
- (void)showNewInputUserinfoView{
//    self.inputUserinfoView = [LCInputUserinfoView createInstance];
//    self.inputUserinfoView.delegate = self;
//    
//    self.inputUserinfoPopup = [KLCPopup popupWithContentView:self.inputUserinfoView
//                                                    showType:KLCPopupShowTypeBounceInFromTop
//                                                 dismissType:KLCPopupDismissTypeBounceOutToBottom
//                                                    maskType:KLCPopupMaskTypeDimmed
//                                    dismissOnBackgroundTouch:NO
//                                       dismissOnContentTouch:NO];
//    self.inputUserinfoPopup.dimmedMaskAlpha = self.dimmedMaskAlpha;
//    
//    [self showInputUserinfoView];
    LCRegisterUserInfoView *inputUserinfoView = [LCRegisterUserInfoView createInstance];
    inputUserinfoView.delegate = self;
    self.inputUserinfoPopup = [KLCPopup popupWithContentView:inputUserinfoView
                                                    showType:KLCPopupShowTypeBounceInFromTop
                                                 dismissType:KLCPopupDismissTypeBounceOutToBottom
                                                    maskType:KLCPopupMaskTypeDimmed
                                    dismissOnBackgroundTouch:NO
                                       dismissOnContentTouch:NO];
    self.inputUserinfoPopup.dimmedMaskAlpha = self.dimmedMaskAlpha;
    CGFloat topSpace = (DEVICE_HEIGHT - [inputUserinfoView intrinsicContentSize].height - LCTextKeyboardHeight) / 2;
    topSpace = MAX(topSpace, 4);
    CGFloat centerY = topSpace + [inputUserinfoView intrinsicContentSize].height/2;
    [self.inputUserinfoPopup showAtCenter:CGPointMake(DEVICE_WIDTH/2, centerY) inView:nil];
}

- (void)registerUserInfoView:(LCRegisterUserInfoView *)userInfoView userInfo:(LCUserModel *)userInfo {
    [self.inputUserinfoPopup dismissPresentingPopup];
    //完成性别、生日后进入行业、学校
    self.user = userInfo;
    [LCDataManager sharedInstance].userInfo = userInfo;
    [[LCDataManager sharedInstance] saveData];
    [self showNewInputSchoolView:userInfo];
}

#pragma mark RegisterFinishView
- (void)showNewRegisterFinishViewWithUser:(LCUserModel *)user{
    self.registerFinishView = [LCRegisterFinishView createInstance];
    self.registerFinishView.delegate = self;
    self.registerFinishView.user = user;
    
    self.registerFinishPopup = [KLCPopup popupWithContentView:self.registerFinishView
                                                     showType:KLCPopupShowTypeBounceInFromTop
                                                  dismissType:KLCPopupDismissTypeBounceOutToBottom
                                                     maskType:KLCPopupMaskTypeDimmed
                                     dismissOnBackgroundTouch:NO
                                        dismissOnContentTouch:NO];
    self.registerFinishPopup.dimmedMaskAlpha = self.dimmedMaskAlpha;
    
    [self.registerFinishPopup showAtCenter:CGPointMake(DEVICE_WIDTH/2, DEVICE_HEIGHT/2) inView:nil];
}

#pragma mark LoginView
- (void)showNewLoginView{
    self.loginView = [LCLoginView createInstance];
    self.loginView.delegate = self;
    
    self.loginPopup = [KLCPopup popupWithContentView:self.loginView
                                            showType:KLCPopupShowTypeBounceInFromTop
                                         dismissType:KLCPopupDismissTypeBounceOutToBottom
                                            maskType:KLCPopupMaskTypeDimmed
                            dismissOnBackgroundTouch:NO
                               dismissOnContentTouch:NO];
    self.registerFinishPopup.dimmedMaskAlpha = self.dimmedMaskAlpha;
    
    [self showLoginView];
}
- (void)showLoginView{
    CGFloat topSpace = (DEVICE_HEIGHT - [self.loginView intrinsicContentSize].height - LCTextKeyboardHeight) / 2;
    topSpace = MAX(topSpace, 4);
    CGFloat centerY = topSpace + [self.loginView intrinsicContentSize].height/2;
    [self.loginPopup showAtCenter:CGPointMake(DEVICE_WIDTH/2, centerY) inView:nil];
    
    [self.loginView.phoneTextField becomeFirstResponder];
}

#pragma mark InputPhoneView
- (void)showNewInputPhoneView{
    self.inputPhoneView = [LCInputPhoneView createInstance];
    self.inputPhoneView.delegate = self;
    
    self.inputPhonePopup = [KLCPopup popupWithContentView:self.inputPhoneView
                                                 showType:KLCPopupShowTypeBounceInFromTop
                                              dismissType:KLCPopupDismissTypeBounceOutToBottom
                                                 maskType:KLCPopupMaskTypeDimmed
                                 dismissOnBackgroundTouch:NO
                                    dismissOnContentTouch:NO];
    self.inputPhonePopup.dimmedMaskAlpha = self.dimmedMaskAlpha;
    
    [self showInputPhoneView];
}
- (void)showInputPhoneView{
    CGFloat topSpace = (DEVICE_HEIGHT - [self.inputPhoneView intrinsicContentSize].height - LCTextKeyboardHeight) / 2;
    topSpace = MAX(topSpace, 4);
    CGFloat centerY = topSpace + [self.inputPhoneView intrinsicContentSize].height/2;
    [self.inputPhonePopup showAtCenter:CGPointMake(DEVICE_WIDTH/2, centerY) inView:nil];
    
    [self.inputPhoneView.phoneTextField becomeFirstResponder];
}

#pragma mark ResetPasswordView
- (void)showNewResetPasswordView{
    self.resetPasswordView = [LCResetPasswordView createInstance];
    self.resetPasswordView.delegate = self;
    
    self.resetPasswordPopup = [KLCPopup popupWithContentView:self.resetPasswordView
                                                    showType:KLCPopupShowTypeBounceInFromTop
                                                 dismissType:KLCPopupDismissTypeBounceOutToBottom
                                                    maskType:KLCPopupMaskTypeDimmed
                                    dismissOnBackgroundTouch:NO
                                       dismissOnContentTouch:NO];
    self.resetPasswordPopup.dimmedMaskAlpha = self.dimmedMaskAlpha;
    
    [self showResetPasswordView];
}
- (void)showResetPasswordView {
    CGFloat topSpace = (DEVICE_HEIGHT - [self.resetPasswordView intrinsicContentSize].height - LCTextKeyboardHeight) / 2;
    topSpace = MAX(topSpace, 4);
    CGFloat centerY = topSpace + [self.resetPasswordView intrinsicContentSize].height/2;
    [self.resetPasswordPopup showAtCenter:CGPointMake(DEVICE_WIDTH/2, centerY) inView:nil];
    
    [self.resetPasswordView.passwordTextField becomeFirstResponder];
}

#pragma mark ResetPasswordView
- (void)showNewInputSchoolView:(LCUserModel *)user {
    self.inputSchoolinfoView = [LCInputSchoolAndHometownView createInstance];
    self.inputSchoolinfoView.delegate = self;
    self.inputSchoolinfoPopup = [KLCPopup popupWithContentView:self.inputSchoolinfoView
                                                    showType:KLCPopupShowTypeBounceInFromTop
                                                 dismissType:KLCPopupDismissTypeBounceOutToBottom
                                                    maskType:KLCPopupMaskTypeDimmed
                                    dismissOnBackgroundTouch:NO
                                       dismissOnContentTouch:NO];
    self.inputSchoolinfoPopup.dimmedMaskAlpha = self.dimmedMaskAlpha;
    
    [self showInputSchoolView];
}
- (void)showInputSchoolView {
    CGFloat topSpace = (DEVICE_HEIGHT - [self.inputSchoolinfoView intrinsicContentSize].height) / 2;
    topSpace = MAX(topSpace, 4);
    CGFloat centerY = topSpace + [self.inputSchoolinfoView intrinsicContentSize].height/2;
    [self.inputSchoolinfoPopup showAtCenter:CGPointMake(DEVICE_WIDTH/2, centerY) inView:nil];
    
//    [self.inputSchoolinfoView.passwordTextField becomeFirstResponder];
}

#pragma mark - InnerFunc
- (UIView *)getMostTopVCView{
    UIViewController *mostTopVC = [LCSharedFuncUtil getTopMostViewController];
    return mostTopVC.view;
}



@end
