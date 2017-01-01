//
//  LCHomeRecmdUserVC.m
//  LinkCity
//
//  Created by Roy on 6/19/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCHomeRecmdUserVC.h"
#import "LCNearbyUserFilterView.h"
#import "LCUserTableViewCell.h"
#import "LCUserTableViewCellHelper.h"
#import "LCNearbyUserCell.h"

@interface LCHomeRecmdUserVC ()<UITableViewDataSource,UITableViewDelegate,LCNearbyUserFilterViewDelegate,LCTabViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *tabBarView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) KLCPopup *userFilterPopup;
//@property (nonatomic, strong) LCNearbyUserFilterView *userFilterView;

@property (nonatomic, strong) NSMutableArray *recmdUserArray;
@property (nonatomic, strong) NSString *recmdUserOrderStr;
@property (nonatomic, strong) NSMutableArray *nearbyUserArray;
@property (nonatomic, assign) LCUserFilterType recmdUserFilterType;
@property (nonatomic, assign) LCUserFilterType nearbyUserFilterType;

@property (nonatomic, assign) BOOL haveDidNetRequest;

@end

@implementation LCHomeRecmdUserVC

+ (instancetype)createInstance{
    return (LCHomeRecmdUserVC *)[LCStoryboardManager viewControllerWithFileName:SBNamePlanTab identifier:VCIDHomeRecmdUserVC];
}

- (void)commonInit{
    [super commonInit];
    
    self.showingTab = LCHomeRecmdUserVCTab_Nearby;
    self.haveDidNetRequest = NO;
}

#pragma mark Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGBA(LCViewBackGroundColor, 1);
    
    LCTabView *tabView = [LCTabView createInstance];
    tabView.frame = CGRectMake(0, 0, DEVICE_WIDTH, LCTabViewHeight);
    tabView.delegate = self;
    tabView.selectIndex = 0;
    [tabView updateButtons:@[@"附近",@"热门"] withMargin:0];
    [self.tabBarView addSubview:tabView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView addHeaderWithTarget:self action:@selector(tableHeaderRefresh)];
    [self.tableView addFooterWithTarget:self action:@selector(tableFooterRefresh)];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCNearbyUserCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCNearbyUserCell class])];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
    [self updateShow];
}

- (void)updateShow{
    self.title = @"推荐达客";
    [self.tableView reloadData];
    
    switch (self.showingTab) {
        case LCHomeRecmdUserVCTab_Recmd:
            if (self.haveDidNetRequest && self.recmdUserArray.count <= 0) {
                [self.tableView showBlankViewWithImageName:BlankContentImageA title:@"还没有达客在附近出没，\r\n快去邀请身边的小伙伴加入吧!" marginTop:BlankContentMarginTop];
            }else{
                [self.tableView hideBlankView];
            }
            break;
        case LCHomeRecmdUserVCTab_Nearby:
            if (self.haveDidNetRequest && self.nearbyUserArray.count <= 0) {
                [self.tableView showBlankViewWithImageName:BlankContentImageA title:@"还没有达客在附近出没，\r\n快去邀请身边的小伙伴加入吧!" marginTop:BlankContentMarginTop];
            }else{
                [self.tableView hideBlankView];
            }
            break;
    }
}

- (void)refreshData{
    [self.tableView headerBeginRefreshing];
    [self requestRecmdUserWithOrderStr:nil];
}

#pragma mark Button Action
- (IBAction)filterButtonAction:(id)sender {
    [self showUserFilterView];
}

