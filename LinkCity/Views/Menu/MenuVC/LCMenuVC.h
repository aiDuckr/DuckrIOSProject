//
//  LCMenuVC.h
//  LinkCity
//
//  Created by roy on 10/25/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCSlideVC.h"

typedef enum : NSUInteger {
    MenuActiveHomePage,
    MenuActiveMyPlanPage,
    MenuActiveMyChatPage,
    MenuActiveMyFavorPage,
    MenuActiveNearbyPage,
    MenuActiveNone,
} MenuActiveType;

@protocol LCMenuVCDelegate;
@interface LCMenuVC : LCBaseVC

@property (nonatomic,weak) LCSlideVC *slideVC;
- (void)updateMenuActiveType:(MenuActiveType)activeType;
- (void)tipUnreadInfo:(BOOL)haveUnreadInfo;
- (void)tipUnreadChat:(NSInteger)unreadChatNumber;
@end