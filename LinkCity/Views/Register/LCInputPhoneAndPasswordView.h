//
//  LCInputPhoneAndPasswordView.h
//  LinkCity
//
//  Created by roy on 2/28/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCInputPhoneAndPasswordViewDelegate;
@interface LCInputPhoneAndPasswordView : UIView<UITextFieldDelegate>
@property (nonatomic, weak) id<LCInputPhoneAndPasswordViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *phoneInputTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordInputTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;


+ (instancetype)createInstance;
@end


@protocol LCInputPhoneAndPasswordViewDelegate <NSObject>
@optional
- (void)inputPhoneAndPasswordViewDidCancel:(LCInputPhoneAndPasswordView *)inputView;
- (void)inputPhoneAndPasswordView:(LCInputPhoneAndPasswordView *)inputView didClickNextWithPhoneNum:(NSString *)phone andPassword:(NSString *)password;

@end

