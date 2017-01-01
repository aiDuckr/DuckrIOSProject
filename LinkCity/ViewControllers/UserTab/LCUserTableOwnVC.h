//
//  LCUserTableOwnVC.h
//  LinkCity
//
//  Created by godhangyu on 16/5/24.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCAutoRefreshVC.h"

typedef enum : NSUInteger {
    LCUserTableOwnVCType_FavoredUser,
    LCUserTableOwnVCType_Fans,
    LCUserTableOwnVCType_Duckr,
    LCUserTableOwnVCType_DuckrFavored,
    LCUserTableOwnVCType_DuckrFans,
} LCUserTableOwnVCType;

@interface LCUserTableOwnVC : LCAutoRefreshVC
@property (nonatomic, assign) LCUserTableOwnVCType showingType;

// for LCUserTableVCType_FavoredUser, LCUserTableVCType_Fans
@property (nonatomic, strong) LCUserModel *user;

// for LCUserTableVCType_Duckr
@property (nonatomic, strong) NSString *placeName;
@end

