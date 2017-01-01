//
//  LCMerchantInfoVC.m
//  LinkCity
//
//  Created by Roy on 8/28/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCMerchantInfoVC.h"
#import "LCUserInfoTopCell.h"
#import "LCMultiTourPicCell.h"
#import "LCHomeVCPlanCell.h"
#import "LCHomeVCSectionFooterCell.h"
#import "LCUserInfoSectionHeaderCell.h"
#import "LCUserInfoUserCarCell.h"
#import "LCUserInfoBaseInfoCell.h"
#import "LCUserEvaluationTitleCell.h"
#import "LCUserEvaluationCell.h"
#import "LCUserEvaluationAddCell.h"
#import "LCUserTableVC.h"
#import "LCUserEvaluationVC.h"
#import "LCReportUserVC.h"

typedef enum : NSUInteger {
    LCUserInfoCellType_CarSection,
    LCUserInfoCellType_Car,
    LCUserInfoCellType_PlanSection,
    LCUserInfoCellType_Plan,
    LCUserInfoCellType_PlanFooter,
    LCUserInfoCellType_TourpicSection,
    LCUserInfoCellType_Tourpic,
    LCUserInfoCellType_UserInfoSection,
    LCUserInfoCellType_UserInfo,
} LCUserInfoCellType;


static const CGFloat TabHeight = 42;
static const CGFloat TopViewHeight = 212;

@interface LCMerchantInfoVC ()<UITableViewDataSource,UITableViewDelegate,LCUserInfoTopCellDelegate,LCMultiTourPicCellDelegate,LCTabViewDelegate>


@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottom;

@property (weak, nonatomic) IBOutlet UIView *buttomButtonView;
@property (weak, nonatomic) IBOutlet UIButton *chatButton;
@property (weak, nonatomic) IBOutlet UIView *buttonLeftLine;
@property (weak, nonatomic) IBOutlet UIButton *followButton;

@property (nonatomic, strong) UIImage *formerNavigationBarShadowImage;

@property (nonatomic, strong) LCTabView *tabView;

@property (nonatomic, strong) UIBarButtonItem *rightBarMoreButton;
@property (nonatomic, strong) UIImage *moreButtonWhiteImage;
@property (nonatomic, strong) UIImage *moreButtonGreyImage;

@property (nonatomic, strong) LCUserInfoTopView *userInfoTopView;
@property (nonatomic, strong) NSLayoutConstraint *userInfoTopViewTop;
@property (nonatomic, strong) NSLayoutConstraint *userInfoTopViewHeight;
@end


@implementation LCMerchantInfoVC

#pragma mark - Public Interface
+ (instancetype)createInstance{
    return (LCMerchantInfoVC *)[LCStoryboardManager viewControllerWithFileName:SBNameUser identifier:NSStringFromClass([LCMerchantInfoVC class])];
}

- (void)commonInit{
    [super commonInit];
    
    self.tourpicArray = [LCDataManager sharedInstance].albumTourpicArr;
}

- (void)setUser:(LCUserModel *)user{
    _user = user;
}

