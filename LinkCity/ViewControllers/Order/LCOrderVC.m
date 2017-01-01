//
//  LCOrderVC.m
//  LinkCity
//
//  Created by Roy on 12/23/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCOrderVC.h"
#import "LCOrderVCUserInfoView.h"
#import "LCPhoneUtil.h"
#import "LCPaymentChooseView.h"
#import "LCPaymentHelper.h"
#import "LCAliPaymentHelper.h"
#import "LCWechatPaymentHelper.h"
#import "LCOrderFinishVC.h"

#define LCUserInfoViewHeight (90)
@interface LCOrderVC ()<LCPaymentHelperDelegate, LCPaymentChooseViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewTop;
@property (weak, nonatomic) IBOutlet UIImageView *ticketTopBg;
@property (weak, nonatomic) IBOutlet UIImageView *ticketBottomBg;
@property (weak, nonatomic) IBOutlet UILabel *declarationLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@property (weak, nonatomic) IBOutlet UIButton *minusBtn;
@property (weak, nonatomic) IBOutlet UILabel *numSetLabel;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (weak, nonatomic) IBOutlet UISwitch *insuranceSwitch;
@property (weak, nonatomic) IBOutlet UILabel *pointLabel;
@property (weak, nonatomic) IBOutlet UISwitch *pointSwitch;

@property (weak, nonatomic) IBOutlet UITextField *firstUserNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstUserIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstUserPhoneTextField;

@property (weak, nonatomic) IBOutlet UIView *otherUserHolderView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *otherUserHolderViewHeight;

@property (weak, nonatomic) IBOutlet UIButton *payBtn;


@property (nonatomic, strong) LCPartnerOrderModel *partnerOrder;
@property (nonatomic, strong) LCPaymentHelper *paymentHelper;
@property (nonatomic, strong) NSMutableArray *userViewArray;
@property (nonatomic, strong) KLCPopup *paymentPopup;
@property (nonatomic, assign) BOOL isNeedInsurance;
@property (nonatomic, assign) BOOL isUsePoint;

@end

@implementation LCOrderVC


+ (instancetype)createInstance{
    return (LCOrderVC *)[LCStoryboardManager viewControllerWithFileName:SBNameOrder_V_3_3 identifier:NSStringFromClass([LCOrderVC class])];
}

- (void)updateShowWithPlan:(LCPlanModel *)plan selectedStage:(LCPartnerStageModel *)stage recmdUuid:(NSString *)recmdUuid{
    self.plan = plan;
    self.stage = stage;
    self.recmdUuid = recmdUuid;
    
    self.isNeedInsurance = YES;
    self.isUsePoint = NO;
    
    [self updateShow];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"购买";
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    [self.scrollView.panGestureRecognizer addTarget:self action:@selector(panAction)];
    
    self.ticketTopBg.image = [[UIImage imageNamed:@"OrderVCTicketTopBg"] resizableImageWithCapInsets:UIEdgeInsetsMake(6, 100, 12, 100) resizingMode:UIImageResizingModeStretch];
    self.ticketBottomBg.image = [[UIImage imageNamed:@"OrderVCTicketBottomBg"] resizableImageWithCapInsets:UIEdgeInsetsMake(12, 100, 12, 100) resizingMode:UIImageResizingModeStretch];
    
    [[LCUIConstants sharedInstance] setButtonAsSubmitButtonEnableStyle:self.payBtn];
    
    self.firstUserNameTextField.text = [LCStringUtil getNotNullStr:[LCDataManager sharedInstance].userRealName];
    self.firstUserIdTextField.text = [LCStringUtil getNotNullStr:[LCDataManager sharedInstance].userRealId];
    self.firstUserPhoneTextField.text = [LCStringUtil getNotNullStr:[LCDataManager sharedInstance].userRealTelephone];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self updateShow];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [LCDataManager sharedInstance].userRealName = self.firstUserNameTextField.text;
    [LCDataManager sharedInstance].userRealId = self.firstUserIdTextField.text;
    [LCDataManager sharedInstance].userRealTelephone = self.firstUserPhoneTextField.text;
}


