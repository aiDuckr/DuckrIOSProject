//
//  LCMainSearchPlanVC.m
//  LinkCity
//
//  Created by lhr on 16/5/12.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCMainSearchPlanVC.h"
#import "LCSendPlanTagView.h"
#import "LCCostPlanCell.h"
#import "LCFreePlanCell.h"
#import "LCWebPlanCell.h"
//#import "UIView+BlocksKit.h"
#import "LCCalendarChooseDateView.h"
@interface LCMainSearchPlanVC ()<UISearchBarDelegate, LCSendPlanTagViewDelegate, UITableViewDelegate, UITableViewDataSource, LCDelegateManagerDelegate, LCCalendarChooseDateViewDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate>

@property (nonatomic,strong) LCSearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *searchInfoView2;
@property (weak, nonatomic) IBOutlet UIView *searchInfoView1;
@property (weak, nonatomic) IBOutlet UILabel *searchLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *emptyView;

@property (retain, nonatomic) NSArray *searchResult;

@property (assign, nonatomic) BOOL isFirstInfoVC;

@property (nonatomic,strong) LCSendPlanTagView *tagViewTomorrow;

@property (nonatomic,strong) LCSendPlanTagView *tagViewNextWeek;

@property (nonatomic,strong) LCSendPlanTagView *tagViewNextMonth;

@property (nonatomic,strong) LCSendPlanTagView *tagViewDate;

@property (nonatomic,strong) LCSendPlanTagView *selectedTagDateView;

@property (nonatomic,strong) LCSendPlanTagView *tagViewPlanParter;

@property (nonatomic,strong) LCSendPlanTagView *tagViewPlanLocal;

@property (nonatomic,strong) LCSendPlanTagView *selectedTagPlanView;

@property (nonatomic,strong) NSString *startDate;

@property (nonatomic,strong) NSString *endDate;

@property (nonatomic,strong) NSString *destName;

@property (nonatomic,assign) NSInteger planType;

@property (nonatomic,strong) NSString *departName;

@property (nonatomic,strong) NSString *orderStr;

@property (nonatomic,strong) LCCalendarChooseDateView *dateView;
@property (nonatomic,assign) BOOL isAppearingFromMainVC;
//@property (nonatomic, strong)

@end

@implementation LCMainSearchPlanVC


#pragma mark -init

+ (instancetype)createInstance {
    return (LCMainSearchPlanVC *)[LCStoryboardManager viewControllerWithFileName:SBNamePlanTab identifier:VCIDMainSearchPlanVC];
}


- (void)initNavigationBar {
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonAction)];
    NSDictionary* textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIFont systemFontOfSize:17],NSFontAttributeName,
                                    UIColorFromRGBA(0x2c2a28, 1), NSForegroundColorAttributeName,
                                    nil];
    [cancelBtn setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = cancelBtn;
    [self.navigationItem setHidesBackButton:YES];
}
/// 初始化搜索框.
- (void)initSearchBar {
    self.searchBar = [[LCSearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, (DEVICE_WIDTH - 70.0f), 44.0f)];
    self.searchBar.delegate = self;
    self.searchBar.text = @"";
    [self.searchBar setPlaceholder:@"搜索你感兴趣的目的地"];
    [self.searchBar setSearchTextFieldBackgroundColor:UIColorFromRGBA(0xf5f4f2, 1)];
    
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(45.0f, 0.0f, (DEVICE_WIDTH - 45.0f * 1), 44.0f)];
    [searchView addSubview:self.searchBar];
    self.navigationItem.titleView = searchView;
    self.emptyView.hidden = YES;
}

- (void)initTagsView {
    _tagViewTomorrow = [[LCSendPlanTagView alloc] initWithFrame:CGRectMake(0, 0, 45, 28) isFixedFrame:YES titleString:@"明天"];
    self.tagViewTomorrow.tag = 0;
    self.tagViewTomorrow.delegate = self;
    [self.searchInfoView1 addSubview:self.tagViewTomorrow];
    _tagViewNextWeek = [[LCSendPlanTagView alloc] initWithFrame:CGRectMake(0, 0, 45, 28) isFixedFrame:YES titleString:@"本周"];
    self.tagViewNextWeek.tag = 0;
    self.tagViewNextWeek.delegate = self;
    [self.searchInfoView1 addSubview:self.tagViewNextWeek];
    _tagViewNextMonth = [[LCSendPlanTagView alloc] initWithFrame:CGRectMake(0, 0, 45, 28) isFixedFrame:YES titleString:@"本月"];
    self.tagViewNextMonth.tag = 0;
    self.tagViewNextMonth.delegate = self;
    [self.searchInfoView1 addSubview:self.tagViewNextMonth];
    _tagViewDate = [[LCSendPlanTagView alloc] initWithFrame:CGRectMake(0, 0, 45, 28) isFixedFrame:YES titleString:@"日历"];
    self.tagViewDate.tag = 0;
    self.tagViewDate.delegate = self;
    [self.searchInfoView1 addSubview:self.tagViewDate];
    
    _tagViewPlanParter = [[LCSendPlanTagView alloc] initWithFrame:CGRectMake(0, 0, 75, 28) isFixedFrame:YES titleString:@"旅行邀约"];
    self.tagViewPlanParter.tag = 1;
    self.tagViewPlanParter.delegate = self;
    [self.searchInfoView2 addSubview:self.tagViewPlanParter];
    _tagViewPlanLocal = [[LCSendPlanTagView alloc] initWithFrame:CGRectMake(0, 0, 75, 28) isFixedFrame:YES titleString:@"同城邀约"];
    self.tagViewPlanLocal.tag = 1;
    self.tagViewPlanLocal.delegate = self;
    [self.searchInfoView2 addSubview:self.tagViewPlanLocal];
}

