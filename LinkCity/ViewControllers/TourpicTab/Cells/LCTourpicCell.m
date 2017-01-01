//
//  LCTourpicCell.m
//  LinkCity
//
//  Created by 张宗硕 on 4/2/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCTourpicCell.h"
#import "LCTourpicBaseView.h"


@implementation LCTourpicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)updateTourpicCell:(LCTourpic *)tourpic withType:(LCTourpicCellViewType)type {
    self.tourpic = tourpic;
    
    [self.avatarButtonView setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:tourpic.user.avatarThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultAvatarImageName]];
    
    self.nickLabel.text = tourpic.user.nick;
    self.contentLabel.text = tourpic.desc;
    
    if (1 <= tourpic.user.age && tourpic.user.age <= 200) {
        self.ageLabel.text = [NSString stringWithFormat:@"%ld", (long)tourpic.user.age];
    } else {
        self.ageLabel.text = @"-";
    }
    
    if (1 == tourpic.user.sex) {
        self.sexView.hidden = NO;
        self.sexView.backgroundColor = UIColorFromRGBA(0x8ccbed, 1.0);
        self.sexImageView.image = [UIImage imageNamed:@"UserSexMale"];
    } else if (2 == tourpic.user.sex) {
        self.sexView.hidden = NO;
        self.sexView.backgroundColor = UIColorFromRGBA(0xf4abc2, 1.0);
        self.sexImageView.image = [UIImage imageNamed:@"UserSexFemale"];
    } else {
        self.sexView.hidden = YES;
    }
    
    NSString *publishTime = [LCDateUtil getTimeIntervalStringFromDateString:tourpic.createdTime];
    self.timeLabel.text = publishTime;
    
    if (LCTourpicCellViewType_Detail == type || LCTourpicCellViewType_Homepage == type || LCTourpicCellViewType_FocusCell == type) {
        self.distanceLabel.text = @"";
    } else {
        self.distanceLabel.text = [LCStringUtil getDistanceString:tourpic.distance];
    }
    
    for (UIView *v in [self.photoContainerView subviews]) {
        [v removeFromSuperview];
    }
    
    UIView *contentView = [[UIView alloc] init];
    if (LCTourpicCellViewType_Detail == type && LCTourpicType_Video == self.tourpic.type && self.tourpic.photoUrls.count > 0) {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, DEVICE_WIDTH, DEVICE_WIDTH)];
        [image setImageWithURL:[NSURL URLWithString:[tourpic.thumbPhotoUrls objectAtIndex:0]] placeholderImage:[UIImage imageNamed:LCDefaultTourpicImageName]];
        [self.photoContainerView addSubview:image];
        
        NSString *url = [self.tourpic.photoUrls objectAtIndex:0];
        self.videoPathUrl = [AVAsset assetWithURL:[NSURL URLWithString:url]];
        self.videoPlayerView = [[LCTourVideoPlayerView alloc] initWithFrame: CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_WIDTH) url:self.videoPathUrl];
        [self.photoContainerView addSubview:self.videoPlayerView];
        [self.videoPlayerView play];
        contentView = self.videoPlayerView;
    } else {
        LCTourpicBaseView *view = [LCTourpicBaseView createInstance:tourpic];
        [view updateTourpicView:tourpic withType:type];
        [self.photoContainerView addSubview:view];
        contentView = view;
    }
    
    NSLayoutConstraint* leftConstraint = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.photoContainerView attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f];
    NSLayoutConstraint* topConstraint = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.photoContainerView attribute:NSLayoutAttributeTop multiplier:1.0f constant: 0.0f];
    NSLayoutConstraint* heightConstraint = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.photoContainerView attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f];
    NSLayoutConstraint* bottomConstraint = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.photoContainerView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f];

    leftConstraint.active = YES;
    topConstraint.active = YES;
    heightConstraint.active = YES;
    bottomConstraint.active = YES;
    
    if (LCTourpicCellViewType_Cell == type || LCTourpicCellViewType_Homepage == type) {
        self.bottomLineHeightConstraint.constant = 12.0f;
        self.contentLabel.numberOfLines = 3;
        self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    } else if (LCTourpicCellViewType_Detail == type) {
        self.bottomLineHeightConstraint.constant = 0.0f;
        self.contentLabel.numberOfLines = 0;
    }
    
    [self updateLikeView:tourpic];
    if (tourpic.commentNum <= 0) {
       self.commentLabel.text = @"评论";
    } else {
        self.commentLabel.text = [NSString stringWithFormat:@"%ld", (long)tourpic.commentNum];
    }
    
    if ([LCStringUtil isNotNullString:tourpic.placeName]) {
        self.placeLabel.text = [NSString stringWithFormat:@"于 %@", tourpic.placeName];
    }
    
    [self updateUserRelation:tourpic.user];
    
    if (LCTourpicCellViewType_Homepage == type) {
        self.focusButton.hidden = YES;
        self.isHotImageView.hidden = NO;
        if (LCNewOrHotType_New == self.tourpic.newOrHotType) {
            self.isHotImageView.image = [UIImage imageNamed:@"TourpicCellNew"];
        } else if (LCNewOrHotType_Hot == self.tourpic.newOrHotType) {
            self.isHotImageView.image = [UIImage imageNamed:@"TourpicCellHot"];
        } else {
            self.isHotImageView.hidden = YES;
            self.focusButton.hidden = NO;
        }
    } else {
        self.focusButton.hidden = NO;
        self.isHotImageView.hidden = YES;
    }
    if (LCTourpicCellViewType_FocusCell == type) {
        self.focusButton.hidden = YES;
    }
    // 自己看自己的旅图详情.
    if (LCTourpicCellViewType_Detail == type && nil != [LCDataManager sharedInstance].userInfo && [tourpic.user.uUID isEqualToString:[LCDataManager sharedInstance].userInfo.uUID]) {
        self.isHotImageView.hidden = YES;
        self.focusButton.hidden = YES;
    }
}

