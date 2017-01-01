//
//  LCNetRequester+Order.m
//  LinkCity
//
//  Created by Roy on 6/28/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCNetRequester+Order.h"

@implementation LCNetRequester (Order)

//获取费用说明
+ (void)getOrderRuleWithCallBack:(void(^)(LCOrderRuleModel *orderRule, NSError *error))callBack{
    [[self getInstance] doGet:URL_GET_ORDER_RULE withParams:nil requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                LCOrderRuleModel *orderRule = [[LCOrderRuleModel alloc] initWithDictionary:[dataDic dicOfObjectForKey:@"RuleOrder"]];
                callBack(orderRule, error);
            }else{
                callBack(nil, error);
            }
        }
    }];
}

//获取商家所有盈利邀约
+ (void)getPlanProfitList:(NSString *)userUUID      // 商家的UUID
                  isClear:(BOOL)isClear     // 可选填，为0或空，返回未结算的（已入账和未入账）的邀约，为1返回已结算的邀约
                 callBack:(void(^)(NSDecimalNumber *profitIn,        // 已入账金额
                                   NSDecimalNumber *profitOut,       // 未入账金额
                                   NSDecimalNumber *profitClear,     // 已结算金额
                                   NSArray *planArray,      // PartnerPlan 数据结构
                                   NSError *error))callBack{
    if ([LCStringUtil isNullString:userUUID]) {
        if (callBack) {
            callBack(nil,nil,nil,nil, [NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        return;
    }
    
    NSDictionary *param = @{@"UserUUID":userUUID,
                            @"IsClear":[NSNumber numberWithBool:isClear]};
    
    [[self getInstance] doPost:URL_GET_PROFIT_PLAN_LIST withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                NSDecimalNumber *profitIn = [NSDecimalNumber decimalNumberWithDecimal:[[dataDic objectForKey:@"ProfitIn"] decimalValue]];
                profitIn = [LCDecimalUtil getTwoDigitRoundDecimal:profitIn];
                NSDecimalNumber *profitOut = [NSDecimalNumber decimalNumberWithDecimal:[[dataDic objectForKey:@"ProfitOut"] decimalValue]];
                profitOut = [LCDecimalUtil getTwoDigitRoundDecimal:profitOut];
                NSDecimalNumber *profitClear = [NSDecimalNumber decimalNumberWithDecimal:[[dataDic objectForKey:@"ProfitClear"] decimalValue]];
                profitClear = [LCDecimalUtil getTwoDigitRoundDecimal:profitClear];
                
                NSMutableArray *planArray = [[NSMutableArray alloc] init];
                for (NSDictionary *planDic in [dataDic arrayForKey:@"PlanList"]){
                    LCPlanModel *aPlan = [[LCPlanModel alloc] initWithDictionary:planDic];
                    if (aPlan) {
                        [planArray addObject:aPlan];
                    }
                }
                
                callBack(profitIn, profitOut, profitClear, planArray, error);
            }else{
                callBack(nil, nil, nil, nil, error);
            }
        }
    }];
}


//新建订单
+ (void)planOrderNew:(NSString *)planGuid       // 必填，邀约的Guid
            orderNum:(NSInteger)orderNum         // 必填，订单人数
          orderScore:(NSInteger)orderScore      // 可选填，使用的积分数，默认为0
        orderContact:(NSString *)orderContact   // [{"Name":"何海","Telephone":"18611521840"},{"Name":"伍海江","Telephone":"18611521841"}]
               wxPay:(NSInteger)isWxPay  //可选填，用于生成微信预付单，不填则代表是支付宝支付
           recmdUuid:(NSString *)recmdUuid  //推荐人/领队的uuid
     isNeedInsurance:(BOOL)isNeedInsurance  //是否使用保险
            callBack:(void(^)(LCPartnerOrderModel *partnerOrder,
                              LCWxPrepayModel *wxPrepay,
                              NSError *error))callBack{
    
    if ([LCStringUtil isNullString:planGuid] ||
        [LCStringUtil isNullString:orderContact]) {
        if (callBack) {
            callBack(nil, nil, [NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        return;
    }
    
    NSDictionary *param = @{@"PlanGuid":planGuid,
                            @"OrderNumber":[NSNumber numberWithInteger:orderNum],
                            @"OrderScore":[NSNumber numberWithInteger:orderScore],
                            @"OrderContact":orderContact,
                            @"WxPay":[NSNumber numberWithInteger:isWxPay],
                            @"IsNeedInsurance":[NSNumber numberWithBool:isNeedInsurance]};
    NSMutableDictionary *mutableParam = [NSMutableDictionary dictionaryWithDictionary:param];
    
    if ([LCStringUtil isNotNullString:recmdUuid]) {
        [mutableParam setObject:recmdUuid forKey:@"RecmdUuid"];
    }
    
    [[self getInstance] doPost:URL_PLAN_ORDER_NEW withParams:mutableParam requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                LCPartnerOrderModel *partnerOrder = [[LCPartnerOrderModel alloc] initWithDictionary:[dataDic dicOfObjectForKey:@"PartnerOrder"]];
                LCWxPrepayModel *wxPrepay = [[LCWxPrepayModel alloc] initWithDictionary:[dataDic dicOfObjectForKey:@"WxPrepay"]];
                callBack(partnerOrder, wxPrepay, error);
            }else{
                callBack(nil, nil, error);
            }
        }
    }];
}

