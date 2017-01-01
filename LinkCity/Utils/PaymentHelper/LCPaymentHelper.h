//
//  LCPaymentHelper.h
//  LinkCity
//
//  Created by Roy on 8/9/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LCPaymentHelperDelegate;
@interface LCPaymentHelper : NSObject
@property (nonatomic, weak) id<LCPaymentHelperDelegate> delegate;

@property (nonatomic, strong) LCPartnerOrderModel *partnerOrder;
@property (nonatomic, strong) LCWxPrepayModel *wxPrepayModel;

@property (nonatomic, assign) BOOL isPayMargin;
@property (nonatomic, strong) NSString *marginOrderGuid;
@property (nonatomic, strong) NSDecimalNumber *marginOrderValue;


- (instancetype)initWithDelegate:(id<LCPaymentHelperDelegate>)delegate;
- (void)payEarnestWithPlanGuid:(NSString *)planGuid
                     withTitle:(NSString *)planTitle
                   orderNumber:(NSInteger)orderNumber
                  orderContact:(NSString *)orderContact
                    orderScore:(NSInteger)orderScore
                     recmdUuid:(NSString *)recmdUuid
               isNeedInsurance:(BOOL)isNeedInsurance;
- (void)payTailWithOrderGuid:(NSString *)orderGuid;

- (void)payMarginWithMarginValue:(NSDecimalNumber *)marginValue;


#pragma mark Inner Func

//Override
- (void)doClientPay;


- (void)clientDidPaySucceed:(BOOL)succeed;
- (void)notificationAction:(NSNotification *)notify;
@end



@protocol LCPaymentHelperDelegate <NSObject>
@optional
- (void)paymentHelper:(LCPaymentHelper *)paymentHelper didPaySucceed:(BOOL)succeed order:(LCPartnerOrderModel *)order error:(NSError *)error;
- (void)paymentHelper:(LCPaymentHelper *)paymentHelper didPayMarginSucceed:(BOOL)succeed error:(NSError *)error;

@end
