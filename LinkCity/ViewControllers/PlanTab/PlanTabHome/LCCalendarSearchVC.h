//
//  LCCalendarSearchVC.h
//  LinkCity
//
//  Created by 张宗硕 on 8/4/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCCalendarSearchVC : LCAutoRefreshVC
@property (assign, nonatomic) BOOL isCalenderSearch;
@property (assign, nonatomic) BOOL isNeedRefresh;
@property (strong, nonatomic) NSString *searchText;
@end
