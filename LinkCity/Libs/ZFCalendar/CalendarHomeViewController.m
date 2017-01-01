//
//  CalendarHomeViewController.m
//  Calendar
//
//  Created by 张凡 on 14-6-23.
//  Copyright (c) 2014年 张凡. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "CalendarHomeViewController.h"
#import "Color.h"

@interface CalendarHomeViewController ()
{
    int daynumber;//天数
    int optiondaynumber;//选择日期数量
//    NSMutableArray *optiondayarray;//存放选择好的日期对象数组
}

@end

@implementation CalendarHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        //[self setHotelToDay:365 ToDateforString:nil];
        [self setHotelToDay:365 selectStartDateforString:nil selectEndDateforString:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = @"选择起止日期";
    
//    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] init];
//    /// 使用资源原图片.
//    UIImage *backImage = [[UIImage imageNamed:@"NavigationBackBG"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    [backButtonItem setImage:backImage];
//    [backButtonItem setTarget:self];
//    [backButtonItem setAction:@selector(backAction:)];
//    self.navigationItem.leftBarButtonItem = backButtonItem;
}

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:APP_ANIMATION];
}

- (void)confirmDateAction:(id)sender
{
    [super confirmDateAction:sender];
    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseDateFinished:)])
    {
        confirmView.hidden = YES;
        [self.delegate chooseDateFinished:self];
        
        if(self.navigationController) {
            [self.navigationController popViewControllerAnimated:YES];
        }else if (self.presentingViewController) {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 设置方法

//飞机初始化方法
- (void)setAirPlaneToDay:(int)day ToDateforString:(NSString *)todate
{
    daynumber = day;
    optiondaynumber = 1;//选择一个后返回数据对象
    super.calendarMonth = [self getMonthArrayOfDayNumber:daynumber selectStartDateforString:todate selectEndDateforString:nil];
    self.Logic.optiondaynumber = 1;
    [super.collectionView reloadData];//刷新
}

//酒店初始化方法
- (void)setHotelToDay:(int)day selectStartDateforString:(NSString *)startDate selectEndDateforString:(NSString *)endDate
{
    daynumber = day;
    NSLog(@"I come in the day is %d", daynumber);
    optiondaynumber = 2;//选择两个后返回数据对象
    super.calendarMonth = [self getMonthArrayOfDayNumber:daynumber selectStartDateforString:startDate selectEndDateforString:endDate];
    self.Logic.optiondaynumber = 2;
    [super.collectionView reloadData];//刷新
}


//火车初始化方法
- (void)setTrainToDay:(int)day ToDateforString:(NSString *)todate
{
    daynumber = day;
    optiondaynumber = 1;//选择一个后返回数据对象
    super.calendarMonth = [self getMonthArrayOfDayNumber:daynumber selectStartDateforString:todate selectEndDateforString:nil];
    self.Logic.optiondaynumber = 1;
    [super.collectionView reloadData];//刷新
    
}



#pragma mark - 逻辑代码初始化

//获取时间段内的天数数组
- (NSMutableArray *)getMonthArrayOfDayNumber:(int)day selectStartDateforString:(NSString *)startDate selectEndDateforString:(NSString *)endDate
{
    
    NSDate *date = [NSDate date];
    
    NSDate *selectStartDate = nil;
    if (startDate) {
        selectStartDate = [[NSDate date]dateFromString:startDate];
    }else{
        selectStartDate = nil;
    }
    NSDate *selectEndDate = nil;
    if (endDate) {
        selectEndDate = [[NSDate date]dateFromString:endDate];
    }else{
        selectEndDate = nil;
    }
    
    super.Logic = [[CalendarLogic alloc]init];
    super.Logic.delegate = self;
    
    //return [super.Logic reloadCalendarView:date selectDate:selectdate  needDays:day];
    return [super.Logic reloadCalendarView:date selectStartDate:selectStartDate selectEndDate:selectEndDate needDays:day];
}

- (void)startAndEndDayFinished:(CalendarLogic *)calendarLogic
{
    confirmView.hidden = NO;
    self.startDateStr = [calendarLogic.startCalendarDay toString];
    self.endDateStr = [calendarLogic.endCalendarDay toString];
}

#pragma mark - 设置标题

- (void)setCalendartitle:(NSString *)calendartitle
{

    [self.navigationItem setTitle:calendartitle];

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [super collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    
    if ([self.delegate respondsToSelector:@selector(calendarHomeVCDidSelectOneDate:)]) {
        [self.delegate calendarHomeVCDidSelectOneDate:self];
    }
}


@end
