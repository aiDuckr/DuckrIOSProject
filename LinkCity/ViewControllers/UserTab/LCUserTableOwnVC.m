//
//  LCUserTableOwnVC.m
//  LinkCity
//
//  Created by godhangyu on 16/5/24.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCUserTableOwnVC.h"
#import "LCHomeUserCell.h"
#import "LCTourpicCell.h"
#import "LCFreePlanCell.h"
#import "LCCostPlanCell.h"
#import "LCUserTableSearchVC.h"

@interface LCUserTableOwnVC ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, LCTabViewDelegate, LCTourpicCellDelegate>
//Data
@property (nonatomic, strong) NSMutableArray *userArray;
@property (nonatomic, strong) NSString *userOrderStr;
@property (nonatomic, strong) NSMutableArray *dynamicArray;
@property (nonatomic, strong) NSString *dynamicOrderStr;
@property (assign, nonatomic) NSInteger tabViewIndex;


//UI
@property (nonatomic, strong) LCTabView *tabView;
@property (weak, nonatomic) IBOutlet UIView *tabViewContainer;
@property (weak, nonatomic) IBOutlet UITableView *duckrTableView;
@property (weak, nonatomic) IBOutlet UITableView *dynamicTableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchBarButton;

@end

@implementation LCUserTableOwnVC

+ (instancetype)createInstance{
    return (LCUserTableOwnVC *)[LCStoryboardManager viewControllerWithFileName:SBNameUserTab identifier:VCIDUserTableOwnVC];
}

#pragma mark - Common Init

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addObserveToNotificationNameToRefreshData:URL_FAVOR_USER];
    [self addObserveToNotificationNameToRefreshData:URL_UNFOLLOW_USER];
    [self initNavigationBar];
    [self initTabView];
    [self initTableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    
    [self.navigationController.navigationBar setHidden:NO];
    [self.tabBarController.tabBar setHidden:YES];
    
    [self updateShow];
}

- (void)initNavigationBar {
    if (self.showingType != LCUserTableOwnVCType_FavoredUser) {
        [self.navigationItem setRightBarButtonItem:nil];
    }
}

- (void)initTabView {
    LCTabView *tabView = [LCTabView createInstance];
    tabView.frame = CGRectMake(0, 0, DEVICE_WIDTH, LCTabViewHeight);
    tabView.delegate = self;
    tabView.selectIndex = 0;
    self.tabViewIndex = 0;
    self.tabView = tabView;
    switch (self.showingType) {
        case LCUserTableOwnVCType_FavoredUser:
            self.title = @"我的关注";
            [self.tabView updateButtons:@[@"我的关注",@"动态"] withMargin:0];
            break;
        case LCUserTableOwnVCType_Fans:
            self.title = @"我的粉丝";
            [self.tabView updateButtons:@[@"我的粉丝",@"动态"] withMargin:0];
            break;
        case LCUserTableOwnVCType_Duckr:
            self.title = self.placeName;
            break;
        case LCUserTableOwnVCType_DuckrFavored:
            self.title = @"Ta的关注";
            [self.tabView updateButtons:@[@"Ta的关注",@"动态"] withMargin:0];
            break;
        case LCUserTableOwnVCType_DuckrFans:
            self.title = @"Ta的粉丝";
            [self.tabView updateButtons:@[@"Ta的粉丝",@"动态"] withMargin:0];
            break;
    }
    [self.tabViewContainer addSubview:tabView];
}

- (void)initTableView {
    self.duckrTableView.delegate = self;
    self.duckrTableView.dataSource = self;
    self.duckrTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.duckrTableView.estimatedRowHeight = 180.0f;
    self.duckrTableView.rowHeight = UITableViewAutomaticDimension;
    [self.duckrTableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    [self.duckrTableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    [self.duckrTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCHomeUserCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCHomeUserCell class])];
    
    self.dynamicTableView.delegate = self;
    self.dynamicTableView.dataSource = self;
    self.dynamicTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.dynamicTableView.estimatedRowHeight = 180.0f;
    self.dynamicTableView.rowHeight = UITableViewAutomaticDimension;
    [self.dynamicTableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    [self.dynamicTableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    [self.dynamicTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCTourpicCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCTourpicCell class])];
    [self.dynamicTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCFreePlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCFreePlanCell class])];
    [self.dynamicTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCCostPlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCCostPlanCell class])];
    
}

