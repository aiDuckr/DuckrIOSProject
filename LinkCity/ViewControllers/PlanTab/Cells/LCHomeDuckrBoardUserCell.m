//
//  LCHomeDuckrBoardUserCell.m
//  LinkCity
//
//  Created by 张宗硕 on 5/18/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCHomeDuckrBoardUserCell.h"

@implementation LCHomeDuckrBoardUserCell
- (void)updateShowCell:(LCUserModel *)user {
    self.user = user;
    self.nickLabel.text = user.nick;
    [self.avatarButton setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:user.avatarThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultAvatarImageName]];
    self.haveGoLabel.text = [NSString stringWithFormat:@"去过%lu个城市", (unsigned long)user.haveGoNum];
}

- (IBAction)avatarButtonAction:(id)sender {
    [LCViewSwitcher pushToShowUserInfoVCForUser:self.user on:[LCSharedFuncUtil getTopMostNavigationController]];
}

@end
