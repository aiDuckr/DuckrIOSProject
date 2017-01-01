//
//  LCMessageConvert.h
//  LinkCity
//
//  Created by 张宗硕 on 11/23/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageModel.h"

@interface LCMessageConvert : NSObject

+ (MessageModel *)getEMMessageFromJsonStr:(NSString *)jsonStr;
+ (NSString *)getJsonStrFromEMMessage:(MessageModel *)model;

@end
