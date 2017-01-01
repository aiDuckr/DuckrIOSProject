//
//  LCContactPlanListVC.m
//  LinkCity
//
//  Created by roy on 3/16/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCContactPlanOrGroupListVC.h"
#import "LCContactPlanOrGroupCell.h"
#import "MJRefresh.h"
#import "LCBlankContentView.h"


@interface LCContactPlanOrGroupListVC ()<UITableViewDataSource,UITableViewDelegate>
//Data
@property (nonatomic, strong) NSMutableArray *planArray;
@property (nonatomic, strong) NSString *planArrayOrderStr;
@property (nonatomic, strong) NSMutableArray *groupArray;

//UI
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) LCBlankContentView *tableBlankView;


@end

@implementation LCContactPlanOrGroupListVC

+ (instancetype)createInstance{
    return (LCContactPlanOrGroupListVC *)[LCStoryboardManager viewControllerWithFileName:SBNameChatTab identifier:VCIDContactPlanOrGroupListVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addObserveToNotificationNameToRefreshData:URL_JOIN_PLAN];
    [self addObserveToNotificationNameToRefreshData:URL_QUIT_PLAN];
    [self addObserveToNotificationNameToRefreshData:URL_QUIT_CHATGROUP];
    [self addObserveToNotificationNameToRefreshData:URL_JOINE_CHATGROUP];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCContactPlanOrGroupCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCContactPlanOrGroupCell class])];
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefreshAction)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefreshAction)];
    
    NSString *blankContentTitle = @"";
    switch (self.showingType) {
        case LCContactPlanOrGroupListVC_Group:
            blankContentTitle = @"还没有聊天室记录，打开附近看看吧！";
            break;
        case LCContactPlanOrGroupListVC_Plan:
            blankContentTitle = @"还没有群聊消息，加入个聊天室试试！";
            break;
    }
    self.tableBlankView = [[LCBlankContentView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT) imageName:BlankContentImageE title:blankContentTitle marginTop:BlankContentMarginTop+80];
    [self.view insertSubview:self.tableBlankView atIndex:0];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
    [self updateShow];
}

- (void)refreshData{
    [self.tableView headerBeginRefreshing];
}

- (void)updateShow{
    switch (self.showingType) {
        case LCContactPlanOrGroupListVC_Group:
            self.title = @"当地聊天室";
            break;
        case LCContactPlanOrGroupListVC_Plan:
            self.title = @"邀约群";
            break;
    }
    
    if ((self.groupArray && self.groupArray.count>0) ||
        (self.planArray && self.planArray.count>0)) {
        self.tableBlankView.hidden = YES;
    }else{
        self.tableBlankView.hidden = NO;
    }
    
    [self.tableView reloadData];
}


#pragma mark Set & Get
- (NSMutableArray *)planArray{
    return [LCDataManager sharedInstance].joinedPlanArr;
}
- (void)setPlanArray:(NSMutableArray *)planArray{
    [LCDataManager sharedInstance].joinedPlanArr = planArray;
}

- (NSMutableArray *)groupArray{
    return [LCDataManager sharedInstance].joinedChatGroupArr;
}
- (void)setGroupArray:(NSMutableArray *)groupArray{
    [LCDataManager sharedInstance].joinedChatGroupArr = groupArray;
}

#pragma mark NetRequest
- (void)requestPlansFromOrderString:(NSString *)orderString{
    self.planArrayOrderStr = orderString;
    
    [LCNetRequester getJoinedPlansOfUser:[LCDataManager sharedInstance].userInfo.uUID orderString:orderString callBack:^(NSArray *plans, NSString *orderStr, NSError *error) {
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipDefaultDelay];
        }else{
            if ([LCStringUtil isNullString:self.planArrayOrderStr]) {
                //下拉刷新
                self.planArray = [NSMutableArray arrayWithArray:plans];
            }else{
                //上拉加载更多
                if (!plans || plans.count<=0) {
                    [YSAlertUtil tipOneMessage:LCFooterRefreshEmptyTip yoffset:TipDefaultYoffset delay:TipDefaultDelay];
                }else{
                    if (!self.planArray) {
                        self.planArray = [[NSMutableArray alloc] initWithCapacity:0];
                    }
                    [self.planArray addObjectsFromArray:plans];
                }
            }
            
            self.planArrayOrderStr = orderStr;
            [self updateShow];
        }

    }];
}

//ChatGroup only support HeaderRefresh, doNoting when footerRefresh
- (void)requestChatGroupsFromServer{
    [LCNetRequester getMyChatGroupListWithCallBack:^(NSArray *chatGroupArray, NSError *error) {
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipDefaultDelay];
        }else{
            self.groupArray = [NSMutableArray arrayWithArray:chatGroupArray];
            [self updateShow];
        }
    }];
}


#pragma mark Table Refresh
- (void)headerRefreshAction{
    switch (self.showingType) {
        case LCContactPlanOrGroupListVC_Group:
            [self requestChatGroupsFromServer];
            break;
        case LCContactPlanOrGroupListVC_Plan:
            [self requestPlansFromOrderString:nil];
            break;
    }
}
- (void)footerRefreshAction{
    switch (self.showingType) {
        case LCContactPlanOrGroupListVC_Group:
            [self.tableView footerEndRefreshing];
            break;
        case LCContactPlanOrGroupListVC_Plan:
            [self requestPlansFromOrderString:self.planArrayOrderStr];
            break;
    }
}

#pragma mark UITableView Delegate DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowNum = 0;
    switch (self.showingType) {
        case LCContactPlanOrGroupListVC_Group:
            if (self.groupArray) {
                rowNum = self.groupArray.count;
            }
            break;
        case LCContactPlanOrGroupListVC_Plan:
            if (self.planArray) {
                rowNum = self.planArray.count;
            }
    }
    return rowNum;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    height = [LCContactPlanOrGroupCell getCellHeight];
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    
    switch (self.showingType) {
        case LCContactPlanOrGroupListVC_Group:{
            LCChatGroupModel *group = [self.groupArray objectAtIndex:indexPath.row];
            LCContactPlanOrGroupCell *groupCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCContactPlanOrGroupCell class]) forIndexPath:indexPath];
            [groupCell.coverImageView setImageWithURL:[NSURL URLWithString:group.coverThumbUrl] placeholderImage:nil];
            groupCell.titleLabel.text = [LCStringUtil getNotNullStr:group.name];
            cell = groupCell;
        }
            break;
        case LCContactPlanOrGroupListVC_Plan:{
            LCPlanModel *plan = [self.planArray objectAtIndex:indexPath.row];
            LCContactPlanOrGroupCell *planCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCContactPlanOrGroupCell class]) forIndexPath:indexPath];
            [planCell.coverImageView setImageWithURL:[NSURL URLWithString:plan.firstPhotoThumbUrl] placeholderImage:nil];
            planCell.titleLabel.text = [LCStringUtil getNotNullStr:plan.roomTitle];
            cell = planCell;
        }
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (self.showingType) {
        case LCContactPlanOrGroupListVC_Group:{
            LCChatGroupModel *group = [self.groupArray objectAtIndex:indexPath.row];
            [LCViewSwitcher pushToShowChatWithGroupVC:group on:self.navigationController];
        }
            break;
        case LCContactPlanOrGroupListVC_Plan:{
            LCPlanModel *plan = [self.planArray objectAtIndex:indexPath.row];
            [LCViewSwitcher pushToShowChatWithPlanVC:plan on:self.navigationController];
        }
            break;
    }
}




@end
