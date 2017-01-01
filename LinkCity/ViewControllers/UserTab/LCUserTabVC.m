//
//  LCUserTabVC.m
//  LinkCity
//
//  Created by roy on 3/7/15.
//  Updated by zzs on 13/1/16.
//  Updated by lhr on 13/6/16.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCUserTabVC.h"
#import "LCUserInfoVC.h"
#import "LCUserServiceVC.h"
#import "LCRegisterAndLoginHelper.h"
#import "LCAgreementVC.h"
#import "LCUserIdentifyVC.h"
#import "LCUserIdentityHelper.h"
#import "LCPlanTableVC.h"
#import "LCSettingVC.h"
#import "LCTourpicAlbumVC.h"
#import "LCNotifyTableVC.h"
#import "LCUserTableOwnVC.h"
#import "LCUserPlanHelperVC.h"
#import "LCUserOrderListVC.h"
#import "LCMerchantOrderListVC.h"
#import "LCEditUserInfoVC.h"
#import "LinkCity-Swift.h"
#import "LCPickAndUploadImageView.h"
#import "LCUserPlanListVC.h"
#import "LCUserAllOrderVC.h"
#import "LCUserPendingPaymentOrderVC.h"
#import "LCUserToBeEvaluatedOrderVC.h"
#import "LCUserRefundOrderVC.h"
#import "LCMerchantServiceListVC.h"
#import "LCMerchantBillListVC.h"
#import "LCMerchantRefundListVC.h"
#import "LCMerchantTicketCheckVC.h"
#import "LCUserApplyForMerchantVC.h"

#define LCUserServiceTop_UserNotIdentity 52
#define LCUserServiceTop_UserIdentified 8
#define NotifyButtonImage_Normal @"MyNotifyButtonIcon"
#define NotifyButtonImage_Reddot @"MyNotifyButtonRedDotIcon"

@interface LCUserTabVC ()<UIScrollViewDelegate>
//UI

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userCellTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userCellHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userIndentifyHeight;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *userIdentityIcon;
@property (weak, nonatomic) IBOutlet UIButton *favorBtn;
@property (weak, nonatomic) IBOutlet UIButton *followerBtn;
@property (weak, nonatomic) IBOutlet UIButton *pointBtn;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UIView *userIdentityCellView;
@property (weak, nonatomic) IBOutlet UILabel *userIdentityStateLabel;
@property (weak, nonatomic) IBOutlet UIView *userServiceCellView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userIdentityCellHeightConstraint;
@property (nonatomic, strong) UIBarButtonItem *notifyBarButton;
@property (weak, nonatomic) IBOutlet UILabel *merchantStatusLabel;
@property (weak, nonatomic) IBOutlet UIView *notifyRedDotView;
//@property (weak, nonatomic) IBOutlet UILabel *carStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *myPlanLabel;
@property (nonatomic, strong) UIImage *formerNavigationBarShadowImage;
@property (weak, nonatomic) IBOutlet UILabel *beMerchantLabel;
@property (weak, nonatomic) IBOutlet UIButton *myPlanButton;
@property (weak, nonatomic) IBOutlet UIImageView *merchantIcon;

@property (weak, nonatomic) IBOutlet UIView *allOrderViewContainer;
@property (weak, nonatomic) IBOutlet UIView *pendingPaymentViewContainer;
@property (weak, nonatomic) IBOutlet UIView *toBeEvaluatedViewContainer;
@property (weak, nonatomic) IBOutlet UIView *refundViewContainer;
@property (weak, nonatomic) IBOutlet UILabel *editingResetLabel;

@property (weak, nonatomic) IBOutlet UILabel *pendingPaymentLabel;
@property (weak, nonatomic) IBOutlet UILabel *toBeEvaluatedLabel;
@property (weak, nonatomic) IBOutlet UIView *sexView;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *merchantRefundDotLabel;

