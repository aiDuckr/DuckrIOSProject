//
//  LCPlanDetailPlaceCell.m
//  LinkCity
//
//  Created by 张宗硕 on 12/14/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCPlanDetailPlaceCell.h"

@implementation LCPlanDetailPlaceCell

- (void)awakeFromNib {
    self.placeNameLabel.layer.cornerRadius = 8;
    self.placeNameLabel.layer.masksToBounds = YES;
}

- (void)updateShowPlaceName:(NSString *)placeName {
    if ([placeName isEqualToString:@"-"]) {
        self.dashView.hidden = NO;
        self.placeNameLabel.hidden = YES;
    } else {
        self.placeNameLabel.text = placeName;
        self.dashView.hidden = YES;
        self.placeNameLabel.hidden = NO;
    }
}

+ (CGFloat)cellHeight{
    return 16;
}

+ (CGFloat)cellWidthForPlaceName:(NSString *)placeName{
    CGFloat width = 0;
    CGFloat maxWidth = DEVICE_WIDTH / 2.0;
    
    if ([placeName isEqualToString:@"-"]) {
        width = 21;
    }else{
        CGSize textSize = [placeName sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:FONT_LANTINGBLACK size:13]}];
        width = MIN(textSize.width+12, maxWidth);
    }
    
    return width;
}

@end
