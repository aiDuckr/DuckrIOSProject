//
//  LCEditUserInfo.h
//  LinkCity
//
//  Created by roy on 3/4/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCBaseVC.h"
#import "LCUserModel.h"

@interface LCEditUserInfoVC : LCBaseVC
@property (nonatomic, retain) LCUserModel *currentUser;

+ (instancetype)createInstance;
@end
