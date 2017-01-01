//
//  LCRegisterAndLoginHelper.h
//  LinkCity
//
//  Created by roy on 2/9/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

/*
 WorkFlow:
 ***************************
 Register:
 registerStartView - InputPhoneAndPasswordView - InputVerifyCodeView - RegisterSucceedView - InputUserinfoView - RegisterFinishView - Finish
                                                                     - ErrorTipView
 ***************************
 Login:
 registerStartView - LoginView - Finish
                               - ErrorTipView
 ***************************
 ResetPassword:
 registerStartView - LoginView - InputPhoneView - InputVerifyCodeView - ResetPasswordView - Finish
                                                                      - ErrorTipView
 */


#import <UIKit/UIKit.h>
#import "LCRegisterAndLoginBase.h"

@protocol LCRegisterAndLoginHelperDelegate;

@interface LCRegisterAndLoginHelper : LCRegisterAndLoginBase
@property (nonatomic, weak) id<LCRegisterAndLoginHelperDelegate> delegate;

+ (instancetype)sharedInstance;

- (void)startRegister;
//检测是否已经登录;
//如果没有登录，开始注册登录流程;
- (void)startRegisterWithDelegate:(id<LCRegisterAndLoginHelperDelegate>)delegate;
- (void)startLoginWithDelegate:(id<LCRegisterAndLoginHelperDelegate>)delegate;
@end

@protocol LCRegisterAndLoginHelperDelegate <NSObject>
@optional
- (void)registerAndLoginhelperDidLogin;
- (void)registerAndLoginHelperDidCancel;

@end
