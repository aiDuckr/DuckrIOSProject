//
//  GroupUserCollectionCell.m
//  LinkCity
//
//  Created by zzs on 14/11/30.
//  Copyright (c) 2014年 linkcity. All rights reserved.
//

#import "LCGroupUserCollectionCell.h"

@implementation LCGroupUserCollectionCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.avatarButton.layer.masksToBounds = YES;
    self.avatarButton.layer.cornerRadius = 6.0f;
}


- (IBAction)goToUserPage:(id)sender {
    if (nil != self.userInfo) {
        [self.delegate goToUserPage:self.userInfo];
    }
}

/// 点击用户头像减号踢人.
- (IBAction)kickOffUserAction:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(kickOffUserClicked:)])
    {
        [self.delegate kickOffUserClicked:self.userInfo];
    }
}

/// 点击头像
- (IBAction)clickUserAvatarAction:(id)sender
{
    if (nil == self.userInfo)
    {
        /// 踢人.
        if (self.delegate && [self.delegate respondsToSelector:@selector(kickOffBtnClicked)])
        {
            [self.delegate kickOffBtnClicked];
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelKickOffUser)])
    {
        [self.delegate cancelKickOffUser];
    }
}

@end
