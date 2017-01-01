//
//  LCStoryboardManager.m
//  LinkCity
//
//  Created by roy on 11/10/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCStoryboardManager.h"

@implementation LCStoryboardManager

+ (UIViewController *)viewControllerWithFileName:(NSString *)storyboardFileName identifier:(NSString *)identifier{
    UIStoryboard *storyboard = [LCStoryboardManager storyboardWithFileName:storyboardFileName];
    if (storyboard) {
        return [storyboard instantiateViewControllerWithIdentifier:identifier];
    }
    return nil;
}

+ (UIStoryboard *)storyboardWithFileName:(NSString *)fileName{
    if (fileName) {
        return [UIStoryboard storyboardWithName:fileName bundle:nil];
    }
    return nil;
}

@end
