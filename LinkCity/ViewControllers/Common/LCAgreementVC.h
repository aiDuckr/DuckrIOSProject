//
//  LCAgreementVC.h
//  LinkCity
//
//  Created by roy on 3/12/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCBaseVC.h"

@interface LCAgreementVC : LCBaseVC
@property (nonatomic, strong) void(^callBack)(BOOL didConfirm);
@property (nonatomic, strong) NSString *urlStr;
@property (nonatomic, assign) BOOL showCancelBarButton;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;


+ (instancetype)createInstance;
@end
