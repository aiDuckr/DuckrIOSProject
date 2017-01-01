//
//  UITextView+LineSpace.h
//  LinkCity
//
//  Created by roy on 11/26/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (LineSpace)
- (void)setText:(NSString *)text withLineSpace:(float)lineSpace;
- (void)setText:(NSString *)text withLineSpace:(float)lineSpace withFont:(UIFont *)font color:(UIColor *)color;
@end