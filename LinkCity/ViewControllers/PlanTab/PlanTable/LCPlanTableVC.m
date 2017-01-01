//
//  LCPlanTableVC.m
//  LinkCity
//
//  Created by roy on 2/7/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCPlanTableVC.h"
#import "LCHomeVCPlanCell.h"
#import "LCPhotoScanner.h"
#import "MJRefresh.h"
#import "LCUserTableViewCell.h"
#import "LCUserTableViewCellHelper.h"
#import "LCBlankContentView.h"
#import "LCNearbyChatRoomCell.h"
#import "LCTourpicCell.h"


@interface LCPlanTableVC ()<UITableViewDataSource,UITableViewDelegate,LCTabViewDelegate,LCTourpicCellDelegate,LCShareViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *tabViewContainer;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewTopToTopLayoutGuide;


@property (weak, nonatomic) IBOutlet UITableView *planTableView;
@property (weak, nonatomic) IBOutlet UITableView *userTableView;
@property (weak, nonatomic) IBOutlet UITableView *chatRoomTableView;
@property (weak, nonatomic) IBOutlet UITableView *tourpicTableView;


@property (nonatomic, strong) LCBlankContentView *planTableBlankView;
@property (nonatomic, strong) LCBlankContentView *userTableBlankView;
@property (nonatomic, strong) LCBlankContentView *chatRoomTableBlankView;
@property (nonatomic, strong) LCBlankContentView *tourpicTableBlankView;

@property (nonatomic, strong) NSString *planTableOrderStr;
@property (nonatomic, strong) NSString *userTableOrderStr;
@property (nonatomic, strong) NSString *tourpicTableOrderStr;

@property (retain, nonatomic) LCShareView *shareView;

@property (nonatomic, assign) BOOL haveDoneFirstTimeNetRequestForPlan;

@end



@implementation LCPlanTableVC
@synthesize planModelArray = _planModelArray;

+ (instancetype)createInstance{
    return (LCPlanTableVC *)[LCStoryboardManager viewControllerWithFileName:SBNamePlanTab identifier:VCIDPlanTableVC];
}

