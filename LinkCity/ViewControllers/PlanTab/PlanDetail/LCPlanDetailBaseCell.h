//
//  LCPlanDetailBaseCell.h
//  LinkCity
//
//  Created by roy on 2/16/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCPlanModel.h"

@interface LCPlanDetailBaseCell : UITableViewCell
@property (nonatomic, strong) LCPlanModel *plan;

+ (CGFloat)getCellHeightOfPlan:(LCPlanModel *)plan;

@end
