//
//  LCPlanMemberBottomCell.h
//  LinkCity
//
//  Created by roy on 3/17/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCPlanModel.h"


@protocol LCPlanMemberBottomCellDelegate;
@interface LCPlanMemberBottomCell : UICollectionViewCell
@property (nonatomic, weak) id<LCPlanMemberBottomCellDelegate> delegate;
@property (nonatomic, strong) LCPlanModel *plan;

@property (weak, nonatomic) IBOutlet UISwitch *banDisturbSwitch;

+ (CGFloat)getCellHeightForPlan:(LCPlanModel *)plan;
@end


@protocol LCPlanMemberBottomCellDelegate <NSObject>

- (void)planMemberBottomCellDidUpdateData:(LCPlanMemberBottomCell *)bottomCell;

@end