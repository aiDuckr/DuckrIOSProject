//
//  LCReportUserVC.m
//  LinkCity
//
//  Created by Roy on 12/25/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCReportUserVC.h"

@interface LCReportUserVC ()
@property (weak, nonatomic) IBOutlet SZTextView *reasonTextView;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end

@implementation LCReportUserVC

+ (instancetype)createInstance{
    return (LCReportUserVC *)[LCStoryboardManager viewControllerWithFileName:SBNameUserTab identifier:NSStringFromClass([LCReportUserVC class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"举报用户";
    self.reasonTextView.placeholder = @"填写举报原因";
    self.reasonTextView.text = @"";
    [[LCUIConstants sharedInstance] setButtonAsSubmitButtonEnableStyle:self.submitBtn];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.reasonTextView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}

- (IBAction)submitBtnAction:(id)sender {
    NSString *reason = [LCStringUtil trimSpaceAndEnter:self.reasonTextView.text];
    
    [YSAlertUtil showHudWithHint:nil inView:self.view enableUserInteraction:YES];
    [LCNetRequester reportUser:self.userToReport.uUID reason:reason callBack:^(NSString *msg, NSError *error) {
        [YSAlertUtil hideHud];
        
        NSString *msgToToast = msg;
        if (error) {
            msgToToast = error.domain;
        }
        
        [YSAlertUtil tipOneMessage:msgToToast yoffset:TipAboveKeyboardYoffset delay:TipErrorDelay];
    }];
}


@end
