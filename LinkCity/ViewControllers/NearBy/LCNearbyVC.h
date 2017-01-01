//
//  LCNearByVC.h
//  LinkCity
//
//  Created by roy on 3/8/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCBaseVC.h"


typedef enum : NSUInteger {
    LCNearbyTab_Tourist,
    LCNearbyTab_ChatRoom,
    LCNearbyTab_Plan,
    LCNearbyTab_Native,
} LCNearbyTab;
@interface LCNearbyVC : LCAutoRefreshVC
@property (nonatomic, assign) LCNearbyTab showingNearbyTab;

+ (instancetype)createInstance;
@end
