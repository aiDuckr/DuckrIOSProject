//
//  LCCostPlanTourPlanCell.h
//  LinkCity
//
//  Created by lhr on 16/4/24.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LCPlanModel;
@protocol LCCostPlanTourPlanCellDelegate <NSObject>

- (void)jumpToTourPlanDetail;

@end

@interface LCCostPlanTourPlanCell : UITableViewCell

@property (weak, nonatomic) id <LCCostPlanTourPlanCellDelegate> delegate;

- (void)bindWithData:(LCPlanModel *)model;


@end
