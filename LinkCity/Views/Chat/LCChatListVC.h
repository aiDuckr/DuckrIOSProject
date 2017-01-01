//
//  LCChatListVC.h
//  LinkCity
//
//  Created by 张宗硕 on 11/20/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCChatListCell.h"
#import "LCSlideVC.h"
#import "LCChatApi.h"

typedef enum {
    COMEIN_CHAT_LIST_MENU = 0,
    COMEIN_CHAT_LIST_SHARE
}ComeInChatListType;

@interface LCChatListVC : LCBaseVC
/// 用户分享的计划.
@property (nonatomic, retain) LCPlan *planToSend;
/// 进入该界面的类型.
@property (nonatomic, assign) ComeInChatListType type;

@end
