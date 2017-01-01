//
//  LCPlanDetailAJoinRequestCell.m
//  LinkCity
//
//  Created by roy on 2/16/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCPlanDetailAJoinRequestCell.h"

@implementation LCPlanDetailAJoinRequestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (IBAction)agreeButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(planDetailAJoinRequestCellDidAgree:)]) {
        [self.delegate planDetailAJoinRequestCellDidAgree:self];
    }
}
- (IBAction)ignoreButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(planDetailAJoinRequestCellDidIgnore:)]) {
        [self.delegate planDetailAJoinRequestCellDidIgnore:self];
    }
}




@end
