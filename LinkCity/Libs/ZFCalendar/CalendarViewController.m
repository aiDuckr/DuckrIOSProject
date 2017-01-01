//
//  CalendarViewController.m
//  Calendar
//
//  Created by 张凡 on 14-8-21.
//  Copyright (c) 2014年 张凡. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "CalendarViewController.h"
//UI
#import "CalendarMonthCollectionViewLayout.h"
#import "CalendarMonthHeaderView.h"
#import "CalendarDayCell.h"
//MODEL
#import "CalendarDayModel.h"

#define CATDayLabelHeight 25.0f

@interface CalendarViewController ()
{

     NSTimer* timer;//定时器

}
@property (weak, nonatomic) UILabel *day1OfTheWeekLabel;
@property (weak, nonatomic) UILabel *day2OfTheWeekLabel;
@property (weak, nonatomic) UILabel *day3OfTheWeekLabel;
@property (weak, nonatomic) UILabel *day4OfTheWeekLabel;
@property (weak, nonatomic) UILabel *day5OfTheWeekLabel;
@property (weak, nonatomic) UILabel *day6OfTheWeekLabel;
@property (weak, nonatomic) UILabel *day7OfTheWeekLabel;
@end

@implementation CalendarViewController

static NSString *MonthHeader = @"MonthHeaderView";

static NSString *DayCell = @"DayCell";


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self initData];
        [self initView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    [self addDayNameHeader];
    
    CalendarMonthCollectionViewLayout *layout = [CalendarMonthCollectionViewLayout new];
    
    CGRect rect = CGRectMake(0.0f, 89.0f, self.view.bounds.size.width, self.view.bounds.size.height);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout]; //初始化网格视图大小
    
    [self.collectionView registerClass:[CalendarDayCell class] forCellWithReuseIdentifier:DayCell];//cell重用设置ID
    
    [self.collectionView registerClass:[CalendarMonthHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MonthHeader];
    
//    self.collectionView.bounces = NO;//将网格视图的下拉效果关闭
    
    self.collectionView.delegate = self;//实现网格视图的delegate
    
    self.collectionView.dataSource = self;//实现网格视图的dataSource
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.collectionView];
    
    [self addConfirmView];
}

- (void)addConfirmView
{
    NSLog(@"i add confirm view...");
    CGFloat bgHeight = 80;
    CGFloat btnHeight = 41;
    
    confirmView = [[UIView alloc] initWithFrame:CGRectMake(0.0, DEVICE_HEIGHT - bgHeight, DEVICE_WIDTH, bgHeight)];
    confirmView.backgroundColor = [[UIColor alloc] initWithRed:0.0f green:0.0f blue:0.0 alpha:0.5];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(15, (bgHeight-btnHeight)/2.0, DEVICE_WIDTH - 30, btnHeight)];
    [button setTitle:@"确 认" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(confirmDateAction:) forControlEvents:UIControlEventTouchDown];
    [[LCUIConstants sharedInstance] setButtonAsSubmitButtonEnableStyle:button];
    [confirmView addSubview:button];
    [self.view addSubview:confirmView];
    confirmView.hidden = YES;
}

- (void)confirmDateAction:(id)sender
{
    
}

