//
//  LCUserEvaluationTableVC.h
//  LinkCity
//
//  Created by roy on 3/21/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCAutoRefreshVC.h"
#import "LCUserModel.h"

@interface LCUserEvaluationTableVC : LCAutoRefreshVC
@property (nonatomic, strong) LCUserModel *user;
@end
