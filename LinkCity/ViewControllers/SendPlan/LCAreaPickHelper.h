//
//  LCAreaPickHelper.h
//  LinkCity
//
//  Created by Roy on 12/17/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCAreaPickView.h"
#import "KLCPopup.h"

@interface LCAreaPickHelper : NSObject
@property (nonatomic, strong) UINavigationController *navVC;
@property (nonatomic, strong) LCAreaPickView *pickView;
@property (nonatomic, strong) KLCPopup *pickPopup;

@property (nonatomic, strong) void(^callBack)(NSString *cityAreaName);

+ (instancetype)instanceWithNavVC:(UINavigationController *)navVC;
- (void)startAreaPickWithCityName:(NSString *)city areaName:(NSString *)areaName callBack:(void (^)(NSString *))callBack;

@end