- (void)addDayNameHeader
{
    CGFloat xOffset = 0.0f;
    CGFloat yOffset = 64.0f;
    
    CGFloat gap = DEVICE_WIDTH / 7;

    //一，二，三，四，五，六，日
    UILabel *dayOfTheWeekLabel = [[UILabel alloc]initWithFrame:CGRectMake(xOffset,yOffset, gap, CATDayLabelHeight)];
    [dayOfTheWeekLabel setBackgroundColor:[UIColor clearColor]];
    [dayOfTheWeekLabel setFont:[UIFont fontWithName:@"FZLanTingHeiS-R-GB" size:11.0f]];
    self.day1OfTheWeekLabel = dayOfTheWeekLabel;
    self.day1OfTheWeekLabel.textAlignment = NSTextAlignmentCenter;
    self.day1OfTheWeekLabel.textColor = UIColorFromRGBA(CALENDAR_HEADER_COLOR, 1.0);
    [self.view addSubview:self.day1OfTheWeekLabel];

    xOffset += gap;
    dayOfTheWeekLabel = [[UILabel alloc]initWithFrame:CGRectMake(xOffset,yOffset, gap, CATDayLabelHeight)];
    [dayOfTheWeekLabel setBackgroundColor:[UIColor clearColor]];
    [dayOfTheWeekLabel setFont:[UIFont fontWithName:@"FZLanTingHeiS-R-GB" size:11.0f]];
    self.day2OfTheWeekLabel = dayOfTheWeekLabel;
    self.day2OfTheWeekLabel.textAlignment=NSTextAlignmentCenter;
    self.day2OfTheWeekLabel.textColor = UIColorFromRGBA(CALENDAR_HEADER_COLOR, 1.0);
    [self.view addSubview:self.day2OfTheWeekLabel];

    xOffset += gap;
    dayOfTheWeekLabel = [[UILabel alloc]initWithFrame:CGRectMake(xOffset,yOffset, gap, CATDayLabelHeight)];
    [dayOfTheWeekLabel setBackgroundColor:[UIColor clearColor]];
    [dayOfTheWeekLabel setFont:[UIFont fontWithName:@"FZLanTingHeiS-R-GB" size:11.0f]];
    self.day3OfTheWeekLabel = dayOfTheWeekLabel;
    self.day3OfTheWeekLabel.textAlignment=NSTextAlignmentCenter;
    self.day3OfTheWeekLabel.textColor = UIColorFromRGBA(CALENDAR_HEADER_COLOR, 1.0);
    [self.view addSubview:self.day3OfTheWeekLabel];

    xOffset += gap;
    dayOfTheWeekLabel = [[UILabel alloc]initWithFrame:CGRectMake(xOffset,yOffset, gap, CATDayLabelHeight)];
    [dayOfTheWeekLabel setBackgroundColor:[UIColor clearColor]];
    [dayOfTheWeekLabel setFont:[UIFont fontWithName:@"FZLanTingHeiS-R-GB" size:11.0f]];
    self.day4OfTheWeekLabel = dayOfTheWeekLabel;
    self.day4OfTheWeekLabel.textAlignment=NSTextAlignmentCenter;
    self.day4OfTheWeekLabel.textColor = UIColorFromRGBA(CALENDAR_HEADER_COLOR, 1.0);
    [self.view addSubview:self.day4OfTheWeekLabel];

    xOffset += gap;
    dayOfTheWeekLabel = [[UILabel alloc]initWithFrame:CGRectMake(xOffset,yOffset, gap, CATDayLabelHeight)];
    [dayOfTheWeekLabel setBackgroundColor:[UIColor clearColor]];
    [dayOfTheWeekLabel setFont:[UIFont fontWithName:@"FZLanTingHeiS-R-GB" size:11.0f]];
    self.day5OfTheWeekLabel = dayOfTheWeekLabel;
    self.day5OfTheWeekLabel.textAlignment=NSTextAlignmentCenter;
    self.day5OfTheWeekLabel.textColor = UIColorFromRGBA(CALENDAR_HEADER_COLOR, 1.0);
    [self.view addSubview:self.day5OfTheWeekLabel];

    xOffset += gap;
    dayOfTheWeekLabel = [[UILabel alloc]initWithFrame:CGRectMake(xOffset,yOffset, gap, CATDayLabelHeight)];
    [dayOfTheWeekLabel setBackgroundColor:[UIColor clearColor]];
    [dayOfTheWeekLabel setFont:[UIFont fontWithName:@"FZLanTingHeiS-R-GB" size:11.0f]];
    self.day6OfTheWeekLabel = dayOfTheWeekLabel;
    self.day6OfTheWeekLabel.textAlignment=NSTextAlignmentCenter;
    self.day6OfTheWeekLabel.textColor = UIColorFromRGBA(CALENDAR_HEADER_COLOR, 1.0);
    [self.view addSubview:self.day6OfTheWeekLabel];

    xOffset += gap;
    dayOfTheWeekLabel = [[UILabel alloc]initWithFrame:CGRectMake(xOffset,yOffset, gap, CATDayLabelHeight)];
    [dayOfTheWeekLabel setBackgroundColor:[UIColor clearColor]];
    [dayOfTheWeekLabel setFont:[UIFont fontWithName:@"FZLanTingHeiS-R-GB" size:11.0f]];
    self.day7OfTheWeekLabel = dayOfTheWeekLabel;
    self.day7OfTheWeekLabel.textAlignment=NSTextAlignmentCenter;
    self.day7OfTheWeekLabel.textColor = UIColorFromRGBA(CALENDAR_HEADER_COLOR, 1.0);
    [self.view addSubview:self.day7OfTheWeekLabel];

    [self updateWithDayNames:@[@"日", @"一", @"二", @"三", @"四", @"五", @"六"]];
}


