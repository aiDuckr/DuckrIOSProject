//
//  LCChatVC.h
//  LinkCity
//
//  Created by roy on 3/18/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCBaseVC.h"

#import "LCUserModel.h"
#import "LCPlanModel.h"
#import "LCChatGroupModel.h"

#import "XMPPRoom.h"
#import "XMPPMessage+Info.h"
#import "LCXMPPMessageHelper.h"
#import "XMPPMessageArchivingCoreDataStorage.h"
#import "XMPPRoomCoreDataStorage.h"
#import "LCXMPPUtil.h"

#import "LCMessageConvert.h"

#import "LocationViewController.h"
#import "LCPhotoScanner.h"
#import "MJRefresh.h"


#import "MessageModel.h"


#import "DXMessageToolBar.h"


@interface LCChatBaseVC : LCAutoRefreshVC<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, assign) CGFloat tableViewTopGap;

//Data
@property (nonatomic, strong) NSMutableArray *msgModelArray;    //聊天中的消息，MessageModel / NSString

//Must Set
@property (nonatomic, assign) BOOL isGroupChat;
@property (nonatomic, strong) NSString *chatWithJidStr;
@property (nonatomic, strong) NSString *headImageURL;

//chat with user must set
@property (nonatomic, strong) LCUserModel *chatWithUser;
//chat with plan or group must set
@property (nonatomic, strong) NSMutableDictionary *xmppRoomUserDic; // key: telephone   value: LCUserModel
@property (nonatomic, strong) XMPPRoom *xmppRoom;
@property (nonatomic, strong) NSString *planOrGroupGuid;    //planGuid 或者 groupGuid，用于据此获取未知用户信息


//UI
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DXMessageToolBar *msgToolBar;

//Control TableView
- (void)updateTableView;

//Control DataSource
- (void)addMessageModelToDataSource:(MessageModel *)messageModel;

//To be override
- (void)updateShow;



//Public function
- (void)sendCheckIn:(LCLocationModel *)location;
- (void)getUserInfoByTelephone:(NSString *)telephone;
- (void)updateMessageModelsWithNewUserInfo;

//发送单聊信息
- (void)sendChatToServer:(MessageModel *)model;
//发送群聊信息
- (void)sendGroupChatToServer:(MessageModel *)model;

@end







