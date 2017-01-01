//
//  UIScrollView+Page.m
//  LinkCity
//
//  Created by Roy on 12/10/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "UIScrollView+Page.h"

@implementation UIScrollView (Page)
- (NSInteger)getCurrentPage{
    CGFloat width = self.frame.size.width;
    return (self.contentOffset.x + (0.5f * width)) / width;
}

- (void)scrollToPageIndex:(NSInteger)index withAnimation:(BOOL)animation{
    CGFloat contentOffset = self.frame.size.width * index;
    contentOffset = MIN(contentOffset, self.contentSize.width - self.frame.size.width);
    [self scrollRectToVisible:CGRectMake(contentOffset, 0, self.frame.size.width, self.frame.size.height) animated:animation];
}
@end
