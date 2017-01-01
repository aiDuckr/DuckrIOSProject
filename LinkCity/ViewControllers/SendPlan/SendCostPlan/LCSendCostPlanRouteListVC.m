//
//  LCSendCostPlanRouteListVC.m
//  LinkCity
//
//  Created by Roy on 12/16/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCSendCostPlanRouteListVC.h"
#import "LCPickRouteCell.h"

@interface LCSendCostPlanRouteListVC ()<UITableViewDataSource, UITableViewDelegate, LCPickRouteCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *routeArray;
@property (nonatomic, strong) NSMutableDictionary *routeSelection;
@property (nonatomic, strong) NSString *routeOrderStr;
@end

@implementation LCSendCostPlanRouteListVC

+ (instancetype)createInstance{
    return (LCSendCostPlanRouteListVC *)[LCStoryboardManager viewControllerWithFileName:SBNameSendPlan identifier:NSStringFromClass([LCSendCostPlanRouteListVC class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"路线";

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 40;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCPickRouteCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCPickRouteCell class])];
    [self.tableView addHeaderWithTarget:self action:@selector(tableViewHeaderAction)];
    [self.tableView addFooterWithTarget:self action:@selector(tableViewFooterAction)];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:NO];
    [self.tabBarController.tabBar setHidden:YES];
    
    [self updateShow];
}

- (void)updateShow{
    [self.tableView reloadData];
}

- (void)refreshData{
    [self.tableView headerBeginRefreshing];
}

- (void)setCurPlan:(LCPlanModel *)curPlan{
    [super setCurPlan:curPlan];
    
    [self setSelection:YES forRouteId:self.curPlan.userRouteId];
}

#pragma mark MJRefresh
- (void)tableViewHeaderAction{
    self.routeOrderStr = nil;
    [self requestRouteArray];
}
- (void)tableViewFooterAction{
    [self requestRouteArray];
}

- (void)requestRouteArray{
    [LCNetRequester getRouteForSendPlan:self.curPlan.departName
                              destNames:self.curPlan.destinationNames
                              startTime:[self.curPlan getFirstStageStartTime]
                                endTime:[self.curPlan getFirstStageEndTime]
                               daysLong:self.curPlan.daysLong
                               orderStr:self.routeOrderStr
                               callBack:^(NSArray *userRoutes, NSString *orderStr, NSError *error)
     {
         
         [self.tableView headerEndRefreshing];
         [self.tableView footerEndRefreshing];
         
         if (error) {
             [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipDefaultDelay];
         }else{
             if ([LCStringUtil isNullString:self.routeOrderStr]) {
                 // pull down
                 self.routeArray = [NSMutableArray arrayWithArray:userRoutes];
             }else{
                 // pull up
                 if (!userRoutes || userRoutes.count <= 0) {
                     [YSAlertUtil tipOneMessage:LCFooterRefreshEmptyTip yoffset:TipDefaultYoffset delay:TipDefaultDelay];
                 }else{
                     [self.routeArray addObjectsFromArray:userRoutes];
                 }
             }
             
             self.routeOrderStr = orderStr;
             [self updateShow];
         }
         
     }];
}

#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.routeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LCUserRouteModel *route = [self.routeArray objectAtIndex:indexPath.row];
    LCPickRouteCell *routeCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCPickRouteCell class]) forIndexPath:indexPath];
    routeCell.delegate = self;
    [routeCell updateShowWithRoute:route selected:[self getSelectionOfRouteId:route.userRouteId]];
    
    routeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return routeCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LCUserRouteModel *route = [self.routeArray objectAtIndex:indexPath.row];
    [LCViewSwitcher pushToShowRouteDetailVCForRoute:route routeOwner:[LCDataManager sharedInstance].userInfo editable:NO showDayIndex:0 on:self.navigationController callBack:^(BOOL choose) {
        
        LCPickRouteCell *choosedCell = [tableView cellForRowAtIndexPath:indexPath];
        [self pickRouteCellDidClickSelect:choosedCell];
    }];
}

#pragma mark LCPickRouteCell Delegate
- (void)pickRouteCellDidClickSelect:(LCPickRouteCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    LCUserRouteModel *route = [self.routeArray objectAtIndex:indexPath.row];
    
    for (NSString *key in [self.routeSelection allKeys]) {
        [self.routeSelection setObject:[NSNumber numberWithBool:NO] forKey:key];
    }
    
    [self setSelection:YES forRouteId:route.userRouteId];
    self.curPlan.userRouteId = route.userRouteId;
    self.curPlan.userRoute = route;
    
    [self updateShow];
}


#pragma mark Selection
- (BOOL)getSelectionOfRouteId:(NSInteger)routeId{

    NSNumber *selection = [self.routeSelection objectForKey:[[NSNumber numberWithInteger:routeId] stringValue]];
    if (!selection || ![selection boolValue]) {
        return NO;
    }else{
        return YES;
    }
}

- (void)setSelection:(BOOL)selection forRouteId:(NSInteger)routeId{
    if (!self.routeSelection) {
        self.routeSelection = [[NSMutableDictionary alloc] init];
    }
    
    [self.routeSelection setObject:[NSNumber numberWithBool:selection] forKey:[[NSNumber numberWithInteger:routeId] stringValue]];
}



@end
