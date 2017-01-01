//
//  LCAutoRefreshVC.m
//  LinkCity
//
//  Created by roy on 3/17/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCAutoRefreshVC.h"

@interface LCAutoRefreshVC ()

@end

@implementation LCAutoRefreshVC

- (void)commonInit{
    [super commonInit];
    
    _isNeedRefreshData = YES;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.refreshDataReason = NSStringFromSelector(@selector(viewWillAppear:));
    [self refreshDataIfNeed];
}

#pragma mark Refresh Data
- (void)addObserveToNotificationNameToRefreshData:(NSString *)notificationName{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNeedRefreshData:) name:notificationName object:nil];
}

- (void)setNeedRefreshData:(NSNotification *)notification{
    LCLogInfo(@"AutoRefreshVC receiveNotification:%@",notification.name);
    self.refreshDataReason = notification.name;
    self.isNeedRefreshData = YES;
    
    if (self.isAppearing) {
        [self refreshDataIfNeed];
    }
}

- (void)refreshDataIfNeed{
    if (self.isNeedRefreshData) {
        self.isNeedRefreshData = NO;
        [self refreshData];
    }
}
- (void)refreshData{
    
}

@end
