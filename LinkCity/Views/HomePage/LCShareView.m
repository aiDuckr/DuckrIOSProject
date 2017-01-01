//
//  LCShareView.m
//  LinkCity
//
//  Created by 张宗硕 on 11/27/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCShareView.h"

#define DEFAULT_SHAREVIEW_HEIGHT 177
#define DEFAULT_SHOW_ANIMATION_DURATION 0.3
#define DEFAULT_DISMISS_ANIMATION_DURATION 0.2

@interface LCShareView()
@end
@implementation LCShareView

+ (instancetype)createInstance {
    return [[[NSBundle mainBundle] loadNibNamed:@"LCShareView" owner:nil options:nil] objectAtIndex:0];;
}

+ (void)showShareView:(LCShareView *)shareView onViewController:(UIViewController *)vc forPlan:(LCPlan *)plan{
    shareView.plan = plan;
    [LCShareView showShareView:shareView onViewController:vc];
}
+ (void)showShareView:(LCShareView *)shareView onViewController:(UIViewController *)vc{
    float vcHeight = vc.view.frame.size.height;
    float vcWidth = vc.view.frame.size.width;
    if (!shareView.containerView) {
        shareView.containerView = [[UIView alloc]initWithFrame:vc.view.bounds];
    }
    if (!shareView.tapGesture) {
        shareView.tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:shareView action:@selector(tapAction:)];
        [shareView.containerView addGestureRecognizer:shareView.tapGesture];
    }
    
    [vc.view addSubview:shareView.containerView];
    shareView.containerView.frame = vc.view.bounds;
    shareView.backgroundColor = UIColorFromRGBA(0x000000, 0);
    
    [shareView.containerView addSubview:shareView];
    shareView.frame = CGRectMake(0, vcHeight, vcWidth, DEFAULT_SHAREVIEW_HEIGHT);
    
    [UIView animateWithDuration:DEFAULT_SHOW_ANIMATION_DURATION delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^(){
        shareView.containerView.backgroundColor = UIColorFromRGBA(0x000000, 0.3);
        shareView.frame = CGRectMake(0,
                                     vcHeight-DEFAULT_SHAREVIEW_HEIGHT,
                                     vcWidth,
                                     DEFAULT_SHAREVIEW_HEIGHT);
    } completion:nil];
}

+ (void)dismissShareView:(LCShareView *)shareView onViewController:(UIViewController *)vc animation:(BOOL)animate completion:(void (^)())comp{
    float vcHeight = vc.view.frame.size.height;
    float vcWidth = vc.view.frame.size.width;
    
    if (animate) {
        [UIView animateWithDuration:DEFAULT_DISMISS_ANIMATION_DURATION delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^(){
            shareView.containerView.backgroundColor = UIColorFromRGBA(0x000000, 0);
            shareView.frame = CGRectMake(0,
                                         vcHeight,
                                         vcWidth,
                                         DEFAULT_SHAREVIEW_HEIGHT);
        } completion:^(BOOL finished){
            [shareView.containerView removeFromSuperview];
            if (comp) {
                comp();
            }
        }];
    }else{
        [shareView.containerView removeFromSuperview];
        if (comp) {
            comp();
        }
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tapGesture{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelShareAction)]) {
        [self.delegate cancelShareAction];
    }
}
- (IBAction)cacelShareAction:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelShareAction)])
    {
        [self.delegate cancelShareAction];
    }
}

- (IBAction)shareWeixinAction:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareWeixinAction:)])
    {
        [self.delegate shareWeixinAction:self.plan];
    }
}

- (IBAction)shareWeixinTimeLineAction:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareWeixinTimeLineAction:)])
    {
        [self.delegate shareWeixinTimeLineAction:self.plan];
    }
}

- (IBAction)shareDuckrAction:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareDuckrAction:)])
    {
        [self.delegate shareDuckrAction:self.plan];
    }
}

- (IBAction)shareWeiboAction:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareWeiboAction:)])
    {
        [self.delegate shareWeiboAction:self.plan];
    }
}

- (IBAction)shareRenrenAction:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareRenrenAction:)])
    {
        [self.delegate shareRenrenAction:self.plan];
    }
}

@end