#pragma mark LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self addObserveToNotificationNameToRefreshData:URL_UPDATE_USER];
    [self addObserveToNotificationNameToRefreshData:URL_ADD_EVALUATION];
    [self addObserveToNotificationNameToRefreshData:URL_FOLLOW_USER];
    [self addObserveToNotificationNameToRefreshData:URL_UNFOLLOW_USER];
    [self addObserveToNotificationNameToRefreshData:URL_DELETE_ROUTE];
    
    
    self.moreButtonWhiteImage = [[UIImage imageNamed:@"MoreBarBtnWhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.moreButtonGreyImage = [[UIImage imageNamed:@"MoreBarBtnGrey"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.rightBarMoreButton = [[UIBarButtonItem alloc] initWithImage:self.moreButtonWhiteImage style:UIBarButtonItemStyleDone target:self action:@selector(moreButtonAction:)];
    
    self.title = @"个人主页";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.layer.masksToBounds = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCUserInfoTopCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCUserInfoTopCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCUserInfoBaseInfoCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCUserInfoBaseInfoCell class])];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCUserEvaluationTitleCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCUserEvaluationTitleCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCUserEvaluationCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCUserEvaluationCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCUserEvaluationAddCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCUserEvaluationAddCell class])];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCHomeVCPlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCHomeVCPlanCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCUserInfoSectionHeaderCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCUserInfoSectionHeaderCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCMultiTourPicCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCMultiTourPicCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCHomeVCSectionFooterCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCHomeVCSectionFooterCell class])];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCUserInfoUserCarCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCUserInfoUserCarCell class])];
    
    //add userInfoTopView
    self.userInfoTopView = [LCUserInfoTopView createInstance];
    self.userInfoTopView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.userInfoTopView];
    
    NSString *horizontalConstraintStr = [NSString stringWithFormat:@"H:|[_userInfoTopView(==%ld)]",(long)DEVICE_WIDTH];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:horizontalConstraintStr options:0 metrics:nil views:NSDictionaryOfVariableBindings(_userInfoTopView)]];
    
    self.userInfoTopViewTop = [NSLayoutConstraint constraintWithItem:self.userInfoTopView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:(0-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT)];
    [self.contentView addConstraint:self.userInfoTopViewTop];
    
    self.userInfoTopViewHeight = [NSLayoutConstraint constraintWithItem:self.userInfoTopView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:TopViewHeight+TabHeight];
    [self.userInfoTopView addConstraint:self.userInfoTopViewHeight];
    
    [self.contentView bringSubviewToFront:self.tableView];
    [self.contentView bringSubviewToFront:self.buttomButtonView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //Init navigationBar appearance
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    self.formerNavigationBarShadowImage = self.navigationController.navigationBar.shadowImage;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    [self updateShow];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear: animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[LCUIConstants sharedInstance].navBarOpaqueImage forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = UIColorFromRGBA(NavigationBarTintColor, 1);
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGBA(NavigationBarTintColor, 1), NSForegroundColorAttributeName, [UIFont fontWithName:FONT_LANTINGBLACK size:17], NSFontAttributeName, nil];
    self.navigationController.navigationBar.shadowImage = self.formerNavigationBarShadowImage;
}

- (void)refreshData{
    [LCNetRequester getUserHomepage:self.user.uUID callBack:^(LCUserModel *user,
                                                              NSArray *planArray,
                                                              NSArray *tourpicArray,
                                                              LCCarIdentityModel *carService,
                                                              NSError *error)
     {
         if (!error) {
             self.user = user;
             self.planArray = planArray;
             self.tourpicArray = tourpicArray;
             self.carIdentity = carService;
             
             if ([user.uUID isEqualToString:[LCDataManager sharedInstance].userInfo.uUID]) {
                 //当前显示的用户，是登录用户
                 //更新本地存储
                 [LCDataManager sharedInstance].userInfo = user;
             }
             
             [self updateShow];
         }else{
             [YSAlertUtil tipOneMessage:error.domain];
         }
     }];
}



- (void)updateShow{
    //在个人主页狂点关注，再点聊天跳到聊天，聊天页navigationbar 会变白
    //由于网络请求延迟导致更新navigationbar 颜色
    if (!self.isAppearing) {
        return;
    }
    
    if ([LCDataManager sharedInstance].userInfo &&
        [self.user.uUID isEqualToString:[LCDataManager sharedInstance].userInfo.uUID]) {
        self.navigationItem.rightBarButtonItem = nil;
    }else{
        self.navigationItem.rightBarButtonItem = self.rightBarMoreButton;
    }
    
    // update navigation bar
    [self updateNavigationBarAppearance];
    
    
    self.userInfoTopViewHeight.constant = TopViewHeight + TabHeight;
    
    // udpate content
    [self updateCellIndex];
    [self.tableView reloadData];
    
    // update bottom buttons
    if ([self.user.uUID isEqualToString:[LCDataManager sharedInstance].userInfo.uUID]) {
        //如果是公开主页但自己看自己
        self.buttomButtonView.hidden = YES;
        self.tableViewBottom.constant = 0;
        self.followButton.hidden = YES;
        self.buttonLeftLine.hidden = YES;
        self.chatButton.hidden = YES;
    }else{
        //公开主页，并且自己看别人
        self.buttomButtonView.hidden = NO;
        self.tableViewBottom.constant = 50;
        self.followButton.hidden = NO;
        self.buttonLeftLine.hidden = NO;
        self.chatButton.hidden = NO;
    }
    
    if (self.user.isFavored) {
        [self.followButton setTitle:@"已关注" forState:UIControlStateNormal];
        [self.followButton setImage:[UIImage imageNamed:@"FollowedUserBtn"] forState:UIControlStateNormal];
    }else{
        [self.followButton setTitle:@"关注" forState:UIControlStateNormal];
        [self.followButton setImage:[UIImage imageNamed:@"FollowUserBtn"] forState:UIControlStateNormal];
    }
    
    //当滚到一半时，userInfoTopView消失，进到子页面，再回来时，userInfoTopView又出现了，需要再更新下
    [self scrollViewDidScroll:self.tableView];
}

