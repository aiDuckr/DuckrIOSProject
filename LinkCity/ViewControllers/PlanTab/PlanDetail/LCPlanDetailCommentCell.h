//
//  LCPlanDetailCommentCell.h
//  LinkCity
//
//  Created by roy on 2/16/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCPlanDetailBaseCell.h"
#import "LCPlanCommentCell.h"

@protocol LCPlanDetailCommentCellDelegate;
@interface LCPlanDetailCommentCell : LCPlanDetailBaseCell
@property (nonatomic, weak) id<LCPlanDetailCommentCellDelegate> delegate;


@property (weak, nonatomic) IBOutlet UIImageView *topBg;
@property (weak, nonatomic) IBOutlet UIImageView *bottomBg;

@property (weak, nonatomic) IBOutlet UILabel *commentNumLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//查看更多按钮
@property (weak, nonatomic) IBOutlet UIButton *checkMoreButton;
//有未读消息时的红点
@property (weak, nonatomic) IBOutlet UIView *unreadCommentView;


@end


@protocol LCPlanDetailCommentCellDelegate <NSObject>

- (void)planDetailCommentCellDidClickCheckMore:(LCPlanDetailCommentCell *)commentCell;
- (void)planDetailCommentCell:(LCPlanDetailCommentCell *)commentCell didClickCommentAtIndex:(NSInteger)index;

@end

