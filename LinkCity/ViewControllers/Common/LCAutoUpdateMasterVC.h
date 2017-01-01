//
//  LCAutoUpdateMasterVC.h
//  LinkCity
//
//  Created by Roy on 9/2/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCAutoRefreshVC.h"

#define AUTO_UPDATE_ARRAY_SIZE (4)
@interface LCAutoUpdateMasterVC : LCAutoRefreshVC
@property (nonatomic, strong) NSMutableArray *updatedPlanModelArray;
@property (nonatomic, strong) NSMutableArray *updatedTourpicModelArray;


- (void)startObservePlanModelUpdate;
- (void)stopObservePlanModelUpdate;
- (NSMutableArray *)updatePlanArray:(NSArray *)planArray;
- (void)clearUpdatedPlanModel;


@end
