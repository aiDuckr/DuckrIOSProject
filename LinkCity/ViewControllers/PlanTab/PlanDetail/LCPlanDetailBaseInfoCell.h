//
//  LCPlanDetailBaseInfoCell.h
//  LinkCity
//
//  Created by roy on 2/16/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCPlanDetailBaseCell.h"

@protocol LCPlanDtailBaseInfoCellDelegate;
@interface LCPlanDetailBaseInfoCell : LCPlanDetailBaseCell

//Data
@property (nonatomic, weak) id<LCPlanDtailBaseInfoCellDelegate> delegate;

//UI
@property (weak, nonatomic) IBOutlet UIImageView *topBg;
@property (weak, nonatomic) IBOutlet UIImageView *bottomBg;

@property (weak, nonatomic) IBOutlet UIImageView *createrAvatarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *createrIdentifiedIcon;
@property (weak, nonatomic) IBOutlet UILabel *createrNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *createrSexImageView;
@property (weak, nonatomic) IBOutlet UILabel *createrAgeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *serviceIcon;


@property (weak, nonatomic) IBOutlet UICollectionView *destinationCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *destinationCollectionViewHeight;

@property (weak, nonatomic) IBOutlet UILabel *destinationLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBgHeight;



@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;



@property (weak, nonatomic) IBOutlet UILabel *themeTitleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *themeCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *themeCollectionViewHeight;
@property (weak, nonatomic) IBOutlet UIImageView *themeBottomLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *themeBottomLineTop;



@property (weak, nonatomic) IBOutlet UIImageView *joinNeedIdentifiyIcon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *planDescriptionTop;
@property (weak, nonatomic) IBOutlet UILabel *planDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *imageButtonOne;
@property (weak, nonatomic) IBOutlet UIButton *imageButtonTwo;
@property (weak, nonatomic) IBOutlet UIButton *imageButtonThree;


@property (weak, nonatomic) IBOutlet UILabel *memberCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *memberDetailButton;
@property (weak, nonatomic) IBOutlet UIView *memberView;




@property (weak, nonatomic) IBOutlet UIImageView *locationImageView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *scanNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentNumLabel;


@end


@protocol LCPlanDtailBaseInfoCellDelegate <NSObject>

- (void)planDetailBaseInfoCellDidRequestToViewCreaterDetail:(LCPlanDetailBaseInfoCell *)cell;
- (void)planDetailBaseInfoCell:(LCPlanDetailBaseInfoCell *)cell didClickImageIndex:(NSInteger)imageIndex;
- (void)planDetailBaseInfoCell:(LCPlanDetailBaseInfoCell *)cell didClickMemberIndex:(NSInteger)memberIndex;
- (void)planDetailBaseInfoCellDidRequestToViewMemberDetail:(LCPlanDetailBaseInfoCell *)cell;

- (void)planDetailBaseInfoCell:(LCPlanDetailBaseInfoCell *)cell didClickDest:(NSString *)dest isDepart:(BOOL)isDepart;
- (void)planDetailBaseInfoCell:(LCPlanDetailBaseInfoCell *)cell didClickTheme:(LCRouteThemeModel *)theme;

@end
