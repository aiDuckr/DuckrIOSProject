//
//  LCInputPhoneView.m
//  LinkCity
//
//  Created by roy on 3/1/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCInputPhoneView.h"
#import "LCPhoneUtil.h"

@implementation LCInputPhoneView

+ (instancetype)createInstance{
    UINib *nib = [UINib nibWithNibName:@"LCRegisterAndLoginViews" bundle:nil];
    
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    for (UIView *v in views) {
        if ([v isKindOfClass:[LCInputPhoneView class]]) {
            v.translatesAutoresizingMaskIntoConstraints = NO;
            LCInputPhoneView *inputPhoneView = (LCInputPhoneView *)v;
            return inputPhoneView;
        }
    }
    
    return nil;
}

- (CGSize)intrinsicContentSize{
    return CGSizeMake(320, 140);
}



- (IBAction)cancelButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(inputPhoneViewDidCancel:)]) {
        [self.delegate inputPhoneViewDidCancel:self];
    }
}

- (IBAction)nextButtonAction:(id)sender {
    if ([self checkInput]) {
        if ([self.delegate respondsToSelector:@selector(inputPhoneViewDidClickNext:withPhone:)]) {
            [self.delegate inputPhoneViewDidClickNext:self withPhone:self.phoneTextField.text];
        }
    }
}


- (BOOL)checkInput{
    NSString *phone = self.phoneTextField.text;
    NSString *errMsg = nil;
    if ([LCStringUtil isNullString:phone]) {
        errMsg = @"请输入您的手机号";
    }else if(![LCPhoneUtil isPhoneNum:phone]){
        errMsg = @"请输入正确的手机号";
    }
    
    if (errMsg) {
        [YSAlertUtil tipOneMessage:errMsg yoffset:TipAboveKeyboardYoffset delay:TipErrorDelay];
        return NO;
    }else{
        return YES;
    }
}


@end
