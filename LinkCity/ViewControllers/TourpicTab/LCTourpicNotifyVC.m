//
//  LCTourpicNotifyVC.m
//  LinkCity
//
//  Created by 张宗硕 on 3/30/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCTourpicNotifyVC.h"
#import "LCNotifyTableViewCell.h"
#import "LCTourpicDetailVC.h"
#import "MJRefresh.h"

@interface LCTourpicNotifyVC ()<UITableViewDataSource, UITableViewDelegate, LCNotifyTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSArray *notifyArr;
@property (retain, nonatomic) NSString *orderStr;

@end

@implementation LCTourpicNotifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initVariable];
    [self initTableView];
    [self updateUserNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

+ (instancetype)createInstance {
    return (LCTourpicNotifyVC *)[LCStoryboardManager viewControllerWithFileName:SBNameTourpicTab identifier:VCIDTourpicNotifyVC];
}

- (void)initVariable {
    self.notifyArr = [[NSArray alloc] init];
    self.orderStr = @"";
}

- (void)initTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollsToTop = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCNotifyTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCNotifyTableViewCell class])];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefreshAction)];
}

- (void)footerRefreshAction {
    [self updateUserNotifications];
}

- (void)updateUserNotifications {
    [LCNetRequester getTourpicNotificationsWithOrderStr:self.orderStr callBack:^(NSArray *notifyArr, LCRedDotModel *redDot, NSString *orderStr, NSError *error) {
        [self.tableView footerEndRefreshing];
        if (!error) {
            [LCDataManager sharedInstance].redDot = redDot;
            if ([LCStringUtil isNullString:self.orderStr]) {
                if (nil != notifyArr) {
                    self.notifyArr = notifyArr;
                    [self.tableView reloadData];
                } else {
                    self.notifyArr = [[NSArray alloc] init];
                }
            } else {
                if (nil != notifyArr) {
                    NSMutableArray *mutArr = [[NSMutableArray alloc] initWithArray:self.notifyArr];
                    [mutArr addObjectsFromArray:notifyArr];
                    self.notifyArr = mutArr;
                    [self.tableView reloadData];
                }
            }
            self.orderStr = orderStr;
        }
        
    }];
}

- (void)showTourpicDetail:(LCTourpic *)tourpic {
    LCTourpicDetailVC *vc = [LCTourpicDetailVC createInstance];
    vc.tourpic = tourpic;
    [self.navigationController pushViewController:vc animated:APP_ANIMATION];
}

#pragma mark LCNotifyTableViewCell Delegate
- (void)notifyTableViewCellDidClickAvatarButton:(LCNotifyTableViewCell *)cell {
    LCUserModel *userModel = [[LCUserModel alloc] init];
    userModel.uUID = cell.userNotification.userUUID;
    if ([LCStringUtil isNotNullString:userModel.uUID]) {
        [LCViewSwitcher pushToShowUserInfoVCForUser:userModel on:self.navigationController];
    }
}

#pragma mark UITableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCUserNotificationModel *aNotification = [self.notifyArr objectAtIndex:indexPath.row];
    LCNotifyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCNotifyTableViewCell class]) forIndexPath:indexPath];
    cell.delegate = self;
    cell.userNotification = aNotification;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.notifyArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [LCNotifyTableViewCell getCellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:APP_ANIMATION];
    LCUserNotificationModel *model = [self.notifyArr objectAtIndex:indexPath.row];
    LCTourpic *tourpic = [[LCTourpic alloc] init];
    tourpic.guid = model.guid;
    [self showTourpicDetail:tourpic];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

@end
