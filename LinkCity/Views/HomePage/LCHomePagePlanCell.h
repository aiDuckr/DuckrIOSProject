//
//  LCHomePagePlanCell.h
//  LinkCity
//
//  Created by 张宗硕 on 11/8/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"
#import "EGOImageView.h"
#import "LCImageUtil.h"
#import "LCPlanApi.h"
#import "LCPlan.h"
#import "UIImageView+AFNetworking.h"
#import "UIButton+AFNetworking.h"
#import "LCAFNBlurredImageView.h"

@protocol LCHomePagePlanCellDelegate <NSObject>
@required
- (void)shareToSocialNetwork:(LCPlan *)plan;

@end

@interface LCHomePagePlanCell : UITableViewCell<LCPlanApiDelegate>

@property (nonatomic, retain) UIViewController *controller;
@property (nonatomic, retain) LCPlan *plan;

@property (weak, nonatomic) IBOutlet UILabel *destinationLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *dateLabelLeftLine;
@property (weak, nonatomic) IBOutlet UIView *dateLabelRightLine;

@property (weak, nonatomic) IBOutlet UILabel *declarationLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *shareNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *planTypeTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *planScaleLabel;
@property (weak, nonatomic) IBOutlet UILabel *fovarLabel;
@property (weak, nonatomic) IBOutlet UILabel *forwardLabel;
@property (weak, nonatomic) IBOutlet UIImageView *planTypeIconImageView;
@property (weak, nonatomic) IBOutlet UIButton *favorButton;
@property (weak, nonatomic) IBOutlet UIView *avatarView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *destinationLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *declarationLabelWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstGapWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondGapWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdGapWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fourGapWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fiveGapWidthConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellBottomLineHeight;


@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UIButton *avatarBtn;

@property (weak, nonatomic) IBOutlet UIButton *firstPartnerImageBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondPartnerImageBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirdPartnerImageBtn;
@property (weak, nonatomic) IBOutlet UIButton *fourPartnerImageBtn;
@property (weak, nonatomic) IBOutlet UIButton *fivePartnerImageBtn;
@property (weak, nonatomic) IBOutlet UIButton *sixPartnerImageBtn;

@property (weak, nonatomic) IBOutlet UILabel *firstPartnerLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondPartnerLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdPartnerLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourPartnerLabel;
@property (weak, nonatomic) IBOutlet UILabel *fivePartnerLabel;
@property (weak, nonatomic) IBOutlet UILabel *sixPartnerLabel;

@property (nonatomic, retain) NSMutableArray *avatarImageBtns;
@property (nonatomic, retain) NSMutableArray *nameLabels;

@property (nonatomic, retain) id<LCHomePagePlanCellDelegate> delegate;
@end
