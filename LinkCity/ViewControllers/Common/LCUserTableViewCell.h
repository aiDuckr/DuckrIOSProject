//
//  LCUserDetailTableCell.h
//  LinkCity
//
//  Created by roy on 3/17/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCUserModel.h"


#define UserTableViewCellTopContentTrailingToEdge 0
#define UserTableViewCellTopContentTrailingToBtn 63

@protocol LCUserTableViewCellDelegate;
@interface LCUserTableViewCell : UITableViewCell
@property (nonatomic, assign) id<LCUserTableViewCellDelegate> delegate;
@property (nonatomic, strong) LCUserModel *user;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIButton *avatarButton;

@property (weak, nonatomic) IBOutlet UIImageView *identityImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;


@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *professionImageView;

@property (weak, nonatomic) IBOutlet UIImageView *firstServiceImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstServiceLeading;
@property (weak, nonatomic) IBOutlet UIImageView *secondServiceImageView;


@property (weak, nonatomic) IBOutlet UIButton *rightTopButton;
@property (weak, nonatomic) IBOutlet UILabel *rightTopLabel;
@property (weak, nonatomic) IBOutlet UILabel *topContentLabe;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topContentLabelTrailing;

@property (weak, nonatomic) IBOutlet UILabel *bottomContentLabel;

@property (weak, nonatomic) IBOutlet UIImageView *rightSelectionImageView;




+ (CGFloat)getCellHeight;
@end

@protocol LCUserTableViewCellDelegate <NSObject>
@optional
- (void)userTableViewCellDidClickRightTopButton:(LCUserTableViewCell *)userCell;
- (void)userTableViewCellDidClickAvatarButton:(LCUserTableViewCell *)userCell;

@end
