//
//  LCAutoRefreshVC.h
//  LinkCity
//
//  Created by roy on 3/17/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCBaseVC.h"

@interface LCAutoRefreshVC : LCBaseVC
@property (nonatomic,assign) BOOL isNeedRefreshData;    //是否需要重新更新网络数据
@property (nonatomic,strong) NSString *refreshDataReason;   //是什么导致的刷新数据

- (void)addObserveToNotificationNameToRefreshData:(NSString *)notificationName;
- (void)refreshData;
@end
