//
//  LCUserCommentCell.h
//  LinkCity
//
//  Created by 张宗硕 on 12/15/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCUserCommentCellDelegate;

typedef NS_ENUM(NSInteger,LCUserCommentCellType){
    LCUserCommentCellTypeCommon,
    LCUserCommentCellTypeScore,
};




@interface LCUserCommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *avatarImageButton;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyLabel;
@property (retain, nonatomic) LCCommentModel *comment;

@property (retain, nonatomic) id<LCUserCommentCellDelegate> delegate;

- (void)updateShowComment:(LCCommentModel *)comment;
- (void)updateShowComment:(LCCommentModel *)comment withType:(LCUserCommentCellType)type;
@end

@protocol LCUserCommentCellDelegate <NSObject>
- (void)userCommentToViewUserDetail:(LCUserModel *)user;

@end