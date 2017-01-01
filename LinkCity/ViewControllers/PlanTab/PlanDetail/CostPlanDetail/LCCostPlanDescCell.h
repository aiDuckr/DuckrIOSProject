//
//  LCCostPlanDescCell.h
//  LinkCity
//
//  Created by Roy on 12/21/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LCCostPlanDescCellDelegate;
@interface LCCostPlanDescCell : UITableViewCell
//Data
@property (nonatomic, strong) LCPlanModel *plan;
@property (nonatomic, weak) id<LCCostPlanDescCellDelegate> delegate;

//UI
@property (weak, nonatomic) IBOutlet UILabel *departAndDestLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *stageCollectionView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *includeLabel;
@property (weak, nonatomic) IBOutlet UILabel *excludeLabel;
@property (weak, nonatomic) IBOutlet UILabel *refundLabel;


- (void)updateShowWithPlan:(LCPlanModel *)plan;
@end


@protocol LCCostPlanDescCellDelegate <NSObject>

- (void)costPlanDescCell:(LCCostPlanDescCell *)cell didClickStage:(LCPartnerStageModel *)stage;

@end