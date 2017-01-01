//
//  LCHomeUserCell.m
//  LinkCity
//
//  Created by 张宗硕 on 5/16/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCHomeUserCell.h"
@interface LCHomeUserCell()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMarginAvatar;

@property (nonatomic,strong) UIImageView *listIconView;

@property (nonatomic,strong) UILabel *numberLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *focusWidthConstraint;


@end


@implementation LCHomeUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.focusButton.layer.borderColor = [UIColorFromRGBA(0xd7d5d2, 1.0) CGColor];
    self.focusButton.layer.borderWidth = 0.5f;
    _listIconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 16)];
    _numberLabel = [[UILabel alloc] init];
    //self.leftMarginAvatar.constant = 42.0f;
    
}

- (void)updateShowCell:(LCUserModel *)user withIndex:(NSInteger)index withType:(LCHomeUserCellType)type {
    [self updateShowCell:user withType:LCHomeUserCellViewType_HomepageRecm];
     self.leftMarginAvatar.constant = 47.0f;
    self.bottomLabel.text = user.signature;
    self.bottomSplitHeightConstraint.constant = 0.0f;
    self.lineSplitView.hidden = NO;
    [self.listIconView removeFromSuperview];
    [self.numberLabel removeFromSuperview];
    if (index < 3) {
        if (index == 0) {
            self.listIconView.image = [UIImage imageNamed:@"UserDackrListFirstUserIcon"];
        } else if (index == 1) {
            self.listIconView.image = [UIImage imageNamed:@"UserDackrListSecondUserIcon"];
        } else if (index == 2) {
            self.listIconView.image = [UIImage imageNamed:@"UserDackrListThirdUserIcon"];
        }
        [self.listIconView sizeToFit];
        self.listIconView.x = 12;
        self.listIconView.yCenter = self.height / 2;
        [self.contentView addSubview:self.listIconView];
    } else {
        self.numberLabel.text = [NSString stringWithFormat:@"%zd",(index + 1)];
        self.numberLabel.font = LCDefaultFontSize(15.0f);
        self.numberLabel.textColor = UIColorFromRGBA(0x2c2a28, 1.0);
        [self.numberLabel sizeToFit];
        self.numberLabel.center = CGPointMake(23, self.height / 2);
        [self.contentView addSubview:self.numberLabel];
        //[self layoutIfNeeded];
    }
    
    
}

- (void)updateShowCell:(LCUserModel *)user withType:(LCHomeUserCellType)type {
    self.user = user;
    [self.listIconView removeFromSuperview];
    [self.numberLabel removeFromSuperview];
    self.leftMarginAvatar.constant = 12.0f;
    self.user = user;
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:user.avatarThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultAvatarImageName]];
    self.nickLabel.text = user.nick;
    if (1 == user.sex) {
        self.sexView.hidden = NO;
        self.sexView.backgroundColor = UIColorFromRGBA(0x8ccbed, 1.0);
        self.sexImageView.image = [UIImage imageNamed:@"UserSexMale"];
    } else if (2 == user.sex) {
        self.sexView.hidden = NO;
        self.sexView.backgroundColor = UIColorFromRGBA(0xf4abc2, 1.0);
        self.sexImageView.image = [UIImage imageNamed:@"UserSexFemale"];
    } else {
        self.sexView.hidden = YES;
    }
    [self updateUserRelation:user];
    if (1 <= user.age && user.age <= 200) {
        self.ageLabel.text = [NSString stringWithFormat:@"%ld", (long)user.age];
    } else {
        self.ageLabel.text = @"-";
    }
    
    switch (type) {
        case LCHomeUserCellViewType_HomepageRecm:
            [self updateHomepageRecmLabel];
            break;
        case LCHomeUserCellViewType_HomepageDuckr:
            [self updateHomepageDuckrLabel];
            break;
        case LCHomeUserCellViewType_HomeRecmOnlineDuckr:
            [self updateHomeRecmOnlineDuckrLabel];
            break;
        case LCHomeUserCellViewType_HomeDuckrLocal:
            [self updateHomeDuckrLocalLabel];
            break;
        case LCHomeUserCellViewType_UserFansFavor:
            [self updateUserFansFavorLabel];
            break;
        case LCHomeUserCellViewType_ChatAddFriend:
            [self updateChatAddFriendLabel];
            break;
        case LCHomeUserCellViewType_ChatAddFriendSearch:
            [self updateChatAddFriendSearchLabel];
            break;
        case LCHomeUserCellViewType_ChatAddFriendNearbyDuckr:
            [self updateChatAddFriendNearbyDuckrLabel];
            break;
        default:
            [self clearMiddleBottomLabel];
            break;
    }
}

- (void)updateHomepageRecmLabel {
    self.lineSplitView.hidden = YES;
    self.bottomSplitHeightConstraint.constant = 13;
    self.middleLabel.text = [NSString stringWithFormat:@"去过%lu个城市", (unsigned long)self.user.haveGoNum];
    if ([LCStringUtil isNotNullString:self.user.livingPlace]) {
        self.bottomLabel.text = [NSString stringWithFormat:@"%@    %ld关注", self.user.livingPlace, (long)self.user.fansNum];
    } else {
        self.bottomLabel.text = [NSString stringWithFormat:@"%ld关注", (long)self.user.fansNum];
    }
}

- (void)updateHomepageDuckrLabel {
    self.lineSplitView.hidden = NO;
    self.bottomSplitHeightConstraint.constant = 0;
    self.middleLabel.text = [NSString stringWithFormat:@"%ld人关注", (long)self.user.fansNum];
    self.bottomLabel.text = self.user.signature;
}

