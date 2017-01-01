//
//  LCSearchDestinationMoreVC.m
//  LinkCity
//
//  Created by David Chen on 2016/8/17.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCSearchDestinationMoreVC1.h"
#import "LCRoutePlaceModel.h"
#import "LCPlanTableVC.h"
#import "LCRouteThemeModel.h"
#import "LCTourpicTableVC.h"
#import "LCHotPlaceCollectionViewCell.h"
#import "LCPlaceSearchHistoryInfoCell.h"
#import "LCSearchPlaceThemeCell.h"
#import "LCFreePlanCell.h"
#import "LCCostPlanCell.h"
#import "LCMoreVCHeaderLessView.h"
#import "LCMoreVCHeaderThreeLinesView.h"
#import "LCMoreVCHeaderFourLinesView.h"
#import "LCInviteFilterView.h"
#import "LCInviteWithoutThemeFilterView.h"
#import "LCFilterTagButton.h"
#import "LCSharedFuncUtil.h"

#define LCMoreVCHeaderLessViewHeight (50.0f)
#define LCMoreVCHeaderThreeLinesViewheight (150.0f)
#define LCMoreVCHeaderFourLinesViewheight (200.0f)


//@interface LCSearchDestinationMoreVC1 ()<UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate, UIScrollViewDelegate, LCFilterTagButtonDelegate, LCMoreVCHeaderLessViewDelegate, LCMoreVCHeaderThreeLinesViewDelegate, LCMoreVCHeaderFourLinesViewDelegate, LCInviteFilterViewDelegate, LCInviteWithoutThemeFilterViewDelegate, LCSharedFuncUtilForGrayview>

@interface LCSearchDestinationMoreVC1 ()



@property (nonatomic, weak) IBOutlet UIView *topView4Container;
@property (nonatomic, weak) IBOutlet UIView *topView5Container;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topView4ContainerToNavBarConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topView5ContainerToNavBarConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableContainerToNavBarConstraint;





//公用的
@property (retain, nonatomic) LCSearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *hintResultView;
@property (strong, nonatomic) NSArray *contentArr;
@property (retain, nonatomic) NSString *orderStr;

//More Cost
@property (strong, nonatomic) NSArray *hotThemeArr;//页面上的“热门主题”
@property (nonatomic, assign) BOOL isSelectThemeTag;
@property (nonatomic, assign) BOOL isFirstTimeLoading;

@property (strong, nonatomic) NSArray *dateArr;
@property (strong, nonatomic) NSArray *priceArr;
@property (strong, nonatomic) NSArray *themeArr;//???有这吗？
@property (assign, nonatomic) LCPlanOrderType orderType;//不同于orderStr


@property (strong, nonatomic) NSArray *timeBtnArry;//今天、明天、本周末三个按钮状态


@property (assign, nonatomic) float lastHeight;//上次滑动位置
@property(nonatomic) BOOL isOpen;//当前是否展开...
@property(nonatomic) BOOL closeToOpen;//当前是否展开...从关闭的状态变到展开状态。
@property (strong, nonatomic) LCMoreVCHeaderLessView *lessView;
@property (strong, nonatomic) LCMoreVCHeaderThreeLinesView *threeLinesView;
@property (strong, nonatomic) LCMoreVCHeaderFourLinesView *fourLinesView;

//More Free
/*
 SearchText: "酒吧"  // 搜索条件
 Lng: "36.1556"    // 经度
 Lat: "53.4566"    // 纬度
 ThemeId: 0    // 主题ID 0 为全部主题
 Sex: 1    // 性别筛选，1为男，2为女
 OrderType: 0    // 排序类型 热度排序、距离排序、最新发布、最近了发 分别为0，1，2，3    默认为按热度排序
 OrderStr: "123456"    // 排序字符串
 */
@property (nonatomic, strong) KLCPopup *planFilterPopup;
@property (weak, nonatomic) IBOutlet UIButton *filterButton;
@property (assign, nonatomic) NSInteger fitlerThemeId;
@property (assign, nonatomic) UserSex inviteSex;
@property (assign, nonatomic) LCPlanOrderType inviteOrderType;
@end

