//
//  LCRouteLabel.m
//  LinkCity
//
//  Created by roy on 2/12/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCRouteLabel.h"

@implementation LCRouteLabel

+ (instancetype)createInstance{
    UINib *nib = [UINib nibWithNibName:@"LCRouteLabel" bundle:nil];
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    for (UIView *v in views){
        if ([v isKindOfClass:[LCRouteLabel class]]) {
            return (LCRouteLabel *)v;
        }
    }
    return nil;
}

- (void)addIntoViewAndSetToSameSize:(UIView *)viewContainer{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [viewContainer addSubview:self];
    [viewContainer addConstraint:[NSLayoutConstraint constraintWithItem:viewContainer attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [viewContainer addConstraint:[NSLayoutConstraint constraintWithItem:viewContainer attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [viewContainer addConstraint:[NSLayoutConstraint constraintWithItem:viewContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [viewContainer addConstraint:[NSLayoutConstraint constraintWithItem:viewContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
}

- (void)setStartPlace:(NSString *)startPlace{
    self.startPlaceLabel.text = startPlace;
}
- (void)setDestinationStr:(NSString *)destination{
    self.destinationLabel.text = destination;
}

@end
