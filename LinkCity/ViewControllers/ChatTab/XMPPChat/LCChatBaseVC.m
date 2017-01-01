//
//  LCChatVC.m
//  LinkCity
//
//  Created by roy on 3/18/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCChatBaseVC.h"
#import "LCPickOneImageHelper.h"
#import "LinkCity-Swift.h"
#import "RecordAudio.h"



@interface LCChatBaseVC ()<DXMessageToolBarDelegate,DXChatBarMoreViewDelegate,LocationViewDelegate,MessageModelDelegate, RecordAudioDelegate>

@property (nonatomic, strong) RecordAudio *recordAudio;
@property (nonatomic, strong) NSData *audioData;
@end

@implementation LCChatBaseVC

- (void)commonInit{
    [super commonInit];
    self.tableViewTopGap = 64;
}

- (NSMutableDictionary *)xmppRoomUserDic{
    if (!_xmppRoomUserDic) {
        _xmppRoomUserDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return _xmppRoomUserDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.msgModelArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self initMsgToolBar];
    [self initTableView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tapGesture];
    [self.tableView.panGestureRecognizer addTarget:self action:@selector(tableViewPanAction:)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    
    [self loadRecentChatMsg:nil];
    
    self.view.backgroundColor = UIColorFromRGBA(LCViewBackGroundColor, 1);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
    [self updateShow];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[LCDataManager sharedInstance] clearUnreadNumForBareJidStr:self.chatWithJidStr];
    [self.view endEditing:YES];
}


- (void)initMsgToolBar{
    self.msgToolBar = [[DXMessageToolBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - [DXMessageToolBar defaultHeight], self.view.frame.size.width, [DXMessageToolBar defaultHeight])];
    self.msgToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
    self.msgToolBar.delegate = self;
    
    self.msgToolBar.moreView = [[DXChatBarMoreView alloc] initWithFrame:CGRectMake(0, (kVerticalPadding * 2 + kInputTextViewMinHeight), self.msgToolBar.frame.size.width, 115)];
    self.msgToolBar.moreView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    /// 将self注册为chatToolBar的moreView的代理
    if ([self.msgToolBar.moreView isKindOfClass:[DXChatBarMoreView class]]) {
        [(DXChatBarMoreView *)self.msgToolBar.moreView setDelegate:self];
    }
    
    
    DXFaceView *faceView = [[DXFaceView alloc] initWithFrame:CGRectMake(0, (kVerticalPadding * 2 + kInputTextViewMinHeight), self.msgToolBar.frame.size.width, 215)];
    faceView.delegate = self.msgToolBar;
    self.msgToolBar.faceView = faceView;
    self.msgToolBar.faceView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    DXRecordView *recordView = [[DXRecordView alloc] initWithFrame:CGRectMake((DEVICE_WIDTH-180)/2.0, (DEVICE_HEIGHT-180)/2.0, 180, 180)];
    self.msgToolBar.recordView = recordView;
    self.msgToolBar.recordView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    self.msgToolBar.recordView.backgroundColor = [UIColor clearColor];
    
    
    [self.view addSubview:self.msgToolBar];
}
- (void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.tableViewTopGap, self.view.frame.size.width, self.view.frame.size.height - self.tableViewTopGap - self.msgToolBar.frame.size.height) style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;

    [self.tableView registerNib:[UINib nibWithNibName:[LCSharedFuncUtil classNameOfClass:[LCChatTimeCell class]] bundle:nil] forCellReuseIdentifier:[LCSharedFuncUtil classNameOfClass:[LCChatTimeCell class]]];
    [self.tableView registerNib:[UINib nibWithNibName:[LCSharedFuncUtil classNameOfClass:[LCChatSysInfoCell class]] bundle:nil] forCellReuseIdentifier:[LCSharedFuncUtil classNameOfClass:[LCChatSysInfoCell class]]];
    [self.tableView registerNib:[UINib nibWithNibName:[LCSharedFuncUtil classNameOfClass:[LCChatMsgLeftCell class]] bundle:nil] forCellReuseIdentifier:[LCSharedFuncUtil classNameOfClass:[LCChatMsgLeftCell class]]];
    [self.tableView registerNib:[UINib nibWithNibName:[LCSharedFuncUtil classNameOfClass:[LCChatMsgRightCell class]] bundle:nil] forCellReuseIdentifier:[LCSharedFuncUtil classNameOfClass:[LCChatMsgRightCell class]]];
    /// 设置上下拉刷新，可以刷新更多聊天内容.
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh) dateKey:@"table"];
    [self.view addSubview:self.tableView];
}

