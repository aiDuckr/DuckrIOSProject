//
//  LCOrderChooseStageView.h
//  LinkCity
//
//  Created by Roy on 12/22/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCOrderChooseStageViewDelegate;
@interface LCOrderChooseStageView : UIView
@property (nonatomic, strong) LCPlanModel *plan;
@property (nonatomic, weak) id<LCOrderChooseStageViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


+ (instancetype)createInstance;
- (void)updateShowWithPlan:(LCPlanModel *)plan;
@end

@protocol LCOrderChooseStageViewDelegate <NSObject>

- (void)orderChooseStageView:(LCOrderChooseStageView *)v didChooseStage:(LCPartnerStageModel *)stage;
- (void)orderChooseStageViewDidCancel:(LCOrderChooseStageView *)v;

@end
