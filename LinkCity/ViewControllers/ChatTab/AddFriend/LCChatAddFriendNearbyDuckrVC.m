//
//  LCChatAddFriendNearbyDuckrVC.m
//  LinkCity
//
//  Created by godhangyu on 16/6/6.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCChatAddFriendNearbyDuckrVC.h"
#import "UIImage+Create.h"
#import "LCHomeUserCell.h"

@interface LCChatAddFriendNearbyDuckrVC ()<UITableViewDataSource, UITableViewDelegate>

// UI
@property (weak ,nonatomic) IBOutlet UITableView *nearbyDuckrTableView;

// Data
@property (nonatomic, assign) NSInteger skip;
@property (nonatomic, strong) NSArray *nearbyDuckrUserArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *separateLineHeight;

@end

@implementation LCChatAddFriendNearbyDuckrVC

+ (instancetype)createInstance {
    return (LCChatAddFriendNearbyDuckrVC *)[LCStoryboardManager viewControllerWithFileName:SBNameChatTab identifier:VCIDChatAddFriendNearbyDuckrVC];
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavigationBar];
    [self initTableView];
    if (!self.nearbyDuckrUserArray) {
        [self.nearbyDuckrTableView headerBeginRefreshing];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    
    [self updateShow];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[LCUIConstants sharedInstance].navBarOpaqueImage forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Common Init

- (void)initNavigationBar {
    self.title = @"附近达客";
    self.separateLineHeight.constant = 0.5f;
}

- (void)initTableView {
    self.nearbyDuckrTableView.delegate = self;
    self.nearbyDuckrTableView.dataSource = self;
    self.nearbyDuckrTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.nearbyDuckrTableView.estimatedRowHeight = 80.0f;
    self.nearbyDuckrTableView.rowHeight = UITableViewAutomaticDimension;
    [self.nearbyDuckrTableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    [self.nearbyDuckrTableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    [self.nearbyDuckrTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCHomeUserCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCHomeUserCell class])];
    
}

- (void)updateShow {
    [self.nearbyDuckrTableView reloadData];
}

#pragma mark - Net

- (void)requestNearbyDuckrUserArrayWithSkipNum:(NSInteger)skip {
    __weak typeof(self) weakSelf = self;
    LCUserLocation *location = nil;
    if ([[LCDataManager sharedInstance].userLocation isUserLocationValid]) {
        location = [LCDataManager sharedInstance].userLocation;
    }
    NSString *locName = @"";
    if (nil != [LCDataManager sharedInstance].currentCity) {
        locName = [LCDataManager sharedInstance].currentCity.cityName;
    }
    
    [LCNetRequester getNearbyDuckrByLocation:location skip:skip filterType:LCUserFilterType_All locName:locName callBack:^(NSArray *nativeArray, NSError *error) {
        [self.nearbyDuckrTableView headerEndRefreshing];
        [self.nearbyDuckrTableView footerEndRefreshing];
        if (!error) {
            if (skip == 0) {
                weakSelf.skip = nativeArray.count;
                weakSelf.nearbyDuckrUserArray = [LCSharedFuncUtil addFiltedArrayToArray:nil withUnfiltedArray:nativeArray];
            } else {
                if (!nativeArray || nativeArray.count <= 0) {
                    [YSAlertUtil tipOneMessage:LCFooterRefreshEmptyTip yoffset:TipDefaultYoffset delay:TipDefaultDelay];
                } else {
                    weakSelf.skip += nativeArray.count;
                    weakSelf.nearbyDuckrUserArray = [LCSharedFuncUtil addFiltedArrayToArray:weakSelf.nearbyDuckrUserArray withUnfiltedArray:nativeArray];
                }
            }
            [weakSelf updateShow];
        } else {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipDefaultDelay];
        }
    }];
}

#pragma mark - Refresh

- (void)headerRefreshing {
    [self requestNearbyDuckrUserArrayWithSkipNum:0];
}

- (void)footerRefreshing {
    [self requestNearbyDuckrUserArrayWithSkipNum:self.skip];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.nearbyDuckrUserArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCUserModel *user = [self.nearbyDuckrUserArray objectAtIndex:indexPath.row];
    LCHomeUserCell *userCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCHomeUserCell class]) forIndexPath:indexPath];
    [userCell updateShowCell:user withType:LCHomeUserCellViewType_ChatAddFriendNearbyDuckr];
    return userCell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LCUserModel *user = [self.nearbyDuckrUserArray objectAtIndex:indexPath.row];
    [LCViewSwitcher pushToShowUserInfoVCForUser:user on:self.navigationController];
}

@end
