//
//  LCTimePickerView.h
//  LinkCity
//
//  Created by Roy on 12/16/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCTimePickerViewDelegate;
@interface LCTimePickerView : UIView
@property (nonatomic, weak) id<LCTimePickerViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;

+ (instancetype)createInstance;
@end

@protocol LCTimePickerViewDelegate <NSObject>

- (void)timePickerViewDidClickCancel:(LCTimePickerView *)v;
- (void)timePickerViewDidClickConfirm:(LCTimePickerView *)v;

@end
