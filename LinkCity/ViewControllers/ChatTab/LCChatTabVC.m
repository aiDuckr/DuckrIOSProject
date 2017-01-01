//
//  LCChatTabVC.m
//  LinkCity
//
//  Created by roy on 3/15/15.
//  Updated by zzs on 6/28/16.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCChatTabVC.h"
#import "LCAddFriendVC.h"
#import "LCChatSectionHeaderView.h"
#import "LCContactPlanOrGroupListVC.h"
#import "LCRegisterAndLoginHelper.h"
#import "LCChatWithUserVC.h"
#import "LCRecentChatCell.h"
#import "LCBlankContentView.h"
#import "LCChatTabNavTitleView.h"
#import "LCChatAddFriendVC.h"
#import "LCChatUserFavorDynamicVC.h"
#import "LCContactListVC.h"
#import "LCChatTabNotificationVC.h"
#import "UIImage+Create.h"

static const NSInteger topCellCount = 3;

@interface LCChatTabVC ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (nonatomic, strong) NSMutableArray *coreDataChatContactArray;
@property (weak, nonatomic) IBOutlet UITableView *chatListTableView;
@property (strong, nonatomic) UIImage *formerNavbarShadowImage;             //!> 首页导航栏的背景图.
@property (nonatomic, strong) LCBlankContentView *chatListBlankView;
@property (nonatomic, strong) LCChatTabNavTitleView *navTitleView;
@property (nonatomic, strong) XMPPMessageArchiving_Contact_CoreDataObject *serviceCoreDataChatContact;
@end

@implementation LCChatTabVC

+ (UINavigationController *)createNavInstance {
    return [[UINavigationController alloc] initWithRootViewController:[LCChatTabVC createInstance]];
}

