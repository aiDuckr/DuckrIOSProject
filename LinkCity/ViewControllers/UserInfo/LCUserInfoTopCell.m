//
//  LCUserInfoTopCell.m
//  LinkCity
//
//  Created by roy on 3/27/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCUserInfoTopCell.h"

@implementation LCUserInfoTopCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)getCellHeight{
    return 212;
}

- (void)setUser:(LCUserModel *)user{
    _user = user;
    
    [self.avatarButton setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:_user.avatarThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultAvatarImageName]];
    self.nickLabel.text = user.nick;
    self.ageLabel.text = [user getUserAgeString];
    if (user.isIdentify == LCIdentityStatus_Done) {
        self.identifiedImageView.hidden = NO;
    }else{
        self.identifiedImageView.hidden = YES;
    }
    if ([user getUserSex] == UserSex_Male) {
        self.sexImageView.image = [UIImage imageNamed:LCSexMaleImageName];
    }else{
        self.sexImageView.image = [UIImage imageNamed:LCSexFemaleImageName];
    }
    
    
    [self.favorBtn setTitle:[NSString stringWithFormat:@"关注 %ld",(long)user.favorNum] forState:UIControlStateNormal];
    [self.followerBtn setTitle:[NSString stringWithFormat:@"粉丝 %ld",(long)user.fansNum] forState:UIControlStateNormal];
}

- (IBAction)avatarButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(userInfoTopCellDidClickAvatar:)]) {
        [self.delegate userInfoTopCellDidClickAvatar:self];
    }
}
- (IBAction)favorBtnAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(userInfoTopCellDidClickFavored:)]) {
        [self.delegate userInfoTopCellDidClickFavored:self];
    }
}
- (IBAction)followerBtnAtion:(id)sender {
    if ([self.delegate respondsToSelector:@selector(userInfoTopCellDidClickFans:)]) {
        [self.delegate userInfoTopCellDidClickFans:self];
    }
}


@end
