//
//  LCPlanDetailChargeTitleCell.h
//  LinkCity
//
//  Created by Roy on 6/26/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCPlanDetailChargeTitleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellBottom;
@property (weak, nonatomic) IBOutlet UIImageView *imageBgView;
@property (weak, nonatomic) IBOutlet UIView *borderBgView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;


- (void)animateToFolded:(BOOL)toFolded;

+ (CGFloat)getCellHeight;
@end
