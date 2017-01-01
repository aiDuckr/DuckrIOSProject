//
//  LCRecentChatListCell.m
//  LinkCity
//
//  Created by 张宗硕 on 11/20/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCChatListCell.h"

@implementation LCChatListCell

- (void)awakeFromNib {
    // Initialization code
    self.avatarImageView.placeholderImage = [UIImage imageNamed:@"ChatDefaultGroupAvatar"];
    self.avatarImageView.layer.cornerRadius = 3.0f;
    self.avatarImageView.layer.masksToBounds = YES;
    
    CALayer *dotLayer = [CALayer layer];
    dotLayer.frame = self.dotView.bounds;
    dotLayer.backgroundColor = UIColorFromR_G_B_A(255, 37, 59, 1).CGColor;
    [self.dotView.layer addSublayer:dotLayer];
    [self.dotView bringSubviewToFront:self.numberHintLabel];
}

- (IBAction)avatarAction:(id)sender {
    if ([self.cellObj isKindOfClass:[LCUserInfo class]]) {
        LCUserInfo *userInfo = (LCUserInfo *)self.cellObj;
        [LCViewSwitcher pushToShowUserInfo:userInfo onNavigationVC:self.naviVC];
    } else if ([self.cellObj isKindOfClass:[LCPlan class]]) {
        LCPlan *plan = (LCPlan *)self.cellObj;
        [LCViewSwitcher pushToShowDetailOfPlan:plan onNavigationVC:self.naviVC];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