- (void)updateShow{
    
    if (self.tabViewIndex != self.tabView.selectIndex) {
        self.tabViewIndex = self.tabView.selectIndex;
        [self.scrollView scrollRectToVisible:CGRectMake(self.tabViewIndex * DEVICE_WIDTH, 0, DEVICE_WIDTH, 10) animated:NO];
    }
    
    switch (self.tabView.selectIndex) {
        case 0:
            if (!self.userArray) {
                [self.duckrTableView headerBeginRefreshing];
                return;
            }
            break;
        case 1:
            if (!self.dynamicArray) {
                [self.dynamicTableView headerBeginRefreshing];
                return;
            }
            break;
    }
    
    if (self.tabViewIndex == 0) {
        [self.duckrTableView reloadData];
    }
    if (self.tabViewIndex == 1) {
        [self.dynamicTableView reloadData];
    }
    
    [self.duckrTableView headerEndRefreshing];
    [self.duckrTableView footerEndRefreshing];
    
    [self.dynamicTableView headerEndRefreshing];
    [self.dynamicTableView footerEndRefreshing];
}

#pragma mark - Net
- (void)requestUserArrayFromOrderString:(NSString *)orderStr{
    __weak typeof(self) weakSelf = self;
    switch (self.showingType) {
        case LCUserTableOwnVCType_FavoredUser:{
            [LCNetRequester getFavorsListOfUser_V_FIVE:self.user.uUID orderStr:orderStr callBack:^(NSArray *userArray, NSString *orderStr, NSError *error) {
                [weakSelf didGetUserArray:userArray orderStr:orderStr error:error];
            }];
        }
            break;
        case LCUserTableOwnVCType_Fans:{
            [LCNetRequester getFansListOfUser_V_FIVE:self.user.uUID orderStr:orderStr callBack:^(NSArray *userArray, NSString *orderStr, NSError *error) {
                [weakSelf didGetUserArray:userArray orderStr:orderStr error:error];
            }];
        }
            break;
        case LCUserTableOwnVCType_DuckrFavored: {
            [LCNetRequester getFavorsListOfUser_V_FIVE:self.user.uUID orderStr:orderStr callBack:^(NSArray *userArray, NSString *orderStr, NSError *error) {
                [weakSelf didGetUserArray:userArray orderStr:orderStr error:error];
            }];
        }
            break;
        case LCUserTableOwnVCType_DuckrFans: {
            [LCNetRequester getFansListOfUser_V_FIVE:self.user.uUID orderStr:orderStr callBack:^(NSArray *userArray, NSString *orderStr, NSError *error) {
                [weakSelf didGetUserArray:userArray orderStr:orderStr error:error];
            }];
        }
            break;
        case LCUserTableOwnVCType_Duckr:{
            [LCNetRequester getUserListByPlaceName:self.placeName orderStr:orderStr callBack:^(NSArray *userArray, NSString *orderStr, NSError *error) {
                [weakSelf didGetUserArray:userArray orderStr:orderStr error:error];
            }];
            break;
        }
    }
}

