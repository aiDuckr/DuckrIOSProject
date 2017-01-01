//
//  LCCalendarSearchVC.m
//  LinkCity
//
//  Created by 张宗硕 on 8/4/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCCalendarSearchVC.h"
#import "LCCalendarChooseDateView.h"
#import "LCFilterTagButton.h"
#import "LCFreePlanCell.h"
#import "LCCostPlanCell.h"
#import "LCSharedFuncUtil.h"
#define TopCalendarFilterViewHeight (150.0f)
#define TopCalendarFilterNum 3
@interface LCCalendarSearchVC ()<LCCalendarChooseDateViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate, LCFilterTagButtonDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, LCSharedFuncUtilForGrayview>
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *hintResultView;
@property (weak, nonatomic) IBOutlet UIView *filteredView;

@property (weak, nonatomic) IBOutlet LCFilterTagButton *filteredFirstBtn;
@property (weak, nonatomic) IBOutlet LCFilterTagButton *filteredSecondBtn;
@property (weak, nonatomic) IBOutlet LCFilterTagButton *filteredThirdBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *filterViewWidthConstraint;

@property (weak, nonatomic) IBOutlet UIView *themeContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *themeContainerWidthConstraint;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopConstraint;

@property (weak, nonatomic) IBOutlet LCFilterTagButton *timeTodayButton;
@property (weak, nonatomic) IBOutlet LCFilterTagButton *timeTomorrowButton;
@property (weak, nonatomic) IBOutlet LCFilterTagButton *timeWeekButton;
@property (weak, nonatomic) IBOutlet LCFilterTagButton *timeDatesButton;

@property (weak, nonatomic) IBOutlet LCFilterTagButton *orderHotButton;
@property (weak, nonatomic) IBOutlet LCFilterTagButton *orderCreatedTimeButton;
@property (weak, nonatomic) IBOutlet LCFilterTagButton *orderPriceButton;

@property (weak, nonatomic) IBOutlet LCFilterTagButton *priceFreeButton;
@property (weak, nonatomic) IBOutlet LCFilterTagButton *priceOneButton;
@property (weak, nonatomic) IBOutlet LCFilterTagButton *priceTwoButton;
@property (weak, nonatomic) IBOutlet LCFilterTagButton *priceThreeButton;
@property (weak, nonatomic) IBOutlet LCFilterTagButton *priceFourButton;

@property (retain, nonatomic) LCSearchBar *searchBar;

@property (strong, nonatomic) NSArray *timeButtonArr;
@property (strong, nonatomic) NSArray *priceButtonArr;
@property (strong, nonatomic) NSArray *themeButtonArr;
@property (strong, nonatomic) NSArray *orderButtonArr;
@property (strong, nonatomic) NSArray *filteredButtonArr;
@property (strong, nonatomic) NSArray *filterCorrButtonArr;
@property (strong, nonatomic) NSArray *dateArr;
@property (strong, nonatomic) NSArray *priceArr;
@property (strong, nonatomic) NSArray *themeArr;
@property (assign, nonatomic) LCPlanOrderType orderType;
@property (strong, nonatomic) NSString *orderStr;
@property (strong, nonatomic) NSArray *contentArr;
@property (assign, nonatomic) BOOL isShowFilteredView;
@property (assign, nonatomic) BOOL isLocalSearch;
@end

@implementation LCCalendarSearchVC

#pragma mark - LifeCycle.
/// 首页控制器.
+ (instancetype)createInstance {
    return (LCCalendarSearchVC *)[LCStoryboardManager viewControllerWithFileName:SBNamePlanTab identifier:VCIDCalendarSearchVC];
}

