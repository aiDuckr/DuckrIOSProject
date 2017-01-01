//
//  LCNetRequester+Order.h
//  LinkCity
//
//  Created by Roy on 6/28/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCNetRequester.h"
#import "LCOrderRuleModel.h"
#import "LCPartnerOrderModel.h"
#import "LCWxPrepayModel.h"

@interface LCNetRequester (Order)

//获取费用说明
+ (void)getOrderRuleWithCallBack:(void(^)(LCOrderRuleModel *orderRule, NSError *error))callBack;

//获取商家所有盈利邀约
+ (void)getPlanProfitList:(NSString *)userUUID      // 商家的UUID
                  isClear:(BOOL)isClear     // 可选填，为0或空，返回未结算的（已入账和未入账）的邀约，为1返回已结算的邀约
                 callBack:(void(^)(NSDecimalNumber *profitIn,        // 已入账金额
                                   NSDecimalNumber *profitOut,       // 未入账金额
                                   NSDecimalNumber *profitClear,     // 已结算金额
                                   NSArray *planArray,      // PartnerPlan 数据结构
                                   NSError *error))callBack;


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
                              NSError *error))callBack;

//新建支付尾款的订单
+ (void)planTailOrderNew:(NSString *)orderGuid
                   wxPay:(NSInteger)isWxPay
                callBack:(void(^)(LCPartnerOrderModel *partnerOrder,
                                  LCWxPrepayModel *wxPrepay,
                                  NSError *error))callBack;

//支付成功更新订单
+ (void)planOrderQuery:(NSString *)orderGuid       // 必填，订单的Guid
               callBack:(void(^)(LCPartnerOrderModel *partnerOrder,
                                 NSError *error))callBack;

//申请退款
+ (void)planOrderRefund:(NSString *)planGuid
                 refund:(NSInteger)refund       // 可选填，填0或不填是查询是否可以退款，填1是确认申请退款
               callBack:(void(^)(NSDecimalNumber *days,      // 距离出发还有多少天，精确到小数点后2位，目前的设计不需要用到
                                 LCRefundStatusType refundStatus,        //  是否可以退款，1代表可以，0代表不可以
                                 NSDecimalNumber *refundMoney,        // 退款金额 ＝ 订金 - 积分抵现，不可退款的时候为0
                                 NSInteger refundScore,     // 退还积分，不可退款的时候为0
                                 NSString *refundTitle, //"现在距出发日期超过3天，可以退还全额订金"  // 标题，不可退款的时候为“现在距出发日期不足3天”
                                 NSString *message,
                                 NSError *error))callBack;
//申请退款 v5.1
+ (void)planOrderRefund_V_FIVE:(NSString *)orderGuid
                        refund:(NSInteger)refund
                        reason:(NSString *)reason
                      callBack:(void(^)(NSDecimalNumber *days,
                                        LCRefundStatusType refundStatus,
                                        NSDecimalNumber *refundMoney,
                                        NSInteger refundScore,
                                        NSString *refundTitle,
                                        NSString *message,
                                        NSError *error))callBack;

+ (void)planOrderList:(NSString *)orderStr callBack:(void(^)(NSArray *planArray, NSString *orderStr, NSError *error))callBack;

//解析达客口令
+ (void)analysisShareCode:(NSString *)shareCode callBack:(void(^)(LCPlanModel *plan, NSString *recmdUuid, NSError *error))callBack;

+ (void)confirmArrival:(NSString *)planGuid callBack:(void(^)(NSError *error))callBack;

@end