- (void)requestDynamicFromOrderString:(NSString *)orderStr {
    __weak typeof(self) weakSelf = self;
    switch (self.showingType) {
        case LCUserTableOwnVCType_FavoredUser:{
            [LCNetRequester getFavorsDynamic_V_FIVE:self.user.uUID orderStr:orderStr callBack:^(NSArray *contentArray, NSString *orderStr, NSError *error) {
                [weakSelf didGetDynamicArray:contentArray orderStr:orderStr error:error];
            }];
            break;
        }
        case LCUserTableOwnVCType_Fans: {
            [LCNetRequester getFansDynamic_V_FIVE:self.user.uUID orderStr:orderStr callBack:^(NSArray *contentArray, NSString *orderStr, NSError *error) {
                [weakSelf didGetDynamicArray:contentArray orderStr:orderStr error:error];
            }];
            break;
        }
        case LCUserTableOwnVCType_DuckrFavored: {
            [LCNetRequester getFavorsDynamic_V_FIVE:self.user.uUID orderStr:orderStr callBack:^(NSArray *contentArray, NSString *orderStr, NSError *error) {
                [weakSelf didGetDynamicArray:contentArray orderStr:orderStr error:error];
            }];
        }
            break;
        case LCUserTableOwnVCType_DuckrFans: {
            [LCNetRequester getFansDynamic_V_FIVE:self.user.uUID orderStr:orderStr callBack:^(NSArray *contentArray, NSString *orderStr, NSError *error) {
                [weakSelf didGetDynamicArray:contentArray orderStr:orderStr error:error];
            }];
        }
            break;
        case LCUserTableOwnVCType_Duckr:
            break;
    }
}