//DATA
@property (nonatomic, assign) NSInteger pendingPaymentNumber;
@property (nonatomic, assign) NSInteger toBeEvaluatedNumber;
@property (nonatomic, assign) NSInteger merchantRefundDotNumber;
@property (weak, nonatomic) IBOutlet UIView *merchantTabView;
@property (weak, nonatomic) IBOutlet UIView *userTabView;
@property (weak, nonatomic) IBOutlet UIView *userFuncListView;
@property (weak, nonatomic) IBOutlet UIView *merchantFuncListView;
@property (nonatomic, strong) NSString *processingRateInfo;

@property (weak, nonatomic) IBOutlet UILabel *merchantRateLabel;
@property (assign, nonatomic) BOOL isMerchant;
@end

@implementation LCUserTabVC

+ (UINavigationController *)createNavInstance {
    return [[UINavigationController alloc] initWithRootViewController:[LCUserTabVC createInstance]];
}

+ (instancetype)createInstance {
    return (LCUserTabVC *)[LCStoryboardManager viewControllerWithFileName:SBNameUserTab identifier:VCIDUserTabVC];
}

- (void)commonInit {
    [super commonInit];
    self.isHaveTabBar = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAllObserverNotifications];
    
    self.scrollView.delegate = self;
    self.processingRateInfo = [[NSString alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"我";
    self.navigationController.navigationBar.topItem.title = @"";
    self.tabBarController.tabBar.hidden = NO;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:FONT_LANTINGBLACK size:17], NSFontAttributeName, nil];
    self.formerNavigationBarShadowImage = self.navigationController.navigationBar.shadowImage;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    [self requestOrderRedDot];
    [self updateShow];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self restoreNavigationBar];
//    [self updateShow];
}

- (void)initAllObserverNotifications {
    [self addObserveToNotificationNameToRefreshData:URL_USER_IDENTITY];
    [self addObserveToNotificationNameToRefreshData:URL_CAR_IDENTITY];
    [self addObserveToNotificationNameToRefreshData:URL_GUIDE_IDENTITY_APPROVE];
    [self addObserveToNotificationNameToRefreshData:URL_GUIDE_IDENTITY];
    [self addObserveToNotificationNameToRefreshData:URL_FAVOR_USER];
    [self addObserveToNotificationNameToRefreshData:URL_UNFOLLOW_USER];
    [self addObserveToNotificationNameToRefreshData:URL_UPDATE_USER];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:NotificationRedDotNumDidChange object:nil];
}

- (void)restoreNavigationBar {
    /// NavBar变白.
    [self.navigationController.navigationBar setBackgroundImage:[LCUIConstants sharedInstance].navBarOpaqueImage forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = UIColorFromRGBA(NavigationBarTintColor, 1);
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGBA(NavigationBarTintColor, 1), NSForegroundColorAttributeName, [UIFont fontWithName:FONT_LANTINGBLACK size:17], NSFontAttributeName, nil];
    self.navigationController.navigationBar.shadowImage = self.formerNavigationBarShadowImage;
}

- (void)refreshData {
    if ([self haveLogin]) {
        __weak typeof(self) weakSelf = self;
        [LCNetRequester getUserInfo:[LCDataManager sharedInstance].userInfo.uUID callBack:^(LCUserModel *user, NSError *error) {
            if (error) {
                LCLogWarn(@"get user info error :%@",error);
            } else {
                [LCDataManager sharedInstance].userInfo = user;
                [[LCDataManager sharedInstance] saveData];
                
                [weakSelf updateShow];
            }
        }];
        //TODO
    }
}

