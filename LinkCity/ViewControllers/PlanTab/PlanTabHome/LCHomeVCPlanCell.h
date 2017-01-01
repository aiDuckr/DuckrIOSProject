//
//  LCHomeVCPlanCell.h
//  LinkCity
//
//  Created by Roy on 6/17/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCHomeVCPlanCell : UITableViewCell
// Data
@property (nonatomic, retain) LCPlanModel *plan;

// UI
@property (weak, nonatomic) IBOutlet UIImageView *planServiceImageView;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *topBg;
@property (weak, nonatomic) IBOutlet UIImageView *bottomBg;

@property (weak, nonatomic) IBOutlet UIImageView *createrAvatar;

@property (weak, nonatomic) IBOutlet UILabel *createrName;
@property (weak, nonatomic) IBOutlet UIImageView *createrSexImageView;
@property (weak, nonatomic) IBOutlet UILabel *createrAgeLabel;

@property (weak, nonatomic) IBOutlet UILabel *planSendLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *planDepartState;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;


@property (weak, nonatomic) IBOutlet UILabel *startPlaceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UILabel *destinationLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *destinationLabelLeading;

@property (weak, nonatomic) IBOutlet UILabel *planTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *planDescriptionLabel;

@property (weak, nonatomic) IBOutlet UIButton *planImageFirstButton;
@property (weak, nonatomic) IBOutlet UIButton *planImageSecondButton;
@property (weak, nonatomic) IBOutlet UIButton *planImageThirdButton;

@property (weak, nonatomic) IBOutlet UILabel *memberNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *planScanNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *planCommentNumLabel;


+ (CGFloat)getCellHightForPlan:(LCPlanModel *)plan;
@end