- (void)updateShow{
    if (self.plan.daysLong == 0) {
        self.plan.daysLong = 1;
    }
    self.declarationLabel.text = [LCStringUtil getNotNullStr:self.plan.declaration];
    NSString *timeStr = [NSString stringWithFormat:@"出发时间：%@   全程%ld天",
                         [LCDateUtil getDotDateFromHorizontalLineStr:self.stage.startTime],
                         (long)self.plan.daysLong];
    self.timeLabel.text = timeStr;
    self.priceLabel.text = [LCDecimalUtil currencyStrFromDecimal:self.stage.price];
    
    NSInteger userNum = self.userViewArray.count + 1;
    self.numLabel.text = [NSString stringWithFormat:@"%ld",(long)userNum];
    
    self.numSetLabel.text = [NSString stringWithFormat:@"%ld",(long)userNum];
    
    self.insuranceSwitch.on = self.isNeedInsurance;
    self.pointSwitch.on = self.isUsePoint;
    
    
    self.pointLabel.text = [NSString stringWithFormat:@"可用%ld积分抵%@元", (long)self.plan.scoreUpper, [self pointCash]];
    
    [self updatePayBtnShow];
    [self updateUseNumBtnShow];
}

- (void)updatePayBtnShow{
    [self.payBtn setTitle:[NSString stringWithFormat:@"支付 ￥%@", [LCDecimalUtil currencyStrFromDecimal:[self cashToPay]]] forState:UIControlStateNormal];
}

- (void)updateUseNumBtnShow{
    NSInteger curUserNum = self.userViewArray.count + 1;
    if (curUserNum <= 1) {
        [self.minusBtn setImage:[UIImage imageNamed:@"SendPlanMinusDayIcon_gray"] forState:UIControlStateNormal];
        self.minusBtn.enabled = NO;
    }else{
        [self.minusBtn setImage:[UIImage imageNamed:@"SendPlanMinusDayIcon"] forState:UIControlStateNormal];
        self.minusBtn.enabled = YES;
    }
    
    NSInteger orderSpace = self.stage.totalNumber - self.stage.joinNumber;
    if (curUserNum >= orderSpace) {
        [self.addBtn setImage:[UIImage imageNamed:@"SendPlanAddDayIcon_gray"] forState:UIControlStateNormal];
        self.addBtn.enabled = NO;
    }else{
        [self.addBtn setImage:[UIImage imageNamed:@"SendPlanAddDayIcon"] forState:UIControlStateNormal];
        self.addBtn.enabled = YES;
    }
}

- (NSString *)checkInput{
    NSString *errMsg = @"";
    if ([LCStringUtil isNullString:self.firstUserNameTextField.text]) {
        errMsg = [errMsg stringByAppendingString:@"请填写真实姓名\r\n"];
    }
    
    if ([LCStringUtil isNullString:self.firstUserPhoneTextField.text] ||
        ![LCPhoneUtil isPhoneNum:self.firstUserPhoneTextField.text]) {
        errMsg = [errMsg stringByAppendingString:@"请填写正确的联系电话\r\n"];
    }
    
    if (self.isNeedInsurance) {
        BOOL lostID = NO;
        if (![LCStringUtil validateIDCardNumber:self.firstUserIdTextField.text]) {
            lostID = YES;
        }
        
        for (LCOrderVCUserInfoView *v in self.userViewArray){
            if (![LCStringUtil validateIDCardNumber:v.idTextField.text] ||
                [LCStringUtil isNullString:v.nameTextField.text]) {
                lostID = YES;
                break;
            }
        }
        
        if (lostID) {
            errMsg = [errMsg stringByAppendingString:@"请正确填写姓名和身份证号以便领取免费保险\r\n"];
        }
    }
    
    errMsg = [LCStringUtil trimSpaceAndEnter:errMsg];
    
    return errMsg;
}

#pragma mark Set & Get
- (NSMutableArray *)userViewArray{
    if (!_userViewArray) {
        _userViewArray = [[NSMutableArray alloc] init];
    }
    return _userViewArray;
}

