//
//  LCLocalTabVC.h
//  LinkCity
//
//  Created by 张宗硕 on 7/27/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCAutoRefreshVC.h"
typedef enum : NSUInteger {
    LCLocalTabVCTab_Trade = 0,
    LCLocalTabVCTab_Invite = 1,
} LCLocalTabVCTab;

@interface LCLocalTabVC : LCAutoRefreshVC
+ (UINavigationController *)createNavInstance;
+ (instancetype)createInstance;

@end
