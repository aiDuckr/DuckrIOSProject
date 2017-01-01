//
//  LCUserPlanHelperVC.m
//  LinkCity
//
//  Created by Roy on 8/30/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCUserPlanHelperVC.h"
#import "LCYellowSectionHeaderCell.h"
#import "LCHomeVCPlanCell.h"

typedef enum : NSUInteger {
    LCUserPlanHelperCellType_SectionByJoinedPlan,
    LCUserPlanHelperCellType_PlanByJoined,
    LCUserPlanHelperCellType_SectionByWantGoPlan,
    LCUserPlanHelperCellType_PlanByWantGo,
} LCUserPlanHelperCellType;

@interface LCUserPlanHelperVC ()<UITableViewDataSource,UITableViewDelegate>
//UI
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//Data
@property (nonatomic, strong) NSArray *byJoinedPlanList;
@property (nonatomic, strong) NSArray *byWantGoPlanList;
@end

@implementation LCUserPlanHelperVC

+ (instancetype)createInstance{
    return (LCUserPlanHelperVC *)[LCStoryboardManager viewControllerWithFileName:SBNameUserTab identifier:NSStringFromClass([LCUserPlanHelperVC class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"邀约助手";
    self.view.backgroundColor = UIColorFromRGBA(LCViewBackGroundColor, 1);
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView addHeaderWithTarget:self action:@selector(planTableHeaderRereshing) dateKey:@"table"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCHomeVCPlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCHomeVCPlanCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCYellowSectionHeaderCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCYellowSectionHeaderCell class])];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
    [self updateShow];
}

- (void)refreshData{
    [self.tableView headerBeginRefreshing];
}

- (void)planTableHeaderRereshing{
    [LCNetRequester getUserPlanHelperListWithCallBack:^(NSArray *byJoinePlanList, NSArray *byWantGoPlanList, NSError *error) {
        [self.tableView headerEndRefreshing];
        
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain];
        }else{
            self.byJoinedPlanList = byJoinePlanList;
            self.byWantGoPlanList = byWantGoPlanList;
            [self updateShow];
        }
    }];
}

- (void)updateShow{
    [self updateCellIndex];
    [self.tableView reloadData];
    
    if (cellNum <= 0) {
        [self.tableView showBlankViewWithImageName:BlankContentImageA title:@"暂时没有推荐的邀约\r\n去完善个人信息，或者发布新的邀约吧" marginTop:BlankContentMarginTop];
    }else{
        [self.tableView hideBlankView];
    }
}

#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return cellNum;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    
    switch ([self getCellTypeByIndexPath:indexPath]) {
        case LCUserPlanHelperCellType_SectionByJoinedPlan:{
            LCYellowSectionHeaderCell *headerCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCYellowSectionHeaderCell class]) forIndexPath:indexPath];
            headerCell.contentView.backgroundColor = [UIColor clearColor];
            headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
            headerCell.yellowLineTop.constant = 15;
            headerCell.titleLabel.text = @"根据您参加的邀约推荐";
            headerCell.titleLabel.hidden = NO;
            headerCell.subTitleLabel.hidden = YES;
            headerCell.seeAllView.hidden = YES;
            cell = headerCell;
        }
            break;
        case LCUserPlanHelperCellType_SectionByWantGoPlan:{
            LCYellowSectionHeaderCell *headerCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCYellowSectionHeaderCell class]) forIndexPath:indexPath];
            headerCell.contentView.backgroundColor = [UIColor clearColor];
            headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
            headerCell.yellowLineTop.constant = 15;
            headerCell.titleLabel.text = @"根据您想去的地方推荐";
            headerCell.titleLabel.hidden = NO;
            headerCell.subTitleLabel.hidden = YES;
            headerCell.seeAllView.hidden = YES;
            cell = headerCell;
        }
            break;
        case LCUserPlanHelperCellType_PlanByJoined:
        case LCUserPlanHelperCellType_PlanByWantGo:{
            LCHomeVCPlanCell *planCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCHomeVCPlanCell class]) forIndexPath:indexPath];
            planCell.plan = [self getPlanByIndexPath:indexPath];
            cell = planCell;
        }
            break;
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight = 0;
    
    switch ([self getCellTypeByIndexPath:indexPath]) {
        case LCUserPlanHelperCellType_SectionByJoinedPlan:
        case LCUserPlanHelperCellType_SectionByWantGoPlan:{
            rowHeight = YellowHeaderCellHeight-15;
        }
            break;
        case LCUserPlanHelperCellType_PlanByJoined:
        case LCUserPlanHelperCellType_PlanByWantGo:{
            rowHeight = [LCHomeVCPlanCell getCellHightForPlan:[self getPlanByIndexPath:indexPath]];
        }
            break;
    }
    
    return rowHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LCPlanModel *plan = [self getPlanByIndexPath:indexPath];
    [LCViewSwitcher pushToShowPlanDetailVCForPlan:plan recmdUuid:nil on:self.navigationController];
}

#pragma mark Caculate
static NSInteger cellNum = 0;
static NSInteger byJoinedPlanListSectionIndex = 0;
static NSInteger byWantGoPlanListSectionIndex = 0;

- (void)updateCellIndex{
    cellNum = 0;
    
    if (self.byJoinedPlanList.count > 0) {
        byJoinedPlanListSectionIndex = cellNum;
        cellNum += 1 + self.byJoinedPlanList.count;
    }else{
        byJoinedPlanListSectionIndex = -1;
    }
    
    if (self.byWantGoPlanList.count > 0) {
        byWantGoPlanListSectionIndex = cellNum;
        cellNum += 1 + self.byWantGoPlanList.count;
    }else{
        byWantGoPlanListSectionIndex = -1;
    }
}

- (LCUserPlanHelperCellType)getCellTypeByIndexPath:(NSIndexPath *)indexPath{
    LCUserPlanHelperCellType cellType = 0;
    NSInteger row = indexPath.row;
    
    if (self.byJoinedPlanList.count > 0) {
        if (row == byJoinedPlanListSectionIndex) {
            cellType = LCUserPlanHelperCellType_SectionByJoinedPlan;
        }else if(row > byJoinedPlanListSectionIndex && row <= byJoinedPlanListSectionIndex + self.byJoinedPlanList.count){
            cellType = LCUserPlanHelperCellType_PlanByJoined;
        }
    }
    
    if (self.byWantGoPlanList.count > 0) {
        if (row == byWantGoPlanListSectionIndex) {
            cellType = LCUserPlanHelperCellType_SectionByWantGoPlan;
        }else if(row > byWantGoPlanListSectionIndex && row <= byWantGoPlanListSectionIndex + self.byWantGoPlanList.count){
            cellType = LCUserPlanHelperCellType_PlanByWantGo;
        }
    }
    
    return cellType;
}

- (LCPlanModel *)getPlanByIndexPath:(NSIndexPath *)indexPath{
    LCPlanModel *plan = nil;
    LCUserPlanHelperCellType cellType = [self getCellTypeByIndexPath:indexPath];
    
    if (cellType == LCUserPlanHelperCellType_PlanByJoined) {
        NSInteger planIndex = indexPath.row - byJoinedPlanListSectionIndex - 1;
        plan = [self.byJoinedPlanList objectAtIndex:planIndex];
    }else if(cellType == LCUserPlanHelperCellType_PlanByWantGo) {
        NSInteger planIndex = indexPath.row - byWantGoPlanListSectionIndex - 1;
        plan = [self.byWantGoPlanList objectAtIndex:planIndex];
    }
    
    return plan;
}



@end