- (void)updateShow {
    self.myPlanLabel.text = @"我的活动";
    self.beMerchantLabel.text = @"成为商家";
//    [self.myPlanButton setImage:[UIImage imageNamed:@"UserTabPlanIcon"] forState:UIControlStateNormal];
//    self.merchantIcon.image = [UIImage imageNamed:@"UserTabMerchantIcon"];
    LCUserModel *user = [LCDataManager sharedInstance].userInfo;
    if (LCIdentityStatus_Done == user.isTourGuideVerify || LCIdentityStatus_Done == user.isLocalMerchant || LCIdentityStatus_Done == user.isTravelAgency) {
        self.isMerchant = YES;
    } else {
        self.isMerchant = NO;
    }
    if (nil != user) {
        [self reCountProcessingRateLabel];
        self.nickLabel.text = user.nick;
        [self.avatarImageView setImageWithURL:[NSURL URLWithString:user.avatarThumbUrl]];
        [self.favorBtn setTitle:[NSString stringWithFormat:@"%ld",(long)user.favorNum] forState:UIControlStateNormal]; //喜欢
        [self.followerBtn setTitle:[NSString stringWithFormat:@"%ld",(long)user.fansNum] forState:UIControlStateNormal]; //粉丝
        [self.pointBtn setTitle:[NSString stringWithFormat:@"%ld",(long)user.point] forState:UIControlStateNormal]; //积分
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
        self.userIdentityIcon.hidden = YES;
        self.userIdentityCellView.hidden = NO;
        self.userIdentityCellHeightConstraint.constant = 40.0f;
        self.userIdentityStateLabel.textColor = UIColorFromRGBA(0xaba7a2, 1.0f);
        
        if (self.isMerchant) {
            self.merchantRateLabel.text = self.processingRateInfo;
        } else {
            self.userIdentityStateLabel.text = self.processingRateInfo;
        }
        self.userIndentifyHeight.constant = 40.0f;
        switch (user.isIdentify) {
             case LCIdentityStatus_Done:
                self.userIndentifyHeight.constant = 0;
                break;
            case LCIdentityStatus_Failed:
                self.editingResetLabel.text = @"审核失败";
                break;
            case LCIdentityStatus_Verifying:
                self.editingResetLabel.text = @"审核中";
                break;
            case LCIdentityStatus_None:
                self.editingResetLabel.text = @"未审核";
                break;
            
        }
//        switch (user.isIdentify) {
//            case LCIdentityStatus_None: {
        //                self.userIdentityIcon.hidden = YES;
//        self.userIdentityCellView.hidden = NO;
//        self.userIdentityCellHeightConstraint.constant = 40.0f;
//        self.userIdentityStateLabel.textColor = UIColorFromRGBA(0xaba7a2, 1.0f);
//        self.userIdentityStateLabel.text = @"未审核";
//            }
//                break;
//            case LCIdentityStatus_Verifying: {
//                self.userIdentityIcon.hidden = YES;
//                self.userIdentityCellView.hidden = NO;
//                self.userIdentityCellHeightConstraint.constant = 40.0f;
//                self.userIdentityStateLabel.textColor = UIColorFromRGBA(0xaba7a2, 1.0f);
//                self.userIdentityStateLabel.text = @"审核中";
//            }
//                break;
//            case LCIdentityStatus_Failed: {
//                self.userIdentityIcon.hidden = YES;
//                self.userIdentityCellView.hidden = NO;
//                self.userIdentityCellHeightConstraint.constant = 40.0f;
//                self.userIdentityStateLabel.textColor = UIColorFromRGBA(0xff5a4d, 1.0f);
//                self.userIdentityStateLabel.text = @"审核失败";
//            }
//                break;
//            case LCIdentityStatus_Done: {
//                self.userIdentityIcon.hidden = NO;
//                self.userIdentityCellView.hidden = YES;
//                self.userIdentityCellHeightConstraint.constant = 0.0f;
//                self.userIdentityStateLabel.text = @"审核成功";
//            }
//                break;
//        }
        
        switch (user.isTourGuideVerify) {
            case LCIdentityStatus_None: {
                self.merchantStatusLabel.textColor = UIColorFromRGBA(0xaba7a2, 1.0f);
                self.merchantStatusLabel.text = @"未认证";
            }
                break ;
            case LCIdentityStatus_Verifying: {
                self.merchantStatusLabel.textColor = UIColorFromRGBA(0xaba7a2, 1.0f);
                self.merchantStatusLabel.text = @"审核中";
            }
                break ;
            case LCIdentityStatus_Failed: {
                
                self.merchantStatusLabel.textColor = UIColorFromRGBA(0xff5a4d, 1.0f);
                self.merchantStatusLabel.text = @"审核失败";
            }
                break ;
            case LCIdentityStatus_Done: {
                self.myPlanLabel.text = @"我的活动";
                self.beMerchantLabel.text = @"我的账单";
                self.merchantIcon.image = [UIImage imageNamed:@"UserTabBillIcon"];
                self.merchantStatusLabel.textColor = UIColorFromRGBA(0xaba7a2, 1.0f);
                self.merchantStatusLabel.text = @"";
            }
                break ;
        }
        
    }
    if (YES == self.isMerchant) {
        self.merchantFuncListView.hidden = NO;
        self.userFuncListView.hidden = YES;
    } else {
        self.merchantFuncListView.hidden = YES;
        self.userFuncListView.hidden = NO;
    }
    
    [self updateRedDotShow];
    [self updateOrderInfo];
    
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
}

