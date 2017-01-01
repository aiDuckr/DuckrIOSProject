//
//  LCInputPhoneView.h
//  LinkCity
//
//  Created by roy on 3/1/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCInputPhoneViewDelegate;
@interface LCInputPhoneView : UIView
//Data
@property (nonatomic, weak) id<LCInputPhoneViewDelegate> delegate;

//UI
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;


+ (instancetype)createInstance;
@end


@protocol LCInputPhoneViewDelegate <NSObject>
@optional
- (void)inputPhoneViewDidCancel:(LCInputPhoneView *)phoneView;
- (void)inputPhoneViewDidClickNext:(LCInputPhoneView *)phoneView withPhone:(NSString *)phone;

@end