//
//  LCUserEvaluationVC.h
//  LinkCity
//
//  Created by roy on 3/4/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCBaseVC.h"
#import "LCUserModel.h"

@interface LCUserEvaluationVC : LCBaseVC
@property (nonatomic, strong) LCUserEvaluationModel *evaluation;
@property (nonatomic, strong) LCUserModel *userToEvaluate;


+ (instancetype)createInstance;
@end






