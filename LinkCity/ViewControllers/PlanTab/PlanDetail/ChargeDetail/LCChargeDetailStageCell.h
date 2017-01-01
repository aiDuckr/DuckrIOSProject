//
//  LCChargeDetailStageCell.h
//  LinkCity
//
//  Created by Roy on 8/17/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCChargeDetailStageCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIView *borderBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *borderBgViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *borderBgViewBottom;

@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

- (void)updateShowWithStage:(LCPartnerStageModel *)stage isFirstCell:(BOOL)isFirst isLastCell:(BOOL)isLast;
+ (CGFloat)getCellHeight;
@end
