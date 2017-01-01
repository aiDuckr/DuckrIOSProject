//
//  LCPlanDetailBaseCell.m
//  LinkCity
//
//  Created by roy on 2/16/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCPlanDetailBaseCell.h"

@implementation LCPlanDetailBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPlan:(LCPlanModel *)plan{
    _plan = plan;
}


// Must Override
+ (CGFloat)getCellHeightOfPlan:(LCPlanModel *)plan{
    return 200;
}



@end


