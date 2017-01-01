//
//  LCChatListVC.m
//  LinkCity
//
//  Created by 张宗硕 on 11/20/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCChatListVC.h"
#import "AppDelegate.h"
#import "ChatViewController.h"
#import "LCXMPPUtil.h"
#import "XMPPMessageArchiving_Contact_CoreDataObject.h"
#import "LCDateUtil.h"
#import "LCChatManager.h"
#import "LCTableView.h"

/// 切换Tab方块动画的时间.
#define CHAT_INDICATOR_DURATION 1.0f

@interface LCChatListVC ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, LCChatApiDelegate, LCUserApiDelegate> {
    NSArray *chatList;      //!< 最近聊天数据列表.array of LCUserInfo&LCPlan
    NSArray *groupList;     //!< 群组聊天数据列表.array of LCPlan
    NSArray *favoriteList;  //!< 喜欢的人数据列表.array of LCUserInfo
    NSDictionary *chatContactDic;   //!< 本地数据库JID对应本地聊天联系人数据库对象.jid-Contact_CoreDataObject
    NSArray *chatLocalContactList;  //!< 本地联系人有顺序的列表.array of Contact_CoreDataObject
    NSInteger currentIndex;         //!< 第几个选项卡.
}

/// 左上角的菜单栏按钮.
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButtonItem;
/// 菜单栏第一个Tab的宽度.
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstTabWidthConstraint;
/// 菜单栏第二个Tab的宽度.
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondTabWidthConstraint;
/// 最近聊天列表的宽度.
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chatTableViewWidthConstraint;
/// 群组聊天列表的宽度.
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *groupTableViewWidthConstraint;
/// 收藏人列表的宽度.
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *favoriteTableViewConstraint;
/// 最近聊天列表.
@property (weak, nonatomic) IBOutlet LCTableView *chatListTableView;
/// 群组聊天列表.
@property (weak, nonatomic) IBOutlet LCTableView *groupChatTableView;
/// 收藏的人列表.
@property (weak, nonatomic) IBOutlet LCTableView *favoriteChatTableView;
/// 列表切换滚动视图.
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
/// 滚动视图上面的标题视图.
@property (weak, nonatomic) IBOutlet UIView *tabBarView;
/// 最近聊天的图标.
@property (weak, nonatomic) IBOutlet UIImageView *chatIconImageView;
/// 群聊的图标.
@property (weak, nonatomic) IBOutlet UIImageView *groupIconImageView;
/// 收藏的人的图标.
@property (weak, nonatomic) IBOutlet UIImageView *favoriteIconImageView;
/// 切换的方块视图.
@property (nonatomic, retain) UIView *indicatorView;

@property (nonatomic, strong) NSMutableDictionary *unreadMsgNumFromServerDic;
@end

@implementation LCChatListVC

