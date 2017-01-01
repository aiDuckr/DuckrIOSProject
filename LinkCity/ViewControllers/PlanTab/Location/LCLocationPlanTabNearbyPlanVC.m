//
//  LCLocationPlanTabNearbyPlanVC.m
//  LinkCity
//
//  Created by godhangyu on 16/5/17.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCLocationPlanTabNearbyPlanVC.h"
#import "LCFreePlanCell.h"
#import "LCCostPlanCell.h"

@interface LCLocationPlanTabNearbyPlanVC ()<UITableViewDataSource, UITableViewDelegate,LCDelegateManagerDelegate>

// UI
@property (weak, nonatomic) IBOutlet UITableView *nearbyPlanTableView;

// Data
@property (nonatomic, strong) NSString *orderStr;
@property (nonatomic, strong) NSMutableArray *nearbyPlanInfoArray;

@end

@implementation LCLocationPlanTabNearbyPlanVC

#pragma mark - Public Interface

+ (instancetype)createInstance {
    return (LCLocationPlanTabNearbyPlanVC *)[LCStoryboardManager viewControllerWithFileName:SBNameLocationPlanTab identifier:VCIDLocationPlanTabNearbyPlanVC];
}

#pragma mark - Life Style

- (void)commonInit {
    [super commonInit];
    
    // read data from DataManager
    LCDataManager *manager = [LCDataManager sharedInstance];
    self.nearbyPlanInfoArray = [manager.nearbyPlanArray mutableCopy];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNavBar];
    [self loadTableView];
     [self addObserveToNotificationNameToRefreshData:URL_FAVOR_PLAN];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [LCDelegateManager sharedInstance].delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupNavBar {
    self.title = @"附近约人";
}

#pragma mark - TableView

- (void)loadTableView {
    _nearbyPlanTableView.delegate = self;
    _nearbyPlanTableView.dataSource = self;
    _nearbyPlanTableView.rowHeight = UITableViewAutomaticDimension;
    _nearbyPlanTableView.estimatedRowHeight = 100.0f;
    _nearbyPlanTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 20)];
    
    [_nearbyPlanTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCFreePlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCFreePlanCell class])];
    [_nearbyPlanTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCCostPlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCCostPlanCell class])];
    
    [_nearbyPlanTableView addHeaderWithTarget:self action:@selector(tableViewHeaderRefreshing)];
    [_nearbyPlanTableView addFooterWithTarget:self action:@selector(tableViewFooterRefreshing)];
    
    [_nearbyPlanTableView headerBeginRefreshing];
    
    // refresh
    [self requestNearbyPlan:@""];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_nearbyPlanInfoArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    if (_nearbyPlanInfoArray.count > indexPath.row) {
        id model = [_nearbyPlanInfoArray objectAtIndex:indexPath.row];
        if ([model isKindOfClass:[LCPlanModel class]]) {
            LCPlanModel *planModel = (LCPlanModel *)model;
            if (planModel.routeType == LCRouteTypeFreePlanSameCity || planModel.routeType == LCRouteTypeFreePlanCommon) {
                if (indexPath.row != ([tableView numberOfRowsInSection:indexPath.section] - 1)){
                    cell = [self configureFreePlanCell:planModel withInset:YES];
                } else {
                    cell = [self configureFreePlanCell:planModel withInset:NO];
                }
            } else {
                cell = [self configureCostPlanCell:planModel];
            }
        }
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id plan = [self.nearbyPlanInfoArray objectAtIndex:indexPath.row];
    if ([plan isKindOfClass:[LCPlanModel class]]) {
        LCPlanModel *normalPlan = (LCPlanModel *)plan;
        [LCViewSwitcher pushToShowPlanDetailVCForPlan:normalPlan recmdUuid:nil on:self.navigationController];
    }
}

- (LCFreePlanCell *)configureFreePlanCell:(LCPlanModel *)model withInset:(BOOL)HaveInset {
    LCFreePlanCell * cell = [self.nearbyPlanTableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCFreePlanCell class])];
    cell.delegate = [LCDelegateManager sharedInstance];
    [cell updateShowWithPlan:model hideThemeId:0 withDistance:YES withSpaInset:HaveInset];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (LCCostPlanCell *)configureCostPlanCell:(LCPlanModel *)model {
    LCCostPlanCell * cell = [self.nearbyPlanTableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCCostPlanCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateShowWithPlan:model];
    return cell;
}

