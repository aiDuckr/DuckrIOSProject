//
//  LCBaseVC.m
//  LinkCity
//
//  Created by zzs on 14/11/29.
//  Copyright (c) 2014年 linkcity. All rights reserved.
//

#import "LCBaseVC.h"
#import "MBProgressHUD.h"
#import "LCSharedFuncUtil.h"
@interface LCBaseVC ()
@property (nonatomic, strong) MBProgressHUD *hud;

//nav bar的保存恢复机制，在iso7上千万与透明bar切换时，动画显示是黑的
////保存上一个VC的navigationBar设置
//@property (nonatomic, assign) BOOL formerTranslucent;
//@property (nonatomic, strong) UIImage *formerBgImage;
//@property (nonatomic, strong) UIColor *formerBarTintColor;
@end

@implementation LCBaseVC

+ (instancetype)createInstance{
    NSAssert(NO, @"Sub class of LCBaseVC must override +createInstance");//断言
    return nil;
}

#pragma mark - inits

- (instancetype)init{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _haveLayoutSubViews = NO;
    _statisticByMob = YES;
    _isAppearing = NO;
    _isViewWillAppearCalledFirstTime = YES;
    _isShowingKeyboard = NO;
    _isJustShowKeyboard = NO;
    _isHaveTabBar = NO;
}

#pragma mark LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _isAppearing = YES;
    NSString *currentControllerName = NSStringFromClass([self class]);
    
    if (self.statisticByMob) {
        [MobClick beginLogPageView:currentControllerName];
    }
    if (self.isHaveTabBar) {
        //
        
        //[[LCSharedFuncUtil getAppDelegate].tabBarVC plusButton].hidden = NO;
//        [[LCSharedFuncUtil getAppDelegate].tabBarVC bringPlusViewFront];
        //[LCSharedFuncUtil getAppDelegate].tabBarVC
    }
    //else {
//        [[LCSharedFuncUtil getAppDelegate].tabBarVC plusButton].hidden = YES;
//    }
    [self registerForKeyboardNotifications];
    
//    //保存上一个VC的navigationBar设置
//    self.formerTranslucent = self.navigationController.navigationBar.translucent;
//    self.formerBgImage = [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
//    self.formerBarTintColor = self.navigationController.navigationBar.barTintColor;
}

- (void)viewDidLayoutSubviews {
    _haveLayoutSubViews = YES;
    [super viewDidLayoutSubviews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationController.navigationBar.translucent = YES;
    _isViewWillAppearCalledFirstTime = NO;
    
//    [[LCSharedFuncUtil getAppDelegate].tabBarVC bringPlusViewFront];
    //[LCSharedFuncUtil getAppDelegate].tabBarVC

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    _isAppearing = NO;
    
    NSString *currentControllerName = NSStringFromClass([self class]);
    if (self.statisticByMob) {
        [MobClick endLogPageView:currentControllerName];
    }
    
    [self unregisterForKeyboardNotifications];
    
//    //恢复上一个VC的navigationBar设置
//    self.navigationController.navigationBar.translucent = self.formerTranslucent;
//    [self.navigationController.navigationBar setBackgroundImage:self.formerBgImage forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.barTintColor = self.formerBarTintColor;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //if (self.isHaveTabBar) {
        //
        
        //[[LCSharedFuncUtil getAppDelegate].tabBarVC plusButton].hidden = NO;
        //[[LCSharedFuncUtil getAppDelegate].tabBarVC bringPlusViewFront];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - login
- (BOOL)haveLogin {
    return [[LCDataManager sharedInstance] haveLogin];
}

#pragma mark Keyboards
- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
}

- (void)unregisterForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)aNotification {
    
}

//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    //LCLogInfo(@"keyboardHeight:%f",kbSize.height);
    self.keyBoardHeight = kbSize.height;
    
    self.isShowingKeyboard = YES;
    self.isJustShowKeyboard = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isJustShowKeyboard = NO;
    });
}

//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    self.isShowingKeyboard = NO;
}

#pragma mark
- (UIView *)getFirstResponderOfView:(UIView *)v {
    if (v.isFirstResponder) {
        return v;
    } else {
        for (UIView *subV in v.subviews) {
            UIView *res = [self getFirstResponderOfView:subV];
            if (res) {
                return res;
            }
        }
    }
    return nil;
}

@end
