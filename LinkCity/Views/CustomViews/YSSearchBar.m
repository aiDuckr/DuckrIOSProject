//
//  YSSearchBar.m
//  LinkCity
//
//  Created by zzs on 14-8-8.
//  Copyright (c) 2014年 yunshuo. All rights reserved.
//

#import "YSSearchBar.h"

@implementation YSSearchBar

- (void)setup
{
    [[[[self.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
    
    [self setBackgroundColor:[UIColor clearColor]];
    
    for (UIView *subView in self.subviews)
    {
        for (UIView *secondLevelSubview in subView.subviews){
            if ([secondLevelSubview isKindOfClass:[UITextField class]])
            {
                //UITextField *searchBarTextField = (UITextField *)secondLevelSubview;
                
                //searchBarTextField.backgroundColor = [UIColor redColor];
            }
        }
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
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
