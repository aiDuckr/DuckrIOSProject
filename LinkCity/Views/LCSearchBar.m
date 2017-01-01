//
//  YSSearchBar.m
//  LinkCity
//
//  Created by zzs on 14-8-8.
//  Copyright (c) 2014年 yunshuo. All rights reserved.
//

#import "LCSearchBar.h"
#import "UIImage+Create.h"

@implementation LCSearchBar

- (void)setup {
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [subview removeFromSuperview];
            break;
        }
        for (UIView *subsubview in subview.subviews) {
            if ([subsubview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                [subsubview removeFromSuperview];
                break;
            }
        }
    }
    
    self.translucent = YES;
    
    self.tintColor = UIColorFromRGBA(0x2c2a28, 1.0f);
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setSearchTextFieldBackgroundColor:(UIColor *)backgroundColor {
    UIView *searchTextField = nil;
    [self setBackgroundColor:[UIColor whiteColor]];
    self.barTintColor = [UIColor whiteColor];
    searchTextField = [[[self.subviews firstObject] subviews] lastObject];
    searchTextField.backgroundColor = backgroundColor;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
