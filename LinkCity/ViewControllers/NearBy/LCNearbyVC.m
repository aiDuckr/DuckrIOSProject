//
//  LCNearByVC.m
//  LinkCity
//
//  Created by roy on 3/8/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCNearbyVC.h"
#import "KLCPopup.h"
#import "LCNearbyUserFilterView.h"
#import "LCNearbyPlanFilterView.h"
#import "MJRefresh.h"
#import "LCNearbyUserCell.h"
#import "LCNearbyChatRoomCell.h"
#import "LCTabView.h"
#import "LCHomeVCPlanCell.h"
#import "LCUserInfoVC.h"
#import "LCPlanDetailVC.h"
#import "LCChatGroupMemberVC.h"
#import "LCBlankContentView.h"

@interface LCNearbyVC ()<UITableViewDataSource,UITableViewDelegate,LCNearbyUserFilterViewDelegate,LCNearbyPlanFilterViewDelegate,UIScrollViewDelegate,LCTabViewDelegate>
//Data
@property (nonatomic, assign) BOOL isHeaderRefreshAction;
@property (nonatomic, strong) NSArray *touristArray;    //array of LCUserModel
@property (nonatomic, strong) NSArray *nativeArray;     //array of LCUserModel
@property (nonatomic, strong) NSArray *chatRoomArray;   //array of LCChatGroupModel
@property (nonatomic, strong) NSArray *planArray;   //array of LCPlanModel

//UI
@property (weak, nonatomic) IBOutlet UIView *tabBarView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *touristTableView;
@property (weak, nonatomic) IBOutlet UITableView *chatRoomTableView;
@property (weak, nonatomic) IBOutlet UITableView *planTableView;
@property (weak, nonatomic) IBOutlet UITableView *nativeTableView;

@property (nonatomic, strong) LCBlankContentView *touristBlankView;
@property (nonatomic, strong) LCBlankContentView *chatRoomBlankView;
@property (nonatomic, strong) LCBlankContentView *planBlankView;
@property (nonatomic, strong) LCBlankContentView *nativeBlankView;

@property (weak, nonatomic) IBOutlet UIButton *filterButton;

@property (nonatomic, strong) KLCPopup *userFilterPopup;
@property (nonatomic, strong) KLCPopup *planFilterPopup;
@end




@implementation LCNearbyVC

+ (instancetype)createInstance{
    return (LCNearbyVC *)[LCStoryboardManager viewControllerWithFileName:SBNameNearby identifier:VCIDNearbyVC];
}

