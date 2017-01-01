//
//  LCFilterTagButtonCell.m
//  LinkCity
//
//  Created by 张宗硕 on 8/2/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCFilterTagButtonCell.h"

@implementation LCFilterTagButtonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.buttonWidthConstraint.constant = (DEVICE_WIDTH - 24.0f - 13.0f * 3) / 4.0f;
}

- (void)updateFilterTagButton:(LCRouteThemeModel *)model {
    [self.filterTagButton setTitle:model.title forState:UIControlStateNormal];
    self.filterTagButton.tag = model.tourThemeId;
}

@end
