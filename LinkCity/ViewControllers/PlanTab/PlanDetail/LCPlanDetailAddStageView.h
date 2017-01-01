//
//  LCPlanDetailAddStageView.h
//  LinkCity
//
//  Created by Roy on 8/15/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSInteger {
    LCAddStageViewShowingType_Add = 0,
    LCAddStageViewShowingType_Update = 1,
} LCAddStageViewShowingType;


@protocol LCPlanDetailAddStageViewDelegate;
@interface LCPlanDetailAddStageView : UIView

//UI
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) IBOutlet UILabel *timeAndFeeTitleLabel;

@property (weak, nonatomic) IBOutlet UIView *timeAndFeeView;
@property (weak, nonatomic) IBOutlet UILabel *stageLabel;
@property (weak, nonatomic) IBOutlet UITextField *timeTextField;
@property (weak, nonatomic) IBOutlet UIButton *timeButton;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;

@property (weak, nonatomic) IBOutlet UIView *timeAndPriceMaskView;


@property (weak, nonatomic) IBOutlet UILabel *memberNumLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *memberNumLabelLeftSpace;
@property (weak, nonatomic) IBOutlet UISlider *memberNumSlider;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;


@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewBottom;

//Data
@property (nonatomic, strong) id<LCPlanDetailAddStageViewDelegate> delegate;
@property (nonatomic, assign) LCAddStageViewShowingType showingType;
@property (nonatomic, strong) LCPlanModel *plan;
@property (nonatomic, strong) LCPartnerStageModel *stage;

+ (instancetype)createInstance;
- (void)showAsAddStageForPlan:(LCPlanModel *)plan;
- (void)showAsEditStageForStage:(LCPartnerStageModel *)stage plan:(LCPlanModel *)plan;
- (void)showAsEditScaleForStage:(LCPartnerStageModel *)stage plan:(LCPlanModel *)plan;
@end


@protocol LCPlanDetailAddStageViewDelegate <NSObject>

- (void)addStageViewCanceled:(LCPlanDetailAddStageView *)stageView;
- (void)addStageView:(LCPlanDetailAddStageView *)stageView didChooseStartDate:(NSString *)startDateStr endDate:(NSString *)endDateStr;

- (void)addStageView:(LCPlanDetailAddStageView *)stageView didAddOrUpdateStage:(LCPlanModel *)plan;
- (void)addStageViewDidClickDeleteBtn:(LCPlanDetailAddStageView *)stageView;

@end