- (void)commonInit{
    [super commonInit];
    self.showingNearbyTab = LCNearbyTab_Plan;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView.scrollsToTop = NO;
    
    [self addObserveToNotificationNameToRefreshData:URL_JOINE_CHATGROUP];
    [self addObserveToNotificationNameToRefreshData:URL_QUIT_CHATGROUP];
    [self addObserveToNotificationNameToRefreshData:URL_JOIN_PLAN];
    [self addObserveToNotificationNameToRefreshData:URL_QUIT_PLAN];
    [self addObserveToNotificationNameToRefreshData:URL_DELETE_PLAN];
    
    self.scrollView.delegate = self;
    self.scrollView.scrollEnabled = NO;
    self.scrollView.backgroundColor = UIColorFromRGBA(LCViewBackGroundColor, 1);
    
    self.touristTableView.delegate = self;
    self.touristTableView.dataSource = self;
    self.touristTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.touristTableView.backgroundColor = [UIColor clearColor];
    [self.touristTableView addHeaderWithTarget:self action:@selector(touristTableHeaderRefresh)];
    [self.touristTableView addFooterWithTarget:self action:@selector(touristTableFooterRefresh)];
    [self.touristTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCNearbyUserCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCNearbyUserCell class])];
    
    self.chatRoomTableView.delegate = self;
    self.chatRoomTableView.dataSource = self;
    self.chatRoomTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.chatRoomTableView.backgroundColor = [UIColor clearColor];
    [self.chatRoomTableView addHeaderWithTarget:self action:@selector(chatRoomTableHeaderRefresh)];
    [self.chatRoomTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCNearbyChatRoomCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCNearbyChatRoomCell class])];
    
    self.planTableView.delegate = self;
    self.planTableView.dataSource = self;
    self.planTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.planTableView.backgroundColor = [UIColor clearColor];
    [self.planTableView addHeaderWithTarget:self action:@selector(planTableHeaderRefresh)];
    [self.planTableView addFooterWithTarget:self action:@selector(planTableFooterRefresh)];
    [self.planTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCHomeVCPlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCHomeVCPlanCell class])];

    self.nativeTableView.delegate = self;
    self.nativeTableView.dataSource = self;
    self.nativeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.nativeTableView.backgroundColor = [UIColor clearColor];
    [self.nativeTableView addHeaderWithTarget:self action:@selector(nativeTableHeaderRefresh)];
    [self.nativeTableView addFooterWithTarget:self action:@selector(nativeTableFooterRefresh)];
    [self.nativeTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCNearbyUserCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCNearbyUserCell class])];
    
    LCTabView *tabView = [LCTabView createInstance];
    tabView.frame = CGRectMake(0, 0, DEVICE_WIDTH, LCTabViewHeight);
    tabView.delegate = self;
    tabView.selectIndex = 0;
    tabView.buttonTitles = @[@"约伴",@"游客",@"当地达客",@"聊天室"];
    [self.tabBarView addSubview:tabView];
    
    self.touristBlankView = [[LCBlankContentView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-LCTabViewHeight) imageName:BlankContentImageB title:@"还没有达客在附近出没，\r\n快去邀请身边的小伙伴加入吧！" marginTop:BlankContentMarginTop];
    [self.scrollView insertSubview:self.touristBlankView atIndex:0];
    
    self.chatRoomBlankView = [[LCBlankContentView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH, 0, DEVICE_WIDTH, DEVICE_HEIGHT-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-LCTabViewHeight) imageName:BlankContentImageA title:@"面包会有的，牛奶会有的，\r\n聊天室也会有的！" marginTop:BlankContentMarginTop];
    [self.scrollView insertSubview:self.chatRoomBlankView atIndex:0];
    
    self.planBlankView = [[LCBlankContentView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH*2, 0, DEVICE_WIDTH, DEVICE_HEIGHT-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-LCTabViewHeight) imageName:BlankContentImageA title:@"还没有人在附近发起约伴，\r\n快去首页发一个吧！" marginTop:BlankContentMarginTop];
    [self.scrollView insertSubview:self.planBlankView atIndex:0];
    
    self.nativeBlankView = [[LCBlankContentView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH*3, 0, DEVICE_WIDTH, DEVICE_HEIGHT-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-LCTabViewHeight) imageName:BlankContentImageB title:@"还没有当地人在附近出末，\r\n先去别处看看吧！" marginTop:BlankContentMarginTop];
    [self.scrollView insertSubview:self.nativeBlankView atIndex:0];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
    [self updateShow];
}

- (void)refreshData{
    [self.touristTableView headerBeginRefreshing];
    
    [self.touristTableView headerBeginRefreshing];
    [self.chatRoomTableView headerBeginRefreshing];
    [self.nativeTableView headerBeginRefreshing];
    [self.planTableView headerBeginRefreshing];
//    switch (self.showingNearbyTab) {
//        case LCNearbyTab_Tourist:
//            [self.touristTableView headerBeginRefreshing];
//            break;
//        case LCNearbyTab_ChatRoom:
//            [self.chatRoomTableView headerBeginRefreshing];
//            break;
//        case LCNearbyTab_Native:
//            [self.nativeTableView headerBeginRefreshing];
//            break;
//        case LCNearbyTab_Plan:
//            [self.planTableView headerBeginRefreshing];
//            break;
//    }
}

