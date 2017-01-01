//
//  LCDataBufferManager.h
//  LinkCity
//
//  Created by 张宗硕 on 7/20/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCDataBufferManager : NSObject
+ (instancetype)sharedInstance;
- (NSArray *)refreshTourpicArr:(NSArray *)tourpicArr;
- (NSArray *)refreshPlanArr:(NSArray *)planArr;
- (NSArray *)refreshUserArr:(NSArray *)userArr;
- (NSArray *)refreshPlanTourpicUserArr:(NSArray *)arr;
- (NSArray *)refreshHomeRcmdArr:(NSArray *)arr;
- (LCHomeRcmd *)refreshHomeRcmd:(LCHomeRcmd *)homeRcmd;

- (void)addNewTourpic:(LCTourpic *)tourpic;
- (void)addNewPlan:(LCPlanModel *)plan;
- (void)addNewUser:(LCUserModel *)user;

@end