- (void)updateNavigationBarAppearance{
    
    CGFloat tableOffsetY = self.tableView.contentOffset.y;
    if (tableOffsetY > TopViewHeight-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT) {
        //上滑后，NavBar变白
        self.title = [LCStringUtil getNotNullStr:self.user.nick];
        
        [self.navigationController.navigationBar setBackgroundImage:[LCUIConstants sharedInstance].navBarOpaqueImage forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.tintColor = UIColorFromRGBA(NavigationBarTintColor, 1);
        self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGBA(NavigationBarTintColor, 1), NSForegroundColorAttributeName, [UIFont fontWithName:FONT_LANTINGBLACK size:17], NSFontAttributeName, nil];
        
        self.tabView.backgroundColor = [UIColor whiteColor];
        self.tabView.highlightButtonTitleColor = [UIColor blackColor];
        [self.rightBarMoreButton setImage:self.moreButtonGreyImage];
        
    }else{
        //下滑后，NavBar变透明
        self.title = @"";
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:FONT_LANTINGBLACK size:17], NSFontAttributeName, nil];
        
        self.tabView.backgroundColor = [UIColor clearColor];
        self.tabView.highlightButtonTitleColor = [UIColor whiteColor];
        [self.rightBarMoreButton setImage:self.moreButtonWhiteImage];
    }
}

#pragma mark - ButtonAction

- (void)moreButtonAction:(id)sender{
    if ([LCDataManager sharedInstance].userInfo &&
        ![[LCDataManager sharedInstance].userInfo.uUID isEqualToString:self.user.uUID]) {
        //如果已登录，并且不是本人，进行屏蔽或举报
        
        BOOL userIsBlocked = NO;
        for (NSXMLElement *privacyItem in [[LCXMPPMessageHelper sharedInstance].xmppPrivacy listWithName:XMPPPrivacyListName])
        {
            NSString *blockJid = [privacyItem attributeStringValueForName:@"value"];
            if ([blockJid isEqualToString:self.user.openfireAccount]) {
                userIsBlocked = YES;
                break;
            }
        }
        
        if (userIsBlocked) {
            [YSAlertUtil showActionSheetWithCallBack:^(NSInteger selectIndex) {
                if (selectIndex == 0) {
                    
                }else if(selectIndex == 1){
                    [[LCXMPPMessageHelper sharedInstance] unBlockUserOfJid:self.user.openfireAccount];
                }else if(selectIndex == 2){
                    [LCViewSwitcher pushToReportUser:self.user on:self.navigationController];
                }
            } cancelButtonTitle:@"取消" otherButtonTitles:@[@"取消屏蔽",@"举报"]];
        }else{
            [YSAlertUtil showActionSheetWithCallBack:^(NSInteger selectIndex) {
                if (selectIndex == 0) {
                    
                }else if(selectIndex == 1){
                    [[LCXMPPMessageHelper sharedInstance] blockUserOfJid:self.user.openfireAccount];
                }else if(selectIndex == 2){
                    [LCViewSwitcher pushToReportUser:self.user on:self.navigationController];
                }
            } cancelButtonTitle:@"取消" otherButtonTitles:@[@"屏蔽",@"举报"]];
        }
    }
}