- (void)updateShow{
    self.touristTableView.scrollsToTop = NO;
    self.chatRoomTableView.scrollsToTop = NO;
    self.planTableView.scrollsToTop = NO;
    self.nativeTableView.scrollsToTop = NO;
    
    switch (self.showingNearbyTab) {
        case LCNearbyTab_Tourist:{
            [self.scrollView scrollRectToVisible:CGRectMake(0, 0, DEVICE_WIDTH, 10) animated:NO];
            self.touristTableView.scrollsToTop = YES;
            self.filterButton.hidden = NO;
            [self.filterButton setImage:[UIImage imageNamed:@"NearbyFilter"] forState:UIControlStateNormal];
            [self.touristTableView reloadData];
            
            if (self.touristArray && self.touristArray.count>0) {
                self.touristBlankView.hidden = YES;
            }else{
                self.touristBlankView.hidden = NO;
            }
        }
            break;
        case LCNearbyTab_ChatRoom: {
            [self.scrollView scrollRectToVisible:CGRectMake(DEVICE_WIDTH, 0, DEVICE_WIDTH, 10) animated:NO];
            self.chatRoomTableView.scrollsToTop = YES;
            self.filterButton.hidden = YES;
            [self.chatRoomTableView reloadData];
            
            if (self.chatRoomArray && self.chatRoomArray.count>0) {
                self.chatRoomBlankView.hidden = YES;
            }else{
                self.chatRoomBlankView.hidden = NO;
            }
        }
            break;
        case LCNearbyTab_Plan: {
            [self.scrollView scrollRectToVisible:CGRectMake(DEVICE_WIDTH*2, 0, DEVICE_WIDTH, 10) animated:NO];
            self.planTableView.scrollsToTop = YES;
            self.filterButton.hidden = NO;
            [self.filterButton setImage:[UIImage imageNamed:@"NearbyOrder"] forState:UIControlStateNormal];
            [self.planTableView reloadData];
            
            if (self.planArray && self.planArray.count>0) {
                self.planBlankView.hidden = YES;
            }else{
                self.planBlankView.hidden = NO;
            }
        }
            break;
        case LCNearbyTab_Native: {
            [self.scrollView scrollRectToVisible:CGRectMake(DEVICE_WIDTH*3, 0, DEVICE_WIDTH, 10) animated:NO];
            self.nativeTableView.scrollsToTop = YES;
            self.filterButton.hidden = NO;
            [self.filterButton setImage:[UIImage imageNamed:@"NearbyFilter"] forState:UIControlStateNormal];
            [self.nativeTableView reloadData];
            
            if (self.nativeArray && self.nativeArray.count>0) {
                self.nativeBlankView.hidden = YES;
            }else{
                self.nativeBlankView.hidden = NO;
            }
        }
            break;
    }
}

#pragma mark - Button Action
- (IBAction)filterButtonAction:(UIButton *)sender {
    switch (self.showingNearbyTab) {
        case LCNearbyTab_Tourist:
            [self showUserFilterView];
            break;
        case LCNearbyTab_ChatRoom:
            
            break;
        case LCNearbyTab_Plan:
            [self showPlanFilterView];
            break;
        case LCNearbyTab_Native:
            [self showUserFilterView];
            break;
    }
}

#pragma mark TabView Delegate
- (void)tabView:(LCTabView *)tabView didSelectIndex:(NSInteger)index{
    LCLogInfo(@"%ld",(long)index);
    if (index == 0) {
        self.showingNearbyTab = LCNearbyTab_Plan;
    }else if(index == 1){
        self.showingNearbyTab = LCNearbyTab_Tourist;
    }else if(index == 2){
        self.showingNearbyTab = LCNearbyTab_Native;
    }else if(index == 3){
        self.showingNearbyTab = LCNearbyTab_ChatRoom;
    }
    [self updateShow];
}

