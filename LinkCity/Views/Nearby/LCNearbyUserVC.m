//
//  LCNearbyUserVC.m
//  LinkCity
//
//  Created by roy on 11/29/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCNearbyUserVC.h"
#import "LCNearbyUserCell.h"
#import "LCUserApi.h"
#import "MJRefresh.h"
#import "LCUserInfoVC.h"
#import "LCChatManager.h"

#define NearbyUserRange 5000
@interface LCNearbyUserVC ()<UITableViewDataSource,UITableViewDelegate,LCUserApiDelegate>


@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuBarButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//是否下拉刷新---否是是上拉刷新
@property (nonatomic, assign) BOOL isPullHeaderAction;

//用于筛选重复用户的辅助字典
@property (nonatomic, strong) NSMutableDictionary *uuidDic;
@end

@implementation LCNearbyUserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置标题
    self.title = @"附近的达客";
    //设置菜单按钮
    [self.menuBarButton setTarget:self];
    [self.menuBarButton setAction:@selector(barMenuButtonAction:)];
    
    UIImage *menuImage = [[UIImage imageNamed:@"NavigationMenuIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.menuBarButton setImage:menuImage];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //设置上下拉刷新
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    //上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    //主动刷新
    [self.tableView headerBeginRefreshing];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInitData) name:NotificationInitData object:nil];
    //更新未读消息显示
    [self updateInitData];
    
    //初始化数据
    self.uuidDic = [[NSMutableDictionary alloc]initWithCapacity:0];
    self.users = [[NSMutableArray alloc]initWithCapacity:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //[self getNearbyUsersInRange:NearbyUserRange orderFrom:0];
    
    if (self.users) {
        [self.tableView reloadData];
        [self getNearbyUsersInRange:NearbyUserRange orderFrom:0];
    }
    
    if ((YES == [LCDataManager sharedInstance].isClickedMenu) || (!self.users && !self.isFirstTimeViewWillAppear)) {
        //主动刷新
        [self.tableView headerBeginRefreshing];
        [LCDataManager sharedInstance].isClickedMenu = NO;
    }
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)barMenuButtonAction:(id)sender{
    [LCSlideVC showMenu];
}
#pragma mark - Public Interface
+ (UINavigationController *)createNavigationVCInstance{
    return (UINavigationController *)[LCStoryboardManager viewControllerWithFileName:SBNameNearby identifier:VCIDNearbyUserNavigationVC];
}
+ (LCNearbyUserVC *)createRootVCInstance{
    return (LCNearbyUserVC *)[LCStoryboardManager viewControllerWithFileName:SBNameNearby identifier:VCIDNearbyUserVC];
}

#pragma mark - NotificationFuncstions
- (void)updateInitData {
    NSInteger menuNumber = [LCChatManager sharedInstance].initialData.unreadChatNum +
                            [LCChatManager sharedInstance].initialData.unreadMsgNum +
                            [[LCChatManager sharedInstance] getTotalUnreadMsgNum];
    if (menuNumber > 0) {
        UIImage *menuImage = [[UIImage imageNamed:@"NavigationMenuRedIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self.menuBarButton setImage:menuImage];
    } else {
        UIImage *menuImage = [[UIImage imageNamed:@"NavigationMenuIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self.menuBarButton setImage:menuImage];
    }
}
#pragma mark - MJRefresh
- (void)headerRereshing
{
    self.isPullHeaderAction = YES;
    [self getNearbyUsersInRange:NearbyUserRange orderFrom:0];
}

- (void)footerRereshing
{
    self.isPullHeaderAction = NO;
    if (!self.users || self.users.count<=0) {
        [self getNearbyUsersInRange:NearbyUserRange orderFrom:0];
    }else{
        [self getNearbyUsersInRange:NearbyUserRange orderFrom:self.users.count];
    }
}
#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 74;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LCNearbyUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NearbyUserCell"];
    
    if (self.users.count > indexPath.row) {
        cell.user = [self.users objectAtIndex:indexPath.row];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.users.count > indexPath.row) {
        [LCViewSwitcher pushToShowUserInfo:[self.users objectAtIndex:indexPath.row] onNavigationVC:self.navigationController];
    }
}


#pragma mark - LCUserApi
- (void)getNearbyUsersInRange:(NSInteger)meters orderFrom:(NSInteger)orderStartNumber{
    //RLog(@"%@",[NSThread callStackSymbols]);
    LCUserApi *userApi = [[LCUserApi alloc]initWithDelegate:self];
    [userApi getNearbyUsersInRange:meters orderFrom:orderStartNumber];
}

- (void)userApi:(LCUserApi *)userApi didGetNearbyUsers:(NSArray *)users withError:(NSError *)error{
    if (error) {
        RLog(@"get nearby user error. %@",error);
        [YSAlertUtil tipOneMessage:error.domain delay:TIME_FOR_ERROR_TIP];
    }else{
        RLog(@"get nearby user succeed.");
        if (self.isPullHeaderAction) {
            //下拉刷新
            [self.users removeAllObjects];
            [self.uuidDic removeAllObjects];
            for(LCUserInfo *u in users){
                if ([self.uuidDic objectForKey:u.uuid]) {
                    RLog(@"repeat user: %@,%@",u.uuid,u.nick);
                }else{
                    [self.uuidDic setObject:u forKey:u.uuid];
                    [self.users addObject:u];
                }
            }
        }else{
            if (!users || users.count<=0) {
                [YSAlertUtil tipOneMessage:@"没有更多了"];
            }else{
                for(LCUserInfo *u in users){
                    if ([self.uuidDic objectForKey:u.uuid]) {
                        RLog(@"repeat user: %@,%@",u.uuid,u.nick);
                    }else{
                        [self.uuidDic setObject:u forKey:u.uuid];
                        [self.users addObject:u];
                    }
                }
            }
        }
        [self.tableView reloadData];
    }
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
}
@end