@implementation LCSearchDestinationMoreVC1
+ (instancetype)createInstance {
//    return (LCSearchDestinationMoreVC1 *)[LCStoryboardManager viewControllerWithFileName:SBNamePlanTab identifier:VCIDSearchDestinationMore1];
    return [[LCSearchDestinationMoreVC1 alloc]init];
}

- (void)commonInit {
    [super commonInit];
    self.hotThemeArr = [LCDataManager sharedInstance].appInitData.hotThemeArr;
    self.dateArr = [[NSArray alloc] init];
    self.priceArr = [[NSArray alloc] init];
    self.themeArr = [[NSArray alloc] init];
    self.orderType = LCPlanOrderType_Default;
    self.orderStr = @"";
    self.contentArr = [[NSArray alloc] init];
    self.timeBtnArry = [NSArray arrayWithObjects:@"0", @"0", @"0", nil];
    self.isOpen = NO;
    self.closeToOpen = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.isSelectThemeTag = [self ifThemeTagIsSelected];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initGestureRecognizer];
    [self initSearchBar];
    [self initHeaderview];
    [self inittableView];
    
    //先从缓存里拿数据
    LCDataManager *manager = [LCDataManager sharedInstance];
    if (_isCost) {
        self.contentArr = manager.homeSearchMoreActiv;
        if (0 == self.contentArr.count) {
            self.isFirstTimeLoading = YES;
        } else {
            self.isFirstTimeLoading = NO;
        }
        
        self.filterButton.hidden = YES;
    } else {
        self.contentArr = manager.homeSearchMoreInvite;
        self.filterButton.hidden = NO;
    }
    [self.tableView reloadData];
    [self.tableView headerBeginRefreshing];
}

#pragma mark inits

- (void)initGestureRecognizer {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction)];
    pan.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:pan];
}

/// 初始化搜索框.
- (void)initSearchBar {
    self.searchBar = [[LCSearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, (DEVICE_WIDTH - 45.0f * 3), 44.0f)];
    self.searchBar.delegate = self;
    [self.searchBar setSearchTextFieldBackgroundColor:UIColorFromRGBA(0xf5f4f2, 1.0)];
    self.searchBar.text = self.searchText;
    
    [self.searchBar setPlaceholder:@"搜索活动主题、名称、地点"];
    self.searchBar.showsCancelButton = NO;
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(45.0f, 0.0f, (DEVICE_WIDTH - 45.0f * 3), 44.0f)];
    [searchView addSubview:self.searchBar];
    self.navigationItem.titleView = searchView;
}

- (void)inittableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //    self.tableView.hidden = YES;
    self.tableView.estimatedRowHeight = 180.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    //    [self.tableView setTableHeaderView:self.lessView];
    
    //付费和免费，两种cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCFreePlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCFreePlanCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCCostPlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCCostPlanCell class])];
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefreshAction)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefreshAction)];
}

- (void)initHeaderview {
    /*
     @property (strong, nonatomic) LCMoreVCHeaderLessView *lessView;
     @property (strong, nonatomic) LCMoreVCHeaderThreeLinesView *threeLinesView;
     @property (strong, nonatomic) LCMoreVCHeaderFourLinesView *fourLinesView;
     */
    self.lessView = [LCMoreVCHeaderLessView createInstance];
    self.lessView.frame = CGRectMake(0, 0, DEVICE_WIDTH, 50);
    self.lessView.delegate = self;
    [self.lessView setNeedsLayout];
    if (self.isSelectThemeTag) {
        [self.topView4Container addSubview:self.lessView];
        self.threeLinesView = [LCMoreVCHeaderThreeLinesView createInstance];
        self.threeLinesView.delegate = self;
        self.threeLinesView.frame = CGRectMake(0, 0, DEVICE_WIDTH, 150);
        [self.threeLinesView setNeedsLayout];
        [self.topView4Container addSubview:self.threeLinesView];
    } else {
        [self.topView5Container addSubview:self.lessView];
        self.fourLinesView = [LCMoreVCHeaderFourLinesView createInstance];
        self.fourLinesView.delegate = self;
        self.fourLinesView.frame = CGRectMake(0, 0, DEVICE_WIDTH, 200);
        [self.fourLinesView setNeedsLayout];
        [self.topView5Container addSubview:self.fourLinesView];
    }

}

