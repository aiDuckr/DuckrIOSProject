//
//  LCHomePageVC.m
//  LinkCity
//
//  Created by 张宗硕 on 11/8/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCHomePageVC.h"
#import "LCHomePagePlanCell.h"
#import "LCImageUtil.h"
#import "LCHomePageApi.h"
#import "LCDateUtil.h"
#import "LCFilterPlanVC.h"
#import "LCSearchDestinationVC.h"
#import "LCStoryboardManager.h"
#import "LCSlideVC.h"
#import "LCReceptionDetailVC.h"
#import "LCPartnerDetailVC.h"
#import "LCStoryboardManager.h"
#import "LCShareView.h"
#import "UMSocial.h"
#import "MobClickSocialAnalytics.h"
#import "LCShareUtil.h"
#import "LCUserInfoVC.h"
#import "LCViewSwitcher.h"
#import "LCPhoneUtil.h"
#import "LCCommonApi.h"
#import "MJRefresh.h"
#import "LCViewSwitcher.h"
#import "LCChatManager.h"

#define DEFAULT_SEARCH_PLACEHOLDER @"搜索目的地"

@interface LCHomePageVC ()<UITableViewDataSource, UITableViewDelegate, LCShareViewDelegate, LCHomePagePlanCellDelegate, LCCommonApiDelegate, LCHomePageApiDelegate> {
//    NSString *destinationID;    //!< 搜索计划目的地ID.
//    NSString *startTime;        //!< 搜索计划开始时间.
//    NSString *endTime;          //!< 搜索计划结束时间.
//    NSString *planType;         //!< 搜索计划的类型.
//    NSInteger scaleMax;         //!< 搜索计划人数上限.
//    
//    BOOL isSaveFilter;          //!< 是否保存搜索条件.
    UIButton *searchButton;     //!< 导航栏搜索目的地按钮.
}

@property (nonatomic, assign) BOOL shouldRefreshPlanListOnViewAppear;
@property (nonatomic, assign) BOOL isPullHeaderAction;

/// 计划列表控件.
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/// 菜单按钮.
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButtonItem;
/// 筛选按钮.
@property (weak, nonatomic) IBOutlet UIBarButtonItem *filterButtonItem;
/// 分享图层.
@property (strong, nonatomic) LCShareView *shareView;
/// 首页最新计划列表.
@property (nonatomic, retain) NSArray *latestPlanArr;
/// 首页热门计划列表.
@property (nonatomic, retain) NSArray *topPlanArr;
/// 首页推荐计划列表.
@property (nonatomic, retain) NSArray *recommendPlanArr;

@end

@implementation LCHomePageVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /// 初始化成员变量.
    [self initVariable];
    /// 初始化导航栏按钮.
    [self initNavigationButtonItem];
    /// 初始化计划列表控件.
    [self initTableView];
    /// 初始化搜索目的地视图.
    [self initSearchView];
    /// 初始化监听通知.
    [self initNotification];
    /// 自动下拉刷新.
    [self headerRereshing];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    /// 更新列表数据.
    [self refreshTableViewData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    /// 检测是否需要上传通讯录.
    [self checkIfUploadTelephoneList];
}

- (void)setLatestPlanArr:(NSArray *)planList {
    [LCDataManager sharedInstance].latestPlanArr = [NSMutableArray arrayWithArray:planList];
}

- (NSArray *)latestPlanArr {
    return [LCDataManager sharedInstance].latestPlanArr;
}

- (void)setTopPlanArr:(NSArray *)planList {
    [LCDataManager sharedInstance].topPlanArr = [NSMutableArray arrayWithArray:planList];
}

- (NSArray *)topPlanArr {
    return [LCDataManager sharedInstance].topPlanArr;
}

- (void)setRecommendPlanArr:(NSArray *)planList {
    [LCDataManager sharedInstance].recommendPlanArr = [NSMutableArray arrayWithArray:planList];
}

- (NSArray *)recommendPlanArr {
    return [LCDataManager sharedInstance].recommendPlanArr;
}

/// 初始化成员变量.
- (void)initVariable {
//    isSaveFilter = NO;
    self.shouldRefreshPlanListOnViewAppear = NO;
    //标记App 已经启动完成
    [LCDataManager sharedInstance].appFinishLoad = YES;
}

