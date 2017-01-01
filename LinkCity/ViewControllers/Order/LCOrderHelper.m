//
//  LCOrderHelper.m
//  LinkCity
//
//  Created by Roy on 12/23/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCOrderHelper.h"

@interface LCOrderHelper()<LCOrderChooseStageViewDelegate, LCOneDatePickViewDelegate>

//Inner Date
@property (nonatomic, strong) LCPartnerStageModel *selectedStage;
@end

@implementation LCOrderHelper

+ (instancetype)instanceWithNavVC:(UINavigationController *)navVC{
    LCOrderHelper *instance = [[LCOrderHelper alloc] init];
    instance.navVC = navVC;
    
    return instance;
}

#pragma mark Get & Set
- (LCOneDatePickView *)oneDatePickView{
    if (!_oneDatePickView) {
        _oneDatePickView = [LCOneDatePickView createInstanceWithVC:[LCSharedFuncUtil getTopMostViewController]];
    }
    return _oneDatePickView;
}

- (void)startToOrderPlan:(LCPlanModel *)plan recmdUuid:(NSString *)recmdUuid{
    self.plan = plan;
    self.recmdUuid = recmdUuid;
    
    NSArray *selectableStageArray = plan.canSelectedStage;
    if (selectableStageArray.count <= 0) {
        //没有可以买的分期
        [YSAlertUtil tipOneMessage:@"所有活动都已经开始或者报满了"];
    }else{
        if ([self.plan isMerchantCostPlan]) {
            //如果是商家发的商品，弹出分期选择对话框，选分期
            [self showChooseStageView];
        }else{
            //否则，是拼车收费邀约，直接购买第一期
            self.stage = self.plan.stageArray.firstObject;
            [self showOrderVC];
        }
    }
}

- (void)showChooseStageView{
    if (!self.chooseStageView) {
        self.chooseStageView = [LCOrderChooseStageView createInstance];
        self.chooseStageView.delegate = self;
    }
    [self.chooseStageView updateShowWithPlan:self.plan];
    NSArray *canChoosedStageArr = self.plan.canSelectedStage;
    // 设置日历价格数据
    [self.oneDatePickView.calendarHomeVC setCostPlanStageArr:canChoosedStageArr];
    
    if (!self.choosePickup) {
        _oneDatePickView.delegate = self;
        self.choosePickup = [KLCPopup popupWithContentView:self.oneDatePickView
                                                  showType:KLCPopupShowTypeSlideInFromBottom
                                               dismissType:KLCPopupDismissTypeSlideOutToBottom
                                                  maskType:KLCPopupMaskTypeDimmed
                                  dismissOnBackgroundTouch:YES
                                     dismissOnContentTouch:NO];
        self.choosePickup.dimmedMaskAlpha = 0.5;
    }
    
    [self.choosePickup showWithLayout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutBottom)];
}

#pragma mark OneDatePickView Delegate
- (void)oneDatePickView:(LCOneDatePickView *)v didSelectOneDate:(NSString *)dateStr{
    self.selectedStage = nil;
    for (LCPartnerStageModel *stage in self.plan.stageArray) {
        if ([stage.startTime isEqualToString:dateStr]) {
            self.selectedStage = stage;
            break ;
        }
    }
    if (nil == self.selectedStage) {
        [YSAlertUtil tipOneMessage:@"没有该时间出发的邀约" onView:v yoffset:TipDefaultYoffset delay:TipErrorDelay];
        return ;
    }
//    if (self.selectedStage) {
//        self.selectedStage.startTime = dateStr;
//        NSLog(@"time is%@", self.selectedStage.startTime);
//    }
    
    [self.choosePickup dismiss:YES];
    if ([self.plan getPlanRelation] == LCPlanRelationCreater) {
        [YSAlertUtil tipOneMessage:@"您不能购买自己创建的邀约" yoffset:TipDefaultYoffset delay:TipErrorDelay];
        return;
    }

    if (self.selectedStage.isMember == YES) {
        [YSAlertUtil tipOneMessage:@"您已经购买过该期活动，不能重复购买" yoffset:TipDefaultYoffset delay:TipErrorDelay];
    } else {
        self.stage = self.selectedStage;
        [self showOrderVC];
        // 发送请求添加到待支付订单
        [self requestToAddOrderToCart];
    }
}

- (void)showOrderVC{
    if (!self.orderVC) {
        self.orderVC = [LCOrderVC createInstance];
    }
    
    [self.orderVC updateShowWithPlan:self.plan selectedStage:self.stage recmdUuid:self.recmdUuid];
    [self.navVC pushViewController:self.orderVC animated:YES];
}

#pragma mark LCOrderChooseStageViewDelegate
- (void)orderChooseStageViewDidCancel:(LCOrderChooseStageView *)v{
    [self.choosePickup dismiss:YES];
}

- (void)orderChooseStageView:(LCOrderChooseStageView *)v didChooseStage:(LCPartnerStageModel *)stage{
    
    if (stage.isMember == YES) {
        [YSAlertUtil tipOneMessage:@"您已经购买过该期活动，不能重复购买" onView:v yoffset:TipDefaultYoffset delay:TipErrorDelay];
    }else{
        self.stage = stage;
        [self.choosePickup dismiss:YES];
        [self showOrderVC];
    }
}

#pragma mark - Net Request

- (void)requestToAddOrderToCart {
    [LCNetRequester addToCartByPlanGuid:self.plan.planGuid callBack:^(NSError *error) {
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipDefaultDelay];
        }
    }];
}


@end
