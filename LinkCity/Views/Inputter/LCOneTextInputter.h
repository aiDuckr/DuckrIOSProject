//
//  LCOneTextInputter.h
//  LinkCity
//
//  Created by roy on 2/9/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCOneTextInputter;
@protocol LCOneTextInputterDelegate <NSObject>

- (void)oneTextInputter:(LCOneTextInputter *)inputter didSubmitWithInput:(NSString *)inputString;
- (void)oneTextInputter:(LCOneTextInputter *)inputter didCancelWithInput:(NSString *)inputString;

@end

@interface LCOneTextInputter : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;


@property (nonatomic, weak) id<LCOneTextInputterDelegate> delegate;

+ (instancetype)createInstance;
@end
