//
//  LCSendPlanImageAndDescView.h
//  LinkCity
//
//  Created by Roy on 12/29/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCSendPlanImageAndDescViewDelegate;
@interface LCSendPlanImageAndDescView : UIView
@property (nonatomic, weak) id<LCSendPlanImageAndDescViewDelegate> delegate;
@property (nonatomic, strong) LCPlanModel *plan;
@property (nonatomic, assign) NSInteger uploadingImageNum;

@property (weak, nonatomic) IBOutlet UIButton *imgBtnA;
@property (weak, nonatomic) IBOutlet UIButton *imgBtnB;
@property (weak, nonatomic) IBOutlet UIButton *imgBtnC;
@property (weak, nonatomic) IBOutlet SZTextView *descTextView;

+ (instancetype)createInstance;
- (void)updateShowWithPlan:(LCPlanModel *)plan;

@end

@protocol LCSendPlanImageAndDescViewDelegate <NSObject>
@optional
- (void)sendPlanImageAndDescViewDidUpdateImage:(LCSendPlanImageAndDescView *)topView;
- (void)sendPlanImageAndDescViewDidEndInputDescription:(LCSendPlanImageAndDescView *)topView;
- (void)sendPlanImageAndDescViewDidEndUploadImage:(LCSendPlanImageAndDescView *)topView;

@end
