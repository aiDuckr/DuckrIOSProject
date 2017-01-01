//
//  LCTimePickerView.m
//  LinkCity
//
//  Created by Roy on 12/16/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCTimePickerView.h"

@implementation LCTimePickerView

+ (instancetype)createInstance{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([LCTimePickerView class]) bundle:nil];
    
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    for (UIView *v in views){
        if ([v isKindOfClass:[LCTimePickerView class]]) {
            v.translatesAutoresizingMaskIntoConstraints = NO;
            return (LCTimePickerView *)v;
        }
    }
    
    return nil;
}

- (void)awakeFromNib{
    [self.timePicker setDatePickerMode:UIDatePickerModeTime];
    
    
}

- (CGSize)intrinsicContentSize{
    return CGSizeMake(DEVICE_WIDTH, 250);
}

- (IBAction)confirmBtnAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(timePickerViewDidClickConfirm:)]) {
        [self.delegate timePickerViewDidClickConfirm:self];
    }
}

- (IBAction)cancelBtnAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(timePickerViewDidClickCancel:)]) {
        [self.delegate timePickerViewDidClickCancel:self];
    }
}



@end
