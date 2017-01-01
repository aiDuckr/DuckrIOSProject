//
//  UILabel+LineSpace.h
//  LinkCity
//
//  Created by roy on 11/14/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (LineSpace)

- (void)setText:(NSString *)text withLineSpace:(float)lineSpace;
- (void)setText:(NSString *)text withLineSpace:(float)lineSpace textAlignment:(NSTextAlignment)alignment;
@end
