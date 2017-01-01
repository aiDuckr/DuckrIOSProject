//
//  LCPlanTabTimeFilterView.m
//  LinkCity
//
//  Created by 张宗硕 on 6/21/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCPlanTabTimeFilterView.h"

@implementation LCPlanTabTimeFilterView
+ (instancetype)createInstance {
    UINib *nib = [UINib nibWithNibName:@"LCPlanTabTimeFilterView" bundle:nil];
    
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    LCPlanTabTimeFilterView *view = nil;
    
    for (UIView *v in views) {
        if ([v isKindOfClass:[LCPlanTabTimeFilterView class]]) {
            v.translatesAutoresizingMaskIntoConstraints = NO;
            view = (LCPlanTabTimeFilterView *)v;
        }
    }
    return view;
}

- (void)awakeFromNib {
    self.selectedIndex = -1;
    [self.buttonArr addObject:self.tomorrowButton];
    [self.buttonArr addObject:self.weekButton];
    [self.buttonArr addObject:self.monthButton];
    [self.buttonArr addObject:self.calendarButton];
}

- (IBAction)tomorrowAction:(id)sender {
    if (0 == self.selectedIndex) {
        self.selectedIndex = -1;
        self.planStartDate = @"";
        self.planEndDate = @"";
    } else {
        self.selectedIndex = 0;
        self.planStartDate = [LCDateUtil stringFromDate:[LCDateUtil nDaysBeforeDate:-1]];
        self.planEndDate = [LCDateUtil stringFromDate:[LCDateUtil nDaysBeforeDate:-2]];
    }
    
    [self updateSelectedButtonView];
}

- (IBAction)weekAction:(id)sender {
    if (1 == self.selectedIndex) {
        self.selectedIndex = -1;
        self.planStartDate = @"";
        self.planEndDate = @"";
    } else {
        self.selectedIndex = 1;
        NSDateFormatter *formatter = [LCDateUtil getUsualDateFormatterToDay];
        self.planStartDate =[formatter stringFromDate:[LCDateUtil dateOfFirstDayThisWeek]];
        self.planEndDate = [formatter stringFromDate:[LCDateUtil nDaysBeforeDate:[LCDateUtil dateOfFirstDayThisWeek] withDays:(-7)]];
    }
    
    [self updateSelectedButtonView];
}

- (IBAction)monthAction:(id)sender {
    if (2 == self.selectedIndex) {
        self.selectedIndex = -1;
        self.planStartDate = @"";
        self.planEndDate = @"";
    } else {
        self.selectedIndex = 2;
        NSDateFormatter *formatter = [LCDateUtil getUsualDateFormatterToDay];
        self.planStartDate = [formatter stringFromDate:[LCDateUtil dateOfFirstDayThisMonth]];
        self.planEndDate = [formatter stringFromDate:[LCDateUtil dateOfFirstDayNextMonth]];
    }
    
    [self updateSelectedButtonView];
}

- (IBAction)calendarAction:(id)sender {
    if (3 == self.selectedIndex) {
        self.selectedIndex = -1;
        self.planStartDate = @"";
        self.planEndDate = @"";
    } else {
        self.selectedIndex = 3;
    }
}

- (void)updateSelectedButtonView {
    for (NSInteger index = 0; index < self.buttonArr.count; ++index) {
        UIButton *btn = [self.buttonArr objectAtIndex:index];
        if (index == self.selectedIndex) {
            [btn setTitleColor:UIColorFromRGBA(0x7d7975, 1.0) forState:UIControlStateNormal];
            [btn setBackgroundColor:UIColorFromRGBA(0xf7f7f5, 1.0)];
        } else {
            [btn setTitleColor:UIColorFromRGBA(0x7d7975, 1.0) forState:UIControlStateNormal];
            [btn setBackgroundColor:UIColorFromRGBA(0xf7f7f5, 1.0)];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
