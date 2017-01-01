//
//  LCUserInfoTopCell.h
//  LinkCity
//
//  Created by roy on 3/27/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCUserModel.h"

@protocol LCUserInfoTopCellDelegate;
@interface LCUserInfoTopCell : UITableViewCell
@property (nonatomic, strong) LCUserModel *user;
@property (nonatomic, weak) id<LCUserInfoTopCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
@property (weak, nonatomic) IBOutlet UIImageView *identifiedImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UIButton *favorBtn;
@property (weak, nonatomic) IBOutlet UIButton *followerBtn;


+ (CGFloat)getCellHeight;
@end


@protocol LCUserInfoTopCellDelegate <NSObject>

- (void)userInfoTopCellDidClickAvatar:(LCUserInfoTopCell *)topCell;
- (void)userInfoTopCellDidClickFavored:(LCUserInfoTopCell *)topCell;
- (void)userInfoTopCellDidClickFans:(LCUserInfoTopCell *)topCell;
- (void)userInfoTopCellDidClickPoint:(LCUserInfoTopCell *)topCell;
@end