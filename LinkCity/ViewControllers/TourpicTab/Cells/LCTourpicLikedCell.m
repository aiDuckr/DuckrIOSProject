//
//  LCTourpicLikedCell.m
//  LinkCity
//
//  Created by 张宗硕 on 4/3/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCTourpicLikedCell.h"
#import "LCUserLikedListVC.h"

@implementation LCTourpicLikedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateLikedCell:(LCTourpic *)tourpic {
    self.tourpic = tourpic;
    
    self.likedLabel.text = [NSString stringWithFormat:@"赞（%ld）", (long)tourpic.likeNum];
    
    for(UIView *view in [self.likedView subviews]) {
        [view removeFromSuperview];
    }
    
    int i = 0;
    if (nil != tourpic.likedArr && tourpic.likedArr.count > 0) {
        for (i = 0; i < tourpic.likedArr.count; i++) {
            if (i < tourpic.likedArr.count) {
                CGFloat x = (24 + 9) * i;
                if (x + 24 + 9 > DEVICE_WIDTH - 45) {
                    break ;
                }
                LCUserModel *user = tourpic.likedArr[i];
                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, 0.0, 24.0, 24.0)];
                button.tag = i;
                button.layer.cornerRadius = 12.0f;
                button.layer.masksToBounds = YES;
                [button setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:user.avatarThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultAvatarImageName]];
                [button addTarget:self action:@selector(userAvatarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                [self.likedView addSubview:button];
            }
        }
    }
    
    if (self.tourpic.likeNum > 1) {
        self.moreButton.hidden = NO;
    } else {
        self.moreButton.hidden = YES;
    }
}

- (void)userAvatarButtonAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger index = button.tag;
    if (nil != self.tourpic.likedArr && self.tourpic.likedArr.count > index) {
        LCUserModel *user = [self.tourpic.likedArr objectAtIndex:index];
        UINavigationController *nav = [LCSharedFuncUtil getTopMostNavigationController];
        if (nil != nav) {
            [LCViewSwitcher pushToShowUserInfoVCForUser:user on:nav];
        }
    }
}

- (IBAction)moreLikedAction:(id)sender {
    UINavigationController *nav = [LCSharedFuncUtil getTopMostNavigationController];
    if (nil != nav) {
        LCUserLikedListVC *vc = [LCUserLikedListVC createInstance];
        vc.tourpic = self.tourpic;
        [nav pushViewController:vc animated:APP_ANIMATION];
    }
}

@end