- (void)didGetUserArray:(NSArray *)userArray orderStr:(NSString *)orderStr error:(NSError *)error{
    
    if (error) {
        [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
    }else{
        if ([LCStringUtil isNullString:self.userOrderStr]) {
            //下拉刷新
            self.userArray = [NSMutableArray arrayWithArray:userArray];
        }else{
            //上拉加载更多
            if (!userArray || userArray.count<=0) {
                [YSAlertUtil tipOneMessage:LCFooterRefreshEmptyTip yoffset:TipDefaultYoffset delay:TipDefaultDelay];
            }else{
                if (!self.userArray) {
                    self.userArray = [[NSMutableArray alloc] initWithCapacity:0];
                }
                [self.userArray addObjectsFromArray:userArray];
            }
        }
        self.userOrderStr = orderStr;
        [self updateShow];
    }
}

- (void)didGetDynamicArray:(NSArray *)contentArray orderStr:(NSString *)orderStr error:(NSError *)error {
    
    if (error) {
        [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
    } else {
        if ([LCStringUtil isNullString:self.dynamicOrderStr]) {
            self.dynamicArray = [NSMutableArray arrayWithArray:contentArray];
        } else {
            if (!contentArray || contentArray.count <= 0) {
                [YSAlertUtil tipOneMessage:LCFooterRefreshEmptyTip yoffset:TipDefaultYoffset delay:TipDefaultDelay];
            } else {
                if (!self.dynamicArray) {
                    self.dynamicArray = [[NSMutableArray alloc] initWithCapacity:0];
                }
                [self.dynamicArray addObjectsFromArray:contentArray];
            }
        }
        self.dynamicOrderStr = orderStr;
        [self updateShow];
    }
}

#pragma mark - Refresh

- (void)refreshData {
    if (self.tabViewIndex == 0) {
        [self.duckrTableView headerBeginRefreshing];
    }
    if (self.tabViewIndex == 1) {
        [self.dynamicTableView headerBeginRefreshing];
    }
}

- (void)headerRefreshing{
    self.userOrderStr = nil;
    self.dynamicOrderStr = nil;
    if (self.tabView.selectIndex == 0) {
        [self requestUserArrayFromOrderString:nil];
    }
    if (self.tabView.selectIndex == 1) {
        [self requestDynamicFromOrderString:nil];
    }
}

- (void)footerRefreshing{
//    if (self.showingType == LCUserTableOwnVCType_FavoredUser) {
//        //如果是我关注的人列表，不支持下拉刷新
//        [self.duckrTableView footerEndRefreshing];
//        [self updateShow];
//    }else{
//        [self requestUserArrayFromOrderString:self.userOrderStr];
//    }
    if (self.tabView.selectIndex == 0) {
        [self requestUserArrayFromOrderString:self.userOrderStr];
    }
    if (self.tabView.selectIndex == 1) {
        [self requestDynamicFromOrderString:self.dynamicOrderStr];
    }
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.duckrTableView]) {
        return self.userArray.count;
    }
    if ([tableView isEqual:self.dynamicTableView]) {
        return self.dynamicArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.duckrTableView]) {
        LCUserModel *user = [self.userArray objectAtIndex:indexPath.row];
        LCHomeUserCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCHomeUserCell class]) forIndexPath:indexPath];
        [cell updateShowCell:user withType:LCHomeUserCellViewType_UserFansFavor];
        return cell;
    }
    if ([tableView isEqual:self.dynamicTableView]) {
        UITableViewCell *cell = nil;
        id obj = [self.dynamicArray objectAtIndex:indexPath.row];
        
        if ([obj isKindOfClass:[LCTourpic class]]) {
            LCTourpic *tourpic = (LCTourpic *)obj;
            LCTourpicCell *tourpicCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCTourpicCell class]) forIndexPath:indexPath];
            tourpicCell.delegate = self;
            [tourpicCell updateTourpicCell:tourpic withType:LCTourpicCellViewType_Homepage];
            cell = tourpicCell;
        } else if ([obj isKindOfClass:[LCPlanModel class]]) {
            LCPlanModel *plan = (LCPlanModel *)obj;
            if (LCPlanType_CostPlan == plan.routeType || LCPlanType_CostLocal == plan.routeType) {
                LCCostPlanCell *costPlanCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCCostPlanCell class]) forIndexPath:indexPath];
                [costPlanCell updateShowWithPlan:plan];
                cell = costPlanCell;
            } else {
                LCFreePlanCell *freePlanCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCFreePlanCell class]) forIndexPath:indexPath];
                if (indexPath.row != ([tableView numberOfRowsInSection:indexPath.section] - 1)) {
                    [freePlanCell updateShowWithPlan:plan hideThemeId:0 withSpaInset:YES];
                } else {
                    [freePlanCell updateShowWithPlan:plan hideThemeId:0 withSpaInset:NO];
                }
                freePlanCell.delegate = [LCDelegateManager sharedInstance];
                cell = freePlanCell;
            }
        }
        
        return cell;
    }
    return nil;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([tableView isEqual:self.duckrTableView]) {
        LCUserModel *user = [self.userArray objectAtIndex:indexPath.row];
        [LCViewSwitcher pushToShowUserInfoVCForUser:user on:self.navigationController];
    }
    if ([tableView isEqual:self.dynamicTableView]) {
        id obj = [self.dynamicArray objectAtIndex:indexPath.row];
        
        if ([obj isKindOfClass:[LCTourpic class]]) {
            LCTourpic *tourpic = [self.dynamicArray objectAtIndex:indexPath.row];
            [LCViewSwitcher pushToShowTourPicDetail:tourpic withType:LCTourpicDetailVCViewType_Normal on:self.navigationController];
        } else if ([obj isKindOfClass:[LCPlanModel class]]) {
            LCPlanModel *plan = (LCPlanModel *)obj;
            [LCViewSwitcher pushToShowPlanDetailVCForPlan:plan recmdUuid:@"" on:self.navigationController];
        }
    }
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.duckrTableView) {
        [self.view endEditing:YES];
    }
}

#pragma mark - LCTourpicCell Delegate

- (void)tourpicCommentSelected:(LCTourpicCell *)cell {
    if (![self haveLogin]) {
        [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
        return;
    }
    [LCViewSwitcher pushToShowTourPicDetail:cell.tourpic withType:LCTourpicDetailVCViewType_Comment on:self.navigationController];
}

#pragma mark - LCTabView Delegate

- (void)tabView:(LCTabView *)tabView didSelectIndex:(NSInteger)index {
    self.tabView.selectIndex = index;
    [self updateShow];
}

#pragma mark - Button Actions

- (IBAction)searchBarButtonAction:(id)sender {
    LCUserTableSearchVC *searchVC = [LCUserTableSearchVC createInstance];
    [self.navigationController pushViewController:searchVC animated:APP_ANIMATION];
}

@end

