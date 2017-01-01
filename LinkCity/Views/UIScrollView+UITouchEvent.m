//
//  UIScrollView+UITouchEvent.m
//  LinkCity
//
//  Created by 张宗硕 on 12/5/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "UIScrollView+UITouchEvent.h"

@implementation UIScrollView (UITouchEvent)

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

/* roy.2015.1.7   
 this will cause app crash, when use handwrite keyboard to input username during registering
 */
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [[self nextResponder] touchesBegan:touches withEvent:event];
//    [super touchesBegan:touches withEvent:event];
//}
//-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    [[self nextResponder] touchesMoved:touches withEvent:event];
//    [super touchesMoved:touches withEvent:event];
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    [[self nextResponder] touchesEnded:touches withEvent:event];
//    [super touchesEnded:touches withEvent:event];
//}

@end