- (void)updateRedDotShow {
    NSInteger notifyNum = [LCDataManager sharedInstance].redDot.notifyNum;
    if (notifyNum > 0) {
        self.notifyRedDotView.hidden = NO;
    } else {
        self.notifyRedDotView.hidden = YES;
    }
}

- (IBAction)notifyButtonAction:(id)sender {
    [LCViewSwitcher pushToShowNotifyTableVCOn:self.navigationController];
}

- (IBAction)settingButtonAction:(id)sender {
    [MobClick event:Mob_UserTab_Set];
    LCSettingVC *settingVC = [LCSettingVC createInstance];
    [self.navigationController pushViewController:settingVC animated:YES];
}

#pragma mark ButtonAction
- (IBAction)merchantCheckTicketAction:(id)sender {
    LCMerchantTicketCheckVC *vc = [LCMerchantTicketCheckVC createInstance];
    [self.navigationController pushViewController:vc animated:APP_ANIMATION];
}


- (IBAction)merchantRefundAction:(id)sender {
    LCMerchantRefundListVC *vc = [LCMerchantRefundListVC createInstance];
    [self.navigationController pushViewController:vc animated:APP_ANIMATION];
}

- (IBAction)followerBtnAction:(id)sender {
    [MobClick event:Mob_UserTab_FollowerList];
    LCUserTableOwnVC *userTableVC = [LCUserTableOwnVC createInstance];
    userTableVC.showingType = LCUserTableOwnVCType_Fans;
    userTableVC.user = [LCDataManager sharedInstance].userInfo;
    [self.navigationController pushViewController:userTableVC animated:YES];
}

- (IBAction)favorBtnAction:(id)sender {
    [MobClick event:Mob_UserTab_FollowedList];
    LCUserTableOwnVC *userTableVC = [LCUserTableOwnVC createInstance];
    userTableVC.showingType = LCUserTableOwnVCType_FavoredUser;
    userTableVC.user = [LCDataManager sharedInstance].userInfo;
    [self.navigationController pushViewController:userTableVC animated:YES];
}

- (IBAction)pointBtnAction:(id)sender {
    [LCViewSwitcher pushWebVCtoShowURL:server_url([LCConstants serverHost], LCPointIntroURL) withTitle:@"积分说明" on:self.navigationController];
}

- (IBAction)userInfoButtonAction:(id)sender {
    [MobClick event:Mob_UserTab_MyInfo];
    LCUserModel *user = [LCDataManager sharedInstance].userInfo;
    if ([LCDataManager sharedInstance].userInfo) {
        LCEditUserInfoVC *editUserVC = [LCEditUserInfoVC createInstance];
        editUserVC.currentUser = user;
        [self.navigationController pushViewController:editUserVC animated:YES];
    }
}

- (IBAction)myTourpicButtonAction:(id)sender {
    [MobClick event:Mob_UserTab_MyTourPicList];
    LCTourpicAlbumVC *vc = [LCTourpicAlbumVC createInstance];
    vc.user = [LCDataManager sharedInstance].userInfo;
    [self.navigationController pushViewController:vc animated:APP_ANIMATION];
}

