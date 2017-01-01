//
//  LCDestinationInputter.m
//  LinkCity
//
//  Created by roy on 2/9/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCDialogInputter.h"
#import "LCOneTextInputter.h"
#import "KLCPopup.h"

@interface LCDialogInputter()<LCOneTextInputterDelegate>
@property (nonatomic, strong) KLCPopup *popUp;
@property (nonatomic, strong) LCOneTextInputter *oneTextInputter;
@property (nonatomic, strong) void(^comp)(NSString *destionation);
@end
@implementation LCDialogInputter

#pragma mark - Public Interface
+ (instancetype)sharedInstance{
    static LCDialogInputter *inputter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        inputter = [[LCDialogInputter alloc] init];
    });
    return inputter;
}

- (void)showInputterWithDefaultText:(NSString *)text
                        placeHolder:(NSString *)placeHolder
                              title:(NSString *)title
                         completion:(void(^)(NSString *destination))comp{
    
    
    self.comp = comp;
    if ([LCStringUtil isNotNullString:text]) {
        self.oneTextInputter.inputTextField.text = text;
    }else{
        self.oneTextInputter.inputTextField.text = @"";
    }
    if ([LCStringUtil isNotNullString:placeHolder]) {
        self.oneTextInputter.inputTextField.placeholder = placeHolder;
    }else{
        self.oneTextInputter.inputTextField.placeholder = nil;
    }
    if ([LCStringUtil isNotNullString:title]) {
        self.oneTextInputter.titleLabel.text = title;
    }else{
        self.oneTextInputter.titleLabel.text = @"";
    }
    
    [self.oneTextInputter.inputTextField becomeFirstResponder];
    
    KLCPopupLayout layout = KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter,
                                               KLCPopupVerticalLayoutAboveCenter);
    
    self.popUp = [KLCPopup popupWithContentView:self.oneTextInputter
                                               showType:KLCPopupShowTypeBounceInFromTop
                                            dismissType:KLCPopupDismissTypeBounceOutToBottom
                                               maskType:KLCPopupMaskTypeDimmed
                               dismissOnBackgroundTouch:NO
                                  dismissOnContentTouch:NO];
    
    [self.popUp showWithLayout:layout];
}

- (id)init{
    self = [super init];
    if (self) {
        self.oneTextInputter = [LCOneTextInputter createInstance];
        self.oneTextInputter.delegate = self;
        self.oneTextInputter.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

#pragma mark - LCOneTextInputterDelegate
- (void)oneTextInputter:(LCOneTextInputter *)inputter didSubmitWithInput:(NSString *)inputString{
    if (self.comp) {
        self.comp(inputString);
        self.comp = nil;
    }
    
    if (self.popUp) {
        [self.popUp dismissPresentingPopup];
    }
}
- (void)oneTextInputter:(LCOneTextInputter *)inputter didCancelWithInput:(NSString *)inputString{
    if (self.comp) {
        self.comp = nil;
    }
    
    if (self.popUp) {
        [self.popUp dismissPresentingPopup];
    }
}

@end