/// 初始化导航栏按钮.
- (void)initNavigationButtonItem {
    /// 使用资源原图片.
    UIImage *menuImage = [[UIImage imageNamed:@"NavigationMenuIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.menuButtonItem setImage:menuImage];
    
    /// 使用资源原图片.
    UIImage *filterImage = [[UIImage imageNamed:@"NavigationFilterIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.filterButtonItem setImage:filterImage];
    
    [self.menuButtonItem setTarget:self];
    [self.menuButtonItem setAction:@selector(menuButtonAction:)];
}

/// 初始化计划列表控件.
- (void)initTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //设置上下拉刷新
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    //上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    self.tableView.sectionHeaderHeight = 0.0f;
}

/// 初始化搜索目的地视图.
- (void)initSearchView {
    searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 9.0f, 200.0, 26.0)];

    searchButton.titleLabel.font = [UIFont fontWithName:APP_CHINESE_FONT size:15.0];
    [searchButton setTitle:DEFAULT_SEARCH_PLACEHOLDER forState:UIControlStateNormal];
    [searchButton setTitleColor:UIColorFromRGBA(APP_NAVIGATION_TITLE_COLOR, 1.0) forState:UIControlStateNormal];
    [searchButton setTitleColor:UIColorFromRGBA(APP_NAVIGATION_TITLE_COLOR, 1.0) forState:UIControlStateSelected];
    
    searchButton.layer.borderColor = [UIColorFromRGBA(APP_COLOR, 1.0) CGColor];
    searchButton.layer.borderWidth = 0.5f;
    searchButton.layer.cornerRadius = 13.0f;
    searchButton.layer.masksToBounds = YES;

    searchButton.backgroundColor = UIColorFromR_G_B_A(255.0f, 253.0f, 240.0f, 1.0f);
    
    [searchButton addTarget:self action:@selector(searchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(15.0f, 0.0f, 200.0, 44.0f)];
    [searchView addSubview:searchButton];
    self.navigationItem.titleView = searchView;
}

/// 初始化监听通知.
- (void)initNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInitData) name:NotificationInitData object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldRefreshPlanList:) name:NotificationShouldRefreshPlanListFromServer object:nil];
}

/// 更新列表数据.
- (void)refreshTableViewData {
    if (self.latestPlanArr) {
        [self.tableView reloadData];
    }
    if ((YES == [LCDataManager sharedInstance].isClickedMenu)
        || [LCDataManager sharedInstance].isAutoScrollToLastestPlan
        || (!self.latestPlanArr && !self.isFirstTimeViewWillAppear)
        || self.shouldRefreshPlanListOnViewAppear) {
        self.shouldRefreshPlanListOnViewAppear = NO;
        [self.tableView headerBeginRefreshing];
        [LCDataManager sharedInstance].isClickedMenu = NO;
    }
}

/// 检测是否需要上传通讯录.
- (void)checkIfUploadTelephoneList {
    if ([LCStringUtil isNotNullString:[LCDataManager sharedInstance].userInfo.cid]) {
        NSDate *date = [LCDataManager sharedInstance].lastUploadConatactDate;
        NSDate *nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
        NSInteger days = [LCDateUtil numberOfDaysFromTwoDate:date withAnotherDate:nowDate];
        if (days >= UPLOAD_CONTACT_MAX_DAYS) {
            [self uploadTelephoneContact];
        }
    }
}

/// 上传通讯录.
- (void)uploadTelephoneContact {
    NSString *cid = [LCDataManager sharedInstance].userInfo.cid;
    if ([LCStringUtil isNullString:cid]) {
        return ;
    }
    NSString *telephone = [LCDataManager sharedInstance].userInfo.telephone;
    NSDictionary *dic = [LCPhoneUtil getTelphoneContactDic:telephone];
    if ([[dic allKeys] containsObject:@"SelfTelephone"]
        && [[dic allKeys] containsObject:@"TelephoneList"]) {
        LCCommonApi *api = [[LCCommonApi alloc] initWithDelegate:self];
        [api uploadTelephoneContact:dic];
    }
}

/// 根据排序时间获取计划列表.
- (void)searchPlanListFromServer:(NSString *)orderTime {
    if ([LCStringUtil isNullString:orderTime]) {
        self.isPullHeaderAction = YES;
    } else {
        self.isPullHeaderAction = NO;
    }
    LCHomePageApi *api = [[LCHomePageApi alloc] init];
    api.delegate = self;
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    [dic setObject:[LCStringUtil getNotNullStr:destinationID] forKey:@"DestinationId"];
//    [dic setObject:[LCStringUtil getNotNullStr:startTime] forKey:@"StartTime"];
//    [dic setObject:[LCStringUtil getNotNullStr:endTime] forKey:@"EndTime"];
//    [dic setObject:planType forKey:@"PlanType"];
//    [dic setObject:[LCStringUtil integerToString:scaleMax] forKey:@"ScaleMax"];
//    [dic setObject:[LCStringUtil getNotNullStr:orderTime] forKey:@"OrderTime"];
    [api searchHomePlanList:orderTime];
}

