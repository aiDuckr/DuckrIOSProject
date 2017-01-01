//
//  LCPlanDetailAThemeCell.m
//  LinkCity
//
//  Created by roy on 2/26/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCPlanDetailAThemeCell.h"

@implementation LCPlanDetailAThemeCell

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.themeLabel.layer.cornerRadius = 10;
    self.themeLabel.layer.masksToBounds = YES;
    self.themeLabel.layer.borderColor = UIColorFromRGBA(DUCKER_YELLOW, 1).CGColor;
    self.themeLabel.layer.borderWidth = 1;
}

//重用Cell后，会更新constraints，此时强制Cell重新布局
- (void)updateConstraintsIfNeeded{
    [super updateConstraintsIfNeeded];
    
    [self setNeedsLayout];
}

+ (CGSize)sizeOfAThemeCell:(LCRouteThemeModel *)theme{
    CGSize textSize = [theme.title sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:FONT_LANTINGBLACK size:13]}];
    return CGSizeMake(textSize.width+30+8, 24);
}
+ (CGFloat)heightOfAThemeCell{
    return 24;
}
@end
