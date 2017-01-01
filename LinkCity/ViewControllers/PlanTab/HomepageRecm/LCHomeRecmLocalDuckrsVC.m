//
//  LCHomeRecmLocalDuckrsVC.m
//  LinkCity
//
//  Created by lhr on 16/5/19.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCHomeRecmLocalDuckrsVC.h"
#import "LCHomeUserCell.h"
#import "LCTourpicCell.h"
#import "LCFreePlanCell.h"
#import "LCCostPlanCell.h"
#import "LCDelegateManager.h"

@interface LCHomeRecmLocalDuckrsVC ()<UITableViewDelegate, UITableViewDataSource, LCTabViewDelegate, UIScrollViewDelegate, LCTourpicCellDelegate,LCDelegateManagerDelegate>
@property (nonatomic, strong) LCTabView *tabView;                           //!> 顶部的Tab视图.

@property (weak, nonatomic) IBOutlet UIView *tabBarView;        //!> 顶部的Tab视图的StoryBoard的容器.
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;              //!> 左右滚动视图.
@property (weak, nonatomic) IBOutlet UITableView *userTableView;          //!> 同城达客的上下滚动列表.
@property (weak, nonatomic) IBOutlet UITableView *planTableView;          //!> 达客动态的上下滚动的列表.

//!> 同城达客数据表.
@property (strong, nonatomic) NSArray *userContentArr;
@property (strong, nonatomic) NSArray *planContentArr;                    //!> 达客动态数据表.
@property (strong, nonatomic) NSString *userOrderStr;                     //!> 达客动态排序字符串.
@property (strong, nonatomic) NSString *planOrderStr;                     //!> 同城达客排序字符串.
@end

@implementation LCHomeRecmLocalDuckrsVC

#pragma mark - Public Interface


+ (instancetype)createInstance {
    return (LCHomeRecmLocalDuckrsVC *)[LCStoryboardManager viewControllerWithFileName:SBNamePlanTab identifier:VCIDHomeRecmLocalDuckrsVC];
}

- (void)viewDidLoad {
    //VCIDHomeRecmuserDuckrsVC
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /// 初始化顶部的两个按钮.
    [self initUpperTabbar];
    /// 初始化左右滚动视图.
    [self initScrollView];
    /// 初始化同城达客列表.
    [self inituserTableView];
    /// 初始化在线达客—正在发生列表.
    [self initPlanTableView];
    /// 从后台获取在线达客的内容.
    [self headerRefreshAction];
    [self.userTableView headerBeginRefreshing];
    [self requestPlanDuckrs];
    //[self.planTableView headerBeginRefreshing];
//    [self requestuserDuckrs];
//    /// 从后台获取在线达客—正在发生的内容.
//    [self requestPlanDuckrs];
    //__weak typeof(self) weakSelf = self;
    
//    [LCDelegateManager sharedInstance].updateShowblock =^{
//        [self updateShow];
//    };
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [LCDelegateManager sharedInstance].delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)commonInit {
    [super commonInit];
    self.userOrderStr = @"";
    self.planOrderStr = @"";
}

#pragma mark - Common Init.
/// 初始化顶部的两个按钮.
- (void)initUpperTabbar {
    LCTabView *tabView = [LCTabView createInstance];
    tabView.frame = CGRectMake(0, 0, DEVICE_WIDTH, LCTabViewHeight);
    [tabView updateButtons:@[@"达客", @"动态"] withMargin:0];
    tabView.delegate = self;
    tabView.selectIndex = LCHomeRecmLocalDuckrsType_User;
    self.tabView = tabView;
    [self.tabBarView addSubview:tabView];
}

/// 初始化左右滚动视图.
- (void)initScrollView {
    self.scrollView.delegate = self;
    self.scrollView.scrollsToTop = NO;
}

