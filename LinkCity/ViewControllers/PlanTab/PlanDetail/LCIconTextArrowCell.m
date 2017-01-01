//
//  LCIconTextArrowCell.m
//  LinkCity
//
//  Created by 张宗硕 on 12/14/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCIconTextArrowCell.h"

@implementation LCIconTextArrowCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateShowIconText:(NSString *)textStr withIconImageName:(NSString *)imageNameStr {
    self.middleTextLabel.text = textStr;
    if ([LCStringUtil isNotNullString:imageNameStr]) {
        self.iconImageView.image = [UIImage imageNamed:imageNameStr];
    }
}
@end
