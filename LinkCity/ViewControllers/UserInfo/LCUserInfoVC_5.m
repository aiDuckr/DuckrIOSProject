//
//  LCUserInfoVC_5.m
//  LinkCity
//
//  Created by godhangyu on 16/6/8.
//  Copyright © 2016年 linkcity. All rights reserved.
//

#import "LCUserInfoVC_5.h"
#import "LCPickAndUploadImageView.h"
#import "LCFreePlanCell.h"
#import "LCCostPlanCell.h"
#import "LCMultiTourPicCell_5.h"
#import "LCUserInfoPlanMoreVC.h"
#import "LCUserInfoMoreVC.h"
#import "LCUserTableOwnVC.h"

#define PlaceHolder @"未填写"
#define UserCellImageViewHeight 259.0f

@interface LCUserInfoVC_5 ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, LCMultiTourPicCellDelegate_5>

// UI
// Scroll View
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
// Scroll View -> Plan View Container
@property (weak, nonatomic) IBOutlet UIView *planViewContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *planViewContainerHeight;
@property (weak, nonatomic) IBOutlet UIButton *planMoreButton;
@property (weak, nonatomic) IBOutlet UITableView *planTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *planTableViewHeight;
// Scroll View -> Tourpic View Container
@property (weak, nonatomic) IBOutlet UIView *tourpicViewContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tourpicViewContainerHeight;
@property (weak, nonatomic) IBOutlet UITableView *tourpicTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tourpicTableViewHeight;
// Scroll View -> Info View Container
// Scroll View -> Into View Container -> Location Declaration View
@property (weak, nonatomic) IBOutlet UILabel *locationTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *declarationLabel;
// Scroll View -> Info View Container -> Destination View
@property (weak, nonatomic) IBOutlet UILabel *wishDestinationLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitedDestinationLabel;
// Scroll View -> Info View Containter -> Job School View
@property (weak, nonatomic) IBOutlet UILabel *jobLabel;
@property (weak, nonatomic) IBOutlet UILabel *schoolLabel;

// User Cell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIButton *avatarImageButton;

@property (weak, nonatomic) IBOutlet UIImageView *userIdentityIcon;

@property (weak, nonatomic) IBOutlet UILabel *nickLabel;

@property (weak, nonatomic) IBOutlet UIView *sexView;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;

@property (weak, nonatomic) IBOutlet UILabel *favorLabel;
@property (weak, nonatomic) IBOutlet UILabel *followerLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userCellHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userCellTop;

// Bottom Button View
@property (weak, nonatomic) IBOutlet UIView *chatView;
@property (weak, nonatomic) IBOutlet UIView *bottomSeparateLine;
@property (weak, nonatomic) IBOutlet UIView *favorView;
@property (weak, nonatomic) IBOutlet UIView *centerChatView;

@property (weak, nonatomic) IBOutlet UIButton *chatButton;
@property (weak, nonatomic) IBOutlet UIButton *favorButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;

@property (nonatomic, strong) UIImage *formerNavigationBarShadowImage;

// Data
@property (nonatomic, strong) NSArray *planArray;
@property (nonatomic, strong) NSArray *tourpicArray;
@property (nonatomic, assign) BOOL isVisible;

@end

@implementation LCUserInfoVC_5

+ (instancetype)createInstance {
    return (LCUserInfoVC_5 *)[LCStoryboardManager viewControllerWithFileName:SBNameUser identifier:VCIDUserInfoVC_5];
}

#pragma mark - Life Cycle

- (void)commonInit {
    [super commonInit];
    self.isHaveTabBar = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNavigationBar];
    [self initTableView];
    [self initAllObserverNotifications];
    [self initUI];
    
    self.scrollView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self initNavigationBar];
    self.isVisible = YES;
    [self updateShow];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[LCUIConstants sharedInstance].navBarOpaqueImage forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = UIColorFromRGBA(NavigationBarTintColor, 1);
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGBA(NavigationBarTintColor, 1), NSForegroundColorAttributeName, [UIFont fontWithName:FONT_LANTINGBLACK size:17], NSFontAttributeName, nil];
    self.navigationController.navigationBar.shadowImage = self.formerNavigationBarShadowImage;
    self.isVisible = NO;
}

