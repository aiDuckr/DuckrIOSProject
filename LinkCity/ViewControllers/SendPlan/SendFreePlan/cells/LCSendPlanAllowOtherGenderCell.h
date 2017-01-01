//
//  LCSendPlanAllowOtherGenderCell.h
//  LinkCity
//
//  Created by lhr on 16/4/16.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCPlanModel.h"
@protocol LCSendPlanAllowOtherGenderCellDelegate  <NSObject>

- (void)didStateChanged:(LCGenderLimit)genderLimit;

@end

@interface LCSendPlanAllowOtherGenderCell : UITableViewCell

@property (assign, nonatomic) LCGenderLimit genderLimit;

@property (weak, nonatomic) id <LCSendPlanAllowOtherGenderCellDelegate> delegate;

- (void)updateShowWithPlan:(LCPlanModel *)plan;

@end
