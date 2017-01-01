//
//  LCLocationPlanTabTourPicVC.m
//  LinkCity
//
//  Created by godhangyu on 16/5/17.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCLocationPlanTabTourPicVC.h"
#import "LCTourpicCell.h"

@interface LCLocationPlanTabTourPicVC ()<UITableViewDataSource, UITableViewDelegate, LCTourpicCellDelegate>

// UI
@property (weak, nonatomic) IBOutlet UITableView *tourpicTableView;

// Data
@property (nonatomic, strong) NSString *orderStr;
@property (nonatomic, strong) NSMutableArray *tourpicInfoArray;

@end

@implementation LCLocationPlanTabTourPicVC

#pragma mark - Public Interface

+ (instancetype)createInstance {
    return (LCLocationPlanTabTourPicVC *)[LCStoryboardManager viewControllerWithFileName:SBNameLocationPlanTab identifier:VCIDLocationPlanTabTourPicVC];
}

#pragma mark - Life Style

- (void)commonInit {
    [super commonInit];
    
    // read data from DataManager
    LCDataManager *manager = [LCDataManager sharedInstance];
    self.tourpicInfoArray = [manager.nearbyTourpicArray mutableCopy];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNavBar];
    [self loadTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupNavBar {
    self.title = @"本地旅图";
}

#pragma mark - TableView

- (void)loadTableView {
    _tourpicTableView.delegate = self;
    _tourpicTableView.dataSource = self;
    _tourpicTableView.rowHeight = UITableViewAutomaticDimension;
    _tourpicTableView.estimatedRowHeight = 100.0f;
    _tourpicTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 20)];
    
    [_tourpicTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCTourpicCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCTourpicCell class])];
    
    [_tourpicTableView addHeaderWithTarget:self action:@selector(tableViewHeaderRefreshing)];
    [_tourpicTableView addFooterWithTarget:self action:@selector(tableViewFooterRefreshing)];
    
    [_tourpicTableView headerBeginRefreshing];
    
    [self requestTourpic:@""];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_tourpicInfoArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (_tourpicInfoArray.count > indexPath.row) {
        LCTourpic *tourpic = [self.tourpicInfoArray objectAtIndex:indexPath.row];
        LCTourpicCell *tourpicCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCTourpicCell class]) forIndexPath:indexPath];
        [tourpicCell updateTourpicCell:tourpic withType:LCTourpicCellViewType_Cell];
        tourpicCell.delegate = self;
        tourpicCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        cell = tourpicCell;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id obj = [self.tourpicInfoArray objectAtIndex:indexPath.row];
    if ([obj isKindOfClass:[LCTourpic class]]) {
        LCTourpic *tourpic = (LCTourpic *)obj;
        [LCViewSwitcher pushToShowTourPicDetail:tourpic withType:LCTourpicDetailVCViewType_Normal on:self.navigationController];
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

#pragma mark - Common Funcs

- (void)requestTourpic:(NSString *)orderStr {
    NSString *locName = @"";
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
    [LCNetRequester getLocationTourpic_V_Five_ByLocationName:locName orderStr:orderStr callBack:^(NSArray *tourpicArray, NSString *orderStr, NSError *error) {
        [weakSelf.tourpicTableView headerEndRefreshing];
        [weakSelf.tourpicTableView footerEndRefreshing];
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
        } else if (nil == tourpicArray || tourpicArray.count == 0) {
            if ([LCStringUtil isNullString:weakOrderStr]) {
                [YSAlertUtil tipOneMessage:@"没有旅图!"];
            } else {
                [YSAlertUtil tipOneMessage:@"没有更多旅图!"];
            }
        }
        if (!weakSelf.tourpicInfoArray) {
            weakSelf.tourpicInfoArray = [[NSMutableArray alloc] init];
        }
        weakSelf.orderStr =orderStr;
        if (isRefresh) {
            [weakSelf.tourpicInfoArray removeAllObjects];
        }
        [weakSelf.tourpicInfoArray addObjectsFromArray:tourpicArray];
        
        [weakSelf updateShow];
    }];
}

- (void)tableViewHeaderRefreshing {
    [self requestTourpic:@""];
}

- (void)tableViewFooterRefreshing {
    [self requestTourpic:_orderStr];
}

- (void)updateShow {
    LCDataManager *manager = [LCDataManager sharedInstance];
    manager.nearbyTourpicArray = self.tourpicInfoArray;
    [self.tourpicTableView reloadData];
}

@end
