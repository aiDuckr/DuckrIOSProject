//
//  LCNearbyUserCell.m
//  LinkCity
//
//  Created by roy on 11/30/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCNearbyUserCell.h"
#import "EGOImageView.h"

@interface LCNearbyUserCell()
@property (weak, nonatomic) IBOutlet EGOImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *separteLineHeight;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;


@end
@implementation LCNearbyUserCell

- (void)awakeFromNib {
//    self.avatarImageView.layer.cornerRadius = self.sexImageView.frame.size.width/2.0;
//    self.avatarImageView.layer.masksToBounds = YES;
    self.separteLineHeight.constant = 0.5;
    [self.bottomLine.superview bringSubviewToFront:self.bottomLine];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUser:(LCUserNearby *)user{
    _user = user;
    [self updateShow];
}

- (void)updateShow{
    self.nickLabel.text = self.user.nick;
    self.avatarImageView.imageURL = [NSURL URLWithString:self.user.avatarThumbUrl];
    
    if ([self.user.sex isEqualToString:SEX_MALE_STRING]) {
        self.sexImageView.image = [UIImage imageNamed:@"NearbyMale"];
    }else if([self.user.sex isEqualToString:SEX_FEMALE_STRING]){
        self.sexImageView.image = [UIImage imageNamed:@"NearbyFemale"];
    }
    
    NSInteger age = self.user.age;
    if (age<0) {
        self.ageLabel.text = @"-";
    }else{
        self.ageLabel.text = [NSString stringWithFormat:@"%lu",(long)self.user.age];
    }
    
    NSInteger distance = self.user.distance;
    distance = MAX(0, distance);
    NSString *distanceStr = nil;
    if (distance<900) {
        distanceStr = [NSString stringWithFormat:@"%d00m以内",(distance/100+1)];
    }else{
        distanceStr = [NSString stringWithFormat:@"%dkm以内",(distance/1000+1)];
    }
    self.distanceLabel.text = distanceStr;
}

@end
