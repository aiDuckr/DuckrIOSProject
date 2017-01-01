//
//  LCBaseDataManager.h
//  LinkCity
//
//  Created by roy on 3/30/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCBaseDataManager : NSObject
- (void)saveInteger:(NSInteger)integer forKey:(NSString *)key;
- (NSInteger)readIntegerForKey:(NSString *)key withDefaultValue:(NSInteger)defaultValue;

- (void)archiveAndSaveObject:(id)obj forKey:(NSString *)key;
- (id)readArchivedObjectForKey:(NSString *)key;

- (id)readObjectForKey:(NSString *)key;
- (void)saveObject:(id)obj forKey:(NSString *)key;

- (void)saveArray:(NSArray *)array forKey:(NSString *)key;
- (NSMutableArray *)readArrayForKey:(NSString *)key;
@end