- (void)showUserFilterView{
    static CGFloat centerY = 0;
    if (!self.userFilterPopup) {
        LCNearbyUserFilterView *userFilterView = [LCNearbyUserFilterView createInstance];
        userFilterView.delegate = self;
        self.userFilterPopup = [KLCPopup popupWithContentView:userFilterView
                                                     showType:KLCPopupShowTypeSlideInFromBottom
                                                  dismissType:KLCPopupDismissTypeSlideOutToBottom
                                                     maskType:KLCPopupMaskTypeDimmed
                                     dismissOnBackgroundTouch:YES
                                        dismissOnContentTouch:NO];
        centerY = DEVICE_HEIGHT - [userFilterView intrinsicContentSize].height/2;
    }
    
    [self.userFilterPopup showAtCenter:CGPointMake(DEVICE_WIDTH/2, centerY) inView:nil];
}

#pragma mark Net Request
- (void)requestRecmdUserWithOrderStr:(NSString *)orderStr{
    self.recmdUserOrderStr = orderStr;
    
    LCUserLocation *location = nil;
    if ([[LCDataManager sharedInstance].userLocation isUserLocationValid]) {
        location = [LCDataManager sharedInstance].userLocation;
    }
    NSString *locName = @"";
    if (nil != [LCDataManager sharedInstance].currentCity) {
        locName = [LCDataManager sharedInstance].currentCity.cityName;
    }
    [LCNetRequester getHomePageRecmdUserByLocation:location
                                           locName:locName
                                        filterType:self.recmdUserFilterType
                                       orderString:self.recmdUserOrderStr
                                          callBack:^(NSArray *userArray, NSString *orderStr, NSError *error)
     {
         [self.tableView headerEndRefreshing];
         [self.tableView footerEndRefreshing];
         
         if (error) {
             [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
         }else{
             if ([LCStringUtil isNullString:self.recmdUserOrderStr]) {
                 //header refresh
                 self.recmdUserArray = [NSMutableArray arrayWithArray:userArray];
             }else{
                 //footer refresh
                 if (!userArray || userArray.count<=0) {
                     [YSAlertUtil tipOneMessage:LCFooterRefreshEmptyTip yoffset:TipDefaultYoffset delay:TipDefaultDelay];
                 }else{
                     if (!self.recmdUserArray) {
                         self.recmdUserArray = [[NSMutableArray alloc] init];
                     }
                     [self.recmdUserArray addObjectsFromArray:userArray];
                 }
             }
             
             self.recmdUserOrderStr = orderStr;
             [self updateShow];
         }
     }];
}
- (void)requestNearbyUserWithSkipNum:(NSInteger)skip{
    LCUserLocation *location = nil;
    if ([[LCDataManager sharedInstance].userLocation isUserLocationValid]) {
        location = [LCDataManager sharedInstance].userLocation;
    }
    NSString *locName = @"";
    if (nil != [LCDataManager sharedInstance].currentCity) {
        locName = [LCDataManager sharedInstance].currentCity.cityName;
    }
    [LCNetRequester getNearbyDuckrByLocation:location
                                        skip:skip
                                  filterType:self.nearbyUserFilterType
                                     locName:locName callBack:^(NSArray *duckrArray, NSError *error)
     {
         [self.tableView headerEndRefreshing];
         [self.tableView footerEndRefreshing];
         
         self.haveDidNetRequest = YES;
         
         if (error) {
             [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
         }else{
             if (skip == 0) {
                 //header refresh
                 self.nearbyUserArray = [NSMutableArray arrayWithArray:duckrArray];
             }else{
                 //footer refresh
                 if (!duckrArray || duckrArray.count<=0) {
                     [YSAlertUtil tipOneMessage:LCFooterRefreshEmptyTip yoffset:TipDefaultYoffset delay:TipDefaultDelay];
                 }else{
                     if (!self.nearbyUserArray) {
                         self.nearbyUserArray = [[NSMutableArray alloc] init];
                     }
                     [self.nearbyUserArray addObjectsFromArray:duckrArray];
                 }
             }
             
             [self distinctNearbyUserArray];
             [self updateShow];
         }
     }];
}

- (void)distinctNearbyUserArray{
    NSMutableArray *distinctUserArray = [[NSMutableArray alloc] init];
    
    for (LCUserModel *aUser in self.nearbyUserArray){
        if (![[distinctUserArray valueForKey:@"uUID"] containsObject:aUser.uUID]) {
            [distinctUserArray addObject:aUser];
        }
    }
    
    self.nearbyUserArray = distinctUserArray;
}

#pragma mark Tab View Delegate
- (void)tabView:(LCTabView *)tabView didSelectIndex:(NSInteger)index{
    if (index == 0) {
        self.showingTab = LCHomeRecmdUserVCTab_Nearby;
    }else if(index == 1){
        self.showingTab = LCHomeRecmdUserVCTab_Recmd;
    }
    
    [self updateShow];
}
#pragma mark TableView
- (void)tableHeaderRefresh{
    switch (self.showingTab) {
        case LCHomeRecmdUserVCTab_Recmd:
            [self requestRecmdUserWithOrderStr:nil];
            break;
        case LCHomeRecmdUserVCTab_Nearby:
            [self requestNearbyUserWithSkipNum:0];
            break;
    }
}
- (void)tableFooterRefresh{
    switch (self.showingTab) {
        case LCHomeRecmdUserVCTab_Recmd:
            [self requestRecmdUserWithOrderStr:self.recmdUserOrderStr];
            break;
        case LCHomeRecmdUserVCTab_Nearby:
            [self requestNearbyUserWithSkipNum:self.nearbyUserArray.count];
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowNum = 0;
    
    switch (self.showingTab) {
        case LCHomeRecmdUserVCTab_Recmd:{
            rowNum = self.recmdUserArray.count;
        }
            break;
        case LCHomeRecmdUserVCTab_Nearby:{
            rowNum = self.nearbyUserArray.count;
        }
            break;
    }
    
    return rowNum;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    
    LCUserModel *user = nil;
    switch (self.showingTab) {
        case LCHomeRecmdUserVCTab_Recmd:{
            user = [self.recmdUserArray objectAtIndex:indexPath.row];
        }
            break;
        case LCHomeRecmdUserVCTab_Nearby:{
            user = [self.nearbyUserArray objectAtIndex:indexPath.row];
        }
            break;
    }
    
    LCNearbyUserCell *userCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCNearbyUserCell class]) forIndexPath:indexPath];
    userCell.user = user;
    cell = userCell;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [LCNearbyUserCell getCellHeight];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LCUserModel *user = nil;
    switch (self.showingTab) {
        case LCHomeRecmdUserVCTab_Recmd:{
            user = [self.recmdUserArray objectAtIndex:indexPath.row];
        }
            break;
        case LCHomeRecmdUserVCTab_Nearby:{
            user = [self.nearbyUserArray objectAtIndex:indexPath.row];
        }
            break;
    }
    
    [LCViewSwitcher pushToShowUserInfoVCForUser:user on:self.navigationController];
}

#pragma mark LCNearbyUserFilterViewDelegate
- (void)nearbyUserFilterViewDidFiltCancel:(LCNearbyUserFilterView *)userFilterView{
    [self.userFilterPopup dismissPresentingPopup];
}
- (void)nearbyUserFilterView:(LCNearbyUserFilterView *)userFilterView filtType:(LCUserFilterType)filtType{
    [self.userFilterPopup dismissPresentingPopup];
    
    //友盟事件
    switch (filtType){
        case LCUserFilterType_All:
            break;
        case LCUserFilterType_Female:
            break;
        case LCUserFilterType_Male:
            break;
        case LCUserFilterType_Identified:
            break;
    }
    
    //更新显示
    switch (self.showingTab) {
        case LCHomeRecmdUserVCTab_Recmd:
            self.recmdUserFilterType = filtType;
            break;
        case LCHomeRecmdUserVCTab_Nearby:
            self.nearbyUserFilterType = filtType;
    }
    [self.tableView headerBeginRefreshing];
}




@end
