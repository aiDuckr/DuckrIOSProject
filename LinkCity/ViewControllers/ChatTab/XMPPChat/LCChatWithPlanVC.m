//
//  LCChatWithPlanVC.m
//  LinkCity
//
//  Created by roy on 3/18/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCChatWithPlanVC.h"
#import "LCUserModel.h"
#import "UIResponder+Router.h"

@interface LCChatWithPlanVC ()
@property (nonatomic, strong) LCPlanModel *plan;
@property (nonatomic, strong) UIImageView *headerPlanAvatarImageView;
@property (nonatomic, strong) UILabel *headerPlanTitleLabel;
@end

@implementation LCChatWithPlanVC

- (void)commonInit{
    [super commonInit];
    self.tableViewTopGap = 114;
}

- (instancetype)initWithPlan:(LCPlanModel *)plan{
    self = [super init];
    if (self) {
        self.plan = plan;
        self.chatWithJidStr = self.plan.roomId;
        self.isGroupChat = YES;
        self.headImageURL = [LCDataManager sharedInstance].userInfo.avatarThumbUrl;
        self.planOrGroupGuid = self.plan.planGuid;
        [self updateXMPPRoomUserDic];
        
        //如果Room已经上线了，使用相应的XMPPRoom
        NSArray *onlineXMPPRooms = [LCXMPPMessageHelper sharedInstance].onlineXMPPRoomArray;
        for (XMPPRoom *room in onlineXMPPRooms){
            if ([room.roomJID.bare isEqualToString:self.plan.roomId]) {
                self.xmppRoom = room;
                break;
            }
        }
        //如果Room还未上线，创建一个新Room并上线
        if (!self.xmppRoom) {
            self.xmppRoom = [[LCXMPPMessageHelper sharedInstance] getRoomOnlineWithRoomBareJid:self.plan.roomId];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addObserveToNotificationNameToRefreshData:URL_JOIN_PLAN];
    [self addObserveToNotificationNameToRefreshData:URL_QUIT_PLAN];
    [self addObserveToNotificationNameToRefreshData:NotificationDidReceiveXMPPChatMessage];
    [self addObserveToNotificationNameToRefreshData:NotificationDidReceiveXMPPGroupMessage];
    [self addObserveToNotificationNameToRefreshData:NotificationDidReceiveXMPPMessage];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:NotificationDidReceiveXMPPGroupMessage object:nil];
    
    UIBarButtonItem *planInfoBarButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"GroupInfoIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(barButtonAction)];
    self.navigationItem.rightBarButtonItem = planInfoBarButton;
    
    [self addHeaderPlanView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)refreshData{
    [LCNetRequester getPlanDetailFromPlanGuid:self.plan.planGuid callBack:^(LCPlanModel *plan,NSArray * tourpicArray, NSError *error) {
        if (!error) {
            self.plan = plan;
            
            //更新本地的聊天会话model
            LCChatContactModel *chatContactModel = [LCChatContactModel chatContactModelWithPlan:plan];
            [[LCDataManager sharedInstance].chatContactDic setObject:chatContactModel forKey:[chatContactModel getBareJidString]];
            
            [self updateXMPPRoomUserDic];
            [self updateShow];
        }else{
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
            
            if (error.code == ErrCodePlanNotExist) {
                //计划不存在
                
                //下线群聊
                [[LCXMPPMessageHelper sharedInstance] getRoomOfflineWithRoomBareJid:self.plan.roomId];
                
                //删除聊天记录和通讯录和红点
                NSString *bareJidStr = self.plan.roomId;
                [LCXMPPUtil deleteChatMsg:bareJidStr];
                [LCXMPPUtil deleteChatContact:bareJidStr];
                [[LCDataManager sharedInstance] clearUnreadNumForBareJidStr:bareJidStr];
                [self.navigationController popViewControllerAnimated:YES];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationJustDeleteChat object:nil];
            }
        }
    }];
}

