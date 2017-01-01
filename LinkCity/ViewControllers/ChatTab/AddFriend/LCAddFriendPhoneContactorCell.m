//
//  LCAddAddressBookUserCell.m
//  LinkCity
//
//  Created by roy on 3/16/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCAddFriendPhoneContactorCell.h"

@implementation LCAddFriendPhoneContactorCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.favorButton addTarget:self action:@selector(favorButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setShowType:(LCAddFriendPhoneContactorCellType)showType{
    _showType = showType;
    
    [self updateShow];
}

- (void)updateShow{
    switch (self.showType) {
        case LCAddFriendPhoneContactorCellType_Favor:{
            self.favorButton.backgroundColor = [UIColor clearColor];
            self.favorButton.layer.borderColor = UIColorFromRGBA(LCDarkTextColor, 1).CGColor;
            self.favorButton.layer.borderWidth = 0.5;
            [self.favorButton setTitle:@"关注" forState:UIControlStateNormal];
            [self.favorButton setTitleColor:UIColorFromRGBA(LCDarkTextColor, 1) forState:UIControlStateNormal];
        }
            break;
        case LCAddFriendPhoneContactorCellType_Favored:{
            self.favorButton.backgroundColor = [UIColor clearColor];
            self.favorButton.layer.borderWidth = 0;
            [self.favorButton setTitle:@"已关注" forState:UIControlStateNormal];
            [self.favorButton setTitleColor:UIColorFromR_G_B_A(201, 197, 193, 1) forState:UIControlStateNormal];
        }
            break;
        case LCAddFriendPhoneContactorCellType_Invite:{
            self.favorButton.backgroundColor = UIColorFromR_G_B_A(247, 245, 243, 1);
            self.favorButton.layer.borderColor = UIColorFromRGBA(LCDarkTextColor, 1).CGColor;
            self.favorButton.layer.borderWidth = 0;
            [self.favorButton setTitle:@"邀请" forState:UIControlStateNormal];
            [self.favorButton setTitleColor:UIColorFromRGBA(LCDarkTextColor, 1) forState:UIControlStateNormal];
        }
            break;
        case LCAddFriendPhoneContactorCellType_Invited:{
            self.favorButton.backgroundColor = [UIColor clearColor];
            self.favorButton.layer.borderWidth = 0;
            [self.favorButton setTitle:@"已邀请" forState:UIControlStateNormal];
            [self.favorButton setTitleColor:UIColorFromR_G_B_A(201, 197, 193, 1) forState:UIControlStateNormal];
        }
            break;
    }
}

- (void)favorButtonAction{
    if ([self.delegate respondsToSelector:@selector(addFriendPhoneContactorCellDidClickButton:)]) {
        [self.delegate addFriendPhoneContactorCellDidClickButton:self];
    }
}

+ (CGFloat)getCellHeight{
    return 58;
}


@end
