//
//  LCSplashVC.m
//  LinkCity
//
//  Created by roy on 3/25/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCSplashVC.h"
#import "LCUMengHelper.h"

@interface LCSplashVC ()

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoHeight;

@property (nonatomic, strong) UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UIView *tapView;


@property (weak, nonatomic) IBOutlet UIButton *userDeclarationButton;

@end

@implementation LCSplashVC

+ (instancetype)createInstance{
    return (LCSplashVC *)[LCStoryboardManager viewControllerWithFileName:SBNameMain identifier:VCIDSplashVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IS_IPHONE_4_4S || IS_IPHONE_5_5S) {
        self.logoImageView.image = [UIImage imageNamed:@"SplashDuckrLogo"];
        self.logoTop.constant = 69;
        self.logoWidth.constant = 106;
        self.logoHeight.constant = 106;
    }else{
        self.logoImageView.image = [UIImage imageNamed:@"SplashDuckrLogoMin"];
        self.logoTop.constant = 110;
        self.logoWidth.constant = 118;
        self.logoHeight.constant = 118;
    }
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureAction:)];
    longPressGesture.minimumPressDuration = 3;
    [self.tapView addGestureRecognizer:longPressGesture];
    
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont fontWithName:FONT_LANTINGBLACK size:11],
                                NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],
                                NSForegroundColorAttributeName:UIColorFromR_G_B_A(206, 141, 54, 1)};
    NSMutableAttributedString *userDeclarationText = [[NSMutableAttributedString alloc] initWithString:@"使用条款和隐私政策" attributes:attribute];
    [self.userDeclarationButton setAttributedTitle:userDeclarationText forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (IBAction)registerButtonAction:(id)sender {
    [[LCUMengHelper sharedInstance] setup];
    
    AppDelegate *appDelegate = [LCSharedFuncUtil getAppDelegate];
    [appDelegate showTabBarVC];
}
- (IBAction)skipButtonAction:(id)sender {
    [[LCUMengHelper sharedInstance] setup];
    
    [LCDataManager sharedInstance].isFirstTimeOpenApp = NO;
    [[LCDataManager sharedInstance] saveData];
    
    AppDelegate *appDelegate = [LCSharedFuncUtil getAppDelegate];
    [appDelegate showTabBarVC];
}
- (void)longPressGestureAction:(UILongPressGestureRecognizer *)gestureRecognizer{
    //长按则相当于按跳过按钮
    //并永远关闭本App的友盟统计
    [LCDataManager sharedInstance].shouldUMengActive = 0;
    [[LCDataManager sharedInstance] saveData];
    
    [LCNetRequester didBlockUMengWithCallBack:^(NSError *error) {
        LCLogInfo(@"did block UMent with error: %@",error);
    }];
    
    
    [LCDataManager sharedInstance].isFirstTimeOpenApp = NO;
    [[LCDataManager sharedInstance] saveData];
    
    AppDelegate *appDelegate = [LCSharedFuncUtil getAppDelegate];
    [appDelegate showTabBarVC];
}

- (IBAction)userDeclaration:(id)sender {
    [LCViewSwitcher presentWebVCtoShowURL:server_url(SERVER_HOST, LCUserUseAgreementURL) withTitle:@"使用条款和隐私政策"];
}



//#pragma mark Blured image cover
//- (void)showCover{
//    if (!self.coverImageView) {
//        self.coverImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
//        UIImage *screenShot = [LCImageUtil createScreenShot];
//        screenShot = [LCImageUtil blurWithCoreImage:screenShot withRect:self.coverImageView.bounds pixel:2];
//        self.coverImageView.image = screenShot;
//    }
//    [self.view addSubview:self.coverImageView];
//}
//- (void)hideCover{
//    if (self.coverImageView) {
//        [self.coverImageView removeFromSuperview];
//    }
//}
//
//#pragma mark - LCRegisterAndLoginHelperDelegate
//- (void)registerAndLoginhelperDidLogin{
//    
//    [LCDataManager sharedInstance].isFirstTimeOpenApp = NO;
//    [[LCDataManager sharedInstance] saveData];
//    
//    AppDelegate *appDelegate = [LCSharedFuncUtil getAppDelegate];
//    [appDelegate showTabBarVC];
//}
//- (void)registerAndLoginHelperDidCancel{
//}

@end
