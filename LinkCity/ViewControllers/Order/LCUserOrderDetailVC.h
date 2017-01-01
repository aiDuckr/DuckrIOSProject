//
//  LCUserOrderDetailVC.h
//  LinkCity
//
//  Created by 张宗硕 on 12/22/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    LCUserOrderDetailType_Default = 0,
    LCUserOrderDetailType_Push = 1,
} LCUserOrderDetailType;

@interface LCUserOrderDetailVC : LCAutoRefreshVC
@property (retain, nonatomic) LCPlanModel *plan;
@property (assign, nonatomic) LCUserOrderDetailType type;
@end