- (void)updateShow{
    
}


#pragma mark ButtonAction
- (void)tapAction:(id)sender{
    [self.view endEditing:YES];
    [self.msgToolBar endEditing:YES];
}
- (void)tableViewPanAction:(id)sender{
    [self.view endEditing:YES];
    [self.msgToolBar endEditing:YES];
}


#pragma mark UITableView
- (void)updateTableView {
    [self.tableView reloadData];
    [self scrollViewToBottom:YES];
}
/// 滚动列表显示到最底端.
- (void)scrollViewToBottom:(BOOL)animated {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.tableView.contentSize.height > self.tableView.frame.size.height) {
            CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
            [self.tableView setContentOffset:offset animated:animated];
        }
    });
}

- (void)headerRefresh{
    for (id obj in self.msgModelArray){
        if ([obj isKindOfClass:[MessageModel class]]) {
            MessageModel *msgModel = (MessageModel *)obj;
            if (msgModel.sendDate) {
                [self loadRecentChatMsg:msgModel.sendDate];
                break;
            }
        }
    }
    [self.tableView headerEndRefreshing];
}

#pragma mark UITableView Delegate & DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowNum = 0;
    if (self.msgModelArray) {
        rowNum = self.msgModelArray.count;
    }
    return rowNum;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    
    
    if (indexPath.row < [self.msgModelArray count]) {
        id obj = [self.msgModelArray objectAtIndex:indexPath.row];
        if ([obj isKindOfClass:[NSString class]]) {
            /// 显示聊天时间.
            LCChatTimeCell *timeCell = [tableView dequeueReusableCellWithIdentifier:[LCSharedFuncUtil classNameOfClass:[LCChatTimeCell class]]];
            timeCell.timeLabel.text = (NSString *)obj;
            cell = timeCell;
        } else {
            /// 显示聊天内容.
            MessageModel *model = (MessageModel *)obj;
            if (model.type == eMessageBodyType_System) {
                LCChatSysInfoCell *sysCell = [tableView dequeueReusableCellWithIdentifier:[LCSharedFuncUtil classNameOfClass:[LCChatSysInfoCell class]] forIndexPath:indexPath];
                sysCell.sysInfoLabel.text = [LCStringUtil getNotNullStr:model.content];
                cell = sysCell;
            }else{
                if (model.isSender) {
                    LCChatMsgRightCell *msgCell = [tableView dequeueReusableCellWithIdentifier:[LCSharedFuncUtil classNameOfClass:[LCChatMsgRightCell class]] forIndexPath:indexPath];
                    msgCell.msgModel = model;
                    cell = msgCell;
                }else{
                    LCChatMsgLeftCell *msgCell = [tableView dequeueReusableCellWithIdentifier:[LCSharedFuncUtil classNameOfClass:[LCChatMsgLeftCell class]] forIndexPath:indexPath];
                    msgCell.msgModel = model;
                    cell = msgCell;
                }
            }
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}







#pragma mark XMPP
/// 从CoreData里面读取聊天记录信息.
- (void)loadRecentChatMsg:(NSDate *)fromDate {
    __block NSInteger currentCount = self.msgModelArray.count;
    NSArray *messageArr = [LCXMPPUtil loadRecentChatMsg:self.chatWithJidStr isGroup:self.isGroupChat fromDate:fromDate];
    /// 将加载的聊天记录信息添加到聊天列表对应的列表中.
    if (self.isGroupChat) {
        messageArr = [self getGroupMessageModelArrayFromCoreDataArray:messageArr];
    } else {
        messageArr = [self getPtoPMessageModelArrayFromCoreDataArray:messageArr];
    }
    
    if (messageArr && messageArr.count > 0) {
        messageArr = [messageArr arrayByAddingObjectsFromArray:self.msgModelArray];
        self.msgModelArray = [[NSMutableArray alloc] initWithArray:messageArr];
    }
    
    [self addTimeLineToWholeDataSource];
    [self.tableView reloadData];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.msgModelArray && self.msgModelArray.count>0) {
            /// 滚到刚加载的信息列表的最后一条.
            NSInteger rowIndex = [self.msgModelArray count] - currentCount - 1;
            rowIndex = rowIndex < 0 ? 0 : rowIndex;
            rowIndex = rowIndex >= self.msgModelArray.count ? self.msgModelArray.count-1 : rowIndex;
            
            
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rowIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
    });
}
/// convert 数据库获取单聊的聊天记录 to MessageModel
- (NSArray *)getPtoPMessageModelArrayFromCoreDataArray:(NSArray *)messageArr {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (XMPPMessageArchiving_Message_CoreDataObject *message in messageArr) {
        MessageModel *model = [LCMessageConvert getEMMessageFromJsonStr:message.info];
        model.content = message.body;
        model.sendDate = message.timestamp;
        model.isChatGroup = NO;
        if (message.isOutgoing) {
            model.isSender = YES;
            model.headImageURL = [NSURL URLWithString:[LCDataManager sharedInstance].userInfo.avatarThumbUrl];
            model.username = [LCDataManager sharedInstance].userInfo.nick;
        } else {
            model.isSender = NO;
            model.headImageURL = [NSURL URLWithString:self.headImageURL];
        }
        [arr addObject:model];
    }
    return arr;
}
/// convert CoreData里面读取群的聊天记录 to MessageModel
- (NSArray *)getGroupMessageModelArrayFromCoreDataArray:(NSArray *)msgArr {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (XMPPMessageArchiving_Message_CoreDataObject *message in msgArr) {
        MessageModel *model = [LCMessageConvert getEMMessageFromJsonStr:message.info];
        model.content = message.body;
        model.sendDate = message.timestamp;
        model.isChatGroup = YES;
        if (NO == message.isOutgoing) {
            model.senderTelephone = [LCStringUtil getNotNullStr:model.senderTelephone];
            if ([model.senderTelephone isEqualToString:[LCDataManager sharedInstance].userInfo.telephone]) {
                model.isSender = YES;
            } else {
                model.isSender = NO;
            }
            LCUserModel *user = [self.xmppRoomUserDic objectForKey:model.senderTelephone];
            if (user) {
                //如果有该用户信息，进行显示
                model.headImageURL = [NSURL URLWithString:user.avatarThumbUrl];
                model.username = user.nick;
            }else{
                //如果没有
                //在子类中updateMessageModelsWithNewUserInfo 的时候，会对没有信息的用户去网上取，并更新显示
                [self getUserInfoByTelephone:model.senderTelephone];
            }
        }
        [arr addObject:model];
    }
    return arr;
}



