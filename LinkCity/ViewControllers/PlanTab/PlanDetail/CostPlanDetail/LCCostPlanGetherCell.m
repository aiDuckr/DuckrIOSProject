//
//  LCCostPlanGetherCell.m
//  LinkCity
//
//  Created by lhr on 16/4/24.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCCostPlanGetherCell.h"
@interface LCCostPlanGetherCell()
@property (weak, nonatomic) IBOutlet UILabel *gatherPlace;

@property (weak, nonatomic) IBOutlet UILabel *gatherTimeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *gatherTimeIcon;

@property (weak, nonatomic) IBOutlet UIImageView *gatherIcon;
@end

@implementation LCCostPlanGetherCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindWithData:(LCPlanModel *)model {
    self.gatherTimeLabel.text = [NSString stringWithFormat:@"集合时间:%@",[LCDateUtil getHourAndMinuteStrfromStr:model.gatherTime]];
    self.gatherPlace.text = [NSString stringWithFormat:@"集合地点:%@",model.gatherPlace];
}

@end