- (void)addHeaderPlanView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAVIGATION_BAR_HEIGHT, DEVICE_WIDTH, 50)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    self.headerPlanAvatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 6, 48, 38)];
    self.headerPlanAvatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headerPlanAvatarImageView.layer.cornerRadius = 3;
    self.headerPlanAvatarImageView.layer.masksToBounds = YES;
    [self.headerPlanAvatarImageView setImageWithURL:[NSURL URLWithString:self.plan.roomAvatar] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
    [headerView addSubview:self.headerPlanAvatarImageView];
    
    self.headerPlanTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15+48+8, 10, DEVICE_WIDTH - 110, 15)];
    [self.headerPlanTitleLabel setFont:[UIFont fontWithName:FONT_LANTINGBLACK size:15]];
    [self.headerPlanTitleLabel setTextColor:UIColorFromRGBA(LCLightTextColor, 1)];
    self.headerPlanTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.headerPlanTitleLabel.numberOfLines = 1;
    [headerView addSubview:self.headerPlanTitleLabel];
    CGPoint titleCenter = self.headerPlanTitleLabel.center;
    titleCenter.y = 25;
    self.headerPlanTitleLabel.center = titleCenter;
    
    UIImageView *rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TableRightArrow"]];
    [headerView addSubview:rightArrow];
    rightArrow.center = CGPointMake(DEVICE_WIDTH-15-rightArrow.frame.size.width/2, 25);
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, DEVICE_WIDTH, 0.5)];
    bottomLine.backgroundColor = UIColorFromRGBA(LCBottomLineColor, 1);
    [headerView addSubview:bottomLine];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:headerView.bounds];
    [btn addTarget:self action:@selector(planButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor clearColor];
    [headerView addSubview:btn];
    
    [self.view addSubview:headerView];
}

- (void)updateShow{
    [super updateShow];
    
    //Roy: 在成员页刚加入计划时，返回的计划里不存在新加入的人，会导致跳出，先不做
    //[self popOutIfUserIsNotMemberOfPlan];
    
    self.title = [LCStringUtil getNotNullStr: self.plan.roomTitle];
    [self.headerPlanAvatarImageView setImageWithURL:[NSURL URLWithString:self.plan.roomAvatar] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
    [self.headerPlanTitleLabel setText:[LCStringUtil getNotNullStr:self.plan.roomTitle]];
    [self.tableView reloadData];
}

//Override
- (void)sendGroupChatToServer:(MessageModel *)model{
    //如果当前用户是聊天室成员，发送消息，否则toast
    if (self.plan.isMember) {
        [super sendGroupChatToServer:model];
    }else{
        [YSAlertUtil tipOneMessage:@"您不在当前邀约中，发送失败" yoffset:TipAboveKeyboardYoffset delay:TipErrorDelay];
    }
}

- (void)updateXMPPRoomUserDic{
    for (LCUserModel *user in self.plan.memberList){
        [self.xmppRoomUserDic setObject:user forKey:user.telephone];
    }
    
    [self updateMessageModelsWithNewUserInfo];
}

- (void)barButtonAction{
    [LCViewSwitcher pushToShowPlanMemberVCForPlan:self.plan on:self.navigationController];
}

- (void)planButtonAction{
    [LCViewSwitcher pushToShowPlanDetailVCForPlan:self.plan recmdUuid:nil on:self.navigationController];
}

- (void)popOutIfUserIsNotMemberOfPlan{
    BOOL amIPlanMember = NO;
    for (LCUserModel *aUser in self.plan.memberList) {
        if ([aUser.telephone isEqualToString:[LCDataManager sharedInstance].userInfo.telephone]) {
            amIPlanMember = YES;
            break;
        }
    }
    
    if (!amIPlanMember) {
        //本人不在计划内
        [YSAlertUtil tipOneMessage:@"您不是该邀约的成员" yoffset:TipDefaultYoffset delay:TipErrorDelay];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)notificationAction:(NSNotification *)notification{
    if ([notification.name isEqualToString:NotificationDidReceiveXMPPGroupMessage]) {
        XMPPMessage *message = [notification.userInfo objectForKey:XMPPMessageKey];
        //收到该Room的消息，并且不是自己发的，进行显示
        if ([message.from.bare isEqualToString:self.chatWithJidStr] &&
            ![message.from.resource isEqualToString:[LCDataManager sharedInstance].userInfo.telephone]) {
            NSString *info = message.info;
            if ([LCStringUtil isNotNullString:info]) {
                [self didReceiveGroupMessage:message senderTelephone:message.from.resource];
            }
        }
    }
}

- (void)didReceiveGroupMessage:(XMPPMessage *)message senderTelephone:(NSString *)senderTelephone{
    LCUserModel *userInfo = [self.xmppRoomUserDic objectForKey:senderTelephone];
    if (!userInfo) {
        //如果当前计划中没有该成员，有可能新加入计划的人或已经退出计划的人，发送的聊天信息
        //更新计划信息
        [self getUserInfoByTelephone:senderTelephone];
    }
    
    MessageModel *model = [LCMessageConvert getEMMessageFromJsonStr:message.info];
    model.senderTelephone = [LCStringUtil getNotNullStr:model.senderTelephone];
    
    model.content = message.body;
    model.isSender = NO;
    model.isChatGroup = YES;
    model.headImageURL = [NSURL URLWithString:userInfo.avatarThumbUrl];
    model.username = userInfo.nick;
    model.sendDate = [message sendDate];
    [self addMessageModelToDataSource:model];
    [self updateTableView];
}


/// 用户点击聊天信息，查看详情.
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    [super routerEventWithName:eventName userInfo:userInfo];
}

@end
