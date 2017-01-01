//
//  LCChatWithUserVC.m
//  LinkCity
//
//  Created by roy on 3/18/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCChatWithUserVC.h"
#import "LCUserInfoMoreVC.h"

@interface LCChatWithUserVC ()

@end

@implementation LCChatWithUserVC

- (instancetype)initWithUser:(LCUserModel *)user{
    self = [super init];
    if (self) {
        self.chatWithUser = user;
        self.chatWithJidStr = self.chatWithUser.openfireAccount;
        self.isGroupChat = NO;
        self.headImageURL = self.chatWithUser.avatarThumbUrl;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:NotificationDidReceiveXMPPChatMessage object:nil];
    
    UIBarButtonItem *moreBarButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"ChatWithUserMore"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(moreBarButtonAction)];
    self.navigationItem.rightBarButtonItem = moreBarButton;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self.navigationController.navigationBar setTintColor:DefaultDuckrYellowColor];
    
}

- (void)updateShow{
    [super updateShow];
    
    self.title = [LCStringUtil getNotNullStr: self.chatWithUser.nick];
}

- (void)moreBarButtonAction{
    LCUserInfoMoreVC *userInfoMoreVC = [LCUserInfoMoreVC createInstance];
    userInfoMoreVC.user = self.chatWithUser;
    [self.navigationController pushViewController:userInfoMoreVC animated:APP_ANIMATION];
}


- (void)notificationAction:(NSNotification *)notification{
    if ([notification.name isEqualToString:NotificationDidReceiveXMPPChatMessage]) {
        XMPPMessage *msg = [notification.userInfo objectForKey:XMPPMessageKey];
        if ([msg.to.bare isEqual:[LCDataManager sharedInstance].userInfo.openfireAccount] &&
            [msg.from.bare isEqualToString:self.chatWithJidStr]) {
            //收到当前聊天的消息，进行显示
            if ([LCStringUtil isNotNullString:msg.info]) {
                MessageModel *model = [LCMessageConvert getEMMessageFromJsonStr:msg.info];
                model.content = msg.body;
                model.isSender = NO;
                model.headImageURL = [NSURL URLWithString:self.chatWithUser.avatarThumbUrl];
                model.sendDate = [msg sendDate];
                [self addMessageModelToDataSource:model];
                [self updateTableView];
            }
        }
    }
}



@end