- (void)commonInit{
    [super commonInit];
    
    self.showingType = LCPlanTableForSearchDestination;
    self.showingTab = LCPlanTableVCTab_PlanTable;
    self.haveDoneFirstTimeNetRequestForPlan = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.scrollView.scrollsToTop = NO;
    self.planTableView.scrollsToTop = YES;
    self.userTableView.scrollsToTop = NO;
    
    [self addObserveToNotificationNameToRefreshData:URL_SEND_PLAN];
    [self addObserveToNotificationNameToRefreshData:URL_JOIN_PLAN];
    [self addObserveToNotificationNameToRefreshData:URL_QUIT_PLAN];
    [self addObserveToNotificationNameToRefreshData:URL_DELETE_PLAN];
    [self addObserveToNotificationNameToRefreshData:URL_FAVOR_PLAN];
    [self addObserveToNotificationNameToRefreshData:URL_KICKOFF_USRE_OF_PLAN];
    
    UIImage *addImage = [[UIImage imageNamed:@"AddCommentToUserBtn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    [addButton setTitle:@"发邀约" forState:UIControlStateNormal];
    [addButton setTitleColor:UIColorFromRGBA(LCDarkTextColor, 1) forState:UIControlStateNormal];
    [addButton.titleLabel setFont:[UIFont fontWithName:FONT_LANTINGBLACK size:14]];
    [addButton setImage:addImage forState:UIControlStateNormal];
    [addButton setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    [addButton setTitleEdgeInsets:UIEdgeInsetsMake(2, 0, 0, -5)];
    [addButton addTarget:self action:@selector(sendPlanButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace                                    target:nil action:nil];
    negativeSpacer.width = -10;
    
    self.navigationItem.rightBarButtonItems = @[negativeSpacer,customBarItem];
    
    //禁掉通过手势滚动；只能过Tab按钮滚动
    self.scrollView.scrollEnabled = NO;
    self.scrollView.backgroundColor = UIColorFromRGBA(LCViewBackGroundColor, 1);
    
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 5)];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    self.planTableView.tableHeaderView = tableHeaderView;
    self.planTableView.dataSource = self;
    self.planTableView.delegate = self;
    [self.planTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCHomeVCPlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCHomeVCPlanCell class])];
    [self.planTableView addHeaderWithTarget:self action:@selector(planTableHeaderRereshing) dateKey:@"table"];
    [self.planTableView addFooterWithTarget:self action:@selector(planTableFooterRereshing)];
    
    self.userTableView.delegate = self;
    self.userTableView.dataSource =self;
    self.userTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.userTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCUserTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCUserTableViewCell class])];
    [self.userTableView addHeaderWithTarget:self action:@selector(userTableHeaderRereshing) dateKey:@"table"];
    [self.userTableView addFooterWithTarget:self action:@selector(userTableFooterRereshing)];
    
    self.chatRoomTableView.delegate = self;
    self.chatRoomTableView.dataSource = self;
    self.chatRoomTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.chatRoomTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCNearbyChatRoomCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCNearbyChatRoomCell class])];
    [self.chatRoomTableView addHeaderWithTarget:self action:@selector(chatTableHeaderRefreshing) dateKey:@"table"];
    
    self.tourpicTableView.delegate = self;
    self.tourpicTableView.dataSource = self;
    self.tourpicTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tourpicTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCTourpicCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCTourpicCell class])];
    [self.tourpicTableView addHeaderWithTarget:self action:@selector(tourpicTableHeaderRefreshing) dateKey:@"table"];
    [self.tourpicTableView addFooterWithTarget:self action:@selector(tourpicTableFooterRefresing)];

    
    
    LCTabView *tabView = [LCTabView createInstance];
    tabView.frame = CGRectMake(0, 0, DEVICE_WIDTH, 40);
    tabView.delegate = self;
    tabView.selectIndex = 0;
    [tabView updateButtons:@[@"邀约",@"当地达客",@"聊天室",@"旅图"] withMargin:0];
    [self.tabViewContainer addSubview:tabView];
    
    
    NSString *planTableBlankImageName = BlankContentImageA;
    NSString *planTableBlankTitle = @"";
    switch (self.showingType) {
        case LCPlanTableForRouteRelevant:
        case LCPlanTableForSearchDestination:
        case LCPlanTableForSearchTheme:{
            planTableBlankImageName = BlankContentImageA;
            planTableBlankTitle = @"还没有相关的邀约计划\r\n点击右上角为这里添加第一条邀约吧";
        }
            break;
        case LCPlanTableForUserCreated:{
            planTableBlankImageName = BlankContentImageA;
            planTableBlankTitle = @"您还没有创建邀约\r\n点击右上角为这里添加第一条邀约吧";
        }
            break;
        case LCPlanTableForUserFavored:{
            planTableBlankImageName = BlankContentImageC;
            planTableBlankTitle = @"您还没有收藏邀约，\r\n看到感兴趣的邀约就收了吧！";
        }
            break;
        case LCPlanTableForUserJoined:{
            planTableBlankImageName = BlankContentImageA;
            planTableBlankTitle = @"您还没有参与邀约，\r\n去首页逛逛吧！";
        }
            break;
        case LCPlanTableForHomePageFavorPlan:{
            planTableBlankImageName = BlankContentImageA;
            planTableBlankTitle = @"您关注的用户还没有发过邀约，\r\n去首页逛逛吧！";
        }
            break;
    }
    self.planTableBlankView = [[LCBlankContentView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT) imageName:planTableBlankImageName title:planTableBlankTitle marginTop:BlankContentMarginTop];
    [self.scrollView insertSubview:self.planTableBlankView atIndex:0];
    
    self.userTableBlankView = [[LCBlankContentView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH, 0, DEVICE_WIDTH, DEVICE_HEIGHT-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT) imageName:BlankContentImageB title:@"还没有游客在附近出没\r\n先去别处看看吧!" marginTop:BlankContentMarginTop];
    [self.scrollView insertSubview:self.userTableBlankView atIndex:0];
    
    self.chatRoomTableBlankView = [[LCBlankContentView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH*2, 0, DEVICE_WIDTH, DEVICE_HEIGHT-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT) imageName:BlankContentImageB title:@"这里还没有相关的聊天室\r\n先去别处看看吧!" marginTop:BlankContentMarginTop];
    [self.scrollView insertSubview:self.chatRoomTableBlankView atIndex:0];
    
    self.tourpicTableBlankView = [[LCBlankContentView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH*3, 0, DEVICE_WIDTH, DEVICE_HEIGHT-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT) imageName:BlankContentImageB title:@"这里还没有相关的旅图\r\n先去别处看看吧!" marginTop:BlankContentMarginTop];
    [self.scrollView insertSubview:self.tourpicTableBlankView atIndex:0];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:NO];
    [self.tabBarController.tabBar setHidden:YES];
    
    [self updateShow];
}

