//
//  LCLoginView.m
//  LinkCity
//
//  Created by roy on 3/1/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCLoginView.h"
#import "LCPhoneUtil.h"

@implementation LCLoginView


+ (instancetype)createInstance{
    UINib *nib = [UINib nibWithNibName:@"LCRegisterAndLoginViews" bundle:nil];
    
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    for (UIView *v in views) {
        if ([v isKindOfClass:[LCLoginView class]]) {
            v.translatesAutoresizingMaskIntoConstraints = NO;
            LCLoginView *loginView = (LCLoginView *)v;
            return loginView;
        }
    }
    
    return nil;
}

- (CGSize)intrinsicContentSize{
    return CGSizeMake(320, 200);
}



- (IBAction)cancelButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(loginViewDidCancel:)]) {
        [self.delegate loginViewDidCancel:self];
    }
}

- (IBAction)forgetPasswordButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(loginViewDidClickForgetPassword:)]) {
        [self.delegate loginViewDidClickForgetPassword:self];
    }
}

- (IBAction)loginButtonAction:(id)sender {
    if ([self checkInput]) {
        if ([self.delegate respondsToSelector:@selector(loginViewDidClickLogin:withPhone:password:)]) {
            [self.delegate loginViewDidClickLogin:self withPhone:self.phoneTextField.text password:self.passwordTextField.text];
        }
    }
}



- (BOOL)checkInput{
    NSString *phone = self.phoneTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *errorMsg = nil;
    
    if (!phone || phone.length!=11 || ![LCPhoneUtil isPhoneNum:phone]) {
        errorMsg = @"请输入正确的手机号";
    }else if(!password || password.length < 4){
        errorMsg = @"密码不能少到4位";
    }
    
    if (errorMsg) {
        [YSAlertUtil tipOneMessage:errorMsg yoffset:TipAboveKeyboardYoffset delay:TipErrorDelay];
        return NO;
    }else{
        return YES;
    }
    
}

@end
