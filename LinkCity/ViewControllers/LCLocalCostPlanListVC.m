//
//  LCLocalCostPlanListVC.m
//  LinkCity
//
//  Created by whb on 16/8/5.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCLocalCostPlanListVC.h"
#import "LCCostPlanCell.h"
#import "LCCalendarChooseDateView.h"
#import "LCFilterTagButton.h"
#import "UIImage+Create.h"
#import "LCLocalPlanHeaderSelectedView.h"
#import "LCLocalClosePlanView.h"
#import "LCFilterTagButton.h"

#define TopCalendarFilterViewHeight (100.0f)

@interface LCLocalCostPlanListVC ()<UITableViewDelegate, UITableViewDataSource,LCLocalClosePlanViewDelegate,LCLocalPlanHeaderSelectedViewDelegate,LCFilterTagButtonDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *contentArr;
@property (strong, nonatomic) NSString *orderStr;
@property (strong, nonatomic) NSArray *rcmdTopArr;

@property (strong, nonatomic) NSArray *timeBtnArry;//今天、明天、本周末三个按钮状态

@property (strong, nonatomic) NSArray *dateArr;//选择时间数据
@property (strong, nonatomic) NSArray *priceArr;//价格数据
@property (assign, nonatomic) LCPlanOrderType orderType;//排序数据

@property (assign, nonatomic) float lastHeight;//上次滑动位置

@property(nonatomic) BOOL isOpen;//当前是否展开
@property(nonatomic) BOOL closeToOpen;//当前是否展开

@property (strong, nonatomic) LCLocalPlanHeaderSelectedView *openHeaderView;
@property (strong, nonatomic) LCLocalClosePlanView *closeHeaderView;
@end

@implementation LCLocalCostPlanListVC
+ (instancetype)createInstance {
    return (LCLocalCostPlanListVC *)[LCStoryboardManager viewControllerWithFileName:SBNameLocalTab identifier:VCIDLocalConstPlanListVC];
}

#pragma mark - LifeCycle.
- (void)commonInit {
    [super commonInit];
    
}
-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
    [self initLocaldata];
    [self loadHeaderview];
    [self initTableView];
    [self updateTitle];
    
    if (nil == self.contentArr || 0 == self.contentArr.count) {
        [self.tableView headerBeginRefreshing];
    } else {
        [self headerRefreshAction];
    }
}

- (void)loadHeaderview {
    self.openHeaderView = [LCLocalPlanHeaderSelectedView createInstance];
    self.openHeaderView.delegate=self;
    self.openHeaderView.frame=CGRectMake(0, 0, DEVICE_WIDTH, 100);
    [self.openHeaderView setNeedsLayout];
    
    self.closeHeaderView = [LCLocalClosePlanView createInstance];
    self.closeHeaderView.delegate=self;
    self.closeHeaderView.frame=CGRectMake(0, 0, DEVICE_WIDTH, 50);
    [self.closeHeaderView setNeedsLayout];
}
- (void)initLocaldata {
    LCDataManager *manager = [LCDataManager sharedInstance];
    self.rcmdTopArr = manager.rcmdTopArr;
    self.homeRcmd=[self.rcmdTopArr objectAtIndex:3];
    self.orderStr = @"";
    self.dateArr = [[NSArray alloc] init];
    self.priceArr = [[NSArray alloc] init];
    self.timeBtnArry=[NSArray arrayWithObjects:@"0",@"0",@"0", nil];
    self.isOpen=NO;
    self.closeToOpen=NO;
}
#pragma mark - Common Init.
- (void)initTableView {

    self.tableView.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 180.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.scrollsToTop = YES;
//    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCCostPlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCCostPlanCell class])];
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefreshAction)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefreshAction)];
}

#pragma mark - Common Func.
- (void)updateTitle {
    self.title = self.homeRcmd.title;
}
/// 更新视图.
- (void)updateShow {
    /// 有数据的时候隐藏没有找到相关活动视图.
    [self.tableView reloadData];
}

