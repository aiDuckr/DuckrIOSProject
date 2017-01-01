//
//  LCPlanDetailAJoinRequestCell.h
//  LinkCity
//
//  Created by roy on 2/16/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCPlanDetailAJoinRequestCell;
@protocol LCPlanDetailAJoinRequestCellDelegate <NSObject>
- (void)planDetailAJoinRequestCellDidAgree:(LCPlanDetailAJoinRequestCell *)cell;
- (void)planDetailAJoinRequestCellDidIgnore:(LCPlanDetailAJoinRequestCell *)cell;

@end


@interface LCPlanDetailAJoinRequestCell : UITableViewCell

//Data
@property (nonatomic, weak) id<LCPlanDetailAJoinRequestCellDelegate> delegate;
//UI
@property (weak, nonatomic) IBOutlet UIImageView *requesterAvatar;
@property (weak, nonatomic) IBOutlet UILabel *requesterNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;
@property (weak, nonatomic) IBOutlet UIButton *ignoreButton;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;


@end
