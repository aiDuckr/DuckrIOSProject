//
//  LCMerchantRefundDetailVC.m
//  LinkCity
//
//  Created by 张宗硕 on 6/15/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCMerchantRefundDetailVC.h"
#import "LCMerchantConfirmRefundVC.h"

@interface LCMerchantRefundDetailVC ()<LCMerchantConfirmRefundVCDelegate>
@property (weak, nonatomic) IBOutlet UILabel *refundTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *planTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *payTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderSumLabel;
@property (weak, nonatomic) IBOutlet UILabel *refundReasonLabel;
@property (weak, nonatomic) IBOutlet UIButton *telButton;
@property (weak, nonatomic) IBOutlet UILabel *refundInfoLabel;


@end

@implementation LCMerchantRefundDetailVC

#pragma mark - Public Interface
+ (instancetype)createInstance {
    return (LCMerchantRefundDetailVC *)[LCStoryboardManager viewControllerWithFileName:SBNameUserTab identifier:VCIDMerchantRefundDetailVC];
}

#pragma mark - LifeCycle.
- (void)commonInit {
    [super commonInit];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self headerRefreshAction];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateShow];
}

- (void)headerRefreshAction {
    if ([LCStringUtil isNullString:self.user.partnerOrder.guid]) {
        [YSAlertUtil tipOneMessage:@"无订单的ID"];
    }
    [self requestMerchantRefundDetail];
}

- (void)updateShow {
    if (nil != self.plan && nil != self.user && nil != self.user.partnerOrder) {
        self.refundTimeLabel.text = [LCDateUtil getTimeIntervalStringFromDateString:self.user.partnerOrder.refundTime];
        self.nickLabel.text = self.user.nick;
        self.planTitleLabel.text = self.plan.declaration;
        self.payTimeLabel.text = self.user.partnerOrder.createdTime;
        self.orderNumLabel.text = [NSString stringWithFormat:@"%ld人", (long)self.user.partnerOrder.orderNumber];
        self.orderSumLabel.text = [NSString stringWithFormat:@"%@", self.user.partnerOrder.orderPay];
        if ([LCStringUtil isNotNullString:self.user.partnerOrder.orderRefundReason]) {
            self.refundReasonLabel.text = self.user.partnerOrder.orderRefundReason;
        } else {
            self.refundReasonLabel.text = @"无";
        }
        [self.telButton setTitle:self.user.telephone forState:UIControlStateNormal];
        if ([LCStringUtil isNotNullString:self.plan.refundIntro]) {
            self.refundInfoLabel.text = self.plan.refundIntro;
        } else {
            self.refundInfoLabel.text = @"无";
        }
    }
}

/// 拉取我的服务列表.
- (void)requestMerchantRefundDetail {
    [LCNetRequester requestMerchantRefundDetail:self.user.partnerOrder.guid callBack:^(LCPlanModel *plan, LCUserModel *user, NSError *error) {
        if (!error) {
            if (nil != plan && nil != user) {
                self.plan = plan;
                self.user = user;
            } else {
                [YSAlertUtil tipOneMessage:@"获取退款申请详情失败"];
            }
            
            [self updateShow];
        } else {
            [YSAlertUtil tipOneMessage:error.domain];
        }
    }];
}

- (IBAction)agreeRefundAction:(id)sender {
    LCMerchantConfirmRefundVC *vc = [LCMerchantConfirmRefundVC createInstance];
    vc.delegate = self;
    vc.user = self.user;
    [self.navigationController pushViewController:vc animated:APP_ANIMATION];
}

- (void)confirmRefundSuccess {
    [self.navigationController popViewControllerAnimated:APP_ANIMATION];
}

@end
