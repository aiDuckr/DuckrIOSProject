//
//  LCUserServiceVC.h
//  LinkCity
//
//  Created by roy on 3/7/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCAutoRefreshVC.h"

typedef enum : NSUInteger {
    LCUserServiceType_Normal = 0,
    LCUserServiceType_Bill = 1,
} LCUserServiceVCType;

@interface LCUserServiceVC : LCAutoRefreshVC
@property (assign, nonatomic) LCUserServiceVCType type;
+ (instancetype)createInstance;
@end
