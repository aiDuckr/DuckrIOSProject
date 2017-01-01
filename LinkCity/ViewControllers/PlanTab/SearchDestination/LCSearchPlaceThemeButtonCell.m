//
//  LCSearchPlaceThemeButtonCell.m
//  LinkCity
//
//  Created by 张宗硕 on 8/3/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCSearchPlaceThemeButtonCell.h"

@implementation LCSearchPlaceThemeButtonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.viewWidthConstraint.constant = (DEVICE_WIDTH - 24.0f - 26.0f - 13.0f) / 4.0f;
    self.labelButton.layer.borderColor = [UIColorFromRGBA(0xd7d5d2, 1.0f) CGColor];
    self.labelButton.layer.borderWidth = 0.5f;
    self.labelButton.layer.cornerRadius = 2.0f;
    self.labelButton.layer.masksToBounds = YES;
}

- (void)updateShowSearchPlaceThemeButtonCell:(NSString *)title {
    [self.labelButton setTitle:title forState:UIControlStateNormal];
}

- (IBAction)titleLabelAction:(id)sender {//collectionview上的cell上的button被点击以后通过代理传值。
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchPlaceThemeButtonDidClick:)]) {
        [self.delegate searchPlaceThemeButtonDidClick:self.labelButton.titleLabel.text];
    }
}
@end
