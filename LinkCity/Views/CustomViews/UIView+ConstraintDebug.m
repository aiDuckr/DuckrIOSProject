//
//  UIView+ConstraintDebug.m
//  LinkCity
//
//  Created by roy on 11/18/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "UIView+ConstraintDebug.h"

@implementation UIView (ConstraintDebug)
- (void)printLayoutStringWithRestorationId:(UILayoutConstraintAxis)axis{
    NSArray *constraints = [self constraintsAffectingLayoutForAxis:axis];
    NSLog(@"___________________________________________");
    for (NSLayoutConstraint *c in constraints){
        NSString *cStr = [c description];
        if (c.firstItem) {
            cStr = [NSString stringWithFormat:@"%@ ~ %@",cStr,[c.firstItem restorationIdentifier]];
        }
        if (c.secondItem) {
            cStr = [NSString stringWithFormat:@"%@ ~ %@",cStr,[c.firstItem restorationIdentifier]];
        }
        NSLog(@"%@",cStr);
    }
    NSLog(@"___________________________________________");
}
@end
