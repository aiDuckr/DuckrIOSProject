//
//  LCStageTimePickerView.m
//  LinkCity
//
//  Created by Roy on 8/30/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCStageTimePickerView.h"


@interface LCStageTimePickerView()<UIPickerViewDataSource, UIPickerViewDelegate>

@end
@implementation LCStageTimePickerView

- (void)awakeFromNib{
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
}

+ (instancetype)createInstance{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([LCStageTimePickerView class]) owner:nil options:nil]objectAtIndex:0];
}

- (IBAction)tapAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(stagePickerDidTap:)]) {
        [self.delegate stagePickerDidTap:self];
    }
}
- (IBAction)cancelButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(stagePickerDidCancel:)]) {
        [self.delegate stagePickerDidCancel:self];
    }
}
- (IBAction)confirmButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(stagePickerDidConfirm:)]) {
        [self.delegate stagePickerDidConfirm:self];
    }
}

#pragma mark PickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.stageArray.count;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return DEVICE_WIDTH / 4 * 3;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    LCPartnerStageModel *stage = [self.stageArray objectAtIndex:row];
    
    NSDate *startDate = [LCDateUtil dateFromString:stage.startTime];
    static NSDateFormatter *monthAndDayFormatter = nil;
    if (!monthAndDayFormatter) {
        monthAndDayFormatter = [[NSDateFormatter alloc] init];
        monthAndDayFormatter.dateFormat = @"MM.dd出发";
    }
    NSString *startDateStr = [monthAndDayFormatter stringFromDate:startDate];
    
    return [NSString stringWithFormat:@"%@  ￥%@", startDateStr, stage.price];
}




@end




