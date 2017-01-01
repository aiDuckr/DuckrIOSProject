//
//  LCPlaceSearchMorePlanVC.m
//  LinkCity
//
//  Created by 张宗硕 on 12/19/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCPlaceSearchMorePlanVC.h"
#import "LCFreePlanCell.h"
#import "LCCostPlanCell.h"
#import "LCWebPlanCell.h"
#import "LCTabView.h"

@interface LCPlaceSearchMorePlanVC ()<LCTabViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSArray *planArray;
@property (retain, nonatomic) NSString *orderStr;
@property (weak, nonatomic) IBOutlet UIView *topBarView;
@property (assign, nonatomic) LCPlanOrderType type;

@end

@implementation LCPlaceSearchMorePlanVC
+ (instancetype)createInstance {
    return (LCPlaceSearchMorePlanVC *)[LCStoryboardManager viewControllerWithFileName:SBNameSearchResult identifier:VCIDPlaceSearchMorePlanVC];
}

- (id)init {
    self = [super init];
    if (self) {
        self.isDepart = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initVariable];
    [self initTableView];
    [self initUpperTabbar];
     [self addObserveToNotificationNameToRefreshData:URL_FAVOR_PLAN];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initVariable {
    self.type = LCPlanOrderType_Default;
    self.title = [NSString stringWithFormat:@"到%@的更多邀约", self.placeName];
    self.planArray = [[NSArray alloc] init];
    self.orderStr = nil;
}

- (void)initUpperTabbar {
    LCTabView *tabView = [LCTabView createInstance];
    tabView.frame = CGRectMake(0, 0, DEVICE_WIDTH, LCTabViewHeight);
    tabView.delegate = self;
    tabView.selectIndex = 0;
    [tabView updateButtons:@[@"热度排序", @"最近出发", @"最新发布"] withMargin:0];
    [self.topBarView addSubview:tabView];
}

- (void)refreshData {
    [self.tableView headerBeginRefreshing];
}

- (void)updateShow {
    [self.tableView reloadData];
}

- (void)initTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 250.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView addHeaderWithTarget:self action:@selector(tableViewHeaderRereshing) dateKey:@"table"];
    [self.tableView addFooterWithTarget:self action:@selector(tableViewFooterRereshing)];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCFreePlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCFreePlanCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCCostPlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCCostPlanCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCWebPlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCWebPlanCell class])];
}

- (void)tableViewHeaderRereshing {
    self.orderStr = nil;
    [self searchMixPlanByPlaceName];
}

- (void)tableViewFooterRereshing {
    [self searchMixPlanByPlaceName];
}

- (void)searchMixPlanByPlaceName {
    [LCNetRequester searchMixPlanForDestionation:self.placeName orderType:self.type themeId:0 orderString:self.orderStr isDepart:self.isDepart callBack:^(NSArray *typeList, NSArray *planList, LCDestinationPlaceModel *place, NSString *orderString, NSError *error) {
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipDefaultDelay];
        } else {
            if ([LCStringUtil isNullString:self.orderStr]) {
                if (nil != planList) {
                    self.planArray = [LCPlanModel addAndFiltDuplicateStagePlanArr:planList toOriginalPlanArr:nil];
                } else {
                    self.planArray = [[NSArray alloc] init];
                }
            } else {
                if (nil != planList && planList.count > 0) {
                    NSMutableArray *mutArr = [[NSMutableArray alloc] initWithArray:self.planArray];
                    self.planArray = [LCPlanModel addAndFiltDuplicateStagePlanArr:planList toOriginalPlanArr:mutArr];
                } else {
                    [YSAlertUtil tipOneMessage:LCFooterRefreshEmptyTip yoffset:TipDefaultYoffset delay:TipDefaultDelay];
                }
            }
            self.orderStr = orderString;
            [self updateShow];
        }
    }];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.planArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    id plan = [self.planArray objectAtIndex:indexPath.row];
    
    if ([plan isKindOfClass:[LCPlanModel class]]) {
        LCPlanModel *normalPlan = (LCPlanModel *)plan;
        if ([normalPlan isMerchantCostPlan]) {
            LCCostPlanCell *costPlanCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCCostPlanCell class]) forIndexPath:indexPath];
            [costPlanCell updateShowWithPlan:normalPlan];
            cell = costPlanCell;
        } else {
            LCFreePlanCell *freePlanCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCFreePlanCell class]) forIndexPath:indexPath];
            if (indexPath.row != ([tableView numberOfRowsInSection:indexPath.section] - 1))
                [freePlanCell updateShowWithPlan:plan hideThemeId:0 withSpaInset:YES];
            else
                [freePlanCell updateShowWithPlan:plan hideThemeId:0 withSpaInset:NO];
            //[freePlanCell updateShowWithPlan:normalPlan hideThemeId:NoneHideThemeId];
            cell = freePlanCell;
        }
    } else if([plan isKindOfClass:[LCWebPlanModel class]]) {
        LCWebPlanModel *webPlan = (LCWebPlanModel *)plan;
        LCWebPlanCell *planCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCWebPlanCell class]) forIndexPath:indexPath];
        [planCell updateShowWebPlan:webPlan];
        cell = planCell;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id plan = [self.planArray objectAtIndex:indexPath.row];
    if ([plan isKindOfClass:[LCPlanModel class]]) {
        LCPlanModel *normalPlan = (LCPlanModel *)plan;
        [LCViewSwitcher pushToShowPlanDetailVCForPlan:normalPlan recmdUuid:nil on:self.navigationController];
    } else if([plan isKindOfClass:[LCWebPlanModel class]]) {
        LCWebPlanModel *webPlan = (LCWebPlanModel *)plan;
        [LCViewSwitcher pushWebVCtoShowURL:webPlan.planUrl withTitle:webPlan.title on:self.navigationController];
    }
}

#pragma mark - LCTab
#pragma mark LCTabView Delegate
- (void)tabView:(LCTabView *)tabView didSelectIndex:(NSInteger)index {
    if (0 == index){
        self.type = LCPlanOrderType_Default;
        [self refreshData];
    } else if (1 == index) {
        self.type = LCPlanOrderType_DepartTime;
        [self refreshData];
    } else if (2 == index) {
        self.type = LCPlanOrderType_CreateTime;
        [self refreshData];
    }
}
@end
