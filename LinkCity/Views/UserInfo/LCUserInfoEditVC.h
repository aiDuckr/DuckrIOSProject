//
//  LCUserInfoEditVC.h
//  LinkCity
//
//  Created by roy on 11/28/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCStoryboardManager.h"
#import "EGOImageView.h"
#import "LCUserInfo.h"

@interface LCUserInfoEditVC : LCBaseVC
@property (nonatomic, strong) LCUserInfo *userInfo;

+ (UINavigationController *)createNavigationVCInstance;
+ (LCUserInfoEditVC *)createVCInstance;
@end