#pragma mark - Net
- (void)searchTouristWithSkipNum:(NSInteger)skip{
    [LCNetRequester getNearbyTouristByLocation:[LCDataManager sharedInstance].userLocation
                                          skip:skip
                                    filterType:[LCDataManager sharedInstance].nearbyTouristFilterType
                                      callBack:^(NSArray *touristArray, NSError *error)
     {
         [self.touristTableView headerEndRefreshing];
         [self.touristTableView footerEndRefreshing];
         if (error) {
             LCLogWarn(@"get nearby tourist error:%@",error);
         }else{
             if (self.isHeaderRefreshAction) {
                 self.touristArray = touristArray;
             }else{
                 if (!touristArray || touristArray.count<=0) {
                     [YSAlertUtil tipOneMessage:LCFooterRefreshEmptyTip yoffset:TipDefaultYoffset delay:TipDefaultDelay];
                 }else{
                     self.touristArray = [self.touristArray arrayByAddingObjectsFromArray:touristArray];
                 }
             }
             [self updateShow];
         }
     }];
}
- (void)searchChatRoom{
    [LCNetRequester getNearbyChatGroupListByLocation:[LCDataManager sharedInstance].userLocation callBack:^(NSArray *chatGroupArray, NSError *error) {
        [self.chatRoomTableView headerEndRefreshing];
        if (error) {
            LCLogWarn(@"getNearbyChatGroupListByLocation error:%@",error);
        }else{
            if (self.isHeaderRefreshAction) {
                self.chatRoomArray = chatGroupArray;
            }
            [self updateShow];
        }
    }];
}
- (void)searchNativeWithSkipNum:(NSInteger)skip{
    [LCNetRequester getNearbyDuckrByLocation:[LCDataManager sharedInstance].userLocation
                                         skip:skip
                                   filterType:[LCDataManager sharedInstance].nearbyNativeFilterType
                                      locName:nil
                                     callBack:^(NSArray *nativeArray, NSError *error)
     {
         [self.nativeTableView headerEndRefreshing];
         [self.nativeTableView footerEndRefreshing];
         
         if (error) {
             LCLogWarn(@"getNearbyNativeByLocation error:%@",error);
         }else{
             if (self.isHeaderRefreshAction) {
                 self.nativeArray = nativeArray;
             }else{
                 if (!nativeArray || nativeArray.count<=0) {
                     [YSAlertUtil tipOneMessage:LCFooterRefreshEmptyTip yoffset:TipDefaultYoffset delay:TipDefaultDelay];
                 }else{
                     self.nativeArray = [self.nativeArray arrayByAddingObjectsFromArray:nativeArray];
                 }
             }
             [self updateShow];
         }
     }];
}
- (void)searchPlanWithSkipNum:(NSInteger)skip{
    [LCNetRequester getNearbyPlanByLocation:[LCDataManager sharedInstance].userLocation
                                       skip:skip
                                  orderType:[LCDataManager sharedInstance].nearbyPlanOrderType
                                    locName:nil
                                   callBack:^(NSArray *planArray, NSError *error)
     {
         [self.planTableView headerEndRefreshing];
         [self.planTableView footerEndRefreshing];
         if (error) {
             LCLogWarn(@"getNearbyPlanByLocation error:%@",error);
         }else{
             if (self.isHeaderRefreshAction) {
                 self.planArray = planArray;
             }else{
                 if (!planArray || planArray.count<=0) {
                     [YSAlertUtil tipOneMessage:LCFooterRefreshEmptyTip yoffset:TipDefaultYoffset delay:TipDefaultDelay];
                 }else{
                     self.planArray = [self.planArray arrayByAddingObjectsFromArray:planArray];
                 }
             }
             [self updateShow];
         }
     }];
}


