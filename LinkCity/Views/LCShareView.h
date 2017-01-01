//
//  LCShareView.h
//  LinkCity
//
//  Created by 张宗硕 on 11/27/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCPlanModel.h"

typedef enum : NSInteger {
    LCShareTypePlan = 1,
    LCShareTypeTourpic = 2,
} LCShareType;

@protocol LCShareViewDelegate <NSObject>
@optional
- (void)cancelShareAction;

- (void)shareWeixinAction:(LCPlanModel *)plan;
- (void)shareWeixinTimeLineAction:(LCPlanModel *)plan;
- (void)shareDuckrAction:(LCPlanModel *)plan;
- (void)shareWeiboAction:(LCPlanModel *)plan;
- (void)shareQQAction:(LCPlanModel *)plan;

- (void)shareTourpicWeixin:(LCTourpic *)tourpic;
- (void)shareTourpicWeixinTimeLine:(LCTourpic *)tourpic;
- (void)shareTourpicWeibo:(LCTourpic *)tourpic;
- (void)shareTourpicQQ:(LCTourpic *)tourpic;

- (void)shareWeixinAction;
- (void)shareWeixinTimeLineAction;
- (void)shareWeiboAction;
- (void)shareQQAction;
@end

@interface LCShareView : UIView
+ (instancetype)createInstance;
/***
 展示分享页面，需要提前设置要分相的计划
 */
+ (void)showShareView:(LCShareView *)shareView onViewController:(UIViewController *)vc;
/***
 展示分享页面
 @param shareView  
 @param vc   将shareView显示在哪个vc上
 @param plan 将分享的plan
 */
+ (void)showShareView:(LCShareView *)shareView onViewController:(UIViewController *)vc forPlan:(LCPlanModel *)plan;
+ (void)showShareView:(LCShareView *)shareView onViewController:(UIViewController *)vc forTourpic:(LCTourpic *)tourpic;
+ (void)dismissShareView:(LCShareView *)shareView onViewController:(UIViewController *)vc animation:(BOOL)animate completion:(void(^)())comp;

- (void)setShareToDuckrHiden:(BOOL)hiden;

@property (nonatomic,strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) id<LCShareViewDelegate> delegate;
@property (nonatomic, retain) LCPlanModel *plan;
@property (nonatomic, retain) LCTourpic *tourpic;
@property (nonatomic, assign) LCShareType shareType;

@end
