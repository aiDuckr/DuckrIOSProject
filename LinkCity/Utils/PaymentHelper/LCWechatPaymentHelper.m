//
//  LCWechatPaymentHelper.m
//  LinkCity
//
//  Created by Roy on 8/9/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCWechatPaymentHelper.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "payRequsestHandler.h"

@implementation LCWechatPaymentHelper

- (void)payEarnestWithPlanGuid:(NSString *)planGuid
                     withTitle:(NSString *)planTitle
                   orderNumber:(NSInteger)orderNumber
                  orderContact:(NSString *)orderContact
                    orderScore:(NSInteger)orderScore
                     recmdUuid:(NSString *)recmdUuid
               isNeedInsurance:(BOOL)isNeedInsurance
{
    [YSAlertUtil showHudWithHint:@"创建订单"];
    [LCNetRequester planOrderNew:planGuid
                        orderNum:orderNumber
                      orderScore:orderScore
                    orderContact:orderContact
                           wxPay:1
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
                [self doClientPay];
            }else{
                [self clientDidPaySucceed:YES];
            }
        }
    }];
}

- (void)payTailWithOrderGuid:(NSString *)orderGuid{
    [YSAlertUtil showHudWithHint:@"创建订单"];
    [LCNetRequester planTailOrderNew:orderGuid wxPay:1 callBack:^(LCPartnerOrderModel *partnerOrder, LCWxPrepayModel *wxPrepay, NSError *error) {
        [YSAlertUtil hideHud];
        
        if (error) {
            if ([self.delegate respondsToSelector:@selector(paymentHelper:didPaySucceed:order:error:)]) {
                [self.delegate paymentHelper:self didPaySucceed:NO order:nil error:error];
            }
        }else{
            self.partnerOrder = partnerOrder;
            self.wxPrepayModel = wxPrepay;
            
            if ([LCDecimalUtil isOverZero:self.partnerOrder.orderPay]) {
                [self doClientPay];
            }else{
                [self clientDidPaySucceed:YES];
            }
        }
    }];
}

- (void)payMarginWithMarginValue:(NSDecimalNumber *)marginValue{
    [super payMarginWithMarginValue:marginValue];
    [YSAlertUtil showHudWithHint:@"创建订单"];
    [LCNetRequester userMarginOrderNew:marginValue wxPay:1 callBack:^(NSString *orderGuid, NSDecimalNumber *marginValue, LCWxPrepayModel *wxPrepay, NSError *error) {
        [YSAlertUtil hideHud];
        
        if (error) {
            if ([self.delegate respondsToSelector:@selector(paymentHelper:didPayMarginSucceed:error:)]) {
                [self.delegate paymentHelper:self didPayMarginSucceed:NO error:error];
            }
        }else{
            self.wxPrepayModel = wxPrepay;
            self.marginOrderGuid = orderGuid;
            self.marginOrderValue = marginValue;
            
            if ([LCDecimalUtil isOverZero:self.marginOrderValue]) {
                [self doClientPay];
            }else{
                [self clientDidPaySucceed:YES];
            }
        }
    }];
}

- (void)doClientPay{
    //创建支付签名对象
    payRequsestHandler *reqh = [payRequsestHandler alloc];
    //初始化支付签名对象
    [reqh init:self.wxPrepayModel.appid mch_id:self.wxPrepayModel.mch_id];
    //设置密钥
    [reqh setKey:@"21b7c851bbad3e0edd477718d59b0de7"];
    
    NSString    *package, *time_stamp, *nonce_str;
    //设置支付参数
    time_t now;
    time(&now);
    time_stamp  = [NSString stringWithFormat:@"%ld", now];
    nonce_str	= [WXUtil md5:time_stamp];
    //重新按提交格式组包，微信客户端暂只支持package=Sign=WXPay格式，须考虑升级后支持携带package具体参数的情况
    //package       = [NSString stringWithFormat:@"Sign=%@",package];
    package         = @"Sign=WXPay";
    //第二次签名参数列表
    NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
    [signParams setObject: self.wxPrepayModel.appid        forKey:@"appid"];
    [signParams setObject: nonce_str    forKey:@"noncestr"];
    [signParams setObject: package      forKey:@"package"];
    [signParams setObject: self.wxPrepayModel.mch_id        forKey:@"partnerid"];
    [signParams setObject: time_stamp   forKey:@"timestamp"];
    [signParams setObject: self.wxPrepayModel.prepay_id     forKey:@"prepayid"];
    //生成签名
    NSString *sign  = [reqh createMd5Sign:signParams];
    
    //调起微信支付
    PayReq* req             = [[PayReq alloc] init];
    req.openID              = self.wxPrepayModel.appid;
    req.nonceStr            = nonce_str;
    req.package             = package;
    req.partnerId           = self.wxPrepayModel.mch_id;
    req.prepayId            = self.wxPrepayModel.prepay_id;
    req.timeStamp           = [time_stamp intValue];
    req.sign                = sign;
    
    [WXApi sendReq:req];
}

- (void)notificationAction:(NSNotification *)notify{
    if([notify.name isEqualToString:NotificationWechatPay]){
        //前端微信支付结果的通知
        
        id resp = [notify.userInfo objectForKey:NotificationWechatPayResultKey];
        if([resp isKindOfClass:[PayResp class]]){
            PayResp *payResp = (PayResp *)resp;
            
            switch (payResp.errCode) {
                case WXSuccess:{
                    NSLog(@"支付成功－PaySuccess，retcode = %d", payResp.errCode);
                    [self clientDidPaySucceed:YES];
                }
                    break;
                default:{
                    NSLog(@"错误，retcode = %d, retstr = %@", payResp.errCode,payResp.errStr);
                    [self clientDidPaySucceed:NO];
                }
                    break;
            }
        }
    }
}

@end