/// 初始化在线达客列表.
- (void)inituserTableView {
    self.userTableView.delegate = self;
    self.userTableView.dataSource = self;
    self.userTableView.estimatedRowHeight = 180.0f;
    self.userTableView.rowHeight = UITableViewAutomaticDimension;
    self.userTableView.scrollsToTop = YES;
    
    [self.userTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCHomeUserCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCHomeUserCell class])];
    
    [self.userTableView addHeaderWithTarget:self action:@selector(headerRefreshAction)];
    [self.userTableView addFooterWithTarget:self action:@selector(footerRefreshAction)];
}

/// 初始化在线达客—正在发生列表.
- (void)initPlanTableView {
    self.planTableView.delegate = self;
    self.planTableView.dataSource = self;
    self.planTableView.estimatedRowHeight = 180.0f;
    self.planTableView.rowHeight = UITableViewAutomaticDimension;
    self.planTableView.scrollsToTop = YES;
    
    [self.planTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCTourpicCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCTourpicCell class])];
    [self.planTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCFreePlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCFreePlanCell class])];
    [self.planTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCCostPlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCCostPlanCell class])];
    
    [self.planTableView addHeaderWithTarget:self action:@selector(headerRefreshAction)];
    [self.planTableView addFooterWithTarget:self action:@selector(footerRefreshAction)];
}


#pragma mark - Common Func.
/// 获取到新的数据刷新视图.
- (void)updateShow {
    NSInteger index = self.tabView.selectIndex;
    [self.scrollView scrollRectToVisible:CGRectMake(index * DEVICE_WIDTH, 0, DEVICE_WIDTH, self.scrollView.height) animated:NO];
    switch (index) {
        case LCHomeRecmLocalDuckrsType_User:
            [self.userTableView reloadData];
            break;
        case LCHomeRecmLocalDuckrsType_Plan:
            [self.planTableView reloadData];
            break;
    }
}

- (void)refreshData{
    [self.planTableView reloadData];
}


#pragma mark - Server Request.
/// 下拉刷新.
- (void)headerRefreshAction {
    self.userOrderStr = @"";
    self.planOrderStr = @"";
    [self requestContentDatas];
}

/// 上拉加载更多.
- (void)footerRefreshAction {
    [self requestContentDatas];
}

/// 重新请求数据.
- (void)requestContentDatas {
    switch (self.tabView.selectIndex) {
        case LCHomeRecmLocalDuckrsType_User:
            [self requestuserDuckrs];
            break;
        case LCHomeRecmLocalDuckrsType_Plan:
            [self requestPlanDuckrs];
            break;
        default:
            break;
    }
}

/// 从后台获取在线达客数据.
- (void)requestuserDuckrs {
    __weak typeof(self) weakSelf = self;
    [LCNetRequester getHomeRecmLocalDuckrs:self.userOrderStr callBack:^(NSArray *contentArr, NSString *orderStr, NSError *error) {
        [weakSelf.userTableView headerEndRefreshing];
        [weakSelf.userTableView footerEndRefreshing];
        if (!error) {
            if ([LCStringUtil isNullString:weakSelf.userOrderStr]) {
                    if (nil != contentArr && contentArr.count > 0) {
                            weakSelf.userContentArr = [LCUserModel addAndFiltDuplicateStageUserArr:contentArr toOriginalUserArr:nil];
                        } else {
                            [YSAlertUtil tipOneMessage:@"没有同城达客"];
                        }
                    } else {
                        if (nil != contentArr && contentArr.count > 0) {
                            weakSelf.userContentArr = [LCUserModel addAndFiltDuplicateStageUserArr:contentArr toOriginalUserArr:weakSelf.userContentArr];
        
                        } else {
                            [YSAlertUtil tipOneMessage:@"没有更多同城达客"];
                        }
                    }
                    weakSelf.userOrderStr = orderStr;
                    [weakSelf updateShow];
                } else {
                    [YSAlertUtil tipOneMessage:error.domain];
                }


    }];
//    [LCNetRequester getHomeRecmOnlineDuckrs:self.onlineOrderStr callBack:^(NSArray *contentArr, NSString *orderStr, NSError *error) {
//        [self.onlineTableView headerEndRefreshing];
//        [self.onlineTableView footerEndRefreshing];
//        if (!error) {
//            if ([LCStringUtil isNullString:self.onlineOrderStr]) {
//                if (nil != contentArr && contentArr.count > 0) {
//                    self.onlineContentArr = contentArr;
//                } else {
//                    [YSAlertUtil tipOneMessage:@"没有在线达客"];
//                }
//            } else {
//                if (nil != contentArr && contentArr.count > 0) {
//                    NSMutableArray *mutArr = [[NSMutableArray alloc] initWithArray:self.onlineContentArr];
//                    [mutArr addObjectsFromArray:contentArr];
//                    self.onlineContentArr = mutArr;
//                } else {
//                    [YSAlertUtil tipOneMessage:@"没有更多在线达客"];
//                }
//            }
//            self.onlineOrderStr = orderStr;
//            [self updateShow];
//        } else {
//            [YSAlertUtil tipOneMessage:error.domain];
//        }
//    }];
}

