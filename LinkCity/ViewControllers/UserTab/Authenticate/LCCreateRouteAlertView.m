//
//  LCCreateRouteAlertView.m
//  LinkCity
//
//  Created by roy on 3/13/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCCreateRouteAlertView.h"

@implementation LCCreateRouteAlertView
+ (instancetype)createInstance{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([LCCreateRouteAlertView class]) bundle:nil];
    
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    for (UIView *v in views) {
        if ([v isKindOfClass:[LCCreateRouteAlertView class]]) {
            v.translatesAutoresizingMaskIntoConstraints = NO;
            return (LCCreateRouteAlertView *)v;
        }
    }
    
    return nil;
}

- (CGSize)intrinsicContentSize{
    return CGSizeMake(300, 175);
}


- (IBAction)cancelButtonAction:(id)sender {
    if (self.callBack) {
        self.callBack(NO);
    }
}
- (IBAction)confirmButtonAction:(id)sender {
    if (self.callBack) {
        self.callBack(YES);
    }
}


@end
