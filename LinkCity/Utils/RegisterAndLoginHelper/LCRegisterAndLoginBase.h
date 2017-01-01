//
//  LCRegisterAndLoginBase.h
//  LinkCity
//
//  Created by roy on 3/1/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLCPopup.h"
#import "LCRegisterStartView.h"
#import "LCInputPhoneAndPasswordView.h"
#import "LCInputVerifyCodeView.h"
#import "LCErrorTipView.h"
#import "LCRegisterSucceedView.h"
#import "LCInputUserinfoView.h"
#import "LCRegisterFinishView.h"
#import "LCLoginView.h"
#import "LCInputPhoneView.h"
#import "LCResetPasswordView.h"
#import "LCInputSchoolAndHometownView.h"

@interface LCRegisterAndLoginBase : NSObject<LCRegisterStartViewDelegate,LCInputPhoneAndPasswordViewDelegate,LCInputVerifyCodeViewDelegate,LCInputUserinfoViewDelegate,LCRegisterFinishViewDelegate,LCLoginViewDelegate,LCInputPhoneViewDelegate,LCResetPasswordViewDelegate,LCInputSchoolAndHometownViewDelegate>
@property (nonatomic, assign) CGFloat dimmedMaskAlpha;

@property (nonatomic, strong) LCRegisterStartView *startView;
@property (nonatomic, strong) KLCPopup *startViewPopup;

@property (nonatomic, strong) LCInputPhoneAndPasswordView *inputPhoneAndPasswordView;
@property (nonatomic, strong) KLCPopup *inputPhoneAndPasswordPopup;

@property (nonatomic, strong) LCInputVerifyCodeView *inputVerifyCodeView;
@property (nonatomic, strong) KLCPopup *inputVerifyCodePopup;

@property (nonatomic, strong) LCErrorTipView *errorTipView;
@property (nonatomic, strong) KLCPopup *errorTipPopup;

@property (nonatomic, strong) LCRegisterSucceedView *registerSucceedView;
@property (nonatomic, strong) KLCPopup *registerSucceedPopup;

@property (nonatomic, strong) LCRegisterFinishView *registerFinishView;
@property (nonatomic, strong) KLCPopup *registerFinishPopup;

@property (nonatomic, strong) LCInputPhoneView *inputPhoneView;
@property (nonatomic, strong) KLCPopup *inputPhonePopup;

@property (nonatomic, strong) LCLoginView *loginView;
@property (nonatomic, strong) KLCPopup *loginPopup;

@property (nonatomic, strong) LCResetPasswordView *resetPasswordView;
@property (nonatomic, strong) KLCPopup *resetPasswordPopup;

@property (nonatomic, strong) KLCPopup *inputUserinfoPopup;

@property (nonatomic, strong) LCInputSchoolAndHometownView *inputSchoolinfoView;
@property (nonatomic, strong) KLCPopup *inputSchoolinfoPopup;

@property (nonatomic, strong) LCUserModel *user;    //正在注册或更新的User
#pragma mark StartRegister
- (void)showNewRegisterStartView;
- (void)showRegisterStartView;

#pragma mark InputPhoneAndPasswordView
- (void)showNewInputPhoneAndPasswordView;
- (void)showInputPhoneAndPasswordView;

#pragma mark InputVerifyCodeView
- (void)showNewInputVerifyCodeViewWithPhone:(NSString *)phone;
- (void)showInputVerifyCodeView;

#pragma mark ErrorTipView
- (void)showNewErrorTipViewWithTitle:(NSString *)title msg:(NSString *)msg btnTitle:(NSString *)btnTitle callBack:(void(^)(BOOL canceled))callBack;

#pragma mark RegisterSucceedView
- (void)showNewRegisterSucceedViewWithCallback:(void(^)(LCRegisterSucceedView *succeedView))callBack;

#pragma mark InputUserinfoView
- (void)showNewInputUserinfoView;
- (void)showInputUserinfoView;

#pragma mark RegisterFinishView
- (void)showNewRegisterFinishViewWithUser:(LCUserModel *)user;

#pragma mark LoginView
- (void)showNewLoginView;
- (void)showLoginView;

#pragma mark InputPhoneView
- (void)showNewInputPhoneView;
- (void)showInputPhoneView;

#pragma mark ResetPasswordView
- (void)showNewResetPasswordView;
- (void)showResetPasswordView;

#pragma mark InputuSchoolView
- (void)showNewInputSchoolView:(LCUserModel *)user;
- (void)showInputSchoolView ;

@end