- (void)initNavigationBar {
    self.formerNavigationBarShadowImage = self.navigationController.navigationBar.shadowImage;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

- (void)initTableView {
    // PlanTableView
    self.planTableView.delegate = self;
    self.planTableView.dataSource = self;
    self.planTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.planTableView.estimatedRowHeight = 180.0f;
    self.planTableView.rowHeight = UITableViewAutomaticDimension;
    self.planTableView.scrollEnabled = NO;
    [self.planTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCFreePlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCFreePlanCell class])];
    [self.planTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCCostPlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCCostPlanCell class])];
    
    // TourpicTableView
    self.tourpicTableView.delegate = self;
    self.tourpicTableView.dataSource = self;
    self.tourpicTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tourpicTableView.estimatedRowHeight = 50.0f;
    self.tourpicTableView.rowHeight = UITableViewAutomaticDimension;
    self.tourpicTableView.scrollEnabled = NO;
    [self.tourpicTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCMultiTourPicCell_5 class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCMultiTourPicCell_5 class])];
    
}

- (void)initAllObserverNotifications {
    [self addObserveToNotificationNameToRefreshData:URL_USER_IDENTITY];
    [self addObserveToNotificationNameToRefreshData:URL_CAR_IDENTITY];
    [self addObserveToNotificationNameToRefreshData:URL_GUIDE_IDENTITY_APPROVE];
    [self addObserveToNotificationNameToRefreshData:URL_GUIDE_IDENTITY];
    [self addObserveToNotificationNameToRefreshData:URL_FAVOR_USER];
    [self addObserveToNotificationNameToRefreshData:URL_FOLLOW_USER];
    [self addObserveToNotificationNameToRefreshData:URL_UNFOLLOW_USER];
    [self addObserveToNotificationNameToRefreshData:URL_SET_USER_REMARK_NAME];
}

- (void)initUI {
    LCUserModel *user = self.user;
    if ([user.uUID isEqualToString:[LCDataManager sharedInstance].userInfo.uUID]) {
        self.bottomViewHeight.constant = 0.0f;
    }
    
    if (nil != user) {
        // User Cell
        self.nickLabel.text = user.nick;
        [self.avatarImageView setImageWithURL:[NSURL URLWithString:user.avatarThumbUrl]];
        [self.favorLabel setText:[NSString stringWithFormat:@"%ld", (long)user.favorNum]];
        [self.followerLabel setText:[NSString stringWithFormat:@"%ld", (long)user.fansNum]];
        if (1 == user.sex) {
            self.sexView.hidden = NO;
            self.sexView.backgroundColor = UIColorFromRGBA(0x8ccbed, 1.0);
            self.sexImageView.image = [UIImage imageNamed:@"UserSexMale"];
        } else if (2 == user.sex) {
            self.sexView.hidden = NO;
            self.sexView.backgroundColor = UIColorFromRGBA(0xf4abc2, 1.0);
            self.sexImageView.image = [UIImage imageNamed:@"UserSexFemale"];
        } else {
            self.sexView.hidden = YES;
        }
        if (1 <= user.age && user.age <= 200) {
            self.ageLabel.text = [NSString stringWithFormat:@"%ld", (long)user.age];
        } else {
            self.ageLabel.text = @"-";
        }
        switch (user.isIdentify) {
            case LCIdentityStatus_None: {
                self.userIdentityIcon.hidden = YES;
            }
                break;
            case LCIdentityStatus_Verifying: {
                self.userIdentityIcon.hidden = YES;
            }
                break;
            case LCIdentityStatus_Failed: {
                self.userIdentityIcon.hidden = YES;
            }
                break;
            case LCIdentityStatus_Done: {
                self.userIdentityIcon.hidden = NO;
            }
                break;
        }
        
    
        // Info View
        // 常在地 两端对齐
        [self conversionCharacterInterval:4 current:self.locationTitleLabel.text withLabel:self.locationTitleLabel];
    
        self.locationLabel.text = [LCStringUtil getNotNullStrToShow:user.livingPlace placeHolder:PlaceHolder];
        self.declarationLabel.text = [LCStringUtil getNotNullStrToShow:user.signature placeHolder:PlaceHolder];
    
        self.wishDestinationLabel.text = [LCStringUtil getNotNullStrToShow:[self getWishDestinationStringFromUser:user] placeHolder:PlaceHolder];
        self.visitedDestinationLabel.text = [LCStringUtil getNotNullStrToShow:[self getVisitedDestinationStringFromUser:user] placeHolder:PlaceHolder];
    
        self.jobLabel.text = [LCStringUtil getNotNullStrToShow:user.professional placeHolder:PlaceHolder];
        self.schoolLabel.text = [LCStringUtil getNotNullStrToShow:user.school placeHolder:PlaceHolder];
    
        // Bottom View
        if (user.isFavored) {
            self.chatView.hidden = YES;
            self.favorView.hidden = YES;
            self.bottomSeparateLine.hidden = YES;
            self.centerChatView.hidden = NO;
        } else {
            self.chatView.hidden = NO;
            self.favorView.hidden = NO;
            self.bottomSeparateLine.hidden = NO;
            self.centerChatView.hidden = YES;
        }
    }
}

