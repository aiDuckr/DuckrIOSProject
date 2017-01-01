//
//  LCBillSummarizeCell.m
//  LinkCity
//
//  Created by Roy on 6/25/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCBillSummarizeCell.h"

@implementation LCBillSummarizeCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.borderBgView.layer.borderColor = UIColorFromRGBA(LCCellBorderColor, 1).CGColor;
    self.borderBgView.layer.borderWidth = LCCellBorderWidth;
    self.borderBgView.layer.masksToBounds = YES;
    self.borderBgView.layer.cornerRadius = LCCellCornerRadius;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)updateShowWithProfitIn:(NSDecimalNumber *)profitIn isLastCell:(BOOL)isLast{
    NSDate *now = [NSDate date];
    NSDateFormatter *fm = [[NSDateFormatter alloc] init];
    [fm setDateFormat:@"yyyy年MM月"];
    self.titleLabel.text = [NSString stringWithFormat:@"%@您已入账：",[fm stringFromDate:now]];
    
    if ([LCDecimalUtil isNotNANDecimalNumber:profitIn]) {
        self.sumLabel.text = [NSString stringWithFormat:@"￥%@",profitIn];
    }else{
        self.sumLabel.text = @"请稍后";
    }
    
    
    NSDateComponents *comps = [LCDateUtil getComps:now];
    NSInteger month = [comps month];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:now];
    NSUInteger numberOfDaysInMonth = range.length;  //获取当月天数
    
    self.tipLabel.text = [NSString stringWithFormat:@"达客旅行会在%ld月%ld日给您转账",(long)month,(long)numberOfDaysInMonth];
    
    
    
    if (isLast) {
        self.borderBgBottom.constant = 0;
        self.bottomLine.hidden = YES;
    }else{
        self.borderBgBottom.constant = -6;
        self.bottomLine.hidden = NO;
    }
}


+ (CGFloat)getCellHeight{
    return 112;
}

@end