#pragma mark Filter
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
- (void)showPlanFilterView{
    static CGFloat centerY = 0;
    if (!self.planFilterPopup) {
        LCNearbyPlanFilterView *planFilterView = [LCNearbyPlanFilterView createInstance];
        planFilterView.delegate = self;
        self.planFilterPopup = [KLCPopup popupWithContentView:planFilterView
                                                     showType:KLCPopupShowTypeSlideInFromBottom
                                                  dismissType:KLCPopupDismissTypeSlideOutToBottom
                                                     maskType:KLCPopupMaskTypeDimmed
                                     dismissOnBackgroundTouch:YES
                                        dismissOnContentTouch:NO];
        centerY = DEVICE_HEIGHT - [planFilterView intrinsicContentSize].height/2;
    }
    
    [self.planFilterPopup showAtCenter:CGPointMake(DEVICE_WIDTH/2, centerY) inView:nil];
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
            [MobClick event:V3_UserList_Order_Girl];
            break;
        case LCUserFilterType_Male:
            [MobClick event:V3_UserList_Order_Boy];
            break;
        case LCUserFilterType_Identified:
            [MobClick event:V3_UserList_Order_Identity];
            break;
    }
    
    //更新显示
    if (self.showingNearbyTab == LCNearbyTab_Native) {
        [LCDataManager sharedInstance].nearbyNativeFilterType = filtType;
        [self.nativeTableView headerBeginRefreshing];
    }else if(self.showingNearbyTab == LCNearbyTab_Tourist){
        [LCDataManager sharedInstance].nearbyTouristFilterType = filtType;
        [self.touristTableView headerBeginRefreshing];
    }
}
#pragma mark LCNearbyPlanFilterViewDelegate
- (void)nearbyPlanFilterViewDidFiltDepartTime:(LCNearbyPlanFilterView *)planFilterView{
    [MobClick event:V3_PlanList_Order_RecentDepart];
    
    [self.planFilterPopup dismissPresentingPopup];
    [LCDataManager sharedInstance].nearbyPlanOrderType = LCPlanOrderType_DepartTime;
    [self.planTableView headerBeginRefreshing];
}
- (void)nearbyPlanFilterViewDidFiltPublishTime:(LCNearbyPlanFilterView *)planFilterView{
    [MobClick event:V3_PlanList_Order_LatestPublish];
    
    [self.planFilterPopup dismissPresentingPopup];
    [LCDataManager sharedInstance].nearbyPlanOrderType = LCPlanOrderType_CreateTime;
    [self.planTableView headerBeginRefreshing];
}
- (void)nearbyPlanFilterViewDidFiltCancel:(LCNearbyPlanFilterView *)planFilterView{
    [self.planFilterPopup dismissPresentingPopup];
}



#pragma mark - UITableView
#pragma mark Table Refresh
- (void)touristTableHeaderRefresh{
    self.isHeaderRefreshAction = YES;
    [self searchTouristWithSkipNum:0];
}
- (void)touristTableFooterRefresh{
    self.isHeaderRefreshAction = NO;
    NSInteger skipNum = 0;
    if (self.touristArray) {
        skipNum = self.touristArray.count;
    }
    [self searchTouristWithSkipNum:skipNum];
}
- (void)chatRoomTableHeaderRefresh{
    [self searchChatRoom];
}
- (void)planTableHeaderRefresh{
    self.isHeaderRefreshAction = YES;
    [self searchPlanWithSkipNum:0];
}
- (void)planTableFooterRefresh{
    self.isHeaderRefreshAction = NO;
    NSInteger skipNum = 0;
    if (self.planArray) {
        skipNum = self.planArray.count;
    }
    [self searchPlanWithSkipNum:skipNum];
}
- (void)nativeTableHeaderRefresh{
    self.isHeaderRefreshAction = YES;
    [self searchNativeWithSkipNum:0];
}
- (void)nativeTableFooterRefresh{
    self.isHeaderRefreshAction = NO;
    NSInteger skipNum = 0;
    if (self.nativeArray) {
        skipNum = self.nativeArray.count;
    }
    [self searchNativeWithSkipNum:skipNum];
}



