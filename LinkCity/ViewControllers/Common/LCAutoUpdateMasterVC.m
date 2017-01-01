//
//  LCAutoUpdateMasterVC.m
//  LinkCity
//
//  Created by Roy on 9/2/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCAutoUpdateMasterVC.h"

@interface LCAutoUpdateMasterVC ()

@end

@implementation LCAutoUpdateMasterVC

#pragma mark LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)dealloc{
    [self stopObservePlanModelUpdate];
}

#pragma mark Set & Get
- (NSMutableArray *)updatedPlanModelArray{
    if (!_updatedPlanModelArray) {
        _updatedPlanModelArray = [NSMutableArray new];
    }
    return _updatedPlanModelArray;
}

#pragma mark Public Interface
- (void)startObservePlanModelUpdate{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(planModelUpdateNotification:) name:NotificationPlanModelUpdate object:nil];
}

- (void)stopObservePlanModelUpdate{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationPlanModelUpdate object:nil];
}

- (NSMutableArray *)updatePlanArray:(NSArray *)planArray{
    NSMutableArray *retArray = [NSMutableArray new];
    
    if (planArray.count > 0 &&
        self.updatedPlanModelArray.count > 0) {
        
        for(LCPlanModel *oldPlan in planArray){
            if ([oldPlan isKindOfClass:[LCPlanModel class]]) {
                
                //与更新过数据的邀约比较
                for(LCPlanModel *updatedPlan in self.updatedPlanModelArray){
                    if ([oldPlan.planGuid isEqualToString:updatedPlan.planGuid]) {
                        //是同一个邀约，用更新过的邀约替换旧邀约
                        [retArray addObject:updatedPlan];
                    }else{
                        [retArray addObject:oldPlan];
                    }
                }
            }else{
                [retArray addObject:oldPlan];
            }
        }
    }else{
        [retArray addObjectsFromArray:planArray];
    }
    
    return retArray;
}

- (void)clearUpdatedPlanModel{
    [self.updatedPlanModelArray removeAllObjects];
}


- (void)planModelUpdateNotification:(NSNotification *)notify{
    if (notify.userInfo) {
        LCPlanModel *plan = [notify.userInfo objectForKey:NotificationPlanModelKey];
        if (plan) {
            BOOL didReplace = NO;
            for (int i=0; i<self.updatedPlanModelArray.count; i++){
                if ([[self.updatedPlanModelArray[i] planGuid] isEqualToString:plan.planGuid]) {
                    [self.updatedPlanModelArray replaceObjectAtIndex:i withObject:plan];
                    didReplace = YES;
                    break;
                }
            }
            if (!didReplace) {
                [self.updatedPlanModelArray addObject:plan];
            }
            
            if (self.updatedPlanModelArray.count > AUTO_UPDATE_ARRAY_SIZE) {
                [self.updatedPlanModelArray removeObjectAtIndex:0];
            }
        }
    }
}


@end
