//
//  LCFavorListVC.h
//  LinkCity
//
//  Created by roy on 11/20/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCPartnerPlan.h"
#import "LCReceptionPlan.h"
#import "LCDataManager.h"
#import "LCViewSwitcher.h"
#import "LCTableView.h"

@interface LCFavorListVC : LCBaseVC
@property (nonatomic,strong) NSArray *planList;

+ (UINavigationController *)createInstance;
@end
