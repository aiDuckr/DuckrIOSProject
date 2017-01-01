//
//  LCOrderHelper.h
//  LinkCity
//
//  Created by Roy on 12/23/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCOrderChooseStageView.h"
#import "LCOrderVC.h"
#import "LCOneDatePickView.h"

@interface LCOrderHelper : NSObject
@property (nonatomic, strong) LCPlanModel *plan;
@property (nonatomic, strong) LCPartnerStageModel *stage;
@property (nonatomic, strong) NSString *recmdUuid;

@property (nonatomic, strong) UINavigationController *navVC;
@property (nonatomic, strong) LCOrderChooseStageView *chooseStageView;

@property (nonatomic, strong) LCOneDatePickView *oneDatePickView;    // 日期视图，by zzs
@property (nonatomic, strong) KLCPopup *choosePickup;
@property (nonatomic, strong) LCOrderVC *orderVC;

+ (instancetype)instanceWithNavVC:(UINavigationController *)navVC;
- (void)startToOrderPlan:(LCPlanModel *)plan recmdUuid:(NSString *)recmdUuid;


@end
