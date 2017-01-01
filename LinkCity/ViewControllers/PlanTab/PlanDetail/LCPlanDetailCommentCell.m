//
//  LCPlanDetailCommentCell.m
//  LinkCity
//
//  Created by roy on 2/16/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCPlanDetailCommentCell.h"

@interface LCPlanDetailCommentCell()<UITableViewDataSource,UITableViewDelegate>

@end

static const CGFloat PlanDetailACommentCellHeight = 70;
@implementation LCPlanDetailCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIImage *topBgImage = [UIImage imageNamed:LCCellTopBg];
    topBgImage = [topBgImage resizableImageWithCapInsets:LCCellTopBgResizeEdge resizingMode:UIImageResizingModeStretch];
    self.topBg.image = topBgImage;
    
    UIImage *bottomImage = [UIImage imageNamed:LCCellBottomBg];
    bottomImage = [bottomImage resizableImageWithCapInsets:LCCellBottomBgResizeEdge resizingMode:UIImageResizingModeStretch];
    self.bottomBg.image = bottomImage;
    
    [self.checkMoreButton addTarget:self action:@selector(checkMoreButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.scrollEnabled = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCPlanCommentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCPlanCommentCell class])];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (CGFloat)getCellHeightOfPlan:(LCPlanModel *)plan{
    CGFloat height = 5;    //cell top
    height += 42; //top part
    height += [LCPlanDetailCommentCell getCommenuNumToShowInPlanDetailViewForPlan:plan] * PlanDetailACommentCellHeight; //comment cells
    height += 44;   //see more button
    height += 2; //bottom shadow
    height += 5; //cell bottom
    
    return height;
}

- (void)setPlan:(LCPlanModel *)plan{
    [super setPlan:plan];
    
    [self updateShow];
}

- (void)updateShow{
    self.commentNumLabel.text = [NSString stringWithFormat:@"%ld",(long)self.plan.commentNumber];
    
    [self.tableView reloadData];
    
    if (self.plan.unreadCommentNum>0) {
        self.unreadCommentView.hidden = NO;
    }else{
        self.unreadCommentView.hidden = YES;
    }
}

- (void)checkMoreButtonAction{
    if ([self.delegate respondsToSelector:@selector(planDetailCommentCellDidClickCheckMore:)]) {
        [self.delegate planDetailCommentCellDidClickCheckMore:self];
    }
}

#pragma mark -
#pragma mark UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  [LCPlanDetailCommentCell getCommenuNumToShowInPlanDetailViewForPlan:self.plan];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LCCommentModel *aComment = [self.plan.commentList objectAtIndex:indexPath.row];
    
    LCPlanCommentCell *aCommentCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCPlanCommentCell class]) forIndexPath:indexPath];
    aCommentCell.comment = aComment;
//    [aCommentCell.avatarImageView setImageWithURL:[NSURL URLWithString:aComment.user.avatarThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultAvatarImageName]];
//    aCommentCell.nameLabel.text = aComment.title;
//    aCommentCell.commentLabel.text = aComment.content;
//    aCommentCell.timeLabel.text = [LCDateUtil getTimeIntervalStringFromDateString:aComment.createdTime];
    
    return aCommentCell;
}
#pragma mark TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return PlanDetailACommentCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(planDetailCommentCell:didClickCommentAtIndex:)]) {
        [self.delegate planDetailCommentCell:self didClickCommentAtIndex:indexPath.row];
    }
}


#pragma mark - InnerFunction
+ (NSInteger)getCommenuNumToShowInPlanDetailViewForPlan:(LCPlanModel *)plan{
    if (plan.commentList) {
        return plan.commentList.count;
    }else{
        return 0;
    }
}

@end
