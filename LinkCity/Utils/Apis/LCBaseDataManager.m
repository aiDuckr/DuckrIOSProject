//
//  LCBaseDataManager.m
//  LinkCity
//
//  Created by roy on 3/30/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCBaseDataManager.h"

@implementation LCBaseDataManager
#pragma mark Integer
- (NSInteger)readIntegerForKey:(NSString *)key withDefaultValue:(NSInteger)defaultValue{
    NSNumber *integer = [self readObjectForKey:key];
    if (!integer) {
        return defaultValue;
    }
    
    return [integer integerValue];
}
- (void)saveInteger:(NSInteger)integer forKey:(NSString *)key{
    [self saveObject:[NSNumber numberWithInteger:integer] forKey:key];
}

#pragma mark Archive & Save object
- (void)archiveAndSaveObject:(id)obj forKey:(NSString *)key{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:obj];
    [self saveObject:data forKey:key];
}
- (id)readArchivedObjectForKey:(NSString *)key{
    NSData *data = [self readObjectForKey:key];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}


#pragma mark Array 就你妹没用过！！！都用的是上面的archiveAndSaveObject
- (NSMutableArray *)readArrayForKey:(NSString *)key{
    NSArray *arr = nil;
    NSData *obj = [self readObjectForKey:key];
    if (obj) {
        arr = [NSKeyedUnarchiver unarchiveObjectWithData:obj];
    }else{
        arr = [[NSArray alloc] init];
    }
    return [NSMutableArray arrayWithArray:arr];
}

- (void)saveArray:(NSArray *)array forKey:(NSString *)key{
    NSData *obj = [NSKeyedArchiver archivedDataWithRootObject:array];
    [self saveObject:obj forKey:key];
}




#pragma mark Read & Save Object

- (id)readObjectForKey:(NSString *)key{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:key];
}
- (void)saveObject:(id)obj forKey:(NSString *)key{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:obj forKey:key];
}
@end
