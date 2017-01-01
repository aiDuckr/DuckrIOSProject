//
//  LCAreaPickView.m
//  LinkCity
//
//  Created by Roy on 12/17/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCAreaPickView.h"

@implementation LCAreaPickView

+ (instancetype)createInstance{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([LCAreaPickView class]) bundle:nil];
    
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    for (UIView *v in views){
        if ([v isKindOfClass:[LCAreaPickView class]]) {
            v.translatesAutoresizingMaskIntoConstraints = NO;
            return (LCAreaPickView *)v;
        }
    }
    
    return nil;
}

- (CGSize)intrinsicContentSize{
    return CGSizeMake(DEVICE_WIDTH, 370);
}



@end
