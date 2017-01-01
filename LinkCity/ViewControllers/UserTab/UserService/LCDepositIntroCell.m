//
//  LCDepositIntroCell.m
//  LinkCity
//
//  Created by Roy on 6/25/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCDepositIntroCell.h"


@implementation LCDepositIntroCell



- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentLabel setText:[LCStringUtil getNotNullStr:[LCDataManager sharedInstance].orderRule.incomeDescription] withLineSpace:LCTextFieldLineSpace];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (CGFloat)getCellHeight{
    CGFloat height = 28;
    
    
    CGFloat contentHeight = [LCStringUtil getHeightOfString:[LCStringUtil getNotNullStr:[LCDataManager sharedInstance].orderRule.incomeDescription]
                                                           withFont:[UIFont fontWithName:FONT_LANTINGBLACK size:13]
                                                          lineSpace:LCTextFieldLineSpace
                                                         labelWidth:DEVICE_WIDTH-20-20];
    height += contentHeight;
    
    height += 50;
    
    return height;
}

@end
