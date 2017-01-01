//
//  LCCostPlanTabContentCell.h
//  LinkCity
//
//  Created by Roy on 12/18/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCCostPlanDescCell.h"

@protocol LCCostPlanTabContentCellDelegate;
@interface LCCostPlanTabContentCell : UITableViewCell<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) LCPlanModel *plan;
@property (nonatomic, strong) NSMutableArray *commentArray;

@property (nonatomic, weak) id<LCCostPlanTabContentCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) NSArray *tableViewArray;
@property (nonatomic, strong) NSMutableArray *tableIsTouchingArray;

@property (weak, nonatomic) IBOutlet UITableView *descTableView;
@property (nonatomic, strong) LCCostPlanDescCell *descCell;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descTableViewBottom;

@property (weak, nonatomic) IBOutlet UITableView *routeTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *routeTableViewBottom;
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentTableViewBottom;

- (BOOL)isTouchingTableView:(UITableView *)tableView;
- (void)updateShowWithPlan:(LCPlanModel *)plan commentArray:(NSMutableArray *)commentArray;

- (void)addCommentTableFooterRefresh;
- (void)removeCommentTableFooterRefresh;
@end


@protocol LCCostPlanTabContentCellDelegate <NSObject>

- (void)costPlanTabContentCell:(LCCostPlanTabContentCell *)cell scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
- (void)costPlanTabContentCell:(LCCostPlanTabContentCell *)cell scrollViewWillBeginDrag:(UIScrollView *)scrollView;
- (void)costPlanTabContentCell:(LCCostPlanTabContentCell *)cell scrollViewWillEndDrag:(UIScrollView *)scrollView;
- (void)costPlanTabContentCell:(LCCostPlanTabContentCell *)cell scrollViewDidScroll:(UIScrollView *)scrollView;

- (void)costPlanTabContentCellCommentTableViewFooterRefreshAction:(LCCostPlanTabContentCell *)cell;
- (void)costPlanTabContentCell:(LCCostPlanTabContentCell *)cell didClickComment:(LCCommentModel *)comment;

- (void)costPlanTabContentCell:(LCCostPlanTabContentCell *)cell didClickStage:(LCPartnerStageModel *)stage;

@end
