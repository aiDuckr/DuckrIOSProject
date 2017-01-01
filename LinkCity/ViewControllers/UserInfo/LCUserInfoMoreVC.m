//
//  LCUserInfoMoreVC.m
//  LinkCity
//
//  Created by godhangyu on 16/6/10.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCUserInfoMoreVC.h"
#import "LCUserInfoSetRemarkVC.h"
#import "LCUserReportVC.h"

@interface LCUserInfoMoreVC ()
// UI
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remarkViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *setRemarkButton;
@property (weak, nonatomic) IBOutlet UIButton *reportButton;
@property (weak, nonatomic) IBOutlet UIButton *unFavorButton;

@end

@implementation LCUserInfoMoreVC

+ (instancetype)createInstance {
    return (LCUserInfoMoreVC *)[LCStoryboardManager viewControllerWithFileName:SBNameUser identifier:VCIDUserInfoMoreVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[self initNavigationBar];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //[self initNavigationBar];
}

#pragma mark - Common Init

- (void)initNavigationBar {
    self.navigationController.navigationBar.tintColor = UIColorFromRGBA(NavigationBarTintColor, 1);
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

- (void)initUI {
    if (!self.user.isFavored) {
        self.remarkViewHeight.constant = 0;
        self.unFavorButton.hidden = YES;
    }
}

#pragma mark - Actions

- (IBAction)setRemarkButtonAction:(id)sender {
    LCUserInfoSetRemarkVC *userInfoSetRemarkVC = [LCUserInfoSetRemarkVC createInstance];
    userInfoSetRemarkVC.user = self.user;
    [self.navigationController pushViewController:userInfoSetRemarkVC animated:YES];
}

- (IBAction)blockSwitchAction:(id)sender {
    UISwitch *switchButton = (UISwitch *)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        [[LCXMPPMessageHelper sharedInstance] blockUserOfJid:self.user.openfireAccount];
    } else {
        [[LCXMPPMessageHelper sharedInstance] unBlockUserOfJid:self.user.openfireAccount];
    }
}

- (IBAction)reportButtonAction:(id)sender {
    LCUserReportVC *userReportVC = [LCUserReportVC createInstance];
    userReportVC.user = self.user;
    [self.navigationController pushViewController:userReportVC animated:YES];
}

- (IBAction)unFavorButtonAction:(id)sender {
    [LCNetRequester unfollowUser:self.user.uUID callBack:^(LCUserModel *user, NSError *error) {
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
        } else {
            self.user.isFavored = 0;
            [YSAlertUtil tipOneMessage:@"取消关注成功" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
            [self.navigationController popViewControllerAnimated:NO];
        }
    }];
}

@end
