//
//  UILabel+FitSize.h
//  LinkCity
//
//  Created by roy on 4/13/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (FitSize)
- (void)fitSize;
- (void)fitSizeWithText:(NSString *)text width:(CGFloat)width;
- (void)fitSizeWithText:(NSString *)text width:(CGFloat)width linkSpace:(CGFloat)lineSpace;
@end
