//
//  LCTourpicCommentCell.h
//  LinkCity
//
//  Created by 张宗硕 on 4/3/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCTourpicComment.h"

@class LCTourpicCommentCell;

@interface LCTourpicCommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (retain, nonatomic) LCTourpicComment *comment;

- (void)updateCommentCell:(LCTourpicComment *)comment;
@end
