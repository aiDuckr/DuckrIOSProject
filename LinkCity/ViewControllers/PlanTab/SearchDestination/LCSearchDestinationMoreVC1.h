//
//  LCSearchDestinationMoreVC.h
//  LinkCity
//
//  Created by David Chen on 2016/8/17.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCSearchBar.h"
#import "LCDataManager.h"
#import "LCDestinationCollectionCell.h"
#import "LCSearchDestinationRecmdCell.h"
#import "LCStoryboardManager.h"
#import "LCAutoRefreshVC.h"

@interface LCSearchDestinationMoreVC1 : LCAutoRefreshVC
@property (nonatomic, assign) BOOL isCost;//yes代表是付费活动，no代表是免费邀约。

@property (retain, nonatomic) NSString *searchText;
+ (instancetype)createInstance;
@end
