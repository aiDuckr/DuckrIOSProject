//
//  LCPlanTabSearchView.m
//  LinkCity
//
//  Created by roy on 5/31/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCPlanTabSearchView.h"

@implementation LCPlanTabSearchView

+ (instancetype)createInstance{
    UINib *nib = [UINib nibWithNibName:@"LCPlanTabSearchView" bundle:nil];
    
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    for (UIView *v in views) {
        if ([v isKindOfClass:[LCPlanTabSearchView class]]) {
            LCPlanTabSearchView *searchView = (LCPlanTabSearchView *)v;
            return searchView;
        }
    }
    
    return nil;
}

@end