//#pragma mark - Free Plan Delegate
//
//- (void)planLikeSelected:(LCFreePlanCell *)cell {
//    NSInteger index = [self.nearbyPlanTableView indexPathForCell:cell].row;
//    if (index != NSNotFound) {
//        if (![self haveLogin]) {
//            [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
//            return ;
//        }
//        NSString * planGuid = cell.plan.planGuid;
//        if (cell.plan.isFavored == 0) {
//            cell.plan.isFavored = 1;
//            cell.plan.thumbCount += 1;
//        } else {
//            cell.plan.isFavored = 0;
//            cell.plan.thumbCount -= 1;
//        }
//        __weak typeof(self) weakSelf = self;
//        [LCNetRequester favorPlan:planGuid withType:cell.plan.isFavored callBack:^(LCPlanModel *plan, NSError *error){
//            if (error) {
//                if (cell.plan.isFavored == 0) {
//                    cell.plan.isFavored = 1;
//                    cell.plan.thumbCount += 1;
//                } else {
//                    cell.plan.isFavored = 0;
//                    cell.plan.thumbCount -= 1;
//                }
//                [YSAlertUtil tipOneMessage:error.domain];
//                [weakSelf updateShow];
//            }
//            
//        }];
//        [self updateShow];
//        
//    }
//}

- (void)planCommentSelected:(LCFreePlanCell *)cell {
    if (![self haveLogin]) {
        [[LCRegisterAndLoginHelper sharedInstance] startLoginWithDelegate:nil];
    }
    [LCViewSwitcher pushToShowPlanDetailVCForPlan:cell.plan recmdUuid:nil on:self.navigationController];
}


#pragma mark - Common Funcs

- (void)requestNearbyPlan:(NSString *)orderStr {
    NSString *locName;
    if (nil != [LCDataManager sharedInstance].currentCity) {
        locName = [LCDataManager sharedInstance].currentCity.cityName;
    }
    BOOL isRefresh;
    if ([LCStringUtil isNullString:orderStr]) {
        isRefresh = YES;
    } else {
        isRefresh = NO;
    }
    __weak typeof(self) weakSelf = self;
    __weak typeof(orderStr) weakOrderStr = orderStr;
    [LCNetRequester getLocationNearbyPlan_V_Five_ByLocationName:locName location:[LCDataManager sharedInstance].userLocation orderStr:orderStr callBack:^(NSArray *planArray, NSString *orderStr, NSError *error) {
        [weakSelf.nearbyPlanTableView headerEndRefreshing];
        [weakSelf.nearbyPlanTableView footerEndRefreshing];
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
            return;
        } else if (nil == planArray || planArray.count == 0){
            if ([LCStringUtil isNullString:weakOrderStr]) {
                [YSAlertUtil tipOneMessage:@"没有活动!"];
            } else {
                [YSAlertUtil tipOneMessage:@"没有更多活动!"];
            }
        }
        if (!weakSelf.nearbyPlanInfoArray) {
            weakSelf.nearbyPlanInfoArray = [[NSMutableArray alloc] init];
        }
        weakSelf.orderStr = orderStr;
        if (isRefresh) {
            [weakSelf.nearbyPlanInfoArray removeAllObjects];
        }
        [weakSelf.nearbyPlanInfoArray addObjectsFromArray:planArray];
        
        [weakSelf updateShow];
    }];
    
}

- (void)tableViewHeaderRefreshing {
    [self requestNearbyPlan:@""];
}

- (void)tableViewFooterRefreshing {
    [self requestNearbyPlan:_orderStr];
}

- (void)updateShow {
    LCDataManager *manager = [LCDataManager sharedInstance];
    manager.nearbyPlanArray = self.nearbyPlanInfoArray;
    [self.nearbyPlanTableView reloadData];
}

- (void)refreshData {
    [self.nearbyPlanTableView reloadData];
}

#pragma mark - LCDelegateManager Delegate
- (void)updateViewShow {
    [self updateShow];
}
@end
