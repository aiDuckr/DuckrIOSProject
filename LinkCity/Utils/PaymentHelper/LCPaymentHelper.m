//
//  LCPaymentHelper.m
//  LinkCity
//
//  Created by Roy on 8/9/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCPaymentHelper.h"

@interface LCPaymentHelper()
@property (nonatomic, strong) NSString *planGuid;
@property (nonatomic, assign) NSInteger orderNumber;
@property (nonatomic, assign) NSInteger orderScore;

@property (nonatomic, assign) BOOL isPayForEarnest; // YES means pay for Earnest, No means pay for Tail
@end


@implementation LCPaymentHelper

#pragma mark Public Interface
- (void)payEarnestWithPlanGuid:(NSString *)planGuid
                     withTitle:(NSString *)planTitle
                   orderNumber:(NSInteger)orderNumber
                  orderContact:(NSString *)orderContact
                    orderScore:(NSInteger)orderScore
                     recmdUuid:(NSString *)recmdUuid
               isNeedInsurance:(BOOL)isNeedInsurance{
    [YSAlertUtil showHudWithHint:@"创建订单"];
    [LCNetRequester planOrderNew:planGuid
                        orderNum:orderNumber
                      orderScore:orderScore
                    orderContact:orderContact
                           wxPay:0
                       recmdUuid:recmdUuid
                 isNeedInsurance:isNeedInsurance
                        callBack:^(LCPartnerOrderModel *partnerOrder, LCWxPrepayModel *wxPrepay, NSError *error) {
                            [YSAlertUtil hideHud];
                            
                            if (error) {
                                if ([self.delegate respondsToSelector:@selector(paymentHelper:didPaySucceed:order:error:)]) {
                                    [self.delegate paymentHelper:self didPaySucceed:NO order:nil error:error];
                                }
                            }else{
                                self.partnerOrder = partnerOrder;
                                self.wxPrepayModel = wxPrepay;
                                
                                if ([LCDecimalUtil isOverZero:self.partnerOrder.orderPay]) {
                                    //TODO: should not be
                                }else{
                                    [self clientDidPaySucceed:YES];
                                }
                            }
                        }];
}

- (void)payTailWithOrderGuid:(NSString *)orderGuid{
    
}

- (void)payMarginWithMarginValue:(NSDecimalNumber *)marginValue{
    self.isPayMargin = YES;
    self.marginOrderValue = marginValue;
}


#pragma mark Inner Func
- (instancetype)initWithDelegate:(id<LCPaymentHelperDelegate>)delegate{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.isPayMargin = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:NotificationAliPay object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:NotificationWechatPay object:nil];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (void)doClientPay{
    NSAssert(NO, @"do client pay should be override");
}

