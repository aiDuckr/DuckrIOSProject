//
//  LCBaseModel.h
//  LinkCity
//
//  Created by roy on 11/19/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "objc/runtime.h"
#import "NSDictionary+ParseJson.h"

@interface LCBaseModel : NSObject
- (id)initWithDictionary:(NSDictionary *)dic;
- (void)encodeWithCoder:(NSCoder *)coder;
- (id)initWithCoder:(NSCoder *)coder;

- (void)updateValueWithObject:(id)sender;


- (instancetype)createNewInstance;
@end
