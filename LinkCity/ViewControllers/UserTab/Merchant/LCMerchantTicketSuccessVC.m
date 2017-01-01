//
//  LCMerchantTicketSuccessVC.m
//  LinkCity
//
//  Created by 张宗硕 on 6/16/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCMerchantTicketSuccessVC.h"

@interface LCMerchantTicketSuccessVC ()
@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *sumMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *planTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *planContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *planTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *planPriceLabel;
@property (weak, nonatomic) IBOutlet UIView *contactView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contactHeightConstraint;

@end

@implementation LCMerchantTicketSuccessVC

#pragma mark - Public Interface
+ (instancetype)createInstance {
    return (LCMerchantTicketSuccessVC *)[LCStoryboardManager viewControllerWithFileName:SBNameUserTab identifier:VCIDMerchantTicketSuccessVC];
}

#pragma mark - LifeCycle.
- (void)commonInit {
    [super commonInit];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateShow];
}

- (void)updateShow {
    [self.avatarButton setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:self.user.avatarThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultAvatarImageName]];
    self.nickLabel.text = self.user.nick;
    self.sumMoneyLabel.text = [NSString stringWithFormat:@"支付金额￥%@", self.user.partnerOrder.orderPay];
    self.telLabel.text = self.user.telephone;
    self.codeLabel.text = self.user.partnerOrder.orderCode;
    [self.coverImageView setImageWithURL:[NSURL URLWithString:self.plan.firstPhotoThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultImageName]];
    self.planTitleLabel.text = self.plan.declaration;
    self.planContentLabel.text = self.plan.descriptionStr;
    self.planTimeLabel.text = [NSString stringWithFormat:@"%@ 全程%ld天", self.plan.startTime, (long)self.plan.daysLong];
    self.planPriceLabel.text = [NSString stringWithFormat:@"￥%@/人", self.plan.costPrice];
    
    for (UIView *v in self.contactView.subviews) {
        [v removeFromSuperview];
    }
    
    NSArray *contactArray = self.user.partnerOrder.orderContactNameArray;
    NSArray *identityArray = self.user.partnerOrder.orderContactIdentityArray;
    if (nil == contactArray || contactArray.count <= 0) {
        self.contactHeightConstraint.constant = 0;
        self.contactView.hidden = YES;
    } else {
        self.contactView.hidden = NO;
        NSInteger num = contactArray.count;
        self.contactHeightConstraint.constant = 16.0f * num + (num - 1) * 7;
    }
    for (int i = 0; i < contactArray.count; ++i) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, DEVICE_WIDTH - 12.0f * 2, 16.0f)];
        
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 50.0f, 16.0f)];
        leftLabel.text = [contactArray objectAtIndex:i];
        leftLabel.textColor = UIColorFromRGBA(0x2c2a28, 1.0f);
        leftLabel.font = [UIFont fontWithName:APP_CHINESE_FONT size:13.0f];
        [view addSubview:leftLabel];
        
        UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(52.0f, 0.0f, DEVICE_WIDTH - 52.0f, 16.0f)];
        rightLabel.text = [identityArray objectAtIndex:i];
        rightLabel.textColor = UIColorFromRGBA(0x85817d, 1.0f);
        rightLabel.font = [UIFont fontWithName:APP_CHINESE_FONT size:13.0f];
        [view addSubview:rightLabel];
        
        [self.contactView addSubview:view];
    }
}

@end
