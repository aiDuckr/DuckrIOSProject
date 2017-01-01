//
//  LCPlanDetailChargeInfoCell.m
//  LinkCity
//
//  Created by Roy on 6/25/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCPlanDetailChargeInfoCell.h"

@implementation LCPlanDetailChargeInfoCell

- (void)awakeFromNib {
    self.containerView.layer.borderColor = UIColorFromRGBA(LCCellBorderColor, 1).CGColor;
    self.containerView.layer.borderWidth = LCCellBorderWidth;
    self.containerView.layer.cornerRadius = LCCellCornerRadius;
    self.containerView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPlan:(LCPlanModel *)plan{
    _plan = plan;
    
    
    if ([LCDecimalUtil isOverZero:self.plan.costPrice]) {
        //付款邀约
        switch ([self.plan getPlanRelation]) {
            case LCPlanRelationCreater:
//                self.titleLabel.text = [NSString stringWithFormat:@"已收款￥%@",self.plan.totalEarnest];
                self.titleLabel.text = @"收款信息";
                break;
            case LCPlanRelationMember:{
                LCUserModel *meInPlan = nil;
                for (LCUserModel *user in self.plan.memberList){
                    if ([user.uUID isEqualToString:[LCDataManager sharedInstance].userInfo.uUID]) {
                        meInPlan = user;
                        break;
                    }
                }
                
                if (meInPlan) {
                    if ([meInPlan paidTail]) {
                        LCPartnerOrderModel *tailOrder = meInPlan.tailOrder;
                        if ([meInPlan.partnerOrder.orderPrice compare:meInPlan.partnerOrder.orderEarnest] == NSOrderedSame) {
                            tailOrder = meInPlan.partnerOrder;
                        }
                        
                        self.titleLabel.text = [NSString stringWithFormat:@"付款码 %@",meInPlan.partnerOrder.orderCode];
                        self.rightLabel.text = @"已支付全款";
                    }else if ([meInPlan paidEarnest]) {
                        self.titleLabel.text = [NSString stringWithFormat:@"付款码 %@",meInPlan.partnerOrder.orderCode];
                        self.rightLabel.text = @"去支付尾款";
                    }
                }
            }
                break;
            case LCPlanRelationApplying:
            case LCPlanRelationKicked:
            case LCPlanRelationRejected:
            case LCPlanRelationScanner:
                break;
        }
    }
}


+ (CGFloat)getCellHeight{
    return 58;
}


@end
