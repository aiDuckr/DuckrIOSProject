//
//  LCHomeRecmHotTourpicsVC.m
//  LinkCity
//
//  Created by 张宗硕 on 5/18/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCHomeRecmHotTourpicsVC.h"
#import "LCTourpicCell.h"

@interface LCHomeRecmHotTourpicsVC ()<UITableViewDelegate, UITableViewDataSource, LCTourpicCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *contentArr;
@property (strong, nonatomic) NSString *orderStr;
@property (strong, nonatomic) NSString *locName;

@end

@implementation LCHomeRecmHotTourpicsVC

#pragma mark - Public Interface
+ (instancetype)createInstance {
    return (LCHomeRecmHotTourpicsVC *)[LCStoryboardManager viewControllerWithFileName:SBNamePlanTab identifier:VCIDHomeRecmHotTourpicsVC];
}

#pragma mark - LifeCycle.
- (void)commonInit {
    [super commonInit];
    self.orderStr = @"";
    if (nil != [LCDataManager sharedInstance].currentCity) {
        self.locName = [LCDataManager sharedInstance].currentCity.cityName;
    }
}

#pragma mark - LifeCycle.
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTableView];
    self.contentArr = [LCDataManager sharedInstance].homeRecmTourpicArr;
    if (nil == self.contentArr || 0 == self.contentArr.count) {
        [self.tableView headerBeginRefreshing];
    } else {
        [self headerRefreshAction];
    }
}

- (void)initTableView {
    self.tableView.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 180.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.scrollsToTop = YES;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCTourpicCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCTourpicCell class])];
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefreshAction)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefreshAction)];
}

- (void)updateShow {
    [LCDataManager sharedInstance].homeRecmTourpicArr = self.contentArr;
    [self.tableView reloadData];
}

#pragma makr - Server Request.
/// 下拉刷新.
- (void)headerRefreshAction {
    self.orderStr = @"";
    [self requestHotTourpics];
}

/// 上拉加载更多.
- (void)footerRefreshAction {
    [self requestHotTourpics];
}

- (void)requestHotTourpics {
    [LCNetRequester getHomeRecmHotTourpics:self.orderStr callBack:^(NSArray *contentArr, NSString *orderStr, NSError *error) {
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        if (!error) {
            if ([LCStringUtil isNullString:self.orderStr]) {
                if (nil != contentArr && contentArr.count > 0) {
                    self.contentArr = [LCSharedFuncUtil addFiltedArrayToArray:nil withUnfiltedArray:contentArr];
                } else {
                    [YSAlertUtil tipOneMessage:@"没有热门旅图"];
                }
            } else {
                if (nil != contentArr && contentArr.count > 0) {
                    self.contentArr = [LCSharedFuncUtil addFiltedArrayToArray:self.contentArr withUnfiltedArray:contentArr];
                } else {
                    [YSAlertUtil tipOneMessage:@"没有更多热门旅图"];
                }
            }
            self.orderStr = orderStr;
            [self updateShow];
        } else {
            [YSAlertUtil tipOneMessage:error.domain];
        }
    }];
}

#pragma mark - LCTourpicCell Delegate
- (void)tourpicCommentSelected:(LCTourpicCell *)cell {
    if (![self haveLogin]) {
        [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
        return;
    }
    [LCViewSwitcher pushToShowTourPicDetail:cell.tourpic withType:LCTourpicDetailVCViewType_Comment on:self.navigationController];
}

#pragma mark - UITableView Delegate.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCTourpicCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCTourpicCell class]) forIndexPath:indexPath];
    cell.delegate = self;
    LCTourpic *tourpic = [self.contentArr objectAtIndex:indexPath.row];
    [cell updateTourpicCell:tourpic withType:LCTourpicCellViewType_Cell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LCTourpic *tourpic = [self.contentArr objectAtIndex:indexPath.row];
    [LCViewSwitcher pushToShowTourPicDetail:tourpic withType:LCTourpicDetailVCViewType_Normal on:self.navigationController];
    [tableView deselectRowAtIndexPath:indexPath animated:APP_ANIMATION];
}

@end