#pragma mark - DataSource Control
- (void)addTimeLineToWholeDataSource{
    if (self.msgModelArray && self.msgModelArray.count>0) {
        for (int i=1; i<self.msgModelArray.count; i++) {
            if ([[self.msgModelArray objectAtIndex:i] isKindOfClass:[MessageModel class]] &&
                [[self.msgModelArray objectAtIndex:i-1] isKindOfClass:[MessageModel class]]) {
                MessageModel *curModel = [self.msgModelArray objectAtIndex:i];
                MessageModel *formerModel = [self.msgModelArray objectAtIndex:i-1];
                if (curModel.sendDate && formerModel.sendDate) {
                    NSTimeInterval messageSendTimeInterval = [curModel.sendDate timeIntervalSinceDate:formerModel.sendDate];
                    if (messageSendTimeInterval > THRESHHOLD_MESSAGE_TIME_INTERVAL) {
                        NSString *dateStr = [LCXMPPUtil getMessagteDateStringFromDate:curModel.sendDate];
                        [self.msgModelArray insertObject:dateStr atIndex:i];
                        i++;
                    }
                }
            }
        }
    }
}
- (void)addMessageModelToDataSource:(MessageModel *)messageModel{
    if (self.msgModelArray && self.msgModelArray.count>0 &&
        [[self.msgModelArray lastObject] isKindOfClass:[MessageModel class]])
    {
        MessageModel *formerModel = [self.msgModelArray lastObject];
        if (messageModel.sendDate && formerModel.sendDate) {
            NSTimeInterval messageSendTimeInterval = [messageModel.sendDate timeIntervalSinceDate:formerModel.sendDate];
            if (messageSendTimeInterval > THRESHHOLD_MESSAGE_TIME_INTERVAL) {
                NSString *dateStr = [LCXMPPUtil getMessagteDateStringFromDate:messageModel.sendDate];
                [self.msgModelArray addObject:dateStr];
            }
        }
    }
    [self.msgModelArray addObject:messageModel];
    
    
    if (self.msgModelArray.count > MAX_MESSAGE_NUM_THRESHOLD_WHEN_CHATING) {
        NSArray *subDataSource = [self.msgModelArray subarrayWithRange:NSMakeRange(self.msgModelArray.count-MESSSAGE_NUM_TO_RESERVE_AFTER_OPTIMIZE, MESSSAGE_NUM_TO_RESERVE_AFTER_OPTIMIZE)];
        self.msgModelArray = [NSMutableArray arrayWithArray:subDataSource];
        [self.tableView reloadData];
    }
}


