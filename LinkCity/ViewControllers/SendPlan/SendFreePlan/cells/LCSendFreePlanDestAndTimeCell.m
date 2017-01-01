//
//  LCSendFreePlanDestAndTimeCell.m
//  LinkCity
//
//  Created by lhr on 16/4/21.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCSendFreePlanDestAndTimeCell.h"

@implementation LCSendFreePlanDestAndTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //self.timeField.allowsEditingTextAttributes = NO;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateShowWithPlan:(LCPlanModel *)plan {
    if (plan.destinationNames && plan.destinationNames.count > 0) {
        NSMutableString * string = [[NSMutableString alloc] init];
        for (NSString *placeName in plan.destinationNames) {
            [string appendString:placeName];
        }
        self.destField.text = string;
    }
    if (plan.startTime) {
        self.timeField.text = plan.startTime;
    }
}

@end
