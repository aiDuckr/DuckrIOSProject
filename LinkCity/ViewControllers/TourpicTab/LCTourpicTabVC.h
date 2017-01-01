//
//  LCTravelTableVC.h
//  LinkCity
//
//  Created by roy on 2/6/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCStoryboardManager.h"
#import "LCShareView.h"

typedef enum : NSUInteger {
    LCTourpicTabVCTab_Popular = 0,
    LCTourpicTabVCTab_Square = 1,
    LCTourpicTabVCTab_Focus = 2,
} LCTourpicTabVCTab;

@interface LCTourpicTabVC : LCAutoRefreshVC

@property (nonatomic, assign) LCTourpicTabVCTab showingTab;
+ (UINavigationController *)createNavInstance;
+ (instancetype)createInstance;

- (void)sendTourPic;
- (void)showTabIndex:(NSInteger)index;

@end