- (void)refreshData{
    [self.planTableView headerBeginRefreshing];
    
    if (self.showingType == LCPlanTableForSearchDestination) {
        [self.userTableView headerBeginRefreshing];
        [self.chatRoomTableView headerBeginRefreshing];
        [self.tourpicTableView headerBeginRefreshing];
    }
}

- (void)updateShow{
    [self.planTableView reloadData];
    
    switch (self.showingType) {
        case LCPlanTableForSearchDestination:{
            self.tabViewContainer.hidden = NO;
            self.scrollViewTopToTopLayoutGuide.constant = 40;
            self.title = [LCStringUtil getNotNullStr:self.placeName];
            [self.userTableView reloadData];
            
            if (self.userModelArray && self.userModelArray.count>0) {
                self.userTableBlankView.hidden = YES;
            }else{
                self.userTableBlankView.hidden = NO;
            }
            
            [self.chatRoomTableView reloadData];
            
            if (self.chatRoomArray && self.chatRoomArray.count>0) {
                self.chatRoomTableBlankView.hidden = YES;
            }else{
                self.chatRoomTableBlankView.hidden = NO;
            }
            
            [self.tourpicTableView reloadData];
            
            if (self.tourpicModelArray && self.tourpicModelArray.count>0) {
                self.tourpicTableBlankView.hidden = YES;
            }else{
                self.tourpicTableBlankView.hidden = NO;
            }
            
            [self.planTableView addFooterWithTarget:self action:@selector(planTableFooterRereshing)];
        }
            break;
        case LCPlanTableForSearchTheme:{
            self.tabViewContainer.hidden = YES;
            self.scrollViewTopToTopLayoutGuide.constant = 0;
            self.title = [LCStringUtil getNotNullStr:self.theme.title];
            
            [self.planTableView addFooterWithTarget:self action:@selector(planTableFooterRereshing)];
        }
            break;
        case LCPlanTableForUserCreated:{
            self.tabViewContainer.hidden = YES;
            self.scrollViewTopToTopLayoutGuide.constant = 0;
            self.title = @"我创建的邀约";
            
            [self.planTableView addFooterWithTarget:self action:@selector(planTableFooterRereshing)];
        }
        case LCPlanTableForUserJoined:{
            self.tabViewContainer.hidden = YES;
            self.scrollViewTopToTopLayoutGuide.constant = 0;
            self.title = @"参与的邀约";
            
            [self.planTableView addFooterWithTarget:self action:@selector(planTableFooterRereshing)];
        }
            break;
        case LCPlanTableForUserFavored:{
            self.tabViewContainer.hidden = YES;
            self.scrollViewTopToTopLayoutGuide.constant = 0;
            self.title = @"收藏的邀约";
            
            [self.planTableView addFooterWithTarget:self action:@selector(planTableFooterRereshing)];
        }
            break;
        case LCPlanTableForRouteRelevant:{
            self.tabViewContainer.hidden = YES;
            self.scrollViewTopToTopLayoutGuide.constant = 0;
            self.title = @"相关邀约";
            
            [self.planTableView removeFooter];
        }
            break;
        case LCPlanTableForHomePageFavorPlan:{
            self.tabViewContainer.hidden = YES;
            self.scrollViewTopToTopLayoutGuide.constant = 0;
            self.title = @"关注邀约";
            
            [self.planTableView addFooterWithTarget:self action:@selector(planTableFooterRereshing)];
        }
            break;
    }
    
    
    if (!self.haveDoneFirstTimeNetRequestForPlan ||
        (self.planModelArray && self.planModelArray.count>0)) {
        self.planTableBlankView.hidden = YES;
    }else{
        self.planTableBlankView.hidden = NO;
    }
}


