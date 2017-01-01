 //
//  LCUserOrderDetailVC.m
//  LinkCity
//
//  Created by 张宗硕 on 12/22/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCUserOrderDetailVC.h"
#import "LCRefundVC.h"

@interface LCUserOrderDetailVC ()
@property (weak, nonatomic) IBOutlet UIImageView *ticketBottomImageView;
@property (weak, nonatomic) IBOutlet UIImageView *ticketTopImageView;
@property (weak, nonatomic) IBOutlet UILabel *ticketTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *startEndLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderCodeLabel;

//CarInfo
@property (weak, nonatomic) IBOutlet UIView *carInfoView;
@property (weak, nonatomic) IBOutlet UIImageView *carImageView;
@property (weak, nonatomic) IBOutlet UILabel *carOwnerLabel;
@property (weak, nonatomic) IBOutlet UILabel *carInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *carServiceNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *carDriverAgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *carAgeLabel;

//UserInfo
@property (weak, nonatomic) IBOutlet UILabel *travelerLabel;
@property (weak, nonatomic) IBOutlet UIView *travelerView;
@property (weak, nonatomic) IBOutlet UIView *userInfoView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userInfoViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userInfoViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contactListHeightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *contactNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *telephoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *payTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointPayLabel;
@property (weak, nonatomic) IBOutlet UILabel *actualPayLabel;
@property (weak, nonatomic) IBOutlet UILabel *planTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *contactUpButton;
@property (weak, nonatomic) IBOutlet UIButton *enterGroupButton;
@property (retain, nonatomic) LCPartnerOrderModel *planOrder;

@end

@implementation LCUserOrderDetailVC

+ (instancetype)createInstance {
    return (LCUserOrderDetailVC *)[LCStoryboardManager viewControllerWithFileName:SBNameOrder identifier:VCIDUserOrderDetailVC];
}

- (id)init {
    self = [super init];
    if (self) {
        self.type = LCUserOrderDetailType_Default;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initVariable];
    [self initTopTicketView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init
- (void)initTopTicketView {
    UIImage *topBgImage = [UIImage imageNamed:@"PlanOrderTicketTop"];
    topBgImage = [topBgImage resizableImageWithCapInsets:UIEdgeInsetsMake(2.0f, 0.0f, 304.0f, 40.0f) resizingMode:UIImageResizingModeStretch];
    self.ticketTopImageView.image = topBgImage;
    
    UIImage *bottomImage = [UIImage imageNamed:@"PlanOrderTicketBottom"];
    bottomImage = [bottomImage resizableImageWithCapInsets:UIEdgeInsetsMake(20.0f, 20.0f, 304.0f, 10.0f) resizingMode:UIImageResizingModeStretch];
    self.ticketBottomImageView.image = bottomImage;
}

- (void)initVariable {
    self.title = @"订单";
}

- (void)updatePlanOrder {
    LCUserModel *currentUser = [LCDataManager sharedInstance].userInfo;
    for (LCUserModel *user in self.plan.memberList) {
        if ([user.uUID isEqualToString:currentUser.uUID]) {
            currentUser = user;
            break ;
        }
    }
    self.planOrder = currentUser.partnerOrder;
}

- (void)refreshData {
    [self updatePlanOrder];
    [self requestPartnerOrderFromServer];
    [self requestPlanDetailFromServer];
}

- (void)requestPartnerOrderFromServer {
    if ([LCStringUtil isNullString:self.planOrder.guid]) {
        return ;
    }
    [LCNetRequester planOrderQuery:self.planOrder.guid callBack:^(LCPartnerOrderModel *partnerOrder, NSError *error) {
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipDefaultDelay];
        } else {
            self.planOrder = partnerOrder;
            [self updateShow];
        }
    }];
}

- (void)requestPlanDetailFromServer{
    if ([LCStringUtil isNullString:self.plan.planGuid]) {
        return ;
    }
    
    [LCNetRequester getPlanDetailFromPlanGuid:self.plan.planGuid callBack:^(LCPlanModel *plan,NSArray * tourpicArray, NSError *error) {
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipDefaultDelay];
        } else {
            self.plan = plan;
            [self updateShow];
        }
    }];
}

