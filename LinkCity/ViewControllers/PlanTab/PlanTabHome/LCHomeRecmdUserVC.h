//
//  LCHomeRecmdUserVC.h
//  LinkCity
//
//  Created by Roy on 6/19/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCAutoRefreshVC.h"

typedef enum : NSUInteger {
    LCHomeRecmdUserVCTab_Recmd,
    LCHomeRecmdUserVCTab_Nearby,
} LCHomeRecmdUserVCTab;

@interface LCHomeRecmdUserVC : LCAutoRefreshVC
@property (nonatomic, assign) LCHomeRecmdUserVCTab showingTab;

@end
