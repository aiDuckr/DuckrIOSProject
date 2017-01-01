//
//  LCAgreementVC.m
//  LinkCity
//
//  Created by roy on 3/12/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCAgreementVC.h"

@interface LCAgreementVC ()<UIWebViewDelegate>
@property (nonatomic, strong) UIBarButtonItem *cancelBarButton;
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;

//@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation LCAgreementVC


+ (instancetype)createInstance{
    return (LCAgreementVC *)[LCStoryboardManager viewControllerWithFileName:SBNameCommon identifier:VCIDAgreementVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.delegate = self;
    
    self.cancelBarButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonAction)];
    self.navigationItem.rightBarButtonItem = self.cancelBarButton;
    
    [[LCUIConstants sharedInstance] setButtonAsSubmitButtonEnableStyle:self.agreeButton];
}

- (void)dealloc{
    self.callBack = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
    if (self.showCancelBarButton) {
        self.navigationItem.rightBarButtonItem = self.cancelBarButton;
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    [self updateShow];
}

- (void)updateShow{
    if ([LCStringUtil isNotNullString:self.urlStr]) {
        [self loadURLString:self.urlStr];
    }
}

- (void)loadURLString:(NSString *)urlStr{
    NSURL *url =[NSURL URLWithString:urlStr];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (IBAction)submitButtonAction:(id)sender {
    if (self.callBack) {
        self.callBack(YES);
    }
}
- (void)cancelButtonAction{
    if (self.callBack) {
        self.callBack(NO);
    }
}

#pragma mark - UIWebviewDelegate
//- (void)webViewDidStartLoad:(UIWebView *)webView{
//    LCLogInfo(@"did start load");
//    [YSAlertUtil showHudWithHint:nil];
//    
//    // hide hud after 3s, incase webview don't callback "webViewDidFinishLoad"  "didFailLoadWithError"
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [YSAlertUtil hideHud];
//    });
//}
//- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    LCLogInfo(@"did finish load");
//    [YSAlertUtil hideHud];
//}
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
//    LCLogInfo(@"did fail load %@",error);
//    [YSAlertUtil hideHud];
//}
@end