- (void)updateShow {
    //Ticket
    self.ticketTitleLabel.text = self.plan.declaration;
    self.startEndLabel.text = [NSString stringWithFormat:@"出发时间：%@   全程%ld天",
                               [LCDateUtil getDotDateFromHorizontalLineStr:self.plan.startTime],
                               (long)self.plan.daysLong];
    self.orderPriceLabel.text = [NSString stringWithFormat:@"%@", self.planOrder.orderPrice];
    self.orderNumLabel.text = [NSString stringWithFormat:@"%ld张", (long)self.planOrder.orderNumber];
    self.orderCodeLabel.text = self.planOrder.orderCode;
    self.travelerLabel.text = [NSString stringWithFormat:@"出行者%ld张", (long)self.planOrder.orderNumber];
    
    //CarInfo
    if (self.plan.carIdentity &&
        ([self.plan isCostCarryPlan] || [self.plan isFreeCarryPlan])) {
        self.carInfoView.hidden = NO;
        self.userInfoViewTop.constant = 140;
        
        LCCarIdentityModel *carModel = self.plan.carIdentity;
        [self.carImageView setImageWithURL:[NSURL URLWithString:carModel.carPictureThumbUrl] placeholderImage:nil];
        self.carOwnerLabel.text = [LCStringUtil getNotNullStr:carModel.userName];
        
        NSString *carInfoStr = [LCStringUtil getNotNullStr:carModel.carBrand];
        carInfoStr = [carInfoStr stringByAppendingString:[LCStringUtil getNotNullStr:carModel.carType]];
        if (carModel.carLicense.length > 4) {
            NSString *carLicense = [carModel.carLicense stringByReplacingCharactersInRange:NSMakeRange(2, carModel.carLicense.length-4) withString:@"***"];
            carInfoStr = [carInfoStr stringByAppendingFormat:@"   %@",carLicense];
        }
        self.carInfoLabel.text = carInfoStr;
        
        NSMutableAttributedString *serviceNumStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld",(long)carModel.serviceNumber] attributes:@{NSFontAttributeName:[UIFont fontWithName:FONT_LANTINGBLACK size:19]}];
        [serviceNumStr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"人" attributes:@{NSFontAttributeName:[UIFont fontWithName:FONT_LANTINGBLACK size:11]}]];
        self.carServiceNumLabel.attributedText = serviceNumStr;
        
        NSMutableAttributedString *derivingAgeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld",(long)carModel.drivingYear] attributes:@{NSFontAttributeName:[UIFont fontWithName:FONT_LANTINGBLACK size:19]}];
        [derivingAgeStr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"年" attributes:@{NSFontAttributeName:[UIFont fontWithName:FONT_LANTINGBLACK size:11]}]];
        self.carDriverAgeLabel.attributedText = derivingAgeStr;
        
        NSMutableAttributedString *carAgeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld",(long)carModel.carYear] attributes:@{NSFontAttributeName:[UIFont fontWithName:FONT_LANTINGBLACK size:19]}];
        [carAgeStr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"年" attributes:@{NSFontAttributeName:[UIFont fontWithName:FONT_LANTINGBLACK size:11]}]];
        self.carAgeLabel.attributedText = carAgeStr;
    }else{
        self.carInfoView.hidden = YES;
        self.userInfoViewTop.constant = 14;
    }
    
    //UserInfo
    NSArray *contactArray = self.planOrder.orderContactNameArray;
    NSArray *telephoneArray = self.planOrder.orderContactPhoneArray;
    NSArray *identityArray = self.planOrder.orderContactIdentityArray;
    if (nil == contactArray || contactArray.count <= 0) {
        self.userInfoViewHeightConstraint.constant = 0;
        self.userInfoView.hidden = YES;
    } else {
        self.userInfoView.hidden = NO;
        NSInteger num = contactArray.count;
        self.userInfoViewHeightConstraint.constant = 25.0f + 25.0f + 42.0f + (num + 1) * 15 + num * 14;
        self.contactListHeightConstraint.constant = (num + 1) * 15 + num * 14;
    }
    for (int i = 0; i < contactArray.count; ++i) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 15.0f + i * 29.0f, DEVICE_WIDTH, 29.0f)];
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 65.0f, 14.0f)];
        leftLabel.text = [contactArray objectAtIndex:i];
        leftLabel.textColor = UIColorFromRGBA(0x2c2a28, 1.0f);
        leftLabel.font = [UIFont fontWithName:APP_CHINESE_FONT size:14.0f];
        [view addSubview:leftLabel];
        
        UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(75.0f, 0.0f, DEVICE_WIDTH - 10.0f, 14.0f)];
        rightLabel.text = [identityArray objectAtIndex:i];
        rightLabel.textColor = UIColorFromRGBA(0x2c2a28, 1.0f);
        rightLabel.font = [UIFont fontWithName:APP_CHINESE_FONT size:14.0f];
        [view addSubview:rightLabel];
        [self.travelerView addSubview:view];
    }
    if (nil != contactArray && contactArray.count > 0) {
        self.contactNameLabel.text = [contactArray objectAtIndex:0];
    }
    if (nil != telephoneArray && telephoneArray.count > 0) {
        self.telephoneLabel.text = [telephoneArray objectAtIndex:0];
    }
    self.payTimeLabel.text = self.planOrder.createdTime;
    self.pointPayLabel.text = [NSString stringWithFormat:@"￥%@", self.planOrder.orderScoreCash];
    self.actualPayLabel.text = [NSString stringWithFormat:@"￥%@", self.planOrder.orderPay];
    self.planTitleLabel.text = self.plan.declaration;
    if ([self.plan.endTime compare:[LCDateUtil getTodayStr]] < 0) {
        [self.contactUpButton setTitle:@"评价活动" forState:UIControlStateNormal];
        [self.contactUpButton setTitleColor:UIColorFromRGBA(0x6b450a, 1.0f) forState:UIControlStateNormal];
        [self.contactUpButton setBackgroundColor:UIColorFromRGBA(0xf4d925, 1.0f)];
        self.contactUpButton.layer.borderWidth = 0.0f;
        [self.contactUpButton addTarget:self action:@selector(evaluatioinPlanAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.enterGroupButton setTitleColor:UIColorFromRGBA(0x2c2a28, 1.0f) forState:UIControlStateNormal];
        [self.enterGroupButton setBackgroundColor:UIColorFromRGBA(0xfaf9f8, 1.0f)];
        self.enterGroupButton.layer.borderWidth = 0.5f;
        self.enterGroupButton.layer.borderColor = [UIColorFromRGBA(0xc9c5c1, 1.0f) CGColor];
        self.navigationItem.rightBarButtonItem = nil;
    } else {
        [self.contactUpButton setTitle:@"联系我们" forState:UIControlStateNormal];
        [self.contactUpButton setTitleColor:UIColorFromRGBA(0x2c2a28, 1.0f) forState:UIControlStateNormal];
        [self.contactUpButton setBackgroundColor:UIColorFromRGBA(0xfaf9f8, 1.0f)];
        self.contactUpButton.layer.borderWidth = 0.5f;
        self.contactUpButton.layer.borderColor = [UIColorFromRGBA(0xc9c5c1, 1.0f) CGColor];
        [self.contactUpButton addTarget:self action:@selector(phoneContactButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.enterGroupButton setTitleColor:UIColorFromRGBA(0x6b450a, 1.0f) forState:UIControlStateNormal];
        [self.enterGroupButton setBackgroundColor:UIColorFromRGBA(0xf4d925, 1.0f)];
        self.enterGroupButton.layer.borderWidth = 0.0f;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"退款" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemAction:)];
    }
    if (LCUserOrderDetailType_Push == self.type) {
        [[LCPopViewHelper sharedInstance] popCostPlanEvaluationView:nil withPlan:self.plan];
    }
    
}

