//
//  LCUserIdentityModel.h
//  LinkCity
//
//  Created by roy on 3/12/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCBaseModel.h"

@interface LCUserIdentityModel : LCBaseModel
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *idNumber;
@property (nonatomic, strong) NSString *idCardUrl;
@property (nonatomic, strong) NSString *idCardThumbUrl;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString *reason;

+ (instancetype)createEmptyInstance;
- (LCIdentityStatus)getUserIdentityStatus;
@end