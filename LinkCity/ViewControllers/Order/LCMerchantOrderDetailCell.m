//
//  LCMerchantOrderDetailCell.m
//  LinkCity
//
//  Created by 张宗硕 on 12/25/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCMerchantOrderDetailCell.h"

@implementation LCMerchantOrderDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateShowOrderCell:(LCUserModel *)user {
    self.user = user;
    self.payNameLabel.text = @"";
    self.contactPhoneLabel.text = @"";
    self.userPayLabel.text = @"";
    self.orderCodeLabel.text = @"";
    [self.avatarImageButton setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:user.avatarThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultAvatarImageName]];
    NSArray *contactArray = user.partnerOrder.orderContactNameArray;
    NSArray *identityArray = user.partnerOrder.orderContactIdentityArray;
    NSArray *telephoneArray = user.partnerOrder.orderContactPhoneArray;
    for (UIView *view in self.usersListView.subviews) {
        [view removeFromSuperview];
    }
    for (int i = 0; i < contactArray.count; ++i) {
        if (i >= identityArray.count || i >= telephoneArray.count) {
            break ;
        }
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 12.0 + i * (13.0f + 9.0f), DEVICE_WIDTH - (375.0f - 264.0f), 13.0f)];
        label.font = [UIFont fontWithName:APP_CHINESE_FONT size:13.0f];
        label.textColor = UIColorFromRGBA(0x85817d, 1.0f);
        if (0 == i && 1 == contactArray.count) {
            label.text = [NSString stringWithFormat:@"身份证：%@", [identityArray objectAtIndex:i]];
        } else {
            label.text = [NSString stringWithFormat:@"%@：%@", [contactArray objectAtIndex:i], [identityArray objectAtIndex:i]];
        }
        [self.usersListView addSubview:label];
    }
    
    if (0 == contactArray.count) {
        self.usersListView.hidden = YES;
        self.userListViewHeightConstraint.constant = 0;
    } else {
        self.usersListView.hidden = NO;
        self.userListViewHeightConstraint.constant = 12.0f + contactArray.count * 22.0f;
        self.payNameLabel.text = [contactArray objectAtIndex:0];
        self.contactPhoneLabel.text = [telephoneArray objectAtIndex:0];
    }
    self.userPayLabel.text = [NSString stringWithFormat:@"支付全额￥%@", [user.partnerOrder getTotalPrice]];
    self.orderCodeLabel.textColor = UIColorFromRGBA(0x85817d, 1.0f);
    if (0 != user.partnerOrder.orderRefund) {
        if (1 == user.partnerOrder.orderRefund) {
            self.orderCodeLabel.text = @"退款成功";
        } else {
            self.orderCodeLabel.text = @"申请退款";
        }
    } else if (0 == user.partnerOrder.orderCheck) {
        self.orderCodeLabel.text = @"未验票";
        self.orderCodeLabel.textColor = UIColorFromRGBA(0xfb4c4c, 1.0f);
    } else if (1 == user.partnerOrder.orderCheck) {
        self.orderCodeLabel.text = [NSString stringWithFormat:@"付款码%@", user.partnerOrder.orderCode];
    }
    
}

#pragma mark UIButton Action
- (IBAction)telephoneButtonAction:(id)sender {
    NSArray *telephoneArray = self.user.partnerOrder.orderContactPhoneArray;
    if (nil != telephoneArray && telephoneArray.count > 0) {
        [LCSharedFuncUtil dialPhoneNumber:telephoneArray[0]];
    }
}

@end
