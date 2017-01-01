//
//  LCMerchantWithdrawVC.m
//  LinkCity
//
//  Created by 张宗硕 on 6/17/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCMerchantWithdrawVC.h"
#import "LCMerchantBankcardVC.h"

@interface LCMerchantWithdrawVC ()<LCMerchantBankcardVCDelegate>
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankcardNumLabel;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;
@property (strong, nonatomic) LCBankcard *choosedBankcard;
@property (strong, nonatomic) LCUserAccount *account;
@end

@implementation LCMerchantWithdrawVC

#pragma mark - Public Interface
+ (instancetype)createInstance {
    return (LCMerchantWithdrawVC *)[LCStoryboardManager viewControllerWithFileName:SBNameUserTab identifier:VCIDMerchantWithdrawVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.choosedBankcard = nil;
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
    self.account = [LCDataManager sharedInstance].merchantAccount;
    
    if (nil != self.account) {
        if (nil != self.account.bankcardArr && self.account.bankcardArr.count > 0) {
            if (nil == self.choosedBankcard) {
                self.choosedBankcard = [self.account.bankcardArr objectAtIndex:0];
            }
            self.bankNameLabel.text = self.choosedBankcard.belongedBank;
            self.bankcardNumLabel.text = self.choosedBankcard.bankcardNumber;
        } else {
            [YSAlertUtil tipOneMessage:@"请先绑定银行卡"];
            [self pushToShowMerchantBankcardVC];
        }
        
        self.hintLabel.text = [NSString stringWithFormat:@"可提现金额%@元", self.account.availBalance];
    }
}

- (void)requestWithdraw {
    if (nil != self.choosedBankcard) {
        [LCNetRequester requestMerchantWithdraw:self.choosedBankcard withAmount:self.moneyTextField.text callBack:^(NSError *error) {
            if (!error) {
                [YSAlertUtil tipOneMessage:@"提现请求发送成功"];
                [self.navigationController popViewControllerAnimated:APP_ANIMATION];
            } else {
                [YSAlertUtil tipOneMessage:error.domain];
            }
        }];
    } else {
        [YSAlertUtil tipOneMessage:@"请先绑定银行卡"];
    }
}

- (IBAction)withdrawAction:(id)sender {
    [self.moneyTextField resignFirstResponder];
    if ([LCStringUtil isNullString:self.moneyTextField.text]) {
        [YSAlertUtil tipOneMessage:@"请输入提现金额"];
        return ;
    }
    [self requestWithdraw];
}

- (IBAction)changeBankAction:(id)sender {
    [self pushToShowMerchantBankcardVC];
}

- (void)pushToShowMerchantBankcardVC {
    LCMerchantBankcardVC *vc = [LCMerchantBankcardVC createInstance];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:APP_ANIMATION];
}

- (void)didSelectedBankcard:(LCBankcard *)bankcard {
    self.choosedBankcard = bankcard;
}
@end
