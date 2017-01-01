//
//  LCOrderFinishVC.m
//  LinkCity
//
//  Created by Roy on 12/23/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCOrderFinishVC.h"
#import "LCRefundVC.h"

@interface LCOrderFinishVC ()
@property (weak, nonatomic) IBOutlet UIImageView *ticketBottomImageView;
@property (weak, nonatomic) IBOutlet UIImageView *ticketTopImageView;
@property (weak, nonatomic) IBOutlet UILabel *ticketTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ticketTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *ticketPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *ticketNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderUserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointCashLabel;
@property (weak, nonatomic) IBOutlet UILabel *payCashLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;

@property (weak, nonatomic) IBOutlet UIButton *contactUsButton;
@property (weak, nonatomic) IBOutlet UIButton *enterGroupButton;
@end

@implementation LCOrderFinishVC

+ (instancetype)createInstance{
    return (LCOrderFinishVC *)[LCStoryboardManager viewControllerWithFileName:SBNameOrder_V_3_3 identifier:NSStringFromClass([LCOrderFinishVC class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"支付成功";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneBtnAction:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"退款" style:UIBarButtonItemStylePlain target:self action:@selector(refundBtnAction:)];
    
    UIImage *topBgImage = [UIImage imageNamed:@"PlanOrderTicketTop"];
    topBgImage = [topBgImage resizableImageWithCapInsets:UIEdgeInsetsMake(2.0f, 0.0f, 304.0f, 40.0f) resizingMode:UIImageResizingModeStretch];
    self.ticketTopImageView.image = topBgImage;
    
    UIImage *bottomImage = [UIImage imageNamed:@"PlanOrderTicketBottom"];
    bottomImage = [bottomImage resizableImageWithCapInsets:UIEdgeInsetsMake(20.0f, 20.0f, 304.0f, 10.0f) resizingMode:UIImageResizingModeStretch];
    self.ticketBottomImageView.image = bottomImage;
    
    self.contactUsButton.layer.masksToBounds = YES;
    self.contactUsButton.layer.cornerRadius = 3;
    self.contactUsButton.layer.borderColor = UIColorFromRGBA(0xc9c5c1, 1).CGColor;
    self.contactUsButton.layer.borderWidth = 0.5;
    
    self.enterGroupButton.layer.masksToBounds = YES;
    self.enterGroupButton.layer.cornerRadius = 3;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self updateShow];
}

- (void)updateShow{
    self.ticketTitleLabel.text = self.plan.declaration;
    if (self.plan.daysLong == 0) {
        self.plan.daysLong = 1;
    }
    self.ticketTimeLabel.text = [NSString stringWithFormat:@"出发时间：%@   全程%ld天",
                               [LCDateUtil getDotDateFromHorizontalLineStr:self.plan.startTime],
                               (long)self.plan.daysLong];
    self.ticketPriceLabel.text = [NSString stringWithFormat:@"%@", self.planOrder.orderPrice];
    self.ticketNumLabel.text = [NSString stringWithFormat:@"%ld张", (long)self.planOrder.orderNumber];
    self.orderCodeLabel.text = self.planOrder.orderCode;
    
    if ([self.plan isMerchantCostPlan]) {
        self.tipLabel.text = @"活动当天请出示此活动券给领队，勿将此码透露给他人";
    }else{
        self.tipLabel.text = @"出行不天请出示此活动券给司机，勿将此码透露给他人";
    }
    
    if (self.planOrder.orderContactNameArray.count > 0) {
        self.orderUserNameLabel.text = [LCStringUtil getNotNullStr:[self.planOrder.orderContactNameArray firstObject]];
    }else{
        self.orderUserNameLabel.text = @"";
    }
    
    self.pointCashLabel.text = [NSString stringWithFormat:@"￥%@", self.planOrder.orderScoreCash];
    self.payCashLabel.text = [NSString stringWithFormat:@"￥%@", self.planOrder.orderPay];
    self.orderTimeLabel.text = self.planOrder.createdTime;
}


#pragma mark BtnAction
- (void)doneBtnAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refundBtnAction:(id)sender{
    LCRefundVC *refundVC = [LCRefundVC createInstance];
    refundVC.plan = self.plan;
    [self.navigationController pushViewController:refundVC animated:YES];
}

- (IBAction)contactUsBtnAction:(id)sender {
    LCUserModel *creater = [self.plan.memberList firstObject];
    if (creater && [LCStringUtil isNotNullString:creater.telephone]) {
        if (self.plan.isAllowPhoneContact) {
            [LCSharedFuncUtil dialPhoneNumber:creater.telephone];
        } else {
            [YSAlertUtil tipOneMessage:@"发起人未允许电话联系" yoffset:TipDefaultYoffset delay:TipErrorDelay];
        }
    }
}
- (IBAction)enterGroupBtnAction:(id)sender {
    if (nil != self.plan && [LCStringUtil isNotNullString:self.plan.planGuid]) {
        [LCViewSwitcher pushToShowChatWithPlanVC:self.plan on:self.navigationController];
    }
}


@end
