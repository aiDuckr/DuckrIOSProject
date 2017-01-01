//
//  LCSendCostPlanFeeIncludeVC.m
//  LinkCity
//
//  Created by Roy on 12/16/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCSendCostPlanFeeIncludeVC.h"
#import "LCSendCostPlanImageVC.h"
#import "SZTextView.h"

@interface LCSendCostPlanFeeIncludeVC ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewTop;
@property (weak, nonatomic) IBOutlet SZTextView *includeTextView;
@property (weak, nonatomic) IBOutlet SZTextView *excludeTextView;
@property (weak, nonatomic) IBOutlet UILabel *refundLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;


@end

@implementation LCSendCostPlanFeeIncludeVC

+ (instancetype)createInstance{
    return (LCSendCostPlanFeeIncludeVC *)[LCStoryboardManager viewControllerWithFileName:SBNameSendPlan identifier:NSStringFromClass([LCSendCostPlanFeeIncludeVC class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
    self.navigationItem.rightBarButtonItem = cancelBarButton;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    [self.scrollView.panGestureRecognizer addTarget:self action:@selector(panAction:)];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapAction:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewPanAction:)];
    panGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:panGesture];
    
    self.includeTextView.delegate = self;
    self.excludeTextView.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self updateShow];
}

- (void)updateShow{
    self.includeTextView.text = [LCStringUtil getNotNullStr:self.curPlan.costInclude];
    self.excludeTextView.text = [LCStringUtil getNotNullStr:self.curPlan.costExclude];
    [self.refundLabel setText:[LCDataManager sharedInstance].orderRule.refundDescription withLineSpace:LCTextFieldLineSpace];
    
    [self updateNextBtnShow];
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

#pragma mark Button Action
- (void)tapAction:(id)sender{
    [self.view endEditing:YES];
}
- (void)panAction:(id)sender{
    [self.view endEditing:YES];
}
- (void)cancelAction:(id)sender{
    [MobClick event:Mob_PublishPlanB_Cancel];
    [self cancelSendPlan];
}

- (void)viewTapAction:(id)sender{
    [self.view endEditing:YES];
}

- (void)viewPanAction:(id)sender{
    [self.view endEditing:YES];
}

- (IBAction)nextBtnAction:(id)sender {
    [self mergeUIDataIntoModel];
    
    NSString *inputErrorMsg = [self checkInput];
    if ([LCStringUtil isNullString:inputErrorMsg]) {
        LCSendCostPlanImageVC *imageVC = [LCSendCostPlanImageVC createInstance];
        imageVC.curPlan = self.curPlan;
        imageVC.isSendingPlan = self.isSendingPlan;
        [self.navigationController pushViewController:imageVC animated:YES];
    }else{
        [YSAlertUtil tipOneMessage:inputErrorMsg yoffset:TipDefaultYoffset delay:TipErrorDelay];
    }
}

#pragma mark TextView Delegate
- (void)textViewDidEndEditing:(UITextView *)textView{
    [self mergeUIDataIntoModel];
    [self updateNextBtnShow];
}

#pragma mark
- (NSString *)checkInput{
    NSString *errorMsg = @"";
    
    if ([LCStringUtil isNullString:[LCStringUtil trimSpaceAndEnter:self.includeTextView.text]]) {
        errorMsg = [errorMsg stringByAppendingString:@"请填写费用包含项目\r\n"];
    }
    
    if ([LCStringUtil isNullString:[LCStringUtil trimSpaceAndEnter:self.excludeTextView.text]]) {
        errorMsg = [errorMsg stringByAppendingString:@"请填写费用不包含项目\r\n"];
    }
    
    //如果最后多回车符，去掉
    errorMsg = [LCStringUtil trimSpaceAndEnter:errorMsg];
    
    LCLogInfo(@"checkInput :%@",errorMsg);
    return errorMsg;
}

- (void)mergeUIDataIntoModel{
    self.curPlan.costInclude = self.includeTextView.text;
    self.curPlan.costExclude = self.excludeTextView.text;
}

#pragma mark KeyBoard
//当输入框在scrollview最下时，键盘弹出后即使scrollview滚到底，输入框也显示不出
//为此每当显示键盘时，将scrollview上提
- (void)keyboardWillShow:(NSNotification *)aNotification{
    [super keyboardWillShow:aNotification];
    
    UITextView *firstResponder = nil;
    if (self.includeTextView.isFirstResponder) {
        firstResponder = self.includeTextView;
    }else if(self.excludeTextView.isFirstResponder) {
        firstResponder = self.excludeTextView;
    }
    
    CGRect r = [firstResponder convertRect:firstResponder.bounds toView:self.view];
    
    if (r.origin.y > 80) {
        self.scrollViewTop.constant = 80 - r.origin.y;
    }
    [self.view layoutIfNeeded];
}

- (void)keyboardWillBeHidden:(NSNotification *)aNotification{
    [super keyboardWillBeHidden:aNotification];
    self.scrollViewTop.constant = 0;
    [self.view layoutIfNeeded];
}


@end
