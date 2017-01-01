//
//  LCBaseVC.h
//  LinkCity
//
//  Created by zzs on 14/11/29.
//  Copyright (c) 2014年 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableView+BlankView.h"

@interface LCBaseVC : UIViewController
@property (nonatomic,assign) BOOL haveLayoutSubViews;   //
@property (nonatomic,assign) BOOL statisticByMob;   //是否进行友盟统计
@property (nonatomic,assign) BOOL isAppearing;     //是否在viewWillAppear 和  viewWillDisappear 之间的状态
@property (nonatomic,assign, readonly) BOOL isViewWillAppearCalledFirstTime;  //是否第一次调用viewWillAppear

@property (nonatomic,assign) BOOL isHaveTabBar;
@property (nonatomic,assign) CGFloat keyBoardHeight;
@property (nonatomic,assign) BOOL isShowingKeyboard;
@property (nonatomic,assign) BOOL isJustShowKeyboard;

+ (instancetype)createInstance;

//must call [super commonInit] when override this func
- (void)commonInit; //任何初始化方式都会调用该方法； 子类可以复写该方法进行初始化参数设置


- (BOOL)haveLogin;

//Tobe override
- (void)keyboardWillShow:(NSNotification *)aNotification;
- (void)keyboardWillBeHidden:(NSNotification*)aNotification;

- (UIView *)getFirstResponderOfView:(UIView *)v;
@end
