//
//  LCUserCommentCell.m
//  LinkCity
//
//  Created by 张宗硕 on 12/15/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCUserCommentCell.h"
#import "LCCommentScoreView.h"

@interface LCUserCommentCell()

@property (nonatomic, strong) LCCommentScoreView *scoreView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nickLabelTopMargin;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *replyLabelTopMargin;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@end

@implementation LCUserCommentCell

- (void)awakeFromNib {
    // Initialization code
    self.replyLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.replyLabel.numberOfLines = 0;
    self.scoreView = [[LCCommentScoreView alloc] initWithFrame:CGRectMake(self.nickLabel.x, 35, 75, 14) scoreViewType:LCCommentScoreViewTypeCommonDetail];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateShowComment:(LCCommentModel *)comment {
    [self.scoreView removeFromSuperview];
    self.comment = comment;
    [self.avatarImageButton setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:comment.user.avatarThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultAvatarImageName]];
    self.nickLabel.text = comment.user.nick;
    self.timeLabel.text = [LCDateUtil getTimeIntervalStringFromDateString:comment.createdTime];
    
    if (self.comment.commentType == 1) {
        //TODO
        NSString *atStr = [@"@" stringByAppendingString:comment.replyToUserNick];
        NSMutableAttributedString *commentStr = [[NSMutableAttributedString alloc] initWithString: comment.content];
        [commentStr replaceCharactersInRange:[[commentStr string] rangeOfString:comment.replyToUserNick] withString:atStr];
        NSRange range = [[commentStr string] rangeOfString:atStr];
        [commentStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGBA(0xad7f2d, 1) range:range];
        [self.replyLabel setAttributedText:commentStr];
    } else {
        self.replyLabel.text = comment.content;
    }
}


- (void)updateShowComment:(LCCommentModel *)comment withType:(LCUserCommentCellType)type {
    [self.scoreView removeFromSuperview];
    [self updateShowComment:comment];
    if (type == LCUserCommentCellTypeCommon) {
        //[self updateShowComment:comment];
        self.nickLabelTopMargin.constant = 27.0;
        self.replyLabelTopMargin.constant = 52.0;
        self.contentView.backgroundColor = UIColorFromRGBA(0xFAF9F8, 1.0);
    } else {
        //[self updateShowComment:comment];
        self.nickLabelTopMargin.constant = 15.0;
        self.replyLabelTopMargin.constant = 61.0;
        self.containerView.backgroundColor = [UIColor whiteColor];
        [self.containerView addSubview:self.scoreView];
        //self.scoreView.backgroundColor = [UIColor redColor];
        [self.scoreView updateShowWithScore:comment.score];
        [self layoutIfNeeded];
    }
}
- (IBAction)avatarImageButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(userCommentToViewUserDetail:)]) {
        [self.delegate userCommentToViewUserDetail:self.comment.user];
    }
}


@end
