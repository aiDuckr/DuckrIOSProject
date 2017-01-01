//
//  LCMerchantServiceCell.m
//  LinkCity
//
//  Created by 张宗硕 on 6/12/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCMerchantServiceCell.h"
#import "LCMerchantOrderDetailVC.h"

@implementation LCMerchantServiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateShowCell:(LCPlanModel *)plan {
    self.plan = plan;
    [self.coverImageView setImageWithURL:[NSURL URLWithString:self.plan.firstPhotoThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
    self.titleLabel.text = self.plan.declaration;
    self.contentLabel.text = self.plan.descriptionStr;
    self.timeLabel.text = [self.plan getPlanStartDateText];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@元/人", self.plan.costPrice];
}

- (IBAction)signUpInfoAction:(id)sender {
    LCMerchantOrderDetailVC *vc = [LCMerchantOrderDetailVC createInstance];
    vc.plan = self.plan;
    [[LCSharedFuncUtil getTopMostNavigationController] pushViewController:vc animated:APP_ANIMATION];
}

- (IBAction)planDetailAction:(id)sender {
    [LCViewSwitcher pushToShowPlanDetailVCForPlan:self.plan recmdUuid:@"" on:[LCSharedFuncUtil getTopMostNavigationController]];
}


@end
