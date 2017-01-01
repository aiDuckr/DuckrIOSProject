//
//  LCPlanCommentTableViewCell.m
//  LinkCity
//
//  Created by roy on 11/17/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCPlanCommentTableViewCell.h"
#import "EGOImageView.h"
#import "LCDateUtil.h"

@interface LCPlanCommentTableViewCell()
@property (weak, nonatomic) IBOutlet EGOImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellBottomLineHeight;

@end
@implementation LCPlanCommentTableViewCell

- (void)awakeFromNib {
    self.cellBottomLineHeight.constant = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

- (void)setComment:(LCCommentModel *)comment{
    _comment = comment;
    
    [self.commentLabel setText:self.comment.content withLineSpace:10];
    self.avatarImageView.imageURL = [NSURL URLWithString:self.comment.userInfo.avatarThumbUrl];
    self.nameLabel.text = self.comment.userInfo.nick;
    self.locName.text = [LCStringUtil getLocationStrWhichMaybeNil:self.comment.userInfo.livingPlace];
    self.sexImageView.image = [self.comment.userInfo getSexImageForPlanCommentPage];
    self.timeLabel.text = [LCDateUtil getTimeIntervalStringFromDateString:self.comment.createTime];
    
//    self.comment.content get
}

- (IBAction)avatarPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(avatarPressed:)]) {
        [self.delegate avatarPressed:self.row];
    }
}

@end
