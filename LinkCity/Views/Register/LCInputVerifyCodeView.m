//
//  LCInputVerifyCodeView.m
//  LinkCity
//
//  Created by roy on 2/28/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCInputVerifyCodeView.h"

static const NSInteger VerifyCodeLength = 6;

static const NSInteger INTERVAL_FOR_SEND_AUTHCODE = 60;
static NSInteger countDownTime;

@implementation LCInputVerifyCodeView

+ (instancetype)createInstance{
    return [LCInputVerifyCodeView createInstanceWithPhoneNum:nil];
}
+ (instancetype)createInstanceWithPhoneNum:(NSString *)phoneNum{
    UINib *nib = [UINib nibWithNibName:@"LCRegisterAndLoginViews" bundle:nil];
    
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    for (UIView *v in views) {
        if ([v isKindOfClass:[LCInputVerifyCodeView class]]) {
            v.translatesAutoresizingMaskIntoConstraints = NO;
            LCInputVerifyCodeView *inputVerifyCodeView = (LCInputVerifyCodeView *)v;
            if ([LCStringUtil isNotNullString:phoneNum]) {
                inputVerifyCodeView.phoneLabel.text = [NSString stringWithFormat:@"+86 %@",phoneNum];
            }else{
                inputVerifyCodeView.verifyCodeTextField.text = @"";
            }
            //初始化时，VerifyCode显示空
            [inputVerifyCodeView updateShowWithVerifyCode:nil];
            
            return inputVerifyCodeView;
        }
    }
    
    return nil;
}
- (void)startCountDown{
    [self resetSendVerifyCodeButtonState];
    [self countDown];
}
- (void)countDown{
    countDownTime--;
    if (countDownTime > 0) {
        [self.sendVerifyCodeButton setEnabled:NO];
        self.sendVerifyCodeButton.alpha = 0.5;
        [self.sendVerifyCodeButton setTitle:[NSString stringWithFormat:@"%lds",(long)countDownTime] forState:UIControlStateNormal];
        //have to do this for iOS7.   Doesn't setNeedsLayout mannually for iOS8 to update title.
        [self.sendVerifyCodeButton setNeedsLayout];
        [self performSelector:@selector(countDown) withObject:nil afterDelay:1];
    }else{
        [self resetSendVerifyCodeButtonState];
    }
}

- (CGSize)intrinsicContentSize{
    return CGSizeMake(320, 200);
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.verifyCodeTextField.text = @"";
    self.verifyCodeTextField.delegate = self;
    
    [self updateShowWithVerifyCode:@""];
    [self resetSendVerifyCodeButtonState];
}

#pragma mark ButtonAction
- (IBAction)lastStepButtonAction:(id)sender {
    [self resetSendVerifyCodeButtonState];
    if ([self.delegate respondsToSelector:@selector(inputVerifyCodeViewDidClickLastStep:)]) {
        [self.delegate inputVerifyCodeViewDidClickLastStep:self];
    }
}
- (IBAction)resendButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(inputVerifyCodeViewDidClickResend:)]) {
        [self.delegate inputVerifyCodeViewDidClickResend:self];
    }
}
- (IBAction)verifyButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(inputVerifyCodeView:askToVerifyCode:)]) {
        [self.delegate inputVerifyCodeView:self askToVerifyCode:self.verifyCodeTextField.text];
    }
}
- (IBAction)cancelButtonAction:(id)sender {
    [self resetSendVerifyCodeButtonState];
    if ([self.delegate respondsToSelector:@selector(inputVerifyCodeViewDidClickCancel:)]) {
        [self.delegate inputVerifyCodeViewDidClickCancel:self];
    }
}


#pragma mark UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.verifyCodeTextField) {
        NSString *verifyCode = textField.text;
        verifyCode = [verifyCode stringByReplacingCharactersInRange:range withString:string];
        [self updateShowWithVerifyCode:verifyCode];
        
        if (verifyCode.length > VerifyCodeLength) {
            return NO;
        }
    }
    
    return YES;
}


#pragma mark InnerFunc
- (void)updateShowWithVerifyCode:(NSString *)code{
    if ([LCStringUtil isNotNullString:code]) {
        self.verifyCodeTipLabel.hidden = YES;
    }else{
        self.verifyCodeTipLabel.hidden = NO;
    }
    
    if (code.length < VerifyCodeLength) {
        self.waitingView.hidden = NO;
        self.verifyView.hidden = YES;
    }else if(code.length >= VerifyCodeLength){
        self.waitingView.hidden = YES;
        self.verifyView.hidden = NO;
    }
}

#pragma mark - CountDown & Button state
- (void)resetSendVerifyCodeButtonState{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(countDown) object:nil];
    countDownTime = INTERVAL_FOR_SEND_AUTHCODE;
    [self setSendVerifyCodeButtonEnable];
}
- (void)setSendVerifyCodeButtonEnable{
    self.sendVerifyCodeButton.enabled = YES;
    self.sendVerifyCodeButton.alpha = 1.0;
    [self.sendVerifyCodeButton setTitle:@"重新发送" forState:UIControlStateNormal];
}

@end
