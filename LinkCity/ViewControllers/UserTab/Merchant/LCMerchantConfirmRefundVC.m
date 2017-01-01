//
//  LCMerchantConfirmRefundVC.m
//  LinkCity
//
//  Created by 张宗硕 on 6/15/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCMerchantConfirmRefundVC.h"

@interface LCMerchantConfirmRefundVC ()
@property (weak, nonatomic) IBOutlet UIButton *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;

@end

@implementation LCMerchantConfirmRefundVC

#pragma mark - Public Interface
+ (instancetype)createInstance {
    return (LCMerchantConfirmRefundVC *)[LCStoryboardManager viewControllerWithFileName:SBNameUserTab identifier:VCIDMerchantConfirmRefundVC];
}

#pragma mark - LifeCycle.
- (void)commonInit {
    [super commonInit];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    if (nil != self.view) {
        [self.view addGestureRecognizer:singleTap];
    }
}

- (void)handleSingleTap:(id)sender {
    [self.moneyTextField resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateShow];
}

- (void)updateShow {
    if (nil != self.user) {
        self.nickLabel.text = self.user.nick;
        [self.avatarImageView setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:self.user.avatarThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
    }
}

- (IBAction)avatarAction:(id)sender {
    if (nil != self.user) {
        [LCViewSwitcher pushToShowUserInfoVCForUser:self.user on:self.navigationController];
    }
}

- (IBAction)confirmAction:(id)sender {
    [self.moneyTextField resignFirstResponder];
    if ([LCStringUtil isNotNullString:self.moneyTextField.text]) {
        [LCNetRequester requestMerchantAgreeRefund:self.user.partnerOrder.guid withMoney:self.moneyTextField.text callBack:^(NSError *error) {
            if (!error) {
                [YSAlertUtil tipOneMessage:@"处理成功"];
                [self.navigationController popViewControllerAnimated:APP_ANIMATION];
                if (self.delegate && [self.delegate respondsToSelector:@selector(confirmRefundSuccess)]) {
                    [self.delegate confirmRefundSuccess];
                }
            } else {
                [YSAlertUtil tipOneMessage:error.domain];
            }
        }];
    } else {
        [YSAlertUtil tipOneMessage:@"请输入合法金额"];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
