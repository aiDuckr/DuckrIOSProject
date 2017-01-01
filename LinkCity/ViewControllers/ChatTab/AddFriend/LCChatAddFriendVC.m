//
//  LCChatAddFriendVC.m
//  LinkCity
//
//  Created by godhangyu on 16/6/3.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCChatAddFriendVC.h"
#import "LCHomeUserCell.h"
#import "LCChatAddFriendSearchVC.h"
#import "LCChatAddFriendNearbyDuckrVC.h"
//#import "LCContactListVC.h"
#import "UIImage+Create.h"

@interface LCChatAddFriendVC ()<UITableViewDataSource, UITableViewDelegate>

//Data
@property (nonatomic, strong) NSMutableArray *recmUserArray;
@property (nonatomic, strong) NSMutableArray *mixedArray;
@property (nonatomic, strong) NSString *orderStr;

//UI
@property (weak, nonatomic) IBOutlet UITableView *recmUserTableView;
@property (weak, nonatomic) IBOutlet UIButton *chatContactBookButton;
@property (weak, nonatomic) IBOutlet UIButton *chatNearbyDuckrButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *separateLineHeight;

@end

@implementation LCChatAddFriendVC

+ (instancetype)createInstance {
    return (LCChatAddFriendVC *)[LCStoryboardManager viewControllerWithFileName:SBNameChatTab identifier:VCIDChatAddFriendVC];
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavigationBar];
    [self initTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:APP_ANIMATION];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    [self updateShow];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Common Init

- (void)initNavigationBar {
    self.title = @"添加关注";
    _separateLineHeight.constant = 0.5f;
}

- (void)initTableView {
    self.recmUserTableView.delegate = self;
    self.recmUserTableView.dataSource = self;
    self.recmUserTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.recmUserTableView.estimatedRowHeight = 80.0f;
    self.recmUserTableView.rowHeight = UITableViewAutomaticDimension;
    [self.recmUserTableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    [self.recmUserTableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    [self.recmUserTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCHomeUserCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCHomeUserCell class])];
}

- (void)updateShow {
    if (!self.recmUserArray) {
        [self.recmUserTableView headerBeginRefreshing];
    }
    
    [self.recmUserTableView reloadData];
}

#pragma mark - Net

- (void)requestRecmUserArrayFromOrderString:(NSString *)orderStr {
    __weak typeof(self) weakSelf = self;
    NSString *locName;
    if (nil != [LCDataManager sharedInstance].currentCity) {
        locName = [LCDataManager sharedInstance].currentCity.cityName;
    }
    
    [LCNetRequester getUserRecmDuckrListWithLocName_V_FIVE:locName location:[LCDataManager sharedInstance].userLocation orderStr:orderStr callBack:^(NSArray *userArray, NSArray *mixedArray, NSString *orderStr, NSError *error) {
        [self.recmUserTableView headerEndRefreshing];
        [self.recmUserTableView footerEndRefreshing];
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipDefaultDelay];
        } else {
            if ([LCStringUtil isNullString:weakSelf.orderStr]) {
                // refresh
                weakSelf.recmUserArray = [NSMutableArray arrayWithArray:userArray];
                weakSelf.mixedArray = [NSMutableArray arrayWithArray:mixedArray];
            } else {
                // loadmore
                if (!userArray || userArray.count <= 0) {
                    [YSAlertUtil tipOneMessage:LCFooterRefreshEmptyTip yoffset:TipDefaultYoffset delay:TipDefaultDelay];
                } else {
                    if (!weakSelf.recmUserArray) {
                        weakSelf.recmUserArray = [[NSMutableArray alloc] init];
                        weakSelf.mixedArray = [[NSMutableArray alloc] init];
                    }
                    [weakSelf.recmUserArray addObjectsFromArray:userArray];
                    [weakSelf.mixedArray addObjectsFromArray:mixedArray];
                }
            }
            [self updateShow];
        }
    }];
}

#pragma mark - Refresh

- (void)refreshData {
    
}

- (void)headerRefreshing {
    [self requestRecmUserArrayFromOrderString:nil];
}

- (void)footerRefreshing {
    [self requestRecmUserArrayFromOrderString:self.orderStr];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recmUserArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCUserModel *user = [self.recmUserArray objectAtIndex:indexPath.row];
    LCHomeUserCell *userCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCHomeUserCell class]) forIndexPath:indexPath];
    [userCell updateShowCell:user withType:LCHomeUserCellViewType_ChatAddFriend];
    [userCell updateChatAddFriendLabelWithMixedNumber:[[self.mixedArray objectAtIndex:indexPath.row] integerValue]];
    return userCell;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LCUserModel *user = [self.recmUserArray objectAtIndex:indexPath.row];
    [LCViewSwitcher pushToShowUserInfoVCForUser:user on:self.navigationController];
}

#pragma mark - Actions

- (IBAction)onContactBookButtonClicked:(id)sender {
    [MobClick event:Mob_ChatTab_AddFriend];
    [LCViewSwitcher presentToShowAddFriendVCShowingTab:LCAddFriendVCTab_AddressBookUser];
//    LCContactListVC *vc = [LCContactListVC createInstance];
//    [self.navigationController pushViewController:vc animated:APP_ANIMATION];
}

- (IBAction)onNearbyDuckrButtonClicked:(id)sender {
    LCChatAddFriendNearbyDuckrVC *addFriendNearbyVC = [LCChatAddFriendNearbyDuckrVC createInstance];
    [self.navigationController pushViewController:addFriendNearbyVC animated:APP_ANIMATION];
}

- (IBAction)onSearchButtonClicked:(id)sender {
    LCChatAddFriendSearchVC *searchVC = [LCChatAddFriendSearchVC createInstance];
    [self.navigationController pushViewController:searchVC animated:APP_ANIMATION];
}

@end
