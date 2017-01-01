//
//  LCThemeSearchResultVC.m
//  LinkCity
//
//  Created by roy on 6/4/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCThemeSearchResultVC.h"
#import "LCPlanMiniCell.h"
#import "LCFreePlanCell.h"
#import "LCCostPlanCell.h"
#import "LCWebPlanCell.h"
#import "LCMoreButtonCell.h"
#import "LCPublishNewItemCell.h"

@interface LCThemeSearchResultVC ()<UITableViewDataSource,UITableViewDelegate>
//UI
@property (weak, nonatomic) IBOutlet UITableView *tableView;


//Data
@property (retain, nonatomic) NSMutableArray *planArr;
@property (retain, nonatomic) NSString *planOrderString;
@property (retain, nonatomic) LCRouteThemeModel *theme;

@property (nonatomic, assign) BOOL haveRequestPlanFromServer;
@end

@implementation LCThemeSearchResultVC

+ (instancetype)createInstance {
    return (LCThemeSearchResultVC *)[LCStoryboardManager viewControllerWithFileName:SBNameSearchResult identifier:VCIDThemeSearchResultVC];
}

- (void)commonInit{
    [super commonInit];
    
    self.haveRequestPlanFromServer = NO;
}

- (void)refreshData {
    [self searchPlanByThemeId:@""];
    
    [YSAlertUtil showHudWithHint:nil inView:self.view enableUserInteraction:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addObserveToNotificationNameToRefreshData:URL_JOIN_PLAN];
    [self addObserveToNotificationNameToRefreshData:URL_QUIT_PLAN];
    [self addObserveToNotificationNameToRefreshData:URL_DELETE_PLAN];
    [self addObserveToNotificationNameToRefreshData:URL_SEND_PLAN];
    
    [self addObserveToNotificationNameToRefreshData:URL_PLAN_ORDER_NEW];
    [self addObserveToNotificationNameToRefreshData:URL_PLAN_ORDER_QUERY];
    [self addObserveToNotificationNameToRefreshData:URL_PLAN_ORDER_REFUND];
     [self addObserveToNotificationNameToRefreshData:URL_FAVOR_PLAN];
    
    [self initVariable];
    
    //TableView
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCPlanMiniCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCPlanMiniCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCFreePlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCFreePlanCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCCostPlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCCostPlanCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCWebPlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCWebPlanCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCMoreButtonCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCMoreButtonCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCPublishNewItemCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCPublishNewItemCell class])];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[LCUIConstants sharedInstance].navBarOpaqueImage forBarMetrics:UIBarMetricsDefault];
    
    /// 如果有正在显示的hud，去掉.
    [YSAlertUtil hideHud];
}

- (void)initVariable {
    self.planArr = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    [self updateShow];
}

- (void)updateShow {
    if (nil == self.theme) {
        self.title = self.themeName;
    } else {
        self.title = self.theme.title;
    }
    
    [self.tableView addFooterWithTarget:self action:@selector(tableFooterRereshing)];
    if (self.planArr.count>0 || !self.haveRequestPlanFromServer) {
        [self.tableView hideBlankView];
    }else{
        [self.tableView showBlankViewWithImageName:BlankContentImageA title:@"还没有相关的邀约计划\r\n" marginTop:BlankContentMarginTop];
    }
    
    [self.tableView reloadData];
}

- (void)searchPlanByThemeId:(NSString *)orderStr {
    LCCityModel *city = [LCDataManager sharedInstance].currentCity;
    NSString *locName = @"";
    if (nil != city) {
        locName = city.cityName;
    }
    self.planOrderString = orderStr;
    [LCNetRequester searchMixPlanForTheme:self.themeId
                                  locName:locName
                              orderString:self.planOrderString
                                 callBack:^(NSArray *planList,
                                            LCRouteThemeModel *theme,
                                            NSString *orderString,
                                            NSError *error)
    {
        self.haveRequestPlanFromServer = YES;
        
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        [YSAlertUtil hideHud];
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipDefaultDelay];
        } else {
            if ([LCStringUtil isNullString:self.planOrderString]) {
                /// 下拉刷新.
                self.planArr = [LCPlanModel addAndFiltDuplicateStagePlanArr:planList toOriginalPlanArr:nil];
            } else {
                /// 上拉加载更多.
                if (!planList || planList.count <= 0) {
                    [YSAlertUtil tipOneMessage:LCFooterRefreshEmptyTip yoffset:TipDefaultYoffset delay:TipDefaultDelay];
                } else {
                    self.planArr = [LCPlanModel addAndFiltDuplicateStagePlanArr:planList toOriginalPlanArr:self.planArr];
                }
            }
            self.planOrderString = orderString;
            if (nil != theme) {
                self.theme = theme;
            }
            [self updateShow];
        }
    }];
}

#pragma mark Button Action

#pragma mark UITableView
- (void)tableFooterRereshing {
    [self searchPlanByThemeId:self.planOrderString];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowNum = 0;
    rowNum = self.planArr.count;
    return rowNum;
}

#pragma mark Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    id obj = self.planArr[indexPath.row];
    if ([obj isKindOfClass:[LCPlanModel class]]) {
        LCPlanModel *plan = (LCPlanModel *)obj;
        if ([plan isMerchantCostPlan]) {
            LCCostPlanCell *costPlanCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCCostPlanCell class]) forIndexPath:indexPath];
            [costPlanCell updateShowWithPlan:plan];
            cell = costPlanCell;
        }else{
            LCFreePlanCell *freePlanCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCFreePlanCell class]) forIndexPath:indexPath];
            if (indexPath.row != ([tableView numberOfRowsInSection:indexPath.section] - 1))
                [freePlanCell updateShowWithPlan:plan hideThemeId:0 withSpaInset:YES];
            else
                [freePlanCell updateShowWithPlan:plan hideThemeId:0 withSpaInset:NO];
            cell = freePlanCell;
        }
    } else if ([obj isKindOfClass:[LCWebPlanModel class]]) {
        LCWebPlanCell *webPlanCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCWebPlanCell class]) forIndexPath:indexPath];
        webPlanCell.webPlanModel = (LCWebPlanModel *)obj;
        cell = webPlanCell;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id obj = self.planArr[indexPath.row];
    if ([obj isKindOfClass:[LCPlanModel class]]) {
        [LCViewSwitcher pushToShowPlanDetailVCForPlan:(LCPlanModel *)obj recmdUuid:nil on:self.navigationController];
    }else if([obj isKindOfClass:[LCWebPlanModel class]]) {
        LCWebPlanModel *webPlan = (LCWebPlanModel *)obj;
        [LCViewSwitcher pushWebVCtoShowURL:webPlan.planUrl withTitle:webPlan.title on:self.navigationController];
    }
}



@end
