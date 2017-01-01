//
//  AppDelegate.h
//  LinkCity
//
//  Created by 张宗硕 on 10/23/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "GCDAsyncSocket.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "LCXMPPMessageHelper.h"
#import "LCGeXinHelper.h"
#import "LCTabBarVC.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate> {
    
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) LCTabBarVC *tabBarVC;


- (void)showTabBarVC;
@end