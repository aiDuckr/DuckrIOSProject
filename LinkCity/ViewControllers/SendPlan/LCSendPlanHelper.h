//
//  LCSendPlanHelper.h
//  LinkCity
//
//  Created by Roy on 12/12/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCSendPlanHelper : NSObject

+ (instancetype)sharedInstance;

- (void)sendNewPlanWithPlaceName:(NSString *)placeName;
- (void)modify:(LCPlanModel *)plan;
- (void)verifyIdentityAndSendFreePlan;
- (void)pushToSendFreePlanDestVC;
@end