- (NSMutableArray *)planModelArray{
    switch (self.showingType) {
        case LCPlanTableForRouteRelevant:
        case LCPlanTableForSearchDestination:
        case LCPlanTableForSearchTheme:
        case LCPlanTableForUserCreated:
        case LCPlanTableForHomePageFavorPlan:
            return _planModelArray;
            break;
        case LCPlanTableForUserFavored:
            return [LCDataManager sharedInstance].favoredPlanArr;
            break;
        case LCPlanTableForUserJoined:
            return _planModelArray;
            break;
    }
}
- (void)setPlanModelArray:(NSMutableArray *)planModelArray{
    switch (self.showingType) {
        case LCPlanTableForRouteRelevant:
        case LCPlanTableForSearchDestination:
        case LCPlanTableForSearchTheme:
        case LCPlanTableForUserCreated:
        case LCPlanTableForHomePageFavorPlan:
            _planModelArray = planModelArray;
            break;
        case LCPlanTableForUserFavored:
            [LCDataManager sharedInstance].favoredPlanArr = planModelArray;
            break;
        case LCPlanTableForUserJoined:
            _planModelArray = planModelArray;
            break;
    }
}

#pragma mark Server Request
- (void)requestPlansFromOrderString:(NSString *)orderString{
    switch (self.showingType) {
        case LCPlanTableForSearchDestination:{
            [LCNetRequester searchPlanByDestination:self.placeName orderString:orderString callBack:^(NSArray *plans, NSString *orderStr, NSError *error) {
                [self didGetPlansFromServer:plans orderStr:orderStr withError:error];
            }];
        }
            break;
        case LCPlanTableForSearchTheme:{
            [LCNetRequester searchPlanByTheme:self.theme.tourThemeId orderString:orderString callBack:^(NSArray *plans, NSString *orderStr, NSError *error) {
                [self didGetPlansFromServer:plans orderStr:orderStr withError:error];
            }];
        }
            break;
        case LCPlanTableForUserCreated:{
            [LCNetRequester getCreatedPlansOfUser:self.user.uUID orderString:orderString callBack:^(NSArray *plans, NSString *orderStr, NSError *error) {
                [self didGetPlansFromServer:plans orderStr:orderStr withError:error];
            }];
            
        }
        case LCPlanTableForUserJoined:{
            [LCNetRequester getJoinedPlansOfUser:self.user.uUID orderString:orderString callBack:^(NSArray *plans, NSString *orderStr, NSError *error) {
                [self didGetPlansFromServer:plans orderStr:orderStr withError:error];
            }];
        }
            break;
        case LCPlanTableForUserFavored:{
            [LCNetRequester getFavoredPlansWithOrderString:orderString callBack:^(NSArray *plans, NSString *orderStr, NSError *error) {
                [self didGetPlansFromServer:plans orderStr:orderStr withError:error];
            }];
        }
            break;
        case LCPlanTableForRouteRelevant:{
            //相关邀约不支持加载更多；  如果是上拉加载更多，直接返回空，认为没有更多了
            [LCNetRequester getRelevantPlanOfRoute:self.userRouteModel.userRouteId callBack:^(NSArray *plans, NSError *error) {
                [self didGetPlansFromServer:plans orderStr:nil withError:error];
            }];
        }
            break;
        case LCPlanTableForHomePageFavorPlan:{
            [LCNetRequester getHomePageFavorPlanByOrderString:orderString callBack:^(NSArray *planArray, NSString *orderStr, NSError *error) {
                [self didGetPlansFromServer:planArray orderStr:orderStr withError:error];
            }];
        }
            break;
    }
}



