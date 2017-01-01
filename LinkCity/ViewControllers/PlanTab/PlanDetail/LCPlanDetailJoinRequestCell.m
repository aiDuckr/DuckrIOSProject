//
//  LCPlanDetailJoinRequestCell.m
//  LinkCity
//
//  Created by roy on 2/16/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCPlanDetailJoinRequestCell.h"
#import "LCPlanDetailAJoinRequestCell.h"


@interface LCPlanDetailJoinRequestCell()<UITableViewDataSource,UITableViewDelegate,LCPlanDetailAJoinRequestCellDelegate>

@end

static const CGFloat PlanDetailAJoinRequestCellHeight = 60;
static NSString *const reuseID_AJoinRequestCell = @"PlanDetailAJoinRequestCell";
@implementation LCPlanDetailJoinRequestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIImage *topBgImage = [UIImage imageNamed:LCCellTopBg];
    topBgImage = [topBgImage resizableImageWithCapInsets:LCCellTopBgResizeEdge resizingMode:UIImageResizingModeStretch];
    self.topBg.image = topBgImage;
    
    UIImage *bottomImage = [UIImage imageNamed:LCCellBottomBg];
    bottomImage = [bottomImage resizableImageWithCapInsets:LCCellBottomBgResizeEdge resizingMode:UIImageResizingModeStretch];
    self.bottomBg.image = bottomImage;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

+ (CGFloat)getCellHeightOfPlan:(LCPlanModel *)plan{
    CGFloat height = 5;    //cell top
    height += 44; //top part
    height += [LCPlanDetailJoinRequestCell getRequestNumOfPlan:plan] * PlanDetailAJoinRequestCellHeight; //comment cells
    height += 2; //bottom shadow
    height += 5; //cell bottom
    
    return height;
}



#pragma mark -
#pragma mark UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  [LCPlanDetailJoinRequestCell getRequestNumOfPlan:self.plan];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LCPlanDetailAJoinRequestCell *aJoinRequestCell = [tableView dequeueReusableCellWithIdentifier:reuseID_AJoinRequestCell forIndexPath:indexPath];
    aJoinRequestCell.delegate = self;
    
    LCUserModel *requester = [self.plan.applyingList objectAtIndex:indexPath.row];
    [aJoinRequestCell.requesterAvatar setImageWithURL:[NSURL URLWithString:requester.avatarThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultAvatarImageName]];
    aJoinRequestCell.requesterNameLabel.text = requester.nick;
    
    if (indexPath.row+1 == [LCPlanDetailJoinRequestCell getRequestNumOfPlan:self.plan]) {
        //is the last row
        aJoinRequestCell.bottomLine.hidden = YES;
    }else{
        //is not the last row
        aJoinRequestCell.bottomLine.hidden = NO;
    }
    
    return aJoinRequestCell;
}
#pragma mark TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return PlanDetailAJoinRequestCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(planDetailJoinRequestCell:didClickSeeDetailButtonAtIndex:)]) {
        [self.delegate planDetailJoinRequestCell:self didClickSeeDetailButtonAtIndex:indexPath.row];
    }
}

#pragma mark LCPlanDetailAJoinRequestCell
- (void)planDetailAJoinRequestCellDidAgree:(LCPlanDetailAJoinRequestCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if ([self.delegate respondsToSelector:@selector(planDetailJoinRequestCell:didClickApproveButtonAtIndex:)]) {
        [self.delegate planDetailJoinRequestCell:self didClickApproveButtonAtIndex:indexPath.row];
    }
}
- (void)planDetailAJoinRequestCellDidIgnore:(LCPlanDetailAJoinRequestCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if ([self.delegate respondsToSelector:@selector(planDetailJoinRequestCell:didClickRefuseButtonAtIndex:)]) {
        [self.delegate planDetailJoinRequestCell:self didClickRefuseButtonAtIndex:indexPath.row];
    }
}

#pragma mark InnerFunction
+ (NSInteger)getRequestNumOfPlan:(LCPlanModel *)plan{
    if (plan.applyingList && plan.applyingList.count>0) {
        return plan.applyingList.count;
    }else{
        return 0;
    }
}

@end
