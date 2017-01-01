//
//  LCDatePicker.m
//  LinkCity
//
//  Created by roy on 11/29/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCDatePicker.h"

@interface LCDatePicker()

@end
@implementation LCDatePicker

- (void)awakeFromNib{
    RLog(@"awakeFromNib");
    double secondsPerDay = 60*60*24;
    NSDate *nowDate = [NSDate date];
    NSDate *earlyDate = [NSDate dateWithTimeInterval:(-1*secondsPerDay*365*100) sinceDate:nowDate];
    
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

@end
