//
//  LCNotifyTableViewCell.m
//  LinkCity
//
//  Created by roy on 3/29/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCNotifyTableViewCell.h"

@implementation LCNotifyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUserNotification:(LCUserNotificationModel *)userNotification{
    _userNotification = userNotification;
    
    [self updateShow];
}

- (void)updateShow{
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:self.userNotification.avatarUrl] placeholderImage:[UIImage imageNamed:LCDefaultAvatarImageName]];
    self.nickLabel.text = [LCStringUtil getNotNullStr:self.userNotification.userName];
    
    if ([LCStringUtil isNotNullString:self.userNotification.userName]) {
        self.contentLabeleading.constant = 8;
    }else{
        self.contentLabeleading.constant = 0;
    }
    
    if ([LCStringUtil isNotNullString:self.userNotification.picUrl]) {
        self.planCoverImageView.hidden = NO;
        [self.planCoverImageView setImageWithURL:[NSURL URLWithString:self.userNotification.picUrl] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
        self.contentLabelTrailing.constant = 62;
    } else {
        self.planCoverImageView.hidden = YES;
        self.contentLabelTrailing.constant = 10;
    }
    self.contentLabel.text = [LCStringUtil getNotNullStr:self.userNotification.content];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy.MM.dd HH:mm"];
    NSDate *createDate = [LCDateUtil dateFromStringYMD_HMS:self.userNotification.createdTime];
    self.timeLabel.text = [LCStringUtil getNotNullStr:[df stringFromDate:createDate]];
    
}


- (IBAction)avatarButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(notifyTableViewCellDidClickAvatarButton:)]) {
        [self.delegate notifyTableViewCellDidClickAvatarButton:self];
    }
}


+ (CGFloat)getCellHeight{
    return 65;
}
@end
