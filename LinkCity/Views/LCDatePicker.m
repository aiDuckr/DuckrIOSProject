//
//  LCDatePicker.m
//  LinkCity
//
//  Created by roy on 11/29/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCDatePicker.h"
#import "LCDateUtil.h"
@interface LCDatePicker()


@end
@implementation LCDatePicker

- (void)awakeFromNib{
    RLog(@"awakeFromNib");
    double secondsPerDay = 60*60*24;
    NSDate *nowDate = [NSDate date];
    NSDate *earlyDate = [NSDate dateWithTimeInterval:(-1*secondsPerDay*365*100) sinceDate:nowDate];
    
    //self.weekLabel.hidden = self.withWeekDayLabel;
    //self.datePicker.date = [LCDateUtil dateFromString:@"1990-06-18"];
    self.datePicker.maximumDate = nowDate;
    self.datePicker.minimumDate = earlyDate;
}

+ (instancetype)createInstance{
    return [[[NSBundle mainBundle]loadNibNamed:@"LCDatePicker" owner:nil options:nil]objectAtIndex:0];
}

- (IBAction)tapAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(datePickerDidTap:)]) {
        [self.delegate datePickerDidTap:self];
//        NSInteger numberOfWeekDay = [LCDateUtil getComps:self.datePicker.date].weekday;
//        switch (numberOfWeekDay) {
//            case 1:
//                self.weekLabel.text = @"周日";
//                break;
//            case 2:
//                self.weekLabel.text = @"周一";
//                break;
//            case 3:
//                self.weekLabel.text = @"周二";
//                break;
//            case 4:
//                self.weekLabel.text = @"周三";
//                break;
//            case 5:
//                self.weekLabel.text = @"周四";
//                break;
//            case 6:
//                self.weekLabel.text = @"周五";
//                break;
//            case 7:
//                self.weekLabel.text = @"周六";
//                break;
//            default:
//                break;
//        }
    }
}
- (IBAction)cancelButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(datePickerDidCancel:)]) {
        [self.delegate datePickerDidCancel:self];
    }
}
- (IBAction)confirmButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(datePickerDidConfirm:)]) {
        [self.delegate datePickerDidConfirm:self];
    }
}

//- (void)setWithWeekDayLabel:(BOOL)withWeekDayLabel {
//    _withWeekDayLabel = withWeekDayLabel;
//    self.weekLabel.hidden = (!withWeekDayLabel);
//}
@end