#pragma mark 手势

- (void)tapAction {
    [self.searchBar resignFirstResponder];
}

- (void)panAction {
    [self.searchBar resignFirstResponder];
}

- (void)panGestureAction {
    [self.view endEditing:YES];
}



#pragma mark ...
- (BOOL)ifThemeTagIsSelected {
    for (id themeModel in self.hotThemeArr) {
        NSString *themeStr = [(LCRouteThemeModel *)themeModel title];
        if ([self.searchText isEqualToString:themeStr]) {
            return YES;//如果传过来的searchText是个主题，就返回yes
        }
    }
    return NO;
}


- (void)updateShow {
    /// 缓存数据.
    LCDataManager *manager = [LCDataManager sharedInstance];
    if (_isCost) {
        manager.homeSearchMoreActiv = self.contentArr;
    } else {
        manager.homeSearchMoreInvite = self.contentArr;
    }
    [self.tableView reloadData];
}

- (void)showSearchResultView:(NSString *)text {
    self.searchBar.text = text;
    self.searchText = text;
    [self.tableView headerBeginRefreshing];
    self.tableView.hidden = NO;
}

#pragma mark 下拉刷新，上拉加载
- (void)headerRefreshAction {
    self.orderStr = @"";
    [self requestSearchResults];
}

- (void)footerRefreshAction {
    [self requestSearchResults];
}

#pragma mark requestSearchResults 请求数据

- (void)requestSearchResults {
    __weak typeof(self) weakSelf = self;
    if (_isCost) {
        [LCNetRequester requestMoreActiv:self.dateArr priceArr:self.priceArr themeArr:self.themeArr searchText:self.searchText orderType:self.orderType orderStr:self.orderStr withCallBack:^(NSArray *contentArr, NSString *orderStr, NSError *error) {
            [weakSelf.tableView headerEndRefreshing];
            [weakSelf.tableView footerEndRefreshing];
            if (!error) {
                if ([LCStringUtil isNullString:self.orderStr]) {
                    weakSelf.contentArr = [[NSArray alloc] init];
                }
                if (nil != contentArr && contentArr.count > 0) {
                    weakSelf.contentArr = [LCSharedFuncUtil addFiltedArrayToArray:weakSelf.contentArr withUnfiltedArray:contentArr];
                    self.isFirstTimeLoading = NO;
                    [self hideNotFoundPage];
                } else if ([LCStringUtil isNotNullString:weakSelf.orderStr]) {
                    [YSAlertUtil tipOneMessage:@"没有更多活动内容"];
                } else {
                    [self showNotFoundPage];
                }
                weakSelf.orderStr = orderStr;
                [weakSelf updateShow];
            } else {
                [YSAlertUtil tipOneMessage:error.domain];
            }
        }];
        
    } else {
        [LCNetRequester requestMoreInvites:self.orderStr themeId:self.fitlerThemeId sex:self.inviteSex orderType:self.inviteOrderType withCallBack:^(NSArray *contentArr, NSString *orderStr, NSError *error) {
            [weakSelf.tableView headerEndRefreshing];
            [weakSelf.tableView footerEndRefreshing];
            if (!error) {
                if ([LCStringUtil isNullString:self.orderStr]) {
                    weakSelf.contentArr = [[NSArray alloc] init];
                }
                if (nil != contentArr && contentArr.count > 0) {
                    weakSelf.contentArr = [LCSharedFuncUtil addFiltedArrayToArray:weakSelf.contentArr withUnfiltedArray:contentArr];
                    [self hideNotFoundPage];
                } else if ([LCStringUtil isNotNullString:weakSelf.orderStr]) {
                    [YSAlertUtil tipOneMessage:@"没有更多邀约内容"];
                }  else {
                    [self showNotFoundPage];
                    //                    [UIView animateWithDuration:0.5 animations:^{
                    //                        self.filterButton.frame = CGRectMake(DEVICE_WIDTH * 2 - 43 - 15, self.filterButton.frame.origin.y, 43, 43);//显示
                    //                    }];
                }
                weakSelf.orderStr = orderStr;
                [weakSelf updateShow];
            } else {
                [YSAlertUtil tipOneMessage:error.domain];
            }
        }];
    }
}

