//
//  LCCostPlanJoinIntroCell.m
//  LinkCity
//
//  Created by lhr on 16/4/26.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCCostPlanJoinIntroCell.h"
#import "UILabel+LineSpace.h"
@interface LCCostPlanJoinIntroCell()

@property (weak, nonatomic) IBOutlet UILabel *joinedInfoLabel;

@end

@implementation LCCostPlanJoinIntroCell

- (void)awakeFromNib {
    [super awakeFromNib];
   // [self.joinedInfoLabel ]
    // Initialization code
}

- (void)bindWithData:(LCPlanModel *)model {
    [self.joinedInfoLabel setText:model.planTips withLineSpace:10];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
