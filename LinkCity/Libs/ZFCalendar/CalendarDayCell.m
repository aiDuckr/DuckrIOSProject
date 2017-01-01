//
//  CalendarDayCell.m
//  tttttt
//
//  Created by 张凡 on 14-8-20.
//  Copyright (c) 2014年 张凡. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "CalendarDayCell.h"

@implementation CalendarDayCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
//        self.layer.borderColor = [[UIColor redColor] CGColor];
//        self.layer.borderWidth = 1.0f;
    }
    return self;
}

- (void)initView{
    /*self.layer.borderWidth = 1.0f;
    self.layer.borderColor = [[UIColor redColor] CGColor];*/
    duckrDotView = [[UIView alloc]initWithFrame:CGRectMake((self.bounds.size.width - 30) / 2, (self.bounds.size.height - 30) / 2, 30, 30)];
    duckrDotView.layer.cornerRadius = duckrDotView.frame.size.height / 2;
    duckrDotView.layer.masksToBounds = YES;
    duckrDotView.backgroundColor = UIColorFromRGBA(APP_COLOR, 1.0f);
    [self addSubview:duckrDotView];
    
    //日期
    day_lab = [[UILabel alloc]initWithFrame:CGRectMake(0, (self.bounds.size.height - 15) / 2, self.bounds.size.width, 15)];
    day_lab.textAlignment = NSTextAlignmentCenter;
    day_lab.textColor = UIColorFromRGBA(0x6b450a, 1.0);
    day_lab.font = [UIFont fontWithName:@"Futura-Medium" size:14.0f];
    [self addSubview:day_lab];

    //农历
    day_title = [[UILabel alloc]initWithFrame:CGRectMake(-5, self.bounds.size.height-16, self.bounds.size.width+10, 11)];
    day_title.textColor = UIColorFromRGBA(0xfb4c4c, 1.0);
    day_title.font = [UIFont fontWithName:@"Futura-Medium" size:10.0f];
    day_title.textAlignment = NSTextAlignmentCenter;
    [self addSubview:day_title];
    
//    UIView *rightLineView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.size.width - 0.5f, 11.5f, 0.5f, self.bounds.size.height)];
//    rightLineView.backgroundColor = [UIColor redColor];
//    [self addSubview:rightLineView];
//    
//    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, self.bounds.size.height + 11.5f, self.bounds.size.width, 0.5f)];
//    bottomLineView.backgroundColor = [UIColor redColor];
//    [self addSubview:bottomLineView];
}


- (void)setModel:(CalendarDayModel *)model
{
    switch (model.style) {
        case CellDayTypeEmpty://不显示
            [self hidden_YES];
            break;
            
        case CellDayTypePast://过去的日期
            [self hidden_NO];
            
            /*if (model.holiday) {
                day_lab.text = model.holiday;
            }else{*/
                day_lab.text = [NSString stringWithFormat:@"%lu",(unsigned long)model.day];
            //}
            
            day_lab.textColor = UIColorFromRGBA(0xaba7a2, 1.0);
            day_title.text = @"";
            duckrDotView.hidden = YES;
            break;
            
        case CellDayTypeFutur://将来的日期
            [self hidden_NO];
            
            /*if (model.holiday) {
                day_lab.text = model.holiday;
                day_lab.textColor = [UIColor redColor];
            }else{*/
                day_lab.text = [NSString stringWithFormat:@"%tu",model.day];
                day_lab.textColor = UIColorFromRGBA(CALENDAR_FUTURE_CONTENT_COLOR, 1.0);
            //}
            
            day_title.text = model.Chinese_calendar;
            duckrDotView.hidden = YES;
            break;
            
        case CellDayTypeWeek://周末
            [self hidden_NO];
            
            /*if (model.holiday) {
                day_lab.text = model.holiday;
                day_lab.textColor = [UIColor redColor];
            }else{*/
                day_lab.text = [NSString stringWithFormat:@"%tu",model.day];
                day_lab.textColor = UIColorFromRGBA(CALENDAR_FUTURE_CONTENT_COLOR, 1.0);
            //}
            
            day_title.text = model.Chinese_calendar;
            duckrDotView.hidden = YES;
            break;
            
        case CellDayTypeStartClick://被点击的日期
            [self hidden_NO];
            day_lab.text = [NSString stringWithFormat:@"%tu",model.day];
            day_title.text = model.Chinese_calendar;
            if ([LCStringUtil isNotNullString:model.Chinese_calendar]) {
                day_lab.textColor = UIColorFromRGBA(BUTTON_TITLE_COLOR, 1.0);
                duckrDotView.hidden = NO;
            } else {
                day_lab.textColor = UIColorFromRGBA(BUTTON_TITLE_COLOR, 1.0);
                duckrDotView.hidden = YES;
            }
            
            break;
            
        case CellDayTypeEndClick://被点击的日期
            [self hidden_NO];
            day_lab.text = [NSString stringWithFormat:@"%tu",model.day];
            day_lab.textColor = UIColorFromRGBA(BUTTON_TITLE_COLOR, 1.0);
            day_title.text = @"";
            duckrDotView.hidden = NO;
            
            break;
            
        case CellDayTypeStartEndClick://被点击的日期，开始和结束在同一天
            [self hidden_NO];
            day_lab.text = [NSString stringWithFormat:@"%tu",model.day];
            day_lab.textColor = UIColorFromRGBA(BUTTON_TITLE_COLOR, 1.0);
            day_title.text = @"";
            duckrDotView.hidden = NO;
            
        default:
            
            break;
    }


}

- (void)hidden_YES{
    
    day_lab.hidden = YES;
    day_title.hidden = YES;
    duckrDotView.hidden = YES;
    
}

- (void)hidden_NO{
    
    day_lab.hidden = NO;
    day_title.hidden = NO;
    
}

@end