#pragma mark TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowNum = 0;
    
    if (tableView == self.touristTableView) {
        if (self.touristArray) {
            rowNum = self.touristArray.count;
        }
    }else if(tableView == self.chatRoomTableView) {
        if (self.chatRoomArray){
            rowNum = self.chatRoomArray.count;
        }
    }else if(tableView == self.nativeTableView) {
        if (self.nativeArray) {
            rowNum = self.nativeArray.count;
        }
    }else if(tableView == self.planTableView) {
        if (self.planArray) {
            rowNum = self.planArray.count;
        }
    }
    
    return rowNum;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    
    if (tableView == self.touristTableView) {
        if (self.touristArray && self.touristArray.count>indexPath.row) {
            LCUserModel *aUser = [self.touristArray objectAtIndex:indexPath.row];
            LCNearbyUserCell *userCell = [self.touristTableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCNearbyUserCell class]) forIndexPath:indexPath];
            userCell.user = aUser;
            cell = userCell;
        }
    }else if(tableView == self.chatRoomTableView) {
        if (self.chatRoomArray && self.chatRoomArray.count>indexPath.row) {
            LCChatGroupModel *aChatGroup = [self.chatRoomArray objectAtIndex:indexPath.row];
            LCNearbyChatRoomCell *groupCell = [self.chatRoomTableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCNearbyChatRoomCell class]) forIndexPath:indexPath];
            groupCell.chatGroupModel = aChatGroup;
            if (self.chatRoomArray.count == indexPath.row+1) {
                // last line
                groupCell.bottomLineLead.constant = LCBottomCellSeparatorLineLead;
            }else{
                groupCell.bottomLineLead.constant = LCInnerCellSeparatorLineLead;
            }
            
            cell = groupCell;
        }
    }else if(tableView == self.nativeTableView) {
        if (self.nativeArray && self.nativeArray.count > indexPath.row) {
            LCUserModel *aUser = [self.nativeArray objectAtIndex:indexPath.row];
            LCNearbyUserCell *userCell = [self.nativeTableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCNearbyUserCell class]) forIndexPath:indexPath];
            userCell.user = aUser;
            cell = userCell;
        }
    }else if(tableView == self.planTableView) {
        if (self.planArray && self.planArray.count > indexPath.row) {
            LCPlanModel *aPlan = [self.planArray objectAtIndex:indexPath.row];
            LCHomeVCPlanCell *planCell = [self.planTableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCHomeVCPlanCell class]) forIndexPath:indexPath];
            planCell.plan = aPlan;
            cell = planCell;
        }
    }
    
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
    }
    
    return cell;
}
#pragma mark TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight = 0;
    
    if (tableView == self.touristTableView) {
        rowHeight = [LCNearbyUserCell getCellHeight];
    }else if(tableView == self.chatRoomTableView) {
        rowHeight = [LCNearbyChatRoomCell getCellHeight];
    }else if(tableView == self.nativeTableView) {
        rowHeight = [LCNearbyUserCell getCellHeight];
    }else if(tableView == self.planTableView) {
        if (self.planArray && self.planArray.count > indexPath.row) {
            LCPlanModel *aPlan = [self.planArray objectAtIndex:indexPath.row];
            rowHeight = [LCHomeVCPlanCell getCellHightForPlan:aPlan];
        }
    }
    
    return rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.touristTableView) {
        if (self.touristArray && self.touristArray.count>indexPath.row) {
            LCUserModel *aUser = [self.touristArray objectAtIndex:indexPath.row];
            [LCViewSwitcher pushToShowUserInfoVCForUser:aUser appearanceType:LCUserInfoVC_PublicAppearance on:self.navigationController];
        }
    }else if(tableView == self.chatRoomTableView) {
        if (self.chatRoomArray && self.chatRoomArray.count>indexPath.row) {
            LCChatGroupModel *aGroup = [self.chatRoomArray objectAtIndex:indexPath.row];
            if (aGroup.isMember) {
                [LCViewSwitcher pushToShowChatWithGroupVC:aGroup on:self.navigationController];
            }else{
                [LCViewSwitcher pushToShowChatGroupMemberVCForGroup:aGroup on:self.navigationController];
            }
        }
    }else if(tableView == self.nativeTableView) {
        if (self.nativeArray && self.nativeArray.count > indexPath.row) {
            LCUserModel *aUser = [self.nativeArray objectAtIndex:indexPath.row];
            [LCViewSwitcher pushToShowUserInfoVCForUser:aUser appearanceType:LCUserInfoVC_PublicAppearance on:self.navigationController];
        }
    }else if(tableView == self.planTableView) {
        if (self.planArray && self.planArray.count > indexPath.row) {
            LCPlanModel *aPlan = [self.planArray objectAtIndex:indexPath.row];
            [LCViewSwitcher pushToShowPlanDetailVCForPlan:aPlan on:self.navigationController];
        }
    }
}




@end