#pragma mark - Send Message
/// 如果有分享过来的计划，自动发送.
//- (void)sendPendingMessages{
//    if (self.planToSend) {
//        [self sendChatPlan:self.planToSend];
//        self.planToSend = nil;
//    }
//    if (self.locationToSend) {
//        [self sendLocation:self.locationToSend];
//        self.locationToSend = nil;
//    }
//}
//- (void)sendSelfInfoToGroupChat{
//    NSString *selfInfo = [NSString stringWithFormat:@"%@ 加入了群聊",[LCDataManager sharedInstance].userInfo.nick];
//    MessageModel * model = [self sendChatTextInView:selfInfo];
//    model.content = selfInfo;
//    [self sendGroupChatToServer:model];
//}

/// 发送单聊的信息.
- (void)sendChatToServer:(MessageModel *)model {
    model.sendDate = [NSDate date];
    
    LCUserModel *userInfo = [LCDataManager sharedInstance].userInfo;
    NSString *infoStr = [LCMessageConvert getJsonStrFromEMMessage:model];
    
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:model.content];
    /// 生成XML消息文档.
    NSXMLElement *mes = [NSXMLElement elementWithName:@"message"];
    /// 消息类型.
    [mes addAttributeWithName:@"type" stringValue:@"chat"];
    /// 发送给谁.
    [mes addAttributeWithName:@"to" stringValue:self.chatWithJidStr];
    /// 由谁发送.
    [mes addAttributeWithName:@"from" stringValue:userInfo.openfireAccount];
    /// 消息的Json数据.
    [mes addAttributeWithName:@"info" stringValue:infoStr];
    [mes addChild:body];
    
    /// 发送消息.
    [[LCXMPPMessageHelper sharedInstance].xmppStream sendElement:mes];
    
    [self updateTableView];
}