/// 初始化变量.
- (void)commonInit {
    [super commonInit];
    self.timeButtonArr = [[NSArray alloc] init];
    self.priceButtonArr = [[NSArray alloc] init];
    self.themeButtonArr = [[NSArray alloc] init];
    self.orderButtonArr = [[NSArray alloc] init];
    self.filteredButtonArr = [[NSArray alloc] init];
    self.filterCorrButtonArr = [[NSArray alloc] init];
    
    self.dateArr = [[NSArray alloc] init];
    self.priceArr = [[NSArray alloc] init];
    self.themeArr = [[NSArray alloc] init];
    if ([self.searchText isEqualToString:@""] ||nil == self.searchText) {
        self.searchText = @"";
    }
    self.orderType = LCPlanOrderType_Default;
    self.orderStr = @"";
    self.contentArr = [[NSArray alloc] init];
    self.isShowFilteredView = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /// 初始化上方搜索视图.
    [self initSearchBar];
    /// 初始化时间筛选按钮.
    [self initTimeButtons];
    /// 初始化价格筛选按钮.
    [self initPriceButtons];
    /// 初始化主题筛选按钮.
    [self initThemeContainerView];
    /// 初始化排序按钮.
    [self initOrderButtons];
    [self initFilteredButtons];
    /// 初始化搜索结果列表视图.
    [self initTableView];
}

/// 第一次进来显示日历.
- (void)viewDidAppear:(BOOL)animated {
    if (YES == self.isViewWillAppearCalledFirstTime && self.isCalenderSearch) {
        [self.timeDatesButton updateFilterTagButtonStatus:NO];
    } else if (nil != self.searchText && self.searchText.length > 0 && self.isNeedRefresh){
        [self.tableView headerBeginRefreshing];
        self.isNeedRefresh = NO;
    }
    [super viewDidAppear:animated];
}

#pragma mark - Common Init.
/// 初始化上方搜索视图.
- (void)initSearchBar {
    self.searchBar = [[LCSearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, (DEVICE_WIDTH - 45.0f * 3), 44.0f)];
    [self.searchBar setSearchTextFieldBackgroundColor:UIColorFromRGBA(0xf5f4f2, 1.0)];
    self.searchBar.showsCancelButton = NO;
    self.searchBar.delegate = self;
    self.searchBar.text = @"";
    [self.searchBar setPlaceholder:@"搜索活动主题、名称、地点"];
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(45.0f, 0.0f, (DEVICE_WIDTH - 45.0f * 3), 44.0f)];
    [searchView addSubview:self.searchBar];
    self.navigationItem.titleView = searchView;
}

/// 初始化时间筛选按钮.
- (void)initTimeButtons {
    NSMutableArray *mutArr = [[NSMutableArray alloc] init];
    [mutArr addObject:self.timeTodayButton];
    [mutArr addObject:self.timeTomorrowButton];
    [mutArr addObject:self.timeWeekButton];
    [mutArr addObject:self.timeDatesButton];
    self.timeButtonArr = mutArr;
    for (LCFilterTagButton *btn in self.timeButtonArr) {
        btn.delegate = self;
        btn.type = FilterTagButtonType_Default;
        btn.appearance = FilterTagButtonAppearance_SearchGray;
    }
}

/// 初始化价格筛选按钮.
- (void)initPriceButtons {
    NSMutableArray *mutArr = [[NSMutableArray alloc] init];
    [mutArr addObject:self.priceFreeButton];
    [mutArr addObject:self.priceOneButton];
    [mutArr addObject:self.priceTwoButton];
    [mutArr addObject:self.priceThreeButton];
    [mutArr addObject:self.priceFourButton];
    self.priceButtonArr = mutArr;
    for (LCFilterTagButton *btn in self.priceButtonArr) {
        btn.delegate = self;
        btn.type = FilterTagButtonType_Default;
        btn.appearance = FilterTagButtonAppearance_SearchGray;
    }
}

