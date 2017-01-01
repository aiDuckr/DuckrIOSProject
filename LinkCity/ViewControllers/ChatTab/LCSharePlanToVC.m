//
//  LCSharePlanToVC.m
//  LinkCity
//
//  Created by roy on 8/2/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCSharePlanToVC.h"
#import "LCUserTableViewCell.h"
#import "LCUserTableViewCellHelper.h"
#import "LCContactPlanOrGroupCell.h"
#import "LCChatSectionHeaderView.h"


@interface LCSharePlanToVC ()<UITableViewDataSource,UITableViewDelegate,LCUserTableViewCellDelegate,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;


@property (nonatomic, strong) NSArray *favoredUserArray;
@property (nonatomic, strong) NSMutableArray *filteredUserArray;

@property (nonatomic, strong) NSMutableArray *joinedPlanArray;
@property (nonatomic, strong) NSMutableArray *filterdPlanArray;
@property (nonatomic, strong) NSString *planArrayOrderStr;
@end

@implementation LCSharePlanToVC

+ (instancetype)createInstance{
    return (LCSharePlanToVC *)[LCStoryboardManager viewControllerWithFileName:SBNameChatTab identifier:NSStringFromClass([LCSharePlanToVC class])];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"分享给谁?";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView addFooterWithTarget:self action:@selector(footerRefreshAction)];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCUserTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCUserTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCContactPlanOrGroupCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCContactPlanOrGroupCell class])];
    
    [self addSearchBarToTableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}

- (void)refreshData{
    if (![self haveLogin]) {
        return;
    }
    
    self.favoredUserArray = [LCDataManager sharedInstance].favorUserArr;
    self.filteredUserArray = [[NSMutableArray alloc] initWithArray:self.favoredUserArray];
    
    [LCNetRequester getFavoredUserOfUserUuid:nil callBack:^(NSArray *userArray, NSError *error) {
        if (error) {
            LCLogWarn(@"getFavoredUserOfChatContactWithOrderString error:%@",error);
        }else{
            self.favoredUserArray = userArray;
            [LCDataManager sharedInstance].favorUserArr = userArray;
            self.filteredUserArray = [[NSMutableArray alloc] initWithArray:self.favoredUserArray];
            [self updateShow];
        }
    }];
    
    [self requestPlansFromOrderString:nil];
    [self updateShow];
}

- (void)updateShow{
    [self.tableView reloadData];
}

- (void)addSearchBarToTableView{
    if (!self.searchBar) {
        //为通讯录添加搜索栏
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 10, DEVICE_WIDTH, LCSearchBarHeight)];
        self.searchBar.barTintColor = UIColorFromRGBA(LCSearchBarBgColor, 1);
        self.searchBar.placeholder = @"搜索";
        self.searchBar.delegate = self;
        self.searchBar.layer.borderColor = UIColorFromRGBA(LCSearchBarBgColor, 1).CGColor;
        self.searchBar.layer.borderWidth = 1;
    }
    self.tableView.tableHeaderView = self.searchBar;
}

/// 在聊天列表中显示发送的计划信息.
- (MessageModel *)getMessageModelFromPlan:(LCPlanModel *)plan text:(NSString *)text {
    LCUserModel *userInfo = [LCDataManager sharedInstance].userInfo;
    MessageModel *model = [[MessageModel alloc] init];
    model.plan = plan;
    model.type = eMessageBodyType_Plan;
    model.content = text;
    model.isSender = YES;
    model.headImageURL = [NSURL URLWithString:userInfo.avatarThumbUrl];
    model.sendDate = [NSDate date];
    return model;
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
                self.joinedPlanArray = [NSMutableArray arrayWithArray:plans];
            }else{
                //上拉加载更多
                if (!plans || plans.count<=0) {
                    [YSAlertUtil tipOneMessage:LCFooterRefreshEmptyTip yoffset:TipDefaultYoffset delay:TipDefaultDelay];
                }else{
                    if (!self.joinedPlanArray) {
                        self.joinedPlanArray = [[NSMutableArray alloc] initWithCapacity:0];
                    }
                    [self.joinedPlanArray addObjectsFromArray:plans];
                }
            }
            
            self.filterdPlanArray = [[NSMutableArray alloc] initWithArray:self.joinedPlanArray];
            self.planArrayOrderStr = orderStr;
            [self updateShow];
        }
        
    }];
}

#pragma mark Table Refresh
- (void)footerRefreshAction{
    [self requestPlansFromOrderString:self.planArrayOrderStr];
}

