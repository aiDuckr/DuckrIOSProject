//
//  LCHomeBannerCell.m
//  LinkCity
//
//  Created by 张宗硕 on 7/28/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCHomeBannerCell.h"

@implementation LCHomeBannerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateHomeBannerCell:(LCHomeRcmd *)homeRcmd {
    if (nil == homeRcmd || nil == homeRcmd.homeCategoryArr || homeRcmd.homeCategoryArr.count <= 0) {
        return ;
    }
    self.homeRcmd = homeRcmd;
    LCHomeCategoryModel *homeCategory = [homeRcmd.homeCategoryArr objectAtIndex:0];
    self.titleLabel.text = homeRcmd.title;
    [self.bannerImageView setImageWithURL:[NSURL URLWithString:homeCategory.coverThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
}

- (IBAction)bannerAction:(id)sender {
    if (nil != self.homeRcmd && nil != self.homeRcmd.homeCategoryArr && self.homeRcmd.homeCategoryArr.count > 0) {
        LCHomeCategoryModel *homeCategory = [self.homeRcmd.homeCategoryArr objectAtIndex:0];
        [LCViewSwitcher pushToShowHomeCategory:homeCategory on:[LCSharedFuncUtil getTopMostNavigationController]];
    }
}

@end
