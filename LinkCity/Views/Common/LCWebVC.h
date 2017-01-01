//
//  LCWebVC.h
//  LinkCity
//
//  Created by 张宗硕 on 11/24/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCBaseVC.h"

@interface LCWebVC : LCBaseVC
@property (nonatomic, retain) NSString *webUrlStr;
+ (instancetype)createVC;
+ (UINavigationController *)createNavigationVC;

- (void)loadWebPageWithString:(NSString*)urlString title:(NSString *)title;
@end
