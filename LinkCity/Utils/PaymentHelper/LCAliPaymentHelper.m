//
//  LCAliPaymentHelper.m
//  LinkCity
//
//  Created by Roy on 8/9/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCAliPaymentHelper.h"
#import "LCAliOrder.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

@implementation LCAliPaymentHelper

- (void)payEarnestWithPlanGuid:(NSString *)planGuid
                     withTitle:(NSString *)planTitle
                   orderNumber:(NSInteger)orderNumber
                  orderContact:(NSString *)orderContact
                    orderScore:(NSInteger)orderScore
                     recmdUuid:(NSString *)recmdUuid
               isNeedInsurance:(BOOL)isNeedInsurance
{
    self.planTilte = planTitle;
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
                [self doClientPay];
            }else{
                [self clientDidPaySucceed:YES];
            }
        }
    }];
}

- (void)payTailWithOrderGuid:(NSString *)orderGuid {
    [YSAlertUtil showHudWithHint:@"创建订单"];
    [LCNetRequester planTailOrderNew:orderGuid wxPay:0 callBack:^(LCPartnerOrderModel *partnerOrder, LCWxPrepayModel *wxPrepay, NSError *error) {
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
    [LCNetRequester userMarginOrderNew:marginValue wxPay:0 callBack:^(NSString *orderGuid, NSDecimalNumber *marginValue, LCWxPrepayModel *wxPrepay, NSError *error) {
        [YSAlertUtil hideHud];
        
        if (error) {
            if ([self.delegate respondsToSelector:@selector(paymentHelper:didPayMarginSucceed:error:)]) {
                [self.delegate paymentHelper:self didPayMarginSucceed:NO error:error];
            }
        }else{
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


//Override
- (void)doClientPay {
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088612921972742";
    NSString *seller = @"account@linkcity.cc";
    NSString *privateKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAME8rchSMCfV5OVR\
    7TulVBMXDS5F2WRNSggaxL5jQozvYfah25kAZvrKvlJVfuXLqXsn4MxI8ydONX2z\
    8vo50PHZJwISCcbqU5dxkTxiOmvxTGyZwCveWsl8gddV53HwDsVR0DdPbeeU/z9Y\
    EB+Aw6xcJ//1XIF9ag8vCza0/7LXAgMBAAECgYA5KzeKxW4Dyw8uHR/ffpkyEKbQ\
    os+fEhKt9SVx4jHlOkk0S0yJponQ9rx55VtmputcST8DkS2G2meO6fcfuo0rC7iF\
    56eXgu7ilRYc/qr/IKH+q/IRSoM22hsxd7SHIbV1m3ae5C3wlW7Ev+t5vJFkwC5z\
    mFNSID+ffKXebU9WqQJBAPYoVi4b1sy3AYH5yt70+UM35KF3yI3q0rEJ4gD8IpmT\
    IHRo2qcM7dZNuoK6fVMzy7tt+7GWhDEHXu6FNfa225sCQQDI9qYUGhnblvDoTq25\
    FprqYNsSllnGEpkm/mMr/SL4rbGbbG1m+LmVt//Tp5rB0iQTg5UHg60bWf2vqicY\
    wc91AkEA454u+poBiPEcssyBvKM4LuDrSCfUSu69/rkNxC1h7TKwCxS+Q0RgVQ8x\
    DRtXMe2uUVWFLRTqjc+sB9EkMkuqSwJBAIf0nXzB/7ZYUljHSa4LBfkEV5EmmEtx\
    L516wjrzQSJ918cvPoBISr1oQrG9FOyFLxTokv0Hbygu5HpgIZ0VGTUCQB/o9L0W\
    wmVyQpKGcd0W040uNM/UW8W3nc8DtSpujqbTFT34PN/Vf8OzzMj+wxNdVlfcNbWk\
    +dXS2zDewiitD2o=";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    LCAliOrder *order = [[LCAliOrder alloc] init];
    order.partner = partner;
    order.seller = seller;
    self.planTilte = [LCStringUtil getNotNullStr:self.planTilte];
    order.productName = self.planTilte; //商品标题
    
    if (self.isPayMargin) {
        order.tradeNO = self.marginOrderGuid;   //订单ID（由商家自行制定）
        order.productDescription = [NSString stringWithFormat:@"费用一共%@元",self.marginOrderValue]; //商品描述
        order.amount = [NSString stringWithFormat:@"%@",self.marginOrderValue]; //商品价格
    }else{
        order.tradeNO = self.partnerOrder.guid; //订单ID（由商家自行制定）
        order.productDescription = [NSString stringWithFormat:@"费用一共%@元",self.partnerOrder.orderPay]; //商品描述
        order.amount = [NSString stringWithFormat:@"%@",self.partnerOrder.orderPay]; //商品价格
    }
    
    order.notifyURL =  server_url([LCConstants serverHost], @"api/v3/pay/alipay/notify/"); //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"com.baiying.LinkCity.alipay";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"payOrderFunction reslut = %@",resultDic);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationAliPay object:nil userInfo:@{NotificationAliPayResultKey:resultDic}];
        }];
        
    }
}

- (void)notificationAction:(NSNotification *)notify{
    if ([notify.name isEqualToString:NotificationAliPay]) {
        //前端支付宝支付结果的通知
        NSString *paySuccess = @"false";
        NSInteger resultStatus = -1;
        
        NSDictionary *resultDic = [notify.userInfo valueForKey:NotificationAliPayResultKey];
        if ([[resultDic allKeys] containsObject:@"result"]) {
            NSString *resultString = [resultDic objectForKey:@"result"];
            NSArray *paramCuples = [resultString componentsSeparatedByString:@"&"];
            for(NSString *str in paramCuples){
                NSArray *aParamCouple = [str componentsSeparatedByString:@"="];
                if (aParamCouple && aParamCouple.count == 2) {
                    NSString *paramName = aParamCouple[0];
                    NSString *paramValue = aParamCouple[1];
                    if ([paramName isEqualToString:@"success"]) {
                        paySuccess = paramValue;
                    }
                }
            }
        }
        
        
        if ([[resultDic allKeys] containsObject:@"resultStatus"] ){
            resultStatus = [LCStringUtil idToNSInteger:[resultDic objectForKey:@"resultStatus"]];
        }
        
        if (([paySuccess isEqualToString:@"true"] || [paySuccess isEqualToString:@"\"true\""])
            && resultStatus == 9000) {
            //支付成功
            [self clientDidPaySucceed:YES];
        }else{
            //支付失败
            [self clientDidPaySucceed:NO];
        }
    }
}




@end
