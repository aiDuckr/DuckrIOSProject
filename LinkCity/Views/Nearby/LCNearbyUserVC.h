//
//  LCNearbyUserVC.h
//  LinkCity
//
//  Created by roy on 11/29/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCUserNearby.h"
#import "LCStoryboardManager.h"
#import "LCViewSwitcher.h"


@interface LCNearbyUserVC : LCBaseVC

//附近的人数组，成员类型是LCUserNearby
@property (nonatomic,strong) NSMutableArray *users;

//public interface
+ (UINavigationController *)createNavigationVCInstance;
+ (LCNearbyUserVC *)createRootVCInstance;
@end