/// 从后台获取在线达客—正在发生数据.
- (void)requestPlanDuckrs {
    __weak typeof(self) weakSelf = self;
    NSString *locName = @"";
    if (nil != [LCDataManager sharedInstance].currentCity) {
        locName = [LCDataManager sharedInstance].currentCity.cityName;
    }
    [LCNetRequester getHomeRecmLocalDuckrsPlan:self.planOrderStr localName:locName  callBack:^(NSArray *contentArr, NSString *orderStr, NSError *error) {
        [weakSelf.planTableView headerEndRefreshing];
        [weakSelf.planTableView footerEndRefreshing];
        if (!error) {
            if ([LCStringUtil isNullString:weakSelf.planOrderStr]) {
                if (nil != contentArr && contentArr.count > 0) {
                    weakSelf.planContentArr = [LCSharedFuncUtil addFiltedArrayToArray:nil withUnfiltedArray:contentArr];
                } else {
                    [YSAlertUtil tipOneMessage:@"没有同城达客发布的内容"];
                }
            } else {
                if (nil != contentArr && contentArr.count > 0) {
                    weakSelf.planContentArr = [LCSharedFuncUtil addFiltedArrayToArray:weakSelf.planContentArr withUnfiltedArray:contentArr];
                } else {
                    [YSAlertUtil tipOneMessage:@"没有更多同城达客发布的内容"];
                }
            }
            weakSelf.planOrderStr = orderStr;
            [weakSelf updateShow];
        } else {
            [YSAlertUtil tipOneMessage:error.domain];
        }

    }];
}
#pragma mark - LCTourpicCell Delegate.
/// 旅图点击评论的回调函数.
- (void)tourpicCommentSelected:(LCTourpicCell *)cell {
    if (![self haveLogin]) {
        [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
        return ;
    }
    [LCViewSwitcher pushToShowTourPicDetail:cell.tourpic withType:LCTourpicDetailVCViewType_Comment on:self.navigationController];
}

#pragma mark - LCTabView Delegate.
- (void)tabView:(LCTabView *)tabView didSelectIndex:(NSInteger)index {
    self.tabView.selectIndex = index;
    if (LCHomeRecmLocalDuckrsType_Plan == self.tabView.selectIndex) {
        [MobClick event:V5_HOMEPAGE_LOCAL_DUCKR_HAPPENING_CLICK];
    }
    [self updateShow];
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.scrollView == scrollView) {
        int index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
        [self.tabView setSelectIndex:index];
        [self tabView:self.tabView didSelectIndex:index];
        [self.scrollView setContentOffset:CGPointMake(index * DEVICE_WIDTH, 0.0f) animated:YES];
    }
}

