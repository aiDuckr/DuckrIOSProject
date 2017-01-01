//
//  LCMessageCenterVC.m
//  LinkCity
//
//  Created by zzs on 14/12/2.
//  Copyright (c) 2014年 linkcity. All rights reserved.
//

#import "LCMessageCenterVC.h"
#import "LCMessageCenterCell.h"
#import "LCMessageCenterApi.h"
#import "LCNotification.h"
#import "LCSlideVC.h"
#import "LCDateUtil.h"
#import "MJRefresh.h"
#import "LCChatManager.h"

@interface LCMessageCenterVC ()<UITableViewDataSource, UITableViewDelegate, LCMessageCenterDelegate> {
    NSArray *messageList;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) BOOL isPullHeaderAction;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButtonItem;

@end

@implementation LCMessageCenterVC

- (IBAction)markAllReadAction:(id)sender {
    [LCChatManager sharedInstance].initialData.unreadMsgNum = 0;
    LCMessageCenterApi *api = [[LCMessageCenterApi alloc] initWithDelegate:self];
    [api setReadAllMessage];
}

- (void)messageCenterApi:(LCMessageCenterApi *)api didSetReadAllMessageWithError:(NSError *)error {
    if (nil == error) {
        for (LCNotification *notif in messageList) {
            notif.status = NOTIF_STATUS_READ;
        }
        [self.tableView reloadData];
    }
}

- (IBAction)menuAction:(id)sender {
    [LCSlideVC showMenu];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    messageList = [[LCDataManager sharedInstance] readMessageList];
    ZLog(@"the message list count is %tu", messageList.count);
    /// 使用资源原图片.
    UIImage *menuImage = [[UIImage imageNamed:@"NavigationMenuIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.menuButtonItem setImage:menuImage];
    
    //设置上下拉刷新
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getMessageCenter:@""];
}

#pragma mark - MJRefresh
- (void)headerRereshing {
    [self getMessageCenter:@""];
}

- (void)footerRereshing {
    if (!messageList || messageList.count <= 0){
        [self getMessageCenter:@""];
    }else{
        LCNotification *notif = [messageList objectAtIndex:messageList.count - 1];
        [self getMessageCenter:notif.timestamp];
    }
}

- (void)getMessageCenter:(NSString *)orderTime {
    ZLog(@"order time is %@", orderTime);
    if ([LCStringUtil isNullString:orderTime]) {
        self.isPullHeaderAction = YES;
    } else {
        self.isPullHeaderAction = NO;
    }
    LCMessageCenterApi *api = [[LCMessageCenterApi alloc] initWithDelegate:self];
    [api getMessageCenterList:orderTime];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return messageList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"MessageCenterCell";
    LCMessageCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (nil == cell) {
        cell = [[LCMessageCenterCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    LCNotification *notif = [messageList objectAtIndex:indexPath.row];
    cell.naviController = self.navigationController;
    cell.notif = notif;
    cell.contentLabel.text = notif.content;
    cell.titleLabel.text = notif.notifTitle;
    cell.avatarButton.imageURL = [NSURL URLWithString:notif.fromUserAvatar];
    NSDate *date = [LCDateUtil dateFromStringYMD_HMS:notif.createdTime];
    NSString *monthDay = [LCDateUtil getMonthAndDateStrFromDate:date];
    cell.timeLabel.text = monthDay;
    if (NOTIF_STATUS_READ == notif.status) {
        cell.dotView.hidden = YES;
    } else {
        cell.dotView.hidden = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LCNotification *notif = [messageList objectAtIndex:indexPath.row];
    NSString *notifID = notif.notfID;
    LCMessageCenterApi *api = [[LCMessageCenterApi alloc] initWithDelegate:self];
    [api setReadMessage:notifID];
    ZLog(@"the notify id is %@", notifID);
    notif.status = NOTIF_STATUS_READ;
    [LCChatManager sharedInstance].initialData.unreadMsgNum--;
    //[tableView reloadData];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
    NotifType type = notif.type;
    ZLog(@"type is %d", type);
    switch (type) {
        case NOTIFY_TYPE_REPLY_PLAN:
        case NOTIFY_TYPE_REPLY_COMMENT:
        {
            NSString *planGuid = notif.planGuid;
            NSString *planType = notif.planType;
            /// 判断各个变量是否为空，都不为空的时候跳转.
            if ([LCStringUtil isNotNullString:planGuid] &&
                [LCStringUtil isNotNullString:planType]) {
                [LCViewSwitcher pushToShowDetailOfPlanWithUUID:planGuid planType:planType onNavigationVC:self.navigationController scrollType:PlanDetailScrollToBottom];
            }
        }
            break;
        case NOTIFY_TYPE_PRAISE:
        case NOTIFY_TYPE_SYSTEM_GOTO_PLAN:
        {
            NSString *planGuid = notif.planGuid;
            NSString *planType = notif.planType;
            /// 判断各个变量是否为空，都不为空的时候跳转.
            if ([LCStringUtil isNotNullString:planGuid] &&
                [LCStringUtil isNotNullString:planType]) {
                [LCViewSwitcher pushToShowDetailOfPlanWithUUID:planGuid planType:planType onNavigationVC:self.navigationController scrollType:PlanDetailNotScroll];
            }
        }
            break;
        case NOTIFY_TYPE_EVENT:
        {
            //NSString *content = [apsInfo objectForKey:@"C"];
            NSString *eventUrl = notif.eventUrl;
            NSString *eventTitle = notif.eventTitile;
            /// 判断各个变量是否为空，都不为空的时候跳转.
            ZLog(@"evnet url is %@", eventUrl);
            if ([LCStringUtil isNotNullString:eventUrl]) {
                [LCViewSwitcher presentWebVCtoShowURL:eventUrl withTitle:eventTitle];
            }
        }
            break;
        default:
            break;
    }
}

- (void)messageCenterApi:(LCMessageCenterApi *)api didGetMessageCenterList:(NSArray *)messages withError:(NSError *)error {
    if (error) {
        if ([LCStringUtil isNotNullString:error.domain]) {
            [self showHint:error.domain];
        }
    } else {
        if (self.isPullHeaderAction) {
            //下拉刷新
            messageList = messages;
            [[LCDataManager sharedInstance] saveMessageList:messageList];
        } else {
            //上拉刷新
            if(!messageList || messageList.count <= 0) {
                [self showHint:@"没有更多了！"];
            } else {
                messageList = [messageList arrayByAddingObjectsFromArray:messages];
                [[LCDataManager sharedInstance] saveMessageList:messageList];
            }
        }
        [self.tableView reloadData];
    }
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
