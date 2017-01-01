//
//  LCInputVerifyCodeView.h
//  LinkCity
//
//  Created by roy on 2/28/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCInputVerifyCodeViewDelegate;
@interface LCInputVerifyCodeView : UIView<UITextFieldDelegate>
//Data
@property (nonatomic,weak) id<LCInputVerifyCodeViewDelegate> delegate;

//UI
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *verifyCodeTipLabel;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTextField;

//等待输入的View，包含上一步按钮，重发按钮
@property (weak, nonatomic) IBOutlet UIView *waitingView;
@property (weak, nonatomic) IBOutlet UIButton *sendVerifyCodeButton;

//验证的View，包含“验证我”按钮
@property (weak, nonatomic) IBOutlet UIView *verifyView;



+ (instancetype)createInstance;
+ (instancetype)createInstanceWithPhoneNum:(NSString *)phoneNum;

- (void)startCountDown;
@end



@protocol LCInputVerifyCodeViewDelegate <NSObject>
@optional
- (void)inputVerifyCodeViewDidClickCancel:(LCInputVerifyCodeView *)verifyCodeView;
- (void)inputVerifyCodeViewDidClickLastStep:(LCInputVerifyCodeView *)verifyCodeView;
- (void)inputVerifyCodeViewDidClickResend:(LCInputVerifyCodeView *)verifyCodeView;
- (void)inputVerifyCodeView:(LCInputVerifyCodeView *)verifyCodeView askToVerifyCode:(NSString *)code;

@end