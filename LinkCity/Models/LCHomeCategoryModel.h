//
//  LCPlanCategoryModel.h
//  LinkCity
//
//  Created by roy on 3/9/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCBaseModel.h"

typedef enum : NSUInteger {
    LCHomeCategoryType_Unknown = 0,
    LCHomeCategoryType_BannerPlan = 11,
    LCHomeCategoryType_BannerWeb = 12,
    LCHomeCategoryType_BannerTheme = 13,
    LCHomeCategoryType_BannerDuckr = 14,
} LCHomeCategoryType;

@interface LCHomeCategoryModel : LCBaseModel
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *coverUrl;
@property (nonatomic, strong) NSString *coverThumbUrl;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *descInfo;   //"236个邀约"    // 描述

@property (nonatomic, assign) LCHomeCategoryType categoryType;
@end