/// 初始化主题筛选按钮.
- (void)initThemeContainerView {
    NSMutableArray *themeArr = [NSMutableArray arrayWithArray:[LCDataManager sharedInstance].appInitData.inviteThemes];//最后一个"其他"主题按钮不显示
    [themeArr removeLastObject];

    if (nil != themeArr && themeArr.count > 0) {
        /// 删除滚动视图内的View的宽度约束.
        [self.themeContainerView removeConstraint:self.themeContainerWidthConstraint];
    }
    NSMutableArray *mutArr = [[NSMutableArray alloc] init];
    LCFilterTagButton *lastBtn = nil;
    for (NSInteger index = 0; index < themeArr.count; ++index) {
        LCRouteThemeModel *model = [themeArr objectAtIndex:index];

        LCFilterTagButton *btn = [[LCFilterTagButton alloc] initWithFrame:CGRectZero];
        btn.delegate = self;
        btn.tag = model.tourThemeId;
        btn.type = FilterTagButtonType_Default;
        btn.translatesAutoresizingMaskIntoConstraints = NO;
        btn.appearance = FilterTagButtonAppearance_SearchGray;
        [btn setTitle:model.title forState:UIControlStateNormal];
        /// 按钮的内容距左右各8的距离.
        [btn setContentEdgeInsets:UIEdgeInsetsMake(0.0f, 8.0f, 0.0f, 8.0f)];
        btn.titleLabel.font = [UIFont fontWithName:APP_CHINESE_FONT size:13.0f];
        [self.themeContainerView addSubview:btn];
        
        /// 按钮高度固定28.
        NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:28.0f];
        [btn addConstraint:heightConstraint];
        
        if (0 == index) {
            /// 第一个按钮距离父视图距离12.
            NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.themeContainerView attribute:NSLayoutAttributeLeading multiplier:1 constant:12.0f];
            [self.themeContainerView addConstraint:leftConstraint];
        } else {
            /// 其余各个视图距离左边的按钮15.
            NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:lastBtn attribute:NSLayoutAttributeTrailing multiplier:1 constant:11.0f];
            [self.themeContainerView addConstraint:leftConstraint];
        }
        
        /// 所有的按钮垂直居中.
        NSLayoutConstraint *centerConstraint = [NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.themeContainerView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
        [self.themeContainerView addConstraint:centerConstraint];
        
        if (themeArr.count - 1 == index) {
            /// 最后一个按钮距离父视图右边12.
            NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.themeContainerView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-12.0f];
            [self.themeContainerView addConstraint:rightConstraint];
        }
        [mutArr addObject:btn];
        lastBtn = btn;
    }
    self.themeButtonArr = mutArr;
}

/// 初始化排序按钮.
- (void)initOrderButtons {
    NSMutableArray *mutArr = [[NSMutableArray alloc] init];
    [mutArr addObject:self.orderHotButton];
    [mutArr addObject:self.orderCreatedTimeButton];
    [mutArr addObject:self.orderPriceButton];
    self.orderButtonArr = mutArr;
    for (LCFilterTagButton *btn in self.orderButtonArr) {
        btn.delegate = self;
        btn.type = FilterTagButtonType_Radio;
        btn.appearance = FilterTagButtonAppearance_SearchWhite;
    }
}

- (void)initFilteredButtons {
    NSMutableArray *mutArr = [[NSMutableArray alloc] init];
    [mutArr addObject:self.filteredFirstBtn];
    [mutArr addObject:self.filteredSecondBtn];
    [mutArr addObject:self.filteredThirdBtn];
    self.filteredButtonArr = mutArr;
    for (LCFilterTagButton *btn in self.filteredButtonArr) {
        btn.delegate = self;
        btn.type = FilterTagButtonType_MutSelect;
        btn.appearance = FilterTagButtonAppearance_Normal;
    }
}

/// 初始化搜索结果列表视图.
- (void)initTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 180.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    /// 需要先赋值FooterView，否则HeaderView无法显示，解决底部有大部分空白的问题.
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, DEVICE_WIDTH, 10.0f)];
    self.tableView.tableHeaderView = self.headerView;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCFreePlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCFreePlanCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCCostPlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCCostPlanCell class])];
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefreshAction)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefreshAction)];
}

