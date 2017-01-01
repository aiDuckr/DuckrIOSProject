//
//  LCFavorListVC.m
//  LinkCity
//
//  Created by roy on 11/20/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCFavorListVC.h"
#import "LCFavorTableCell.h"
#import "LCUserApi.h"
#import "YSAlertUtil.h"
#import "LCStoryboardManager.h"
#import "LCSlideVC.h"
#import "LCReceptionDetailVC.h"
#import "LCPartnerDetailVC.h"
#import "MJRefresh.h"
#import "LCChatManager.h"
#import "LCTableView.h"

@interface LCFavorListVC ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,LCUserApiDelegate>

@property (nonatomic, assign) BOOL shouldRefreshPlanListOnViewAppear;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barMenuButton;
@property (weak, nonatomic) IBOutlet UIButton *partnerButton;
@property (weak, nonatomic) IBOutlet UIButton *receptionButton;
@property (weak, nonatomic) IBOutlet UIView *buttonBottomLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonBottomLineLeadingConstraint;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet LCTableView *partnerTableView;
@property (weak, nonatomic) IBOutlet LCTableView *receptionTableView;

@property (nonatomic, strong) NSMutableArray *receptionPlans;
@property (nonatomic, strong) NSMutableArray *partnerPlans;

@property (nonatomic, assign) BOOL isPullHeaderAction;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBarBottomLineHeight;

@end

@implementation LCFavorListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.shouldRefreshPlanListOnViewAppear = NO;
    
    //设置标题
    self.title = @"我的收藏";
    //设置菜单按钮
    [self.barMenuButton setTarget:self];
    [self.barMenuButton setAction:@selector(barMenuButtonAction:)];
    
    UIImage *menuImage = [[UIImage imageNamed:@"NavigationMenuIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.barMenuButton setImage:menuImage];
    //设置tableview
    self.scrollView.delegate = self;
    self.partnerTableView.delegate = self;
    self.partnerTableView.dataSource = self;
    self.partnerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.partnerTableView.tipWhenEmpty = @"还没有收藏计划，看到喜欢的计划就收了它吧!";
    self.partnerTableView.tipImageName = @"FavorPlanEmpty";
    self.receptionTableView.delegate =self;
    self.receptionTableView.dataSource = self;
    self.receptionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.receptionTableView.tipWhenEmpty = @"还没有收藏计划，看到喜欢的计划就收了它吧!";
    self.receptionTableView.tipImageName = @"FavorPlanEmpty";
    
    [self.partnerTableView registerNib:[UINib nibWithNibName:@"LCFavorTableCell" bundle:nil] forCellReuseIdentifier:@"FavorTableCell"];
    [self.receptionTableView registerNib:[UINib nibWithNibName:@"LCFavorTableCell" bundle:nil] forCellReuseIdentifier:@"FavorTableCell"];
    
    //设置上下拉刷新
    [self.partnerTableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    //上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.partnerTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    
    [self.receptionTableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    //上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.receptionTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    //主动下拉刷新
    [self.partnerTableView headerBeginRefreshing];
    [self.receptionTableView headerBeginRefreshing];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInitData) name:NotificationInitData object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldRefreshPlanList:) name:NotificationShouldRefreshPlanListFromServer object:nil];
    //更新未读消息显示
    [self updateInitData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    ZLog(@"scrollView.contentOffset.x is %f", self.scrollView.contentOffset.x);
    if (self.planList) {
        [self setPlanList:self.planList];
        [self.receptionTableView reloadData];
        [self.partnerTableView reloadData];
    }

    if ((YES == [LCDataManager sharedInstance].isClickedMenu)
        || (!self.planList&&!self.isFirstTimeViewWillAppear)
        || self.shouldRefreshPlanListOnViewAppear
        || YES == [LCDataManager sharedInstance].isAutoUpdateFavorPlanList) {
        self.shouldRefreshPlanListOnViewAppear = NO;
        //主动下拉刷新
        [self.partnerTableView headerBeginRefreshing];
        [self.receptionTableView headerBeginRefreshing];
        [LCDataManager sharedInstance].isClickedMenu = NO;
        [LCDataManager sharedInstance].isAutoUpdateFavorPlanList = NO;
    }
}

- (void)viewDidLayoutSubviews{
    if (!self.haveLayoutSubViews) {
        //调整线的高度
        self.tabBarBottomLineHeight.constant = 0.5;
    }
    [super viewDidLayoutSubviews];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(0 != self.scrollView.contentOffset.x) {
        [self animateToReceptionView];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - Public Interfaces
+ (UINavigationController *)createInstance{
    return (UINavigationController *)[LCStoryboardManager viewControllerWithFileName:SBNameFavorList identifier:VCIDFavorListNavigationVC];
}

- (void)setPlanList:(NSArray *)planList{
    [LCDataManager sharedInstance].favorList = [NSMutableArray arrayWithArray:planList];
    
    self.partnerPlans = [[NSMutableArray alloc]initWithCapacity:0];
    self.receptionPlans = [[NSMutableArray alloc]initWithCapacity:0];
    for (LCPlan *p in planList){
        if ([p.planType isEqualToString:PLAN_TYPE_PARNTER_STR] &&
            [p isKindOfClass:[LCPartnerPlan class]]) {
            [self.partnerPlans addObject:p];
        }else if([p.planType isEqualToString:PLAN_TYPE_RECEPTION_STR] &&
                 [p isKindOfClass:[LCReceptionPlan class]]){
            [self.receptionPlans addObject:p];
        }
    }
}
- (NSArray *)planList{
    return [LCDataManager sharedInstance].favorList;
}

- (void)barMenuButtonAction:(id)sender{
    [LCSlideVC showMenu];
}

- (IBAction)partnerButtonClick:(id)sender {
    [self animateToPartnerView];
}
- (IBAction)receptionButtonClick:(id)sender {
    [self animateToReceptionView];
}

#pragma mark - NotificationFuncstions
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
    [self loadFavorListFromOrdertime:nil];
}

- (void)footerRereshing
{
    self.isPullHeaderAction = NO;
    if (!self.planList || self.planList.count<=0){
        [self loadFavorListFromOrdertime:nil];
    }else{
        LCPlan *lastPlan = [self.planList objectAtIndex:self.planList.count-1];
        [self loadFavorListFromOrdertime:lastPlan.orderTime];
    }
}
#pragma mark - LCUserApi Delegate
- (void)userApi:(LCUserApi *)userApi didGetFavorPlanList:(NSArray *)planList withError:(NSError *)error{
    
    if (error) {
        RLog(@"did get favor plan list failed. :%@",error);
        [YSAlertUtil tipOneMessage:error.domain];
    }else{
        RLog(@"did get favor plan list succeed!");
        if (self.isPullHeaderAction) {
            //下拉刷新
            self.planList = planList;
        }else{
            //上拉刷新
            if(!planList || planList.count<=0){
                [YSAlertUtil tipOneMessage:@"没有更多了"];
            }else{
                self.planList = [self.planList arrayByAddingObjectsFromArray:planList];
            }
        }
        [self.partnerTableView reloadData];
        [self.receptionTableView reloadData];
    }
    [self.partnerTableView headerEndRefreshing];
    [self.partnerTableView footerEndRefreshing];
    [self.receptionTableView headerEndRefreshing];
    [self.receptionTableView footerEndRefreshing];
}
#pragma mark - UITableViewDeleate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.partnerTableView) {
        return [self.partnerPlans count];
    }else if(tableView == self.receptionTableView){
        return [self.receptionPlans count];
    }
    
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (tableView.frame.size.width-20)/712*522+24;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LCFavorTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FavorTableCell" forIndexPath:indexPath];
    if (tableView == self.partnerTableView) {
        if (self.partnerPlans.count > indexPath.row) {
            cell.partnerPlan = [self.partnerPlans objectAtIndex:indexPath.row];
        }
    }else if(tableView == self.receptionTableView){
        if (self.receptionPlans.count > indexPath.row) {
            cell.receptionPlan = [self.receptionPlans objectAtIndex:indexPath.row];
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.partnerTableView &&
        self.partnerPlans.count > indexPath.row) {
        [LCViewSwitcher pushToShowDetailOfPlan:[self.partnerPlans objectAtIndex:indexPath.row] onNavigationVC:self.navigationController];
    }else if(tableView == self.receptionTableView &&
             self.receptionPlans.count > indexPath.row){
        [LCViewSwitcher pushToShowDetailOfPlan:[self.receptionPlans objectAtIndex:indexPath.row] onNavigationVC:self.navigationController];
    }
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.scrollView) {
        if (scrollView.contentOffset.x < 50) {
            [self animateToPartnerView];
        }else if(scrollView.contentOffset.x > 50){
            [self animateToReceptionView];
        }
    }
}

