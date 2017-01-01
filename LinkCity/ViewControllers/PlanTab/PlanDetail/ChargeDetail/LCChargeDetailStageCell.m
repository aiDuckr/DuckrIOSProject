//
//  LCChargeDetailStageCell.m
//  LinkCity
//
//  Created by Roy on 8/17/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCChargeDetailStageCell.h"

@implementation LCChargeDetailStageCell

+ (CGFloat)getCellHeight{
    return 48;
}

- (void)awakeFromNib {
    self.borderBgView.layer.borderColor = UIColorFromRGBA(LCCellBorderColor, 1).CGColor;
    self.borderBgView.layer.borderWidth = LCCellBorderWidth;
    self.borderBgView.layer.masksToBounds = YES;
    self.borderBgView.layer.cornerRadius = LCCellCornerRadius;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateShowWithStage:(LCPartnerStageModel *)stage isFirstCell:(BOOL)isFirst isLastCell:(BOOL)isLast{
    if (isFirst) {
        self.borderBgViewTop.constant = 0;
    }else{
        self.borderBgViewTop.constant = -6;
    }
    
    if (isLast) {
        self.borderBgViewBottom.constant = 0;
        self.bottomLine.hidden = YES;
    }else{
        self.borderBgViewBottom.constant = -6;
        self.bottomLine.hidden = NO;
    }
    
    
    NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %ld人支付", [stage getDepartTimeStr], (long)(stage.joinNumber-1)] attributes:@{NSFontAttributeName:[UIFont fontWithName:FONT_LANTINGBLACK size:14],                                                                                      NSForegroundColorAttributeName:UIColorFromRGBA(0xa8a4a0, 1)}];
    
    
    NSString *todayStr = [LCDateUtil getTodayStr];
    NSDate *now = [LCDateUtil dateFromString:todayStr];
    NSDate *startDate = [LCDateUtil dateFromString:stage.startTime];
    NSDate *endDate = [LCDateUtil dateFromString:stage.endTime];
    NSString *strToAppend = @"";
    UIColor *strColorToAppend = [UIColor clearColor];
    if ([now timeIntervalSinceDate:startDate] < 0) {
        //before start
        if (stage.joinNumber < stage.totalNumber) {
            strToAppend = @" (集合中)";
            strColorToAppend = UIColorFromRGBA(0xb6d827, 1);
        }else{
            strToAppend = @" (已报满)";
            strColorToAppend = UIColorFromRGBA(0xf44e4e, 1);
        }
    }else if ([now timeIntervalSinceDate:endDate] <= 0) {
        //before end
        strToAppend = @" (行程中)";
        strColorToAppend = UIColorFromRGBA(0xf44e4e, 1);
    }else{
        //after end
        strToAppend = @" (已结束)";
        strColorToAppend = UIColorFromRGBA(0xf44e4e, 1);
    }
    
    
    [contentStr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:strToAppend attributes:@{NSFontAttributeName:[UIFont fontWithName:FONT_LANTINGBLACK size:14],                                                                                      NSForegroundColorAttributeName:strColorToAppend}]];
    
    [self.contentLabel setAttributedText:contentStr];
    
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@", [LCDecimalUtil currencyStrFromDecimal:stage.totalEarnest]];
}





@end
