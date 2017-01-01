//
//  LCLocationPlanTabCalendarVC.m
//  LinkCity
//
//  Created by godhangyu on 16/5/16.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCLocationPlanTabCalendarVC.h"
#import "LCLocationPlanTabCalendarCell.h"
#import "FSCalendar.h"

@interface LCLocationPlanTabCalendarVC ()<UITableViewDataSource, UITableViewDelegate, FSCalendarDataSource, FSCalendarDelegate>

// UI
@property (weak, nonatomic) IBOutlet FSCalendar *calendar;
@property (weak, nonatomic) IBOutlet UIButton *previousButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *tableHeaderContainer;
@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarHeightConstraint;

// Data
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *orderStr;
@property (nonatomic, strong) NSMutableArray *planInfoArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerViewHeight;


@end


@implementation LCLocationPlanTabCalendarVC

#pragma mark - Public Interface
+ (instancetype)createInstance {
    return (LCLocationPlanTabCalendarVC *)[LCStoryboardManager viewControllerWithFileName:SBNameLocationPlanTab identifier:VCIDLocationPlanTabCalendarVC];
}

#pragma mark - Life Cycle

- (void)commonInit {
    [super commonInit];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNavBar];
    [self loadCalendarView];
    [self loadTableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)setupNavBar {
    self.title = @"活动日历";
}


#pragma mark - Calendar

- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated {
    _calendarHeightConstraint.constant = CGRectGetHeight(bounds);
    [self.view layoutIfNeeded];
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date {
    LCLogInfo(@"did select date %@", [calendar stringFromDate:date format:@"yyyy/MM/dd"]);
    // TODO:yhy
    if ([self isDatesSameDay:date another:_date]) {
        return;
    }
    _date = date;
    [_tableView headerBeginRefreshing];
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar {
    LCLogInfo(@"%s %@", __FUNCTION__, [calendar stringFromDate:calendar.currentPage]);
}

- (IBAction)previousClicked:(id)sender {
    LCLogInfo(@"previous button clicked!");
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *previousMonth = [self.calendar dateBySubstractingMonths:1 fromDate:currentMonth];
    [self.calendar setCurrentPage:previousMonth animated:YES];
}

- (IBAction)nextClicked:(id)sender {
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *nextMonth = [self.calendar dateByAddingMonths:1 toDate:currentMonth];
    [self.calendar setCurrentPage:nextMonth animated:YES];
    
}

- (void)loadCalendarView {
    [_calendar selectDate:[NSDate date]];
    _calendar.dataSource = self;
    _calendar.delegate = self;
    _calendar.appearance.headerMinimumDissolvedAlpha = 0;
    _calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase;
    
    
    //[_previousButton setImage:[UIImage imageNamed:@"PlanTabCalendarPreviousIcon"] forState:UIControlStateNormal];
    [_previousButton setTitle:nil forState:UIControlStateNormal];
    [_calendar bringSubviewToFront:_previousButton];
    
    
    //[_nextButton setImage:[UIImage imageNamed:@"PlanTabCalendarNextIcon"] forState:UIControlStateNormal];
    [_nextButton setTitle:nil forState:UIControlStateNormal];
    [_calendar bringSubviewToFront:_nextButton];
}

#pragma mark - TableView

- (void)loadTableView {
    _date = [_calendar selectedDate];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 80.0f;
    self.tableHeaderContainer.height = 300.0f;
    _tableView.tableHeaderView = _tableHeaderContainer;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 20)];
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCLocationPlanTabCalendarCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCLocationPlanTabCalendarCell class])];
    [_tableView addHeaderWithTarget:self action:@selector(tableViewHeaderRefreshing)];
    [_tableView addFooterWithTarget:self action:@selector(tableViewFooterRefreshing)];
    
    [_tableView headerBeginRefreshing];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_planInfoArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    if (_planInfoArray.count > indexPath.row) {
        LCPlanModel *plan = [self.planInfoArray objectAtIndex:indexPath.row];
        LCLocationPlanTabCalendarCell *planCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCLocationPlanTabCalendarCell class]) forIndexPath:indexPath];
        planCell.plan = plan;
        planCell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell = planCell;
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id plan = [self.planInfoArray objectAtIndex:indexPath.row];
    if ([plan isKindOfClass:[LCPlanModel class]]) {
        LCPlanModel *normalPlan = (LCPlanModel *)plan;
        [LCViewSwitcher pushToShowPlanDetailVCForPlan:normalPlan recmdUuid:nil on:self.navigationController];
    }
}

#pragma mark - Common Funcs

- (void)requestPlan:(NSDate *)date orderStr:(NSString *)orderStr {
    NSString *locName = @"";
    if (nil != [LCDataManager sharedInstance].currentCity) {
        locName = [LCDataManager sharedInstance].currentCity.cityName;
    }
    BOOL isRefresh;
    if ([LCStringUtil isNullString:orderStr]) {
        isRefresh = YES;
    } else {
        isRefresh = NO;
    }
    __weak typeof(self) weakSelf = self;
    __weak typeof(orderStr) weakOrderStr = orderStr;
    [LCNetRequester getCalendarPlan_V_Five_ByLocationName:locName startDate:date orderStr:orderStr callBack:^(NSArray *planArray, NSString *orderStr, NSError *error) {
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
            return;
        } else if (nil == planArray || planArray.count == 0){
            if ([LCStringUtil isNullString:weakOrderStr]) {
                weakSelf.tableHeaderContainer.height = 586.0f;
            } else {
                [YSAlertUtil tipOneMessage:@"没有更多活动!"];
            }
        } else {
            weakSelf.tableHeaderContainer.height = 300.0f;
        }
        if (!weakSelf.planInfoArray) {
            weakSelf.planInfoArray = [[NSMutableArray alloc] init];
        }
        weakSelf.orderStr = orderStr;
        if (isRefresh) {
            [weakSelf.planInfoArray removeAllObjects];
        }
        weakSelf.planInfoArray = [NSMutableArray arrayWithArray:[LCSharedFuncUtil addFiltedArrayToArray:weakSelf.planInfoArray withUnfiltedArray:planArray]];
        [weakSelf updateShow];
    }];
}

- (void)tableViewHeaderRefreshing {
    [self requestPlan:_date orderStr:@""];
}

- (void)tableViewFooterRefreshing {
    [self requestPlan:_date orderStr:_orderStr];
}

- (void)updateShow {
    [self.tableHeaderContainer sizeToFit];
    [self.tableView reloadData];
}

- (BOOL)isDatesSameDay:(NSDate *)date1 another:(NSDate *)date2 {
    NSString *str1 = [[date1 description] substringToIndex:10];
    NSString *str2 = [[date2 description] substringToIndex:10];
    
    if ([str1 isEqualToString:str2]) {
        return YES;
    }
    return NO;
}

@end