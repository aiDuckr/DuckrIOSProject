//
//  LCPaymentChooseView.m
//  LinkCity
//
//  Created by Roy on 9/6/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCPaymentChooseView.h"

@implementation LCPaymentChooseView

+ (instancetype)createInstance{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([LCPaymentChooseView class]) bundle:nil];
    
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    for (UIView *v in views) {
        if ([v isKindOfClass:[LCPaymentChooseView class]]) {
            v.translatesAutoresizingMaskIntoConstraints = NO;
            return (LCPaymentChooseView *)v;
        }
    }
    
    return nil;
}

- (CGSize)intrinsicContentSize{
    return CGSizeMake(DEVICE_WIDTH, 236);
}

- (void)awakeFromNib{
    self.borderBg.layer.masksToBounds = YES;
    self.borderBg.layer.cornerRadius = LCCellCornerRadius;
    self.borderBg.layer.borderColor = UIColorFromRGBA(LCCellBorderColor, 1).CGColor;
    self.borderBg.layer.borderWidth = 1;
    
    self.wechatBorderView.layer.masksToBounds = YES;
    self.wechatBorderView.layer.cornerRadius = LCCellCornerRadius;
    self.wechatBorderView.layer.borderColor = UIColorFromRGBA(LCCellBorderColor, 1).CGColor;
    self.wechatBorderView.layer.borderWidth = 1;
    
    self.aliBorderView.layer.masksToBounds = YES;
    self.aliBorderView.layer.cornerRadius = LCCellCornerRadius;
    self.aliBorderView.layer.borderColor = UIColorFromRGBA(LCCellBorderColor, 1).CGColor;
    self.aliBorderView.layer.borderWidth = 1;
}

- (IBAction)wechatBtnAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(paymentChooseViewDidChooseWechatPay:)]) {
        [self.delegate paymentChooseViewDidChooseWechatPay:self];
    }
}
- (IBAction)aliBtnAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(paymentChooseViewDidChooseAliPay:)]) {
        [self.delegate paymentChooseViewDidChooseAliPay:self];
    }
}
- (IBAction)backBtnAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(paymentChooseViewDidCancel:)]) {
        [self.delegate paymentChooseViewDidCancel:self];
    }
}

@end
