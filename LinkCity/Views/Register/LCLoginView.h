//
//  LCLoginView.h
//  LinkCity
//
//  Created by roy on 3/1/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCLoginViewDelegate;
@interface LCLoginView : UIView
//Data
@property (nonatomic, weak) id<LCLoginViewDelegate> delegate;

//UI
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;



+ (instancetype)createInstance;
@end


@protocol LCLoginViewDelegate <NSObject>
@optional
- (void)loginViewDidCancel:(LCLoginView *)loginView;
- (void)loginViewDidClickForgetPassword:(LCLoginView *)loginView;
- (void)loginViewDidClickLogin:(LCLoginView *)loginView withPhone:(NSString *)phone password:(NSString *)password;

@end