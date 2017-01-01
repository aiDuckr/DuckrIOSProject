//
//  LCUserRouteListVC.m
//  LinkCity
//
//  Created by roy on 3/13/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCUserRouteListVC.h"
#import "LCUserInfoUserRouteCell.h"
#import "LCUserRouteDetailVC.h"
#import "LCPlanRouteEditVC.h"
#import "MJRefresh.h"

@interface LCUserRouteListVC ()<UITableViewDataSource,UITableViewDelegate,LCPlanRouteEditVCDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *userRoutes;  // array of LCUserRouteModel
@end

@implementation LCUserRouteListVC

+ (instancetype)createInstance{
    return (LCUserRouteListVC *)[LCStoryboardManager viewControllerWithFileName:SBNameUserTab identifier:VCIDUserRouteListVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addObserveToNotificationNameToRefreshData:URL_SEND_ROUTE];
    [self addObserveToNotificationNameToRefreshData:URL_DELETE_ROUTE];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCUserInfoUserRouteCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCUserInfoUserRouteCell class])];
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
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

- (void)updateShow{
    [self.tableView reloadData];
}


#pragma mark ButtonAction
- (void)addRouteBarButtonAction{
    [LCViewSwitcher pushToShowRouteEditVCForRoute:nil editType:LCRouteEditType_ForAddRoute delegate:self on:self.navigationController];
}

- (void)headerRereshing{
    LCUserModel *curUser = [LCDataManager sharedInstance].userInfo;
    if (curUser && [LCStringUtil isNotNullString:curUser.uUID]) {
        [LCNetRequester getUserService:curUser.uUID callBack:^(LCCarIdentityModel *carIdentity, NSMutableArray *userRoutes, NSError *error) {
            [self.tableView headerEndRefreshing];
            if (error) {
                LCLogWarn(@"getUserService error:%@",error);
            }else{
                self.userRoutes = userRoutes;
                [self updateShow];
            }
        }];
    }
}
#pragma mark UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowNum = 0;
    if (self.userRoutes) {
        rowNum = self.userRoutes.count;
    }
    return rowNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LCUserRouteModel *userRoute = [self.userRoutes objectAtIndex:indexPath.row];
    LCUserInfoUserRouteCell *routeCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCUserInfoUserRouteCell class]) forIndexPath:indexPath];
    routeCell.userRoute = userRoute;
    return routeCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    height = [LCUserInfoUserRouteCell getCellHeightForUserRoute:[self.userRoutes objectAtIndex:indexPath.row]];
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LCUserRouteModel *userRoute = [self.userRoutes objectAtIndex:indexPath.row];
    [LCViewSwitcher pushToShowRouteDetailVCForRoute:userRoute routeOwner:[LCDataManager sharedInstance].userInfo editable:YES showDayIndex:0 on:self.navigationController];
}


#pragma mark - LCPlanRouteEditVC Delegate
- (void)planRouteEditVCDidCancel:(LCPlanRouteEditVC *)routeEditVC{
    
}
- (void)planRouteEditVC:(LCPlanRouteEditVC *)routeEditVC didSaveUserRoute:(LCUserRouteModel *)userRoute{
    
}

@end
