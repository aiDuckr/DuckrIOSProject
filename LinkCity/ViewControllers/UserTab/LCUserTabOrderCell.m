//
//  LCUserTabOrderCell.m
//  LinkCity
//
//  Created by 张宗硕 on 12/21/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCUserTabOrderCell.h"

@implementation LCUserTabOrderCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateShowOrderCell:(LCPlanModel *)plan {
    if (nil == plan.memberList || plan.memberList.count <= 0) {
        return ;
    }
    NSString *loginUUID = [LCDataManager sharedInstance].userInfo.uUID;
    LCUserModel *orderUser = nil;
    for (LCUserModel *user in plan.memberList) {
        if ([loginUUID isEqualToString:user.uUID]) {
            orderUser = user;
        }
    }
    LCUserModel *createrUser = [plan.memberList objectAtIndex:0];
    [self.avatarButton setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:createrUser.avatarThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultAvatarImageName]];
    self.nickLabel.text = createrUser.nick;
    self.titleLabel.text = plan.declaration;
    NSString *timeStr = [NSString stringWithFormat:@"出发日期：%@   全程%ld天",
                         [LCDateUtil getDotDateFromHorizontalLineStr:plan.startTime],
                         (long)plan.daysLong];
    self.startTimeLabel.text = timeStr;
    self.codeLabel.text = [NSString stringWithFormat:@"兑换码：%@", [LCStringUtil getNotNullStr:orderUser.partnerOrder.orderCode]];
    self.numLabel.text = [NSString stringWithFormat:@"%ld张", (long)orderUser.partnerOrder.orderNumber];
    self.moneyLabel.text = [NSString stringWithFormat:@"合计%@元", orderUser.partnerOrder.orderPay];
    if ([plan.endTime compare:[LCDateUtil getTodayStr]] < 0) {
        self.statusLabel.text = @"已结束";
    }
}
@end
