//
//  LCSendPlanTourThemeCell.m
//  LinkCity
//
//  Created by 张宗硕 on 8/3/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCSendPlanTourThemeCell.h"

@implementation LCSendPlanTourThemeCell

- (void)awakeFromNib {
    self.containerViewWidthConstraint.constant = (DEVICE_WIDTH - 24.0f - 9.0f) / 2.0f;
}

- (void)updateShowSendPlanTourThemeCell:(LCRouteThemeModel *)theme {
    self.titleLabel.text = theme.title;
    self.descLabel.text = theme.themeDesc;
    [self.coverImageView setImageWithURL:[NSURL URLWithString:theme.coverUrl] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
}
@end
