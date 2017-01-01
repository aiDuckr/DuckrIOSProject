//
//  LCCostPlanCell.h
//  LinkCity
//
//  Created by 张宗硕 on 5/9/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    LCCostPlanCellViewType_Plan,
    LCCostPlanCellViewType_Tourpic,
} LCCostPlanCellViewType;

@class LCCostPlanCell;
@protocol LCCostPlanCellDelegate <NSObject>
- (void)chooseUpperRightButton:(LCCostPlanCell *)cell;

@end

@interface LCCostPlanCell : UITableViewCell
@property (nonatomic, strong) LCPlanModel *plan;
@property (assign, nonatomic) LCCostPlanCellViewType type;
@property (assign, nonatomic) BOOL isChoosed;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *departDestLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UIButton *upperRightButton;
@property (weak, nonatomic) IBOutlet UIButton *themeButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLabelGapConstraint;

@property (weak, nonatomic) IBOutlet UIView *usersView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *usersViewWidthConstraint;
@property (weak, nonatomic) IBOutlet UILabel *likeOrBuyLabel;
@property (weak, nonatomic) IBOutlet UILabel *editSelectLabel;
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;

@property (strong, nonatomic) id<LCCostPlanCellDelegate> delegate;

- (void)updateShowWithPlan:(LCPlanModel *)plan;
- (void)updateUpperRightButton:(BOOL)isChoosed;

@end
