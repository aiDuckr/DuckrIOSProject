//
//  LCRegisterSucceedView.m
//  LinkCity
//
//  Created by roy on 2/28/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCRegisterSucceedView.h"

@interface LCRegisterSucceedView()
@property (nonatomic,strong) void(^callBack)(LCRegisterSucceedView *succeedView);
@end


@implementation LCRegisterSucceedView

+ (instancetype)createInstanceWithCallBack:(void(^)(LCRegisterSucceedView *succeedView))callBack{
    UINib *nib = [UINib nibWithNibName:@"LCRegisterAndLoginViews" bundle:nil];
    
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    for (UIView *v in views) {
        if ([v isKindOfClass:[LCRegisterSucceedView class]]) {
            v.translatesAutoresizingMaskIntoConstraints = NO;
            LCRegisterSucceedView *succeedView = (LCRegisterSucceedView *)v;
            succeedView.callBack = callBack;
            
            return succeedView;
        }
    }
    
    return nil;
}

- (CGSize)intrinsicContentSize{
    return CGSizeMake(320, 250);
}

- (IBAction)cinfirmButtonAction:(id)sender {
    if (self.callBack) {
        self.callBack(self);
    }
}


@end
