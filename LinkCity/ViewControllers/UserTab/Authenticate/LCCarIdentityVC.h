//
//  LCCarServiceAuthenticateVC.h
//  LinkCity
//
//  Created by roy on 3/12/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCAutoRefreshVC.h"
#import "LCCarIdentityModel.h"

@interface LCCarIdentityVC : LCAutoRefreshVC
@property (nonatomic, strong) LCCarIdentityModel *carModel;
@end