#pragma mark - UITableView Delegate.
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (self.isFirstTimeLoading) {
//        return 0.0f;
//    }
//    if (_isCost) {
//        if (self.isSelectThemeTag) {
//            if(self.isOpen){
//                return 150;
//            } else {
//                return 50;
//            }
//        } else {
//            if(self.isOpen){
//                return 200;
//            } else {
//                return 50;
//            }
//        }
//    } else {
//        return 0.0f;
//    }
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    /*
//     @property (strong, nonatomic) LCMoreVCHeaderLessView *lessView;
//     @property (strong, nonatomic) LCMoreVCHeaderThreeLinesView *threeLinesView;
//     @property (strong, nonatomic) LCMoreVCHeaderFourLinesView *fourLinesView;
//     */
//    if (_isCost) {
//        if (self.isSelectThemeTag) {
//            if(self.closeToOpen) {
//                self.closeToOpen = NO;
//                return self.threeLinesView;
//            } else if(self.isOpen){
//                return self.threeLinesView;
//            } else {
//                return self.lessView;
//            }
//        } else {
//            if(self.closeToOpen) {
//                self.closeToOpen = NO;
//                return self.fourLinesView;
//            } else if(self.isOpen){
//                return self.fourLinesView;
//            } else {
//                return self.lessView;
//            }
//        }
//    } else {
//        return nil;
//    }
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LCPlanModel *model = [self.contentArr objectAtIndex:indexPath.row];
    [LCViewSwitcher pushToShowPlanDetailVCForPlan:model recmdUuid:@"" on:self.navigationController];
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        [UIView animateWithDuration:0.5 animations:^{
            self.filterButton.frame = CGRectMake(DEVICE_WIDTH, self.filterButton.frame.origin.y, 43, 43);//隐藏
        }];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == self.tableView) {
        [UIView animateWithDuration:0.5 animations:^{
            self.filterButton.frame = CGRectMake(DEVICE_WIDTH - 43 - 15, self.filterButton.frame.origin.y, 43, 43);//显示
        }];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.tableView && !self.isCost) {
        [UIView animateWithDuration:0.5 animations:^{
            self.filterButton.frame = CGRectMake(DEVICE_WIDTH - 43 - 15, self.filterButton.frame.origin.y, 43, 43);//显示
        }];
    }
}

- (void)showLessFor4TopView {
    self.topView4Container.hidden = NO;
    self.topView5Container.hidden = YES;
    self.topView4ContainerToNavBarConstraint.constant = 0;
    self.tableContainerToNavBarConstraint.constant = 50;
}

- (void)showLessFor5TopView {
    self.topView4Container.hidden = YES;
    self.topView5Container.hidden = NO;
    self.topView5ContainerToNavBarConstraint.constant = 0;
    self.tableContainerToNavBarConstraint.constant = 50;
}

- (void)show3For4TopView {
    self.topView4Container.hidden = NO;
    self.topView5Container.hidden = YES;
    self.topView4ContainerToNavBarConstraint.constant = -50;
    self.tableContainerToNavBarConstraint.constant = 150;
}

