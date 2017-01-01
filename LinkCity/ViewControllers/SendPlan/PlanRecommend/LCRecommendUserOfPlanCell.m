//
//  LCRecommendUserOfPlanCell.m
//  LinkCity
//
//  Created by roy on 6/1/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCRecommendUserOfPlanCell.h"

@implementation LCRecommendUserOfPlanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.contentView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
}


- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    
    if (isSelected) {
        self.selectionImageView.image = [UIImage imageNamed:@"TourpicFavorCheck"];
    }else{
        self.selectionImageView.image = [UIImage imageNamed:@"TourpicFavorUncheck"];
    }
}

- (void)setUser:(LCUserModel *)user{
    _user = user;
    [self updateShow];
}

- (void)updateShow{
    if (self.user) {
        [self.avatarImageView setImageWithURL:[NSURL URLWithString:self.user.avatarThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultAvatarImageName]];
        self.nickLabel.text = [LCStringUtil getNotNullStr:self.user.nick];
        self.ageLabel.text = [self.user getUserAgeString];
        
        if ([self.user getUserSex] == SexMale) {
            self.sexImageView.image = [UIImage imageNamed:LCSexMaleImageName];
        }else{
            self.sexImageView.image = [UIImage imageNamed:LCSexFemaleImageName];
        }
    }
}

@end
