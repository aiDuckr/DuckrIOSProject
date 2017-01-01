//
//  UITableView+BlankView.h
//  LinkCity
//
//  Created by Roy on 6/20/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCBlankContentView.h"

@interface UITableView (BlankView)

- (void)showBlankViewWithImageName:(NSString *)imageName title:(NSString *)title marginTop:(CGFloat)marginTop;
- (void)hideBlankView;
@end