- (void)didGetPlansFromServer:(NSArray *)plans orderStr:(NSString *)orderStr withError:(NSError *)error{
    self.haveDoneFirstTimeNetRequestForPlan = YES;
    
    [self.planTableView headerEndRefreshing];
    [self.planTableView footerEndRefreshing];
    
    if (error) {
        [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipDefaultDelay];
    }else{
        
        if ([LCStringUtil isNullString:self.planTableOrderStr]) {
            //下拉刷新
            self.planModelArray = [LCPlanModel addAndFiltDuplicateStagePlanArr:plans toOriginalPlanArr:nil];
        }else{
            //上拉加载更多
            if (!plans || plans.count<=0) {
                [YSAlertUtil tipOneMessage:LCFooterRefreshEmptyTip yoffset:TipDefaultYoffset delay:TipDefaultDelay];
            }else{
                self.planModelArray = [LCPlanModel addAndFiltDuplicateStagePlanArr:plans toOriginalPlanArr:self.planModelArray];
            }
        }
        self.planTableOrderStr = orderStr;
        [self updateShow];
    }
}

- (void)requestUsersForOrderString:(NSString *)orderStr{
    [LCNetRequester getUserListByPlaceName:self.placeName orderStr:self.userTableOrderStr callBack:^(NSArray *userArray, NSString *orderStr, NSError *error) {
        [self.userTableView headerEndRefreshing];
        [self.userTableView footerEndRefreshing];
        
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
        }else{
            if ([LCStringUtil isNullString:self.userTableOrderStr]) {
                //下拉刷新
                self.userModelArray = [NSMutableArray arrayWithArray:userArray];
            }else{
                //上拉加载更多
                if (!userArray || userArray.count<=0) {
                    [YSAlertUtil tipOneMessage:LCFooterRefreshEmptyTip yoffset:TipDefaultYoffset delay:TipDefaultDelay];
                }else{
                    if (!self.userModelArray) {
                        self.userModelArray = [[NSMutableArray alloc] initWithCapacity:0];
                    }
                    [self.userModelArray addObjectsFromArray:userArray];
                }
            }
            self.userTableOrderStr = orderStr;
            [self updateShow];
        }
    }];
}

- (void)requestChatGroupList{
    [LCNetRequester getChatGroupListByPlaceName:self.placeName callBack:^(NSArray *chatGroupArray, NSError *error) {
        [self.chatRoomTableView headerEndRefreshing];
        
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
        }else{
            self.chatRoomArray = chatGroupArray;
        }
        [self updateShow];
    }];
}

- (void)requestTourpicFromOrderStr:(NSString *)orderString{
    [LCNetRequester getTourpicByPlaceName:self.placeName orderString:orderString callBack:^(NSArray *tourpicList, NSString *orderStr, NSError *error) {
        [self.tourpicTableView headerEndRefreshing];
        [self.tourpicTableView footerEndRefreshing];
        
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
        }else{
            if ([LCStringUtil isNullString:self.tourpicTableOrderStr]) {
                //下拉刷新
                self.tourpicModelArray = [NSMutableArray arrayWithArray:tourpicList];
            }else{
                //上拉加载更多
                if (!tourpicList || tourpicList.count<=0) {
                    [YSAlertUtil tipOneMessage:LCFooterRefreshEmptyTip yoffset:TipDefaultYoffset delay:TipDefaultDelay];
                }else{
                    if (!self.tourpicModelArray) {
                        self.tourpicModelArray = [[NSMutableArray alloc] initWithCapacity:0];
                    }
                    [self.tourpicModelArray addObjectsFromArray:tourpicList];
                }
            }
            self.tourpicTableOrderStr = orderStr;
            [self updateShow];
        }
    }];
}

