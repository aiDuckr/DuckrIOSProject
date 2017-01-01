//
//  UIWindow+Shake.m
//  LinkCity
//
//  Created by roy on 2/5/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "UIWindow+Shake.h"

NSString *const LCWindowShakeNotification = @"LCWindowShakeNotification";
static BOOL shakeGestureEnabled = NO;

@implementation UIWindow (Shake)

- (void)setEnableShakeGesture:(BOOL)enable{
    shakeGestureEnabled = enable;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if ( [super respondsToSelector:@selector(motionEnded:withEvent:)] )
    {
        [super motionEnded:motion withEvent:event];
    }
    
    if (shakeGestureEnabled && motion == UIEventSubtypeMotionShake) {
        [[NSNotificationCenter defaultCenter] postNotificationName:LCWindowShakeNotification object:nil];
    }
}

@end
