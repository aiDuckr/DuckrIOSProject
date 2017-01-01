//
//  LCPlanMemberBottomCell.m
//  LinkCity
//
//  Created by roy on 3/17/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCPlanMemberBottomCell.h"

@implementation LCPlanMemberBottomCell
- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.contentView.layer.masksToBounds = YES;
}

- (void)setPlan:(LCPlanModel *)plan{
    _plan = plan;
    
    [self updateShow];
}

- (void)updateShow{
    if (self.plan.isMember) {
        self.banDisturbSwitch.enabled = YES;
        if (self.plan.isAlert) {
            self.banDisturbSwitch.on = NO;
        }else{
            self.banDisturbSwitch.on = YES;
        }
    }else{
        self.banDisturbSwitch.enabled = NO;
    }
    
    switch ([self.plan getPlanRelation]) {
        case LCPlanRelationScanner:
        case LCPlanRelationKicked:
        case LCPlanRelationRejected:
        {
            self.banDisturbSwitch.enabled = NO;
        }
            break;
        case LCPlanRelationCreater:
        case LCPlanRelationMember:
        {
            self.banDisturbSwitch.enabled = YES;
        }
            break;
        case LCPlanRelationApplying:
        {
            self.banDisturbSwitch.enabled = NO;
        }
            break;
    }
}

- (IBAction)banDisturbSwitchAction:(UISwitch *)sender {
    sender.enabled = NO;
    
    
    //如果send.on，打开免打扰，则设置isAlert=0
    NSInteger setToAlert = sender.on?0:1;
    [LCNetRequester setPlanAlert:setToAlert planGuid:self.plan.planGuid callBack:^(NSInteger isAlert, NSError *error) {
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
        }
        
        self.plan.isAlert = isAlert;
        [self updateShow];
        if ([self.delegate respondsToSelector:@selector(planMemberBottomCellDidUpdateData:)]) {
            [self.delegate planMemberBottomCellDidUpdateData:self];
        }
        sender.enabled = YES;
    }];
}


+ (CGFloat)getCellHeightForPlan:(LCPlanModel *)plan{
    CGFloat height = 0;
    
    switch ([plan getPlanRelation]) {
        case LCPlanRelationScanner:
        case LCPlanRelationKicked:
        case LCPlanRelationRejected:
        {
            height = 0;
        }
            break;
        case LCPlanRelationCreater:
        case LCPlanRelationMember:
        {
            height = 72;
        }
            break;
        case LCPlanRelationApplying:
        {
            height = 0;
        }
            break;
    }
    return height;
}

@end
