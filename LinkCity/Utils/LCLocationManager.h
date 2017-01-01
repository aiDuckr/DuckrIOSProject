//
//  LCLocationManager.h
//  LinkCity
//
//  Created by roy on 11/29/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCLocationManager : NSObject
+ (NSMutableArray *)getLocationsFromPlist;
+ (NSString *)getProvinceNameFromLocations:(NSArray *)locations atIndex:(NSInteger)index;
+ (NSArray *)getCityArrayFromLocations:(NSArray *)locations atIndex:(NSInteger)index;

//for area
+ (void)analysisArea;
+ (NSArray *)getCityDicArrayFromPlist;
@end
