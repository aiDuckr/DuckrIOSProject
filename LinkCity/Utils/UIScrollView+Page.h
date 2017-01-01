//
//  UIScrollView+Page.h
//  LinkCity
//
//  Created by Roy on 12/10/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Page)
- (NSInteger)getCurrentPage;
- (void)scrollToPageIndex:(NSInteger)index withAnimation:(BOOL)animation;
@end
