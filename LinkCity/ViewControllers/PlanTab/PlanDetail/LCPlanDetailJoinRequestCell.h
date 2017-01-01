//
//  LCPlanDetailJoinRequestCell.h
//  LinkCity
//
//  Created by roy on 2/16/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCPlanDetailBaseCell.h"

@protocol LCPlanDetailJoinRequestCellDelegate;
@interface LCPlanDetailJoinRequestCell : LCPlanDetailBaseCell

//Data
@property (nonatomic, weak) id<LCPlanDetailJoinRequestCellDelegate> delegate;

//UI
@property (weak, nonatomic) IBOutlet UIImageView *topBg;
@property (weak, nonatomic) IBOutlet UIImageView *bottomBg;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end




@protocol LCPlanDetailJoinRequestCellDelegate <NSObject>

- (void)planDetailJoinRequestCell:(LCPlanDetailJoinRequestCell *)cell didClickSeeDetailButtonAtIndex:(NSInteger)applyingIndex;
- (void)planDetailJoinRequestCell:(LCPlanDetailJoinRequestCell *)cell didClickApproveButtonAtIndex:(NSInteger)applyingIndex;
- (void)planDetailJoinRequestCell:(LCPlanDetailJoinRequestCell *)cell didClickRefuseButtonAtIndex:(NSInteger)applyingIndex;

@end