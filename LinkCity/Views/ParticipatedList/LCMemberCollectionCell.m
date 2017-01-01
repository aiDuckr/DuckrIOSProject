//
//  LCMemberCollectionCell.m
//  LinkCity
//
//  Created by roy on 11/14/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCMemberCollectionCell.h"

#define DefaultUserImage @"DetailDefaultUserIcon"
#define DefaultUserName @" "

@interface LCMemberCollectionCell()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;

@end
@implementation LCMemberCollectionCell

- (void)setUserInfo:(LCUserInfo *)userInfo{
    _userInfo = userInfo;
    
    if (self.userInfo) {
        [self.avatarImageView setImageWithURL:[NSURL URLWithString:self.userInfo.avatarThumbUrl]];
        self.nickLabel.text = self.userInfo.nick;
    }else{
        self.avatarImageView.image = nil;
        self.nickLabel.text = DefaultUserName;
    }
}

@end
