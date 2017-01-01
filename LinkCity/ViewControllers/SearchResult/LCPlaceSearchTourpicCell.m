//
//  LCPlaceSearchTourpicCell.m
//  LinkCity
//
//  Created by 张宗硕 on 12/18/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCPlaceSearchTourpicCell.h"

@implementation LCPlaceSearchTourpicCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateShowPlaceSearchTourpic:(LCTourpic *)tourpic {
    self.tourpic = tourpic;
    LCUserModel *user = tourpic.user;
    [self.avatarImageButton setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:user.avatarThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultAvatarImageName]];
    self.nickLabel.text = user.nick;
    self.ageLabel.text = [user getUserAgeString];
    
    if (UserSex_Male == [user getUserSex]) {
        self.sexImageView.image = [UIImage imageNamed:LCSexMaleImageName];
    } else {
        self.sexImageView.image = [UIImage imageNamed:LCSexFemaleImageName];
    }
    [self.tourpicImageView setImageWithURL:[NSURL URLWithString:tourpic.thumbPicUrl] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
    self.placeNameLabel.text = tourpic.placeName;
    self.likedNumLabel.text = [NSString stringWithFormat:@"%ld", (long)tourpic.likeNum];
    if (LCTourpicLike_IsUnlike == tourpic.isLike) {
        [self.likeButton setImage:[UIImage imageNamed:@"PlaceSearchTourpicUnlike"] forState:UIControlStateNormal];
    } else if (LCTourpicLike_IsLike == tourpic.isLike) {
        [self.likeButton setImage:[UIImage imageNamed:@"PlaceSearchTourpicLike"] forState:UIControlStateNormal];
    }
}


- (IBAction)likeButtonAction:(id)sender {
    if (![[LCDataManager sharedInstance] haveLogin]) {
        [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
        return ;
    }
    if (nil == self.tourpic) {
        return ;
    }
    if (LCTourpicLike_IsUnlike == self.tourpic.isLike) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(likeTourpicButtonAction:)]) {
            self.tourpic.likeNum++;
            self.tourpic.isLike = LCTourpicLike_IsLike;
            [self.likeButton setImage:[UIImage imageNamed:@"PlaceSearchTourpicLike"] forState:UIControlStateNormal];
            [self.delegate likeTourpicButtonAction:self];
        }
    } else if (LCTourpicLike_IsLike == self.tourpic.isLike) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(likeTourpicButtonAction:)]) {
            self.tourpic.likeNum--;
            self.tourpic.isLike = LCTourpicLike_IsUnlike;
            [self.likeButton setImage:[UIImage imageNamed:@"PlaceSearchTourpicUnlike"] forState:UIControlStateNormal];
            [self.delegate unLikeTourpicButtonAction:self];
        }
    }
}

- (IBAction)avatarButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(avatarSelectedButtonAction:)]) {
        [self.delegate avatarSelectedButtonAction:self];
    }
}

@end
