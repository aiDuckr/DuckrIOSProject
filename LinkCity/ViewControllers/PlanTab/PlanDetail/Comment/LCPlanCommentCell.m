//
//  LCPlanDetailACommentCell.m
//  LinkCity
//
//  Created by roy on 2/16/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCPlanCommentCell.h"

@implementation LCPlanCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setComment:(LCCommentModel *)comment{
    _comment = comment;
    
    [self updateShow];
}

- (void)updateShow{
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:self.comment.user.avatarThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultAvatarImageName]];
    
    self.nameLabel.text = [LCStringUtil getNotNullStr:self.comment.title];
    [self.commentLabel setText:[LCStringUtil getNotNullStr:self.comment.content] withLineSpace:9];
    self.timeLabel.text = [LCDateUtil getTimeIntervalStringFromDateString:self.comment.createdTime];
}

- (IBAction)avatarButtonAction:(id)sender {
    if (self.comment.user && [LCStringUtil isNotNullString:self.comment.user.uUID]) {
        UIViewController *topVC = [LCSharedFuncUtil getTopMostViewController];
        UINavigationController *topNavVC = topVC.navigationController;
        if (topNavVC) {
            [LCViewSwitcher pushToShowUserInfoVCForUser:self.comment.user on:topNavVC];
        }
    }
}


+ (CGFloat)getCellHeightForComment:(LCCommentModel *)comment{
    CGFloat height = 0;
    height += 40;
    CGFloat commentLabelHeight = [LCStringUtil getHeightOfString:comment.content
                                                           withFont:[UIFont fontWithName:FONT_LANTINGBLACK size:13]
                                                          lineSpace:9
                                                         labelWidth:(DEVICE_WIDTH-15-40-6-15)];
    height += commentLabelHeight;
    height += 15;
    
    return height;
}




@end
