//
//  LCRouteTitleView.m
//  LinkCity
//
//  Created by Roy on 12/25/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCRouteTitleView.h"

@implementation LCRouteTitleView

+ (instancetype)createInstance{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([LCRouteTitleView class]) bundle:nil];
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    for (UIView *v in views){
        if ([v isKindOfClass:[LCRouteTitleView class]]) {
            return (LCRouteTitleView *)v;
        }
    }
    
    return nil;
}

+ (CGFloat)getCellHeight{
    return 40;
}

@end