- (IBAction)chatButtonAction:(id)sender {
    if ([self haveLogin]) {
        [LCViewSwitcher pushToShowChatWithUserVC:self.user on:self.navigationController];
    }else{
        [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
    }
}

- (IBAction)followButtonAction:(UIButton *)sender {
    LCLogInfo(@"follow");
    if ([self haveLogin]) {
        if (self.user.isFavored) {
            // unfollow
            sender.enabled = NO;
            [LCNetRequester unfollowUser:self.user.uUID callBack:^(LCUserModel *user, NSError *error) {
                sender.enabled = YES;
                if (error) {
                    [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
                }else{
                    self.user.isFavored = NO;
                    [self updateShow];
                }
            }];
        }else{
            sender.enabled = NO;
            [LCNetRequester followUser:@[self.user.uUID] callBack:^(NSError *error) {
                sender.enabled = YES;
                if (error) {
                    [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
                }else{
                    self.user.isFavored = YES;
                    [self updateShow];
                }
            }];
        }
    }else{
        [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
    }
}

#pragma mark - UITableView
#pragma mark Caculate TableView
static NSInteger serviceTabCellNum = 0;
static NSInteger carSectionIndex = 0;
static NSInteger planSectionIndex = 0;

static NSInteger userTabCellNum = 0;
static NSInteger tourpicSectionIndex = 0;
static NSInteger userBaseInfoSectionIndex = 0;

- (void)updateCellIndex{
    //*********************************
    // Service Tab
    serviceTabCellNum = 0;
    
    if (self.carIdentity) {
        carSectionIndex = serviceTabCellNum;
        serviceTabCellNum += 2;
    }else{
        carSectionIndex = -1;
    }
    
    if (self.planArray.count > 0) {
        planSectionIndex = serviceTabCellNum;
        serviceTabCellNum += 1 + self.planArray.count + 1;
    }else{
        planSectionIndex = -1;
    }
    
    
    //*********************************
    // User Tab
    userTabCellNum = 0;
    
    if (self.tourpicArray.count > 0) {
        tourpicSectionIndex = userTabCellNum;
        userTabCellNum += 1 + 1;
    }else{
        tourpicSectionIndex = -1;
    }
    
    userBaseInfoSectionIndex = userTabCellNum;
    userTabCellNum += 2;    //userBaseInfoSection, userBaseInfo
}

- (LCUserInfoCellType)getCellTypeByIndexPath:(NSIndexPath *)indexPath{
    LCUserInfoCellType cellType = 0;
    NSInteger row = indexPath.row;
    
    if (self.showingTab == MerchantInfoVCTab_Service) {
        if (self.carIdentity) {
            if (row == carSectionIndex) {
                cellType = LCUserInfoCellType_CarSection;
            }else if(row == carSectionIndex + 1){
                cellType = LCUserInfoCellType_Car;
            }
        }
        
        if (self.planArray.count > 0) {
            if (row == planSectionIndex) {
                cellType = LCUserInfoCellType_PlanSection;
            }else if(row > planSectionIndex && row < planSectionIndex + self.planArray.count + 1){
                cellType = LCUserInfoCellType_Plan;
            }else if(row == planSectionIndex + self.planArray.count + 1){
                cellType = LCUserInfoCellType_PlanFooter;
            }
        }
    }else if(self.showingTab == MerchantInfoVCTab_User) {
        if (self.tourpicArray.count > 0) {
            if (row == tourpicSectionIndex) {
                cellType = LCUserInfoCellType_TourpicSection;
            }else if(row > tourpicSectionIndex && row < tourpicSectionIndex + 1 + 1){
                cellType = LCUserInfoCellType_Tourpic;
            }
        }
        
        if (row == userBaseInfoSectionIndex) {
            cellType = LCUserInfoCellType_UserInfoSection;
        }else if(row == userBaseInfoSectionIndex + 1) {
            cellType = LCUserInfoCellType_UserInfo;
        }
    }
    
    return cellType;
}

- (LCPlanModel *)getPlanByIndexPath:(NSIndexPath *)indexPath{
    LCPlanModel *plan = nil;
    NSInteger planIndex = indexPath.row - planSectionIndex - 1;
    if (planIndex >= 0 && planIndex < self.planArray.count) {
        plan = [self.planArray objectAtIndex:planIndex];
    }
    return plan;
}


#pragma mark TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowNum = 0;
    
    if (section == 0) {
        rowNum = 1;
    }else if(section == 1){
        switch (self.showingTab) {
            case MerchantInfoVCTab_Service:
                rowNum = serviceTabCellNum;
                break;
            case MerchantInfoVCTab_User:
                rowNum = userTabCellNum;
                break;
        }
    }
    
    LCLogInfo(@"section:%ld, rowNum:%ld",(long)section,(long)rowNum);
    return rowNum;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        LCUserInfoTopCell *topCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCUserInfoTopCell class]) forIndexPath:indexPath];
        topCell.backgroundColor = [UIColor clearColor];
        topCell.selectionStyle = UITableViewCellSelectionStyleNone;
        topCell.user = self.user;
        topCell.delegate = self;
        cell = topCell;
    }else if(indexPath.section == 1){
        switch ([self getCellTypeByIndexPath:indexPath]) {
            case LCUserInfoCellType_CarSection:{
                LCUserInfoSectionHeaderCell *headerCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCUserInfoSectionHeaderCell class]) forIndexPath:indexPath];
                headerCell.iconImageView.image = [UIImage imageNamed:@"MyServiceMiniIcon"];
                headerCell.titleLabel.text = @"Ta的服务";
                cell = headerCell;
            }
                break;
            case LCUserInfoCellType_Car:{
                LCUserInfoUserCarCell *carCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCUserInfoUserCarCell class]) forIndexPath:indexPath];
                carCell.userCar = self.carIdentity;
                cell = carCell;
            }
                break;
            case LCUserInfoCellType_PlanSection:{
                LCUserInfoSectionHeaderCell *headerCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCUserInfoSectionHeaderCell class]) forIndexPath:indexPath];
                headerCell.iconImageView.image = [UIImage imageNamed:@"MyRouteMiniIcon"];
                headerCell.titleLabel.text = @"Ta的路线";
                cell = headerCell;
            }
                break;
            case LCUserInfoCellType_Plan:{
                LCHomeVCPlanCell *planCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCHomeVCPlanCell class]) forIndexPath:indexPath];
                planCell.plan = [self getPlanByIndexPath:indexPath];
                cell = planCell;
            }
                break;
            case LCUserInfoCellType_PlanFooter:{
                LCHomeVCSectionFooterCell *footerCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCHomeVCSectionFooterCell class]) forIndexPath:indexPath];
                footerCell.titleLabel.text = @"查看更多邀约";
                cell = footerCell;
            }
                break;
            case LCUserInfoCellType_TourpicSection:{
                LCUserInfoSectionHeaderCell *headerCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCUserInfoSectionHeaderCell class]) forIndexPath:indexPath];
                headerCell.iconImageView.image = [UIImage imageNamed:@"MyAlbumIcon"];
                headerCell.titleLabel.text = @"Ta的旅图";
                cell = headerCell;
            }
                break;
            case LCUserInfoCellType_Tourpic:{
                LCMultiTourPicCell *multiTourPicCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCMultiTourPicCell class]) forIndexPath:indexPath];
                multiTourPicCell.contentView.backgroundColor = [UIColor clearColor];
                multiTourPicCell.tourPicArray = self.tourpicArray;
                multiTourPicCell.delegate = self;
                cell = multiTourPicCell;
            }
                break;
            case LCUserInfoCellType_UserInfoSection:{
                LCUserInfoSectionHeaderCell *headerCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCUserInfoSectionHeaderCell class]) forIndexPath:indexPath];
                headerCell.iconImageView.image = [UIImage imageNamed:@"MyUserInfo"];
                headerCell.titleLabel.text = @"Ta的信息";
                cell = headerCell;
            }
                break;
            case LCUserInfoCellType_UserInfo:{
                LCUserInfoBaseInfoCell *baseInfoCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCUserInfoBaseInfoCell class]) forIndexPath:indexPath];
                [baseInfoCell updateShowWithUser:self.user showBottomGap:NO];
                baseInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell = baseInfoCell;
            }
                break;
        }
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView = nil;
    
    if (section == 1) {
        if (!self.tabView) {
            self.tabView = [[LCTabView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, TabHeight)];
            self.tabView.backgroundColor = UIColorFromR_G_B_A(0, 0, 0, 0.2);
            self.tabView.delegate = self;
            self.tabView.selectIndex = 0;
            self.tabView.defaultButtonTitleColor = UIColorFromR_G_B_A(201, 197, 193, 1);
            self.tabView.highlightButtonTitleColor = [UIColor whiteColor];
        }
        
        [self.tabView updateButtons:@[@"服务",@"关于Ta"] withMargin:0];
        [self.tabView setVerticalLineHiden:NO];
        
        sectionView = self.tabView;
    }
   
    return sectionView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat sectionHeight = 0;
    
    if (section == 1) {
        sectionHeight = TabHeight;
    }
    
    return sectionHeight;
}
#pragma mark TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight = 50;
    
    if (indexPath.section == 0) {
        rowHeight = TopViewHeight-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT;
    }else{
        switch ([self getCellTypeByIndexPath:indexPath]) {
            case LCUserInfoCellType_CarSection:{
                rowHeight = [LCUserInfoSectionHeaderCell getCellHeight];
            }
                break;
            case LCUserInfoCellType_Car:{
                rowHeight = [LCUserInfoUserCarCell getCellHeight];
            }
                break;
            case LCUserInfoCellType_PlanSection:{
                rowHeight = [LCUserInfoSectionHeaderCell getCellHeight];
            }
                break;
            case LCUserInfoCellType_Plan:{
                LCPlanModel *plan = [self getPlanByIndexPath:indexPath];
                rowHeight = [LCHomeVCPlanCell getCellHightForPlan:plan];
            }
                break;
            case LCUserInfoCellType_PlanFooter:{
                rowHeight = [LCHomeVCSectionFooterCell getCellHeight];
            }
                break;
            case LCUserInfoCellType_TourpicSection:{
                rowHeight = [LCUserInfoSectionHeaderCell getCellHeight];
            }
                break;
            case LCUserInfoCellType_Tourpic:{
                rowHeight = [LCMultiTourPicCell getCellHeight];
            }
                break;
            case LCUserInfoCellType_UserInfoSection:{
                rowHeight = [LCUserInfoSectionHeaderCell getCellHeight];
            }
                break;
            case LCUserInfoCellType_UserInfo:{
                rowHeight = [LCUserInfoBaseInfoCell getCellHeightForUser:self.user showBottomGap:NO];
            }
                break;
        }
    }
    
    return rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
    }else{
        switch ([self getCellTypeByIndexPath:indexPath]) {
            case LCUserInfoCellType_PlanSection:
            case LCUserInfoCellType_TourpicSection:
            case LCUserInfoCellType_Tourpic:
            case LCUserInfoCellType_UserInfoSection:
            case LCUserInfoCellType_UserInfo:
            case LCUserInfoCellType_CarSection:
                break;
            case LCUserInfoCellType_Car:
                break;
            case LCUserInfoCellType_Plan:{
                LCPlanModel *plan = [self getPlanByIndexPath:indexPath];
                [LCViewSwitcher pushToShowPlanDetailVCForPlan:plan recmdUuid:nil on:self.navigationController];
            }
                break;
            case LCUserInfoCellType_PlanFooter:{
                LCPlanTableVC *planTableVC = [LCPlanTableVC createInstance];
                planTableVC.showingType = LCPlanTableForUserJoined;
                planTableVC.user = self.user;
                [self.navigationController pushViewController:planTableVC animated:YES];
            }
                break;
        }
    }
}

