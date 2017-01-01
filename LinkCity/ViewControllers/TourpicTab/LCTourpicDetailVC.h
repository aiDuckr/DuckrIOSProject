//
//  LCTourpicDetailVC.h
//  LinkCity
//
//  Created by 张宗硕 on 3/26/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCAutoRefreshVC.h"
#import "LCShareUtil.h"

typedef enum : NSInteger {
    LCTourpicDetailVCViewType_Normal = 0,
    LCTourpicDetailVCViewType_Comment = 1,
} LCTourpicDetailVCViewType;

@interface LCTourpicDetailVC : LCAutoRefreshVC
+ (instancetype)createInstance;
@property (retain, nonatomic) LCTourpic *tourpic;
@property (assign, nonatomic) LCTourpicDetailVCViewType type;
@end