#pragma mark - Util

- (void)conversionCharacterInterval:(NSInteger)maxInteger current:(NSString *)currentString withLabel:(UILabel *)label {
    CGRect rect = [@"你" boundingRectWithSize:CGSizeMake(60,label.frame.size.height)
                                     options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                  attributes:@{NSFontAttributeName: label.font}
                                     context:nil];
    
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:currentString];
    [attrString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"FZLTHJW--GB1-0" size:15] range:NSMakeRange(0, currentString.length)];
    [attrString addAttribute:NSKernAttributeName value:@(((maxInteger - currentString.length) * rect.size.width)/(currentString.length - 1)) range:NSMakeRange(0, currentString.length)];
    label.attributedText = attrString;
}

- (NSString *)getWishDestinationStringFromUser:(LCUserModel *)user{
    __block NSString *wantToStr = @"";
    [user.wantGoList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx!=0) {
            wantToStr = [wantToStr stringByAppendingString:@", "];
        }
        
        wantToStr = [wantToStr stringByAppendingString:(NSString *)obj];
    }];
    if (wantToStr.length<1) {
        wantToStr = @"";
    }
    return wantToStr;
}

- (NSString *)getVisitedDestinationStringFromUser:(LCUserModel *)user{
    __block NSString *haveBeenStr = @"";
    [user.haveGoList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx!=0) {
            haveBeenStr = [haveBeenStr stringByAppendingString:@", "];
        }
        
        haveBeenStr = [haveBeenStr stringByAppendingString:(NSString *)obj];
    }];
    if (haveBeenStr.length<1) {
        haveBeenStr = @"";
    }
    return haveBeenStr;
}

- (void)refreshData {
//    if ([self haveLogin]) {
    __weak typeof(self) weakSelf = self;
    [LCNetRequester getUserHomepage:self.user.uUID callBack:^(LCUserModel *user, NSArray *planArray, NSArray *tourpicArray, LCCarIdentityModel *carService, NSError *error) {
        if (!error) {
            weakSelf.user = user;
            weakSelf.planArray = planArray;
            weakSelf.tourpicArray = tourpicArray;
            // TODO
            //self.carIdentity = carService;
            
//            if ([user.uUID isEqualToString:[LCDataManager sharedInstance].userInfo.uUID]) {
//                [LCDataManager sharedInstance].userInfo = user;
//            }
            [weakSelf updateShow];
        }
    }];
        //TODO
//    }
}

