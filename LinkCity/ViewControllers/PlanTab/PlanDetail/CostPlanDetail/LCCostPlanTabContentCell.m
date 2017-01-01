//
//  LCCostPlanTabContentCell.m
//  LinkCity
//
//  Created by Roy on 12/18/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCCostPlanTabContentCell.h"
#import "LCRouteContentTextCell.h"
#import "LCRouteTitleCell.h"
#import "LCRouteContentTextImageCell.h"
#import "LCUserCommentCell.h"
#import "LCPlanDetailNoCommentCell.h"

@interface LCCostPlanTabContentCell()<LCUserCommentCellDelegate, LCCostPlanDescCellDelegate>
@property (nonatomic, strong) NSMutableArray *routeContentArray;

@property (nonatomic, strong) UILabel *gatherTimeLabel;
@property (nonatomic, strong) UILabel *gatherPlaceLabel;

@end

@implementation LCCostPlanTabContentCell

- (void)awakeFromNib {
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    
    self.tableViewArray = @[self.descTableView, self.routeTableView, self.commentTableView];
    self.tableIsTouchingArray = [[NSMutableArray alloc] init];
    
    for(int i=0; i<self.tableViewArray.count; i++){
        UITableView *table = self.tableViewArray[i];
        
        table.delegate = self;
        table.dataSource = self;
        table.rowHeight = UITableViewAutomaticDimension;
        table.estimatedRowHeight = 100;
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        [table registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        
        [self.tableIsTouchingArray addObject:[NSNumber numberWithBool:NO]];
    }
    
    //Desc TableView
    [self.descTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCCostPlanDescCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCCostPlanDescCell class])];
    
    //Route TableView
    [self.routeTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCRouteTitleCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCRouteTitleCell class])];
    [self.routeTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCRouteContentTextCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCRouteContentTextCell class])];
    [self.routeTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCRouteContentTextImageCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCRouteContentTextImageCell class])];
    
    UIView *routeTableHeaderV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 85)];
    routeTableHeaderV.backgroundColor = [UIColor whiteColor];
    UILabel *gatherTimeLabel = [[UILabel alloc] init];
    gatherTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [routeTableHeaderV addSubview:gatherTimeLabel];
    gatherTimeLabel.textColor = UIColorFromRGBA(0x2c2a28, 1);
    gatherTimeLabel.font = [UIFont fontWithName:FONT_LANTINGBLACK size:14];
    
    UILabel *gatherPlaceLabel = [[UILabel alloc] init];
    gatherPlaceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [routeTableHeaderV addSubview:gatherPlaceLabel];
    gatherPlaceLabel.textColor = UIColorFromRGBA(0x2c2a28, 1);
    gatherPlaceLabel.font = [UIFont fontWithName:FONT_LANTINGBLACK size:14];
    
    [routeTableHeaderV addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[gatherTimeLabel]-(10)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(gatherTimeLabel, gatherPlaceLabel)]];
    [routeTableHeaderV addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[gatherPlaceLabel]-(10)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(gatherTimeLabel, gatherPlaceLabel)]];
    [routeTableHeaderV addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[gatherTimeLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(gatherTimeLabel, gatherPlaceLabel)]];
    [routeTableHeaderV addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[gatherPlaceLabel]-(20)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(gatherTimeLabel, gatherPlaceLabel)]];
    self.routeTableView.tableHeaderView = routeTableHeaderV;
    self.gatherPlaceLabel = gatherPlaceLabel;
    self.gatherTimeLabel = gatherTimeLabel;
    
    //Comment TableView
    [self.commentTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCUserCommentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCUserCommentCell class])];
    [self.commentTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCPlanDetailNoCommentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCPlanDetailNoCommentCell class])];
    
}

- (BOOL)isTouchingTableView:(UITableView *)tableView{
    BOOL ret = NO;
    NSInteger tableIndex = [self.tableViewArray indexOfObject:tableView];
    if (tableIndex >= 0 && tableIndex < self.tableIsTouchingArray.count) {
        ret = [[self.tableIsTouchingArray objectAtIndex:tableIndex] boolValue];
    }
    return ret;
}

