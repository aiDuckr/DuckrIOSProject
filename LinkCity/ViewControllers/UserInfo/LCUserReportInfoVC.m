//
//  LCUserReportInfoVC.m
//  LinkCity
//
//  Created by godhangyu on 16/6/11.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCUserReportInfoVC.h"

@interface LCUserReportInfoVC ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation LCUserReportInfoVC

+ (instancetype)createInstance {
    return (LCUserReportInfoVC *)[LCStoryboardManager viewControllerWithFileName:SBNameUser identifier:VCIDUserReportInfoVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initTextView];
    
}

- (void)initTextView {
    NSString *str = @"        您应保证您的投诉行为基于善意，并代表您本人的真实意思。达客旅行APP作为中立的平台服务者，收到您的投诉后，会尽快按照相关法律法规的规定独立判断并进行处理。达客旅行APP将会采取合理的措施保护您的个人信息；除法律法规规定的情形外，未经用户许可达客旅行不会向第三方公开、透露您的个人信息。";
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8.0f];
    NSRange range = NSMakeRange(0, [str length]);
    
    [attributedStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGBA(0x2a2c28, 1) range:range];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"FZLTHJW--GB1-0" size:14.0f] range:range];
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    
    self.textView.textContainerInset = UIEdgeInsetsMake(15, 8, 8, 8);
    [self.textView setAttributedText:attributedStr];
}

@end