#pragma mark ButtonAction
- (void)tapAction{
    [self.view endEditing:YES];
}
- (void)panAction{
    [self.view endEditing:YES];
}
- (IBAction)addBtnAction:(id)sender {
    NSInteger payNum = [self.numLabel.text integerValue];
    NSInteger orderSpace = self.stage.totalNumber - self.stage.joinNumber;
    if (++payNum > orderSpace) {
        //do nothing
    }else{
        self.numLabel.text = [NSString stringWithFormat:@"%ld",(long)payNum];
        self.numSetLabel.text = [NSString stringWithFormat:@"%ld",(long)payNum];
        [self addUserView];
    }
    
    [self updateShow];
}
- (IBAction)minusBtnAction:(id)sender {
    NSInteger payNum = [self.numLabel.text integerValue];
    if (--payNum <= 1) {
        //do nothing
    }else{
        self.numLabel.text = [NSString stringWithFormat:@"%ld",(long)payNum];
        self.numLabel.text = [NSString stringWithFormat:@"%ld",(long)payNum];
    }
    
    [self removeUserView];
    
    [self updateShow];
}
- (IBAction)assuranceSwitchAction:(UISwitch *)sender {
    //LCLogInfo(@"last isNeedInsurance %@", self.isNeedInsurance?@"YES":@"NO");
    
    if (self.isNeedInsurance != sender.on) {
        
        if (sender.on == YES) {
            //如果是打开保险
            self.isNeedInsurance = YES;
        }else{
            //如果是关闭保险
            [YSAlertUtil alertTwoButton:@"关闭" btnTwo:@"开启" withTitle:nil msg:@"达客为您准备了免费保险\r\n为了您爱的人，请开启" callBack:^(NSInteger chooseIndex) {
                if (chooseIndex == 0) {
                    self.isNeedInsurance = NO;
                }else{
                    sender.on = YES;
                }
            }];
        }
    }
}
- (IBAction)pointSwitchAction:(UISwitch *)sender {
    if (sender.on != self.isUsePoint) {
        self.isUsePoint = sender.on;
        [self updateShow];
    }
}
- (IBAction)orderAgreementBtnAction:(id)sender {
    NSString *url = server_url([LCConstants serverHost], LCOrderAgreementURL);
    [LCViewSwitcher presentWebVCtoShowURL:url withTitle:@"预订说明"];
}
- (IBAction)payBtnAction:(id)sender {
    [self.view endEditing:YES];
    NSString *errMsg = [self checkInput];
    
    if ([LCStringUtil isNotNullString:errMsg]) {
        [YSAlertUtil tipOneMessage:errMsg yoffset:TipDefaultYoffset delay:TipErrorDelay];
        return;
    }

    NSDecimalNumber *cashToPay = [self cashToPay];
    if (![LCDecimalUtil isOverZero:cashToPay]) {
        //付款额等于零，直接创建订单，并支付完成
        NSInteger orderNum = [self.numLabel.text integerValue];
        NSInteger orderScore = self.isUsePoint ? self.plan.scoreUpper : 0;
        NSString *contactStr = [self getContactsStr];
        self.paymentHelper = [[LCPaymentHelper alloc] initWithDelegate:self];
        [self.paymentHelper payEarnestWithPlanGuid:self.stage.planGuid withTitle:self.plan.declaration orderNumber:orderNum orderContact:contactStr orderScore:orderScore recmdUuid:self.recmdUuid isNeedInsurance:self.isNeedInsurance];
    }else{
        //付款额大于零，跳支付方式选择
        [self showPaymentPopup];
    }
}


