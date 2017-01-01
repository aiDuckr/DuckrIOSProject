//
//  LCCostPlanArrangementCell.h
//  LinkCity
//
//  Created by lhr on 16/4/24.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCCopyableLabel.h"
@class LCPlanModel;

@protocol LCCostPlanArrangementCellDelegate <NSObject>

- (void)LCCostPlanArrangementDidChangedHeight;

@end
@interface LCCostPlanArrangementCell : UITableViewCell
@property (weak, nonatomic) IBOutlet LCCopyableLabel *includeLabel;

@property (weak, nonatomic) IBOutlet LCCopyableLabel *excludeLabel;

@property (weak, nonatomic) IBOutlet LCCopyableLabel *refundLabel;

@property (weak, nonatomic) id <LCCostPlanArrangementCellDelegate> delegate;

- (void)bindWithData:(LCPlanModel *)model;

@end
