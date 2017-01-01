//
//  LCVersionInfoModel.h
//  LinkCity
//
//  Created by roy on 3/26/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCBaseModel.h"

@interface LCVersionInfoModel : LCBaseModel
@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSString *forceUpdate;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *descriptionStr;
@end
