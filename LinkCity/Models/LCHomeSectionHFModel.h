//
//  LCHomeSectionHFModel.h
//  LinkCity
//
//  Created by Roy on 8/21/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCBaseModel.h"

@interface LCHomeSectionHFModel : LCBaseModel
@property (nonatomic, strong) NSString *title;      //Title: "从这出发"
@property (nonatomic, assign) NSInteger recmdNum;   //RecmdNum: 256
@property (nonatomic, assign) NSInteger isShowMore; //IsShowMore: 1
@property (nonatomic, strong) NSString *tableTitle; //TableTitle: "从这出发的邀约"
@property (nonatomic, strong) NSArray *tableTabs;   //TableTabs: ["热门", "从这出发", "到这儿来"]
@property (nonatomic, strong) NSArray *tableTabIds; //TableTabIds: [3, 1, 2]    // 1从这出发，2到这儿来，3热门邀约，4我的关注，5达客，6推荐路线
@property (nonatomic, assign) NSInteger tableTabIndex;  //TableTabIndex: 1


@end







