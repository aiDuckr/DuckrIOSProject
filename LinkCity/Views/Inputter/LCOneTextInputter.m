//
//  LCOneTextInputter.m
//  LinkCity
//
//  Created by roy on 2/9/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCOneTextInputter.h"

@interface LCOneTextInputter()<UITextFieldDelegate>

@end
@implementation LCOneTextInputter

+ (instancetype)createInstance{
    UINib *nib = [UINib nibWithNibName:@"LCOneTextInputter" bundle:nil];
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    for (UIView *v in views) {
        if ([v isKindOfClass:[LCOneTextInputter class]]) {
            v.translatesAutoresizingMaskIntoConstraints = NO;
            return (LCOneTextInputter *)v;
        }
    }
    
    return nil;
}



- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self.submitButton addTarget:self action:@selector(submitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.inputTextField.delegate = self;
}

- (void)submitButtonAction:(id)sender{
    [self doSubmit];
}
- (void)cancelButtonAction:(id)sender{
    [self dismissKeyboard];
    if ([self.delegate respondsToSelector:@selector(oneTextInputter:didCancelWithInput:)]) {
        [self.delegate oneTextInputter:self didCancelWithInput:self.inputTextField.text];
    }
}

- (void)dismissKeyboard{
    [self.inputTextField resignFirstResponder];
}


- (void)doSubmit{
    if ([LCStringUtil isNullString:[LCStringUtil trimSpaceAndEnter:self.inputTextField.text]]) {
        [YSAlertUtil tipOneMessage:@"请输入内容" yoffset:TipAboveKeyboardYoffset delay:TipDefaultDelay];
    }else{
        [self dismissKeyboard];
        if ([self.delegate respondsToSelector:@selector(oneTextInputter:didSubmitWithInput:)]) {
            [self.delegate oneTextInputter:self didSubmitWithInput:self.inputTextField.text];
        }
    }
}

//Override
- (CGSize)intrinsicContentSize{
    return CGSizeMake(320, 172);
}
- (BOOL)canBecomeFirstResponder{
    return YES;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self doSubmit];

    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    LCLogInfo(@"text field did end edit");
}

@end
