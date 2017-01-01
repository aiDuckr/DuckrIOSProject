//
//  LCTourpicCommentCell.m
//  LinkCity
//
//  Created by 张宗硕 on 4/3/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCTourpicCommentCell.h"

@implementation LCTourpicCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCommentCell:(LCTourpicComment *)comment {
    self.comment = comment;
    [self.avatarButton setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:comment.user.avatarThumbUrl] placeholderImage:[UIImage imageNamed:@"DefaultAvatar"]];
    self.nickLabel.text = comment.title;
    self.timeLabel.text = [LCDateUtil getTimeIntervalStringFromDateString:comment.createdTime];
    
    if (self.comment.commentType == 1 && [LCStringUtil isNotNullString:comment.replyToUserNick]) {
        //TODO
        NSString *atStr = [@"@" stringByAppendingString:comment.replyToUserNick];
        NSMutableAttributedString *commentStr = [[NSMutableAttributedString alloc] initWithString: comment.content];
        [commentStr replaceCharactersInRange:[[commentStr string] rangeOfString:comment.replyToUserNick] withString:atStr];
        NSRange range = [[commentStr string] rangeOfString:atStr];
        [commentStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGBA(0xad7f2d, 1) range:range];
        [self.contentLabel setAttributedText:commentStr];
    } else {
        self.contentLabel.text = comment.content;
    }
}

- (IBAction)userAvatarButtonAction:(id)sender {
    LCUserModel *user = self.comment.user;
    UINavigationController *nav = [LCSharedFuncUtil getTopMostNavigationController];
    if (nil != nav) {
        [LCViewSwitcher pushToShowUserInfoVCForUser:user on:nav];
    }
}


@end
