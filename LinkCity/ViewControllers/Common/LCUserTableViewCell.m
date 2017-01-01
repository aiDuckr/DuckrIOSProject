//
//  LCUserDetailTableCell.m
//  LinkCity
//
//  Created by roy on 3/17/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCUserTableViewCell.h"

@implementation LCUserTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.rightTopButton.layer.borderWidth = 0.5;
    self.rightTopButton.layer.borderColor = UIColorFromRGBA(LCButtonBorderColor, 1).CGColor;
    [self.rightTopButton addTarget:self action:@selector(rightTopButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.avatarButton addTarget:self action:@selector(avatarButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setUser:(LCUserModel *)user{
    _user = user;
    
    [self updateShow];
}

- (void)updateShow{
    self.topContentLabe.hidden = YES;
    self.bottomContentLabel.hidden = YES;
    self.rightTopButton.hidden = YES;
    self.rightTopLabel.hidden = YES;
    self.rightSelectionImageView.hidden = YES;
    self.rightTopButton.backgroundColor = [UIColor yellowColor];
    
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:self.user.avatarThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultAvatarImageName]];
    self.nickLabel.text = [LCStringUtil getNotNullStr:self.user.nick];
    self.ageLabel.text = [self.user getUserAgeString];
    
    if (self.user.isIdentify == LCIdentityStatus_Done) {
        self.identityImageView.hidden = NO;
    }else{
        self.identityImageView.hidden = YES;
    }
    
    if ([self.user getUserSex] == UserSex_Male) {
        self.sexImageView.image = [UIImage imageNamed:LCSexMaleImageName];
    }else{
        self.sexImageView.image = [UIImage imageNamed:LCSexFemaleImageName];
    }
    
    
    if ([LCStringUtil isNotNullString:self.user.professional] && ![self.user.professional isEqualToString:@"无"]) {
        NSString *proImageName = [[LCDataManager sharedInstance].professionDic objectForKey:self.user.professional];
        self.professionImageView.image = [UIImage imageNamed:proImageName];
        self.professionImageView.hidden = NO;
        self.firstServiceLeading.constant = 21;
    }else{
        self.professionImageView.hidden = YES;
        self.firstServiceLeading.constant = 3;
    }
    
    
    if (self.user.isCarVerify == LCIdentityStatus_Done) {
        self.firstServiceImageView.hidden = NO;
        self.firstServiceImageView.image = [UIImage imageNamed:@"ServiceCarIconForUser"];
        
        if (self.user.isTourGuideVerify == LCIdentityStatus_Done) {
            self.secondServiceImageView.hidden = NO;
            self.secondServiceImageView.image = [UIImage imageNamed:@"ServiceLeadIconForUser"];
        }else{
            self.secondServiceImageView.hidden = YES;
        }
    }else{
        if (self.user.isTourGuideVerify == LCIdentityStatus_Done) {
            self.firstServiceImageView.hidden = NO;
            self.firstServiceImageView.image = [UIImage imageNamed:@"ServiceLeadIconForUser"];
        }else{
            self.firstServiceImageView.hidden = YES;
        }
        
        self.secondServiceImageView.hidden = YES;
    }
}

- (void)rightTopButtonAction{
    if ([self.delegate respondsToSelector:@selector(userTableViewCellDidClickRightTopButton:)]) {
        [self.delegate userTableViewCellDidClickRightTopButton:self];
    }
}

- (void)avatarButtonAction{
    if ([self.delegate respondsToSelector:@selector(userTableViewCellDidClickAvatarButton:)]) {
        [self.delegate userTableViewCellDidClickAvatarButton:self];
    }
}


+ (CGFloat)getCellHeight{
    return 95;
}

@end
