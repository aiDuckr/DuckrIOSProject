//
//  NSDictionary+ParseJson.h
//  LinkCity
//
//  Created by roy on 3/10/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (ParseJson)
- (NSDictionary *)dicOfObjectForKey:(NSString *)key;
- (NSArray *)arrayForKey:(NSString *)key;
@end