- (void)dealloc {
    /// 清理监听事件.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /// 初始化视图控制器的变量.
    [self initVaribaleValue];
    /// 初始化和聊天服务器的连接.
    [self initChatServer];
    /// 初始化所有的列表的样式和Delegate.
    [self initAllTableView];
    /// 初始化左右滚动视图.
    [self initScrollView];
    /// 初始化左右滚动的方块.
    [self initIndicatorView];
    /// 初始化所有检测通知.
    [self initNotificationObserver];
    /// 更新左上角的菜单栏的消息.
    [self updateInitData];
    /// 更新页面的约束条件.
    [self updateConstraint];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    /// 更新左上角的菜单，当分享计划进入联系人的时候菜单变成返回按钮.
    [self updateNavigationButtonItem];
    chatList = [[LCDataManager sharedInstance] readChatList];
    /// 本地读取联系人列表.
    [self readChatContactList];
    /// 本地读取喜欢人的列表.
    [self readFavoriteList];
    /// 服务器读取联系人信息.
    [self getChatListDataFromServer];
    /// 获取收藏人的列表.
    [self getFavoriteListFromServer];
    /// 更新每个联系人的未读消息.
    [self readUnreadMsgCount];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    /// 选择第几个Tab选项卡.
    [self setChooseTableView:currentIndex];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

/// App从后台变前台上线聊天服务器.
- (void)applicationDidActive {
    AppDelegate *del = [self appDelegate];
    if (NO == [[del xmppStream] isConnected]) {
        [del connect];
    }
    /// 更新每个联系人的未读消息.
    [self readUnreadMsgCount];
}

/// 初始化和聊天服务器的连接.
- (void)initChatServer {
    AppDelegate *del = [self appDelegate];
    if (NO == [[del xmppStream] isConnected]) {
        ZLog(@"if (NO == [[del xmppStream] isConnected])");
        [del connect];
    }
}

/// 获取AppDelegate.
- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

/// 初始化左上角的菜单，当分享计划进入联系人的时候菜单变成返回按钮.
- (void)updateNavigationButtonItem {
    switch (self.type) {
        case COMEIN_CHAT_LIST_SHARE:
        {
            UIImage *menuImage = [[UIImage imageNamed:@"NavigationBackBG"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [self.menuButtonItem setImage:menuImage];
        }
            break;
        case COMEIN_CHAT_LIST_MENU:
        {
            UIImage *menuImage = [[UIImage imageNamed:@"NavigationMenuIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [self.menuButtonItem setImage:menuImage];
        }
            break;
            
        default:
            break;
    }
}

/// 初始化所有的列表的样式和Delegate.
- (void)initAllTableView {
    /// 最近聊天列表.
    self.chatListTableView.delegate = self;
    self.chatListTableView.dataSource = self;
    self.chatListTableView.layer.borderWidth = 0.0f;
    self.chatListTableView.backgroundColor = UIColorFromR_G_B_A(245.0f, 245.0f, 245.0f, 1.0);
    self.chatListTableView.tipWhenEmpty = @"还没有聊天记录，快去找人搭讪吧!";
    self.chatListTableView.tipImageName = @"ChatListEmpty";
    
    /// 群组聊天列表.
    self.groupChatTableView.delegate = self;
    self.groupChatTableView.dataSource = self;
    self.groupChatTableView.layer.borderWidth = 0.0f;
    self.groupChatTableView.backgroundColor = UIColorFromR_G_B_A(245.0f, 245.0f, 245.0f, 1.0);
    self.groupChatTableView.tipWhenEmpty = @"还没有群聊消息，参与个计划试试!";
    self.groupChatTableView.tipImageName = @"GroupChatEmpty";
    
    /// 收藏的人列表.
    self.favoriteChatTableView.delegate = self;
    self.favoriteChatTableView.dataSource = self;
    self.favoriteChatTableView.layer.borderWidth = 0.0f;
    self.favoriteChatTableView.backgroundColor = UIColorFromR_G_B_A(245.0f, 245.0f, 245.0f, 1.0);
    self.favoriteChatTableView.tipWhenEmpty = @"还没有收藏过别人，看到喜欢的人就收了Ta吧!";
    self.favoriteChatTableView.tipImageName = @"FavorPeopleEmpty";
}

/// 初始化左右滚动视图.
- (void)initScrollView {
    self.scrollView.delegate = self;
}

/// 初始化左右滚动的方块.
- (void)initIndicatorView {
    self.indicatorView = [[UIView alloc] init];
    self.indicatorView.backgroundColor = UIColorFromRGBA(APP_COLOR, 1.0f);
    [self.tabBarView addSubview:self.indicatorView];
}

/// 初始化所有检测通知.
- (void)initNotificationObserver {
    /// 更新消息的通知.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateInitData)
                                                 name:NotificationInitData
                                               object:nil];
    /// 得到一个新的联系人的通知.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveChatAddContact)
                                                 name:NotificationReceiveChatMessageAddContact
                                               object:nil];
    /// 得到App重新激活的通知.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    /// 收到聊天消息的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveChatMessage:)
                                                 name:NotificationReceiveChatMessageAPN
                                               object:nil];
}

/// 更新左上角的菜单栏的消息.
- (void)updateInitData {
    NSInteger menuNumber = [LCChatManager sharedInstance].initialData.unreadChatNum + [LCChatManager sharedInstance].initialData.unreadMsgNum;
    if (menuNumber > 0) {
        UIImage *menuImage = [[UIImage imageNamed:@"NavigationMenuRedIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self.menuButtonItem setImage:menuImage];
    } else {
        UIImage *menuImage = [[UIImage imageNamed:@"NavigationMenuIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self.menuButtonItem setImage:menuImage];
    }
}

/// 别人给自己发信息，获取到添加联系人的通知.
- (void)receiveChatAddContact {
    /// 读取联系人列表.
    [self readChatContactList];
    /// 从Rest服务器获取联系人的其他信息.
    [self getChatListDataFromServer];
}

- (void)didReceiveChatMessage:(NSNotification *)notif{
    if (self.isAppearing) {
        [self readUnreadMsgCount];
        /// 收到未读消息的推送，有可能增加了联系人，去Server获取多余的联系人信息
        /// 从Rest服务器获取联系人的其他信息.
        
        BOOL alreadyHaveTheNotifyContact = NO;
        NSDictionary *userInfo = notif.userInfo;
        if (userInfo && [[userInfo allKeys] containsObject:@"J"]) {
            NSString *jid = [LCStringUtil getNotNullStr:[userInfo objectForKey:@"J"]];
            for (XMPPMessageArchiving_Contact_CoreDataObject *contact in chatLocalContactList) {
                if ([LCStringUtil isNotNullString:contact.bareJidStr]
                    && [contact.bareJidStr isEqualToString:jid])
                {
                    alreadyHaveTheNotifyContact = YES;
                    break;
                }
            }
        }
        if (!alreadyHaveTheNotifyContact) {
            [self getChatListDataFromServer];
        }
    }
}

/// 初始化视图控制器的变量.
- (void)initVaribaleValue {
    /// 选择第一个Tab.
    currentIndex = 0;
    
    self.unreadMsgNumFromServerDic = [[NSMutableDictionary alloc]initWithCapacity:0];
}

/// 更新页面的约束条件.
- (void)updateConstraint {
    /// 第一个Tab的宽度.
    self.firstTabWidthConstraint.constant = DEVICE_WIDTH / 3.0f;
    /// 第二个Tab的宽度.
    self.secondTabWidthConstraint.constant = DEVICE_WIDTH / 3.0f;
    /// 最近聊天列表的宽度.
    self.chatTableViewWidthConstraint.constant = DEVICE_WIDTH;
    /// 群聊列表的宽度.
    self.groupTableViewWidthConstraint.constant = DEVICE_WIDTH;
    /// 喜欢的人列表的宽度.
    self.favoriteTableViewConstraint.constant = DEVICE_WIDTH;
}

/// 如果是菜单显示菜单页，如果分享计划过来，则返回.
- (IBAction)menuButtonItemAction:(id)sender {
    switch (self.type) {
        case COMEIN_CHAT_LIST_MENU:
            [LCSlideVC showMenu];
            break;
        case COMEIN_CHAT_LIST_SHARE:
            [self.navigationController popViewControllerAnimated:APP_ANIMATION];
            break;
        default:
            break;
    }
}

/// 从Core Data中查询联系人列表.
- (void)readChatContactList {
    /// 需要在主线程查询Core Data数据.
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(readChatContactList)
                               withObject:nil
                            waitUntilDone:NO];
        return;
    }
    /// 本地联系人信息列表.
    chatLocalContactList = [LCXMPPUtil loadRecentChatContact:CHAT_CONTACT_ALL];
    NSMutableDictionary *contactDic = [[NSMutableDictionary alloc] init];
    for (XMPPMessageArchiving_Contact_CoreDataObject *contact in chatLocalContactList) {
        [contactDic setObject:contact forKey:contact.bareJidStr];
    }
    /// 本地联系人根据JID的字典.
    chatContactDic = [[NSDictionary alloc] initWithDictionary:contactDic];
}

/// 本地读取喜欢人的列表.
- (void)readFavoriteList {
    favoriteList = [[LCChatManager sharedInstance] getFavoriteArr];
//    [self.favoriteChatTableView reloadData];
}

/// 从服务器上获取联系人的信息.
- (void)getChatListDataFromServer {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (XMPPMessageArchiving_Contact_CoreDataObject *contact in chatLocalContactList) {
        if ([LCStringUtil isNotNullString:contact.bareJidStr]
            //&& [LCStringUtil isNotNullString:contact.contactType]
            ) {
            NSString *type = @"0";
            if ([LCStringUtil isNullString:contact.contactType]) {
                type = @"0";
            }else if (CHAT_CONTACT_ALL == [contact.contactType intValue]) {
                type = @"0";
            }else if (CHAT_CONTACT_FAVOR == [contact.contactType intValue] ||
                CHAT_CONTACT_PRIVATE_CHAT == [contact.contactType intValue]) {
                type = @"1";
            } else if (CHAT_CONTACT_PARTNER == [contact.contactType intValue]) {
                type = @"2";
            } else if (CHAT_CONTACT_RECEPTION == [contact.contactType intValue]) {
                type = @"3";
            }
            NSDictionary *dic = @{@"JID":contact.bareJidStr,
                                  @"Type":type};
            [arr addObject:dic];
        }
    }
    
    NSString *str = [LCStringUtil getJsonStrFromArray:arr];
    LCChatApi *api = [[LCChatApi alloc] initWithDelegate:self];
    [api getChatContacts:str];
}

/// 获取收藏人的列表.
- (void)getFavoriteListFromServer {
    LCUserApi *api = [[LCUserApi alloc] initWithDelegate:self];
    [api favorUserList];
}

/// 更新所有列表的数据源的数组信息，如果有更新本地数据库返回YES.
- (BOOL)refreshDataSource:(NSArray *)contacts {
    BOOL isChangeCoreData = NO;
    
    //根据chatLocalContactList（从CoreData中取出的用户列表顺序），对Server返回的用户详情进行排序
    //使得chatList顺序为最近聊天顺序
    NSMutableArray *serverContacts = [NSMutableArray arrayWithArray:contacts];
    NSMutableArray *sortedContacts = [[NSMutableArray alloc]initWithCapacity:0];
    for (XMPPMessageArchiving_Contact_CoreDataObject *localContact in chatLocalContactList){
        NSString *localJidStr = localContact.bareJidStr;
        
        for (id serverContact in serverContacts){
            NSString *serverJidStr = [[LCXMPPUtil getJIDFromUserOrPlan:serverContact] full];
            
            if ([LCStringUtil isNullString:serverJidStr]) {
                [serverContacts removeObject:serverContact];
                break;
            }else if([serverJidStr isEqualToString:localJidStr]){
                [sortedContacts addObject:serverContact];
                [serverContacts removeObject:serverContact];
                break;
            }else{
                continue;
            }
        }
    }
    //Roy 2015.1.14
    //Bug: 删除App期间收到聊天，重新安装登录后，显示红点，但聊天列表里没有会话
    //Server返回的,本地数据库中没有的contact拼到最后
    [sortedContacts addObjectsFromArray:serverContacts];
    chatList = sortedContacts;
    
    /// 保存最新的联系人信息到缓存.
    [[LCDataManager sharedInstance] saveChatList:chatList];
    NSMutableArray *groupArr = [[NSMutableArray alloc] init];
    for (id obj in chatList) {
        if ([obj isKindOfClass:[LCUserInfo class]]) {
            LCUserInfo *user = (LCUserInfo *)obj;
            XMPPMessageArchiving_Contact_CoreDataObject *contact = [chatContactDic objectForKey:user.openfireAccount];
            if (!contact) {
                [LCXMPPUtil saveChatContact:user withType:CHAT_CONTACT_PRIVATE_CHAT];
                isChangeCoreData = YES;
            }
        }
        if ([obj isKindOfClass:[LCPlan class]])
        {
            LCPlan *plan = (LCPlan *)obj;
            [groupArr addObject:plan];
            XMPPMessageArchiving_Contact_CoreDataObject *contact = [chatContactDic objectForKey:plan.roomID];
            if (!contact) {
                [LCXMPPUtil saveChatPlanGroup:plan];
                isChangeCoreData = YES;
            }
        }
    }
    groupList = [[NSArray alloc] initWithArray:groupArr];
    return isChangeCoreData;
}

/// 重新列表内容.
- (void)reloadTableView {
    [self.chatListTableView reloadData];
    [self.groupChatTableView reloadData];
//    [self.favoriteChatTableView reloadData];
}


#pragma mark - Network Request
/// 读取每个联系人未读消息的个数.
- (void)readUnreadMsgCount {
    NSString *telephone = [LCDataManager sharedInstance].userInfo.telephone;
    LCChatApi *api = [[LCChatApi alloc] initWithDelegate:self];
    [api getUnreadMsgCountList:telephone];
}

#pragma mark - LCChatApi Delegate
/// 从服务器获取了联系人的列表
- (void)chatApi:(LCChatApi *)api didGetChatContacts:(NSArray *)contacts withError:(NSError *)error {
    if (!error) {
        /// 本地没有的联系人会新建联系人.
        BOOL isChangeCoreData = [self refreshDataSource:contacts];
        /// 如果更新了本地联系人，重新获取本地的联系人.
        if (isChangeCoreData) {
            [self readChatContactList];
        }
    }
    [self reloadTableView];
}

/// 获取未读消息数.
- (void)chatApi:(LCChatApi *)api didGetChatUnreadMsgCountList:(NSDictionary *)dic withError:(NSError *)error {
    NSMutableDictionary *mutDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    self.unreadMsgNumFromServerDic = mutDic;
    [self.chatListTableView reloadData];
    [self.groupChatTableView reloadData];
    [self.favoriteChatTableView reloadData];
}

#pragma mark - LCUserApi delegate
- (void)userApi:(LCUserApi *)userApi didGetFavorUserList:(NSArray *)userList withError:(NSError *)error {
    if (!error) {
        favoriteList = userList;
        [[LCChatManager sharedInstance] saveFavoriteArr:favoriteList];
        [self.favoriteChatTableView reloadData];
    }
}

#pragma mark - UITableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"ChatListCell";
    NSArray *contactArr = [[NSArray alloc] init];
    LCChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [[LCChatListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.chatListTableView == tableView) {
        contactArr = chatList;
    } else if (self.groupChatTableView == tableView) {
        contactArr = groupList;
        cell.contentLabel.hidden = YES;
        cell.timeLabel.hidden = YES;
    } else if (self.favoriteChatTableView == tableView) {
        contactArr = favoriteList;
        cell.contentLabel.hidden = YES;
        cell.timeLabel.hidden = YES;
    }
    
    id obj = [contactArr objectAtIndex:indexPath.row];
    cell.cellObj = obj;
    cell.naviVC = self.navigationController;
    XMPPMessageArchiving_Contact_CoreDataObject *contact = nil;
    if ([obj isKindOfClass:[LCUserInfo class]]) {
        LCUserInfo *user = (LCUserInfo *)obj;
        cell.nameLabel.text = user.nick;
        cell.avatarImageView.imageURL = [NSURL URLWithString:user.avatarThumbUrl];
        contact = [chatContactDic objectForKey:user.openfireAccount];
    } else if ([obj isKindOfClass:[LCPlan class]]) {
        LCPlan *plan = (LCPlan *)obj;
        cell.nameLabel.text = plan.roomTitle;
        cell.avatarImageView.imageURL = [NSURL URLWithString:plan.roomAvatar];
        contact = [chatContactDic objectForKey:plan.roomID];
    }
    if (contact) {
        cell.contentLabel.text = contact.mostRecentMessageBody;
        cell.timeLabel.text = [LCDateUtil getMonthAndDateStrFromDate:contact.mostRecentMessageTimestamp];
        
        NSInteger unreadMsgCount = [[LCChatManager sharedInstance] getUnreadMsgNumOfBareJidStr:contact.bareJid.bare];
        if (self.unreadMsgNumFromServerDic && [[self.unreadMsgNumFromServerDic allKeys] containsObject:contact.bareJidStr]) {
            NSString *unreadMsgCountStr = [LCStringUtil getNotNullStr:[self.unreadMsgNumFromServerDic objectForKey:contact.bareJidStr]];
            unreadMsgCount += [unreadMsgCountStr intValue];
        }
        if (unreadMsgCount > 0) {
            cell.dotView.hidden = NO;
            
            if (unreadMsgCount > 99) {
                cell.numberHintLabel.text = @"99+";
            } else {
                cell.numberHintLabel.text = [LCStringUtil integerToString:unreadMsgCount];
            }
        }else {
            cell.dotView.hidden = YES;
            cell.numberHintLabel.text = 0;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatViewController *chatVC = nil;
    NSArray *arr = nil;
    if (self.chatListTableView == tableView) {
        arr = chatList;
    } else if (self.groupChatTableView == tableView) {
        arr = groupList;
    } else if (self.favoriteChatTableView == tableView) {
        arr = favoriteList;
    }
    if (nil != arr && arr.count > indexPath.row) {
        id obj = [arr objectAtIndex:indexPath.row];
        NSString *jidStr = nil;
        if ([obj isKindOfClass:[LCUserInfo class]]) {
            LCUserInfo *userInfo = (LCUserInfo *)obj;
            jidStr = userInfo.openfireAccount;
            chatVC = [[ChatViewController alloc] initWithUser:userInfo];
        } else if ([obj isKindOfClass:[LCPlan class]]) {
            LCPlan *plan = (LCPlan *)obj;
            jidStr = plan.roomID;
            chatVC = [[ChatViewController alloc] initWithPlan:plan];
        }
        
        if (nil != jidStr && nil != self.unreadMsgNumFromServerDic && [[self.unreadMsgNumFromServerDic allKeys] containsObject:jidStr]) {
            if (0 != [[self.unreadMsgNumFromServerDic objectForKey:jidStr] intValue]) {
                [self.unreadMsgNumFromServerDic setObject:@"0" forKey:jidStr];
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
        
        if (chatVC) {
            chatVC.planToSend = self.planToSend;
            chatVC.chatList = chatList;
            self.planToSend = nil;
            [self.navigationController pushViewController:chatVC animated:APP_ANIMATION];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    if (self.chatListTableView == tableView) {
        count = chatList.count;
    } else if (self.groupChatTableView == tableView) {
        count = groupList.count;
    } else if (self.favoriteChatTableView == tableView) {
        count = favoriteList.count;
    }
    return count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[UITableView class]]) {
        return;
    }
    int index = fabs(scrollView.contentOffset.x + DEVICE_WIDTH / 2.0f) / DEVICE_WIDTH;
    [self setChooseTableView:index];
}

/// 选择第几个列表.
- (void)setChooseTableView:(NSInteger)index {
    CGRect frame = [self getChooseIndicatorViewFrame:index];
    [UIView animateWithDuration:CHAT_INDICATOR_DURATION
                     animations:^{
                         self.indicatorView.frame = frame;
                     }
                     completion:nil
     ];

    self.scrollView.contentOffset = CGPointMake(index * DEVICE_WIDTH, 0);
    currentIndex = index;
    
    if (0 == index) {
        [self.chatListTableView reloadData];
        self.chatIconImageView.image = [UIImage imageNamed:@"ChatHistoryMessageIconHL"];
        self.groupIconImageView.image = [UIImage imageNamed:@"ChatGroupUserIcon"];
        self.favoriteIconImageView.image = [UIImage imageNamed:@"ChatFavoriteUserIcon"];
    } else if (1 == index) {
        [self.groupChatTableView reloadData];
        self.chatIconImageView.image = [UIImage imageNamed:@"ChatHistoryMessageIcon"];
        self.groupIconImageView.image = [UIImage imageNamed:@"ChatGroupUserIconHL"];
        self.favoriteIconImageView.image = [UIImage imageNamed:@"ChatFavoriteUserIcon"];
    } else if (2 == index) {
        [self.favoriteChatTableView reloadData];
        self.chatIconImageView.image = [UIImage imageNamed:@"ChatHistoryMessageIcon"];
        self.groupIconImageView.image = [UIImage imageNamed:@"ChatGroupUserIcon"];
        self.favoriteIconImageView.image = [UIImage imageNamed:@"ChatFavoriteUserIconHL"];
    }
}

/// 获取黄色方块的位置.
- (CGRect)getChooseIndicatorViewFrame:(NSInteger)index {
    CGRect frame = CGRectZero;
    frame.origin.x = index * DEVICE_WIDTH / 3.0f;
    frame.origin.y = self.tabBarView.frame.size.height - 3;
    frame.size.width = DEVICE_WIDTH / 3.0f;
    frame.size.height = 3;
    self.indicatorView.frame = frame;
    return frame;
}

/// 选择最近聊天列表.
- (IBAction)chatListAction:(id)sender {
    [self setChooseTableView:0];
}

/// 选择群聊列表.
- (IBAction)groupListAction:(id)sender {
    [self setChooseTableView:1];
}

/// 选择收藏的人列表.
- (IBAction)favoriteListAction:(id)sender {
    [self setChooseTableView:2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