#pragma mark ButtonAction
- (void)sendPlanButtonAction:(id)sender{
    [MobClick event:Mob_PublishPlan];
    
    if ([self haveLogin]) {
        [[LCSendPlanHelper sharedInstance] sendNewPlanWithPlaceName:@""];
    }else{
        [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
    }
}

#pragma mark UITabView Delegate
- (void)tabView:(LCTabView *)tabView didSelectIndex:(NSInteger)index{
    if (index == 0) {
        [self.scrollView scrollRectToVisible:CGRectMake(0, 0, DEVICE_WIDTH, 10) animated:YES];
    }else if(index == 1){
        [self.scrollView scrollRectToVisible:CGRectMake(DEVICE_WIDTH, 0, DEVICE_WIDTH, 10) animated:YES];
    }else if(index == 2){
        [self.scrollView scrollRectToVisible:CGRectMake(DEVICE_WIDTH*2, 0, DEVICE_WIDTH, 10) animated:YES];
    }else if(index == 3){
        [self.scrollView scrollRectToVisible:CGRectMake(DEVICE_WIDTH*3, 0, DEVICE_WIDTH, 10) animated:YES];
    }
}




#pragma mark -
#pragma mark MJRefresh
- (void)planTableHeaderRereshing{
    self.planTableOrderStr = nil;
    [self requestPlansFromOrderString:nil];
}

- (void)planTableFooterRereshing{
    if (self.showingType == LCPlanTableForRouteRelevant) {
        //想关邀约不支持加载更多；  如果是上拉加载更多，直接返回认为没有更多了
        [self.planTableView footerEndRefreshing];
    }else{
        [self requestPlansFromOrderString:self.planTableOrderStr];
    }
}

- (void)userTableHeaderRereshing{
    self.userTableOrderStr = nil;
    [self requestUsersForOrderString:nil];
}
- (void)userTableFooterRereshing{
    [self requestUsersForOrderString:self.userTableOrderStr];
}

- (void)chatTableHeaderRefreshing{
    [self requestChatGroupList];
}

- (void)tourpicTableHeaderRefreshing{
    self.tourpicTableOrderStr = nil;
    [self requestTourpicFromOrderStr:self.tourpicTableOrderStr];
}
- (void)tourpicTableFooterRefresing{
    [self requestTourpicFromOrderStr:self.tourpicTableOrderStr];
}

#pragma mark UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowNum = 0;
    if (tableView == self.planTableView) {
        rowNum = self.planModelArray.count;
    }else if(tableView == self.userTableView) {
        rowNum = self.userModelArray.count;
    }else if(tableView == self.chatRoomTableView) {
        rowNum = self.chatRoomArray.count;
    }else if(tableView == self.tourpicTableView) {
        rowNum = self.tourpicModelArray.count;
    }
    return  rowNum;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    
    if (tableView == self.planTableView) {
        LCPlanModel *plan = [self.planModelArray objectAtIndex:indexPath.row];
        LCHomeVCPlanCell *planCell = (LCHomeVCPlanCell *)[self.planTableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCHomeVCPlanCell class]) forIndexPath:indexPath];
        planCell.plan = plan;
        cell = planCell;
    }else if(tableView == self.userTableView) {
        LCUserModel *user = [self.userModelArray objectAtIndex:indexPath.row];
        LCUserTableViewCell *userCell = (LCUserTableViewCell *)[self.userTableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCUserTableViewCell class]) forIndexPath:indexPath];
        
        [LCUserTableViewCellHelper setUserTalbeViewCell:userCell shownAsUserTableViewCell:user];
        cell = userCell;
    }else if(tableView == self.chatRoomTableView) {
        if (self.chatRoomArray && self.chatRoomArray.count>indexPath.row) {
            LCChatGroupModel *aChatGroup = [self.chatRoomArray objectAtIndex:indexPath.row];
            LCNearbyChatRoomCell *groupCell = [self.chatRoomTableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCNearbyChatRoomCell class]) forIndexPath:indexPath];
            groupCell.chatGroupModel = aChatGroup;
            //在按目的地搜索的聊天室里，不显示距离
            groupCell.distanceLabel.hidden = YES;
            if (self.chatRoomArray.count == indexPath.row+1) {
                // last line
                groupCell.bottomLineLead.constant = LCBottomCellSeparatorLineLead;
            }else{
                groupCell.bottomLineLead.constant = LCInnerCellSeparatorLineLead;
            }
            
            cell = groupCell;
        }
    }else if(tableView == self.tourpicTableView) {
        if (self.tourpicModelArray && self.tourpicModelArray.count>indexPath.row) {
            LCTourpic *aTourpic = [self.tourpicModelArray objectAtIndex:indexPath.row];
            LCTourpicCell *tourpicCell = [self.tourpicTableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCTourpicCell class]) forIndexPath:indexPath];
            tourpicCell.delegate = self;
