//
//  LCTourpicTableVC.h
//  LinkCity
//
//  Created by roy on 5/10/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//
//  搜索旅图或别人的旅图列表.

#import "LCAutoRefreshVC.h"

typedef enum : NSUInteger {
    LCTourpicTableType_Search,
    LCTourpicTableType_User,
} LCTourpicTableType;

@interface LCTourpicTableVC : LCAutoRefreshVC
@property (nonatomic, strong) NSString *searchKeyWord;
@property (nonatomic, strong) LCUserModel *user;

@property (nonatomic, assign) LCTourpicTableType tourpicTableType;
@end
