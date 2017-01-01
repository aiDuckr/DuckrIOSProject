//
//  LCInputUserinfoView.h
//  LinkCity
//
//  Created by roy on 2/28/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCInputUserinfoViewDelegate;
@interface LCInputUserinfoView : UIView

//Data
@property (nonatomic, weak) id<LCInputUserinfoViewDelegate> delegate;

//UI
@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
@property (weak, nonatomic) IBOutlet UIButton *maleButton;
@property (weak, nonatomic) IBOutlet UIButton *femaleButton;
@property (weak, nonatomic) IBOutlet UITextField *nickTextField;
@property (weak, nonatomic) IBOutlet UIButton *livingPlaceButton;
@property (weak, nonatomic) IBOutlet UITextField *livingPlaceTextField;



+ (instancetype)createInstance;
@end


@protocol LCInputUserinfoViewDelegate <NSObject>
@optional
- (void)inputUserinfoViewDidClickCancel:(LCInputUserinfoView *)inputUserinfoView;
- (void)inputUserinfoViewDidClickLivingPlaceButton:(LCInputUserinfoView *)inputUserinfoView;
- (void)inputUserinfoViewDidClickPass:(LCInputUserinfoView *)inputUserinfoView;
- (void)inputUserinfoView:(LCInputUserinfoView *)inputUserinfoView didUpdateUserinfo:(LCUserModel *)user;//上传头像、性别、生日

@end