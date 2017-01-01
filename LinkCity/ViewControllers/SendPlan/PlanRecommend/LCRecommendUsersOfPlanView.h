//
//  LCRecommendUsersOfPlanView.h
//  LinkCity
//
//  Created by roy on 6/1/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCRecommendUsersOfPlanViewDelegate;
@interface LCRecommendUsersOfPlanView : UIView
//UI
@property (weak, nonatomic) IBOutlet UIView *userViewHolder;
@property (weak, nonatomic) IBOutlet UIView *userViewInnerBorder;
@property (weak, nonatomic) IBOutlet UICollectionView *userCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userCollectionViewHeight;

@property (weak, nonatomic) IBOutlet UIButton *inviteAllButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *planSectionViewTop;


//Data
@property (nonatomic, strong) NSArray *userArray;
@property (nonatomic, strong) NSMutableArray *userSelectionArray;
@property (nonatomic, weak) id<LCRecommendUsersOfPlanViewDelegate> delegate;

+ (instancetype)createInstance;
+ (CGFloat)getViewHeightWithUsers:(NSArray *)userArray;
@end


@protocol LCRecommendUsersOfPlanViewDelegate <NSObject>
@optional
- (void)recommendUsersOfPlanViewDidClickSeePlanDetail:(LCRecommendUsersOfPlanView *)view;
- (void)recommendUsersOfPlanViewDidClickInvite:(LCRecommendUsersOfPlanView *)view;

@end