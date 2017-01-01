//
//  LCSendCostPlanStageCell.h
//  LinkCity
//
//  Created by Roy on 12/15/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCSendCostPlanStageCellDelegate;
@interface LCSendCostPlanStageCell : UITableViewCell
@property (nonatomic, weak) id<LCSendCostPlanStageCellDelegate> delegate;
@property (nonatomic, strong) LCPartnerStageModel *stage;

@property (weak, nonatomic) IBOutlet UILabel *stageLabel;
@property (weak, nonatomic) IBOutlet UIButton *startDateBtn;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;

- (void)updateShowWithStage:(LCPartnerStageModel *)stage stageIndex:(NSInteger)index;
@end


@protocol LCSendCostPlanStageCellDelegate <NSObject>
@optional
- (void)sendCostPlanStageCellDidClickDate:(LCSendCostPlanStageCell *)cell;
- (void)sendCostPlanStageCell:(LCSendCostPlanStageCell *)cell willChangePriceTextTo:(NSString *)priceText;
- (void)sendCostPlanStageCellDidInputPrice:(LCSendCostPlanStageCell *)cell;

@end