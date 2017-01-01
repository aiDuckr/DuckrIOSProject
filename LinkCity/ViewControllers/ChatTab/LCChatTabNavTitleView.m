//
//  LCChatTabNavTitleView.m
//  LinkCity
//
//  Created by roy on 5/13/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCChatTabNavTitleView.h"

@implementation LCChatTabNavTitleView

+ (instancetype)createInstance{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([LCChatTabNavTitleView class]) bundle:nil];
    
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    for (UIView *v in views) {
        if ([v isKindOfClass:[LCChatTabNavTitleView class]]) {
            //            v.translatesAutoresizingMaskIntoConstraints = NO;
            return (LCChatTabNavTitleView *)v;
        }
    }
    
    return nil;
}

- (void)showAsNormal {
    self.indicator.hidden = YES;
    [self.indicator stopAnimating];
    self.receivingTitleLabel.hidden = YES;
    self.normalTitleLabel.hidden = NO;
}

- (void)showAsReceiving {
    self.indicator.hidden = NO;
    [self.indicator startAnimating];
    self.receivingTitleLabel.hidden = NO;
    self.normalTitleLabel.hidden = YES;
}

- (void)showAsReceivingAndAutoStop {
    [self showAsReceiving];
    [self performSelector:@selector(showAsNormal) withObject:nil afterDelay:3];
}

@end
