//
//  LCNotifyVC.m
//  LinkCity
//
//  Created by roy on 3/29/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCNotifyTableVC.h"
#import "LCNotifyTableViewCell.h"
#import "LCUserNotificationModel.h"

@interface LCNotifyTableVC ()<UITableViewDataSource,UITableViewDelegate,LCNotifyTableViewCellDelegate>
@property (nonatomic, strong) NSMutableArray *notificationArray;    //array of LCUserNotificationModel
@property (nonatomic, strong) NSString *orderStr;


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation LCNotifyTableVC

+ (instancetype)createInstance{
    return (LCNotifyTableVC *)[LCStoryboardManager viewControllerWithFileName:SBNameUserTab identifier:VCIDNotifyTableVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 65;
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCNotifyTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCNotifyTableViewCell class])];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)refreshData{
    [self.tableView headerBeginRefreshing];
}

- (void)updateShow{
    [self.tableView reloadData];
}



- (void)requestUserNotificationWithOrderStr:(NSString *)orderStr{
    [LCNetRequester getUserNotificationListWithOrderStr:orderStr callBack:^(NSArray *userNotificationArray, NSString *orderStr, LCRedDotModel *redDot, NSError *error) {
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
        }else{
            //拉取消息后，更新红点数量
            [LCDataManager sharedInstance].redDot = redDot;
            
            if ([LCStringUtil isNullString:self.orderStr]) {
                //下拉刷新
                self.notificationArray = [NSMutableArray arrayWithArray:userNotificationArray];
            }else{
                //上拉加载更多
                if (!userNotificationArray || userNotificationArray.count<=0) {
                    [YSAlertUtil tipOneMessage:LCFooterRefreshEmptyTip yoffset:TipDefaultYoffset delay:TipDefaultDelay];
                }else{
                    if (!self.notificationArray) {
                        self.notificationArray = [[NSMutableArray alloc] initWithCapacity:0];
                    }
                    [self.notificationArray addObjectsFromArray:userNotificationArray];
                }
            }
            self.orderStr = orderStr;
            [self updateShow];
        }
    }];
}
#pragma mark Refresh
- (void)headerRereshing
{
    self.orderStr = nil;
    [self requestUserNotificationWithOrderStr:nil];
}

- (void)footerRereshing
{
    [self requestUserNotificationWithOrderStr:self.orderStr];
}

#pragma mark UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.notificationArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LCUserNotificationModel *aNotification = [self.notificationArray objectAtIndex:indexPath.row];
    LCNotifyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCNotifyTableViewCell class]) forIndexPath:indexPath];
    cell.userNotification = aNotification;
    cell.delegate = self;
    
    return cell;
}
#pragma mark TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LCUserNotificationModel *aNotification = [self.notificationArray objectAtIndex:indexPath.row];
    if(aNotification.type == LCUserNotificationType_CommentPlan ||
       aNotification.type == LCUserNotificationType_ApplyPlan) {
        
        if ([LCStringUtil isNotNullString:aNotification.guid]) {
            LCPlanModel *aPlan = [[LCPlanModel alloc] init];
            aPlan.planGuid = aNotification.guid;
            [LCViewSwitcher pushToShowPlanDetailVCForPlan:aPlan recmdUuid:nil defaultTabIndex:2 on:self.navigationController];
        }
    }else if(aNotification.type == LCUserNotificationType_FavorUser ||
             aNotification.type == LCUserNotificationType_EvaluationUser) {
        
        if ([LCStringUtil isNotNullString:aNotification.userUUID]) {
            LCUserModel *aUser = [[LCUserModel alloc] init];
            aUser.uUID = aNotification.userUUID;
            [LCViewSwitcher pushToShowUserInfoVCForUser:aUser on:self.navigationController];
        }
    }else if(aNotification.type == LCUserNotificationType_System) {
        //系统消息
        if ([LCStringUtil isNotNullString:aNotification.eventUrl]) {
            //如果有URL，跳转到网页
            [LCViewSwitcher pushWebVCtoShowURL:aNotification.eventUrl withTitle:[LCStringUtil getNotNullStr:@""] on:self.navigationController];
        }else if([LCStringUtil isNotNullString:aNotification.guid]){
            //如果有PlanGuid，跳转到计划详情
            LCPlanModel *aPlan = [[LCPlanModel alloc] init];
            aPlan.planGuid = aNotification.guid;
            [LCViewSwitcher pushToShowPlanDetailVCForPlan:aPlan recmdUuid:nil on:self.navigationController];
        }
    }
}

#pragma mark LCNotifyTableViewCellDelegate
- (void)notifyTableViewCellDidClickAvatarButton:(LCNotifyTableViewCell *)cell{
    LCUserNotificationModel *aNotification = cell.userNotification;
    if (aNotification && [LCStringUtil isNotNullString:aNotification.userUUID]) {
        LCUserModel *aUser = [[LCUserModel alloc] init];
        aUser.uUID = aNotification.userUUID;
        [LCViewSwitcher pushToShowUserInfoVCForUser:aUser on:self.navigationController];
    }
}



@end