- (void)updateLikeView:(LCTourpic *)tourpic {
    if (tourpic.likeNum <= 0) {
        self.likedLabel.text = @"赞";
    } else {
        self.likedLabel.text = [NSString stringWithFormat:@"%ld", (long)tourpic.likeNum];
    }
    if (LCTourpicLike_IsLike == tourpic.isLike) {
        self.likeImageView.image = [UIImage imageNamed:@"TourpiclikedIcon"];
    } else {
        self.likeImageView.image = [UIImage imageNamed:@"TourpicUnlikeIcon"];
    }
}

- (void)updateUserRelation:(LCUserModel *)user {
    self.focusButton.titleLabel.font = [UIFont fontWithName:APP_CHINESE_FONT size:12.0f];
    if (([LCDataManager sharedInstance].userInfo && [user.uUID isEqualToString:[LCDataManager sharedInstance].userInfo.uUID])) {
        self.focusButton.hidden = YES;
    } else {
        self.focusButton.hidden = NO;
        self.focusButton.backgroundColor = [UIColor clearColor];
        self.focusButton.layer.borderColor = [UIColorFromRGBA(0xd7d5d2, 1.0) CGColor];
        self.focusButton.layer.borderWidth = 0.5f;
        [self.focusButton setTitleColor:UIColorFromRGBA(0x2c2a28, 1.0) forState:UIControlStateNormal];
        if (1 == user.isFavored) {
            self.focusButton.enabled = NO;
            [self.focusButton setTitle:@"已关注" forState:UIControlStateNormal];
            [self.focusButton setImage:nil forState:UIControlStateNormal];
            [self.focusButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
            [self.focusButton setContentEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
        } else {
            self.focusButton.enabled = YES;
            [self.focusButton setTitle:@"关注" forState:UIControlStateNormal];
            [self.focusButton setImage:[UIImage imageNamed:@"TourpicFocusAdd"] forState:UIControlStateNormal];
            [self.focusButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 6.0f, 0.0f, 0.0f)];
            [self.focusButton setContentEdgeInsets:UIEdgeInsetsMake(0.0f, -2.0f, 0.0f, 0.0f)];
        }
    }
}

- (IBAction)userAvatarButtonAction:(id)sender {
    LCUserModel *user = self.tourpic.user;
    UINavigationController *nav = [LCSharedFuncUtil getTopMostNavigationController];
    if (nil != nav) {
        [LCViewSwitcher pushToShowUserInfoVCForUser:user on:nav];
    }
}

- (IBAction)focusAction:(id)sender {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(tourpicFocusSelected:)]) {
//        [self.delegate tourpicFocusSelected:self];
//    }
    if (![[LCDataManager sharedInstance] haveLogin]) {
        [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
        return ;
    }
    LCUserModel *user = self.tourpic.user;
    if (1 == user.isFavored) {
        user.isFavored = 0;
        [LCNetRequester unfollowUser:user.uUID callBack:^(LCUserModel *user, NSError *error) {
            if (error) {
                [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
            } else {
                user.isFavored = 0;
            }
        }];
    } else {
        user.isFavored = 1;
        [LCNetRequester followUser:@[user.uUID] callBack:^(NSError *error) {
            if (error) {
                [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
            } else {
                user.isFavored = 1;
            }
        }];
    }
    [self updateUserRelation:user];
}

- (IBAction)likeAction:(id)sender {
    if (![[LCDataManager sharedInstance] haveLogin]) {
        [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
        return ;
    }
    
    if (LCTourpicLike_IsLike == self.tourpic.isLike) {
        self.tourpic.isLike = LCTourpicLike_IsUnlike;
        if (self.tourpic.likeNum - 1 >= 0) {
            self.tourpic.likeNum -= 1;
        }
        [LCNetRequester unlikeTourpic:self.tourpic.guid callBack:^(NSInteger likeNum, NSInteger isLike, NSError *error) {
            if (!error) {
                self.tourpic.likeNum = likeNum;
                self.tourpic.isLike = isLike;
            } else {
                [YSAlertUtil tipOneMessage:error.domain];
            }
        }];
    } else {
        self.tourpic.isLike = LCTourpicLike_IsLike;
        self.tourpic.likeNum += 1;
        // 1为点赞，2为转发
        [LCNetRequester likeTourpic:self.tourpic.guid withType:@"1" callBack:^(NSInteger likeNum, NSInteger forwardNum, NSInteger isLike, NSError *error) {
            if (!error) {
                self.tourpic.likeNum = likeNum;
                self.tourpic.forwardNum = forwardNum;
                self.tourpic.isLike = isLike;
            } else {
                [YSAlertUtil tipOneMessage:error.domain];
            }
        }];
    }
    [self updateLikeView:self.tourpic];
}

- (IBAction)commentAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tourpicCommentSelected:)]) {
        [self.delegate tourpicCommentSelected:self];
    }
}

@end
