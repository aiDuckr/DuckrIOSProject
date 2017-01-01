//
//  LCResetPasswordView.h
//  LinkCity
//
//  Created by roy on 3/1/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCResetPasswordViewDelegate;
@interface LCResetPasswordView : UIView
//Data
@property (nonatomic, weak) id<LCResetPasswordViewDelegate> delegate;

//UI
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmTextField;


+ (instancetype)createInstance;
@end


@protocol LCResetPasswordViewDelegate <NSObject>
@optional
- (void)resetPasswordViewDidCancel:(LCResetPasswordView *)resetPasswordView;
- (void)resetPasswordViewDidSubmit:(LCResetPasswordView *)resetPasswordView withPassword:(NSString *)password;

@end
