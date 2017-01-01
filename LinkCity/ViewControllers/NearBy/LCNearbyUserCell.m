//
//  LCNearbyUserCell.m
//  LinkCity
//
//  Created by roy on 3/9/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCNearbyUserCell.h"

@implementation LCNearbyUserCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (void)setUser:(LCUserModel *)user{
    _user = user;
    [self updateShow];
}

- (void)updateShow{
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:self.user.avatarThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultAvatarImageName]];
    self.nickLabel.text = [LCStringUtil getNotNullStr:self.user.nick];
    self.ageLabel.text = [self.user getUserAgeString];
    
    if (self.user.isIdentify == LCIdentityStatus_Done) {
        self.identifiedImageView.hidden = NO;
    }else{
        self.identifiedImageView.hidden = YES;
    }
    
    if ([self.user getUserSex] == UserSex_Male) {
        self.sexImageView.image = [UIImage imageNamed:LCSexMaleImageName];
    }else{
        self.sexImageView.image = [UIImage imageNamed:LCSexFemaleImageName];
    }
    
    //距离为0或小于0时，是不知道距离，因此不显示
    if (self.user.distance <= 0) {
        self.distanceLabel.text = @"";
    }else{
        if (self.user.distance >= 100) {
            self.distanceLabel.text = [NSString stringWithFormat:@"%.1fkm",self.user.distance/1000.0f];
        }else if (self.user.distance >= 10) {
            self.distanceLabel.text = [NSString stringWithFormat:@"%.2fkm",self.user.distance/1000.0f];
        }else {
            self.distanceLabel.text = [NSString stringWithFormat:@"%.3fkm",self.user.distance/1000.0f];
        }
    }
    
    if ([LCStringUtil isNotNullString:self.user.livingPlace]) {
        self.livingPlace.text = [NSString stringWithFormat:@"来自%@",self.user.livingPlace];
    }else{
        self.livingPlace.text = @"";
    }
    
    
    if ([LCStringUtil isNotNullString:self.user.professional] && ![self.user.professional isEqualToString:@"无"]) {
        NSString *proImageName = [[LCDataManager sharedInstance].professionDic objectForKey:self.user.professional];
        self.professionImageView.image = [UIImage imageNamed:proImageName];
        self.professionImageView.hidden = NO;
        self.serviceOneImageLeading.constant = 21;
    }else{
        self.professionImageView.hidden = YES;
        self.serviceOneImageLeading.constant = 3;
    }
    
    
    if (self.user.isCarVerify == LCIdentityStatus_Done) {
        self.serviceOneImageView.hidden = NO;
        self.serviceOneImageView.image = [UIImage imageNamed:@"ServiceCarIconForUser"];
        
        if (self.user.isTourGuideVerify == LCIdentityStatus_Done) {
            self.serviceTwoImageView.hidden = NO;
            self.serviceTwoImageView.image = [UIImage imageNamed:@"ServiceLeadIconForUser"];
        }else{
            self.serviceTwoImageView.hidden = YES;
        }
    }else{
        if (self.user.isTourGuideVerify == LCIdentityStatus_Done) {
            self.serviceOneImageView.hidden = NO;
            self.serviceOneImageView.image = [UIImage imageNamed:@"ServiceLeadIconForUser"];
        }else{
            self.serviceOneImageView.hidden = YES;
        }
        
        self.serviceTwoImageView.hidden = YES;
    }
    
    self.slogonLabel.text = [LCStringUtil getNotNullStr:self.user.signature];
}

+ (CGFloat)getCellHeight{
    return 90;
}

@end
