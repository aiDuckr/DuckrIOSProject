//
//  LCStageTimePickerView.h
//  LinkCity
//
//  Created by Roy on 8/30/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCPartnerStageModel.h"


@protocol LCStagePickerDelegate;
@interface LCStageTimePickerView : UIView
@property (nonatomic, weak) id<LCStagePickerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *stagePickerContainerView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIView *buttonContainerView;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (nonatomic, strong) NSArray *stageArray;


+ (instancetype)createInstance;
@end



@protocol LCStagePickerDelegate <NSObject>

- (void)stagePickerDidCancel:(LCStageTimePickerView *)stagePicker;
- (void)stagePickerDidConfirm:(LCStageTimePickerView *)stagePicker;
- (void)stagePickerDidTap:(LCStageTimePickerView *)stagePicker;
@end