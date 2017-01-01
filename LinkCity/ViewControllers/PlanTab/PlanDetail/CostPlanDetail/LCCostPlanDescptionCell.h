//
//  LCCostPlanDescptionCell.h
//  LinkCity
//
//  Created by lhr on 16/4/24.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LCCostPlanDescptionCellDelegate <NSObject>

- (void)LCCostPlanDescptionDidChangedHeight;
- (void)LCCostPlanDescptionCellToViewUserDetail:(LCUserModel *)user;

@end

@class LCPlanModel;
@interface LCCostPlanDescptionCell : UITableViewCell

@property (nonatomic,weak) id<LCCostPlanDescptionCellDelegate> delegate;

- (void)bindWithData:(LCPlanModel *)model;



@end
