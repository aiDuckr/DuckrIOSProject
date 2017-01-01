//
//  LCFreePlanCell.h
//  LinkCity
//
//  Created by Roy on 12/10/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCFreePlanCell;
@protocol LCFreePlanCellDelegate <NSObject>

- (void)planLikeSelected:(LCFreePlanCell *)cell;
- (void)planCommentSelected:(LCFreePlanCell *)cell;

@end

@interface LCFreePlanCell : UITableViewCell
@property (nonatomic, strong) LCPlanModel *plan;
@property (nonatomic, assign) NSInteger hideThemeId;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UIView *sexView;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;
@property (weak, nonatomic) IBOutlet UILabel *professionalLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *firstPhotoBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondPhotoBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirdPhotoBtn;
@property (weak, nonatomic) IBOutlet UIImageView *firstPhotoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondPhotoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdPhotoImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *timeLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *likeImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaViewHeight;

@property (weak, nonatomic) IBOutlet UIButton *themeBtn1;
@property (weak, nonatomic) IBOutlet UIButton *themeBtn2;
@property (weak, nonatomic) IBOutlet UIButton *themeBtn3;
@property (weak, nonatomic) IBOutlet UIButton *themeBtn4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *themeViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagGapHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateTimeGapHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nickTopConstraint;



@property (weak,nonatomic) id <LCFreePlanCellDelegate> delegate;
- (void)updateShowWithPlan:(LCPlanModel *)plan hideThemeId:(NSInteger)themeId withSpaInset:(BOOL)isHaveInset;
- (void)updateShowWithPlan:(LCPlanModel *)plan hideThemeId:(NSInteger)themeId withDistance:(BOOL)showDistanceLabel withSpaInset:(BOOL)isHaveInset;

@end
