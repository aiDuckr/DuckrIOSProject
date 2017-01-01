//
//  LCPaymentChooseView.h
//  LinkCity
//
//  Created by Roy on 9/6/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCPaymentChooseViewDelegate;
@interface LCPaymentChooseView : UIView

//Data
@property (nonatomic, weak) id<LCPaymentChooseViewDelegate> delegate;

//UI
@property (weak, nonatomic) IBOutlet UIView *borderBg;
@property (weak, nonatomic) IBOutlet UIView *wechatBorderView;
@property (weak, nonatomic) IBOutlet UIView *aliBorderView;

+ (instancetype)createInstance;
@end




@protocol LCPaymentChooseViewDelegate <NSObject>

- (void)paymentChooseViewDidChooseAliPay:(LCPaymentChooseView *)view;
- (void)paymentChooseViewDidChooseWechatPay:(LCPaymentChooseView *)view;
- (void)paymentChooseViewDidCancel:(LCPaymentChooseView *)view;

@end