#pragma makr - Server Request.
/// 下拉刷新.
- (void)headerRefreshAction {
    self.orderStr = @"";
    [self requestContentDatas];
}

/// 上拉加载更多.
- (void)footerRefreshAction {
    [self requestContentDatas];
}

// 从后台获取首页推荐的数据列表.
- (void)requestContentDatas {
    __weak typeof(self) weakSelf = self;
    [LCNetRequester requestThemeCalendar:self.dateArr priceArr:self.priceArr themeID:self.homeRcmd.type OrderType:0 orderStr:self.orderStr withCallBack:^(NSArray *contentArr, NSString *orderStr, NSError *error) {
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
    float height=localFreeHeight-self.lastHeight;
    if(height<50&&height>-50){
    if (!self.closeToOpen&&self.isOpen&&localFreeHeight < 50.0f) {//筛选框缩小
        self.isOpen=NO;
        [self closeSelectedTheme];
        }
    }
    self.lastHeight=localFreeHeight;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

}

#pragma mark - UITableView Delegate.
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(self.isOpen)
        return 100;
    else
        return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(self.closeToOpen) {
        self.closeToOpen=NO;
        return self.openHeaderView;
    }
    else if(self.isOpen){
        return self.openHeaderView;
    }
    else
        return self.closeHeaderView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell;
    LCPlanModel *plan = [self.contentArr objectAtIndex:indexPath.row];
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
        cell = freePlanCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LCPlanModel *plan = [self.contentArr objectAtIndex:indexPath.row];
    [LCViewSwitcher pushToShowPlanDetailVCForPlan:plan recmdUuid:@"" on:self.navigationController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)closeSelectedTheme {//界面滚动，筛选页面缩小
    if([[self.timeBtnArry objectAtIndex:0] isEqualToString:@"1"])
        [self.closeHeaderView.timeTodayButton updateFilterTagButtonApperance:YES];
    if([[self.timeBtnArry objectAtIndex:1] isEqualToString:@"1"])
        [self.closeHeaderView.timeTomorrowButton updateFilterTagButtonApperance:YES];
    if([[self.timeBtnArry objectAtIndex:2] isEqualToString:@"1"])
        [self.closeHeaderView.timeWeekButton updateFilterTagButtonApperance:YES];
    //回到顶
    [self.tableView reloadData];
}

- (void)closeLocalSelectedTheme:(BOOL)isOpen dateArray:(NSArray*)dateArry timeBtnArry:(NSMutableArray*)timeBtnArry {
    self.isOpen=isOpen;
    self.timeBtnArry=timeBtnArry;
    self.dateArr=dateArry;
    if(!isOpen) {//点击筛选按钮
    [self.tableView headerBeginRefreshing];
    }
    else if(isOpen) {//点击展开
        if([[self.timeBtnArry objectAtIndex:0] isEqualToString:@"1"])
            [self.openHeaderView.timeTodayButton updateFilterTagButtonApperance:YES];
        if([[self.timeBtnArry objectAtIndex:1] isEqualToString:@"1"])
            [self.openHeaderView.timeTomorrowButton updateFilterTagButtonApperance:YES];
        if([[self.timeBtnArry objectAtIndex:2] isEqualToString:@"1"])
            [self.openHeaderView.timeWeekButton updateFilterTagButtonApperance:YES];
        self.closeToOpen=YES;
        self.isOpen=YES;
        [self.tableView reloadData];
    }

}

- (void)openLocalSelectedTheme:(NSArray*)dateArry priceArray:(NSArray*)priceArray orderType:(NSInteger)orderType timeBtnArry:(NSMutableArray*)timeBtnArry {//open状态下选择
    self.dateArr=dateArry;
    self.timeBtnArry=timeBtnArry;
    self.priceArr=priceArray;
    self.orderType=orderType;
    [self.tableView headerBeginRefreshing];
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