- (void)updateShowWithPlan:(LCPlanModel *)plan commentArray:(NSMutableArray *)commentArray{
    self.plan = plan;
    self.commentArray = commentArray;
    
    self.routeContentArray = [[NSMutableArray alloc] init];
    NSInteger lastDay = -1;
    NSInteger curDay = -1;
    for (LCRoutePlaceModel *place in self.plan.userRoute.routePlaces){
        curDay = place.routeDay;
        if (curDay != lastDay) {
            [self.routeContentArray addObject:[NSNumber numberWithInteger:curDay]];
        }
        
        [self.routeContentArray addObject:place];
        lastDay = curDay;
    }
    
    self.gatherTimeLabel.text = [NSString stringWithFormat:@"集合时间：%@",[LCDateUtil getHourAndMinuteStrfromStr:self.plan.gatherTime]];
    self.gatherPlaceLabel.text = [NSString stringWithFormat:@"集合地点：%@",self.plan.gatherPlace];
    
    __block CGPoint preContentOffset = self.descTableView.contentOffset;
    
    for(UITableView *table in self.tableViewArray){
        [table reloadData];
    }
    
    /*
     this is weird
     正常情况下，reloadData后tableview的contentoffset不变
     当设置了 estimatedRowHieght，有可能变
     现在每次reload descTableView后，内容的位置变得很诡异，所以在reload前后手动设置
     */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.descTableView.contentOffset = preContentOffset;
    });
}


#pragma mark UIScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self.delegate respondsToSelector:@selector(costPlanTabContentCell:scrollViewDidScroll:)]) {
        [self.delegate costPlanTabContentCell:self scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([self.delegate respondsToSelector:@selector(costPlanTabContentCell:scrollViewDidEndDecelerating:)]) {
        [self.delegate costPlanTabContentCell:self scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSInteger tableIndex = [self.tableViewArray indexOfObject:scrollView];
    if (tableIndex >= 0 && tableIndex < self.tableIsTouchingArray.count) {
        [self.tableIsTouchingArray replaceObjectAtIndex:tableIndex withObject:[NSNumber numberWithBool:YES]];
        
        if ([self.delegate respondsToSelector:@selector(costPlanTabContentCell:scrollViewWillBeginDrag:)]) {
            [self.delegate costPlanTabContentCell:self scrollViewWillBeginDrag:scrollView];
        }
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    NSInteger tableIndex = [self.tableViewArray indexOfObject:scrollView];
    if (tableIndex >= 0 && tableIndex < self.tableIsTouchingArray.count) {
        [self.tableIsTouchingArray replaceObjectAtIndex:tableIndex withObject:[NSNumber numberWithBool:NO]];
        
        if ([self.delegate respondsToSelector:@selector(costPlanTabContentCell:scrollViewWillEndDrag:)]) {
            [self.delegate costPlanTabContentCell:self scrollViewWillEndDrag:scrollView];
        }
    }
}

#pragma mark UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowNum = 0;
    
    if (tableView == self.descTableView) {
        rowNum = 1;
    }else if(tableView == self.routeTableView) {
        rowNum = self.routeContentArray.count;
    }else if(tableView == self.commentTableView) {
        if (self.commentArray.count > 0) {
            rowNum = self.commentArray.count;
        }else{
            //显示‘暂无评论’的Cell
            rowNum = 1;
        }
    }
    
    return rowNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    
    if (tableView == self.descTableView) {
        LCCostPlanDescCell *descCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCCostPlanDescCell class]) forIndexPath:indexPath];
        [descCell updateShowWithPlan:self.plan];
        descCell.delegate = self;
        descCell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.descCell = descCell;
        
        cell = descCell;
    }else if(tableView == self.routeTableView){
        id obj = [self.routeContentArray objectAtIndex:indexPath.row];
        if ([obj isKindOfClass:[NSNumber class]]) {
            // route title cell
            NSInteger day = [(NSNumber *)obj integerValue];
            
            LCRouteTitleCell *titleCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCRouteTitleCell class]) forIndexPath:indexPath];
            titleCell.dayNumLabel.text = [NSString stringWithFormat:@"DAY%ld",(long)day];
            titleCell.placesLabel.text = [self.plan.userRoute getRoutePlaceStringForDay:day withSeparator:@"-"];
            
            cell = titleCell;
        }else{
            // route place cell
            LCRoutePlaceModel *placeModel = (LCRoutePlaceModel *)obj;
            
            if ([LCStringUtil isNullString:placeModel.placeCoverUrl]) {
                // content text cell
                LCRouteContentTextCell *textCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCRouteContentTextCell class]) forIndexPath:indexPath];
                textCell.contentLabel.text = [LCStringUtil getNotNullStr:placeModel.descriptionStr];
                
                cell = textCell;
            }else{
                // content text and image cell
                LCRouteContentTextImageCell *textAndImageCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCRouteContentTextImageCell class]) forIndexPath:indexPath];
                textAndImageCell.contentLabel.text = [LCStringUtil getNotNullStr:placeModel.descriptionStr];
                [textAndImageCell.imgBtn setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:placeModel.placeCoverUrl] placeholderImage:nil];
                
                cell = textAndImageCell;
            }
        }
    }else if(tableView == self.commentTableView){
        if (self.commentArray.count > 0) {
            LCUserCommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCUserCommentCell class]) forIndexPath:indexPath];
            commentCell.delegate = self;
            LCCommentModel *comment = [self.commentArray objectAtIndex:indexPath.row];
            [commentCell updateShowComment:comment];
            cell = commentCell;
        }else{
            LCPlanDetailNoCommentCell *noCommentCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCPlanDetailNoCommentCell class]) forIndexPath:indexPath];
            cell = noCommentCell;
        }
    }
    
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.descTableView) {
        
    }else if(tableView == self.routeTableView) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([cell isKindOfClass:[LCRouteTitleCell class]] ||
            [cell isKindOfClass:[LCRouteContentTextCell class]]) {
            //is route title cell,
            //or route text cell
            //do nothing
        }else{
            NSMutableArray *imageModels = [[NSMutableArray alloc] initWithCapacity:0];
            id obj = [self.routeContentArray objectAtIndex:indexPath.row];
            LCRoutePlaceModel *selectedPlace = (LCRoutePlaceModel *)obj;
            NSInteger selectedImageIndex = 0;
            
            if ([obj isKindOfClass:[LCRoutePlaceModel class]]) {
                for (LCRoutePlaceModel *aPlace in self.plan.userRoute.routePlaces){
                    if ([LCStringUtil isNotNullString:aPlace.placeCoverUrl]) {
                        LCImageModel *imageModel = [[LCImageModel alloc] init];
                        imageModel.imageUrl = aPlace.placeCoverUrl;
                        imageModel.imageUrlThumb = aPlace.placeCoverThumbUrl;
                        [imageModels addObject:imageModel];
                        
                        if ([aPlace.placeCoverUrl isEqualToString:selectedPlace.placeCoverUrl]) {
                            selectedImageIndex = imageModels.count - 1;
                        }
                    }
                }
            }
            
            if (selectedImageIndex >= 0 && selectedImageIndex < imageModels.count) {
                LCPhotoScanner *photoScanner = [LCPhotoScanner createInstance];
                [photoScanner showImageModels:imageModels fromIndex:selectedImageIndex];
                [[LCSharedFuncUtil getTopMostViewController].navigationController presentViewController:photoScanner animated:YES completion:nil];
            }
        }
    }else if(tableView == self.commentTableView) {
        if (self.commentArray.count > 0) {
            LCCommentModel *comment = [self.commentArray objectAtIndex:indexPath.row];
            if ([self.delegate respondsToSelector:@selector(costPlanTabContentCell:didClickComment:)]) {
                [self.delegate costPlanTabContentCell:self didClickComment:comment];
            }
        }
    }
}

