//
//  LCStoryboardManager.h
//  LinkCity
//
//  Created by roy on 11/10/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCStoryboardManager : NSObject

+ (UIViewController *)viewControllerWithFileName:(NSString *)storyboardFileName identifier:(NSString *)identifier;

@end
