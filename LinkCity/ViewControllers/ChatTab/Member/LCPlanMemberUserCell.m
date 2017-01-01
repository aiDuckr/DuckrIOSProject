//
//  LCPlanMemberUserCell.m
//  LinkCity
//
//  Created by roy on 3/17/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCPlanMemberUserCell.h"

@implementation LCPlanMemberUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setUser:(LCUserModel *)user{
    _user = user;
    
    [self updateShow];
}

- (void)updateShow{
    if (self.user) {
        [self.avatarImageView setImageWithURL:[NSURL URLWithString:self.user.avatarThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultAvatarImageName]];
        self.nickLabel.text = [LCStringUtil getNotNullStr:self.user.nick];
        
        if (self.user.partnerOrder && self.user.partnerOrder.orderNumber > 1) {
            NSMutableAttributedString *nickStr = [[NSMutableAttributedString alloc] initWithString:self.user.nick attributes:@{NSFontAttributeName:[UIFont fontWithName:FONT_LANTINGBLACK size:13],                                                                                      NSForegroundColorAttributeName:UIColorFromRGBA(0xA8A4A0, 1)}];
            [nickStr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" 等%ld人",(long)self.user.partnerOrder.orderNumber] attributes:@{NSFontAttributeName:[UIFont fontWithName:FONT_LANTINGBLACK size:13],                                                                                      NSForegroundColorAttributeName:UIColorFromRGBA(0xB6D827, 1)}]];
            
            [self.nickLabel setAttributedText:nickStr];
        }
        
        
        if (self.isInEditState) {
            self.kickUserIcon.hidden = NO;
        }else{
            self.kickUserIcon.hidden = YES;
        }
    }else{
        [self.avatarImageView setImage:[UIImage imageNamed:@"KickOffUserIcon"]];
        self.nickLabel.text = @"踢人";
        self.kickUserIcon.hidden = YES;
    }
}

+ (CGFloat)getCellHeight{
    return 95;
}

@end