+ (instancetype)createInstance {
    LCChatTabVC *chatVC = (LCChatTabVC *)[LCStoryboardManager viewControllerWithFileName:SBNameChatTab identifier:VCIDChatTabVC];
    return chatVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigationBar];
    [self initAllNotifications];
    [self initTableView];
    [self initBlankView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:UIColorFromRGBA(0xfedd00, 1.0f)] forBarMetrics:UIBarMetricsDefault];
    
    [self updateShow];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[LCUIConstants sharedInstance].navBarOpaqueImage forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:self.formerNavbarShadowImage];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initNavigationBar {
    self.formerNavbarShadowImage = self.navigationController.navigationBar.shadowImage;
    
    UIImage *addUserIcon = [[UIImage imageNamed:@"AddUserIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *addUserBarButton = [[UIBarButtonItem alloc] initWithImage:addUserIcon style:UIBarButtonItemStylePlain target:self action:@selector(addUserButtonAction)];
    self.navigationItem.leftBarButtonItem = addUserBarButton;
    
    UIImage *addFriendIcon = [[UIImage imageNamed:@"ChatAddFriendIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *addFriendButton = [[UIBarButtonItem alloc] initWithImage:addFriendIcon style:UIBarButtonItemStylePlain target:self action:@selector(addFriendButtonAction)];
    self.navigationItem.rightBarButtonItem = addFriendButton;
    
    self.navigationItem.titleView.backgroundColor = [UIColor blueColor];
    UIView *a = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    a.backgroundColor = [UIColor purpleColor];
    [self.navigationItem.titleView addSubview:a];
    
    self.navTitleView = [LCChatTabNavTitleView createInstance];
    self.navTitleView.frame = CGRectMake(0, 0, 200, 44);
    [self.navTitleView showAsNormal];
    self.navigationItem.titleView = self.navTitleView;
}

- (void)initAllNotifications {
    [self addObserveToNotificationNameToRefreshData:NotificationDidReceiveXMPPChatMessage];
    [self addObserveToNotificationNameToRefreshData:NotificationDidReceiveXMPPGroupMessage];
    [self addObserveToNotificationNameToRefreshData:NotificationDidReceiveXMPPMessage];
    [self addObserveToNotificationNameToRefreshData:NotificationReceiveChatMessageAddContact];
    [self addObserveToNotificationNameToRefreshData:URL_QUIT_PLAN];
    [self addObserveToNotificationNameToRefreshData:URL_JOIN_PLAN];
    [self addObserveToNotificationNameToRefreshData:URL_APPROVE_JOIN_PLAN];
    [self addObserveToNotificationNameToRefreshData:URL_DELETE_PLAN];
    [self addObserveToNotificationNameToRefreshData:URL_QUIT_CHATGROUP];
    [self addObserveToNotificationNameToRefreshData:URL_JOINE_CHATGROUP];
    [self addObserveToNotificationNameToRefreshData:URL_FOLLOW_USER];
    [self addObserveToNotificationNameToRefreshData:URL_UNFOLLOW_USER];
    [self addObserveToNotificationNameToRefreshData:NotificationUserJustLogin];
    [self addObserveToNotificationNameToRefreshData:NotificationUserJustLogout];
    [self addObserveToNotificationNameToRefreshData:NotificationJustDeleteChat];
    [self addObserveToNotificationNameToRefreshData:URL_FOLLOW_USER];
    [self addObserveToNotificationNameToRefreshData:URL_UNFOLLOW_USER];
    [self addObserveToNotificationNameToRefreshData:URL_LOGIN];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecodeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)initTableView {
    self.chatListTableView.delegate = self;
    self.chatListTableView.dataSource = self;
    self.chatListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.chatListTableView.backgroundColor = [UIColor clearColor];
    [self.chatListTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCRecentChatCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCRecentChatCell class])];
}

- (void)initBlankView {
    self.chatListBlankView = [[LCBlankContentView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-LCTabViewHeight) imageName:BlankContentImageA title:@"还没有聊天记录，\r\n快去找人搭讪吧！" marginTop:BlankContentMarginTop];
    [self.view insertSubview:self.chatListBlankView atIndex:0];
}

- (void)refreshData {
    if (![self haveLogin]) {
        return;
    }
    
    //从数据库加载最近聊天
    //如果距上一次更新时间大于 LCChatContactUpdateTimeInterval ， 添加到更新列表，去网上更新
    NSArray *coreDataChatContactArray = [LCXMPPUtil loadRecentChatContact:CHAT_CONTACT_TYPE_ALL];
    self.coreDataChatContactArray = [[NSMutableArray alloc] initWithArray:coreDataChatContactArray];
    
    NSMutableArray *jidStringArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSString *serviceJidStr = [NSString stringWithFormat:@"%@@%@", DUKCR_SERVICE_ID, [LCConstants xmppServerName]];
    for (XMPPMessageArchiving_Contact_CoreDataObject *aCoreDataChatContact in self.coreDataChatContactArray) {
        /// 如果是达客客服.
        if ([aCoreDataChatContact.bareJidStr isEqualToString:serviceJidStr]) {
            self.serviceCoreDataChatContact = aCoreDataChatContact;
        }
        if ([LCDataManager sharedInstance].chatContactDic && [[LCDataManager sharedInstance].chatContactDic objectForKey:aCoreDataChatContact.bareJidStr]) {
            LCChatContactModel *aChatContactModel = [[LCDataManager sharedInstance].chatContactDic objectForKey:aCoreDataChatContact.bareJidStr];
//            DUKCR_SERVICE_ID
            if ([[NSDate date] timeIntervalSinceDate:aChatContactModel.lastUpdateContactInfoFromServerTime] > LCChatContactUpdateTimeInterval) {
                [jidStringArray addObject:aCoreDataChatContact.bareJidStr];
            }
        } else {
            [jidStringArray addObject:aCoreDataChatContact.bareJidStr];
        }
    }
    /// 删除达客客服.
    if (nil != self.serviceCoreDataChatContact) {
        [self.coreDataChatContactArray removeObject:self.serviceCoreDataChatContact];
    }
    
    if (NSNotFound == [jidStringArray indexOfObject:serviceJidStr]) {
        [jidStringArray insertObject:serviceJidStr atIndex:0];
    }
    
    //去网上更新通讯录信息
    [LCNetRequester getChatContactInfoWith:jidStringArray callBack:^(NSArray *chatContactArray, NSError *error) {
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
        } else {
            for (LCChatContactModel *aChatContact in chatContactArray){
                [[LCDataManager sharedInstance].chatContactDic setObject:aChatContact forKey:[aChatContact getBareJidString]];
            }
            
            [self updateShow];
        }
    }];
    
    [self updateShow];
}

- (void)commonInit {
    [super commonInit];
    self.isHaveTabBar = YES;
}

- (void)updateShow {
    [self.chatListTableView reloadData];
}

#pragma mark ButtonAction
- (void)addUserButtonAction {
    LCContactListVC *vc = [LCContactListVC createInstance];
    [self.navigationController pushViewController:vc animated:APP_ANIMATION];
}

- (void)addFriendButtonAction {
    LCChatAddFriendVC *chatAddFriendVC = [LCChatAddFriendVC createInstance];
    [self.navigationController pushViewController:chatAddFriendVC animated:APP_ANIMATION];
}

#pragma mark NotificationAction
- (void)appDidBecodeActive:(NSNotification *)notify {
    [self.navTitleView showAsReceivingAndAutoStop];
}

#pragma mark UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger sectionNum = 0;
    
    if (tableView == self.chatListTableView) {
        sectionNum = 1;
    }
    
    return sectionNum;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowNum = 0;
    
    if (tableView == self.chatListTableView) {
        if (self.coreDataChatContactArray) {
            rowNum = self.coreDataChatContactArray.count;
        }
    }
    rowNum += topCellCount;
    
    return rowNum;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    
    if (tableView == self.chatListTableView) {
        height = [LCRecentChatCell getCellHeight];
    }
    
    return height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0;
    if (section == 1) {
        height = [LCChatSectionHeaderView getHeaderViewHeight];
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    LCRecentChatCell *chatCell = [self.chatListTableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCRecentChatCell class]) forIndexPath:indexPath];
    LCRedDotModel *redDotModel = [LCDataManager sharedInstance].redDot;
    
    if (indexPath.row == 0) {
        NSString *timeStr = [LCDateUtil getTimeIntervalStringFromDateString:redDotModel.focusTime];
        NSString *contentStr = redDotModel.focusContent;
        if ([LCStringUtil isNullString:contentStr]) {
            contentStr = @"关注人的动态信息";
        }
        [chatCell updateShowWithTitle:@"我的关注" imageName:@"ChatMyFriendPlanIcon" updateTime:timeStr descString:contentStr unreadNum:redDotModel.focusNum];
    } else if (indexPath.row == 1) {
        NSString *timeStr = [LCDateUtil getTimeIntervalStringFromDateString:redDotModel.notifyTime];
        NSString *contentStr = redDotModel.notifyContent;
        if ([LCStringUtil isNullString:contentStr]) {
            contentStr = @"系统通知的相关信息";
        }
        [chatCell updateShowWithTitle:@"通知" imageName:@"ChatNoticeIcon" updateTime:timeStr descString:contentStr unreadNum:redDotModel.notifyNum];
    } else if (indexPath.row == 2) {
        if (nil != self.serviceCoreDataChatContact) {
            NSString *timeStr = [LCDateUtil getChatTimeStringFromDate:self.serviceCoreDataChatContact.mostRecentMessageTimestamp];
            NSString *contentStr = [LCStringUtil getNotNullStr:self.serviceCoreDataChatContact.mostRecentMessageBody];
            NSInteger unreadNum = [[LCDataManager sharedInstance] getUnreadNumForBareJidStr:self.serviceCoreDataChatContact.bareJidStr];
            [chatCell updateShowWithTitle:@"达客客服" imageName:@"ChatDuckrServiceIcon" updateTime:timeStr descString:contentStr unreadNum:unreadNum];
        } else {
            [chatCell updateShowWithTitle:@"达客客服" imageName:@"ChatDuckrServiceIcon" updateTime:@"" descString:@"您的宝贵意见是我们快速成长的动力" unreadNum:0];
        }
    } else {
        XMPPMessageArchiving_Contact_CoreDataObject *aCoreDataChatContact = [self.coreDataChatContactArray objectAtIndex:indexPath.row - topCellCount];
        //TODO: may need to get from server
        LCChatContactModel *aChatContact = [[LCDataManager sharedInstance].chatContactDic objectForKey:aCoreDataChatContact.bareJidStr];
        NSInteger unreadNum = [[LCDataManager sharedInstance] getUnreadNumForBareJidStr:aCoreDataChatContact.bareJidStr];
        [chatCell updateShowWithChatContact:aChatContact coreDataContact:aCoreDataChatContact unreadNum:unreadNum];
    }
    
    chatCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell = chatCell;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (tableView == self.chatListTableView) {//chat contact
        if (indexPath.row == 0) {
            //跳转到我的关注
            LCChatUserFavorDynamicVC *chatUserFavorDynamicVC = [LCChatUserFavorDynamicVC createInstance];
            chatUserFavorDynamicVC.user = [LCDataManager sharedInstance].userInfo;
            [self.navigationController pushViewController:chatUserFavorDynamicVC animated:APP_ANIMATION];
        } else if (indexPath.row == 1){
            //跳转到通知
            //[[LCRedDotHelper sharedInstance] startUpdateRedDot];
            LCChatTabNotificationVC *vc = [LCChatTabNotificationVC createInstance];
            [self.navigationController pushViewController:vc animated:APP_ANIMATION];
        }else if (indexPath.row == 2) {
            //联系客服
            NSString *serviceJidStr = [NSString stringWithFormat:@"%@@%@", DUKCR_SERVICE_ID, [LCConstants xmppServerName]];
            LCChatContactModel *aChatContactModel = [[LCDataManager sharedInstance].chatContactDic objectForKey:serviceJidStr];
            if (nil != aChatContactModel) {
                [LCViewSwitcher pushToShowChatWithUserVC:aChatContactModel.chatWithUser on:self.navigationController];
            } else {
                [YSAlertUtil tipOneMessage:@"请稍后再试！"];
            }
        } else if ((indexPath.row - topCellCount) < self.coreDataChatContactArray.count) {
            XMPPMessageArchiving_Contact_CoreDataObject *aCoreDataChatContact = [self.coreDataChatContactArray objectAtIndex:(indexPath.row - topCellCount)];
            LCChatContactModel *aChatContact = [[LCDataManager sharedInstance].chatContactDic objectForKey:aCoreDataChatContact.bareJidStr];
            switch (aChatContact.type){
                case LCChatContactType_User:{
                    if (aChatContact.chatWithUser) {
                        [LCViewSwitcher pushToShowChatWithUserVC:aChatContact.chatWithUser on:self.navigationController];
                    }
                }
                    break;
                case LCChatContactType_Plan:{
                    if (aChatContact.chatWithPlan) {
                        [LCViewSwitcher pushToShowChatWithPlanVC:aChatContact.chatWithPlan on:self.navigationController];
                    }
                }
                    break;
                case LCChatContactType_Group:{
                    if (aChatContact.chatWithGroup) {
                        [LCViewSwitcher pushToShowChatWithGroupVC:aChatContact.chatWithGroup on:self.navigationController];
                    }
                }
                    break;
            }
        }
    }
}

