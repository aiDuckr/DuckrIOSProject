//
//  LCParticipatedListVC.m
//  LinkCity
//
//  Created by roy on 11/12/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCParticipatedListVC.h"
#import "LCStoryboardManager.h"
#import "LCSlideVC.h"
#import "YSAlertUtil.h"
#import "LCUserApi.h"
#import "LCReceptionDetailVC.h"
#import "LCPartnerDetailVC.h"
#import "LCParticipatedTableCell.h"
#import "MJRefresh.h"
#import "LCChatManager.h"
#import "LCTableView.h"

@interface LCParticipatedListVC ()<LCUserApiDelegate>
@property (nonatomic, assign) BOOL shouldRefreshPlanListOnViewAppear;
@property (nonatomic, strong) NSMutableArray *planList;


@property (weak, nonatomic) IBOutlet LCTableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barMenuButton;
@property (nonatomic, assign) BOOL isPullHeaderAction;

@end

@implementation LCParticipatedListVC

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.shouldRefreshPlanListOnViewAppear = NO;
    
    //设置title
    self.title = @"我的计划";
    //设置菜单按钮
    [self.barMenuButton setTarget:self];
    [self.barMenuButton setAction:@selector(barMenuButtonAction:)];
    UIImage *menuImage = [[UIImage imageNamed:@"NavigationMenuIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.barMenuButton setImage:menuImage];
    //设置tableview
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if ([self.tableView isKindOfClass:[LCTableView class]]) {
        LCTableView *t = (LCTableView *)self.tableView;
        t.tipWhenEmpty = @"还没有参与计划，先去首页逛逛吧!";
        t.tipImageName = @"FavorPlanEmpty";
    }
    //设置上下拉刷新
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    //上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    //主动下拉刷新
    [self.tableView headerBeginRefreshing];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInitData) name:NotificationInitData object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldRefreshPlanList:) name:NotificationShouldRefreshPlanListFromServer object:nil];
    //更新未读消息显示
    [self updateInitData];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.planList){
        [self.tableView reloadData];
    }
    
    if ((YES == [LCDataManager sharedInstance].isClickedMenu)
        || (YES == [LCDataManager sharedInstance].isAutoUpdateMyselfPlanList)
        || (!self.planList&&!self.isFirstTimeViewWillAppear)
        || self.shouldRefreshPlanListOnViewAppear) {
        self.shouldRefreshPlanListOnViewAppear = NO;
        //主动下拉刷新
        [self.tableView headerBeginRefreshing];
        [LCDataManager sharedInstance].isClickedMenu = NO;
        [LCDataManager sharedInstance].isAutoUpdateMyselfPlanList = NO;
    }
}

- (void)viewDidLayoutSubviews{
    if (!self.haveLayoutSubViews) {
        
    }
    [super viewDidLayoutSubviews];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

#pragma mark - Public Interface
+ (UINavigationController *)createInstance{
    return (UINavigationController *)[LCStoryboardManager viewControllerWithFileName:SBNameParticipated identifier:VCIDParticipatedListNavigationVC];
}

- (void)setPlanList:(NSArray *)planList{
    [LCDataManager sharedInstance].participatedPlanList = [NSMutableArray arrayWithArray:planList];
}
- (NSArray *)planList{
    return [LCDataManager sharedInstance].participatedPlanList;
}

- (void)barMenuButtonAction:(id)sender{
    [LCSlideVC showMenu];
}

#pragma mark - Notification Functions
- (void)updateInitData {
    NSInteger menuNumber = [LCChatManager sharedInstance].initialData.unreadChatNum +
                        [LCChatManager sharedInstance].initialData.unreadMsgNum +
                        [[LCChatManager sharedInstance] getTotalUnreadMsgNum];
    if (menuNumber > 0) {
        UIImage *menuImage = [[UIImage imageNamed:@"NavigationMenuRedIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self.barMenuButton setImage:menuImage];
    } else {
        UIImage *menuImage = [[UIImage imageNamed:@"NavigationMenuIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self.barMenuButton setImage:menuImage];
    }
}
- (void)shouldRefreshPlanList:(NSNotification *)notify{
    self.shouldRefreshPlanListOnViewAppear = YES;
}
#pragma mark - MJRefresh
- (void)headerRereshing
{
    self.isPullHeaderAction = YES;
    [self loadPlanFromOrdertime:nil];
}

- (void)footerRereshing
{
    self.isPullHeaderAction = NO;
    if (!self.planList || self.planList.count<=0){
        [self loadPlanFromOrdertime:nil];
    }else{
        LCPlan *lastPlan = [self.planList objectAtIndex:self.planList.count-1];
        [self loadPlanFromOrdertime:lastPlan.orderTime];
    }
}

#pragma mark - UserApiDelegate
- (void)userApi:(LCUserApi *)userApi didGetParticipatedPlanList:(NSArray *)planList withError:(NSError *)error{
    if (error) {
        RLog(@"get participated plan list failed. %@",error);
        [YSAlertUtil tipOneMessage:error.domain delay:TIME_FOR_ERROR_TIP];
    }else{
        if (self.isPullHeaderAction) {
            //上拉刷新
            self.planList = [NSMutableArray arrayWithArray:planList];
        }else{
            //下拉刷新
            if(!planList || planList.count<=0){
                [YSAlertUtil tipOneMessage:@"没有更多了" delay:TIME_FOR_RIGHT_TIP];
            }else{
                [self.planList addObjectsFromArray:planList];
            }
        }
        [self.tableView reloadData];
    }
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.planList.count > indexPath.row) {
        //根据行宽，计算等比例图片高，返回行高
        return (560-403)/2+(tableView.frame.size.width-50)/325*202;
    }else{
        //最后一行，固定高度
        return 36;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.planList || self.planList.count<=0) {
        return 0;
    }else{
        // 每个计划一行，以及一个结束行
        return self.planList.count+1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCParticipatedTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ParticipatedListCell" forIndexPath:indexPath];
    if (self.planList.count > indexPath.row) {
        //计划行
        LCPlan *plan = [self.planList objectAtIndex:indexPath.row];
        [cell showPlan:plan asLastCell:NO asFirstCell:indexPath.row==0];
    }else{
        //结束行
        [cell showPlan:nil asLastCell:YES asFirstCell:NO];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RLog(@"selectRow");
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.planList.count > indexPath.row) {
        [LCViewSwitcher pushToShowDetailOfPlan:[self.planList objectAtIndex:indexPath.row] onNavigationVC:self.navigationController];
    }
}

#pragma mark - InnerFunction
- (void)loadPlanFromOrdertime:(NSString *)orderTime{
    LCUserApi *userApi = [[LCUserApi alloc]initWithDelegate:self];
    [userApi getParticipatedPlanListOfUser:[LCDataManager sharedInstance].userInfo.uuid orderTime:orderTime];
}

#pragma mark - UINavigationDelegate
@end
