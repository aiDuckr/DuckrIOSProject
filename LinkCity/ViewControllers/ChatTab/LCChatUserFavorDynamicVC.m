//
//  LCChatUserFavorDynamicVC.m
//  LinkCity
//
//  Created by godhangyu on 16/6/7.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCChatUserFavorDynamicVC.h"
#import "LCTourpicCell.h"
#import "LCFreePlanCell.h"
#import "LCCostPlanCell.h"

@interface LCChatUserFavorDynamicVC ()<UITableViewDataSource, UITableViewDelegate, LCTourpicCellDelegate>

// Data
@property (nonatomic, strong) NSMutableArray *dynamicArray;
@property (nonatomic, strong) NSString *dynamicOrderStr;


// UI
@property (weak, nonatomic) IBOutlet UITableView *dynamicTableView;

@end

@implementation LCChatUserFavorDynamicVC

+ (instancetype)createInstance {
    return (LCChatUserFavorDynamicVC *)[LCStoryboardManager viewControllerWithFileName:SBNameChatTab identifier:VCIDChatUserFavorDynamicVC];
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavigationBar];
    [self initTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self updateShow];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Common Init

- (void)initNavigationBar {
    self.title = @"我的关注";
}

- (void)initTableView {
    self.dynamicTableView.delegate = self;
    self.dynamicTableView.dataSource = self;
    self.dynamicTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.dynamicTableView.estimatedRowHeight = 180.0f;
    self.dynamicTableView.rowHeight = UITableViewAutomaticDimension;
    [self.dynamicTableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    [self.dynamicTableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    
    [self.dynamicTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCTourpicCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCTourpicCell class])];
    [self.dynamicTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCFreePlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCFreePlanCell class])];
    [self.dynamicTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCCostPlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCCostPlanCell class])];
    
}

- (void)updateShow {
    if (!self.dynamicArray) {
        [self.dynamicTableView headerBeginRefreshing];
    }
    
    [self.dynamicTableView reloadData];
}

#pragma mark - Net

- (void)requestDynamicArrayFromOrderString:(NSString *)orderStr {
    __weak typeof(self) weakSelf = self;
    [LCNetRequester getFavorsDynamic_V_FIVE:self.user.uUID orderStr:orderStr callBack:^(NSArray *contentArray, NSString *orderStr, NSError *error) {
        [weakSelf didGetDynamicArray:contentArray orderStr:orderStr error:error];
        [[LCRedDotHelper sharedInstance] startUpdateRedDot];
    }];
}

- (void)didGetDynamicArray:(NSArray *)contentArray orderStr:(NSString *)orderStr error:(NSError *)error {
    [self.dynamicTableView headerEndRefreshing];
    [self.dynamicTableView footerEndRefreshing];
    if (error) {
        [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
    } else {
        if ([LCStringUtil isNullString:self.dynamicOrderStr]) {
            self.dynamicArray = [NSMutableArray arrayWithArray:contentArray];
        } else {
            if (!contentArray || contentArray.count <= 0) {
                [YSAlertUtil tipOneMessage:LCFooterRefreshEmptyTip yoffset:TipDefaultYoffset delay:TipDefaultDelay];
            } else {
                if (!self.dynamicArray) {
                    self.dynamicArray = [[NSMutableArray alloc] initWithCapacity:0];
                }
                [self.dynamicArray addObjectsFromArray:contentArray];
            }
        }
        self.dynamicOrderStr = orderStr;
        [self updateShow];
    }
}

#pragma mark - Refresh

- (void)refreshData {
    
}

- (void)headerRefreshing {
    self.dynamicOrderStr = nil;
    [self requestDynamicArrayFromOrderString:nil];
}

- (void)footerRefreshing {
    [self requestDynamicArrayFromOrderString:self.dynamicOrderStr];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dynamicArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    id obj = [self.dynamicArray objectAtIndex:indexPath.row];
    
    if ([obj isKindOfClass:[LCTourpic class]]) {
        LCTourpic *tourpic = (LCTourpic *)obj;
        LCTourpicCell *tourpicCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCTourpicCell class]) forIndexPath:indexPath];
        tourpicCell.delegate = self;
        [tourpicCell updateTourpicCell:tourpic withType:LCTourpicCellViewType_Homepage];
        tourpicCell.focusButton.hidden = YES;
        cell = tourpicCell;
    } else if ([obj isKindOfClass:[LCPlanModel class]]) {
        LCPlanModel *plan = (LCPlanModel *)obj;
        if (LCPlanType_CostPlan == plan.routeType || LCPlanType_CostLocal == plan.routeType) {
            LCCostPlanCell *costPlanCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCCostPlanCell class]) forIndexPath:indexPath];
            [costPlanCell updateShowWithPlan:plan];
            costPlanCell.upperRightButton.hidden = YES;
            cell = costPlanCell;
        } else {
            LCFreePlanCell *freePlanCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCFreePlanCell class]) forIndexPath:indexPath];
            if (indexPath.row != ([tableView numberOfRowsInSection:indexPath.section] - 1)) {
                [freePlanCell updateShowWithPlan:plan hideThemeId:0 withSpaInset:YES];
            } else {
                [freePlanCell updateShowWithPlan:plan hideThemeId:0 withSpaInset:NO];
            }
            freePlanCell.delegate = [LCDelegateManager sharedInstance];
            cell = freePlanCell;
        }
    }
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id obj = [self.dynamicArray objectAtIndex:indexPath.row];
    
    if ([obj isKindOfClass:[LCTourpic class]]) {
        LCTourpic *tourpic = [self.dynamicArray objectAtIndex:indexPath.row];
        [LCViewSwitcher pushToShowTourPicDetail:tourpic withType:LCTourpicDetailVCViewType_Normal on:self.navigationController];
    } else if ([obj isKindOfClass:[LCPlanModel class]]) {
        LCPlanModel *plan = (LCPlanModel *)obj;
        [LCViewSwitcher pushToShowPlanDetailVCForPlan:plan recmdUuid:@"" on:self.navigationController];
    }
}

#pragma mark - LCTourpicCell Delegate

- (void)tourpicCommentSelected:(LCTourpicCell *)cell {
    if (![self haveLogin]) {
        [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
        return;
    }
    [LCViewSwitcher pushToShowTourPicDetail:cell.tourpic withType:LCTourpicDetailVCViewType_Comment on:self.navigationController];
}

@end