- (IBAction)myPlanButtonAction:(id)sender {
    [MobClick event:Mob_UserTab_MyPlanList];
    LCUserModel *user = [LCDataManager sharedInstance].userInfo;
    if (LCIdentityStatus_Done == user.isTourGuideVerify) {
        LCMerchantOrderListVC *vc = [LCMerchantOrderListVC createInstance];
        [self.navigationController pushViewController:vc animated:APP_ANIMATION];
    } else {
        LCUserPlanListVC *vc = [LCUserPlanListVC createInstance];
        [self.navigationController pushViewController:vc animated:APP_ANIMATION];
    }
}

- (IBAction)myUserIdentifyButtonAction:(id)sender {
    [MobClick event:Mob_UserTab_Identity];
    [[LCUserIdentityHelper sharedInstance] startUserIdentityWithUser:[LCDataManager sharedInstance].userInfo fromVC:self];
}

- (IBAction)myServiceButtonAction:(id)sender {
    [MobClick event:Mob_UserTab_MyService];
    if (YES == self.isMerchant) {
        LCMerchantServiceListVC *serviceVC = [LCMerchantServiceListVC createInstance];
        [self.navigationController pushViewController:serviceVC animated:YES];
    } else {
        LCUserApplyForMerchantVC *applyVC = [LCUserApplyForMerchantVC createInstance];
        [self.navigationController pushViewController:applyVC animated:YES];
    }
}

#pragma mark ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y <= 0) {
        self.userCellTop.constant = -64;
        self.userCellHeight.constant = 259 - scrollView.contentOffset.y;
    } else {
        self.userCellTop.constant = -64 - scrollView.contentOffset.y;
        self.userCellHeight.constant = 259;
    }
}

#pragma mark NotificationAction
- (void)notificationAction:(NSNotification *)notify{
    [self updateRedDotShow];
}

#pragma mark - Order Info

- (void)requestOrderRedDot {
    __weak typeof(self) weakSelf = self;
    [LCNetRequester getUserRedDot_V_FIVE:^(LCRedDotModel *redDot, NSError *error) {
        [LCDataManager sharedInstance].redDot = redDot;
        weakSelf.pendingPaymentNumber = redDot.payNum;
        weakSelf.toBeEvaluatedNumber = redDot.evalNum;
        weakSelf.merchantRefundDotNumber = redDot.unRefundNum;
        [weakSelf updateOrderInfo];
    }];
}

- (void)updateOrderInfo {
    if (self.pendingPaymentNumber == 0) {
        _pendingPaymentLabel.hidden = YES;
    } else {
        if (self.pendingPaymentNumber < 100) {
            _pendingPaymentLabel.text = [NSString stringWithFormat:@"%d",(int)self.pendingPaymentNumber];
        } else {
            _pendingPaymentLabel.text = @"99+";
        }
        _pendingPaymentLabel.hidden = NO;
    }
    
    if (self.toBeEvaluatedNumber == 0) {
        _toBeEvaluatedLabel.hidden = YES;
    } else {
        if (self.toBeEvaluatedNumber < 100) {
            _toBeEvaluatedLabel.text = [NSString stringWithFormat:@"%d",(int)self.toBeEvaluatedNumber];
        } else {
            _toBeEvaluatedLabel.text = @"99+";
        }
        _toBeEvaluatedLabel.hidden = NO;
    }
    
    if (self.merchantRefundDotNumber == 0) {
        self.merchantRefundDotLabel.hidden = YES;
    } else {
        if (self.merchantRefundDotNumber < 100) {
            self.merchantRefundDotLabel.text = [NSString stringWithFormat:@"%d",(int)self.merchantRefundDotNumber];
        } else {
            self.merchantRefundDotLabel.text = @"99+";
        }
        self.merchantRefundDotLabel.hidden = NO;
    }
}

- (IBAction)allOrderAction:(id)sender {
    LCLogInfo(@"allOrderAction");
    LCUserAllOrderVC *userAllOrderVC = [LCUserAllOrderVC createInstance];
    [self.navigationController pushViewController:userAllOrderVC animated:APP_ANIMATION];
}