- (void)initTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100.0f;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCFreePlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCFreePlanCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCCostPlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCCostPlanCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCWebPlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCWebPlanCell class])];
    [self.tableView addHeaderWithTarget:self action:@selector(tableViewHeaderRefreshing)];
    [self.tableView addFooterWithTarget:self action:@selector(tableViewFooterRefreshing)];
    
}

- (void)commonInit {
     self.isFirstInfoVC = YES;
}
- (void)setUpUI {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(drawBackKeyboard)];
   
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    self.isAppearingFromMainVC = YES;
    self.dateView = [LCCalendarChooseDateView createInstance];
    self.dateView.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
    self.dateView.delegate = self;

    self.tagViewTomorrow.x = self.searchLabel.maxX + 10;
    self.tagViewTomorrow.yCenter = self.searchLabel.yCenter;
    self.tagViewNextWeek.x = self.tagViewTomorrow.maxX + 15;
    self.tagViewNextWeek.yCenter = self.tagViewTomorrow.yCenter;
    self.tagViewNextMonth.x = self.tagViewNextWeek.maxX + 15;
    self.tagViewNextMonth.yCenter = self.tagViewNextWeek.yCenter;
    self.tagViewDate.x = self.tagViewNextMonth.maxX + 15;
    self.tagViewDate.yCenter = self.tagViewNextMonth.yCenter;
    
    self.tagViewPlanParter.x = self.searchLabel.maxX + 10;
    self.tagViewPlanParter.yCenter = self.searchLabel.yCenter;
    self.tagViewPlanLocal.x = self.tagViewPlanParter.maxX + 15;
    self.tagViewPlanLocal.yCenter = self.tagViewPlanParter.yCenter;
}
#pragma mark - life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigationBar];
    [self initSearchBar];
    [self initTagsView];
    [self initTableView];
    [self setUpUI];
     [self addObserveToNotificationNameToRefreshData:URL_FAVOR_PLAN];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [LCDelegateManager sharedInstance].delegate = self;
    if (self.isAppearingFromMainVC) {
        [self.searchBar becomeFirstResponder];
        self.isAppearingFromMainVC = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Refresh

- (void)tableViewHeaderRefreshing {
    //Result
    self.orderStr = nil;
    [self requestDataFromServer];
    
}


- (void)tableViewFooterRefreshing {
    [self requestDataFromServer];
    
}
- (void)requestDataFromServer {
    self.isFirstInfoVC = NO;
    [self.view endEditing:YES];
    if (self.isShowingKeyboard) {
        [self.searchBar resignFirstResponder];
    }
    __weak typeof(self) weakSelf = self;
    [self resetStartDateAndEndDate];
    [self resetPlanType];
    self.orderStr = [LCStringUtil getNotNullStr:self.orderStr];
    [LCNetRequester searchPlanByDestination:self.destName PlanType:self.planType DepartName:self.departName StartDate:self.startDate endDate:self.endDate orderString:self.orderStr callBack:^(NSArray *array, NSString *orderString,NSError *error) {
        if (!error) {
            if ([LCStringUtil isNullString:weakSelf.orderStr]) {
                if (nil != array && array.count > 0) {
                    weakSelf.searchResult = [LCSharedFuncUtil addFiltedArrayToArray:nil withUnfiltedArray:array];
                } else {
                    weakSelf.searchResult = [[NSArray alloc] init];
                    [YSAlertUtil tipOneMessage:@"没有搜索到内容"];
                }
            } else {
                if (nil != array && array.count > 0) {
                    weakSelf.searchResult = [LCSharedFuncUtil addFiltedArrayToArray:weakSelf.searchResult withUnfiltedArray:array];
                } else {
                    [YSAlertUtil tipOneMessage:@"没有更多搜索内容"];
                }
            }
            
            weakSelf.orderStr = orderString;
        } else {
            [YSAlertUtil tipOneMessage:error.domain];
        }
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
        [weakSelf updateShow];
    }];

}

- (void)refreshData {
    [self updateShow];
}
- (void)updateShow {
    [self.tableView reloadData];
    if ((self.searchResult && self.searchResult.count > 0) || self.isFirstInfoVC) {
        self.emptyView.hidden = YES;
    } else {
        self.emptyView.hidden = NO;
    }
    //    if (nil != self.plan) {
    //        [self popConfirmView:self.plan];
    //        self.plan = nil;
    //    }
}
- (IBAction)sendPlanAction:(id)sender {
    if ([[LCDataManager sharedInstance] haveLogin]) {
        [[LCSendPlanHelper sharedInstance] verifyIdentityAndSendFreePlan];
    }else{
        [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
    }
}

- (void)cancelButtonAction {
    
    //[self.navigationController popViewControllerAnimated:YES];
    if (self.isShowingKeyboard) {
        [self.searchBar resignFirstResponder];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - LCSendPlanTagView Delegate
- (void)didPressLCSendPlanTagView:(LCSendPlanTagView *)view {
    if (view.isSelected) {
        view.isSelected = NO;
        if (view.tag == 0) {
            self.selectedTagDateView = nil;
        } else {
            self.selectedTagPlanView = nil;
        }
    } else {
        view.isSelected = YES;
        if (view.tag == 0) {
            if (self.selectedTagDateView) {
                self.selectedTagDateView.isSelected = NO;
            }
        } else {
            if (self.selectedTagPlanView) {
                self.selectedTagPlanView.isSelected = NO;
            }
        }
        
        if (self.tagViewDate == view) {
            [self.view endEditing:YES];
            [self.searchBar resignFirstResponder];
            [[LCSharedFuncUtil getAppDelegate].window addSubview:self.dateView];
        } else {
            if (view.tag == 0) {
                self.selectedTagDateView = view;
            } else {
                self.selectedTagPlanView = view;
            }
            [self.tableView headerBeginRefreshing];
        }
        if (view.tag == 0) {
            self.selectedTagDateView = view;
        } else {
            self.selectedTagPlanView = view;
        }
    }
}



#pragma mark - UISearchBar Delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];

    self.destName = searchBar.text;
    
    [self.tableView headerBeginRefreshing];
   //    if ([LCStringUtil isNotNullString:searchBar.text]) {
//        [self recordSearchHistory:searchBar.text];
//        if (self.searchType == LCSearchDestinationVCType_Plan) {
//            [LCViewSwitcher pushToShowPlaceSearchResultForPlace:searchBar.text isDepart:NO on:self.navigationController];
//        } else if (x`self.searchType == LCSearchDestinationVCType_Tourpic) {
//            [self pushToTourpicTableVCWithPlaceName:searchBar.text];
//        }
//    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}


#pragma mark - UItableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResult.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = nil;
    if (self.searchResult.count > indexPath.row) {
        id model = [self.searchResult objectAtIndex:indexPath.row];
        if ([model isKindOfClass:[LCPlanModel class]]){
            LCPlanModel *planModel = (LCPlanModel *)model;
            if (planModel.routeType == LCRouteTypeFreePlanSameCity || planModel.routeType == LCRouteTypeFreePlanCommon) {
                //cell = [self configureFreePlanCell:planModel];
                cell = [self configureFreePlanCell:planModel withInset:YES];
                /*if (indexPath.row != ([tableView numberOfRowsInSection:indexPath.section] - 1)){
                    cell = [self configureFreePlanCell:planModel withInset:YES];
                } else {
                    cell = [self configureFreePlanCell:planModel withInset:NO];
                }*/
            } else {
                cell = [self configureCostPlanCell:planModel];
            }
        } else if ([model isKindOfClass:[LCWebPlanModel class]]) {
            LCWebPlanModel *webModel = (LCWebPlanModel *)model;
            cell = [self configureWebPlanCell:webModel];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self drawBackKeyboard];
    if (self.searchResult.count > indexPath.row) {
        id plan = [self.searchResult objectAtIndex:indexPath.row];
        if ([plan isKindOfClass:[LCPlanModel class]]) {
            LCPlanModel *normalPlan = (LCPlanModel *)plan;
            [LCViewSwitcher pushToShowPlanDetailVCForPlan:normalPlan recmdUuid:nil on:self.navigationController];
        } else if([plan isKindOfClass:[LCWebPlanModel class]]) {
            LCWebPlanModel *webPlan = (LCWebPlanModel *)plan;
            [LCViewSwitcher pushWebVCtoShowURL:webPlan.planUrl withTitle:webPlan.title on:self.navigationController];
        }
    }
    
}

- (LCFreePlanCell *)configureFreePlanCell:(LCPlanModel *)model withInset:(BOOL)haveInset{
    LCFreePlanCell * cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCFreePlanCell class])];
    cell.delegate = [LCDelegateManager sharedInstance];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateShowWithPlan:model hideThemeId:NoneHideThemeId withSpaInset:haveInset];

   // [cell updateShowWithPlan:model hideThemeId:;
    return cell;
}

