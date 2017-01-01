//
//  LCLocationPlanTabCalendarCell.m
//  LinkCity
//
//  Created by godhangyu on 16/5/17.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCLocationPlanTabCalendarCell.h"

@implementation LCLocationPlanTabCalendarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPlan:(LCPlanModel *)plan {
    _plan = plan;
    [self updateShow];
}

- (void)updateShow {
    [self.planImageView setImageWithURL:[NSURL URLWithString:_plan.firstPhotoUrl]];
    self.placeLabel.text = _plan.declaration;
    self.dateLabel.text = [_plan getSingleStartDateText];
    NSMutableAttributedString *priceStr = [[NSMutableAttributedString alloc] initWithString:[_plan getPlanCostPerPerson]];
    NSRange bigRange = NSMakeRange([[priceStr string] rangeOfString:@"起"].location, 3);
    [priceStr addAttribute:NSFontAttributeName value:LCDefaultFontSize(11) range:bigRange];
    [self.priceLabel setAttributedText:priceStr];
}

@end
