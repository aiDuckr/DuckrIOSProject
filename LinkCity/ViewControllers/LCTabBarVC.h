//
//  LCTabBarVC.h
//  LinkCity
//
//  Created by roy on 3/20/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCChatTabVC.h"
#import "LCUserTabVC.h"
#import "LCTourpicTabVC.h"
#import "LCPlanTabVC.h"
#import "LCLocalTabVC.h"

@interface LCTabBarVC : UITabBarController
@property (nonatomic, strong) UINavigationController *planTabNavVC;
@property (nonatomic, strong) UINavigationController *tourpicTabVC;
@property (nonatomic, strong) UINavigationController *localTabVC;
@property (nonatomic, strong) UINavigationController *chatTabVC;
@property (nonatomic, strong) UINavigationController *userTabVC;

+ (LCTabBarVC *)createInstance;
//- (void)bringPlusViewFront;
@end