#pragma mark - Common Func.
/// 更新视图.
- (void)updateShow {
    /// 有数据的时候隐藏没有找到相关活动视图.
    if (nil == self.contentArr || self.contentArr.count <= 0) {
        self.hintResultView.hidden = NO;
    } else {
        self.hintResultView.hidden = YES;
    }
    [self.headerView sizeToFit];
    [self.tableView reloadData];
}

- (void)updateShowFilteredView {
    if (YES == self.isShowFilteredView) {
        return ;
    }
    self.filterCorrButtonArr = [[NSArray alloc] init];
    
    for (NSInteger index = 0; index < self.timeButtonArr.count; ++index) {
        LCFilterTagButton *btn = (LCFilterTagButton *)[self.timeButtonArr objectAtIndex:index];
        if (YES == btn.selected) {
            [self addFilteredButton:btn];
        }
    }
    
    for (NSInteger index = 0; index < self.priceButtonArr.count; ++index) {
        LCFilterTagButton *btn = (LCFilterTagButton *)[self.priceButtonArr objectAtIndex:index];
        if (YES == btn.selected) {
            [self addFilteredButton:btn];
        }
    }
    
    for (NSInteger index = 0; index < self.themeButtonArr.count; ++index) {
        LCFilterTagButton *btn = (LCFilterTagButton *)[self.themeButtonArr objectAtIndex:index];
        if (YES == btn.selected) {
            [self addFilteredButton:btn];
        }
    }
    
    for (NSInteger index = 0; index < self.orderButtonArr.count; ++index) {
        LCFilterTagButton *btn = (LCFilterTagButton *)[self.orderButtonArr objectAtIndex:index];
        if (YES == btn.selected) {
            [self addFilteredButton:btn];
        }
    }
    NSInteger filterNum = self.filterCorrButtonArr.count;
    if (filterNum >= 1) {
        [self showFilteredView];
    } else {
        [self showFilterView];
        return ;
    }
    
    NSInteger width = 0.0f;
    for (NSInteger index = 0; index < self.filterCorrButtonArr.count; ++index) {
        LCFilterTagButton *btn = (LCFilterTagButton *)[self.filterCorrButtonArr objectAtIndex:index];
        LCFilterTagButton *filteredBtn = (LCFilterTagButton *)[self.filteredButtonArr objectAtIndex:index];
        [filteredBtn updateFilterTagButtonApperance:YES];
        [filteredBtn setTitle:btn.titleLabel.text forState:UIControlStateNormal];
        NSString *titleStr = btn.titleLabel.text;
        CGFloat titleWidth = [LCStringUtil getWidthOfString:titleStr withFont:[UIFont fontWithName:APP_CHINESE_FONT size:13.0f] labelHeight:28.0f];
        width += titleWidth + 2 * 8.0f + 15.0f;
    }
//    width -= 15.0f;
    self.filterViewWidthConstraint.constant = width;
}

- (void)updateShowFilterView {
    if (NO == self.isShowFilteredView) {
        return ;
    }
    [self showFilterView];
}

- (void)showFilteredView {
    self.filteredView.hidden = NO;
    self.isShowFilteredView = YES;
}

- (void)showFilterView {
    self.filteredView.hidden = YES;
    self.isShowFilteredView = NO;
}

- (LCFilterTagButton *)createFiltedButtonWithTag:(NSInteger)tag title:(NSString *)title {
    LCFilterTagButton *btn = [[LCFilterTagButton alloc] initWithFrame:CGRectZero];
    btn.delegate = self;
    btn.tag = tag;
    btn.type = FilterTagButtonType_Default;
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    btn.appearance = FilterTagButtonAppearance_SearchGray;
    [btn setTitle:title forState:UIControlStateNormal];
    /// 按钮的内容距左右各8的距离.
    [btn setContentEdgeInsets:UIEdgeInsetsMake(0.0f, 8.0f, 0.0f, 8.0f)];
    btn.titleLabel.font = [UIFont fontWithName:APP_CHINESE_FONT size:13.0f];
    return btn;
}

