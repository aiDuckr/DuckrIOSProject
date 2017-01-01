//
//  LCWxPrepayModel.h
//  LinkCity
//
//  Created by Roy on 8/5/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCBaseModel.h"

@interface LCWxPrepayModel : LCBaseModel

@property (nonatomic, strong) NSDictionary *dic;

@property (nonatomic, strong) NSString *appid;
@property (nonatomic, strong) NSString *mch_id;
@property (nonatomic, strong) NSString *nonce_str;
@property (nonatomic, strong) NSString *prepay_id;

@property (nonatomic, strong) NSString *result_code;
@property (nonatomic, strong) NSString *return_code;

@property (nonatomic, strong) NSString *return_msg;
@property (nonatomic, strong) NSString *sign;
@property (nonatomic, strong) NSString *trade_type;

@end
