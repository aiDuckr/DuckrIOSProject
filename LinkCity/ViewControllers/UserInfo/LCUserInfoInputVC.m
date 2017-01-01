//
//  LCUserInfoInputVC.m
//  LinkCity
//
//  Created by roy on 11/29/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCUserInfoInputVC.h"
#import "LCStoryboardManager.h"

#define NickMaxNum 24
#define RealNameMaxNum 24
#define SchoolMaxNum 24
#define CompanyMaxNum 24
#define SignMaxNum 150
@interface LCUserInfoInputVC ()<UITextViewDelegate>

@property (nonatomic, assign) BOOL haveLayoutAfterLoad;

@property (nonatomic, strong) UIBarButtonItem *saveBarButton;

@property (weak, nonatomic) IBOutlet UIView *textFieldContainer;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;

@property (weak, nonatomic) IBOutlet UIView *textViewContrainer;
@property (weak, nonatomic) IBOutlet UILabel *textViewTextNumLabel;
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;

@end

@implementation LCUserInfoInputVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.saveBarButton = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction:)];
    self.navigationItem.rightBarButtonItem = self.saveBarButton;
    
    self.haveLayoutAfterLoad = NO;
    
    self.inputTextView.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLayoutSubviews{
    if (!self.haveLayoutAfterLoad) {
        self.haveLayoutAfterLoad = YES;
        
        [self setInputType:self.inputType forUser:self.userInfo withDelegate:self.delegate];
    }
}

+ (instancetype)createInstance{
    return (LCUserInfoInputVC *)[LCStoryboardManager viewControllerWithFileName:SBNameUser identifier:VCIDEditUserInputVC];
}
- (void)setInputType:(UserInfoInputType)inputType forUser:(LCUserModel *)userInfo withDelegate:(id<LCUserInfoInputVCDelegate>)delegate{
    _userInfo = userInfo;
    _inputType = inputType;
    _delegate = delegate;
    
    switch (inputType) {
        case InputTypeCompany:
            self.textViewContrainer.hidden = YES;
            self.textFieldContainer.hidden = NO;
//            self.inputTextField.text = self.userInfo.company;
            self.title = @"公司";
            [self.inputTextField becomeFirstResponder];
            break;
        case InputTypeNick:
            self.textViewContrainer.hidden = YES;
            self.textFieldContainer.hidden = NO;
            self.inputTextField.text = self.userInfo.nick;
            self.title = @"昵称";
            [self.inputTextField becomeFirstResponder];
            break;
        case InputTypeRealName:
            self.textViewContrainer.hidden = YES;
            self.textFieldContainer.hidden = NO;
            self.inputTextField.text = self.userInfo.realName;
            self.title = @"真实姓名";
            [self.inputTextField becomeFirstResponder];
            break;
        case InputTypeSchool:
            self.textViewContrainer.hidden = YES;
            self.textFieldContainer.hidden = NO;
//            self.inputTextField.text = self.userInfo.school;
            self.title = @"学校";
            [self.inputTextField becomeFirstResponder];
            break;
        case InputTypeSigh:
            self.textViewContrainer.hidden = NO;
            self.textFieldContainer.hidden = YES;
            self.inputTextView.text = self.userInfo.signature;
            self.title = @"旅行宣言";
            self.textViewTextNumLabel.text = [self getTextCountStringForSignature];
            [self.inputTextField resignFirstResponder];
            BOOL can = [self.inputTextView becomeFirstResponder];
            LCLogInfo(@"textView did become to first:%@",can?@"YES":@"NO");
            
            break;
        default:
            break;
    }
}

- (void)saveAction:(id)sender{
    switch (self.inputType) {
        case InputTypeCompany:
            if (self.inputTextField.text.length > CompanyMaxNum) {
                NSString *tip = [NSString stringWithFormat:@"最长%d个字",CompanyMaxNum];
                [YSAlertUtil tipOneMessage:tip yoffset:TipAboveKeyboardYoffset delay:TipDefaultDelay];
                return;
            }
//            self.userInfo.company = self.inputTextField.text;
            break;
        case InputTypeNick:
            if (self.inputTextField.text.length > NickMaxNum) {
                NSString *tip = [NSString stringWithFormat:@"最长%d个字",NickMaxNum];
                [YSAlertUtil tipOneMessage:tip yoffset:TipAboveKeyboardYoffset delay:TipDefaultDelay];
                return;
            }
            self.userInfo.nick = self.inputTextField.text;
            break;
        case InputTypeRealName:
            if (self.inputTextField.text.length > RealNameMaxNum) {
                NSString *tip = [NSString stringWithFormat:@"最长%d个字",RealNameMaxNum];
                [YSAlertUtil tipOneMessage:tip yoffset:TipAboveKeyboardYoffset delay:TipDefaultDelay];
                return;
            }
            self.userInfo.realName = self.inputTextField.text;
            break;
        case InputTypeSchool:
            if (self.inputTextField.text.length > SchoolMaxNum) {
                NSString *tip = [NSString stringWithFormat:@"最长%d个字",SchoolMaxNum];
                [YSAlertUtil tipOneMessage:tip yoffset:TipAboveKeyboardYoffset delay:TipDefaultDelay];
                return;
            }
//            self.userInfo.school = self.inputTextField.text;
            break;
        case InputTypeSigh:
            if (self.inputTextView.text.length > SignMaxNum) {
                NSString *tip = [NSString stringWithFormat:@"最长%d个字",SignMaxNum];
                [YSAlertUtil tipOneMessage:tip yoffset:TipAboveKeyboardYoffset delay:TipDefaultDelay];
                return;
            }
            self.userInfo.signature = self.inputTextView.text;
            break;
        default:
            break;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(userInfoInputVC:didUpdateUserInfo:withInputType:)]) {
        [self.delegate userInfoInputVC:self didUpdateUserInfo:self.userInfo withInputType:self.inputType];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextView Delegate
- (void)textViewDidChange:(UITextView *)textView{
    self.textViewTextNumLabel.text = [self getTextCountStringForSignature];
}
#pragma mark - Help Function
- (NSString *)getTextCountStringForSignature{
    NSString *inputtedString = self.inputTextView.text;
    return [NSString stringWithFormat:@"%lu/%d字",(long)[inputtedString length],SignMaxNum];
}
@end