- (void)addFilteredButton:(LCFilterTagButton *)btn {
    if (nil == btn || self.filterCorrButtonArr.count >= TopCalendarFilterNum) {
        return ;
    }
    
    NSMutableArray *fliterCorrMutArr = [[NSMutableArray alloc] initWithArray:self.filterCorrButtonArr];
    [fliterCorrMutArr addObject:btn];
    
    self.filterCorrButtonArr = fliterCorrMutArr;
}

/// 根据视图填的内容获取相应的请求Server的变量数据.
- (void)updateRequestVariable {
    /// 搜索的内容.
    if (self.searchBar.text.length > 0) {
        self.searchText = self.searchBar.text;
    }

    NSMutableArray *mutArr = [[NSMutableArray alloc] init];

    if (NO == self.timeDatesButton.selected) {
        [self.timeDatesButton setTitle:@"Date" forState:UIControlStateNormal];
        
        // 选择的今天的时间.
        if (YES == self.timeTodayButton.selected) {
            NSArray *dayArr = [LCDateUtil getTodayDateStrs];
            for (NSString *str in dayArr) {
                [mutArr addObject:str];
            }
        }
        /// 选择的明天的时间.
        if (YES == self.timeTomorrowButton.selected) {
            NSArray *dayArr = [LCDateUtil getTomorrowDateStrs];
            for (NSString *str in dayArr) {
                    [mutArr addObject:str];
            }
        }
        
        /// 选择的本周的时间.
        if (YES == self.timeWeekButton.selected) {
            NSArray *dayArr = [LCDateUtil getWeekDateStrs];
            for (NSString *str in dayArr) {
                    [mutArr addObject:str];
            }
        }
        self.dateArr = mutArr;
    } else {
        if (nil == self.dateArr || self.dateArr.count <= 0) {
            [self.timeDatesButton setTitle:@"Dates" forState:UIControlStateNormal];
            [self.timeDatesButton updateFilterTagButtonApperance:NO];
        } else {
            NSString *datesShowStr = [LCDateUtil getDatesShowStrFromDateArr:self.dateArr];
            [self.timeDatesButton setTitle:datesShowStr forState:UIControlStateNormal];
        }
    }
    
    /// 选择的价格.
    mutArr = [[NSMutableArray alloc] init];
    for (NSInteger index = 0; index < self.priceButtonArr.count; ++index) {
        LCFilterTagButton *btn = (LCFilterTagButton *)[self.priceButtonArr objectAtIndex:index];
        if (YES == btn.selected) {
            [mutArr addObject:[NSString stringWithFormat:@"%zd", btn.tag]];
        }
    }
    self.priceArr = mutArr;
    
    /// 选择的主题.
    mutArr = [[NSMutableArray alloc] init];
    for (NSInteger index = 0; index < self.themeButtonArr.count; ++index) {
        LCFilterTagButton *btn = (LCFilterTagButton *)[self.themeButtonArr objectAtIndex:index];
        if (YES == btn.selected) {
            [mutArr addObject:[NSString stringWithFormat:@"%zd", btn.tag]];
        }
    }
    self.themeArr = mutArr;
    
    /// 选择的排序方式.
    self.orderType = LCPlanOrderType_Default;
    for (NSInteger index = 0; index < self.orderButtonArr.count; ++index) {
        LCFilterTagButton *btn = (LCFilterTagButton *)[self.orderButtonArr objectAtIndex:index];
        if (YES == btn.selected) {
            self.orderType = btn.tag;
        }
    }
    if (self.orderType == LCPlanOrderType_Default) {
        [self.orderHotButton updateFilterTagButtonApperance:YES];
    }

}

