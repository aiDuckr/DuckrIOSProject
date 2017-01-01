//
//  ETIMonthHeaderView.m
//  CalendarIOS7
//
//  Created by Jerome Morissard on 3/3/14.
//  Copyright (c) 2014 Jerome Morissard. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "CalendarMonthHeaderView.h"
#import "Color.h"

@interface CalendarMonthHeaderView ()

@end

@implementation CalendarMonthHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)setup
{
    
    self.clipsToBounds = YES;
    
    //月份
    UILabel *masterLabel = [[UILabel alloc] initWithFrame:CGRectMake(-1.0f, 0.0f, DEVICE_WIDTH + 2.0, 25.f)];
//    masterLabel.layer.borderColor = [UIColorFromRGBA(APP_COLOR, 1.0) CGColor];
//    masterLabel.layer.borderWidth = 0.5f;
//    masterLabel.backgroundColor = [UIColor clearColor];
    masterLabel.backgroundColor = UIColorFromR_G_B_A(246, 242, 234, 1);
    [masterLabel setTextAlignment:NSTextAlignmentCenter];
    [masterLabel setFont:[UIFont fontWithName:@"FZLanTingHeiS-R-GB" size:13.0f]];
    self.masterLabel = masterLabel;
    self.masterLabel.textColor = UIColorFromRGBA(CALENDAR_HEADER_COLOR, 1.0);
    [self addSubview:self.masterLabel];
    
    
    
}




@end
