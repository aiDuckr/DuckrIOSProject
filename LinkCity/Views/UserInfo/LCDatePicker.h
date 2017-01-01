//
//  LCDatePicker.h
//  LinkCity
//
//  Created by roy on 11/29/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCDatePicker;
@protocol LCDatePickerDelegate <NSObject>

- (void)datePickerDidCancel:(LCDatePicker *)datePicker;
- (void)datePickerDidConfirm:(LCDatePicker *)datePicker;
- (void)datePickerDidTap:(LCDatePicker *)datePicker;
@end

@interface LCDatePicker : UIView
@property (nonatomic, weak) id<LCDatePickerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *datePickerContainerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIView *buttonContainerView;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

+ (instancetype)createInstance;
@end
