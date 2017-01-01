//
//  LCUserIdentifyVC.h
//  LinkCity
//
//  Created by roy on 3/12/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCAutoRefreshVC.h"
#import "LCUserIdentityModel.h"

@interface LCUserIdentifyVC : LCAutoRefreshVC
@property (nonatomic, strong) LCUserIdentityModel *userIdentityModel;
@property (nonatomic, strong) UIViewController *popToVC;    // the vc should pop to, when finish submit identity


+ (instancetype)createInstance;
@end
