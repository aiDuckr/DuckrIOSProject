//
//  LCHomeHotThemeCell.m
//  LinkCity
//
//  Created by 张宗硕 on 7/28/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCHomeHotThemeCell.h"

@implementation LCHomeHotThemeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.scrollView.scrollsToTop = NO;
}

- (void)updateHomeHotThemeCell:(LCHomeRcmd *)homeRcmd {
    self.homeRcmd = homeRcmd;
    self.titleLabel.text = self.homeRcmd.title;
    [self updateScrollView];
}

- (void)updateScrollView {
    for (UIView *v in self.themeContentView.subviews) {
        [v removeFromSuperview];
    }
    const NSInteger themeWidth = 122.0f;
    const NSInteger themeHeight = 85.0f;
    self.themeContentWidthConstraint.constant = 12.0f + (themeWidth + 6.0f) * self.homeRcmd.homeCategoryArr.count + 12.0f;
    for (NSInteger i = 0; i < self.homeRcmd.homeCategoryArr.count; ++i) {
        LCHomeCategoryModel *model = [self.homeRcmd.homeCategoryArr objectAtIndex:i];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(12.0f + (themeWidth + 6.0f) * i, 0.0f, themeWidth, themeHeight)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, themeWidth, themeHeight)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [imageView setImageWithURL:[NSURL URLWithString:model.coverThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
        [view addSubview:imageView];
        
        UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, themeWidth, themeHeight)];
        shadowView.backgroundColor = UIColorFromRGBA(0x000000, 0.3f);
        [view addSubview:shadowView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(6.0f, (themeHeight - 18.0f) / 2.0f, themeWidth - 12.0f, 18.0f)];
        label.font = [UIFont fontWithName:APP_CHINESE_FONT size:15.0f];
        label.textColor = [UIColor whiteColor];
        label.text = model.title;
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
        
        [self.themeContentView addSubview:view];
    }
}

@end