#pragma mark inner func
- (void)addUserView{
    LCOrderVCUserInfoView *lastV = [self.userViewArray lastObject];
    LCOrderVCUserInfoView *curV = [LCOrderVCUserInfoView createInstance];
    [self.userViewArray addObject:curV];
    [self.otherUserHolderView addSubview:curV];
    
    [self.otherUserHolderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[curV]-(0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(curV)]];
    
    if (!lastV) {
        [self.otherUserHolderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-(0)-[curV(%ld)]-(0)-|",(long)LCUserInfoViewHeight] options:0 metrics:nil views:NSDictionaryOfVariableBindings(curV)]];
        self.otherUserHolderViewHeight.constant = LCUserInfoViewHeight;
    }else{
        [self.otherUserHolderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[lastV]-(0)-[curV(%ld)]",(long)LCUserInfoViewHeight] options:0 metrics:nil views:NSDictionaryOfVariableBindings(lastV, curV)]];
        self.otherUserHolderViewHeight.constant = LCUserInfoViewHeight * self.userViewArray.count;
    }
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}
- (void)removeUserView{
    LCOrderVCUserInfoView *lastV = [self.userViewArray lastObject];
    [lastV removeFromSuperview];
    [self.userViewArray removeLastObject];
    self.otherUserHolderViewHeight.constant = LCUserInfoViewHeight * self.userViewArray.count;
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

- (NSDecimalNumber *)pointCash{
    NSDecimalNumber *pointDecimal = [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithInteger:self.plan.scoreUpper] decimalValue]];
    NSDecimalNumber *pointCash = [pointDecimal decimalNumberByMultiplyingBy:[LCDataManager sharedInstance].orderRule.scoreRatio withBehavior:[LCDecimalUtil getTwoDigitDecimalHandler]];
    return pointCash;
}
- (NSDecimalNumber *)cashToPay{
    NSDecimalNumber *totalCash = [self.stage.price decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:self.numLabel.text] withBehavior:[LCDecimalUtil getTwoDigitDecimalHandler]];
    
    NSDecimalNumber *cashToPay = totalCash;
    
    if (self.isUsePoint) {
        cashToPay = [totalCash decimalNumberBySubtracting:[self pointCash] withBehavior:[LCDecimalUtil getTwoDigitDecimalHandler]];
    }
    
    return cashToPay;
}
- (NSString *)getContactsStr{
    NSMutableArray *contactArray = [NSMutableArray new];
    //添加第一个人的信息
    NSMutableDictionary *contactDic = [[NSMutableDictionary alloc] init];
    if ([LCStringUtil isNotNullString:self.firstUserNameTextField.text]) {
        [contactDic setObject:self.firstUserNameTextField.text forKey:@"Name"];
    }
    if ([LCStringUtil isNotNullString:self.firstUserPhoneTextField.text]) {
        [contactDic setObject:self.firstUserPhoneTextField.text forKey:@"Telephone"];
    }
    if ([LCStringUtil isNotNullString:self.firstUserIdTextField.text]) {
        [contactDic setObject:self.firstUserIdTextField.text forKey:@"Identity"];
    }
    [contactArray addObject:contactDic];
    
    //添加后续人的信息
    for (LCOrderVCUserInfoView *userV in self.userViewArray){
        NSString *name = userV.nameTextField.text;
        NSString *idStr = userV.idTextField.text;
        contactDic = [[NSMutableDictionary alloc] init];
        
        if ([LCStringUtil isNotNullString:name]) {
            [contactDic setObject:name forKey:@"Name"];
        }
        if ([LCStringUtil isNotNullString:idStr]) {
            [contactDic setObject:idStr forKey:@"Identity"];
        }
        
        if (contactDic && [contactDic allKeys].count > 0) {
            [contactArray addObject:contactDic];
        }
    }
    NSString *contactStr = [LCStringUtil getJsonStrFromArray:contactArray];
    
    return contactStr;
}

#pragma mark LCPaymentHelper Delegate
- (void)paymentHelper:(LCPaymentHelper *)paymentHelper didPaySucceed:(BOOL)succeed order:(LCPartnerOrderModel *)order error:(NSError *)error{
    LCLogInfo(@"%@, paymentSucceed:%@",[[NSThread callStackSymbols] firstObject], succeed?@"YES":@"NO");
    
    if (succeed) {
        [MobClick event:Mob_Payment_Succeed];
        
        self.partnerOrder = order;
        [YSAlertUtil tipOneMessage:@"支付成功"];
        
        LCOrderFinishVC *orderFinishVC = [LCOrderFinishVC createInstance];
        orderFinishVC.plan = self.plan;
        orderFinishVC.planOrder = order;
        NSMutableArray *vcs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        [vcs removeLastObject];
        [vcs addObject:orderFinishVC];
        [self.navigationController setViewControllers:vcs animated:YES];
        
        //发一条群聊消息 ---期间会get room online
        NSString *systemMsg = [LCUIConstants getJoinPlanMessageWithUserNick:[LCDataManager sharedInstance].userInfo.nick];
        [[LCXMPPMessageHelper sharedInstance] sendChatSystemInfo:systemMsg toBareJidString:self.plan.roomId isGroup:YES];
    }else{
        [MobClick event:Mob_Payment_Failed];
        
        if (error && [LCStringUtil isNotNullString:error.domain]) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
        }else{
            [YSAlertUtil tipOneMessage:@"支付失败" yoffset:TipDefaultYoffset delay:TipErrorDelay];
        }
    }
}

