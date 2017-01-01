//
//  LCUserRefundingVC.m
//  LinkCity
//
//  Created by godhangyu on 16/6/7.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCUserRefundingVC.h"

@interface RefundTextField : UITextField
@end
@implementation RefundTextField : UITextField

- (CGRect)textRectForBounds:(CGRect)bounds {
    return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(10, 8, 10, 8));
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(10, 8, 10, 8));
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(10, 8, 10, 8));
}

@end
@interface LCUserRefundingVC ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sendButton;
@property (weak, nonatomic) IBOutlet RefundTextField *refundTextField;
@property (weak, nonatomic) IBOutlet UITextView *refundTextView;

@end

@implementation LCUserRefundingVC

+ (instancetype)createInstance {
    return (LCUserRefundingVC *)[LCStoryboardManager viewControllerWithFileName:SBNameUserOrder identifier:VCIDUserRefundingVC];
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavgationBar];
    [self initTextField];
    [self initTextView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Common Init

- (void)initNavgationBar {
    self.title = @"申请退款";
    
    NSDictionary* textAttributes = [NSDictionary dictionaryWithObject: UIColorFromRGBA(0xfb4c4c, 1) forKey: NSForegroundColorAttributeName];
    
    [self.sendButton setTitleTextAttributes: textAttributes forState: UIControlStateNormal];
    
    NSDictionary* textAttributes1 = [NSDictionary dictionaryWithObject: UIColorFromRGBA(0xfdc4c4, 1) forKey: NSForegroundColorAttributeName];
    [self.sendButton setTitleTextAttributes: textAttributes1 forState: UIControlStateDisabled];
    
    self.sendButton.enabled = NO;
}

- (void)initTextField {
    self.refundTextField.layer.borderColor = [UIColorFromRGBA(0xe8e4dd, 1) CGColor];
    
    NSString *placeholderStr = @"请描述你的退款原因，我们会尽快给予处理";
    NSMutableAttributedString *attributedPlaceholderStr = [[NSMutableAttributedString alloc] initWithString:placeholderStr];
    NSRange range = NSMakeRange(0, [placeholderStr length]);
    
    [attributedPlaceholderStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGBA(0xaba7a2, 1) range:range];
    [attributedPlaceholderStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"FZLTHJW--GB1-0" size:15.0f] range:range];
    
    [self.refundTextField setAttributedPlaceholder:attributedPlaceholderStr];
    
    //self.refundTextField.delegate = self;
    [self.refundTextField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)initTextView {
    NSString *str = self.refundIntro;
    NSRange range = NSMakeRange(0, [str length]);
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8.0f];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    [attributedStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGBA(0x7d7975, 1) range:range];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"FZLTHJW--GB1-0" size:13.0f] range:range];
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    [self.refundTextView setAttributedText:attributedStr];
    
    self.refundTextView.selectable = NO;
}

#pragma mark - Action

- (IBAction)sendAction:(id)sender {
    __weak typeof(self) weakSelf = self;
    
    [LCNetRequester planOrderRefund_V_FIVE:self.orderGuid refund:1 reason:self.refundTextField.text callBack:^(NSDecimalNumber *days, LCRefundStatusType refundStatus, NSDecimalNumber *refundMoney, NSInteger refundScore, NSString *refundTitle, NSString *message, NSError *error) {
        if (!error) {
            //下线群聊
            [[LCXMPPMessageHelper sharedInstance] getRoomOfflineWithRoomBareJid:weakSelf.planRoomId];
        
            //删除聊天记录和通讯录和红点
            NSString *bareJidStr = weakSelf.planRoomId;
            [LCXMPPUtil deleteChatMsg:bareJidStr];
            [LCXMPPUtil deleteChatContact:bareJidStr];
            [[LCDataManager sharedInstance] clearUnreadNumForBareJidStr:bareJidStr];
        
            //pop 到顶
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [YSAlertUtil alertOneButton:@"知道了" withTitle:nil msg:[LCStringUtil getNotNullStr:message] callBack:nil];
        } else {
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipDefaultDelay];
        }
    }];
}

#pragma mark - RefundTextField Delegate

- (void)textFieldEditChanged:(UITextFieldLabel *)textField {
    if ([LCStringUtil isNotNullString:self.refundTextField.text]) {
        self.sendButton.enabled = YES;
    } else {
        self.sendButton.enabled = NO;
    }
}


@end