//设置 @"日", @"一", @"二", @"三", @"四", @"五", @"六"
- (void)updateWithDayNames:(NSArray *)dayNames
{
    for (int i = 0 ; i < dayNames.count; i++) {
        switch (i) {
            case 0:
                self.day1OfTheWeekLabel.text = dayNames[i];
                break;
                
            case 1:
                self.day2OfTheWeekLabel.text = dayNames[i];
                break;
                
            case 2:
                self.day3OfTheWeekLabel.text = dayNames[i];
                break;
                
            case 3:
                self.day4OfTheWeekLabel.text = dayNames[i];
                break;
                
            case 4:
                self.day5OfTheWeekLabel.text = dayNames[i];
                break;
                
            case 5:
                self.day6OfTheWeekLabel.text = dayNames[i];
                break;
                
            case 6:
                self.day7OfTheWeekLabel.text = dayNames[i];
                break;
                
            default:
                break;
        }
    }
}

-(void)initData{
    
    self.calendarMonth = [[NSMutableArray alloc]init];//每个月份的数组
    
}



#pragma mark - CollectionView代理方法

//定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.calendarMonth.count;
}


//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSMutableArray *monthArray = [self.calendarMonth objectAtIndex:section];
    
    return monthArray.count;
}


//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DayCell forIndexPath:indexPath];
    
    NSMutableArray *monthArray = [self.calendarMonth objectAtIndex:indexPath.section];
    
    CalendarDayModel *model = [monthArray objectAtIndex:indexPath.row];
    
    cell.model = model;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;

    if (kind == UICollectionElementKindSectionHeader){
        
        NSMutableArray *month_Array = [self.calendarMonth objectAtIndex:indexPath.section];
        CalendarDayModel *model = [month_Array objectAtIndex:15];

        CalendarMonthHeaderView *monthHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MonthHeader forIndexPath:indexPath];
        monthHeader.masterLabel.text = [NSString stringWithFormat:@"%lu年 %lu月",(unsigned long)model.year,(unsigned long)model.month];//@"日期";
        monthHeader.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8f];
        reusableview = monthHeader;
    }
    return reusableview;
    
}


//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL preHideState = confirmView.hidden;
    
    if (NO == confirmView.hidden)
    {
        confirmView.hidden = YES;
    }
    
    NSMutableArray *month_Array = [self.calendarMonth objectAtIndex:indexPath.section];
    CalendarDayModel *model = [month_Array objectAtIndex:indexPath.row];

    if (model.style == CellDayTypeFutur || model.style == CellDayTypeWeek ||model.style == CellDayTypeStartClick || model.style == CellDayTypeEndClick) {
       
        [self.Logic selectLogic:model];
        
        /*if (self.calendarblock) {
            
            self.calendarblock(model);//传递数组给上级
            
            timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
        }*/
        [self.collectionView reloadData];
    }else{
        confirmView.hidden = preHideState;
    }
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES;
}

- (void)setCostPlanStageArr:(NSArray *)arr {
    self.planStageArr = arr;
    NSInteger firstCostPlanIndex = -1;
    NSInteger currentIndex = 0;
    for (NSArray *monthModel in self.calendarMonth) {
        for (CalendarDayModel *model in monthModel) {
            NSString *monthStr = @"";
            if (model.month > 0 && model.month < 10) {
                monthStr = [NSString stringWithFormat:@"0%lu", (unsigned long)model.month];
            } else {
                monthStr = [NSString stringWithFormat:@"%lu", (unsigned long)model.month];
            }
            NSString *dayStr = @"";
            if (model.day > 0 && model.day < 10) {
                dayStr = [NSString stringWithFormat:@"0%lu", (unsigned long)model.day];
            } else {
                dayStr = [NSString stringWithFormat:@"%lu", (unsigned long)model.day];
            }
            NSString *dateStr = [NSString stringWithFormat:@"%lu-%@-%@", (unsigned long)model.year, monthStr, dayStr];
            for (LCPartnerStageModel *stage in self.planStageArr) {
                if ([stage.startTime isEqualToString:dateStr]) {
                    model.Chinese_calendar = [NSString stringWithFormat:@"￥%@",stage.price];
                    if (-1 == firstCostPlanIndex) {
                        firstCostPlanIndex = currentIndex;
                    }
                }
            }
        }
        currentIndex++;
    }
    NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    NSInteger index = 0;
    for (NSArray *monthModel in self.calendarMonth) {
        if (index >= firstCostPlanIndex) {
            [mutArray addObject:monthModel];
        }
        index++;
    }
    self.calendarMonth = mutArray;
}

//定时器方法
- (void)onTimer{
    
    [timer invalidate];//定时器无效
    
    timer = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
