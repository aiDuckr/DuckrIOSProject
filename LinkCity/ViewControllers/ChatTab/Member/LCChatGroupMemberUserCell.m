//
//  LCChatRoomMemberCell.m
//  LinkCity
//
//  Created by roy on 3/11/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCChatGroupMemberUserCell.h"

@implementation LCChatGroupMemberUserCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setUser:(LCUserModel *)user{
    _user = user;
    
    [self updateShow];
}

- (void)updateShow{
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:self.user.avatarThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultAvatarImageName]];
}

+ (CGFloat)getCellHeight{
    return 75;
}

@end
