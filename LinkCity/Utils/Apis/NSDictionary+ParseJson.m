//
//  NSDictionary+ParseJson.m
//  LinkCity
//
//  Created by roy on 3/10/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "NSDictionary+ParseJson.h"

@implementation NSDictionary (ParseJson)
- (NSDictionary *)dicOfObjectForKey:(NSString *)key{
    id obj = [self objectForKey:key];
    if ([obj isKindOfClass:[NSArray class]]) {
        obj = nil;
    } else if ([obj isKindOfClass:[NSDictionary class]]) {
        
    }
    
    return obj;
}
- (NSArray *)arrayForKey:(NSString *)key{
    id obj = [self objectForKey:key];
    
    if (obj == nil ||
        obj == NULL ||
        obj == [NSNull null] ||
        [obj isKindOfClass:[NSDictionary class]] ||
        ![obj isKindOfClass:[NSArray class]]) {
        
        obj = nil;
    }
    
    return obj;
}
@end
