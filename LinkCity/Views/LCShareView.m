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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareToWechatViewLeading;
@property (weak, nonatomic) IBOutlet UIView *shareToDuckrView;


@end

@implementation LCShareView

+ (instancetype)createInstance {
    LCShareView *shareView = [[[NSBundle mainBundle] loadNibNamed:@"LCShareView" owner:nil options:nil] objectAtIndex:0];
    [shareView setShareToDuckrHiden:YES];
    return shareView;
}

+ (void)showShareView:(LCShareView *)shareView onViewController:(UIViewController *)vc forPlan:(LCPlanModel *)plan{
    shareView.plan = plan;
    shareView.shareType = LCShareTypePlan;
    [LCShareView showShareView:shareView onViewController:vc];
}

+ (void)showShareView:(LCShareView *)shareView onViewController:(UIViewController *)vc forTourpic:(LCTourpic *)tourpic {
    shareView.shareType = LCShareTypeTourpic;
    shareView.tourpic = tourpic;
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
        shareView.containerView.backgroundColor = UIColorFromRGBA(0x000000, 0.7);
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

- (void)setShareToDuckrHiden:(BOOL)hiden{
    if (hiden) {
        self.shareToDuckrView.hidden = YES;
        self.shareToWechatViewLeading.constant = 0;
    }else{
        self.shareToDuckrView.hidden = NO;
        self.shareToWechatViewLeading.constant = DEVICE_WIDTH/4.0;
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tapGesture{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelShareAction)]) {
        [self.delegate cancelShareAction];
    }
}
- (IBAction)cacelShareAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelShareAction)]) {
        [self.delegate cancelShareAction];
    }
}

- (IBAction)shareWeixinAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareWeixinAction:)]) {
        if (LCShareTypePlan == self.shareType) {
            [self.delegate shareWeixinAction:self.plan];
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareTourpicWeixin:)]) {
        if (LCShareTypeTourpic == self.shareType) {
            [self.delegate shareTourpicWeixin:self.tourpic];
        }
    }
    if ([self.delegate respondsToSelector:@selector(shareWeixinAction)]) {
        [self.delegate shareWeixinAction];
    }
}

- (IBAction)shareWeixinTimeLineAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareWeixinTimeLineAction:)]) {
        [self.delegate shareWeixinTimeLineAction:self.plan];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareTourpicWeixinTimeLine:)]) {
        if (LCShareTypeTourpic == self.shareType) {
            [self.delegate shareTourpicWeixinTimeLine:self.tourpic];
        }
    }
    if ([self.delegate respondsToSelector:@selector(shareWeixinTimeLineAction)]) {
        [self.delegate shareWeixinTimeLineAction];
    }
}

- (IBAction)shareWeiboAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareWeiboAction:)]) {
        [self.delegate shareWeiboAction:self.plan];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareTourpicWeibo:)]) {
        if (LCShareTypeTourpic == self.shareType) {
            [self.delegate shareTourpicWeibo:self.tourpic];
        }
    }
    if ([self.delegate respondsToSelector:@selector(shareWeiboAction)]) {
        [self.delegate shareWeiboAction];
    }
}

- (IBAction)shareDuckrAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareDuckrAction:)]) {
        [self.delegate shareDuckrAction:self.plan];
    }
}

- (IBAction)shareQQAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareQQAction:)]) {
        [self.delegate shareQQAction:self.plan];
    }
    if ([self.delegate respondsToSelector:@selector(shareTourpicQQ:)]) {
        [self.delegate shareTourpicQQ:self.tourpic];
    }
    if ([self.delegate respondsToSelector:@selector(shareQQAction)]) {
        [self.delegate shareQQAction];
    }
}

@end
