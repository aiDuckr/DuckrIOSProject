//
//  LCMerchantAddCardVC.m
//  LinkCity
//
//  Created by 张宗硕 on 6/17/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCMerchantAddCardVC.h"
#import "LCChooseBankVC.h"

@interface LCMerchantAddCardVC ()<LCChooseBankVCDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *cardTextField;
@property (weak, nonatomic) IBOutlet UILabel *bankLabel;
@property (strong, nonatomic) LCBankcard *bankcard;

@end

@implementation LCMerchantAddCardVC

#pragma mark - Public Interface
+ (instancetype)createInstance {
    return (LCMerchantAddCardVC *)[LCStoryboardManager viewControllerWithFileName:SBNameUserTab identifier:VCIDMerchantAddCardVC];
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
    [self.nameTextField resignFirstResponder];
    [self.cardTextField resignFirstResponder];
}

- (void)requestAddCard {
    [LCNetRequester requestMerchantAddBankcard:self.bankcard callBack:^(LCUserAccount *account, NSError *error) {
        if (!error) {
            [YSAlertUtil tipOneMessage:@"绑定成功！"];
            [LCDataManager sharedInstance].merchantAccount = account;
            [self.navigationController popViewControllerAnimated:APP_ANIMATION];
        } else {
            [YSAlertUtil tipOneMessage:error.domain];
        }
    }];
}

- (IBAction)chooseBankAction:(id)sender {
    LCChooseBankVC *vc = [LCChooseBankVC createInstance];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:APP_ANIMATION];
}

- (void)didSelectedBankName:(NSString *)bankName {
    self.bankLabel.text = bankName;
}

- (IBAction)nextStepAction:(id)sender {
    [self.nameTextField resignFirstResponder];
    [self.cardTextField resignFirstResponder];
    
    NSString *name = self.nameTextField.text;
    NSString *num = self.cardTextField.text;
    NSString *bankName = self.bankLabel.text;
    if ([LCStringUtil isNullString:name]) {
        [YSAlertUtil tipOneMessage:@"请输入持卡人"];
        return;
    }
    if ([LCStringUtil isNullString:num]) {
        [YSAlertUtil tipOneMessage:@"请输入账号"];
        return;
    }
    if ([LCStringUtil isNullString:bankName] || [bankName isEqualToString:@"选择银行"]) {
        [YSAlertUtil tipOneMessage:@"请选择银行"];
        return;
    }
    self.bankcard = [[LCBankcard alloc] init];
    self.bankcard.userName = name;
    self.bankcard.bankcardNumber = num;
    self.bankcard.belongedBank = bankName;
    [self requestAddCard];
}

@end
