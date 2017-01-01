//
//  LCGuideIdentityModel.h
//  LinkCity
//
//  Created by roy on 5/9/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCBaseModel.h"

@interface LCGuideIdentityModel : LCBaseModel
@property (nonatomic, strong) NSString *clubPhotoUrl;
@property (nonatomic, strong) NSString *clubPhotoThumbUrl;
@property (nonatomic, strong) NSString *note;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString *reason;
@property (nonatomic, strong) NSString *createdTime;
@property (nonatomic, strong) NSString *updatedTime;
@property (nonatomic, strong) NSString *type;


- (LCIdentityStatus)getIdentityStatus;


@end
