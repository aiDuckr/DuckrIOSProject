//
//  LCPlanDetailChargeInfoCell.h
//  LinkCity
//
//  Created by Roy on 6/25/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCPlanModel.h"

@interface LCPlanDetailChargeInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;


@property (nonatomic, strong) LCPlanModel *plan;

+ (CGFloat)getCellHeight;
@end