- (void)sendGroupChatToServer:(MessageModel *)model {
    model.sendDate = [NSDate date];
    
    NSString *info = [LCMessageConvert getJsonStrFromEMMessage:model];
    [self.xmppRoom sendMessageWithBody:model.content withInfo:info];
    
    [self updateTableView];
}


#pragma mark - LCTextMessageToolBarDelegate
/// 发送文字聊天，单聊和群聊.
- (void)didSendText:(NSString *)text {
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (text && text.length > 0) {
        MessageModel * model = [self createMessageModelForText:text];
        if (!self.isGroupChat) {
            /// 生成info发送.
            [self sendChatToServer:model];
        } else {
            model.content = text;
            [self sendGroupChatToServer:model];
        }
    }
}

/// 在聊天列表中显示发送的文字信息.
- (MessageModel *)createMessageModelForText:(NSString *)text {
    LCUserModel *userInfo = [LCDataManager sharedInstance].userInfo;
    MessageModel *model = [[MessageModel alloc] init];
    model.type = eMessageBodyType_Text;
    model.content = text;
    model.isSender = YES;
    model.headImageURL = [NSURL URLWithString:userInfo.avatarThumbUrl];
    model.sendDate = [NSDate date];
    [self addMessageModelToDataSource:model];
    return model;
}

/// 发送计划聊天，单聊和群聊.
- (void)sendChatPlan:(LCPlanModel *)plan{
    NSString *text = @"[旅行计划]";
    MessageModel *model = [self getMessageModelFromPlan:plan text:text];
    if (!self.isGroupChat) {
        [self sendChatToServer:model];
    } else {
        [self sendGroupChatToServer:model];
    }
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
    [self addMessageModelToDataSource:model];
    return model;
}

- (void)sendChatSystem:(NSString *)systemInfo{
    if (systemInfo && systemInfo.length > 0) {
        MessageModel * model = [self createMessageModelForSystem:systemInfo];
        if (!self.isGroupChat) {
            /// 生成info发送.
            [self sendChatToServer:model];
        } else {
            model.content = systemInfo;
            [self sendGroupChatToServer:model];
        }
    }
}

/// 在聊天列表中显示发送的系统信息.
- (MessageModel *)createMessageModelForSystem:(NSString *)systemInfo {
    LCUserModel *userInfo = [LCDataManager sharedInstance].userInfo;
    MessageModel *model = [[MessageModel alloc] init];
    model.type = eMessageBodyType_System;
    model.content = systemInfo;
    model.isSender = YES;
    model.headImageURL = [NSURL URLWithString:userInfo.avatarThumbUrl];
    model.sendDate = [NSDate date];
    [self addMessageModelToDataSource:model];
    return model;
}


#pragma mark MessageModel Delegate
/// 上传完成发送的图片.
- (void)uploadImageFinished:(MessageModel *)model {
    if (self.isAppearing) {
        /** Roy 2015.1.21
         After upload Image to server, send image message
         If the ChatViewController is no appearing now, which means we have goChatOffline, then don't send Image
         */
        NSString *showText = @"[图片]";
        model.content = showText;
        if (self.isGroupChat) {
            [self sendGroupChatToServer:model];
        } else {
            [self sendChatToServer:model];
        }
    }else{
        if (self.msgModelArray && [self.msgModelArray containsObject:model]) {
            [self.msgModelArray removeObject:model];
            [self.tableView reloadData];
        }
    }
}

/// 在聊天列表中显示要发送的图片信息.
- (MessageModel *)createImageMessageModelFromImage:(UIImage *)image {
    LCUserModel *userInfo = [LCDataManager sharedInstance].userInfo;
    MessageModel *model = [[MessageModel alloc] init];
    model.type = eMessageBodyType_Image;
    model.thumbnailImage = image;
    model.image = image;
    model.isSender = YES;
    model.headImageURL = [NSURL URLWithString:userInfo.avatarThumbUrl];
    model.sendDate = [NSDate date];
    [self addMessageModelToDataSource:model];
    return model;
}

