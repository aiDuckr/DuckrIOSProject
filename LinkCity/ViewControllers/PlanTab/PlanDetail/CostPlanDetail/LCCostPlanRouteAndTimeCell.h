//
//  LCCostPlanRouteAndTimeCell.h
//  LinkCity
//
//  Created by lhr on 16/4/23.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LCPlanModel;

@protocol LCCostPlanRouteAndTimeCellDelegate <NSObject>
- (void)costPlanRouteAndTimeChoosed:(LCPlanModel *)plan;

@end

@interface LCCostPlanRouteAndTimeCell : UITableViewCell

- (void)bindWithData:(LCPlanModel *)model;
@property (strong, nonatomic) LCPlanModel *plan;
@property (strong, nonatomic) id<LCCostPlanRouteAndTimeCellDelegate> delegate;
@end
