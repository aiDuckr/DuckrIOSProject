//
//  LCCostPlanEvaluationView.h
//  LinkCity
//
//  Created by 张宗硕 on 12/23/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCStarRatingView.h"

@protocol LCCostPlanEvaluationViewDelegate;

@interface LCCostPlanEvaluationView : UIView<StarRatingViewDelegate>
@property (nonatomic,weak) id<LCCostPlanEvaluationViewDelegate> delegate;
@property (retain, nonatomic) LCPlanModel *plan;

+ (instancetype)createInstance;
- (void)updateShowEvaluationView:(LCPlanModel *)plan;
@end

@protocol LCCostPlanEvaluationViewDelegate <NSObject>
@optional
- (void)costPlanEvaluationViewDidCancel:(LCCostPlanEvaluationView *)view;
@end