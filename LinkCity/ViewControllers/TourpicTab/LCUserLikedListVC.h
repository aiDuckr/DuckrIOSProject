//
//  LCUserLikedListVC.h
//  LinkCity
//
//  Created by 张宗硕 on 3/28/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCBaseVC.h"
#import "LCTourpic.h"

@interface LCUserLikedListVC : LCBaseVC
+ (instancetype)createInstance;
@property (retain, nonatomic) LCTourpic *tourpic;
@property (retain, nonatomic) LCPlanModel *plan;
@end
