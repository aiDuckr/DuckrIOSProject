//
//  LCFavorTableCell.m
//  LinkCity
//
//  Created by roy on 11/20/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCFavorTableCell.h"
#import "EGOImageView.h"
#import "LCDateUtil.h"

@interface LCFavorTableCell()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *bottomBarContainerView;

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *destinationLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *daysLabel;
@property (weak, nonatomic) IBOutlet EGOImageView *createrAvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *memeberNumLabel;
@property (weak, nonatomic) IBOutlet UIView *verticalLineRightToDestination;

@end
@implementation LCFavorTableCell

- (void)awakeFromNib {
    // Initialization code
    self.containerView.layer.cornerRadius = 5;
    self.containerView.layer.masksToBounds = YES;
//    self.containerView.layer.borderColor = UIColorFromR_G_B_A(229, 229, 229, 1).CGColor;
//    self.containerView.layer.borderWidth = 1;
    self.bottomBarContainerView.layer.cornerRadius = 5;
    self.bottomBarContainerView.layer.masksToBounds = YES;
    self.bottomBarContainerView.layer.borderColor = UIColorFromR_G_B_A(229, 229, 229, 1).CGColor;
    self.bottomBarContainerView.layer.borderWidth = 1;
    
    CALayer *verticalLineLayer = [CALayer layer];
    verticalLineLayer.frame = CGRectMake(0, 0, 50, 50);
    verticalLineLayer.backgroundColor = self.verticalLineRightToDestination.backgroundColor.CGColor;
    [self.verticalLineRightToDestination.layer addSublayer:verticalLineLayer];
    self.verticalLineRightToDestination.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setPartnerPlan:(LCPartnerPlan *)partnerPlan{
    self.coverImageView.backgroundColor = [LCImageUtil getColorFromColorStr:partnerPlan.coverColor];
    [self.coverImageView setImageWithURL:[NSURL URLWithString:partnerPlan.imageCover]];
    self.destinationLabel.text = partnerPlan.destinationName;
    self.startTimeLabel.text = [LCDateUtil getDotDateFromHorizontalLineStr:partnerPlan.startTime];
    NSInteger days = [LCDateUtil numberOfDaysFromTwoStr:partnerPlan.startTime withAnotherStr:partnerPlan.endTime];
    self.daysLabel.text = [NSString stringWithFormat:@"玩%tu天",days];
    
    if (partnerPlan.memberList && partnerPlan.memberList.count>0) {
        LCUserInfo *user = [partnerPlan.memberList objectAtIndex:0];
        self.createrAvatarImageView.imageURL = [NSURL URLWithString:user.avatarThumbUrl];
        self.nickNameLabel.text = user.nick;
        self.memeberNumLabel.text = [NSString stringWithFormat:@"%ld/%ld",partnerPlan.memberList.count,partnerPlan.scaleMax];
    }
}
- (void)setReceptionPlan:(LCReceptionPlan *)receptionPlan{
    self.coverImageView.backgroundColor = [LCImageUtil getColorFromColorStr:receptionPlan.coverColor];
    [self.coverImageView setImageWithURL:[NSURL URLWithString:receptionPlan.imageCover]];
    self.destinationLabel.text = receptionPlan.destinationName;
    self.startTimeLabel.text = [LCDateUtil getDotDateFromHorizontalLineStr:receptionPlan.startTime];
    NSInteger days = [LCDateUtil numberOfDaysFromTwoStr:receptionPlan.startTime withAnotherStr:receptionPlan.endTime];
    self.daysLabel.text = [NSString stringWithFormat:@"玩%tu天",days];
    
    if (receptionPlan.memberList && receptionPlan.memberList.count>0) {
        LCUserInfo *user = [receptionPlan.memberList objectAtIndex:0];
        self.createrAvatarImageView.imageURL = [NSURL URLWithString:user.avatarThumbUrl];
        self.nickNameLabel.text = user.nick;
        self.memeberNumLabel.text = [NSString stringWithFormat:@"%ld/%ld",receptionPlan.memberList.count,receptionPlan.scaleMax];
    }
}


@end
