//
//  LCHomeRcmd.h
//  LinkCity
//
//  Created by 张宗硕 on 7/27/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    LCHomeRcmdType_Default = 0,
    LCHomeRcmdType_Rcmd = 1,
    LCHomeRcmdType_Nearby = 2,
    LCHomeRcmdType_ToDoList = 3,
    LCHomeRcmdType_HotThemes = 4,
    LCHomeRcmdType_Today = 5,
    LCHomeRcmdType_Tomorrow = 6,
    LCHomeRcmdType_Week = 7,
    LCHomeRcmdType_Traing = 8,
    LCHomeRcmdType_LocalRcmd = 101,             ///> 本地精选.
    LCHomeRcmdType_LocalTrade = 102,            ///> 热门商圈.
    LCHomeRcmdType_LocalTheme = 103,            ///> 主题活动.
} LCHomeRcmdType;

@interface LCHomeRcmd : LCBaseModel<NSCoding>
@property (strong, nonatomic) NSString *title;
@property (assign, nonatomic) LCHomeRcmdType type;
//@property (strong, nonatomic) NSString *reason;
@property (strong, nonatomic) NSArray *planArr;
@property (strong, nonatomic) NSArray *homeCategoryArr;
@property (strong, nonatomic) NSString *reqContent;
@property (strong, nonatomic) LCPlanModel *invitePlan;

- (BOOL)isValidHomeRcmd;
@end
