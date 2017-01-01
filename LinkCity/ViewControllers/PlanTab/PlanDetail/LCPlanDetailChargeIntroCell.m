//
//  LCPlanDetailChargeIntroCell.m
//  LinkCity
//
//  Created by roy on 2/16/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCPlanDetailChargeIntroCell.h"

@implementation LCPlanDetailChargeIntroCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setChargeIntro:(NSString *)chargeIntro{
    if ([LCStringUtil isNotNullString:chargeIntro]) {
        [self.chargeIntroLabel setText:chargeIntro withLineSpace:LCTextFieldLineSpace];
    }else{
        self.chargeIntroLabel.text = @"暂无";
    }
}

+ (CGFloat)getCellHeightForChargeIntro:(NSString *)chargeIntro{
    CGFloat height = 5;    //cell top
    
    if ([LCStringUtil isNullString:chargeIntro]) {
        chargeIntro = @"暂无";
    }
    height += [LCStringUtil getHeightOfString:chargeIntro withFont:[UIFont fontWithName:FONT_LANTINGBLACK size:13] lineSpace:LCTextFieldLineSpace labelWidth:(DEVICE_WIDTH-44)]; //comment cells
    height += 20; //margin up and below chargeIntroLabel

    height += 5; //cell bottom
    
    return height;
}


@end
