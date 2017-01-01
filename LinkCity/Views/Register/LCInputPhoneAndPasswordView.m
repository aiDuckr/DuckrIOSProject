//
//  LCInputPhoneAndPasswordView.m
//  LinkCity
//
//  Created by roy on 2/28/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCInputPhoneAndPasswordView.h"
#import "LCPhoneUtil.h"

@implementation LCInputPhoneAndPasswordView

+ (instancetype)createInstance{
    UINib *nib = [UINib nibWithNibName:@"LCRegisterAndLoginViews" bundle:nil];
    
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    for (UIView *v in views) {
        if ([v isKindOfClass:[LCInputPhoneAndPasswordView class]]) {
            v.translatesAutoresizingMaskIntoConstraints = NO;
            return (LCInputPhoneAndPasswordView *)v;
        }
    }
    
    return nil;
}

- (CGSize)intrinsicContentSize{
    return CGSizeMake(330, 250);
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.phoneInputTextField.delegate = self;
    self.passwordInputTextField.delegate = self;
    
    [self updateShowWithPhoneInput:self.phoneInputTextField.text passwordInput:self.passwordInputTextField.text];
}

#pragma mark UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *phone = self.phoneInputTextField.text;
    NSString *password = self.passwordInputTextField.text;
    
    if (textField == self.phoneInputTextField) {
        phone = [phone stringByReplacingCharactersInRange:range withString:string];
    }else if(textField == self.passwordInputTextField){
        password = [password stringByReplacingCharactersInRange:range withString:string];
    }
    [self updateShowWithPhoneInput:phone passwordInput:password];
    
    return YES;
}


#pragma mark ButtonAction
- (IBAction)cancelButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(inputPhoneAndPasswordViewDidCancel:)]) {
        [self.delegate inputPhoneAndPasswordViewDidCancel:self];
    }
}
- (IBAction)nextButtonAction:(id)sender {
    if ([self checkInput]) {
        if ([self.delegate respondsToSelector:@selector(inputPhoneAndPasswordView:didClickNextWithPhoneNum:andPassword:)]) {
            [self.delegate inputPhoneAndPasswordView:self didClickNextWithPhoneNum:self.phoneInputTextField.text andPassword:self.passwordInputTextField.text];
        }
    }
}

#pragma mark Inner Helper Func
- (void)updateShowWithPhoneInput:(NSString *)phone passwordInput:(NSString *)pssword{
    if ([LCStringUtil isNotNullString:phone] &&
        [LCStringUtil isNotNullString:pssword]) {
        [self.nextButton setEnabled:YES];
    }else{
        [self.nextButton setEnabled:NO];
    }
}

- (BOOL)checkInput{
    NSString *phone = self.phoneInputTextField.text;
    NSString *password = self.passwordInputTextField.text;
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