- (void)updateHomeRecmOnlineDuckrLabel {
    self.lineSplitView.hidden = NO;
    self.bottomSplitHeightConstraint.constant = 0;
    self.middleLabel.text = [NSString stringWithFormat:@"%@", self.user.livingPlace];
    self.bottomLabel.text = self.user.signature;
}

- (void)updateHomeDuckrLocalLabel {
    self.lineSplitView.hidden = NO;
    self.bottomSplitHeightConstraint.constant = 0;
    if (self.user.distance > 0) {
        NSString *distanceStr = [LCStringUtil getDistanceString:self.user.distance];
        self.middleLabel.text = [NSString stringWithFormat:@"%@  |  %ld人关注", distanceStr, (long)self.user.fansNum];
    } else {
        self.middleLabel.text = [NSString stringWithFormat:@"%ld人关注", (long)self.user.fansNum];
    }
    self.bottomLabel.text = [self.user getUserStatusStr];
}

- (void)updateUserFansFavorLabel {
    self.lineSplitView.hidden = NO;
    self.bottomSplitHeightConstraint.constant = 0;
    self.middleLabel.text = [NSString stringWithFormat:@"%@", self.user.livingPlace];
    self.bottomLabel.text = self.user.signature;
}

- (void)updateChatAddFriendLabel {
    self.lineSplitView.hidden = NO;
    self.bottomSplitHeightConstraint.constant = 0;
    self.middleLabel.text = [NSString stringWithFormat:@"%@  |  %ld人关注", self.user.livingPlace, (long)self.user.fansNum];
}

- (void)updateChatAddFriendLabelWithMixedNumber:(NSInteger)num {
    switch (num) {
        // 标志UserList对应下标的对象的用户类型，0代表通讯录好友，-1为同城达客，-2代表在线达客，大于0的自然数n代表有n个共同好友
        case -2:
            self.bottomLabel.text = @"在线达客";
            break;
        case -1:
            self.bottomLabel.text = [NSString stringWithFormat:@"同城达客  %@", [LCStringUtil getDistanceString:self.user.distance]];
            break;
        case 0:
            self.bottomLabel.text = @"通讯录好友";
            break;
        default:
            self.bottomLabel.text = [NSString stringWithFormat:@"%ld个共同好友", (long)num];
            break;
    }
}

- (void)updateChatAddFriendSearchLabel {
    self.lineSplitView.hidden = NO;
    self.bottomSplitHeightConstraint.constant = 0;
    self.middleLabel.text = [NSString stringWithFormat:@"%@", self.user.livingPlace];
    self.bottomLabel.text = self.user.signature;
}

- (void)updateChatAddFriendSearchLabelWithKeyWord:(NSString *)keyWord {
    NSString *nickName = self.nickLabel.text;
    NSMutableAttributedString *nickLabelStr = [[NSMutableAttributedString alloc] initWithString:nickName];
    NSRange highLightRange = [[nickLabelStr string] rangeOfString:keyWord];
    [nickLabelStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGBA(0x00aff0, 1) range:highLightRange];
    [self.nickLabel setAttributedText:nickLabelStr];
}

- (void)updateChatAddFriendNearbyDuckrLabel {
    self.lineSplitView.hidden = NO;
    self.bottomSplitHeightConstraint.constant = 0;
    if (self.user.distance > 0) {
        NSString *distanceStr = [LCStringUtil getDistanceString:self.user.distance];
        self.middleLabel.text = [NSString stringWithFormat:@"%@  |  %ld人关注", distanceStr, (long)self.user.fansNum];
    } else {
        self.middleLabel.text = [NSString stringWithFormat:@"%ld人关注", (long)self.user.fansNum];
    }
    self.bottomLabel.text = self.user.signature;
}

- (void)clearMiddleBottomLabel {
    self.middleLabel.text = @"";
    self.bottomLabel.text = @"";
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
        
        if (LCUserModelRelation_EachFavored == user.relation) {
            self.focusButton.enabled = NO;
            self.focusWidthConstraint.constant = 75.0f;
            [self.focusButton setTitleColor:UIColorFromRGBA(0x7d7975, 1.0) forState:UIControlStateNormal];
            [self.focusButton setTitle:@"互相关注" forState:UIControlStateNormal];
            [self.focusButton setImage:nil forState:UIControlStateNormal];
            [self.focusButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
            [self.focusButton setContentEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
        } else if (LCUserModelRelation_Favored == user.isFavored) {
            self.focusButton.enabled = NO;
            self.focusWidthConstraint.constant = 64.0f;
            [self.focusButton setTitleColor:UIColorFromRGBA(0x7d7975, 1.0) forState:UIControlStateNormal];
            [self.focusButton setTitle:@"已关注" forState:UIControlStateNormal];
            [self.focusButton setImage:nil forState:UIControlStateNormal];
            [self.focusButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
            [self.focusButton setContentEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
        } else {
            self.focusButton.enabled = YES;
            self.focusWidthConstraint.constant = 52.0f;
            [self.focusButton setTitleColor:UIColorFromRGBA(0x2c2a28, 1.0) forState:UIControlStateNormal];
            [self.focusButton setTitle:@"关注" forState:UIControlStateNormal];
            [self.focusButton setImage:[UIImage imageNamed:@"TourpicFocusAdd"] forState:UIControlStateNormal];
            [self.focusButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 6.0f, 0.0f, 0.0f)];
            [self.focusButton setContentEdgeInsets:UIEdgeInsetsMake(0.0f, -2.0f, 0.0f, 0.0f)];
        }
    }
}

- (IBAction)focusButtonAction:(id)sender {
    if (![[LCDataManager sharedInstance] haveLogin]) {
        [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
        return ;
    }
    
    LCUserModel *user = self.user;
    if (0 == user.isFavored) {
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

@end
