//
//  LCRoutePlaceDayHeaderView.m
//  LinkCity
//
//  Created by roy on 3/8/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCRoutePlaceDayHeaderView.h"

@implementation LCRoutePlaceDayHeaderView

+ (instancetype)createInstance{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([LCRoutePlaceDayHeaderView class]) bundle:nil];
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    for (UIView *v in views){
        if ([v isKindOfClass:[LCRoutePlaceDayHeaderView class]]) {
            return (LCRoutePlaceDayHeaderView *)v;
        }
    }
    
    return nil;
}

+ (CGFloat)getCellHeight{
    return 40;
}

@end
