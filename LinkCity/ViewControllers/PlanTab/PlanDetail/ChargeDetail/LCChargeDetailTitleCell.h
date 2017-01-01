//
//  LCChargeDetailTitleCell.h
//  LinkCity
//
//  Created by Roy on 6/25/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCChargeDetailTitleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *chargeLabelBg;
@property (weak, nonatomic) IBOutlet UILabel *chargeLabel;

@property (weak, nonatomic) IBOutlet UIView *memberTitleView;
@property (weak, nonatomic) IBOutlet UIView *memberTitleBorderView;
@property (weak, nonatomic) IBOutlet UILabel *memberTitleLabel;



- (void)updateShowAsStageArrayForTotalEarnest:(NSDecimalNumber *)totalEarnest;
- (void)updateShowWithStage:(LCPartnerStageModel *)stage;

+ (CGFloat)getCellHeightWhetherShowMemberTitle:(BOOL)showMemberTitle;
@end