- (void)sendImageMessage:(UIImage *)imageToSend {
    MessageModel *model = [self createImageMessageModelFromImage:imageToSend];
    [model addMessageModelDelegate:self];
    [model uploadModelImage];
    [self.tableView reloadData];
    [self scrollViewToBottom:YES];
}







#pragma mark - DXMessageToolBarDelegate
/// 文字输入高度变化回调.
- (void)didChangeFrameToHeight:(CGFloat)toHeight {
    //当MoreView由高变低时，由于DXMessageToolBar直接把MoreView消息，如果使用动画把输入框降低，期间会露出黑边
    //所以如果变低时，直接调整位置；否则，通过动画过渡调整位置
    static CGFloat lastHeight = 0;
    if (toHeight>=lastHeight) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect = self.tableView.frame;
            rect.size.height = self.view.frame.size.height - self.tableViewTopGap - toHeight;
            self.tableView.frame = rect;
        }];
    }else{
        CGRect rect = self.tableView.frame;
        rect.size.height = self.view.frame.size.height - self.tableViewTopGap - toHeight;
        self.tableView.frame = rect;
    }
    [self scrollViewToBottom:YES];
    lastHeight = toHeight;
}

#pragma mark DXChatBarMoreView Delegate
/// 用户点击了拍照，跳转拍照界面.
- (void)moreViewTakePicAction:(DXChatBarMoreView *)moreView {
    [MobClick event:Mob_Chat_ChooseCamera];
    
    [[LCPickOneImageHelper sharedInstance] pickImageFromAlbum:NO camera:YES allowEdit:NO completion:^(UIImage *image) {
        [self didPickImage:image];
    }];
}

/// 用户点击了查看相册，跳转到查看本地图片页面.
- (void)moreViewPhotoAction:(DXChatBarMoreView *)moreView {
    [MobClick event:Mob_Chat_ChoosePic];
    
    [[LCPickOneImageHelper sharedInstance] pickImageFromAlbum:YES camera:NO allowEdit:NO completion:^(UIImage *image) {
        [self didPickImage:image];
    }];
}

- (void)didPickImage:(UIImage *)image{
    if (image) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
            UIImage *originImage = image;
            originImage = [LCImageUtil getImageOfCompressImage:originImage toSize:MAX_IMAGE_SIZE_TO_UPLOAD];
            originImage = [LCImageUtil fixOrientation:originImage];
            
            //send image message in main queue
            dispatch_async(dispatch_get_main_queue(), ^(){
                __strong typeof(self) strongSelf = weakSelf;
                if (strongSelf) {
                    [strongSelf sendImageMessage:originImage];
                    [YSAlertUtil hideHud];
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                }
            });
        });
    }
}

/// 用户点击发送位置，跳转到定位页面.
- (void)moreViewLocationAction:(DXChatBarMoreView *)moreView {
    [MobClick event:Mob_Chat_ChooseLocation];
    
    LocationViewController *locationController = [[LocationViewController alloc] initWithNibName:nil bundle:nil];
    locationController.delegate = self;
    [self.navigationController pushViewController:locationController animated:YES];
}

- (void)locationViewController:(LocationViewController *)locationVC requestToSendLocation:(LCLocationModel *)location{
    if (location) {
        
        NSString *showText = @"[位置]";
        LCUserModel *userInfo = [LCDataManager sharedInstance].userInfo;
        MessageModel *model = [[MessageModel alloc] init];
        model.type = eMessageBodyType_Location;
        model.content = showText;
        model.address = location.address;
        model.latitude = location.lat;
        model.longitude = location.lng;
        model.isSender = YES;
        model.headImageURL = [NSURL URLWithString:userInfo.avatarThumbUrl];
        model.sendDate = [NSDate date];
        [self addMessageModelToDataSource:model];
        
        if (self.isGroupChat) {
            [self sendGroupChatToServer:model];
        } else {
            [self sendChatToServer:model];
        }
    }
}



