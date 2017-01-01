//
//  LCChatGroupMemberBottomCell.m
//  LinkCity
//
//  Created by roy on 3/16/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCChatGroupMemberBottomCell.h"

@implementation LCChatGroupMemberBottomCell

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self.submitButton addTarget:self action:@selector(submitButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setChatGroup:(LCChatGroupModel *)chatGroup{
    _chatGroup = chatGroup;
    
    [self updateShow];
}

- (void)updateShow{
    [self.descriptionLabel setText:[LCStringUtil getNotNullStr:self.chatGroup.descriptionStr] withLineSpace:7];
    CGRect frame = self.descriptionLabel.frame;
    CGSize rightSize = [self.descriptionLabel sizeThatFits:CGSizeMake((DEVICE_WIDTH-30), 0)];
    frame.size = rightSize;
    self.descriptionLabel.frame = frame;
    
    if (self.chatGroup.isMember) {
        self.submitButton.enabled = YES;
        self.banDisturbSwitch.enabled = YES;
        if (self.chatGroup.isAlert) {
            self.banDisturbSwitch.on = NO;
        }else{
            self.banDisturbSwitch.on = YES;
        }
        [self.submitButton setTitle:@"退出群组" forState:UIControlStateNormal];
    }else{
        self.submitButton.enabled = YES;
        self.banDisturbSwitch.enabled = NO;
        [self.submitButton setTitle:@"加入群组" forState:UIControlStateNormal];
    }
    
    [self setNeedsUpdateConstraints];
}

- (IBAction)banDisturbSwitchAction:(UISwitch *)sender {
    sender.enabled = NO;
    
    //如果send.on，打开免打扰，则设置isAlert=0
    NSInteger setToAlert = sender.on?0:1;
    [LCNetRequester setChatGroupAlert:setToAlert groupGuid:self.chatGroup.guid callBack:^(NSInteger isAlert, NSError *error) {
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
        }
        
        self.chatGroup.isAlert = isAlert;
        [self updateShow];
        if ([self.delegate respondsToSelector:@selector(chatGroupMemberBottomCellDidUpdateData:)]) {
            [self.delegate chatGroupMemberBottomCellDidUpdateData:self];
        }
        sender.enabled = YES;
    }];
}
- (void)submitButtonAction{
    if (self.chatGroup.isMember) {
        // quit
        [LCNetRequester quitChatGroupWithChatGroupGuid:self.chatGroup.guid callBack:^(NSError *error) {
            if (error) {
                [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
            }else{
                ///下线群聊
                [[LCXMPPMessageHelper sharedInstance] getRoomOfflineWithRoomBareJid:self.chatGroup.groupJid];
                
                //删除聊天记录和通讯录
                NSString *bareJidStr = self.chatGroup.groupJid;
                [LCXMPPUtil deleteChatMsg:bareJidStr];
                [LCXMPPUtil deleteChatContact:bareJidStr];
                //删除聊天红点
                [[LCDataManager sharedInstance] clearUnreadNumForBareJidStr:bareJidStr];
                
                if ([self.delegate respondsToSelector:@selector(chatGroupMemberBottomCellDidQuitChatGroup:)]) {
                    [self.delegate chatGroupMemberBottomCellDidQuitChatGroup:self];
                }
            }
        }];
    }else{
        // join
        [LCNetRequester joinChatGroupWithChatGroupGuid:self.chatGroup.guid location:[LCDataManager sharedInstance].userLocation callBack:^(LCChatGroupModel *chatGroup, NSError *error) {
            if (error) {
                LCLogWarn(@"joinChatGroupWithChatGroupGuid error:%@",error);
                [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
            }else{
                self.chatGroup = chatGroup;
                [self updateShow];
                
                if ([self.delegate respondsToSelector:@selector(chatGroupMemberBottomCellDidJoinChatGroup:newChatGroup:)]) {
                    [self.delegate chatGroupMemberBottomCellDidJoinChatGroup:self newChatGroup:chatGroup];
                }
            }
            
        }];
    }
}

+ (CGFloat)getCellheightForChatGroup:(LCChatGroupModel *)chatGroup{
    CGFloat height = 0;
    height += 15;
    height += [LCStringUtil getHeightOfString:[LCStringUtil getNotNullStr:chatGroup.descriptionStr] withFont:[UIFont fontWithName:FONT_LANTINGBLACK size:14] lineSpace:7 labelWidth:(DEVICE_WIDTH-30)];
    height += 15;
    height += 10;
    height += 50;
    height += 15;
    height += 41;
    height += 20;
    
    return height;
}


@end
