//
//  LCCellTopView.m
//  LinkCity
//
//  Created by lhr on 16/6/14.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCCellTopView.h"

@interface LCCellTopView()


@property (weak, nonatomic) IBOutlet UIImageView *avatarView;

@property (weak, nonatomic) IBOutlet UILabel *nickLabel;

@property (weak, nonatomic) IBOutlet UIView *sexView;

@property (weak, nonatomic) IBOutlet UIImageView *sexIcon;

@property (weak, nonatomic) IBOutlet UILabel *ageLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end

@implementation LCCellTopView


+ (instancetype)createInstance {
    LCCellTopView *topView = [[[NSBundle mainBundle] loadNibNamed:@"LCCellTopView" owner:nil options:nil] objectAtIndex:0];
    return topView;
}

- (void)updateShowWithUserModel:(LCUserModel *)user withTimeLabelText:(NSString *)createTime{
    [self.avatarView setImageWithURL:[NSURL URLWithString:user.avatarThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultAvatarImageName]];
    self.nickLabel.text = user.nick;
    if (1 == user.sex) {
        self.sexView.hidden = NO;
        self.sexView.backgroundColor = UIColorFromRGBA(0x8ccbed, 1.0);
        self.sexIcon.image = [UIImage imageNamed:@"UserSexMale"];
    } else if (2 == user.sex) {
        self.sexView.hidden = NO;
        self.sexView.backgroundColor = UIColorFromRGBA(0xf4abc2, 1.0);
        self.sexIcon.image = [UIImage imageNamed:@"UserSexFemale"];
    } else {
        self.sexView.hidden = YES;
    }
    self.timeLabel.text = [LCDateUtil getTimeIntervalStringFromDateString:createTime];

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
