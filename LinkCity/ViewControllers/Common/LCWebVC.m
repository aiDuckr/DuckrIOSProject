//
//  LCWebVC.m
//  LinkCity
//
//  Created by 张宗硕 on 11/24/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCWebVC.h"
#import "LCStoryboardManager.h"
#import "LCShareView.h"

@interface LCWebVC ()<UIWebViewDelegate,LCShareViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) UIBarButtonItem *cancelBarButton;
@property (nonatomic, strong) LCShareView *shareView;

@property (nonatomic, strong) NSString *shareTitle;
@property (nonatomic, strong) NSString *shareContent;
@property (nonatomic, strong) NSString *shareUrl;
@property (nonatomic, strong) NSString *shareImageUrl;
@property (nonatomic, strong) NSString *shareCallBack;
@end

@implementation LCWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.delegate = self;
    
    if ([LCStringUtil isNotNullString:self.webUrlStr]) {
//        NSString *urlStr = [self.webUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url =[NSURL URLWithString:self.webUrlStr];
        NSURLRequest *request =[NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }
    
    self.cancelBarButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBarButtonClick:)];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
    if (self.isPresented) {
        self.navigationItem.rightBarButtonItem = self.cancelBarButton;
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)createVC{
    return (LCWebVC *)[LCStoryboardManager viewControllerWithFileName:SBNameWeb identifier:VCIDWebVC];
}

+ (UINavigationController *)createNavigationVC{
    return [[UINavigationController alloc] initWithRootViewController:[LCWebVC createVC]];
}

- (void)cancelBarButtonClick:(id)sender {
    if (self.isPresented) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}




- (void)appDidBecomeActive{
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

#pragma mark - UIWebviewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    LCLogInfo(@"did start load");
    [YSAlertUtil showHudWithHint:nil inView:self.view enableUserInteraction:YES];
    
    // hide hud after 3s, incase webview don't callback "webViewDidFinishLoad"  "didFailLoadWithError"
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [YSAlertUtil hideHud];
    });
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    LCLogInfo(@"did finish load");
    [YSAlertUtil hideHud];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    LCLogInfo(@"did fail load %@",error);
    [YSAlertUtil hideHud];
}

#pragma mark Js Call
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *objcCallPrefix = @"objc://";
    NSString *shareByJsPrefix = @"sharebyjs/";
    
    
    NSString *urlString = [[request URL] absoluteString];
    urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    LCLogInfo(@"%@",urlString);
    
    if ([urlString hasPrefix:objcCallPrefix]) {
        NSString *callString = [urlString stringByReplacingCharactersInRange:NSMakeRange(0, [objcCallPrefix length]) withString:@""];
        
        if ([callString hasPrefix:shareByJsPrefix]) {
            NSString *jsonString = [callString stringByReplacingCharactersInRange:NSMakeRange(0, [shareByJsPrefix length]) withString:@""];
            NSArray *jsonArr = [LCStringUtil getArrayFromJsonStr:jsonString];
            
            
            if (jsonArr.count == 5) {
                /*调用本地函数1*/
                [self sharebyjs:[jsonArr objectAtIndex:0]
                        content:[jsonArr objectAtIndex:1]
                            url:[jsonArr objectAtIndex:2]
                            img:[jsonArr objectAtIndex:3]
                       callBack:[jsonArr objectAtIndex:4]];
            }else if(jsonArr.count == 4) {
                /*调用本地函数1*/
                [self sharebyjs:[jsonArr objectAtIndex:0]
                        content:[jsonArr objectAtIndex:1]
                            url:[jsonArr objectAtIndex:2]
                            img:[jsonArr objectAtIndex:3]
                       callBack:nil];
            }
        }
        
        return NO;
    };
    
    return YES;
}

- (void)sharebyjs:(NSString *)shareTitle content:(NSString *)shareContent url:(NSString *)shareUrl img:(NSString *)imgUrl callBack:(NSString *)callBackFunc{
    
    if (!self.shareView) {
        self.shareView = [LCShareView createInstance];
        self.shareView.delegate = self;
    }
    
    self.shareTitle = shareTitle;
    self.shareContent = shareContent;
    self.shareUrl = shareUrl;
    self.shareImageUrl = imgUrl;
    
    if ([LCStringUtil isNullString:callBackFunc]) {
        self.shareCallBack = nil;
    }else{
        self.shareCallBack = [callBackFunc stringByAppendingString:@"();"];
    }
    
    [LCShareView showShareView:self.shareView onViewController:self];
}

- (void)sharedToDoJsCallBack:(BOOL)shareSucceed{
    if ([LCStringUtil isNotNullString:self.shareCallBack] &&
        shareSucceed) {
        [self.webView stringByEvaluatingJavaScriptFromString:self.shareCallBack];
    }
}

#pragma mark LCShareView Delegate
- (void)cancelShareAction {
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:nil];
}

- (void)shareWeixinAction{
    ZLog(@"shareTourpicWeixin");
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^{
       [LCShareUtil shareToWeiXinWith:self.shareTitle content:self.shareContent url:self.shareUrl img:self.shareImageUrl callBack:^(BOOL succeed) {
           [self sharedToDoJsCallBack:succeed];
       }];
    }];
}

- (void)shareWeixinTimeLineAction{
    ZLog(@"shareTourpicWeixinTimeLine");
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^{
        [LCShareUtil shareToWeiXinTimeLineWith:self.shareTitle content:self.shareContent url:self.shareUrl img:self.shareImageUrl callBack:^(BOOL succeed) {
            [self sharedToDoJsCallBack:succeed];
        }];
    }];
}

- (void)shareWeiboAction{
    ZLog(@"shareTourpicWeibo");
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^{
        [LCShareUtil shareToWeiboWith:self.shareTitle content:self.shareContent url:self.shareUrl img:self.shareImageUrl callBack:^(BOOL succeed) {
            [self sharedToDoJsCallBack:succeed];
        }];
    }];
}

- (void)shareQQAction{
    ZLog(@"shareTourpicQQ");
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^{
        [LCShareUtil shareToQQWith:self.shareTitle content:self.shareContent url:self.shareUrl img:self.shareImageUrl callBack:^(BOOL succeed) {
            [self sharedToDoJsCallBack:succeed];
        }];
    }];
}



@end
