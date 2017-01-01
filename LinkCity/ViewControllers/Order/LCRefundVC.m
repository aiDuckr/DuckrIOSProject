//
//  LCRefundVC.m
//  LinkCity
//
//  Created by Roy on 6/27/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCRefundVC.h"

#define RefundIntroTop_CanRefund (74)
#define RefundIntroTop_CanNotRefund (15)
@interface LCRefundVC ()
//UI
@property (weak, nonatomic) IBOutlet UIView *refundInfoBorderBg;

@property (weak, nonatomic) IBOutlet UILabel *refundTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *refundMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *refundDenyLabel;

@property (weak, nonatomic) IBOutlet UIButton *refundBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *refundIntroTop;
@property (weak, nonatomic) IBOutlet UILabel *refundIntroLabel;


//Data
@property (strong, nonatomic) NSDecimalNumber *days;
@property (assign, nonatomic) LCRefundStatusType refundStatus;
@property (strong, nonatomic) NSDecimalNumber *refundMoney;
@property (assign, nonatomic) NSInteger refundScore;
@property (strong, nonatomic) NSString *refundTitle;
@end

@implementation LCRefundVC

+ (instancetype)createInstance{
    return (LCRefundVC *)[LCStoryboardManager viewControllerWithFileName:SBNameOrder identifier:NSStringFromClass([LCRefundVC class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"退款";
    self.refundInfoBorderBg.layer.masksToBounds = YES;
    self.refundInfoBorderBg.layer.cornerRadius = LCCellCornerRadius;
    self.refundInfoBorderBg.layer.borderColor = UIColorFromRGBA(LCCellBorderColor, 1).CGColor;
    self.refundInfoBorderBg.layer.borderWidth = LCCellBorderWidth;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self updateShow];
}

- (void)refreshData{
    
    [LCNetRequester getPlanDetailFromPlanGuid:self.plan.planGuid callBack:^(LCPlanModel *plan,NSArray * tourpicArray, NSError *error) {
        if (error) {
            [YSAlertUtil hideHud];
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
        }else{
            self.plan = plan;
            
            [LCNetRequester planOrderRefund:self.plan.planGuid refund:0 callBack:^(NSDecimalNumber *days,
                                                                                   LCRefundStatusType refundStatus,
                                                                                   NSDecimalNumber *refundMoney,
                                                                                   NSInteger refundScore,
                                                                                   NSString *refundTitle,
                                                                                   NSString *message,
                                                                                   NSError *error)
             {
                 [YSAlertUtil hideHud];
                 
                 if (error) {
                     [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
                 }else{
                     self.days = days;
                     self.refundStatus = refundStatus;
                     self.refundMoney = refundMoney;
                     self.refundScore = refundScore;
                     self.refundTitle = refundTitle;
                     
                     [self updateShow];
                 }
             }];
        }
    }];
    
}

- (void)updateShow{
    if (self.refundStatus == LCRefundStatus_Can) {
        self.refundTitleLabel.text = [LCStringUtil getNotNullStr:self.refundTitle];
        self.refundMoneyLabel.hidden = NO;
        self.refundMoneyLabel.text = [NSString stringWithFormat:@"%@元 + %ld积分",self.refundMoney,(long)self.refundScore];
        self.refundDenyLabel.hidden = YES;
        self.refundBtn.hidden = NO;
        self.refundIntroTop.constant = RefundIntroTop_CanRefund;
    }else if(self.refundStatus == LCRefundStatus_CanNot) {
        self.refundTitleLabel.text = [LCStringUtil getNotNullStr:self.refundTitle];
        self.refundMoneyLabel.hidden = YES;
        self.refundDenyLabel.hidden = NO;
        self.refundBtn.hidden = YES;
        self.refundIntroTop.constant = RefundIntroTop_CanNotRefund;
    }
    
    [self.refundIntroLabel setText:[LCStringUtil getNotNullStr:[LCDataManager sharedInstance].orderRule.refundDescription] withLineSpace:LCTextFieldLineSpace];
}


- (IBAction)refundButtonAction:(id)sender {
    [YSAlertUtil showHudWithHint:nil];
    [LCNetRequester planOrderRefund:self.plan.planGuid refund:1 callBack:^(NSDecimalNumber *days,
                                                                           LCRefundStatusType refundStatus,
                                                                           NSDecimalNumber *refundMoney,
                                                                           NSInteger refundScore,
                                                                           NSString *refundTitle,
                                                                           NSString *message,
                                                                           NSError *error)
     {
         [YSAlertUtil hideHud];
         
         if (error) {
             [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
         }else{
             
             //下线群聊
             [[LCXMPPMessageHelper sharedInstance] getRoomOfflineWithRoomBareJid:self.plan.roomId];
             
             //删除聊天记录和通讯录和红点
             NSString *bareJidStr = self.plan.roomId;
             [LCXMPPUtil deleteChatMsg:bareJidStr];
             [LCXMPPUtil deleteChatContact:bareJidStr];
             [[LCDataManager sharedInstance] clearUnreadNumForBareJidStr:bareJidStr];
             
             //pop 到顶
             [self.navigationController popToRootViewControllerAnimated:YES];
             [YSAlertUtil alertOneButton:@"知道了" withTitle:nil msg:[LCStringUtil getNotNullStr:message] callBack:nil];
         }
     }];
}



@end