#pragma mark - Payment Choose View
- (void)showPaymentPopup{
    static CGFloat centerY = 0;
    
    if (!self.paymentPopup) {
        LCPaymentChooseView *paymentView = [LCPaymentChooseView createInstance];
        paymentView.delegate = self;
        self.paymentPopup = [KLCPopup popupWithContentView:paymentView
                                                  showType:KLCPopupShowTypeSlideInFromBottom
                                               dismissType:KLCPopupDismissTypeSlideOutToBottom
                                                  maskType:KLCPopupMaskTypeDimmed
                                  dismissOnBackgroundTouch:YES
                                     dismissOnContentTouch:NO];
        centerY = DEVICE_HEIGHT - [paymentView intrinsicContentSize].height/2;
    }
    
    [self.paymentPopup showAtCenter:CGPointMake(DEVICE_WIDTH/2, centerY) inView:nil];
}
- (void)paymentChooseViewDidCancel:(LCPaymentChooseView *)view{
    [MobClick event:Mob_Payment_Former];
    [self.paymentPopup dismissPresentingPopup];
}
- (void)paymentChooseViewDidChooseAliPay:(LCPaymentChooseView *)view{
    [self.paymentPopup dismissPresentingPopup];
    
    NSInteger orderNum = [self.numLabel.text integerValue];
    NSInteger orderScore = self.isUsePoint ? self.plan.scoreUpper : 0;
    NSString *contactStr = [self getContactsStr];
    
    self.paymentHelper = [[LCAliPaymentHelper alloc] initWithDelegate:self];
    [self.paymentHelper payEarnestWithPlanGuid:self.stage.planGuid withTitle:self.plan.declaration orderNumber:orderNum orderContact:contactStr orderScore:orderScore recmdUuid:self.recmdUuid isNeedInsurance:self.isNeedInsurance];
}
- (void)paymentChooseViewDidChooseWechatPay:(LCPaymentChooseView *)view{
    [self.paymentPopup dismissPresentingPopup];
    
    NSInteger orderNum = [self.numLabel.text integerValue];
    NSInteger orderScore = self.isUsePoint ? self.plan.scoreUpper : 0;
    NSString *contactStr = [self getContactsStr];
    
    self.paymentHelper = [[LCWechatPaymentHelper alloc] initWithDelegate:self];
    [self.paymentHelper payEarnestWithPlanGuid:self.stage.planGuid withTitle:self.plan.declaration orderNumber:orderNum orderContact:contactStr orderScore:orderScore recmdUuid:self.recmdUuid isNeedInsurance:self.isNeedInsurance];
}

#pragma mark KeyBoard
//当输入框在scrollview最下时，键盘弹出后即使scrollview滚到底，输入框也显示不出
//为此每当显示键盘时，将scrollview上提
- (void)keyboardWillShow:(NSNotification *)aNotification{
    [super keyboardWillShow:aNotification];
    
    UIView *firstResponder = [self getFirstResponderOfView:self.view];
    if (firstResponder) {
        CGRect r = [firstResponder convertRect:firstResponder.bounds toView:self.view];
        
        if (r.origin.y > 100) {
            self.scrollViewTop.constant += 100 - r.origin.y;
        }
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }
}

- (void)keyboardWillBeHidden:(NSNotification *)aNotification{
    [super keyboardWillBeHidden:aNotification];
    self.scrollViewTop.constant = 0;
    [self.view layoutIfNeeded];
}


@end
