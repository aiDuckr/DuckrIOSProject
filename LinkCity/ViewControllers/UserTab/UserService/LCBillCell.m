//
//  LCBillCell.m
//  LinkCity
//
//  Created by Roy on 6/25/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCBillCell.h"

@implementation LCBillCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.borderBg.layer.borderColor = UIColorFromRGBA(LCCellBorderColor, 1).CGColor;
    self.borderBg.layer.borderWidth = LCCellBorderWidth;
    self.borderBg.layer.masksToBounds = YES;
    self.borderBg.layer.cornerRadius = LCCellCornerRadius;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


- (void)updateShowWithPlan:(LCPlanModel *)plan isLastCell:(BOOL)isLast{
    self.plan = plan;
    
    self.sumLabel.text = [NSString stringWithFormat:@"￥%@",[LCDecimalUtil currencyStrFromDecimal:plan.totalEarnest]];
    
    if (plan.totalOrderStatus == LCPlanOrderStatus_InBill) {
        self.inBillLabel.hidden = NO;
        self.notInBillLabel.hidden = YES;
    }else if(plan.totalOrderStatus == LCPlanOrderStatus_OutBill) {
        self.inBillLabel.hidden = YES;
        self.notInBillLabel.hidden = NO;
    }
    
    //PlanInfoLabel
    NSString *routeStr = @"";
    if ([LCStringUtil isNotNullString:plan.departName]) {
        routeStr = [routeStr stringByAppendingString:plan.departName];
        routeStr = [routeStr stringByAppendingString:@"-"];
    }
    routeStr = [routeStr stringByAppendingString:[plan getDestinationsStringWithSeparator:@"-"]];
    
    NSString *timeStr = [LCDateUtil getDotDateFromHorizontalLineStr:self.plan.startTime];
    
    self.planInfoLabel.text = [NSString stringWithFormat:@"%@ %@",timeStr,routeStr];
    
    //PaymentInfoLabel
    NSInteger earnestUserNum = 0;
    NSInteger tailUserNum = 0;
    for(LCUserModel *user in self.plan.memberList){
        if ([user paidTail]) {
            tailUserNum += user.partnerOrder.orderNumber;
        }else if([user paidEarnest]) {
            earnestUserNum += user.partnerOrder.orderNumber;
        }
    }
    NSString *paymentInfoStr = [NSString stringWithFormat:@"单人￥%@",[LCDecimalUtil currencyStrFromDecimal:plan.costPrice]];
    if (earnestUserNum > 0) {
        paymentInfoStr = [paymentInfoStr stringByAppendingFormat:@"  %ld人付订金",(long)earnestUserNum];
    }
    if (tailUserNum > 0) {
        paymentInfoStr = [paymentInfoStr stringByAppendingFormat:@"  %ld人付全款",(long)tailUserNum];
    }
    self.paymentInfoLabel.text = paymentInfoStr;

    
    if (isLast) {
        self.borderBgBottom.constant = 0;
        self.bottomLine.hidden = YES;
    }else{
        self.borderBgBottom.constant = -6;
        self.bottomLine.hidden = NO;
    }
}

+ (CGFloat)getCellHeight{
    return 96;
}
@end
