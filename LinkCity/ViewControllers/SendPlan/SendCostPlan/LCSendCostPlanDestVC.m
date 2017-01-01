//
//  LCSendCostPlanDestVC.m
//  LinkCity
//
//  Created by Roy on 12/15/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCSendCostPlanDestVC.h"
#import "LCSendCostPlanStageVC.h"


@interface LCSendCostPlanDestVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *departTextField;
@property (weak, nonatomic) IBOutlet UITextField *destTextField;
@property (weak, nonatomic) IBOutlet UITextField *declarationTextField;

@property (weak, nonatomic) IBOutlet UILabel *memberNumLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *memberNumLabelLeftSpace;
@property (weak, nonatomic) IBOutlet UISlider *memberNumSlider;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@end

@implementation LCSendCostPlanDestVC

+ (instancetype)createInstance{
    return (LCSendCostPlanDestVC *)[LCStoryboardManager viewControllerWithFileName:SBNameSendPlan identifier:NSStringFromClass([LCSendCostPlanDestVC class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    [self.scrollView.panGestureRecognizer addTarget:self action:@selector(panAction)];
    
    //navigation bar
    UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
    self.navigationItem.rightBarButtonItem = cancelBarButton;
    
    //text field
    self.departTextField.delegate = self;
    self.destTextField.delegate = self;
    self.declarationTextField.delegate = self;
    
    //user num slider
    [self.memberNumSlider addTarget:self action:@selector(memberNumChangeAction) forControlEvents:UIControlEventValueChanged];
    self.memberNumSlider.minimumValue = 2;
    if ([LCDataManager sharedInstance].userInfo) {
        self.memberNumSlider.maximumValue = [[LCDataManager sharedInstance].userInfo getMaxPlanMember];
    }else{
        self.memberNumSlider.maximumValue = MaxPlanScaleOfUsualUser;
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:NO];
    [self.tabBarController.tabBar setHidden:YES];
    
    [self updateShow];
}

//页面layout之后
//初始化num label显示的内容和位置
- (void)viewDidLayoutSubviews{
    [self memberNumChangeAction];
}

- (void)updateShow {
    if (![LCDataManager sharedInstance].userInfo) {
        // have not login
    }else{
        //出发地
        self.departTextField.text = [LCStringUtil getNotNullStr:self.curPlan.departName];
        self.destTextField.text = [self.curPlan getDestinationsStringWithSeparator:DestinationSeparator];
        self.declarationTextField.text = [LCStringUtil getNotNullStr:self.curPlan.declaration];
        
        self.memberNumSlider.value = self.curPlan.scaleMax;
        
        [self updateNextBtnShow];
    }
}

#pragma mark ButtonAction
- (void)tapAction {
    [self.view endEditing:YES];
}

- (void)panAction {
    [self.view endEditing:YES];
}

- (void)cancelAction:(id)sender{
    [MobClick event:Mob_PublishPlanA_Cancel];
    [self mergeUIDataIntoModel];
    [self cancelSendPlan];
}

- (void)memberNumChangeAction{
    float max = self.memberNumSlider.maximumValue;
    float min = self.memberNumSlider.minimumValue;
    float cur = self.memberNumSlider.value;
    float left = 0;
    left -= self.memberNumLabel.frame.size.width/2.0;
    left += (cur-min)/(max-min) * (self.memberNumSlider.frame.size.width-28);
    left += 14;
    
    self.memberNumLabelLeftSpace.constant = left;
    self.memberNumLabel.text = [NSString stringWithFormat:@"%d",(int)cur];
    [self.memberNumLabel layoutIfNeeded];
}

- (IBAction)nextBtnAction:(id)sender {
    [MobClick event:Mob_PublishPlanA_Next];
    [self mergeUIDataIntoModel];

    NSString *inputErrorMsg = [self checkInput];
    if ([LCStringUtil isNullString:inputErrorMsg]) {
        LCSendCostPlanStageVC *stageVC = [LCSendCostPlanStageVC createInstance];
        stageVC.curPlan = self.curPlan;
        stageVC.isSendingPlan = self.isSendingPlan;
        [self.navigationController pushViewController:stageVC animated:YES];
    }else{
        [YSAlertUtil tipOneMessage:inputErrorMsg yoffset:TipDefaultYoffset delay:TipErrorDelay];
    }
}

- (void)updateNextBtnShow{
    if ([LCStringUtil isNullString:[self checkInput]]) {
        //input correct
        [[LCUIConstants sharedInstance] setButtonAsSubmitButtonEnableStyle:self.nextBtn];
    }else{
        //input error
        [[LCUIConstants sharedInstance] setButtonAsSubmitButtonDisableStyle:self.nextBtn];
    }
}

- (void)setThemeBtn:(UIButton *)btn selected:(BOOL)selection{
    if (selection) {
        btn.backgroundColor = UIColorFromRGBA(0xf4d925, 1);
        [btn setTitleColor:UIColorFromRGBA(0x6b450a, 1) forState:UIControlStateNormal];
    }else{
        btn.backgroundColor = UIColorFromRGBA(0xf2f0ed, 1);
        [btn setTitleColor:UIColorFromRGBA(0xaba7a2, 1) forState:UIControlStateNormal];
    }
}

#pragma mark - UITextView Delegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self updateNextBtnShow];
}


#pragma mark
- (NSString *)checkInput{
    NSString *errorMsg = @"";
    
    if ([LCStringUtil isNullString:[LCStringUtil trimSpaceAndEnter:self.departTextField.text]]) {
        errorMsg = [errorMsg stringByAppendingString:@"请填写出发地\r\n"];
    }
    
    if ([LCStringUtil isNullString:[LCStringUtil trimSpaceAndEnter:self.destTextField.text]]) {
        errorMsg = [errorMsg stringByAppendingString:@"请填写目的地\r\n"];
    }
    
    if ([LCStringUtil isNullString:[LCStringUtil trimSpaceAndEnter:self.declarationTextField.text]]) {
        errorMsg = [errorMsg stringByAppendingString:@"请填写活动标题\r\n"];
    }
    
    //如果最后多回车符，去掉
    errorMsg = [LCStringUtil trimSpaceAndEnter:errorMsg];
    
    LCLogInfo(@"checkInput :%@",errorMsg);
    return errorMsg;
}

- (void)mergeUIDataIntoModel{
    self.curPlan.departName = [LCStringUtil trimSpaceAndEnter:self.departTextField.text];
    self.curPlan.destinationNames = [LCPlanModel getDestinationArrayByString:self.destTextField.text];
    self.curPlan.declaration = [LCStringUtil trimSpaceAndEnter:self.declarationTextField.text];
    
    self.curPlan.scaleMax = (NSInteger)self.memberNumSlider.value;
}




@end
