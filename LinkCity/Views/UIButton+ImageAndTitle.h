//
//  UIButton+ImageAndTitle.h
//  LinkCity
//
//  Created by roy on 11/14/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ImageAndTitle)

///设置按钮中的imageview, title, 及左右边框之间距离相等
- (void)updateLayoutToEqualMargin;
///设置按钮中的imageview, title之间的距离，并左右居中
- (void)updateLayoutToCenterMargin:(float)centerMargin;

///设置按钮中图片、文字竖起排列
- (void)updateLayoutToVerticalAlineWithVerticalSpace:(float)verticalCenterMargin;
@end