- (IBAction)pendingPaymentAction:(id)sender {
    LCLogInfo(@"pendingPaymentAction");
    LCUserPendingPaymentOrderVC *userPendingPaymentOrderVC = [LCUserPendingPaymentOrderVC createInstance];
    [self.navigationController pushViewController:userPendingPaymentOrderVC animated:APP_ANIMATION];
}

- (IBAction)toBeEvaluatedAction:(id)sender {
    LCLogInfo(@"toBeEvaluatedAction");
    LCUserToBeEvaluatedOrderVC *userToBeEvaluatedVC = [LCUserToBeEvaluatedOrderVC createInstance];
    [self.navigationController pushViewController:userToBeEvaluatedVC animated:APP_ANIMATION];
}

- (IBAction)refundAction:(id)sender {
    LCLogInfo(@"refundAction");
    LCUserRefundOrderVC *userRefundVC = [LCUserRefundOrderVC createInstance];
    [self.navigationController pushViewController:userRefundVC animated:APP_ANIMATION];
}

- (IBAction)myBillAction:(id)sender {
    LCLogInfo(@"myBillAction");
    LCMerchantBillListVC *merchantBillListVC = [LCMerchantBillListVC createInstance];
    [self.navigationController pushViewController:merchantBillListVC animated:APP_ANIMATION];
}

- (IBAction)avatarAction:(id)sender {
    if (![self haveLogin]) {
        [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
        return;
    }
    
    NSMutableArray *imageModels = [[NSMutableArray alloc] initWithCapacity:0];
    LCImageModel *imageModel = [[LCImageModel alloc] init];
    imageModel.imageUrl = [LCDataManager sharedInstance].userInfo.avatarUrl;
    imageModel.imageUrlThumb = [LCDataManager sharedInstance].userInfo.avatarThumbUrl;
    [imageModels addObject:imageModel];
    
    LCPhotoScanner *photoScanner = [LCPhotoScanner createInstance];
    [photoScanner showImageModels:imageModels fromIndex:0];
    [[LCSharedFuncUtil getTopMostViewController] presentViewController:photoScanner animated:YES completion:nil];
}

#pragma mark - Counting The 
-  (void)reCountProcessingRateLabel {
    NSInteger rateCount = 0;
    LCUserModel *userInfo = [[LCDataManager sharedInstance] userInfo];
    if (userInfo.nick && [LCStringUtil isNotNullString:userInfo.nick]) {
        rateCount += 15;
    }
    
    if (userInfo.avatarUrl && [LCStringUtil isNotNullString:userInfo.avatarUrl] && [userInfo.avatarUrl isEqualToString:@"http://download.duckr.cn/DuckrDefaultPhoto.png"]) {
        rateCount += 15;
    }
    
    if (userInfo.birthday  && [LCStringUtil isNotNullString:userInfo.birthday]) {
        rateCount += 5;
    }
    
    if (userInfo.sex == 1 || userInfo.sex == 2) {
        rateCount += 5;
    }
    
    if (userInfo.livingPlace && [LCStringUtil isNotNullString:userInfo.livingPlace]) {
        rateCount += 15;
    }
    
    if (userInfo.signature && [LCStringUtil isNotNullString:userInfo.signature]) {
        rateCount += 15;
    }
    
    if (userInfo.professional && [LCStringUtil isNotNullString:userInfo.professional]) {
        rateCount += 5;
    }
    if (userInfo.school && [LCStringUtil isNotNullString:userInfo.school]) {
        rateCount += 5;
    }
    
    if (userInfo.haveGoList && userInfo.haveGoList.count > 0) {
        rateCount += 10;
    }
    
    if (userInfo.wantGoList && userInfo.wantGoList.count > 0) {
        rateCount += 10;
    }
        
    if (rateCount > 100) {
        rateCount = 100;
    }
    
    self.processingRateInfo = [NSString stringWithFormat:@"完善度%zd%%",rateCount];
}


@end
