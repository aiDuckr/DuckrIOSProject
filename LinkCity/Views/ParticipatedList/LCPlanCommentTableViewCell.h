//
//  LCPlanCommentTableViewCell.h
//  LinkCity
//
//  Created by roy on 11/17/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCCommentModel.h"

@protocol LCPlanCommentTableViewCellDelegate <NSObject>
- (void)avatarPressed:(NSInteger)row;

@end

@interface LCPlanCommentTableViewCell : UITableViewCell
@property (nonatomic,strong) LCCommentModel *comment;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, retain) id<LCPlanCommentTableViewCellDelegate> delegate;
@end
