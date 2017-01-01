//
//  LCPopViewHelper.m
//  LinkCity
//
//  Created by 张宗硕 on 12/23/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCPopViewHelper.h"
#import "Linkcity-Swift.h"

@interface LCPopViewHelper()<LCConfirmArrivalViewDelegate>
@end

@implementation LCPopViewHelper
+ (instancetype)sharedInstance {
    static LCPopViewHelper *staticInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticInstance = [[LCPopViewHelper alloc] init];
    });
    return staticInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        self.shadowAlpha = LCPopViewShadowAlpha;
    }
    return self;
}

- (void)popCostPlanEvaluationView:(id<LCPopViewHelperDelegate>)delegate withPlan:(LCPlanModel *) plan {
    if (nil == plan) {
        return ;
    }
    
    if (self.costPlanEvaluationPopView && (self.costPlanEvaluationPopView.isBeingShown || self.costPlanEvaluationPopView.isShowing)) {
        return;
    }
    self.delegate = delegate;
    self.costPlanEvaluationView = [LCCostPlanEvaluationView createInstance];
    self.costPlanEvaluationView.delegate = self;
    self.costPlanEvaluationPopView = [KLCPopup popupWithContentView:self.costPlanEvaluationView
                                                       showType:KLCPopupShowTypeBounceInFromTop
                                                    dismissType:KLCPopupDismissTypeBounceOutToBottom
                                                       maskType:KLCPopupMaskTypeDimmed
                                       dismissOnBackgroundTouch:NO
                                          dismissOnContentTouch:NO];
    self.costPlanEvaluationPopView.dimmedMaskAlpha = self.shadowAlpha;
    [self.costPlanEvaluationPopView showAtCenter:CGPointMake(DEVICE_WIDTH / 2.0f, DEVICE_HEIGHT / 2.0f) inView:nil];
    [self.costPlanEvaluationView updateShowEvaluationView:plan];
}

- (void)popConfirmArrivalView:(id<LCPopViewHelperDelegate>)delegate withPlan:(LCPlanModel *) plan {
    if (nil == plan) {
        return ;
    }
    self.plan = plan;
    
    if (self.confirmArrivalPopView && (self.confirmArrivalPopView.isBeingShown || self.confirmArrivalPopView.isShowing)) {
        return ;
    }
    self.delegate = delegate;
    
    LCConfirmArrivalView *view = [LCConfirmArrivalView createInstance];
    [view updateShowWithPlan:plan];
    view.delegate = self;
    self.confirmArrivalPopView = [KLCPopup popupWithContentView:view
                                                           showType:KLCPopupShowTypeBounceInFromTop
                                                        dismissType:KLCPopupDismissTypeBounceOutToBottom
                                                           maskType:KLCPopupMaskTypeDimmed
                                           dismissOnBackgroundTouch:NO
                                              dismissOnContentTouch:NO];
    self.confirmArrivalPopView.dimmedMaskAlpha = self.shadowAlpha;
    [self.confirmArrivalPopView showAtCenter:CGPointMake(DEVICE_WIDTH / 2.0f, DEVICE_HEIGHT / 2.0f) inView:nil];
}

#pragma mark LCCostPlanEvaluationView Delegate
- (void)costPlanEvaluationViewDidCancel:(LCCostPlanEvaluationView *)view {
    [self.costPlanEvaluationPopView dismissPresentingPopup];
    if ([self.delegate respondsToSelector:@selector(popViewHelperDidCancel)]) {
        [self.delegate popViewHelperDidCancel];
    }
}

- (void)popDateSelectedView:(id <LCCalendarChooseDateViewDelegate>)delegate {
    LCCalendarChooseDateView *dateView = [LCCalendarChooseDateView createInstance];
    dateView.allowsMultipleSelection = YES;
    dateView.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
    dateView.delegate = delegate;
    [[LCSharedFuncUtil getAppDelegate].window addSubview:dateView];
}

#pragma mark LCConfirmArrivalView Delegate.
- (void)confirmArrivalDidArrival {
    [LCNetRequester confirmArrival:self.plan.planGuid callBack:^(NSError *error) {
        if (!error) {
            self.plan.isArrived = YES;
            if (self.delegate && [self.delegate respondsToSelector:@selector(popViewConfirmArrival:)]) {
                [self.delegate popViewConfirmArrival:self.plan];
            }
        } else {
            [YSAlertUtil tipOneMessage:error.domain];
        }
    }];
    [self.confirmArrivalPopView dismissPresentingPopup];
}

- (void)confirmArrivalDidNotArrival {
    [self.confirmArrivalPopView dismissPresentingPopup];
}
@end