/// 邀约或者商品的Cell.
- (UITableViewCell *)configureInviteCell:(UITableView*)tableView withIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    LCPlanModel *plan = [self.contentArr objectAtIndex:indexPath.row];
    if (LCPlanType_CostPlan == plan.routeType || LCPlanType_CostLocal == plan.routeType) {
        LCCostPlanCell *costPlanCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCCostPlanCell class]) forIndexPath:indexPath];
        [costPlanCell updateShowWithPlan:plan];
        cell = costPlanCell;
    } else {
        LCFreePlanCell *freePlanCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCFreePlanCell class]) forIndexPath:indexPath];
        if (indexPath.row != self.contentArr.count - 1) {
            [freePlanCell updateShowWithPlan:plan hideThemeId:0 withSpaInset:YES];
        } else {
            [freePlanCell updateShowWithPlan:plan hideThemeId:0 withSpaInset:NO];
        }
        freePlanCell.delegate = [LCDelegateManager sharedInstance];
        cell = freePlanCell;
    }
    return cell;
}


- (IBAction)filteredShowFilterViewAction:(id)sender {
    [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffset.x, 0.0f)];
}



#pragma mark - Server Request.
/// 下拉刷新.
- (void)headerRefreshAction {
    self.orderStr = @"";
    [self requestContentDatas];
}

/// 上拉加载更多.
- (void)footerRefreshAction {
    [self requestContentDatas];
}

/// 从后台获取首页推荐的数据列表.
- (void)requestContentDatas {
    [self.searchBar resignFirstResponder];
    [self updateRequestVariable];

    __weak typeof(self) weakSelf = self;
    [LCNetRequester requestHomeCalendar:self.dateArr priceArr:self.priceArr themeArr:self.themeArr searchText:self.searchText orderType:self.orderType orderStr:self.orderStr withCallBack:^(NSArray *contentArr, NSString *orderStr, NSError *error) {
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
        if (!error) {
            if ([LCStringUtil isNullString:self.orderStr]) {
                weakSelf.contentArr = [[NSArray alloc] init];
            }
            if (nil != contentArr && contentArr.count > 0) {
                weakSelf.contentArr = [LCSharedFuncUtil addFiltedArrayToArray:weakSelf.contentArr withUnfiltedArray:contentArr];
            } else if ([LCStringUtil isNotNullString:weakSelf.orderStr]) {
                [YSAlertUtil tipOneMessage:@"没有更多内容"];
            }
            weakSelf.orderStr = orderStr;
            [weakSelf updateShow];
        } else {
            [YSAlertUtil tipOneMessage:error.domain];
        }
    }];
}


#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
    
    /// 手往下，内容往下滚，contentOffset变负.
    CGFloat localFreeHeight = TopCalendarFilterViewHeight - scrollView.contentOffset.y;
    
    if (localFreeHeight < 0.0f) {
        [self updateShowFilteredView];
    } else if (localFreeHeight <= TopCalendarFilterViewHeight) {
        [self updateShowFilterView];
    }
    
    //    [self updateNavigationBarAppearance];
}

