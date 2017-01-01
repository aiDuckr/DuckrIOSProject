//
//  LCResetPasswordView.m
//  LinkCity
//
//  Created by roy on 3/1/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCResetPasswordView.h"

@implementation LCResetPasswordView



+ (instancetype)createInstance{
    UINib *nib = [UINib nibWithNibName:@"LCRegisterAndLoginViews" bundle:nil];
    
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    for (UIView *v in views) {
        if ([v isKindOfClass:[LCResetPasswordView class]]) {
            v.translatesAutoresizingMaskIntoConstraints = NO;
            LCResetPasswordView *resetPasswordView = (LCResetPasswordView *)v;
            return resetPasswordView;
        }
    }
    
    return nil;
}

- (CGSize)intrinsicContentSize{
    return CGSizeMake(320, 200);
}



- (IBAction)cancelButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(resetPasswordViewDidCancel:)]) {
        [self.delegate resetPasswordViewDidCancel:self];
    }
}

- (IBAction)submitButtonAction:(id)sender {
    if ([self checkInput]) {
        if ([self.delegate respondsToSelector:@selector(resetPasswordViewDidSubmit:withPassword:)]) {
            [self.delegate resetPasswordViewDidSubmit:self withPassword:self.passwordTextField.text];
        }
    }
}

- (BOOL)checkInput{
    NSString *pass = self.passwordTextField.text;
    NSString *rePass = self.confirmTextField.text;
    NSString *errMsg = nil;
    if ([LCStringUtil isNullString:pass] || [LCStringUtil isNullString:rePass]) {
        errMsg = @"请输入密码";
    }else if(![pass isEqualToString:rePass]){
        errMsg = @"两次输入的密码不一致";
    }
    if (errMsg) {
        [YSAlertUtil tipOneMessage:errMsg yoffset:TipAboveKeyboardYoffset delay:TipErrorDelay];
        return NO;
    }else{
        return YES;
    }
}
@end
