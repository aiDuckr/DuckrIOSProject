//
//  LCSendPlanPriceCell.h
//  LinkCity
//
//  Created by Roy on 8/16/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCPartnerStageModel.h"

@protocol LCSendPLanPriceCellDelegate;
@interface LCSendPlanPriceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *holderView;
@property (weak, nonatomic) IBOutlet UILabel *stageIndexLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *timeButton;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UIButton *deleteStageButton;

@property (nonatomic, strong) LCPartnerStageModel *stage;

@property (nonatomic, weak) id<LCSendPLanPriceCellDelegate> delegate;


+ (CGFloat)getCellHeight;
- (void)updateShowWithStage:(LCPartnerStageModel *)stage isFirstStage:(BOOL)isFirst;
@end


@protocol LCSendPLanPriceCellDelegate <NSObject>

- (void)sendPlanPriceCell:(LCSendPlanPriceCell *)cell requestToShowView:(UIView *)v;
- (void)sendPlanPriceCellDidClickDeleteStageButton:(LCSendPlanPriceCell *)cell;

@end