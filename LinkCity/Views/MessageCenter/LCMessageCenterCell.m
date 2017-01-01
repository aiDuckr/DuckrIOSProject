//
//  LCMessageCenterCell.m
//  LinkCity
//
//  Created by zzs on 14/12/2.
//  Copyright (c) 2014年 linkcity. All rights reserved.
//

#import "LCMessageCenterCell.h"

@implementation LCMessageCenterCell

- (void)awakeFromNib {
    // Initialization code
    self.contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.contentLabel.numberOfLines = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)avatarBtnPressed:(id)sender {
    NSString *uuid = self.notif.fromUserUuid;
    LCUserInfo *userInfo = [[LCUserInfo alloc] init];
    userInfo.uuid = uuid;
    if (nil != self.naviController) {
        [LCViewSwitcher pushToShowUserInfo:userInfo onNavigationVC:self.naviController];
    }
}

@end