+ (void)planTailOrderNew:(NSString *)orderGuid
                   wxPay:(NSInteger)isWxPay
                callBack:(void (^)(LCPartnerOrderModel *,
                                   LCWxPrepayModel *,
                                   NSError *))callBack{
    
    if ([LCStringUtil isNullString:orderGuid]) {
        if (callBack) {
            callBack(nil, nil, [NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        return;
    }
    
    NSDictionary *param = @{@"OrderGuid":orderGuid,
                            @"WxPay":[NSNumber numberWithInteger:isWxPay]};
    
    [[self getInstance] doPost:URL_PLAN_TAIL_ORDER_NEW withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                LCPartnerOrderModel *partnerOrder = [[LCPartnerOrderModel alloc] initWithDictionary:[dataDic dicOfObjectForKey:@"TailOrder"]];
                LCWxPrepayModel *wxPrepay = [[LCWxPrepayModel alloc] initWithDictionary:[dataDic dicOfObjectForKey:@"WxPrepay"]];
                callBack(partnerOrder, wxPrepay, error);
            }else{
                callBack(nil, nil, error);
            }
        }
    }];
}

//支付成功更新订单
+ (void)planOrderQuery:(NSString *)orderGuid       // 必填，订单的Guid
               callBack:(void(^)(LCPartnerOrderModel *partnerOrder,
                                 NSError *error))callBack{
    
    if ([LCStringUtil isNullString:orderGuid]) {
        if (callBack) {
            callBack(nil, [NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        return;
    }
    
    NSDictionary *param = @{@"OrderGuid":orderGuid};
    [[self getInstance] doPost:URL_PLAN_ORDER_QUERY withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                LCPartnerOrderModel *partnerOrder = [[LCPartnerOrderModel alloc] initWithDictionary:[dataDic dicOfObjectForKey:@"PartnerOrder"]];
                callBack(partnerOrder, error);
            }else{
                callBack(nil, error);
            }
        }
    }];
}

//申请退款
+ (void)planOrderRefund:(NSString *)planGuid
                 refund:(NSInteger)refund       // 可选填，填0或不填是查询是否可以退款，填1是确认申请退款
               callBack:(void(^)(NSDecimalNumber *days,      // 距离出发还有多少天，精确到小数点后2位，目前的设计不需要用到
                                 LCRefundStatusType refundStatus,        //  是否可以退款，1代表可以，0代表不可以
                                 NSDecimalNumber *refundMoney,        // 退款金额 ＝ 订金 - 积分抵现，不可退款的时候为0
                                 NSInteger refundScore,     // 退还积分，不可退款的时候为0
                                 NSString *refundTitle, //"现在距出发日期超过3天，可以退还全额订金"  // 标题，不可退款的时候为“现在距出发日期不足3天”
                                 NSString *message,
                                 NSError *error))callBack{
    if ([LCStringUtil isNullString:planGuid]) {
        if (callBack) {
            callBack(nil, -1, nil, -1, nil, nil, [NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        return;
    }
    
    NSDictionary *param = @{@"PlanGuid":planGuid,
                            @"Refund":[NSNumber numberWithInteger:refund]};
    [[self getInstance] doPost:URL_PLAN_ORDER_REFUND withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic && [[dataDic allKeys] containsObject:@"Refund"]) {
                dataDic = [dataDic objectForKey:@"Refund"];
                
                NSDecimalNumber *days = [NSDecimalNumber decimalNumberWithDecimal:[[dataDic objectForKey:@"Days"] decimalValue]];
                NSInteger refundStatus = [[dataDic objectForKey:@"RefundStatus"] integerValue];
                NSDecimalNumber *refundMoney = [NSDecimalNumber decimalNumberWithDecimal:[[dataDic objectForKey:@"RefundMoney"] decimalValue]];
                refundMoney = [LCDecimalUtil getTwoDigitRoundDecimal:refundMoney];
                NSInteger refundScore = [[dataDic objectForKey:@"RefundScore"] integerValue];
                NSString *refundTitle = [LCStringUtil getNotNullStr:[dataDic objectForKey:@"RefundTitle"]];
                
                callBack(days, refundStatus, refundMoney, refundScore, refundTitle, message ,error);
            }else{
                callBack(nil, -1, nil, -1, nil, message, error);
            }
        }
    }];
}

//申请退款 v5.1

