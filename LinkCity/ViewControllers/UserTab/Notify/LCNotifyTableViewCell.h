//
//  LCNotifyTableViewCell.h
//  LinkCity
//
//  Created by roy on 3/29/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCUserNotificationModel.h"

@protocol LCNotifyTableViewCellDelegate;
@interface LCNotifyTableViewCell : UITableViewCell
@property (nonatomic, strong) LCUserNotificationModel *userNotification;
@property (nonatomic, weak) id<LCNotifyTableViewCellDelegate> delegate;

//UI
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabeleading;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelTrailing;


@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *planCoverImageView;

+ (CGFloat)getCellHeight;
@end


@protocol LCNotifyTableViewCellDelegate <NSObject>

- (void)notifyTableViewCellDidClickAvatarButton:(LCNotifyTableViewCell *)cell;

@end