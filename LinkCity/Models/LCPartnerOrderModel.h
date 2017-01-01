//
//  LCPartnerOrderModel.h
//  LinkCity
//
//  Created by Roy on 6/27/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCBaseModel.h"

@interface LCPartnerOrderModel : LCBaseModel

@property (nonatomic, strong) NSString *guid;// 订单Guid

@property (nonatomic, assign) NSInteger orderNumber;// 订单数量
@property (nonatomic, strong) NSDecimalNumber *orderPrice;// 订单价格
@property (nonatomic, strong) NSDecimalNumber *orderEarnest;// 订金
@property (nonatomic, assign) NSInteger orderScore;// 使用积分，默认为0
@property (nonatomic, strong) NSDecimalNumber *orderScoreCash;// 积分兑现，默认为0
@property (nonatomic, strong) NSDecimalNumber *orderPay;// 支付金额（订金 － 积分兑现）

@property (nonatomic, strong) NSString *orderCode;// 付款码，付款之后生成的确认码，用于商家用户确认

@property (nonatomic, assign) NSInteger orderPayment;// 付款状态，0未付款，1支付宝，2微信, 3不需要付款
@property (nonatomic, assign) NSInteger orderRefund;// 退款状态，0未退款，1退款成功，2申请退款中，3商家确认退款
@property (nonatomic, assign) NSInteger orderClear;// 结算状态，0未结算，1已结算
@property (nonatomic, assign) NSInteger orderCheck;    //>!是否验票，0未验票，1已验票
@property (nonatomic, strong) NSString *orderRefundReason;    //!>退款原因

@property (nonatomic, strong) NSArray *orderContactNameArray;   // 订单联系人
@property (nonatomic, strong) NSArray *orderContactPhoneArray;
@property (nonatomic, retain) NSArray *orderContactIdentityArray;

@property (nonatomic, strong) NSString *refundTime;// 订单提出退款时间
@property (nonatomic, strong) NSString *createdTime;// 订单创建时间
@property (nonatomic, strong) NSString *updatedTime;// 订单更新时间


- (NSDecimalNumber *)getTotalEarnest;
- (NSDecimalNumber *)getTotalPrice;

@end

