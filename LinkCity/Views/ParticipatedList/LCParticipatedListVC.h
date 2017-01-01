//
//  LCParticipatedListVC.h
//  LinkCity
//
//  Created by roy on 11/12/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCDataManager.h"
#import "LCViewSwitcher.h"
#import "LCPlanDetailVC.h"

@interface LCParticipatedListVC : LCBaseVC<UITableViewDataSource,UITableViewDelegate>
+ (UINavigationController *)createInstance;
@end
