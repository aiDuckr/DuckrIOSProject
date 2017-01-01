//
//  LCPlanRouteCellForChargeInfo.m
//  LinkCity
//
//  Created by roy on 3/6/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCPlanRouteCellForChargeInfo.h"

@implementation LCPlanRouteCellForChargeInfo

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [[LCUIConstants sharedInstance] setViewAsInputBg:self.chargeInfoTextHolder];
    self.chargeInfoTextView.delegate = self;
    [self.chargeInfoTextView setPlaceholder:@"费用说明"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)getCellHeight{
    return 202 + 250;   //键盘高
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([self.delegate respondsToSelector:@selector(planRouteCellForChargeInfoDidBeginEdit:)]) {
        [self.delegate planRouteCellForChargeInfoDidBeginEdit:self];
    }
    
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if ([self.delegate respondsToSelector:@selector(planRouteCellForChargeInfoDidEndEdit:)]) {
        [self.delegate planRouteCellForChargeInfoDidEndEdit:self];
    }
    [textView resignFirstResponder];
    
    return YES;
}


@end
