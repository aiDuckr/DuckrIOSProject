//
//  LCPlanDetailQuitCell.m
//  LinkCity
//
//  Created by roy on 3/1/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCPlanDetailQuitCell.h"

@implementation LCPlanDetailQuitCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPlan:(LCPlanModel *)plan{
    [super setPlan:plan];
    
    [self updateShow];
}

+ (CGFloat)getCellHeightOfPlan:(LCPlanModel *)plan{
    return 70;
}

- (void)updateShow{
    NSString *submitButtonTitle = @"";
    switch ([self.plan getPlanRelation]) {
        case LCPlanRelationScanner:
        case LCPlanRelationKicked:
        case LCPlanRelationRejected:
        {
            if (self.plan.isNeedReview) {
                submitButtonTitle = LCApplyPlanButtonTitle;
            }else{
                submitButtonTitle = LCJoinPlanButtonTitle;
            }
        }
            break;
        case LCPlanRelationCreater:
        case LCPlanRelationMember:
        {
            if (self.plan.userNum == 1) {
                submitButtonTitle = LCDeletePlanButtonTitle;
            }else if(self.plan.userNum > 1){
                submitButtonTitle = LCQuitPlanButtonTitle;
            }
        }
            break;
        case LCPlanRelationApplying:
        {
            submitButtonTitle = LCApplyingPlanButtonTitle;
        }
            break;
    }
    [self.quitButton setTitle:submitButtonTitle forState:UIControlStateNormal];
}

- (IBAction)quitButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(planDetailQuitCellDidClickQuit:)]) {
        [self.delegate planDetailQuitCellDidClickQuit:self];
    }
}


@end