/// 更新红点显示.
- (void)updateInitData {
    NSInteger menuNumber = [LCChatManager sharedInstance].initialData.unreadChatNum +
                            [LCChatManager sharedInstance].initialData.unreadMsgNum +
                            [[LCChatManager sharedInstance] getTotalUnreadMsgNum];
    if (menuNumber > 0) {
        UIImage *menuImage = [[UIImage imageNamed:@"NavigationMenuRedIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self.menuButtonItem setImage:menuImage];
    } else {
        UIImage *menuImage = [[UIImage imageNamed:@"NavigationMenuIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self.menuButtonItem setImage:menuImage];
    }
}

/// 是否应该刷新计划列表.
- (void)shouldRefreshPlanList:(NSNotification *)notify{
    self.shouldRefreshPlanListOnViewAppear = YES;
}

/// 清除筛选条件.
//- (void)clearFilterConditions {
//    destinationID = @"";
//    startTime = @"";
//    endTime = @"";
//    planType = PLAN_TYPE_ALL_STR;
//    scaleMax = PLAN_MAX_SCALE;
//    [searchButton setTitle:DEFAULT_SEARCH_PLACEHOLDER forState:UIControlStateNormal];
//}

#pragma mark - Actions
/// 搜索目的地.
- (void)searchButtonAction:(id)sender {
    LCSearchDestinationVC *controller = (LCSearchDestinationVC *)[LCStoryboardManager viewControllerWithFileName:SBNamePartnerPlan identifier:VCIDSearchDestination];
    controller.searchType = SEARCH_DESTINATION_HOMEPAGE;
    [self.navigationController pushViewController:controller animated:APP_ANIMATION];
}

/// 筛选计划.
- (IBAction)filterAction:(id)sender {
    LCFilterPlanVC *vc = (LCFilterPlanVC *)[LCStoryboardManager viewControllerWithFileName:SBNameHomePage identifier:VCIDHomePageFilterVC];
    [self.navigationController pushViewController:vc animated:APP_ANIMATION];
}

/// 显示菜单.
- (void)menuButtonAction:(id)sender {
    [LCSlideVC showMenu];
}

/// 出行日期文字加阴影.
- (NSAttributedString *)getTimeLabelAttributedString:(LCPlan *)plan {
    if (nil == plan) {
        return [[NSAttributedString alloc] init];
    }
    NSInteger days = [LCDateUtil numberOfDaysFromTwoStr:plan.startTime withAnotherStr:plan.endTime];
    
    NSMutableAttributedString *timeText = [[NSMutableAttributedString alloc]initWithString:[LCDateUtil getDotDateFromHorizontalLineStr:plan.startTime] attributes:@{NSFontAttributeName:[UIFont fontWithName:FONT_FUTURA size:15]}];
    [timeText appendAttributedString:[[NSAttributedString alloc]initWithString:@" 玩" attributes:@{NSFontAttributeName:[UIFont fontWithName:FONT_LANTINGBLACK size:15]}]];
    [timeText appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%tu",days] attributes:@{NSFontAttributeName:[UIFont fontWithName:FONT_FUTURA size:15]}]];
    [timeText appendAttributedString:[[NSAttributedString alloc]initWithString:@"天" attributes:@{NSFontAttributeName:[UIFont fontWithName:FONT_LANTINGBLACK size:15]}]];
    return timeText;
}

/// 更新界面布局约束条件.
- (void)updateCellConstraint:(LCHomePagePlanCell *)cell {
    NSString *content = cell.declarationLabel.text;
    CGSize size = [content sizeWithAttributes: @{NSFontAttributeName:cell.declarationLabel.font}];
    cell.declarationLabelWidthConstraint.constant = size.width;
    
    if (IS_IPHONE_5_5S || IS_IPHONE_4_4S) {
        cell.destinationLabelHeightConstraint.constant = 14.0f;
    }
    if (IS_IPHONE_6_PLUS) {
        CGFloat width = (DEVICE_WIDTH - 2 * 15.0f - 6 * 40.0f) / 5;
        cell.firstGapWidthConstraint.constant = width;
        cell.secondGapWidthConstraint.constant = width;
        cell.thirdGapWidthConstraint.constant = width;
        cell.fourGapWidthConstraint.constant = width;
        cell.fiveGapWidthConstraint.constant = width;
    }
}

//#pragma mark - LCSearchDestinationVC Delegate
///// 点击顶端的搜索目的地搜索目的地后的回调.
//- (void)searchDestinationFinished:(LCSearchDestinationVC *)destinationVC {
//    [searchButton setTitle:destinationVC.placeInfo.placeName forState:UIControlStateNormal];
//    destinationID = destinationVC.placeInfo.placeID;
//    startTime = @"";
//    endTime = @"";
//    planType = @"";
//    scaleMax = PLAN_MAX_SCALE;
//    isSaveFilter = YES;
//    [self headerRereshing];
//}

#pragma mark - LCFilterPlanVC Delegate
/// 填写完筛选条件后的回调.
//- (void)chooseFilterFinished:(LCFilterPlanVC *)controller {
//    destinationID = [LCStringUtil getNotNullStr:controller.placeID];
//    startTime = [LCStringUtil getNotNullStr:controller.startDate];
//    endTime = [LCStringUtil getNotNullStr:controller.endDate];
//    planType = [LCStringUtil getNotNullStr:controller.planType];
//    scaleMax = controller.scaleMax;
//    isSaveFilter = YES;
//    [searchButton setTitle:DEFAULT_SEARCH_PLACEHOLDER forState:UIControlStateNormal];
//    [self headerRereshing];
//}

#pragma mark - LCHomePageApi Delegate
//- (void)homepageApi:(LCHomePageApi *)api didSearchPlanList:(NSArray *)planList relatePlanList:(NSArray *)relatePlan withError:(NSError *)error {
//    if (error) {
//        if ([LCStringUtil isNotNullString:api.msg]) {
//            [self showHint:api.msg];
//        }
//    } else {
//        if (self.isPullHeaderAction) {
//            /// 下拉刷新.
//            self.planArr = planList;
//            if (self.planArr.count <= 0) {
//                if ([LCStringUtil isNotNullString:api.msg]) {
//                    [self showHint:api.msg];
//                }
//                self.planArr = relatePlan;
//            }
//        } else {
//            /// 上拉加载更多.
//            if(!planList || planList.count <= 0) {
//                [self showHint:@"没有更多了！"];
//            } else {
//                self.planArr = [self.planArr arrayByAddingObjectsFromArray:planList];
//            }
//        }
//        [self.tableView reloadData];
//    }
//    [self.tableView headerEndRefreshing];
//    [self.tableView footerEndRefreshing];
//}

- (void)homepageApi:(LCHomePageApi *)api didSearchHomePlanList:(NSArray *)topList recommendList:(NSArray *)recommendList newPlanList:(NSArray *)planList withError:(NSError *)error {
    if (error) {
        if ([LCStringUtil isNotNullString:error.domain]) {
            [self showHint:error.domain];
        }
    } else {
        if (self.isPullHeaderAction) {
            /// 下拉刷新.
            self.latestPlanArr = planList;
            self.topPlanArr = topList;
            self.recommendPlanArr = recommendList;
//            if (self.planArr.count <= 0) {
//                if ([LCStringUtil isNotNullString:api.msg]) {
//                    [self showHint:api.msg];
//                }
//                self.planArr = relatePlan;
//            }
        } else {
            /// 上拉加载更多.
            if(!planList || planList.count <= 0) {
                [self showHint:@"没有更多了！"];
            } else {
                self.latestPlanArr = [self.latestPlanArr arrayByAddingObjectsFromArray:planList];
            }
        }
        
        [self.tableView reloadData];
    }
    
    if (YES == [LCDataManager sharedInstance].isAutoScrollToLastestPlan) {
        NSUInteger rowCount = [self.tableView numberOfRowsInSection:2];
        if (rowCount > 0) {
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
            [self.tableView scrollToRowAtIndexPath:indexPath
                                  atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
        [LCDataManager sharedInstance].isAutoScrollToLastestPlan = NO;
    }
    
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
}

#pragma mark - MJRefresh
- (void)headerRereshing {
//    if (NO == isSaveFilter) {
//        [self clearFilterConditions];
//    }
//    isSaveFilter = NO;
    [self searchPlanListFromServer:@""];
}

- (void)footerRereshing {
    if (!self.latestPlanArr || self.latestPlanArr.count <= 0) {
        [self searchPlanListFromServer:@""];
    } else {
        LCPlan *lastPlan = [self.latestPlanArr objectAtIndex:self.latestPlanArr.count - 1];
        [self searchPlanListFromServer:lastPlan.orderTime];
    }
}

#pragma mark - LCCommonApi Delegate
- (void)commonApi:(LCCommonApi *)api didUploadTelephoneContactWithError:(NSError *)error {
    if (!error) {
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
        [LCDataManager sharedInstance].lastUploadConatactDate = date;
    }
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = self.latestPlanArr.count;
    if (0 == section) {
        count = self.topPlanArr.count;
    } else if (1 == section) {
        count = self.recommendPlanArr.count;
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = (DEVICE_WIDTH * 18.0f) / 25.0f + 133.0f;
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView  heightForHeaderInSection:(NSInteger)section {
    if (0 == section) {
        if (nil == self.topPlanArr || 0 == self.topPlanArr.count) {
            return 0.0f;
        }
    } else if (1 == section) {
        if (nil == self.recommendPlanArr || 0 == self.recommendPlanArr.count) {
            return 0.0f;
        }
    } else if (2 == section) {
        if (nil == self.latestPlanArr || 0 == self.latestPlanArr.count) {
            return 0.0f;
        }
    }
    return 70 * DEVICE_WIDTH / 750;
}

/*- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = @"最新计划";
    if (0 == section) {
        title = @"热门计划";
    } else if (1 == section) {
        title = @"推荐计划";
    }
    return title;
}*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *planList = [LCDataManager sharedInstance].latestPlanArr;
    if (0 == indexPath.section) {
        planList = self.topPlanArr;
    } else if (1 == indexPath.section) {
        planList = self.recommendPlanArr;
    }
    if (planList.count > indexPath.row) {
        LCPlan *plan = [planList objectAtIndex:indexPath.row];
        [LCViewSwitcher pushToShowDetailOfPlan:plan onNavigationVC:self.navigationController];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, DEVICE_WIDTH, 70 * DEVICE_WIDTH / 750)];
    grayView.backgroundColor = UIColorFromR_G_B_A(244.0f, 241.0f, 238.0f, 1.0f);
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, DEVICE_WIDTH, 70 * DEVICE_WIDTH / 750)];//创建一个视图
    headerView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.95];
    UIView *dotView = [[UIView alloc] initWithFrame:CGRectMake(15.0f, (70 * DEVICE_WIDTH / 750 - 11.0f) / 2.0, 11.0f, 11.0f)];
    dotView.backgroundColor = UIColorFromRGBA(APP_COLOR, 1.0f);
    dotView.layer.cornerRadius = 5.5f;
    dotView.layer.masksToBounds = YES;
    [headerView addSubview:dotView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(34.0f, (70 * DEVICE_WIDTH / 750 - 17.0f) / 2.0, 200.0f, 17.0f)];
    label.font = [UIFont fontWithName:APP_CHINESE_FONT size:15.0];
    label.text = @"最新计划";
    if (0 == section) {
        label.text = @"热门计划";
        if (nil == self.topPlanArr || 0 == self.topPlanArr.count) {
            return grayView;
        }
    } else if (1 == section) {
        label.text = @"推荐计划";
        if (nil == self.recommendPlanArr || 0 == self.recommendPlanArr.count) {
            return grayView;
        }
    } else if (2 == section) {
        if (nil == self.latestPlanArr || 0 == self.latestPlanArr.count) {
            return grayView;
        }
    }
    label.textColor = UIColorFromRGBA(APP_NAVIGATION_TITLE_COLOR, 1.0);
    [headerView addSubview:label];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *planList = self.latestPlanArr;
    if (0 == indexPath.section) {
        planList = self.topPlanArr;
    } else if (1 == indexPath.section) {
        planList = self.recommendPlanArr;
    }
    static NSString *identifier = @"HomePagePlanCell";
    LCHomePagePlanCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [[LCHomePagePlanCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    LCPlan *planInfo = [planList objectAtIndex:indexPath.row];
    cell.plan = planInfo;
    cell.delegate = self;
    cell.controller = self;
    cell.destinationLabel.text = planInfo.destinationName;
    
    /// 封面显示封面主要颜色.
    cell.coverImageView.image = nil;
    cell.coverImageView.backgroundColor = nil;
    cell.coverImageView.backgroundColor = [LCImageUtil getColorFromColorStr:planInfo.coverColor];
    //cell.coverImageView.imageType = AFNImageTypeBlurredShowBlured;
    [cell.coverImageView setImageWithURL:[NSURL URLWithString:planInfo.imageCover]];
    cell.dateLabel.attributedText = [self getTimeLabelAttributedString:cell.plan];
    
    /// 群成员人数和规模.
    cell.planScaleLabel.text = [NSString stringWithFormat:@"%tu/%tu", planInfo.userNum, planInfo.scaleMax];
    cell.fovarLabel.text = [NSString stringWithFormat:@"%tu", planInfo.favorNum];
    cell.forwardLabel.text = [NSString stringWithFormat:@"%tu", planInfo.forwardNum];
    cell.declarationLabel.text = planInfo.declaration;
    if (planInfo.isFavored) {
        [cell.favorButton setImage:[UIImage imageNamed:@"HomePageLikeBtnHL"] forState:UIControlStateNormal];
    } else {
        [cell.favorButton setImage:[UIImage imageNamed:@"HomePageLikeBtn"] forState:UIControlStateNormal];
    }
    if ([PLAN_TYPE_PARNTER_STR isEqualToString:planInfo.planType]) {
        cell.planTypeTextLabel.text = @"约伴群";
        cell.planTypeIconImageView.image = [UIImage imageNamed:@"HomePagePartnerCellIcon"];
    } else if ([PLAN_TYPE_RECEPTION_STR isEqualToString:planInfo.planType]) {
        cell.planTypeTextLabel.text = @"招待群";
        cell.planTypeIconImageView.image = [UIImage imageNamed:@"HomePageReceptionCellIcon"];
    }
    
    UIImage *image = [UIImage imageNamed:@"HomePageEmptySeats"];
    
    for (UIButton *button in cell.avatarImageBtns) {
        [button setImage:image forState:UIControlStateNormal];
        button.hidden = YES;
    }
    
    for (UILabel *label in cell.nameLabels) {
        label.text = @"空座位";
        label.hidden = YES;
    }
    
    if (planInfo.memberList.count > 0) {
        LCUserInfo *userInfo = [planInfo.memberList objectAtIndex:0];
        cell.avatarBtn.imageView.contentMode = UIViewContentModeScaleToFill;
        [cell.avatarBtn setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:userInfo.avatarThumbUrl]];
    }
    
    NSInteger index = 0;
    for (LCUserInfo *user in planInfo.memberList) {
        if (index >= cell.avatarImageBtns.count) {
            break;
        }
        UIButton *button = [cell.avatarImageBtns objectAtIndex:index];
        UILabel *label = [cell.nameLabels objectAtIndex:index];
        button.hidden = NO;
        label.hidden = NO;
        [button setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:user.avatarThumbUrl]];
        label.text = user.nick;
        index++;
    }
    for ( ; index < planInfo.scaleMax && index < 6; ++index) {
        UIButton *button = [cell.avatarImageBtns objectAtIndex:index];
        UILabel *label = [cell.nameLabels objectAtIndex:index];
        button.hidden = NO;
        label.hidden = NO;
    }

    [self updateCellConstraint:cell];
    return cell;
}

#pragma mark - LCHomePagePlanCell Delegate
- (void)shareToSocialNetwork:(LCPlan *)plan {
    if (!self.shareView) {
        self.shareView = [LCShareView createInstance];
        self.shareView.delegate = self;
    }
    self.shareView.plan = plan;
    [LCShareView showShareView:self.shareView onViewController:self forPlan:plan];
}

#pragma mark - LCShareViewDelegate

- (void)shareWeixinAction:(LCPlan *)plan {
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){
        [LCShareUtil shareWeixinAction:plan presentedController:self];
    }];
}

- (void)shareWeixinTimeLineAction:(LCPlan *)plan {
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){
        [LCShareUtil shareWeixinTimeLineAction:plan presentedController:self];
    }];
}

- (void)shareWeiboAction:(LCPlan *)plan {
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){
        [LCShareUtil shareWeiboAction:plan presentedController:self];
    }];
}

- (void)shareRenrenAction:(LCPlan *)plan {
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){
        [LCShareUtil shareRenrenAction:plan presentedController:self];
    }];
}

- (void)shareDuckrAction:(LCPlan *)plan {
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){
        [LCShareUtil shareDuckrAction:plan presentedController:self];
    }];
}

- (void)cancelShareAction {
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){}];
}
@end