/// 用户点击聊天信息，查看详情.
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    MessageModel *model = [userInfo objectForKey:[LCChatConstants eventMessageKey]];
    if ([eventName isEqualToString:[LCChatConstants eventLocationBubbleTapEventName]]) {
        /// 查看地理位置信息.
        [self chatLocationCellBubblePressed:model];
    } else if ([eventName isEqualToString:[LCChatConstants eventImageTapEventName]]){
        /// 查看图片信息.
        [self chatImageCellBubblePressed:model];
    } else if ([eventName isEqualToString:[LCChatConstants eventPlanBubbleTapEventName]]) {
        /// 查看计划信息.
        [self goToPlanPage:model];
    } else if ([eventName isEqualToString:[LCChatConstants eventHeadImageTapEventName]]) {
        /// 点击用户头像查看个人信息.
        [self goToUserPage:model];
    } else if ([eventName isEqualToString:[LCChatConstants eventVoiceBubbleTapEventName]]) {
        /// 点击语音信息
        [self voiceCellBubblePressed:model];
    }
}

/// 查看用户个人信息.
- (void)goToUserPage:(MessageModel *)model {
    LCUserModel *userInfo = [LCDataManager sharedInstance].userInfo;
    if (!self.isGroupChat && NO == model.isSender) {
        userInfo = self.chatWithUser;
    } else if (YES == self.isGroupChat && NO == model.isSender) {
        userInfo = (LCUserModel *)[self.xmppRoomUserDic objectForKey:model.senderTelephone];
    }
    if (userInfo) {
        [LCViewSwitcher pushToShowUserInfoVCForUser:userInfo on:self.navigationController];
    }
}

/// 查看计划信息.
- (void)goToPlanPage:(MessageModel *)model {
    LCPlanModel *plan = [LCPlanModel createEmptyPlanForEdit];
    plan.planGuid = model.plan.planGuid;
    [LCViewSwitcher pushToShowPlanDetailVCForPlan:plan recmdUuid:nil on:self.navigationController];
}

/// 查看图片信息.
- (void)chatImageCellBubblePressed:(MessageModel *)model {
    LCImageModel *imageModel = [[LCImageModel alloc] init];
    imageModel.imageUrl = [model.imageRemoteURL absoluteString];
    imageModel.imageUrlThumb = [model.thumbnailRemoteURL absoluteString];
    
    NSArray *arr = [[NSArray alloc] initWithObjects:imageModel, nil];
    [LCViewSwitcher presentPhotoScannerToShow:arr fromIndex:0];
}

/// 查看地理位置信息.
-(void)chatLocationCellBubblePressed:(MessageModel *)model {
//    CLLocationCoordinate2D appleCoordinate = [[LCBaiduMapManager sharedInstance] getAppleCoordinateFromBaiduCoordinate:model.latitude Lon:model.longitude];
    LocationViewController *locationController = [[LocationViewController alloc] initWithLocation:CLLocationCoordinate2DMake(model.latitude, model.longitude)];
    [self.navigationController pushViewController:locationController animated:YES];
}

/// 播放语音信息
- (void)voiceCellBubblePressed:(MessageModel *)model {
    NSData *voiceData = [RecordAudio getDataFromString:model.voice];
    if (voiceData) {
        if (self.recordAudio) {
            [self.recordAudio stopPlay];
        }
        self.recordAudio = [[RecordAudio alloc] init];
        [self.recordAudio play:voiceData];
    }
}

#pragma mark - DXMessageToolBar Voice Record
- (void)didStartRecordingVoiceAction:(UIView *)recordView{
    [self.view addSubview:self.msgToolBar.recordView];
    
    if (self.recordAudio) {
        [self.recordAudio stopPlay];
    }
    
    self.recordAudio = [[RecordAudio alloc] init];
    [self.recordAudio startRecord];
}

