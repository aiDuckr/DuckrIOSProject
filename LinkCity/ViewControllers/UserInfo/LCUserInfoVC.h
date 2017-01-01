//
//  LCUserInfoVC.h
//  LinkCity
//
//  Created by roy on 3/1/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCBaseVC.h"
#import "LCUserModel.h"
#import "LCUserInfoTopView.h"
#import "LCTabView.h"
#import "LCUserRouteModel.h"
#import "LCCarIdentityModel.h"

@interface LCUserInfoVC : LCAutoRefreshVC
@property (nonatomic, strong) LCUserModel *user;
@property (nonatomic, strong) LCCarIdentityModel *carIdentity;
@property (nonatomic, strong) NSArray *planArray; //plans created by this user;   array of LCPlanModel
@property (nonatomic, strong) NSArray *tourpicArray;

@end
