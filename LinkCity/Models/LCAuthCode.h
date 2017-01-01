//
//  LCAuthCode.h
//  LinkCity
//
//  Created by roy on 11/10/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCBaseModel.h"

@interface LCAuthCode : LCBaseModel
- (id)initWithDictionary:(NSDictionary *)dic;
- (void)encodeWithCoder:(NSCoder *)coder;
- (id)initWithCoder:(NSCoder *)coder;

@property (nonatomic, retain) NSString *authCode;
@property (nonatomic, assign) NSInteger expireTime;

- (NSInteger)getIntegerAuthcode;
@end
