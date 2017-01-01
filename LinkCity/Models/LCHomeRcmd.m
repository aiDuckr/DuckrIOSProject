//
//  LCHomeRcmd.m
//  LinkCity
//
//  Created by 张宗硕 on 7/27/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCHomeRcmd.h"

@implementation LCHomeRcmd
- (id)initWithDictionary:(NSDictionary *)dic {
    self = [super initWithDictionary:dic];
    if (self) {
        self.title = [LCStringUtil getNotNullStr:[dic objectForKey:@"Title"]];
        self.type = [LCStringUtil idToNSInteger:[dic objectForKey:@"Type"]];
//        self.reason = [LCStringUtil getNotNullStr:[dic objectForKey:@"Reason"]];
        NSMutableArray *mutPlanArr = [[NSMutableArray alloc] init];
        NSArray *planDicArr = [dic objectForKey:@"PlanList"];
        if (nil != planDicArr && planDicArr.count > 0) {
            for (NSDictionary *dic in planDicArr) {
                LCPlanModel *plan = [[LCPlanModel alloc] initWithDictionary:dic];
                if (nil != plan && NO == [plan isEmptyPlan]) {
                    [mutPlanArr addObject:plan];
                }
            }
        }
        self.planArr = [[NSArray alloc] initWithArray:mutPlanArr];
        
        NSMutableArray *mutCategoryArr = [[NSMutableArray alloc] init];
        NSArray *categoryDicArr = [dic objectForKey:@"HomeCategorys"];
        if (nil != categoryDicArr && categoryDicArr.count > 0) {
            for (NSDictionary *dic in categoryDicArr) {
                LCHomeCategoryModel *model = [[LCHomeCategoryModel alloc] initWithDictionary:dic];
                if (nil != model) {
                    [mutCategoryArr addObject:model];
                }
            }
        }
        self.homeCategoryArr = [[NSArray alloc] initWithArray:mutCategoryArr];
        self.reqContent = [LCStringUtil getNotNullStr:@"ReqContent"];
        
        self.invitePlan = [[LCPlanModel alloc] initWithDictionary:[dic objectForKey:@"Invitation"]];
    }
    return self;
}

- (void)encodeWithCoder: (NSCoder *)coder {
    [coder encodeObject:self.title forKey:@"Title"];
    [coder encodeInteger:self.type forKey:@"Type"];
//    [coder encodeObject:self.reason forKey:@"Reason"];
    [coder encodeObject:self.planArr forKey:@"PlanArr"];
    [coder encodeObject:self.homeCategoryArr forKey:@"HomeCategoryArr"];
    [coder encodeObject:self.reqContent forKey:NSStringFromSelector(@selector(reqContent))];
    [coder encodeObject:self.invitePlan forKey:NSStringFromSelector(@selector(invitePlan))];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.title = [coder decodeObjectForKey:@"Title"];
        self.type = [coder decodeIntegerForKey:@"Type"];
//        self.reason = [coder decodeObjectForKey:@"Reason"];
        self.planArr = [coder decodeObjectForKey:@"PlanArr"];
        self.homeCategoryArr = [coder decodeObjectForKey:@"HomeCategoryArr"];
        self.reqContent = [coder decodeObjectForKey:NSStringFromSelector(@selector(reqContent))];
        self.invitePlan = [coder decodeObjectForKey:NSStringFromSelector(@selector(invitePlan))];
    }
    return self;
}

- (BOOL)isValidHomeRcmd {
    BOOL isValid = NO;
    switch (self.type) {
        case LCHomeRcmdType_Default:
        case LCHomeRcmdType_Rcmd:
        case LCHomeRcmdType_Nearby:
        case LCHomeRcmdType_Today:
        case LCHomeRcmdType_Tomorrow:
        case LCHomeRcmdType_Week:
        case LCHomeRcmdType_LocalTrade:///!>这里也许也不对。都应该是homeCategoryArr不为空才合法
        case LCHomeRcmdType_LocalTheme: {
            if (nil != self.planArr && self.planArr.count > 0) {
                isValid = YES;//这里不走。。。
            }
        }
            break;
        case LCHomeRcmdType_LocalRcmd:
        case LCHomeRcmdType_ToDoList:
        case LCHomeRcmdType_Traing: {
            if (nil != self.homeCategoryArr && self.homeCategoryArr.count > 0) {
                isValid = YES;
            }
        }
            break;
        default:
            break;
    }
    return isValid;
}
@end
