//
//  LCUserBaseInfoView.m
//  LinkCity
//
//  Created by roy on 3/2/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCUserInfoTopView.h"

@implementation LCUserInfoTopView

+ (instancetype)createInstance{
    UINib *nib = [UINib nibWithNibName:@"LCUserInfoTopView" bundle:nil];
    
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    for (UIView *v in views) {
        if ([v isKindOfClass:[LCUserInfoTopView class]]) {
            v.translatesAutoresizingMaskIntoConstraints = NO;
            LCUserInfoTopView *baseInfoView = (LCUserInfoTopView *)v;
            return baseInfoView;
        }
    }
    
    return nil;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.layer.masksToBounds = YES;
}



@end