- (void)updateShow {
    if (self.isVisible) {
        [self updateNavigationBarAppearance];
    }
    if (self.user) {
        self.nickLabel.text = self.user.nick;
        [self.avatarImageView setImageWithURL:[NSURL URLWithString:self.user.avatarThumbUrl]];
        [self.favorLabel setText:[NSString stringWithFormat:@"%ld", (long)self.user.favorNum]];
        [self.followerLabel setText:[NSString stringWithFormat:@"%ld", (long)self.user.fansNum]];
        if (1 == self.user.sex) {
            self.sexView.hidden = NO;
            self.sexView.backgroundColor = UIColorFromRGBA(0x8ccbed, 1.0);
            self.sexImageView.image = [UIImage imageNamed:@"UserSexMale"];
        } else if (2 == self.user.sex) {
            self.sexView.hidden = NO;
            self.sexView.backgroundColor = UIColorFromRGBA(0xf4abc2, 1.0);
            self.sexImageView.image = [UIImage imageNamed:@"UserSexFemale"];
        } else {
            self.sexView.hidden = YES;
        }
        if (1 <= self.user.age && self.user.age <= 200) {
            self.ageLabel.text = [NSString stringWithFormat:@"%ld", (long)self.user.age];
        } else {
            self.ageLabel.text = @"-";
        }
        switch (self.user.isIdentify) {
            case LCIdentityStatus_None: {
                self.userIdentityIcon.hidden = YES;
            }
                break;
            case LCIdentityStatus_Verifying: {
                self.userIdentityIcon.hidden = YES;
            }
                break;
            case LCIdentityStatus_Failed: {
                self.userIdentityIcon.hidden = YES;
            }
                break;
            case LCIdentityStatus_Done: {
                self.userIdentityIcon.hidden = NO;
            }
                break;
        }
    }
    
    // Plan View
    if (self.planArray && self.planArray.count > 0) {
        [self.planViewContainer removeConstraint:self.planViewContainerHeight];
        [self.planTableView reloadData];
        [self.planTableView layoutIfNeeded];
        self.planTableViewHeight.constant = [self.planTableView contentSize].height;
    } else {
        // Plan View Container Height = 0
        self.planViewContainerHeight.constant = 0;
        [self.planViewContainer addConstraint:self.planViewContainerHeight];
    }
    
    // Tourpic View
    if (self.tourpicArray && self.tourpicArray.count > 0) {
        [self.tourpicViewContainer removeConstraint:self.tourpicViewContainerHeight];
        [self.tourpicTableView reloadData];
        [self.tourpicTableView layoutIfNeeded];
        self.tourpicTableViewHeight.constant = [self.tourpicTableView contentSize].height;
    } else {
        // Tourpic View Container Height = 0
        self.tourpicViewContainerHeight.constant = 0;
        [self.tourpicViewContainer addConstraint:self.tourpicViewContainerHeight];
    }
    
    // Info View
    self.locationLabel.text = [LCStringUtil getNotNullStrToShow:self.user.livingPlace placeHolder:PlaceHolder];
    self.declarationLabel.text = [LCStringUtil getNotNullStrToShow:self.user.signature placeHolder:PlaceHolder];
    
    self.wishDestinationLabel.text = [LCStringUtil getNotNullStrToShow:[self getWishDestinationStringFromUser:self.user] placeHolder:PlaceHolder];
    self.visitedDestinationLabel.text = [LCStringUtil getNotNullStrToShow:[self getVisitedDestinationStringFromUser:self.user] placeHolder:PlaceHolder];
    NSLog(@"%lu",self.wishDestinationLabel.text.length);
    NSLog(@"%lu",self.visitedDestinationLabel.text.length);
    
    self.jobLabel.text = [LCStringUtil getNotNullStrToShow:self.user.professional placeHolder:PlaceHolder];
    self.schoolLabel.text = [LCStringUtil getNotNullStrToShow:self.user.school placeHolder:PlaceHolder];
    
    // Bottom View
    if (self.user.isFavored) {
        self.chatView.hidden = YES;
        self.favorView.hidden = YES;
        self.bottomSeparateLine.hidden = YES;
        self.centerChatView.hidden = NO;
    } else {
        self.chatView.hidden = NO;
        self.favorView.hidden = NO;
        self.bottomSeparateLine.hidden = NO;
        self.centerChatView.hidden = YES;
    }
    
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
}

- (void)updateNavigationBarAppearance {
    CGFloat tableOffsetY = self.scrollView.contentOffset.y;
    if (tableOffsetY > UserCellImageViewHeight - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT) {
        // 上滑变白
        self.title = self.user.nick;
        [self.navigationController.navigationBar setBackgroundImage:[LCUIConstants sharedInstance].navBarOpaqueImage forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.tintColor = UIColorFromRGBA(NavigationBarTintColor, 1);
        self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGBA(NavigationBarTintColor, 1), NSForegroundColorAttributeName, [UIFont fontWithName:FONT_LANTINGBLACK size:17], NSFontAttributeName, nil];
    } else {
        // 下滑后，NavBar变透明
        self.title = @"";
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:FONT_LANTINGBLACK size:17], NSFontAttributeName, nil];
    }
}