#pragma mark - LCCalendarChooseDateView Delegate.
- (void)didSelectedDates:(NSArray *)dates {
    /// 日历上选择了日期，取消选择其他的明天，本周，本月的选中状态.
    if (nil != dates && dates.count > 0) {
        for (LCFilterTagButton *btn in self.timeButtonArr) {
            if (btn != self.timeDatesButton) {
                [btn updateFilterTagButtonApperance:NO];
            } else {
                [self.timeDatesButton updateFilterTagButtonApperance:YES];
            }
        }
    }else {//若没有选择日期则按钮变回初始状态
        [self.timeDatesButton updateFilterTagButtonApperance:NO];
    }
    
    NSMutableArray *mutArr = [[NSMutableArray alloc] init];
    for (NSDate *date in dates) {
        NSString *dateStr = [LCDateUtil stringFromDate:date];
        [mutArr addObject:dateStr];
    }
    self.dateArr = mutArr;
    [LCDataManager sharedInstance].currentSelectedArray=self.dateArr;
    [self.tableView headerBeginRefreshing];
}
- (void)calendarChooseDateViewCancel:(LCCalendarChooseDateView *)view {
    if (self.dateArr.count == 0)
    {
        [self.timeDatesButton updateFilterTagButtonApperance:NO];
    }


}
#pragma mark - LCFilterTagButton Delegate.
- (void)filterTagButtonSelected:(LCFilterTagButton *)button {
    
    if (NSNotFound != [self.timeButtonArr indexOfObject:button]) {
        [button updateShowButtons:self.timeButtonArr];
        [self.timeDatesButton updateFilterTagButtonApperance:NO];
        if (button == self.timeDatesButton) {
            [[LCPopViewHelper sharedInstance] popDateSelectedView:self];
        }
    }
    if (NSNotFound != [self.orderButtonArr indexOfObject:button]) {
        [button updateShowButtons:self.orderButtonArr];
    }
    if (NSNotFound != [self.themeButtonArr indexOfObject:button]) {
        [button updateShowButtons:self.themeButtonArr];
    }
    if (NSNotFound != [self.priceButtonArr indexOfObject:button]) {
        [button updateShowButtons:self.priceButtonArr];
    }
    if (NSNotFound != [self.filteredButtonArr indexOfObject:button]) {
        NSInteger index = [self.filteredButtonArr indexOfObject:button];
        LCFilterTagButton *btn = [self.filterCorrButtonArr objectAtIndex:index];
        [btn updateFilterTagButtonStatus:button.selected];
        [self showFilterView];
        return;
    }
    if (button != self.timeDatesButton) {
        [self.tableView headerBeginRefreshing];
    }
}

- (void)filterTagButtonUnSelected:(LCFilterTagButton *)button {
    
    if (button == self.timeDatesButton) {
//        self.dateArr = [[NSArray alloc] init];
        [button updateFilterTagButtonApperance:YES];
        [[LCPopViewHelper sharedInstance] popDateSelectedView:self];
    }else {
    if (NSNotFound != [self.filteredButtonArr indexOfObject:button]) {
        NSInteger index = [self.filteredButtonArr indexOfObject:button];
        LCFilterTagButton *btn = [self.filterCorrButtonArr objectAtIndex:index];
        [btn updateFilterTagButtonStatus:button.selected];
        [self updateShowFilterView];
        return;
    }
    [self.tableView headerBeginRefreshing];
    }
}

#pragma mark - UITableView Delegate.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger number = self.contentArr.count;
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self configureInviteCell:tableView withIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LCPlanModel *model = [self.contentArr objectAtIndex:indexPath.row];
    [LCViewSwitcher pushToShowPlanDetailVCForPlan:model recmdUuid:@"" on:self.navigationController];
}

#pragma mark - UISearchBar Delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [[LCSharedFuncUtil sharedInstance] removeGrayViewfromSuperview];
    NSString *text = searchBar.text;
    if (NO == [text isEqualToString:self.searchText]) {
        [self.tableView headerBeginRefreshing];
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    if (_contentArr.count > 0) {
        LCSharedFuncUtil *sharedInstance = [LCSharedFuncUtil sharedInstance];
        sharedInstance.delegate = self;
        UIView *grayView = [sharedInstance getGrayView];
        [self.view addSubview:grayView];
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [[LCSharedFuncUtil sharedInstance] removeGrayViewfromSuperview];
}



- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {

}
#pragma mark LCSharedFuncUtilForGrayview Delegate
- (void)hideKeyboard {
    [self.searchBar resignFirstResponder];
    [self.view endEditing:YES];
}
//- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
//    [self dismissKeyboardAndHidesearchResultArr];
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
