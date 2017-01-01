//
//  LCSlideVC.h
//  LinkCity
//
//  Created by roy on 10/25/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

///SlideVC 是一个容器类，继承自UIViewController
///该VC中只有一个 bgImageView 用于显示背景图片
///可容纳一个 menuVC 和一个 contentVC，支持滑动切换两者的显示
///menuVC 和 contentVC 是使用 addChildViewController 的方式添加的


@protocol LCSlideContentVCDelegate;

@interface LCSlideVC : LCBaseVC
//显示在底部，向右滑时显示出来的VC
@property (nonatomic, strong) UIViewController *menuVC;
//显示在上层，容纳App主要内容的VC
@property (nonatomic, strong) UIViewController <LCSlideContentVCDelegate> *contentVC;
//菜单侧边栏的宽度，如果不设置，有默认值
@property (nonatomic, assign) CGFloat menuWidth;
//是否允许点击右侧关闭菜单
@property (nonatomic, assign) BOOL tapGestureEnabled;
//是否允许滑动手势打开菜单
@property (nonatomic, assign) BOOL panGestureEnabled;

//发送一个动画显示菜单的notification
+ (void)showMenu;
//发送一个动画关闭菜单的notification
+ (void)hideMenu;

- (void)showMenuAnimated:(BOOL)animated;
- (void)hideMenuAnimated:(BOOL)animated;

- (void)setBackgroundImage:(UIImage *)image;
@end

//contentViewController 应该遵守的协议
@protocol LCSlideContentVCDelegate <NSObject>
//当前是否允许滑动显示菜单
- (BOOL)canSlideToShowMenu;
@end