#pragma mark UITableView Delete Row
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.chatListTableView && indexPath.row >= topCellCount) {
        return YES;
    } else {
        return NO;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.chatListTableView) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            //删除聊天会话
            XMPPMessageArchiving_Contact_CoreDataObject *aCoredataContact = [self.coreDataChatContactArray objectAtIndex:(indexPath.row - topCellCount)];
            NSString *bareJidStr = [NSString stringWithString:aCoredataContact.bareJidStr];
            
            /*roy 2015-07-28
             不删除聊天消息
             因为即使删除聊天会话，下次打开还是会上线该群聊以便接收新消息
             上线是会摘取最近一条消息之后的未读消息，如果删除聊天消息记录，会再摘取之前的聊天，导致会话重新出现
             */
            //[LCXMPPUtil deleteChatMsg:bareJidStr];
            
            [LCXMPPUtil deleteChatContact:bareJidStr];
            [[LCDataManager sharedInstance] clearUnreadNumForBareJidStr:bareJidStr];
            
            
            [self.coreDataChatContactArray removeObjectAtIndex:indexPath.row - topCellCount];
            
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

//#pragma mark UIScrollView Delegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (scrollView == self.contactListTableView) {
//        [self.view endEditing:YES];
//    }
//}

//#pragma mark UISearchBarDelegate
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;{
//    if ([LCStringUtil isNullString:searchText]) {
//        //如果搜索词为空，显示全部
//        self.filteredFavoredUserArray = [[NSMutableArray alloc] initWithArray:self.favoredUserArray];
//    }else{
//        //根据昵称、电话筛选
//        NSMutableArray *matchedUserArray = [[NSMutableArray alloc] init];
//        for (LCUserModel *user in self.favoredUserArray){
//            if (NSNotFound != [user.nick rangeOfString:searchText options:NSCaseInsensitiveSearch].location ||
//                NSNotFound != [user.telephone rangeOfString:searchText options:NSCaseInsensitiveSearch].location) {
//                [matchedUserArray addObject:user];
//            }
//        }
//        
//        self.filteredFavoredUserArray = matchedUserArray;
//    }
//
//    
//    [self updateShow];
//}

@end
