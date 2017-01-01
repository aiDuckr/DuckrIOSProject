//
//  LCPopViewHelper.h
//  LinkCity
//
//  Created by 张宗硕 on 12/23/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCCostPlanEvaluationView.h"
#import "LCCalendarChooseDateView.h"
@protocol LCPopViewHelperDelegate;

@interface LCPopViewHelper : NSObject<LCCostPlanEvaluationViewDelegate>
@property (nonatomic, retain) LCPlanModel *plan;
@property (nonatomic, assign) CGFloat shadowAlpha;

@property (nonatomic, strong) LCCostPlanEvaluationView *costPlanEvaluationView;
@property (nonatomic, strong) KLCPopup *costPlanEvaluationPopView;

@property (nonatomic, strong) KLCPopup *confirmArrivalPopView;

@property (nonatomic, weak) id<LCPopViewHelperDelegate> delegate;

+ (instancetype)sharedInstance;
- (void)popCostPlanEvaluationView:(id<LCPopViewHelperDelegate>)delegate withPlan:(LCPlanModel *) plan;
- (void)popConfirmArrivalView:(id<LCPopViewHelperDelegate>)delegate withPlan:(LCPlanModel *) plan;
- (void)popDateSelectedView:(id <LCCalendarChooseDateViewDelegate>)delegate;

@end

@protocol LCPopViewHelperDelegate <NSObject>

- (void)popViewHelperDidCancel;
- (void)popViewConfirmArrival:(LCPlanModel *)plan;

@end