#pragma mark - ButtonAction
- (IBAction)avatarImageButtonAction:(id)sender {
    LCImageModel *imageModel = [[LCImageModel alloc] init];
    imageModel.imageUrl = self.user.avatarUrl;
    imageModel.imageUrlThumb = self.user.avatarThumbUrl;
    [LCViewSwitcher presentPhotoScannerToShow:@[imageModel] fromIndex:0];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.planTableView) {
        return self.planArray.count;
    }
    if (tableView == self.tourpicTableView) {
        return self.tourpicArray.count ? 1 : 0;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (tableView == self.planTableView) {
        // Plan Cell
        LCPlanModel *plan = [self.planArray objectAtIndex:0];
        if (LCPlanType_CostPlan == plan.routeType || LCPlanType_CostLocal == plan.routeType) {
            LCCostPlanCell *costPlanCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCCostPlanCell class]) forIndexPath:indexPath];
            [costPlanCell updateShowWithPlan:plan];
            cell = costPlanCell;
        } else {
            LCFreePlanCell *freePlanCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCFreePlanCell class]) forIndexPath:indexPath];
            [freePlanCell updateShowWithPlan:plan hideThemeId:0 withSpaInset:NO];
            freePlanCell.delegate = [LCDelegateManager sharedInstance];
            cell = freePlanCell;
        }
    }
    if (tableView == self.tourpicTableView) {
        // MultiTourPic Cell
        LCMultiTourPicCell_5 *multiTourpicCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCMultiTourPicCell_5 class]) forIndexPath:indexPath];
        multiTourpicCell.contentView.backgroundColor = [UIColor clearColor];
        [multiTourpicCell setTourPicArray:self.tourpicArray];
        multiTourpicCell.delegate = self;
        cell = multiTourpicCell;
    }
    return cell;
    
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.planTableView) {
        // Plan Cell Selected
        LCPlanModel *plan = [self.planArray objectAtIndex:0];
#warning uuid为空
        [LCViewSwitcher pushToShowPlanDetailVCForPlan:plan recmdUuid:@"" on:self.navigationController];//为何uuid为空？
    }
    if (tableView == self.tourpicTableView) {
        // Tourpic Cell Selected
    }
}


#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateNavigationBarAppearance];
    if (scrollView.contentOffset.y <= 0) {
        self.userCellTop.constant = -(STATUS_BAR_HEIGHT + NAVIGATION_BAR_HEIGHT);
        self.userCellHeight.constant = UserCellImageViewHeight - scrollView.contentOffset.y;
    } else {
        self.userCellTop.constant = -(STATUS_BAR_HEIGHT + NAVIGATION_BAR_HEIGHT) - scrollView.contentOffset.y;
        self.userCellHeight.constant = UserCellImageViewHeight;
    }
}

#pragma mark - LCMultiTourPicCell Delegate

- (void)multiTourPicCell:(LCMultiTourPicCell_5 *)cell didClickButtonIndex:(NSInteger)index {
    [LCViewSwitcher pushToShowTourPicTableVCForUser:self.user on:self.navigationController];
}

#pragma mark - Actions

- (IBAction)chatButtonAction:(id)sender {
    [MobClick event:Mob_UserInfo_Chat];
    
    if ([self haveLogin]) {
        [LCViewSwitcher pushToShowChatWithUserVC:self.user on:self.navigationController];
    } else {
        [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
    }
}

- (IBAction)favorButtonAction:(id)sender {
    [MobClick event:Mob_UserInfo_Follow];
    
    if ([self haveLogin]) {
        [LCNetRequester followUser:@[self.user.uUID] callBack:^(NSError *error) {
            if (error) {
                [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
            } else {
                self.user.isFavored = YES;
                [YSAlertUtil tipOneMessage:@"关注好友成功" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
                [self updateShow];
            }
        }];
    }
}

- (IBAction)planMoreButtonAction:(id)sender {
    LCUserInfoPlanMoreVC *userInfoPlanMoreVC = [LCUserInfoPlanMoreVC createInstance];
    userInfoPlanMoreVC.user = self.user;
    [self.navigationController pushViewController:userInfoPlanMoreVC animated:APP_ANIMATION];
}

- (IBAction)moreButtonAction:(id)sender {
    if (![self haveLogin]) {
        [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
        return;
    }
    LCUserInfoMoreVC *userInfoMoreVC = [LCUserInfoMoreVC createInstance];
    userInfoMoreVC.user = self.user;
    [self.navigationController pushViewController:userInfoMoreVC animated:APP_ANIMATION];
}

- (IBAction)favorLabelButton:(id)sender {
    [MobClick event:Mob_UserTab_FollowerList];
    LCUserTableOwnVC *userTableVC = [LCUserTableOwnVC createInstance];
    userTableVC.showingType = LCUserTableOwnVCType_DuckrFavored;
    userTableVC.user = self.user;
    [self.navigationController pushViewController:userTableVC animated:YES];
}

- (IBAction)followLabelButton:(id)sender {
    [MobClick event:Mob_UserTab_FollowedList];
    LCUserTableOwnVC *userTableVC = [LCUserTableOwnVC createInstance];
    userTableVC.showingType = LCUserTableOwnVCType_DuckrFans;
    userTableVC.user = self.user;
    [self.navigationController pushViewController:userTableVC animated:YES];
}


@end
