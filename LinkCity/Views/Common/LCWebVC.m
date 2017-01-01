//
//  LCWebVC.m
//  LinkCity
//
//  Created by 张宗硕 on 11/24/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCWebVC.h"
#import "LCStoryboardManager.h"

@interface LCWebVC ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelBarButton;
@end

@implementation LCWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.delegate = self;
}


+ (instancetype)createVC{
    return (LCWebVC *)[LCStoryboardManager viewControllerWithFileName:SBNameWeb identifier:VCIDWebVC];
}
+ (UINavigationController *)createNavigationVC{
    return (UINavigationController *)[LCStoryboardManager viewControllerWithFileName:SBNameWeb identifier:VCIDWebNavigationVC];
}


- (void)loadWebPageWithString:(NSString*)urlString title:(NSString *)title
{
    RLog(@"load web page with string %@",urlString);
    self.title = title;
    NSURL *url =[NSURL URLWithString:urlString];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)cancelBarButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UIWebviewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    RLog(@"did start load");
    [self showHudInView:self.view hint:nil];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    RLog(@"did finish load");
    [self hideHudInView];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    RLog(@"did fail load %@",error);
    [self hideHudInView];
}
@end
