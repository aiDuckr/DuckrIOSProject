//
//  LCMerchantAccountVC.m
//  LinkCity
//
//  Created by 张宗硕 on 6/16/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCMerchantAccountVC.h"
#import "LCMerchantWithdrawVC.h"

@interface LCMerchantAccountVC ()
@property (weak, nonatomic) IBOutlet UIButton *withdrawButton;
@property (weak, nonatomic) IBOutlet UILabel *totalBalanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *availBalanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *uncollectedLabel;

@end

@implementation LCMerchantAccountVC

#pragma mark - Public Interface
+ (instancetype)createInstance {
    return (LCMerchantAccountVC *)[LCStoryboardManager viewControllerWithFileName:SBNameUserTab identifier:VCIDMerchantAccountVC];
}

#pragma mark - LifeCycle.
- (void)commonInit {
    [super commonInit];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.withdrawButton.layer.borderColor = UIColorFromRGBA(0xc9c5c1, 1.0f).CGColor;
    self.withdrawButton.layer.borderWidth = 0.5f;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateShow];
}

- (void)updateShow {
    LCUserAccount *account = [LCDataManager sharedInstance].merchantAccount;
    if (nil != account) {
        self.totalBalanceLabel.text = [NSString stringWithFormat:@"%@", account.totalBalance];
        self.availBalanceLabel.text = [NSString stringWithFormat:@"%@", account.availBalance];
        self.uncollectedLabel.text = [NSString stringWithFormat:@"%@", account.uncollected];
    }
}

- (IBAction)withdrawAction:(id)sender {
    //TODO: 检查是否不够余额提现
    LCMerchantWithdrawVC *vc = [LCMerchantWithdrawVC createInstance];
    [self.navigationController pushViewController:vc animated:APP_ANIMATION];
}

@end
