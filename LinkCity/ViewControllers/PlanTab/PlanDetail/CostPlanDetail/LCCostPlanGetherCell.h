//
//  LCCostPlanGetherCell.h
//  LinkCity
//
//  Created by lhr on 16/4/24.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LCPlanModel;
@interface LCCostPlanGetherCell : UITableViewCell
- (void)bindWithData:(LCPlanModel *)model;
@end