+ (void)planOrderRefund_V_FIVE:(NSString *)orderGuid
                        refund:(NSInteger)refund
                        reason:(NSString *)reason
                      callBack:(void (^)(NSDecimalNumber *days,
                                         LCRefundStatusType refundStatus,
                                         NSDecimalNumber *refundMoney,
                                         NSInteger refundScore,
                                         NSString *refundTitle,
                                         NSString *message,
                                         NSError *error))callBack {
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    if ([LCStringUtil isNullString:orderGuid]) {
        if (callBack) {
            callBack(nil, -1, nil, -1, nil, nil, [NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
        }
        return;
    }
    [param setObject:orderGuid forKey:@"OrderGuid"];
    [param setObject:[NSString stringWithFormat:@"%ld", (long)refund] forKey:@"Refund"];
    [param setObject:reason forKey:@"Reason"];
    
    [[self getInstance] doPost:URL_PLAN_ORDER_REFUND_V_FIVE withParams:param requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (!error) {
                dataDic = [dataDic objectForKey:@"Refund"];
                
                NSDecimalNumber *days = [NSDecimalNumber decimalNumberWithDecimal:[[dataDic objectForKey:@"Days"] decimalValue]];
                NSInteger refundStatus = [[dataDic objectForKey:@"RefundStatus"] integerValue];
                NSDecimalNumber *refundMoney = [NSDecimalNumber decimalNumberWithDecimal:[[dataDic objectForKey:@"RefundMoney"] decimalValue]];
                refundMoney = [LCDecimalUtil getTwoDigitRoundDecimal:refundMoney];
                NSInteger refundScore = [[dataDic objectForKey:@"RefundScore"] integerValue];
                NSString *refundTitle = [LCStringUtil getNotNullStr:[dataDic objectForKey:@"RefundTitle"]];
                
                callBack(days, refundStatus, refundMoney, refundScore, refundTitle, message, error);
            } else {
                callBack(nil, -1, nil, -1, nil, message, error);
            }
        }
    }];
    
    
    
}

+ (void)planOrderList:(NSString *)orderStr callBack:(void(^)(NSArray *planArray, NSString *orderStr, NSError *error))callBack {
    if ([LCStringUtil isNullString:orderStr]) {
        orderStr = @"";
    }
    [[self getInstance] doPost:URL_PLAN_ORDER_LIST withParams:@{@"OrderStr":orderStr} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        NSMutableArray *planArray = [[NSMutableArray alloc] initWithCapacity:0];
        if (callBack) {
            NSString *orderStr = [dataDic objectForKey:@"OrderStr"];
            NSArray *planDicArray = [dataDic objectForKey:@"PlanList"];
            
            for (NSDictionary *dic in planDicArray) {
                LCPlanModel *plan = [[LCPlanModel alloc] initWithDictionary:dic];
                if (nil != plan) {
                    [planArray addObject:plan];
                }
            }
            callBack(planArray, orderStr, error);
        }
    }];
}

//解析达客口令
+ (void)analysisShareCode:(NSString *)shareCode
                 callBack:(void(^)(LCPlanModel *plan, NSString *recmdUuid, NSError *error))callBack
{
    if ([LCStringUtil isNullString:shareCode]) {
        if (callBack) {
            callBack(nil, nil, [NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
            return;
        }
    }
    
    [[self getInstance] doGet:URL_ANALYSE_SHARECODE withParams:@{@"shareCode":shareCode} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (callBack) {
            if (dataDic) {
                NSDictionary *planDic = [dataDic dicOfObjectForKey:@"PartnerPlan"];
                LCPlanModel *plan = [[LCPlanModel alloc] initWithDictionary:planDic];
                
                NSString *recmdUuid = [dataDic objectForKey:@"RecmdUuid"];
                
                callBack(plan, recmdUuid, error);
            }else{
                callBack(nil ,nil ,error);
            }
        }
    }];
}

+ (void)confirmArrival:(NSString *)planGuid callBack:(void(^)(NSError *error))callBack {
    if ([LCStringUtil isNullString:planGuid]) {
        if (callBack) {
            callBack([NSError errorWithDomain:INPUT_ERROR_MESSAGE code:INPUT_ERROR_CODE userInfo:nil]);
            return ;
        }
    }
    
    NSString *latStr = [NSString stringWithFormat:@"%f", [LCDataManager sharedInstance].userLocation.lat];
    NSString *lngStr = [NSString stringWithFormat:@"%f", [LCDataManager sharedInstance].userLocation.lng];
    
    [[self getInstance] doPost:URL_PLAN_ARRIVAL withParams:@{@"PlanGuid": planGuid, @"Lat": latStr, @"Long": lngStr, @"LocType": @"1"} requestCallBack:^(NSDictionary *respondDic, int status, NSString *message, NSDictionary *dataDic, NSError *error) {
        if (!error) {
            callBack(nil);
        } else {
            callBack(error);
        }
    }];
}

@end