- (void)show4For5TopView {
    self.topView4Container.hidden = YES;
    self.topView5Container.hidden = NO;
    self.topView5ContainerToNavBarConstraint.constant = -50;
    self.tableContainerToNavBarConstraint.constant = 200;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
//    CGFloat localFreeHeight = 0.0f;
    if (self.isCost) {
        if (self.isSelectThemeTag) {
//            localFreeHeight = LCMoreVCHeaderThreeLinesViewheight - scrollView.contentOffset.y;
            [self showLessFor4TopView];
            
        } else {
//            localFreeHeight = LCMoreVCHeaderFourLinesViewheight - scrollView.contentOffset.y;
            [self showLessFor5TopView];
        }

//        float height = localFreeHeight - self.lastHeight;
//        if(height<50&&height>-50){
//            if (!self.closeToOpen && self.isOpen && localFreeHeight < 50.0f) {//筛选框缩小
//                self.isOpen=NO;
//                [self closeSelectedTheme];
//            }
//        }
//        self.lastHeight=localFreeHeight;
    } else {
        
    }
    /// 手往下，内容往下滚，contentOffset变负.
    if (scrollView == self.tableView && !_isCost) {
        if (self.contentArr.count > 0) {
            [UIView animateWithDuration:0.5 animations:^{
                self.filterButton.frame = CGRectMake(DEVICE_WIDTH * 2, self.filterButton.frame.origin.y, 43, 43);//隐藏
            }];
        }
    }
    
}

- (void)closeSelectedTheme {//界面滚动，筛选页面缩小
    if([[self.timeBtnArry objectAtIndex:0] isEqualToString:@"1"])
        [self.lessView.timeTodayButton updateFilterTagButtonApperance:YES];
    if([[self.timeBtnArry objectAtIndex:1] isEqualToString:@"1"])
        [self.lessView.timeTomorrowButton updateFilterTagButtonApperance:YES];
    if([[self.timeBtnArry objectAtIndex:2] isEqualToString:@"1"])
        [self.lessView.timeWeekButton updateFilterTagButtonApperance:YES];
    //回到顶
    [self.tableView reloadData];
}

#pragma mark - UISearchBar Delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [[LCSharedFuncUtil sharedInstance] removeGrayViewfromSuperview];
    [self showSearchResultView:searchBar.text];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    LCSharedFuncUtil *sharedInstance = [LCSharedFuncUtil sharedInstance];
    sharedInstance.delegate = self;
    UIView *grayView = [sharedInstance getGrayView];
    [self.view addSubview:grayView];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [[LCSharedFuncUtil sharedInstance] removeGrayViewfromSuperview];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
}

#pragma mark LCMoreVCHeaderLessViewDelegate

- (void)sendStateToVCWithHeaderOpened:(BOOL)isOpen dateArray:(NSArray *)dateArry timeBtnArry:(NSMutableArray *)timeBtnArry{
    self.isOpen = isOpen;
    self.timeBtnArry = timeBtnArry;
    self.dateArr = dateArry;
    
    if(isOpen) {//已经选择了时间，点击三个点，展开
        if (_isSelectThemeTag) {
            //三行的
            if([[self.timeBtnArry objectAtIndex:0] isEqualToString:@"1"])
                [self.threeLinesView.timeTodayButton updateFilterTagButtonApperance:YES];
            if([[self.timeBtnArry objectAtIndex:1] isEqualToString:@"1"])
                [self.threeLinesView.timeTomorrowButton updateFilterTagButtonApperance:YES];
            if([[self.timeBtnArry objectAtIndex:2] isEqualToString:@"1"])
                [self.threeLinesView.timeWeekButton updateFilterTagButtonApperance:YES];
            [self show3For4TopView];
            
        } else {
            if([[self.timeBtnArry objectAtIndex:0] isEqualToString:@"1"])
                [self.fourLinesView.timeTodayButton updateFilterTagButtonApperance:YES];
            if([[self.timeBtnArry objectAtIndex:1] isEqualToString:@"1"])
                [self.fourLinesView.timeTomorrowButton updateFilterTagButtonApperance:YES];
            if([[self.timeBtnArry objectAtIndex:2] isEqualToString:@"1"])
                [self.fourLinesView.timeWeekButton updateFilterTagButtonApperance:YES];
            [self show4For5TopView];
        }
        
        self.closeToOpen = YES;
        self.isOpen = YES;
        
        [self.tableView reloadData];
    } else {//仅仅点击了今天、明天等几个筛选按钮。仅仅更新一下状态并刷新就好啦
        [self.tableView headerBeginRefreshing];
    }
}

