//
//  LCAddFriendVC.h
//  LinkCity
//
//  Created by roy on 3/16/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCBaseVC.h"
#import "LCSearchBar.h"

typedef enum : NSUInteger {
    LCAddFriendVCTab_AddressBookUser,
    LCAddFriendVCTab_RecommendUser,
} LCAddFriendVCTab;

@interface LCAddFriendVC : LCAutoRefreshVC {
    LCSearchBar *mySearchBar;
}

@property (nonatomic, assign) LCAddFriendVCTab showingTab;

@end