#pragma mark - Configure Cells.
- (UITableViewCell *)configureTourpicPlanUserCell:(id)obj withIndexPath:(NSIndexPath *)indexPath withTableView:(UITableView *)tableView {
//    UITableView *tableView = nil;
//    switch (self.tabView.selectIndex) {
//        case LCHomeRecmLocalDuckrsType_User:
//            tableView = self.userTableView;
//            break;
//        case LCHomeRecmLocalDuckrsType_Plan:
//            tableView = self.planTableView;
//            break;
//    }
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (nil == tableView) {
        return cell;
    }
    if ([obj isKindOfClass:[LCTourpic class]]) {
        LCTourpic *tourpic = (LCTourpic *)obj;
        LCTourpicCell *tourpicCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCTourpicCell class]) forIndexPath:indexPath];
        tourpicCell.delegate = self;
        [tourpicCell updateTourpicCell:tourpic withType:LCTourpicCellViewType_Cell];
        cell = tourpicCell;
    } else if ([obj isKindOfClass:[LCPlanModel class]]) {
        LCPlanModel *plan = (LCPlanModel *)obj;
        if (LCPlanType_CostPlan == plan.routeType || LCPlanType_CostLocal == plan.routeType) {
            LCCostPlanCell *costPlanCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCCostPlanCell class]) forIndexPath:indexPath];
            [costPlanCell updateShowWithPlan:plan];
            cell = costPlanCell;
        } else {
            LCFreePlanCell *freePlanCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCFreePlanCell class]) forIndexPath:indexPath];
            if (indexPath.row != ([tableView numberOfRowsInSection:indexPath.section] - 1))
                [freePlanCell updateShowWithPlan:plan hideThemeId:0 withSpaInset:YES];
            else
                [freePlanCell updateShowWithPlan:plan hideThemeId:0 withSpaInset:NO];
            freePlanCell.delegate = [LCDelegateManager sharedInstance];
            cell = freePlanCell;
        }
    } else if ([obj isKindOfClass:[LCUserModel class]]) {
        LCUserModel *user = (LCUserModel *)obj;
        LCHomeUserCell *homeUserCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCHomeUserCell class]) forIndexPath:indexPath];
        [homeUserCell updateShowCell:user withType:LCHomeUserCellViewType_HomeDuckrLocal];//LCHomeUserCellViewType_HomeRecmOnlineDuckr];
        cell = homeUserCell;
    }
    return cell;
}

#pragma mark - UITableView Delegate.

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger number = 1;
//    if (tableView == self.userTableView) {
//        number =1;
//    } else if (tableView == self.planTableView) {
//        number = self.planContentArr.count;
//    }
    return number;
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger number = 0;
    if (tableView == self.userTableView) {
        number = self.userContentArr.count;
    } else if (tableView == self.planTableView) {
        number = self.planContentArr.count;
    }
    return number;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (tableView == self.planTableView  && section  != 0) {
//        return 12;
//    } else {
//        return 0.1;
//    }
//    //
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    id obj = nil;
    if (tableView == self.userTableView) {
        obj = [self.userContentArr objectAtIndex:indexPath.row];
    } else if (tableView == self.planTableView) {
        obj = [self.planContentArr objectAtIndex:indexPath.row];
    }
    cell = [self configureTourpicPlanUserCell:obj withIndexPath:indexPath withTableView:(UITableView *)tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id obj = nil;
    if (tableView == self.userTableView) {
        obj = [self.userContentArr objectAtIndex:indexPath.row];
    } else if (tableView == self.planTableView) {
        obj = [self.planContentArr objectAtIndex:indexPath.row];
    }
    if ([obj isKindOfClass:[LCTourpic class]]) {
        LCTourpic *tourpic = (LCTourpic *)obj;
        [LCViewSwitcher pushToShowTourPicDetail:tourpic withType:LCTourpicDetailVCViewType_Normal on:self.navigationController];
    } else if ([obj isKindOfClass:[LCPlanModel class]]) {
        LCPlanModel *plan = (LCPlanModel *)obj;
        [LCViewSwitcher pushToShowPlanDetailVCForPlan:plan recmdUuid:@"" on:self.navigationController];
    } else if ([obj isKindOfClass:[LCUserModel class]]) {
        LCUserModel *user = (LCUserModel *)obj;
        [LCViewSwitcher pushToShowUserInfoVCForUser:user on:[LCSharedFuncUtil getTopMostNavigationController]];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - LCDelegateManager Delegate
- (void)updateViewShow {
    [self updateShow];
}
@end
