//
//  LCHomeRecmCostPlansVC.h
//  LinkCity
//
//  Created by 张宗硕 on 5/18/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCAutoRefreshVC.h"

typedef enum : NSInteger {
    LCHomeRecmCostPlansViewType_Selected,
    LCHomeRecmCostPlansViewType_LocalRecm,
} LCHomeRecmCostPlansViewType;

@interface LCHomeRecmCostPlansVC : LCAutoRefreshVC
@property (assign, nonatomic) LCHomeRecmCostPlansViewType type;

@end
