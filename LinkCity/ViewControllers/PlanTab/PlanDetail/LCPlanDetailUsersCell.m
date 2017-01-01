//
//  LCPlanDetailUsersCell.m
//  LinkCity
//
//  Created by 张宗硕 on 12/15/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCPlanDetailUsersCell.h"
#import "LCUserLikedListVC.h"

@implementation LCPlanDetailUsersCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateShowDetailUsers:(LCPlanModel *)plan {
    for(UIView *view in [self.usersView subviews]) {
        [view removeFromSuperview];
    }
    self.plan = plan;
    NSString *userNumStr;
    if (plan.favorNumber && plan.favorNumber > 0) {
        userNumStr= [NSString stringWithFormat:@"%ld", (long)plan.favorNumber];
        self.userNumButton.hidden = NO;
        self.usersView.hidden = NO;
    } else {
        userNumStr= [NSString stringWithFormat:@"0"];
        self.userNumButton.hidden = YES;
        self.usersView.hidden = YES;
    }

    [self.userNumButton setTitle:userNumStr forState:UIControlStateNormal];
    self.userNumLabel.text = [NSString stringWithFormat:@"%@人感兴趣", userNumStr];

    if (nil != plan.favorUserArr && plan.favorUserArr.count > 0) {
        for (int i = 0; i < plan.favorUserArr.count; i++){
            if (i < 10) {
                //头像
                LCUserModel *user = plan.favorUserArr[i];
                CGFloat x = i * 10 + i * 25;
                if (x + 25 > DEVICE_WIDTH - 46) {
                    break ;
                }
                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, 0.0, 25.0, 25.0)];
                button.tag = i;
                button.layer.cornerRadius = 12.5;
                button.layer.masksToBounds = YES;
                [button setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:user.avatarThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultAvatarImageName]];
                [button addTarget:self action:@selector(userAvatarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                [self.usersView addSubview:button];
            }
        }
    }
}

- (void)userAvatarButtonAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger index = button.tag;
    if (nil != self.plan.favorUserArr && self.plan.favorUserArr.count > index) {
        LCUserModel *user = [self.plan.favorUserArr objectAtIndex:index];
        if (self.delegate && [self.delegate respondsToSelector:@selector(planDetailUsersCellToViewUserDetail:)]) {
            [self.delegate planDetailUsersCellToViewUserDetail:user];
        }
    }
}

- (IBAction)viewMoreButtonAction:(id)sender {
    UINavigationController *nav = [LCSharedFuncUtil getTopMostNavigationController];
    if (nil != nav) {
        LCUserLikedListVC *vc = [LCUserLikedListVC createInstance];
        vc.plan = self.plan;
        [nav pushViewController:vc animated:APP_ANIMATION];
    }
}


@end
