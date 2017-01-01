//
//  UIWindow+Shake.h
//  LinkCity
//
//  Created by roy on 2/5/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const LCWindowShakeNotification;

@interface UIWindow (Shake)

- (void)setEnableShakeGesture:(BOOL)enable;

@end
