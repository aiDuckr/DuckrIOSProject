//
//  LCUserTableVC.h
//  LinkCity
//
//  Created by roy on 3/27/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCAutoRefreshVC.h"

typedef enum : NSUInteger {
    LCUserTableVCType_FavoredUser,
    LCUserTableVCType_Fans,
    LCUserTableVCType_Duckr,
} LCUserTableVCType;

@interface LCUserTableVC : LCAutoRefreshVC
@property (nonatomic, assign) LCUserTableVCType showingType;

// for LCUserTableVCType_FavoredUser, LCUserTableVCType_Fans
@property (nonatomic, strong) LCUserModel *user;

// for LCUserTableVCType_Duckr
@property (nonatomic, strong) NSString *placeName;
@end