//            tourpicCell.navigationController = self.navigationController;
//            [tourpicCell updateShowWithTourpicAsList:aTourpic];
            
            cell = tourpicCell;
        }
    }
    
    return cell;
}
#pragma mark TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    
    if (tableView == self.planTableView) {
        height = [LCHomeVCPlanCell getCellHightForPlan:[self.planModelArray objectAtIndex:indexPath.row]];
    }else if(tableView == self.userTableView) {
        height = [LCUserTableViewCell getCellHeight];
    }else if(tableView == self.chatRoomTableView) {
        height = [LCNearbyChatRoomCell getCellHeight];
    }else if(tableView == self.tourpicTableView) {
        LCTourpic *tourpic = [self.tourpicModelArray objectAtIndex:indexPath.row];
//        height = [LCTourpicCell getCellHeight:tourpic];
    }
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.planTableView) {
        LCPlanModel *plan = [self.planModelArray objectAtIndex:indexPath.row];
        [LCViewSwitcher pushToShowPlanDetailVCForPlan:plan recmdUuid:nil on:self.navigationController];
    }else if(tableView == self.userTableView) {
        LCUserModel *user = [self.userModelArray objectAtIndex:indexPath.row];
        [LCViewSwitcher pushToShowUserInfoVCForUser:user on:self.navigationController];
    }else if(tableView == self.chatRoomTableView) {
        if (self.chatRoomArray && self.chatRoomArray.count>indexPath.row) {
            LCChatGroupModel *aGroup = [self.chatRoomArray objectAtIndex:indexPath.row];
            if (aGroup.isMember) {
                [LCViewSwitcher pushToShowChatWithGroupVC:aGroup on:self.navigationController];
            }else{
                [LCViewSwitcher pushToShowChatGroupMemberVCForGroup:aGroup on:self.navigationController];
            }
        }
    }else if(tableView == self.tourpicTableView) {
        if (self.tourpicModelArray && self.tourpicModelArray.count>indexPath.row) {
            LCTourpic *tourpic = [self.tourpicModelArray objectAtIndex:indexPath.row];
            [self showTourpicDetail:tourpic];
        }
    }
}





#pragma mark LCTourpicCell Delegate
- (void)likeTourpicAction:(LCTourpicCell *)cell {
    [MobClick event:Mob_TourPicList_Prise];
    
    NSIndexPath *indexPath = [self.tourpicTableView indexPathForCell:cell];
    if (nil != indexPath) {
        LCTourpic *tourpic = [self.tourpicModelArray objectAtIndex:indexPath.row];
//        cell.likeButton.enabled = NO;
        [LCNetRequester likeTourpic:tourpic.guid withType:@"1" callBack:^(NSInteger likeNum, NSInteger forwardNum, NSInteger isLike, NSError *error) {
//            cell.likeButton.enabled = YES;
            
            tourpic.likeNum = likeNum;
            tourpic.forwardNum = forwardNum;
            tourpic.isLike = isLike;
            [self.tourpicTableView reloadData];
        }];
    }
}


