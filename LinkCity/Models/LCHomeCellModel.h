//
//  LCHomeCellModel.h
//  LinkCity
//
//  Created by Roy on 8/21/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCBaseModel.h"
#import "LCHomeSectionHFModel.h"
#import "LCHomeCategoryModel.h"
#import "LCUserModel.h"

typedef enum : NSUInteger {
    LCHomeCellType_None = 0,
    LCHomeCellType_Header = 1,
    LCHomeCellType_Footer = 2,
    LCHomeCellType_Plan = 3,
    LCHomeCellType_RouteList = 4,
    LCHomeCellType_Banner = 5,
    LCHomeCellType_User = 6,
} LCHomeCellType;

@interface LCHomeCellModel : LCBaseModel
@property (nonatomic, assign) NSInteger type;   // 0未知的类型，1为Header视图，2为Footer视图，3为邀约数据，4为路线列表，5为Banner，6为达客
@property (nonatomic, strong) LCHomeSectionHFModel *sectionHF;  //{HomeSectionHF数据结构}
@property (nonatomic, strong) LCPlanModel *partnerPlan; //{PartnerPlan数据结构}
@property (nonatomic, strong) LCHomeCategoryModel *banner;  //{HomeCategory数据结构}
@property (nonatomic, strong) LCUserModel *user;    //{User数据结构}
@property (nonatomic, strong) NSArray *routeList;   //array of LCHomeCategoryModel


- (LCHomeCellType)getCellType;
@end
