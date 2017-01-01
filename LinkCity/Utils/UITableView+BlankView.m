//
//  UITableView+BlankView.m
//  LinkCity
//
//  Created by Roy on 6/20/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "UITableView+BlankView.h"

@implementation UITableView (BlankView)

- (LCBlankContentView *)curBlankView{
    return (LCBlankContentView *)objc_getAssociatedObject(self, @"curBlankView");
}
- (void)setCurBlankView:(LCBlankContentView *)blankView{
    objc_setAssociatedObject(self, @"curBlankView", blankView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showBlankViewWithImageName:(NSString *)imageName title:(NSString *)title marginTop:(CGFloat)marginTop{
    [self hideBlankView];
    
    if (self.superview) {
        LCBlankContentView *blankView = [[LCBlankContentView alloc] initWithFrame:CGRectZero imageName:imageName title:title marginTop:marginTop];
        blankView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.superview insertSubview:blankView belowSubview:self];
        [self setCurBlankView:blankView];
        
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:blankView
                                                                   attribute:NSLayoutAttributeTop
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeTop
                                                                  multiplier:1
                                                                    constant:0]];
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:blankView
                                                                   attribute:NSLayoutAttributeBottom
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeBottom
                                                                  multiplier:1
                                                                    constant:0]];
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:blankView
                                                                   attribute:NSLayoutAttributeLeft
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeLeft
                                                                  multiplier:1
                                                                    constant:0]];
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:blankView
                                                                   attribute:NSLayoutAttributeRight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeRight
                                                                  multiplier:1
                                                                    constant:0]];
    }
    
}

- (void)hideBlankView{
    LCBlankContentView *blankView = [self curBlankView];
    if (blankView) {
        [blankView removeFromSuperview];
    }
    [self setCurBlankView:nil];
}


@end