- (void)unlikeTourpicAction:(LCTourpicCell *)cell {
    [MobClick event:Mob_TourPicList_Prise];
    
    NSIndexPath *indexPath = [self.tourpicTableView indexPathForCell:cell];
    if (nil != indexPath) {
        LCTourpic *tourpic = [self.tourpicModelArray objectAtIndex:indexPath.row];
//        cell.likeButton.enabled = NO;
        [LCNetRequester unlikeTourpic:tourpic.guid callBack:^(NSInteger likeNum, NSInteger isLike, NSError *error) {
//            cell.likeButton.enabled = YES;
            
            tourpic.likeNum = likeNum;
            tourpic.isLike = isLike;
            [self.tourpicTableView reloadData];
        }];
    }
}

- (void)addTourpicComment:(LCTourpicCell *)cell {
    [MobClick event:Mob_TourPicList_Comment];
//    [self showTourpicDetail:cell.tourpic];
}

- (void)forwardTourpic:(LCTourpicCell *)cell {
    [MobClick event:Mob_TourPicList_Share];
    
    if (!self.shareView) {
        self.shareView = [LCShareView createInstance];
    }
    self.shareView.delegate = self;
    self.tabBarController.tabBar.hidden = YES;
//    [LCShareView showShareView:self.shareView onViewController:self forTourpic:cell.tourpic];
}


#pragma mark - For Tourpic Cell
- (void)showTourpicDetail:(LCTourpic *)tourpic {
    LCTourpicDetailVC *vc = [LCTourpicDetailVC createInstance];
    vc.tourpic = tourpic;
    [self.navigationController pushViewController:vc animated:APP_ANIMATION];
}


#pragma mark LCShareView Delegate
- (void)cancelShareAction {
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){
        self.tabBarController.tabBar.hidden = YES;
    }];
}

- (void)shareTourpicWeixin:(LCTourpic *)tourpic {
    ZLog(@"shareTourpicWeixin");
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){
        self.tabBarController.tabBar.hidden = YES;
        [LCShareUtil shareTourpicWeixinAction:tourpic presentedController:self callBack:^(NSInteger forwardNum, NSError *error) {
            if (!error) {
                tourpic.forwardNum = forwardNum;
                [self updateShow];
            }
        }];
    }];
}

- (void)shareTourpicWeixinTimeLine:(LCTourpic *)tourpic {
    ZLog(@"shareTourpicWeixinTimeLine");
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){
        self.tabBarController.tabBar.hidden = YES;
        [LCShareUtil shareTourpicWeixinTimeLine:tourpic presentedController:self callBack:^(NSInteger forwardNum, NSError *error) {
            if (!error) {
                tourpic.forwardNum = forwardNum;
                [self updateShow];
            }
        }];
    }];
}

- (void)shareTourpicWeibo:(LCTourpic *)tourpic {
    ZLog(@"shareTourpicWeibo");
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){
        self.tabBarController.tabBar.hidden = YES;
        [LCShareUtil shareTourpicWeibo:tourpic presentedController:self callBack:^(NSInteger forwardNum, NSError *error) {
            if (!error) {
                tourpic.forwardNum = forwardNum;
                [self updateShow];
            }
        }];
    }];
}

- (void)shareTourpicQQ:(LCTourpic *)tourpic {
    ZLog(@"shareTourpicQQ");
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^{
        self.tabBarController.tabBar.hidden = YES;
        [LCShareUtil shareTourpicQQ:tourpic presentedController:self callBack:^(NSInteger forwardNum, NSError *error) {
            if (!error) {
                tourpic.forwardNum = forwardNum;
                [self updateShow];
            }
        }];
    }];
}

@end