#pragma mark TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0;
    if (section == 0 || section == 1) {
        height = [LCChatSectionHeaderView getHeaderViewHeight];
    }
    return height;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = nil;
    if (section == 0) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([LCChatSectionHeaderView class]) bundle:nil];
        LCChatSectionHeaderView *sectionView = [[nib instantiateWithOwner:nil options:0] firstObject];
        sectionView.leftLabel.text = @"关注的人";
        sectionView.rightLabel.hidden = YES;
        view = sectionView;
    }else if(section == 1) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([LCChatSectionHeaderView class]) bundle:nil];
        LCChatSectionHeaderView *sectionView = [[nib instantiateWithOwner:nil options:0] firstObject];
        sectionView.leftLabel.text = @"参加的邀约";
        sectionView.rightLabel.hidden = YES;
        view = sectionView;
    }
    return view;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowNum = 0;
    
    if (section == 0) {
        rowNum = self.filteredUserArray.count;
    }else if (section == 1) {
        rowNum = self.filterdPlanArray.count;
    }
    
    return rowNum;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight = 0;
    
    if (indexPath.section == 0) {
        rowHeight = [LCUserTableViewCell getCellHeight];
    }else if(indexPath.section == 1) {
        rowHeight = [LCContactPlanOrGroupCell getCellHeight];
    }
    
    return rowHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        LCUserTableViewCell *userCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCUserTableViewCell class]) forIndexPath:indexPath];
        userCell.selectionStyle = UITableViewCellSelectionStyleNone;
        userCell.delegate = self;
        LCUserModel *user = [self.filteredUserArray objectAtIndex:indexPath.row];
        [LCUserTableViewCellHelper setUserTableViewCell:userCell shownAsChatContactWithUser:user];
        cell = userCell;
    }else if (indexPath.section == 1) {
        LCPlanModel *plan = [self.filterdPlanArray objectAtIndex:indexPath.row];
        LCContactPlanOrGroupCell *planCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCContactPlanOrGroupCell class]) forIndexPath:indexPath];
        [planCell.coverImageView setImageWithURL:[NSURL URLWithString:plan.firstPhotoThumbUrl] placeholderImage:nil];
        planCell.titleLabel.text = [LCStringUtil getNotNullStr:plan.roomTitle];
        cell = planCell;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        LCUserModel *user = [self.filteredUserArray objectAtIndex:indexPath.row];
        NSString *text = @"[旅行计划]";
        MessageModel *model = [self getMessageModelFromPlan:self.planToShare text:text];
        [[LCXMPPMessageHelper sharedInstance] sendChatMessageModel:model toBareJidString:user.openfireAccount];
        
        [LCViewSwitcher pushToShowChatWithUserVC:user on:self.navigationController];
    }else if(indexPath.section == 1) {
        LCPlanModel *plan = [self.filterdPlanArray objectAtIndex:indexPath.row];
        NSString *text = @"[旅行计划]";
        MessageModel *model = [self getMessageModelFromPlan:self.planToShare text:text];
        [[LCXMPPMessageHelper sharedInstance] sendGroupChat:model toBareJidString:plan.roomId];
        [LCViewSwitcher pushToShowChatWithPlanVC:plan on:self.navigationController];
    }
}


#pragma mark LCUserTableViewCell Delegate
- (void)userTableViewCellDidClickAvatarButton:(LCUserTableViewCell *)userCell{
    if (userCell.user && [LCStringUtil isNotNullString:userCell.user.uUID]) {
        [LCViewSwitcher pushToShowUserInfoVCForUser:userCell.user on:self.navigationController];
    }
}

#pragma mark UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.tableView) {
        [self.view endEditing:YES];
    }
}

#pragma mark UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;{
    if ([LCStringUtil isNullString:searchText]) {
        self.filteredUserArray = [[NSMutableArray alloc] initWithArray:self.favoredUserArray];
        self.filterdPlanArray = [[NSMutableArray alloc] initWithArray:self.joinedPlanArray];
    }else{
        [self.filteredUserArray removeAllObjects];
        for (LCUserModel *user in self.favoredUserArray) {
            if (NSNotFound != [user.nick rangeOfString:searchText options:NSCaseInsensitiveSearch].location ||
                NSNotFound != [user.telephone rangeOfString:searchText options:NSCaseInsensitiveSearch].location) {
                
                [self.filteredUserArray addObject:user];
            }
        }
        
        [self.filterdPlanArray removeAllObjects];
        for (LCPlanModel *plan in self.joinedPlanArray) {
            if (NSNotFound != [plan.roomTitle rangeOfString:searchText options:NSCaseInsensitiveSearch].location) {
                
                [self.filterdPlanArray addObject:plan];
            }
        }
    }
    
    [self updateShow];
}


@end
