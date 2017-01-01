//
//  LCUserInfoInputVC.h
//  LinkCity
//
//  Created by roy on 11/29/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCUserInfo.h"


typedef enum : NSUInteger {
    InputTypeNick,
    InputTypeSigh,
    InputTypeRealName,
    InputTypeSchool,
    InputTypeCompany
} UserInfoInputType;

@protocol LCUserInfoInputVCDelegate;
@interface LCUserInfoInputVC : LCBaseVC
@property (nonatomic,strong) LCUserInfo *userInfo;
@property (nonatomic,assign) UserInfoInputType inputType;
@property (nonatomic,weak) id<LCUserInfoInputVCDelegate> delegate;

+ (instancetype)createInstance;
- (void)setInputType:(UserInfoInputType)inputType forUser:(LCUserInfo *)userInfo withDelegate:(id<LCUserInfoInputVCDelegate>)delegate;
@end


@protocol LCUserInfoInputVCDelegate <NSObject>
- (void)userInfoInputVC:(LCUserInfoInputVC *)inputVC didUpdateUserInfo:(LCUserInfo *)userInfo withInputType:(UserInfoInputType)inputType;
@end