- (void)clientDidPaySucceed:(BOOL)succeed{
    if (self.isPayMargin) {
        if (succeed) {
            //前端支付完成，向后端验证支付状态
            [YSAlertUtil tipOneMessage:@"支付成功!" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
            [YSAlertUtil showHudWithHint:@"更新订单"];
            
            //第一次验证订单
            [LCNetRequester userMarginOrderQuery:self.marginOrderGuid callBack:^(LCUserModel *user, NSError *error) {
                if (error) {
                    //第二次验证订单
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [LCNetRequester userMarginOrderQuery:self.marginOrderGuid callBack:^(LCUserModel *user, NSError *error) {
                            if (error) {
                                //第三次验证订单
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    [LCNetRequester userMarginOrderQuery:self.marginOrderGuid callBack:^(LCUserModel *user, NSError *error) {
                                        if (error) {
                                            [YSAlertUtil hideHud];
                                            [self serverDidMarginPaySucceed:NO error:[NSError errorWithDomain:@"正在处理您的订单，请稍后重新进入本邀约详情查看订单状态" code:-1 userInfo:nil]];
                                        }else{
                                            //Succeed
                                            [YSAlertUtil hideHud];
                                            [LCDataManager sharedInstance].userInfo = user;
                                            [[LCDataManager sharedInstance] saveData];
                                            [self serverDidMarginPaySucceed:YES error:nil];
                                        }
                                    }];
                                });
                            }else{
                                //Succeed
                                [YSAlertUtil hideHud];
                                [LCDataManager sharedInstance].userInfo = user;
                                [[LCDataManager sharedInstance] saveData];
                                [self serverDidMarginPaySucceed:YES error:nil];
                            }
                        }];
                    });
                }else{
                    //Succeed
                    [YSAlertUtil hideHud];
                    [LCDataManager sharedInstance].userInfo = user;
                    [[LCDataManager sharedInstance] saveData];
                    [self serverDidMarginPaySucceed:YES error:nil];
                }
            }];
            
        }else{
            //前端支付失败
            if ([self.delegate respondsToSelector:@selector(paymentHelper:didPayMarginSucceed:error:)]) {
                [self.delegate paymentHelper:self didPayMarginSucceed:NO error:[NSError errorWithDomain:@"支付失败" code:-1 userInfo:nil]];
            }
        }
    }else{
        if (succeed) {
            //前端支付完成，向后端验证支付状态
            [YSAlertUtil tipOneMessage:@"支付成功!" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
            [YSAlertUtil showHudWithHint:@"更新订单"];
            
            //第一次验证订单
            [LCNetRequester planOrderQuery:self.partnerOrder.guid callBack:^(LCPartnerOrderModel *partnerOrder, NSError *error) {
                if (error) {
                    //第二次验证订单
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [LCNetRequester planOrderQuery:self.partnerOrder.guid callBack:^(LCPartnerOrderModel *partnerOrder, NSError *error) {
                            if (error) {
                                //第三次验证订单
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    [LCNetRequester planOrderQuery:self.partnerOrder.guid callBack:^(LCPartnerOrderModel *partnerOrder, NSError *error) {
                                        if (error) {
                                            [YSAlertUtil hideHud];
                                            [self serverDidOrderPayWithOrder:self.partnerOrder succeed:NO error:[NSError errorWithDomain:@"正在处理您的订单，请稍后重新进入本邀约详情查看订单状态" code:-1 userInfo:nil]];
                                        }else{
                                            //Succeed
                                            [YSAlertUtil hideHud];
                                            [self serverDidOrderPayWithOrder:partnerOrder succeed:YES error:nil];
                                        }
                                    }];
                                });
                            }else{
                                //Succeed
                                [YSAlertUtil hideHud];
                                [self serverDidOrderPayWithOrder:partnerOrder succeed:YES error:nil];
                            }
                        }];
                    });
                }else{
                    //Succeed
                    [YSAlertUtil hideHud];
                    [self serverDidOrderPayWithOrder:partnerOrder succeed:YES error:nil];
                }
            }];
        }else{
            //前端支付失败
            if ([self.delegate respondsToSelector:@selector(paymentHelper:didPaySucceed:order:error:)]) {
                [self.delegate paymentHelper:self didPaySucceed:NO order:nil error:[NSError errorWithDomain:@"支付失败" code:-1 userInfo:nil]];
            }
        }
    }
}

- (void)serverDidOrderPayWithOrder:(LCPartnerOrderModel *)partnerOrder succeed:(BOOL)succeed error:(NSError *)error{
    if ([self.delegate respondsToSelector:@selector(paymentHelper:didPaySucceed:order:error:)]) {
        [self.delegate paymentHelper:self didPaySucceed:succeed order:partnerOrder error:error];
    }
}

- (void)serverDidMarginPaySucceed:(BOOL)succeed error:(NSError *)error{
    if(self.isPayMargin && [self.delegate respondsToSelector:@selector(paymentHelper:didPayMarginSucceed:error:)]) {
        [self.delegate paymentHelper:self didPayMarginSucceed:succeed error:error];
    }
}

- (void)notificationAction:(NSNotification *)notify{
    NSAssert(NO, @"LCPaymentHelper notification action should be override");
}



@end