#pragma mark UITableView Edit - remove cell
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    /// 如果评论是自己发的，可以删除.
    if (tableView == self.commentTableView &&
        self.commentArray.count > 0) {
//        LCCommentModel *aComment = [self.commentArray objectAtIndex:indexPath.row];
//        if ([aComment.user.uUID isEqualToString:[LCDataManager sharedInstance].userInfo.uUID]) {
            return YES;
//        }
    }
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.commentTableView &&
        self.commentArray.count > 0 &&
        editingStyle == UITableViewCellEditingStyleDelete) {
        
        /// 删除评论.
        LCCommentModel *aComment = [self.commentArray objectAtIndex:indexPath.row];
        [LCNetRequester deleteCommentOfPlanWithCommentID:aComment.commentId callBack:^(NSError *error) {
            if (error) {
                [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
            }else{
                [self.commentArray removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            
            [tableView reloadData];
        }];
    }
}

#pragma mark LCCostPlanDescCell Delegate
- (void)costPlanDescCell:(LCCostPlanDescCell *)cell didClickStage:(LCPartnerStageModel *)stage{
    if ([self.delegate respondsToSelector:@selector(costPlanTabContentCell:didClickStage:)]) {
        [self.delegate costPlanTabContentCell:self didClickStage:stage];
    }
}

#pragma mark LCUserCommentCell Delegate
- (void)userCommentToViewUserDetail:(LCUserModel *)user {
    [LCViewSwitcher pushToShowUserInfoVCForUser:user on:[LCSharedFuncUtil getTopMostViewController].navigationController];
}

#pragma mark 
- (void)addCommentTableFooterRefresh{
    [self.commentTableView addFooterWithCallback:^{
        if ([self.delegate respondsToSelector:@selector(costPlanTabContentCellCommentTableViewFooterRefreshAction:)]) {
            [self.delegate costPlanTabContentCellCommentTableViewFooterRefreshAction:self];
        }
    }];
}
- (void)removeCommentTableFooterRefresh{
    [self.commentTableView removeFooter];
}


@end