#pragma mark UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //手往下，内容往下滚，contentOffset变负
    
    self.userInfoTopViewHeight.constant = TopViewHeight + TabHeight - scrollView.contentOffset.y;
    [self.userInfoTopView setNeedsLayout];
    
    [self updateNavigationBarAppearance];
}
#pragma mark LCTabView Delegate
- (void)tabView:(LCTabView *)tabView didSelectIndex:(NSInteger)index{
    if (index == 0) {
        self.showingTab = MerchantInfoVCTab_Service;
    }else if(index == 1){
        self.showingTab = MerchantInfoVCTab_User;
    }
    
    [self updateShow];
}

#pragma mark LCUserInfoTopCell Delegate
- (void)userInfoTopCellDidClickAvatar:(LCUserInfoTopCell *)topCell{
    LCImageModel *imageModel = [[LCImageModel alloc] init];
    imageModel.imageUrl = self.user.avatarUrl;
    imageModel.imageUrlThumb = self.user.avatarThumbUrl;
    [LCViewSwitcher presentPhotoScannerToShow:@[imageModel] fromIndex:0];
}
- (void)userInfoTopCellDidClickFans:(LCUserInfoTopCell *)topCell{
    LCUserTableVC *userTableVC = [LCUserTableVC createInstance];
    userTableVC.showingType = LCUserTableVCType_Fans;
    userTableVC.user = self.user;
    [self.navigationController pushViewController:userTableVC animated:YES];
}
- (void)userInfoTopCellDidClickFavored:(LCUserInfoTopCell *)topCell{
    LCUserTableVC *userTableVC = [LCUserTableVC createInstance];
    userTableVC.showingType = LCUserTableVCType_FavoredUser;
    userTableVC.user = self.user;
    [self.navigationController pushViewController:userTableVC animated:YES];
}
- (void)userInfoTopCellDidClickPoint:(LCUserInfoTopCell *)topCell{
    [LCViewSwitcher pushWebVCtoShowURL:server_url([LCConstants serverHost], LCPointIntroURL) withTitle:@"积分说明" on:self.navigationController];
}

#pragma mark LCMultiTourPicCellDelegate
- (void)multiTourPicCell:(LCMultiTourPicCell *)cell didClickButtonIndex:(NSInteger)index{
    [LCViewSwitcher pushToShowTourPicTableVCForUser:self.user on:self.navigationController];
}


@end