- (void)didCancelRecordingVoiceAction:(UIView *)recordView{
    [self.recordAudio stopRecord];
}

- (void)didFinishRecoingVoiceAction:(UIView *)recordView{
    NSURL *url = [self.recordAudio stopRecord];
    NSTimeInterval audioTime = 0;
    self.audioData = nil;
    if (url != nil) {
        self.audioData = EncodeWAVEToAMR([NSData dataWithContentsOfURL:url], 1, 16);
        audioTime = [RecordAudio getAudioTime:self.audioData];
        
        NSLog(@"audioTime: %f",audioTime);
        NSString *audioStr = [RecordAudio getStringFromData:self.audioData];
        NSLog(@"audioData: %@",audioStr);
        
        if (self.audioData) {
            if (audioTime > 1) {
                NSString *showText = @"[语音]";
                LCUserModel *userInfo = [LCDataManager sharedInstance].userInfo;
                MessageModel *model = [[MessageModel alloc] init];
                model.type = eMessageBodyType_Voice;
                model.content = showText;
                model.voice = audioStr;
                model.isSender = YES;
                model.headImageURL = [NSURL URLWithString:userInfo.avatarThumbUrl];
                model.sendDate = [NSDate date];
                [self addMessageModelToDataSource:model];
                
                if (self.isGroupChat) {
                    [self sendGroupChatToServer:model];
                } else {
                    [self sendChatToServer:model];
                }
            }else{
                [YSAlertUtil tipOneMessage:@"说话时间太短"];
            }
        }else{
            [YSAlertUtil tipOneMessage:@"录音失败"];
        }
    }
}

- (void)didDragOutsideAction:(UIView *)recordView{
    
}

- (void)didDragInsideAction:(UIView *)recordView{
    
}


#pragma mark RecordAudioDelegate
- (void)RecordStatus:(int)status{
    //0 播放 1 播放完成 2出错
    NSLog(@"%ld",(long)status);
}

#pragma mark ----
- (void)sendCheckIn:(LCLocationModel *)location{
    NSString *showText = @"[签到]";
    LCUserModel *userInfo = [LCDataManager sharedInstance].userInfo;
    MessageModel *model = [[MessageModel alloc] init];
    model.type = eMessageBodyType_CheckIn;
    model.content = showText;
    model.address = location.address;
    model.latitude = location.lat;
    model.longitude = location.lng;
    model.isSender = YES;
    model.headImageURL = [NSURL URLWithString:userInfo.avatarThumbUrl];
    model.sendDate = [NSDate date];
    [self addMessageModelToDataSource:model];
    
    if (self.isGroupChat) {
        [self sendGroupChatToServer:model];
    } else {
        [self sendChatToServer:model];
    }
}


- (void)getUserInfoByTelephone:(NSString *)telephone{
    [LCNetRequester getUserInfoByTelephone:telephone planOrGroupGuid:self.planOrGroupGuid callBack:^(LCUserModel *user, NSError *error) {
        if (!error) {
            if (user && [LCStringUtil isNotNullString:user.telephone]) {
                [self.xmppRoomUserDic setObject:user forKey:user.telephone];
                [self updateMessageModelsWithNewUserInfo];
            }
        }
    }];
}

- (void)updateMessageModelsWithNewUserInfo{
    for (id obj in self.msgModelArray){
        if ([obj isKindOfClass:[MessageModel class]]) {
            MessageModel *model = (MessageModel *)obj;
            LCUserModel *user = [self.xmppRoomUserDic objectForKey:model.senderTelephone];
            if (user) {
                model.headImageURL = [NSURL URLWithString:user.avatarThumbUrl];
                model.username = user.nick;
            }
        }
    }
    
    [self.tableView reloadData];
}

@end
