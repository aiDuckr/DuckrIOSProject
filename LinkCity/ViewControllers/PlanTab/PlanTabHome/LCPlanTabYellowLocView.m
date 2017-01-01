//
//  LCPlanTabYellowLocView.m
//  LinkCity
//
//  Created by Roy on 6/18/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCPlanTabYellowLocView.h"

@implementation LCPlanTabYellowLocView

+ (instancetype)createInstance{
    UINib *nib = [UINib nibWithNibName:@"LCPlanTabSearchView" bundle:nil];
    
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    for (UIView *v in views) {
        if ([v isKindOfClass:[LCPlanTabYellowLocView class]]) {
            LCPlanTabYellowLocView *locView = (LCPlanTabYellowLocView *)v;
            return locView;
        }
    }
    
    return nil;
}

@end
