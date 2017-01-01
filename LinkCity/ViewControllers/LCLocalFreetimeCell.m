//
//  LCLocalFreetimeCell.m
//  LinkCity
//
//  Created by linkcity on 16/7/29.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCLocalFreetimeCell.h"

@implementation LCLocalFreetimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)updateShowCell:(LCUserModel *)user {//设置CELL内容数据
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
    
    if (1 <= user.age && user.age <= 200) {
        self.ageLabel.text = [NSString stringWithFormat:@"%ld", (long)user.age];
    } else {
        self.ageLabel.text = @"-";
    }
    self.constellationLabel.text=user.professional;//星座(现改为职业标签)
    self.themeLabel.text=user.inviteThemeStr;//主题标签
    
    self.timeanddistanceLabel.text=[NSString stringWithFormat:@"%@km | %@",[LCStringUtil integerToString:user.distance],[LCDateUtil getTimeIntervalStringFromDateString:user.loginTime]];//时间距离标签
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
