//
//  LCRegisterStartView.m
//  LinkCity
//
//  Created by roy on 2/27/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCRegisterStartView.h"

@implementation LCRegisterStartView

+ (instancetype)createInstance{
    UINib *nib = [UINib nibWithNibName:@"LCRegisterAndLoginViews" bundle:nil];
    
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    for (UIView *v in views) {
        if ([v isKindOfClass:[LCRegisterStartView class]]) {
            v.translatesAutoresizingMaskIntoConstraints = NO;
            return (LCRegisterStartView *)v;
        }
    }
    
    return nil;
}

- (CGSize)intrinsicContentSize{
    return CGSizeMake(300, 290);
}


- (IBAction)cancelButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(registerStartViewDidCancel:)]) {
        [self.delegate registerStartViewDidCancel:self];
    }
}
- (IBAction)registerButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(registerStartViewDidChooseRegister:)]) {
        [self.delegate registerStartViewDidChooseRegister:self];
    }
}
- (IBAction)haveAccountButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(registerStartViewDidChooseLogin:)]) {
        [self.delegate registerStartViewDidChooseLogin:self];
    }
}


@end
