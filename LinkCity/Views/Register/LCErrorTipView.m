//
//  LCErrorTipView.m
//  LinkCity
//
//  Created by roy on 2/28/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCErrorTipView.h"

@implementation LCErrorTipView

+ (instancetype)createInstanceWithTitle:(NSString *)title msg:(NSString *)msg buttonTitle:(NSString *)btnTitle callBack:(void (^)(BOOL))callBack{
    UINib *nib = [UINib nibWithNibName:@"LCRegisterAndLoginViews" bundle:nil];
    
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    for (UIView *v in views) {
        if ([v isKindOfClass:[LCErrorTipView class]]) {
            v.translatesAutoresizingMaskIntoConstraints = NO;
            LCErrorTipView *errorTipView = (LCErrorTipView *)v;
            errorTipView.errorTitleLabel.text = title;
            errorTipView.errorMessageLabel.text = msg;
            [errorTipView.confirmButton setTitle:btnTitle forState:UIControlStateNormal];
            errorTipView.callBack = callBack;
            return errorTipView;
        }
    }
    
    return nil;
}

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (CGSize)intrinsicContentSize{
//    [self.errorMessageLabel sizeToFit];
//    return CGSizeMake(320, 175-20+self.errorMessageLabel.frame.size.height);
    return CGSizeMake(320, 175);
}

- (IBAction)cancelButtonAction:(id)sender {
    if (self.callBack) {
        self.callBack(YES);
    }
}

- (IBAction)confirmButtonAction:(id)sender {
    if (self.callBack) {
        self.callBack(NO);
    }
}


@end
