//
//  LCUserIdentityAlertView.m
//  LinkCity
//
//  Created by roy on 3/12/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCUserIdentityAlertView.h"

@implementation LCUserIdentityAlertView

+ (instancetype)createInstance{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([LCUserIdentityAlertView class]) bundle:nil];
    
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    for (UIView *v in views) {
        if ([v isKindOfClass:[LCUserIdentityAlertView class]]) {
            v.translatesAutoresizingMaskIntoConstraints = NO;
            return (LCUserIdentityAlertView *)v;
        }
    }
    
    return nil;
}

- (CGSize)intrinsicContentSize{
    return CGSizeMake(300, 290);
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
