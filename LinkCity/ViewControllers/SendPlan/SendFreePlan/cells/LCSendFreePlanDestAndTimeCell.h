//
//  LCSendFreePlanDestAndTimeCell.h
//  LinkCity
//
//  Created by lhr on 16/4/21.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCSendFreePlanDestAndTimeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *destField;
@property (weak, nonatomic) IBOutlet UITextField *timeField;
@property (weak, nonatomic) IBOutlet UIView *timeView;

- (void)updateShowWithPlan:(LCPlanModel *)plan;

@end