- (LCCostPlanCell *)configureCostPlanCell:(LCPlanModel *)model {
    LCCostPlanCell * cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCCostPlanCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateShowWithPlan:model];
    return cell;
}

- (LCWebPlanCell *)configureWebPlanCell:(LCWebPlanModel *)model {
    LCWebPlanCell * cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCWebPlanCell class])];
    //cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateShowWebPlan:model];
    return cell;
}

/*
 * cellDelegate
 */

- (void)planLikeSelected:(LCFreePlanCell *)cell {
    
    NSInteger index = [self.tableView indexPathForCell:cell].row;
    if (index != NSNotFound) {
        if (![self haveLogin]) {
            [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
            return ;
        }
        NSString * planGuid = cell.plan.planGuid;
        if (cell.plan.isFavored == 0) {
            cell.plan.isFavored = 1;
            cell.plan.favorNumber += 1;
        } else {
            cell.plan.isFavored = 0;
            cell.plan.favorNumber -= 1;
        }
        __weak typeof(self) weakSelf = self;
        [LCNetRequester favorPlan:planGuid withType:cell.plan.isFavored callBack:^(LCPlanModel *plan, NSError *error){
            if (error) {
                if (cell.plan.isFavored == 0) {
                    cell.plan.isFavored = 1;
                    cell.plan.favorNumber += 1;
                } else {
                    cell.plan.isFavored = 0;
                    cell.plan.favorNumber -= 1;
                }
                [YSAlertUtil tipOneMessage:error.domain];
                [weakSelf updateShow];
            }
            
        }];
        [self updateShow];
        
    }
}

- (void)resetStartDateAndEndDate {
    NSDateFormatter *formatter = [LCDateUtil getUsualDateFormatterToDay];
    if (self.selectedTagDateView == self.tagViewTomorrow) {  //明天
        self.startDate = [LCDateUtil stringFromDate:[LCDateUtil nDaysBeforeDate:-1]];
        self.endDate = [LCDateUtil stringFromDate:[LCDateUtil nDaysBeforeDate:-2]];
    } else if (self.selectedTagDateView == self.tagViewNextWeek) { //下周
        self.startDate =[formatter stringFromDate:[LCDateUtil dateOfFirstDayThisWeek]];
        //= [LCDateUtil stringFromDate:[LCDateUtil nDaysBeforeDate:-1]];
        self.endDate = [formatter stringFromDate:[LCDateUtil nDaysBeforeDate:[LCDateUtil dateOfFirstDayThisWeek] withDays:(-7)]];
    } else if (self.selectedTagDateView == self.tagViewNextMonth) {
        self.startDate = [formatter stringFromDate:[LCDateUtil dateOfFirstDayThisMonth]];
        self.endDate = [formatter stringFromDate:[LCDateUtil dateOfFirstDayNextMonth]];
    }
}

- (void)resetPlanType {
    if (self.selectedTagPlanView == self.tagViewPlanParter) {
        self.planType = 1;
    } else if (self.selectedTagPlanView == self.tagViewPlanLocal) {
        self.planType = 2;
    } else {
        self.planType = 0;
    }
}

#pragma mark - LCCalendarChooseDateView Delegate 

- (void)didSelectedDate:(NSDate *)date {
    self.startDate = [LCDateUtil stringFromDate:date];
    self.endDate = [LCDateUtil stringFromDate:[LCDateUtil nDaysBeforeDate: date withDays:-1]];
    [self.tableView headerBeginRefreshing];
}
//- (void)chooseUpperRightButton:(LCCostPlanCell *)cell {
//    NSInteger index = [self.tableView indexPathForCell:cell].row;
//    if (index != NSNotFound) {
//        if (![self haveLogin]) {
//            [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
//            return ;
//        }
//        
//    }
//}

- (void)drawBackKeyboard {
    [self.searchBar resignFirstResponder];
    [self.view endEditing:YES];
}

#pragma mark - LCDelegateManager Delegate
- (void)updateViewShow {
    [self updateShow];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:self.view];
    if (CGRectContainsPoint(self.tableView.frame, point) && self.searchResult && self.searchResult.count > 0) {
        return NO;
    } else {
        return YES;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}

#pragma mark - UITextField Delegate.
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    self.departName = textField.text;
    [self.tableView headerBeginRefreshing];
}

@end
