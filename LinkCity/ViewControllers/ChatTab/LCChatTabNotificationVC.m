//
//  LCChatTabNotificationVC.m
//  LinkCity
//
//  Created by lhr on 16/6/13.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCChatTabNotificationVC.h"
#import "LCNotifyTableViewCell.h"
#import "LCNotificationModel.h"
#import "LCChatTabNotificationCell.h"


@interface LCChatTabNotificationVC ()<UITableViewDelegate, UITableViewDataSource,LCNotifyTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *notificationArray;

@property (strong, nonatomic) NSString *orderStr;

@end

@implementation LCChatTabNotificationVC

+ (instancetype)createInstance {
    return (LCChatTabNotificationVC *)[LCStoryboardManager viewControllerWithFileName:SBNameChatTab identifier:VCIDChatTabNotificationVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    self.orderStr = nil;
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    //
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
}
#pragma mark - Init
- (void)initTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 80.0f;
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCChatTabNotificationCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCChatTabNotificationCell class])];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Init 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.notificationArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCChatTabNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCChatTabNotificationCell class])];
    LCNotificationModel * model = [self.notificationArray objectAtIndex:indexPath.row];
    [cell updateShowWithNotificationModel:model];
//    cell.userNotification = model;
//    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LCNotificationModel *aNotification = [self.notificationArray objectAtIndex:indexPath.row];
    
    if (aNotification.notificaionType == LCNotificationTypePlan) {
        [LCViewSwitcher pushToShowPlanDetailVCForPlan:aNotification.planInfo recmdUuid:nil on:self.navigationController];
    } else if (aNotification.notificaionType == LCNotificationTypeTourpic) {
        [LCViewSwitcher pushToShowTourPicDetail:aNotification.tourPicInfo withType:LCTourpicDetailVCViewType_Normal on:self.navigationController];
    } else {
        [LCViewSwitcher pushToShowUserInfoVCForUser:aNotification.fromUser on:self.navigationController];
    }
//    if(aNotification.type == LCUserNotificationType_CommentPlan ||
//       aNotification.type == LCUserNotificationType_ApplyPlan) {
//        
//        if ([LCStringUtil isNotNullString:aNotification.guid]) {
//            LCPlanModel *aPlan = [[LCPlanModel alloc] init];
//            aPlan.planGuid = aNotification.guid;
//            [LCViewSwitcher pushToShowPlanDetailVCForPlan:aPlan recmdUuid:nil defaultTabIndex:2 on:self.navigationController];
//        }
//    }else if(aNotification.type == LCUserNotificationType_FavorUser ||
//             aNotification.type == LCUserNotificationType_EvaluationUser) {
//        
//        if ([LCStringUtil isNotNullString:aNotification.userUUID]) {
//            LCUserModel *aUser = [[LCUserModel alloc] init];
//            aUser.uUID = aNotification.userUUID;
//            [LCViewSwitcher pushToShowUserInfoVCForUser:aUser on:self.navigationController];
//        }
//    }else if(aNotification.type == LCUserNotificationType_System) {
//        //系统消息
//        if ([LCStringUtil isNotNullString:aNotification.eventUrl]) {
//            //如果有URL，跳转到网页
//            [LCViewSwitcher pushWebVCtoShowURL:aNotification.eventUrl withTitle:[LCStringUtil getNotNullStr:@""] on:self.navigationController];
//        }else if([LCStringUtil isNotNullString:aNotification.guid]){
//            //如果有PlanGuid，跳转到计划详情
//            LCPlanModel *aPlan = [[LCPlanModel alloc] init];
//            aPlan.planGuid = aNotification.guid;
//            [LCViewSwitcher pushToShowPlanDetailVCForPlan:aPlan recmdUuid:nil on:self.navigationController];
//        }
//    }

}

- (void)refreshData{
    [self.tableView headerBeginRefreshing];
}

- (void)updateShow{
    [self.tableView reloadData];
}



- (void)requestUserNotificationWithOrderStr:(NSString *)orderStr{
    
    __weak typeof(self) weakSelf = self;
    [LCNetRequester getNotificationListWithOrderStr:orderStr callBack:^(NSArray *userNotificationArray, NSString *orderStr, NSError *error) {
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
        
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
        } else {
//            //拉取消息后，更新红点数量
            [[LCRedDotHelper sharedInstance] startUpdateRedDot];
            if ([LCStringUtil isNullString:self.orderStr]) {
                //下拉刷新
                if (nil != userNotificationArray && userNotificationArray.count > 0) {
                    weakSelf.notificationArray = userNotificationArray;
                } else {
                    [YSAlertUtil tipOneMessage:@"您还没有通知"];
                }
            }else{
                //上拉加载更多
                if (!userNotificationArray || userNotificationArray.count<=0) {
                    [YSAlertUtil tipOneMessage:LCFooterRefreshEmptyTip yoffset:TipDefaultYoffset delay:TipDefaultDelay];
                }else{
                    NSMutableArray *mutArr = [[NSMutableArray alloc] initWithArray:weakSelf.notificationArray];
                    [mutArr addObjectsFromArray:userNotificationArray];
                    weakSelf.notificationArray = mutArr;
                }
            }
            weakSelf.orderStr = orderStr;
            [weakSelf updateShow];
        }
    }];
}
#pragma mark - Refresh
- (void)headerRereshing {
    self.orderStr = @"";
    [self requestUserNotificationWithOrderStr:nil];
}

- (void)footerRereshing {
    [self requestUserNotificationWithOrderStr:self.orderStr];
}

#pragma mark - LCNotifyTableViewCell Delegate
- (void)notifyTableViewCellDidClickAvatarButton:(LCNotifyTableViewCell *)cell{
    LCUserNotificationModel *aNotification = cell.userNotification;
    if (aNotification && [LCStringUtil isNotNullString:aNotification.userUUID]) {
        LCUserModel *aUser = [[LCUserModel alloc] init];
        aUser.uUID = aNotification.userUUID;
        [LCViewSwitcher pushToShowUserInfoVCForUser:aUser on:self.navigationController];
    }
}
@end
