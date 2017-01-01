//
//  LCPlanDetailACommentCell.h
//  LinkCity
//
//  Created by roy on 2/16/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCCommentModel.h"

@interface LCPlanCommentCell : UITableViewCell
@property (nonatomic, strong) LCCommentModel *comment;


//UI
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


+ (CGFloat)getCellHeightForComment:(LCCommentModel *)comment;
@end

