//
//  LCDataBufferManager.m
//  LinkCity
//
//  Created by 张宗硕 on 7/20/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCDataBufferManager.h"

@interface LCDataBufferManager ()
@property (nonatomic, strong) NSMutableDictionary *tourpicDic;
@property (nonatomic, strong) NSMutableDictionary *planDic;
@property (nonatomic, strong) NSMutableDictionary *userDic;
@end

@implementation LCDataBufferManager
+ (instancetype)sharedInstance {
    static LCDataBufferManager *staticInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticInstance = [[LCDataBufferManager alloc] init];
    });
    return staticInstance;
}

- (NSMutableDictionary *)tourpicDic {
    if (nil == _tourpicDic) {
        _tourpicDic = [[NSMutableDictionary alloc] init];
    }
    return _tourpicDic;
}

- (NSMutableDictionary *)planDic {
    if (nil == _planDic) {
        _planDic = [[NSMutableDictionary alloc] init];
    }
    return _planDic;
}

- (NSMutableDictionary *)userDic {
    if (nil == _userDic) {
        _userDic = [[NSMutableDictionary alloc] init];
    }
    return _userDic;
}

- (LCHomeRcmd *)refreshHomeRcmd:(LCHomeRcmd *)homeRcmd {
    if (nil == homeRcmd) {
        return nil;
    }
    homeRcmd.planArr = [self refreshPlanTourpicUserArr:homeRcmd.planArr];
    if ([[self.planDic allKeys] containsObject:homeRcmd.invitePlan.planGuid]) {
        homeRcmd.invitePlan = [self.planDic objectForKey:homeRcmd.invitePlan.planGuid];
    }
    return homeRcmd;
}

- (NSArray *)refreshHomeRcmdArr:(NSArray *)arr {
    if (nil == arr || arr.count <= 0) {
        return [[NSArray alloc] init];
    }
    NSMutableArray *mutArr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < arr.count; ++i) {
        LCHomeRcmd *homeRcmd = (LCHomeRcmd *)[arr objectAtIndex:i];
        homeRcmd = [self refreshHomeRcmd:homeRcmd];
        [mutArr addObject:homeRcmd];
    }
    return mutArr;
}

- (NSArray *)refreshPlanTourpicUserArr:(NSArray *)arr {
    if (nil == arr || arr.count <= 0) {
        return [[NSArray alloc] init];
    }
    NSMutableArray *mutArr = [[NSMutableArray alloc] initWithArray:arr];
    for (NSInteger i = 0; i < mutArr.count; ++i) {
        id obj = [mutArr objectAtIndex:i];
        if ([obj isKindOfClass:[LCPlanModel class]]) {
            LCPlanModel *plan = (LCPlanModel *)obj;
            if ([[self.planDic allKeys] containsObject:plan.planGuid]) {
                [mutArr replaceObjectAtIndex:i withObject:[self.planDic objectForKey:plan.planGuid]];//用新的替换旧的
            }
        } else if ([obj isKindOfClass:[LCTourpic class]]) {
            LCTourpic *tourpic = (LCTourpic *)obj;
            if ([[self.tourpicDic allKeys] containsObject:tourpic.guid]) {
                [mutArr replaceObjectAtIndex:i withObject:[self.tourpicDic objectForKey:tourpic.guid]];
            }
        } else if ([obj isKindOfClass:[LCUserModel class]]) {
            LCUserModel *user = (LCUserModel *)obj;
            if ([[self.planDic allKeys] containsObject:user.uUID]) {
                [mutArr replaceObjectAtIndex:i withObject:[self.planDic objectForKey:user.uUID]];
            }
        }
    }
    return mutArr;
}

- (NSArray *)refreshTourpicArr:(NSArray *)tourpicArr {
    if (nil == tourpicArr || tourpicArr.count <= 0) {
        return [[NSArray alloc] init];
    }
    NSMutableArray *mutArr = [[NSMutableArray alloc] initWithArray:tourpicArr];
    for (NSInteger i = 0; i < mutArr.count; ++i) {
        LCTourpic *tourpic = [mutArr objectAtIndex:i];
        if ([[self.tourpicDic allKeys] containsObject:tourpic.guid]) {
            [mutArr replaceObjectAtIndex:i withObject:[self.tourpicDic objectForKey:tourpic.guid]];
        }
    }
    return mutArr;
}

- (NSArray *)refreshPlanArr:(NSArray *)planArr {
    if (nil == planArr || planArr.count <= 0) {
        return [[NSArray alloc] init];
    }
    NSMutableArray *mutArr = [[NSMutableArray alloc] initWithArray:planArr];
    for (NSInteger i = 0; i < mutArr.count; ++i) {
        LCPlanModel *plan = [mutArr objectAtIndex:i];
        if ([[self.planDic allKeys] containsObject:plan.planGuid]) {
            [mutArr replaceObjectAtIndex:i withObject:[self.planDic objectForKey:plan.planGuid]];
        }
    }
    return mutArr;
}

- (NSArray *)refreshUserArr:(NSArray *)userArr {
    if (nil == userArr || userArr.count <= 0) {
        return [[NSArray alloc] init];
    }
    NSMutableArray *mutArr = [[NSMutableArray alloc] initWithArray:userArr];
    for (NSInteger i = 0; i < mutArr.count; ++i) {
        LCUserModel *user = [mutArr objectAtIndex:i];
        if ([[self.planDic allKeys] containsObject:user.uUID]) {
            [mutArr replaceObjectAtIndex:i withObject:[self.planDic objectForKey:user.uUID]];
        }
    }
    return mutArr;
}

- (void)addNewTourpic:(LCTourpic *)tourpic {
    if (nil != tourpic) {
        [self.tourpicDic setObject:tourpic forKey:tourpic.guid];
    }
}

- (void)addNewPlan:(LCPlanModel *)plan {
    if (nil != plan) {
        [self.planDic setObject:plan forKey:plan.planGuid];
    }
}

- (void)addNewUser:(LCUserModel *)user {
    if (nil != user) {
        [self.planDic setObject:user forKey:user.uUID];
    }
}

@end
