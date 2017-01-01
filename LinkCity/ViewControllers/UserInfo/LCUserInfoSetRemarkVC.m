//
//  LCUserInfoSetRemarkVC.m
//  LinkCity
//
//  Created by godhangyu on 16/6/11.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCUserInfoSetRemarkVC.h"


@interface RemarkTextField : UITextField
@end
@implementation RemarkTextField : UITextField

- (CGRect)textRectForBounds:(CGRect)bounds {
    return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(12, 16, 12, 16));
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(12, 16, 12, 16));
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(12, 16, 12, 16));
}

@end
@interface LCUserInfoSetRemarkVC ()<UIAlertViewDelegate>

// UI
@property (weak, nonatomic) IBOutlet RemarkTextField *remarkTextField;

@end

@implementation LCUserInfoSetRemarkVC

+ (instancetype)createInstance {
    return (LCUserInfoSetRemarkVC *)[LCStoryboardManager viewControllerWithFileName:SBNameUser identifier:VCIDUserInfoSetRemarkVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initTextField];
    [self initNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //[self initNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Common Init

- (void)initNavigationBar {
    self.title = @"备注信息";
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = UIColorFromRGBA(NavigationBarTintColor, 1);
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NavigationBarBackBtn"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonAction)];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(setRemarkButtonAction)];
    
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.rightBarButtonItem = saveButton;
}
- (void)initTextField {
    self.remarkTextField.text = self.user.nick;
    self.remarkTextField.clearButtonMode = UITextFieldViewModeAlways;
}

#pragma mark - Actions

- (void)setRemarkButtonAction {
    if (self.remarkTextField.text.length > 30) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"备注名最长为30个字符" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert setTag:1];
        [alert show];
    } else {
        [self requestToSetRemarkName];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)backButtonAction {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"保存本次编辑" delegate:self cancelButtonTitle:@"不保存" otherButtonTitles:@"保存", nil];
    [alert setTag:2];
    [alert show];
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 2) {
        if (buttonIndex == 1) {
            [self requestToSetRemarkName];
            [self.navigationController popViewControllerAnimated:YES];//新添加返回按钮，选择保存的界面调整by王颢博
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - Net Request

- (void)requestToSetRemarkName {
    [LCNetRequester setUserRemarkName:self.remarkTextField.text remarkUUID:self.user.uUID callBack:^(NSString *message, NSError *error) {
        if (!error) {
            [YSAlertUtil tipOneMessage:@"修改备注信息成功" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
        } else {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
        }
    }];
}


@end
