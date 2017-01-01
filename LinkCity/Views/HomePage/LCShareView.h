//
//  LCShareView.h
//  LinkCity
//
//  Created by 张宗硕 on 11/27/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCPlan.h"

@protocol LCShareViewDelegate <NSObject>
@required
- (void)cancelShareAction;
- (void)shareWeixinAction:(LCPlan *)plan;
- (void)shareWeixinTimeLineAction:(LCPlan *)plan;
- (void)shareDuckrAction:(LCPlan *)plan;
- (void)shareWeiboAction:(LCPlan *)plan;
- (void)shareRenrenAction:(LCPlan *)plan;
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
+ (void)showShareView:(LCShareView *)shareView onViewController:(UIViewController *)vc forPlan:(LCPlan *)plan;
+ (void)dismissShareView:(LCShareView *)shareView onViewController:(UIViewController *)vc animation:(BOOL)animate completion:(void(^)())comp;

@property (nonatomic,strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) id<LCShareViewDelegate> delegate;
@property (nonatomic, retain) LCPlan *plan;

@end
