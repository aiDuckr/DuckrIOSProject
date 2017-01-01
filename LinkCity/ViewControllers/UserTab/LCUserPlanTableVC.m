//
//  LCUserPlanVC.m
//  LinkCity
//
//  Created by roy on 6/5/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCUserPlanTableVC.h"
#import "LCFreePlanCell.h"
#import "LCCostPlanCell.h"

@interface LCUserPlanTableVC ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSString *joinedPlanOrderString;
@property (retain, nonatomic) NSMutableArray *joinedPlanArray;
@end

@implementation LCUserPlanTableVC

+ (instancetype)createInstance{
    return (LCUserPlanTableVC *)[LCStoryboardManager viewControllerWithFileName:SBNameUserTab identifier:VCIDUserPlanTableVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initVariable];
    [self initTableView];
    [self initNotification];
    [self initNavigationBar];
}

- (void)initVariable {
    self.title = @"我的约伴";
}

- (void)initNavigationBar {
    //Add right navigation bar button
    UIImage *addImage = [[UIImage imageNamed:@"AddCommentToUserBtn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    [addButton setTitle:@"发约伴" forState:UIControlStateNormal];
    [addButton setTitleColor:UIColorFromRGBA(LCDarkTextColor, 1) forState:UIControlStateNormal];
    [addButton.titleLabel setFont:[UIFont fontWithName:FONT_LANTINGBLACK size:14]];
    [addButton setImage:addImage forState:UIControlStateNormal];
    [addButton setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    [addButton setTitleEdgeInsets:UIEdgeInsetsMake(2, 0, 0, -5)];
    [addButton addTarget:self action:@selector(sendPlanButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace                                    target:nil action:nil];
    negativeSpacer.width = -10;
    
    self.navigationItem.rightBarButtonItems = @[negativeSpacer,customBarItem];
}

- (void)initTableView {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 250.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView addHeaderWithTarget:self action:@selector(tableViewHeaderRereshing) dateKey:@"table"];
    [self.tableView addFooterWithTarget:self action:@selector(tableViewFooterRereshing)];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCFreePlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCFreePlanCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCCostPlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCCostPlanCell class])];
}

- (void)initNotification {
    [self addObserveToNotificationNameToRefreshData:URL_SEND_PLAN];
    [self addObserveToNotificationNameToRefreshData:URL_JOIN_PLAN];
    [self addObserveToNotificationNameToRefreshData:URL_QUIT_PLAN];
    [self addObserveToNotificationNameToRefreshData:URL_DELETE_PLAN];
    [self addObserveToNotificationNameToRefreshData:URL_FAVOR_PLAN];
    [self addObserveToNotificationNameToRefreshData:URL_UNFAVOR_PLAN];
    [self addObserveToNotificationNameToRefreshData:URL_KICKOFF_USRE_OF_PLAN];
    
    [self addObserveToNotificationNameToRefreshData:URL_PLAN_ORDER_NEW];
    [self addObserveToNotificationNameToRefreshData:URL_PLAN_ORDER_QUERY];
    [self addObserveToNotificationNameToRefreshData:URL_PLAN_ORDER_REFUND];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:NO];
    [self.tabBarController.tabBar setHidden:YES];
    
    [self updateShow];
}

- (void)refreshData {
    [self.tableView headerBeginRefreshing];
}

- (void)updateShow {
    
    [self.tableView reloadData];
}

#pragma mark Server Request
- (void)requestJoinedPlansFromOrderString:(NSString *)orderString{
    self.joinedPlanOrderString = orderString;
    [LCNetRequester getJoinedPlansOfUser:[LCDataManager sharedInstance].userInfo.uUID orderString:orderString callBack:^(NSArray *plans, NSString *orderStr, NSError *error) {
        [self didGetJoinedPlansFromServer:plans orderStr:orderStr withError:error];
    }];
}

- (void)didGetJoinedPlansFromServer:(NSArray *)plans orderStr:(NSString *)orderStr withError:(NSError *)error{
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
    
    if (error) {
        [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipDefaultDelay];
    } else {
        if ([LCStringUtil isNullString:self.joinedPlanOrderString]) {
            //下拉刷新
            self.joinedPlanArray = [LCPlanModel addAndFiltDuplicateStagePlanArr:plans toOriginalPlanArr:nil];
        }else{
            //上拉加载更多
            if (!plans || plans.count<=0) {
                [YSAlertUtil tipOneMessage:LCFooterRefreshEmptyTip yoffset:TipDefaultYoffset delay:TipDefaultDelay];
            }else{
                self.joinedPlanArray = [LCPlanModel addAndFiltDuplicateStagePlanArr:plans toOriginalPlanArr:self.joinedPlanArray];
            }
        }
        self.joinedPlanOrderString = orderStr;
        [self updateShow];
    }
}

#pragma mark Set && Get
- (NSMutableArray *)joinedPlanArray {
    return [LCDataManager sharedInstance].joinedPlanArr;
}

- (void)setJoinedPlanArray:(NSMutableArray *)joinedPlanArray {
    [LCDataManager sharedInstance].joinedPlanArr = joinedPlanArray;
}

#pragma mark Button Action
- (void)sendPlanButtonAction:(id)sender {
    [MobClick event:Mob_PublishPlan];
    
    if ([self haveLogin]) {
        [[LCSendPlanHelper sharedInstance] sendNewPlanWithPlaceName:[LCDataManager sharedInstance].locName];
    }else{
        [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
    }
}


#pragma mark -
#pragma mark MJRefresh
- (void)tableViewHeaderRereshing {
    [self requestJoinedPlansFromOrderString:nil];
}

- (void)tableViewFooterRereshing {
    [self requestJoinedPlansFromOrderString:self.joinedPlanOrderString];
}

#pragma mark UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowNum = 0;
    rowNum = self.joinedPlanArray.count;
    return  rowNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    id plan = [self.joinedPlanArray objectAtIndex:indexPath.row];
    
    if ([plan isKindOfClass:[LCPlanModel class]]) {
        LCPlanModel *normalPlan = (LCPlanModel *)plan;
        if ([normalPlan isMerchantCostPlan]) {
            LCCostPlanCell *costPlanCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCCostPlanCell class]) forIndexPath:indexPath];
            [costPlanCell updateShowWithPlan:normalPlan hideThemeId:NoneHideThemeId];
            cell = costPlanCell;
        } else {
            LCFreePlanCell *freePlanCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCFreePlanCell class]) forIndexPath:indexPath];
            [freePlanCell updateShowWithPlan:normalPlan hideThemeId:NoneHideThemeId];
            cell = freePlanCell;
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id plan = [self.joinedPlanArray objectAtIndex:indexPath.row];
    if ([plan isKindOfClass:[LCPlanModel class]]) {
        LCPlanModel *normalPlan = (LCPlanModel *)plan;
        [LCViewSwitcher pushToShowPlanDetailVCForPlan:normalPlan recmdUuid:nil on:self.navigationController];
    }
}


@end