#pragma mark UIButton Actions
- (IBAction)planTitileButtonAction:(id)sender {
    if (nil != self.plan && [LCStringUtil isNotNullString:self.plan.planGuid]) {
        [LCViewSwitcher pushToShowPlanDetailVCForPlan:self.plan recmdUuid:nil on:self.navigationController];
    }
}

- (void)phoneContactButtonAction:(id)sender {
    LCUserModel *creater = [self.plan.memberList firstObject];
    if (creater && [LCStringUtil isNotNullString:creater.telephone]) {
        if (self.plan.isAllowPhoneContact) {
            [LCSharedFuncUtil dialPhoneNumber:creater.telephone];
        } else {
            [YSAlertUtil tipOneMessage:@"发起人未允许电话联系" yoffset:TipDefaultYoffset delay:TipErrorDelay];
        }
    }
}

- (void)evaluatioinPlanAction:(id)sender {
    if (self.plan.isEvalued) {
        [YSAlertUtil tipOneMessage:@"您已经评价过该活动了"];
    } else {
        [[LCPopViewHelper sharedInstance] popCostPlanEvaluationView:nil withPlan:self.plan];
    }
}

- (IBAction)enterGroupButtonAction:(id)sender {
    if (nil != self.plan && [LCStringUtil isNotNullString:self.plan.planGuid]) {
        [LCViewSwitcher pushToShowChatWithPlanVC:self.plan on:self.navigationController];
    }
}

- (void)rightBarButtonItemAction:(id)sender {
    LCRefundVC *refundVC = [LCRefundVC createInstance];
    refundVC.plan = self.plan;
    [self.navigationController pushViewController:refundVC animated:YES];
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