#pragma mark - Inner Func
- (void)animateToPartnerView{
    [self.partnerButton setTitleColor:UIColorFromR_G_B_A(72, 67, 63, 1) forState:UIControlStateNormal];
    [self.receptionButton setTitleColor:UIColorFromR_G_B_A(182, 180, 178, 1) forState:UIControlStateNormal];
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, self.scrollView.frame.size.width, 2) animated:YES];
    [UIView animateWithDuration:0.2 animations:^(){
        CGRect frame = self.buttonBottomLine.frame;
        frame.origin.x = 0;
        self.buttonBottomLine.frame = frame;
    }];
}

- (void)animateToReceptionView{
    [self.receptionButton setTitleColor:UIColorFromR_G_B_A(72, 67, 63, 1) forState:UIControlStateNormal];
    [self.partnerButton setTitleColor:UIColorFromR_G_B_A(182, 180, 178, 1) forState:UIControlStateNormal];
    [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, 2) animated:YES];
    [UIView animateWithDuration:0.2 animations:^(){
        CGRect frame = self.buttonBottomLine.frame;
        frame.origin.x = self.scrollView.frame.size.width/2;
        self.buttonBottomLine.frame = frame;
    }];
}

- (void)loadFavorListFromOrdertime:(NSString *)orderTime{
    LCUserApi *userApi = [[LCUserApi alloc]initWithDelegate:self];
    [userApi getFavorPlanListFromOrdertime:orderTime];
}
@end
