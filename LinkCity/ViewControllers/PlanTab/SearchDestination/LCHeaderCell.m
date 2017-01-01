//
//  LCHeaderCell.m
//  LinkCity
//
//  Created by David Chen on 2016/8/24.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCHeaderCell.h"

@implementation LCHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(12.0f, 0.0f, 100.0f, 40.0f)];
        label1.font = [UIFont fontWithName:APP_CHINESE_FONT size:14.0f];
        label1.textColor = UIColorFromRGBA(0x7d7975, 1.0);
        label1.tag = 1;
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(DEVICE_WIDTH - 12.0f - 100.0f, 0.0f, 100.0f, 40.0f)];
        label2.textAlignment = NSTextAlignmentRight;
        label2.font = [UIFont fontWithName:APP_CHINESE_FONT size:14.0f];
        label2.textColor = UIColorFromRGBA(0xaba7a2, 1.0);
        label2.tag = 2;
        
        [self.contentView addSubview:label1];
        [self.contentView addSubview:label2];
    }
    return self;
}

- (void)setLabelText1:(NSString *)text1 labelText2:(NSString *)text2 {
    UILabel *l1 = [self.contentView viewWithTag:1];
    UILabel *l2 = [self.contentView viewWithTag:2];
    l1.text = text1;
    l2.text = text2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(CGSize)intrinsicContentSize {
    return CGSizeMake(DEVICE_WIDTH, 40);
}
@end
