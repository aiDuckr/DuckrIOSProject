//
//  LCSendPlanFillUserInfoView.h
//  LinkCity
//
//  Created by Roy on 6/19/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCUserModel.h"

@protocol LCSendPlanFillUserInfoViewDelegate;
@interface LCSendPlanFillUserInfoView : UIView

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIButton *maleBtn;
@property (weak, nonatomic) IBOutlet UIButton *femaleBtn;
@property (weak, nonatomic) IBOutlet UITextField *birthdayTextField;
@property (weak, nonatomic) IBOutlet UITextField *livingPlaceTextField;


@property (nonatomic, weak) id<LCSendPlanFillUserInfoViewDelegate> delegate;
@property (nonatomic, strong) LCUserModel *editingUser;

+ (instancetype)createInstance;
@end



@protocol LCSendPlanFillUserInfoViewDelegate <NSObject>

- (void)sendPlanFillUserInfoViewPickBirthday:(LCSendPlanFillUserInfoView *)view;
- (void)sendPlanFillUserInfoViewPickLivingPlace:(LCSendPlanFillUserInfoView *)view;
- (void)sendPlanFillUserInfoView:(LCSendPlanFillUserInfoView *)view finishSucceed:(BOOL)succeed;
@end