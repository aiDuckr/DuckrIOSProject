//
//  LCCostPlanDescView.h
//  LinkCity
//
//  Created by Roy on 12/21/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCCopyableLabel.h"

@interface LCCostPlanDescView : UIView
//Data
@property (nonatomic, strong) LCPlanModel *plan;

//UI
@property (weak, nonatomic) IBOutlet UILabel *departAndDestLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *stageCollectionView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet LCCopyableLabel *descLabel;
@property (weak, nonatomic) IBOutlet LCCopyableLabel *includeLabel;
@property (weak, nonatomic) IBOutlet LCCopyableLabel *excludeLabel;
@property (weak, nonatomic) IBOutlet LCCopyableLabel *refundLabel;


+ (instancetype)createInstance;
- (void)updateShowWithPlan:(LCPlanModel *)plan;
- (CGFloat)getHeightForPlan:(LCPlanModel *)plan;
@end
