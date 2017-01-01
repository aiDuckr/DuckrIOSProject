//
//  LCOrderUserView.m
//  LinkCity
//
//  Created by Roy on 12/23/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCOrderVCUserInfoView.h"

@implementation LCOrderVCUserInfoView

+ (instancetype)createInstance{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([LCOrderVCUserInfoView class]) bundle:nil];
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    LCOrderVCUserInfoView *userInfoV = nil;
    
    for (UIView *v in views){
        if ([v isKindOfClass:[LCOrderVCUserInfoView class]]) {
            userInfoV = (LCOrderVCUserInfoView *)v;
            userInfoV.translatesAutoresizingMaskIntoConstraints = NO;
        }
    }
    
    return userInfoV;
}

@end
