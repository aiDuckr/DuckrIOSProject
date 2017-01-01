//
//  LCChargeDetailUserCell.m
//  LinkCity
//
//  Created by Roy on 6/25/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCChargeDetailUserCell.h"

@implementation LCChargeDetailUserCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.borderBgView.layer.borderColor = UIColorFromRGBA(LCCellBorderColor, 1).CGColor;
    self.borderBgView.layer.borderWidth = LCCellBorderWidth;
    self.borderBgView.layer.masksToBounds = YES;
    self.borderBgView.layer.cornerRadius = LCCellCornerRadius;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)avatarButtonAction:(id)sender {
    [LCViewSwitcher pushToShowUserInfoVCForUser:self.user on:[LCSharedFuncUtil getTopMostViewController].navigationController];
}

- (IBAction)detailButtonAction:(id)sender {
    [LCSharedFuncUtil dialPhoneNumber:self.user.telephone];
}

- (void)updateShowWithUser:(LCUserModel *)user isLastCell:(BOOL)isLast{
    self.user = user;
    
    [self.avatarBtn setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:self.user.avatarThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultAvatarImageName]];
    self.nickLabel.text = [LCStringUtil getNotNullStr:self.user.nick];
    self.orderCodeLabel.text = [LCStringUtil getNotNullStr:self.user.telephone];
    if (self.user.partnerOrder.orderContactNameArray.count > 0 &&
        self.user.partnerOrder.orderContactPhoneArray.count > 0) {
        self.nickLabel.text = [self.user.partnerOrder.orderContactNameArray firstObject];
        self.orderCodeLabel.text = [self.user.partnerOrder.orderContactPhoneArray firstObject];
    }
    
    if (self.user.partnerOrder) {
        if (self.user.partnerOrder.orderNumber > 1) {
            self.withOtherLabel.text = [NSString stringWithFormat:@"等%ld人",(long)self.user.partnerOrder.orderNumber];
        }else{
            self.withOtherLabel.text = @"";
        }
        
        NSString *chargeStr = [LCChargeDetailUserCell getChargeStringFromUser:self.user];
        [self.chargeLabel setText:chargeStr withLineSpace:LCTextFieldLineSpace];
    }
    
    
    
    if (isLast) {
        self.borderBgViewBottom.constant = 0;
        self.bottomLine.hidden = YES;
    }else{
        self.borderBgViewBottom.constant = -6;
        self.bottomLine.hidden = NO;
    }
}

+ (NSString *)getChargeStringFromUser:(LCUserModel *)user{
    NSString *chargeStr = @"";
    if ([user paidTail]) {
        LCPartnerOrderModel *tailOrder = user.tailOrder;
        if ([user.partnerOrder.orderPrice compare:user.partnerOrder.orderEarnest] == NSOrderedSame) {
            tailOrder = user.partnerOrder;
        }
        
        chargeStr = [chargeStr stringByAppendingFormat:@"支付全款￥%@",[tailOrder getTotalPrice]];
    }else if([user paidEarnest]) {
        chargeStr = [chargeStr stringByAppendingFormat:@"支付订金￥%@",[user.partnerOrder getTotalEarnest]];
    }
    
    chargeStr = [chargeStr stringByAppendingFormat:@" 付款码 %@",user.partnerOrder.orderCode];
    
    if (user.partnerOrder.orderContactNameArray.count > 1 &&
        user.partnerOrder.orderContactNameArray.count == user.partnerOrder.orderContactPhoneArray.count) {
        chargeStr = [chargeStr stringByAppendingString:@"\r\n其他联系人:"];
        for (int i=1; i<user.partnerOrder.orderContactNameArray.count; i++){
            chargeStr = [chargeStr stringByAppendingFormat:@"\r\n%@ %@",user.partnerOrder.orderContactNameArray[i], user.partnerOrder.orderContactPhoneArray[i]];
        }
    }
    
    return chargeStr;
}


+ (CGFloat)getCellHeightForUser:(LCUserModel *)user{
    CGFloat height = 52;
    
    CGFloat chargeStrHeight = [LCStringUtil getHeightOfString:[LCChargeDetailUserCell getChargeStringFromUser:user]
                                                           withFont:[UIFont fontWithName:FONT_LANTINGBLACK size:13]
                                                          lineSpace:LCTextFieldLineSpace
                                                         labelWidth:DEVICE_WIDTH-12-12-60-12];
    
    return height + chargeStrHeight;
}


@end
