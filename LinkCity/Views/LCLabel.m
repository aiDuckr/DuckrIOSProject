//
//  LCLabel.m
//  LinkCity
//
//  Created by roy on 3/6/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCLabel.h"

@implementation LCLabel

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.edgeInset = UIEdgeInsetsZero;
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.edgeInset = UIEdgeInsetsZero;
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect{
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInset)];
}

- (CGSize)intrinsicContentSize{
    CGSize size = [super intrinsicContentSize];
    size.width += self.edgeInset.left + self.edgeInset.right;
    size.height += self.edgeInset.top + self.edgeInset.bottom;
    return size;
}

@end