#pragma mark LCMoreVCHeaderThreeLinesViewDelegate
-(void)sendStateToVCFromThreeLinesViewWithDateArray:(NSArray *)dateArry priceArray:(NSArray *)priceArray orderType:(NSInteger)orderType timeBtnArry:(NSMutableArray *)timeBtnArry{
    self.dateArr = dateArry;
    self.timeBtnArry = timeBtnArry;
    self.priceArr = priceArray;
    self.orderType = orderType;
    [self.tableView headerBeginRefreshing];
}
#pragma mark LCMoreVCHeaderFourLinesViewDelegate
-(void)sendStateToVCFromFourLinesViewWithDateArray:(NSArray *)dateArry priceArray:(NSArray *)priceArray orderType:(NSInteger)orderType timeBtnArry:(NSMutableArray *)timeBtnArry{
    self.dateArr = dateArry;
    self.timeBtnArry = timeBtnArry;
    self.priceArr = priceArray;
    self.orderType = orderType;
    [self.tableView headerBeginRefreshing];
}


- (IBAction)showPlanFilterViewAction:(id)sender {
    static CGFloat centerY = 0;
    
    if (!self.planFilterPopup) {
        if (_isSelectThemeTag) {
            LCInviteWithoutThemeFilterView *planFilterView1 = [LCInviteWithoutThemeFilterView createInstance];
            planFilterView1.delegate = self;
            self.planFilterPopup = [KLCPopup popupWithContentView:planFilterView1
                                                         showType:KLCPopupShowTypeSlideInFromBottom
                                                      dismissType:KLCPopupDismissTypeSlideOutToBottom
                                                         maskType:KLCPopupMaskTypeDimmed
                                         dismissOnBackgroundTouch:YES
                                            dismissOnContentTouch:NO];
            centerY = DEVICE_HEIGHT - [planFilterView1 intrinsicContentSize].height / 2;
        } else {
            LCInviteFilterView *planFilterView2 = [LCInviteFilterView createInstance];
            planFilterView2.delegate = self;
            self.planFilterPopup = [KLCPopup popupWithContentView:planFilterView2
                                                         showType:KLCPopupShowTypeSlideInFromBottom
                                                      dismissType:KLCPopupDismissTypeSlideOutToBottom
                                                         maskType:KLCPopupMaskTypeDimmed
                                         dismissOnBackgroundTouch:YES
                                            dismissOnContentTouch:NO];
            centerY = DEVICE_HEIGHT - [planFilterView2 intrinsicContentSize].height / 2;
        }
    }
    
    [self.planFilterPopup showAtCenter:CGPointMake(DEVICE_WIDTH / 2, centerY) inView:nil];
}

#pragma mark - LCInviteFilterView Delegate.
- (void)inviteFilterViewDidFilter:(LCInviteFilterView *)userFilterView fitlerThemeId:(NSInteger)themeId userSex:(UserSex)sex filtType:(LCPlanOrderType)type {
    [self hideNotFoundPage];
    [self.planFilterPopup dismissPresentingPopup];
    self.inviteSex = sex;
    self.fitlerThemeId = themeId;
    self.inviteOrderType = type;
    [self.tableView headerBeginRefreshing];
    [self.tableView scrollsToTop];
}

- (void)inviteFilterViewDidFilter:(LCInviteWithoutThemeFilterView *)userFilterView userSex:(UserSex)sex filtType:(LCPlanOrderType)type {
    [self hideNotFoundPage];
    [self.planFilterPopup dismissPresentingPopup];
    self.inviteSex = sex;
    self.inviteOrderType = type;
    [self.tableView headerBeginRefreshing];
    [self.tableView scrollsToTop];
}

#pragma mark LCSharedFuncUtilForGrayview
- (void)hideKeyboard {
    [self.searchBar resignFirstResponder];
    [self.view endEditing:YES];
}

#pragma mark 显示和隐藏“未找到结果页面”

- (void)showNotFoundPage {
    self.hintResultView.hidden = NO;
    self.tableView.hidden = YES;
    [UIView animateWithDuration:0.5 animations:^{
        self.filterButton.frame = CGRectMake(DEVICE_WIDTH - 43 - 15, self.filterButton.frame.origin.y, 43, 43);//显示
    }];
}

- (void)hideNotFoundPage {
    self.hintResultView.hidden = YES;
    self.tableView.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
