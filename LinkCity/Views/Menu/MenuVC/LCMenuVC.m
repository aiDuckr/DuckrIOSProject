//
//  LCMenuVC.m
//  LinkCity
//
//  Created by roy on 10/25/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCMenuVC.h"
#import "EGOImageView.h"
#import "LCDataManager.h"
#import "LCChatManager.h"
#import "UIButton+AFNetworking.h"

@interface LCMenuVC ()<LCCommonApiDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coverRowHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *planRowHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chatRowHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *favorRowHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *settingRowHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendPlanRowHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *homeRowHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarTopSpace;


@property (weak, nonatomic) IBOutlet UIButton *homeButton;
@property (weak, nonatomic) IBOutlet UIButton *planButton;
@property (weak, nonatomic) IBOutlet UIButton *chatButton;
@property (weak, nonatomic) IBOutlet UIButton *favorButton;
@property (weak, nonatomic) IBOutlet UIButton *nearbyButton;
@property (weak, nonatomic) IBOutlet UIButton *sendReceptionButton;
@property (weak, nonatomic) IBOutlet UIButton *sendPartnerButton;

@property (weak, nonatomic) IBOutlet UIImageView *homeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *planImageView;
@property (weak, nonatomic) IBOutlet UIImageView *chatImageView;
@property (weak, nonatomic) IBOutlet UIImageView *favorImageView;
@property (weak, nonatomic) IBOutlet UIImageView *nearbyImageView;

@property (weak, nonatomic) IBOutlet UIView *avatarContainerView;
@property (weak, nonatomic) IBOutlet EGOImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIButton *avatarButton;

@property (weak, nonatomic) IBOutlet UILabel *nickLabel;

//for tip
@property (weak, nonatomic) IBOutlet UIButton *systemInfoTipButton;
@property (weak, nonatomic) IBOutlet UIView *systemInfoTipPoint;
@property (weak, nonatomic) IBOutlet UIView *chatInfoTipPoint;
@property (weak, nonatomic) IBOutlet UILabel *chatInfoLabel;

@end

@implementation LCMenuVC

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setAllButtonOff];
    [self setHomeButtonON:YES];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInitData) name:NotificationInitData object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveChatMessage:) name:NotificationReceiveChatMessageAPN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    //更新未读消息显示
    [self updateInitData];
    
    //设置头像内容scale
    [self.avatarButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentFill];
    [self.avatarButton setContentVerticalAlignment:UIControlContentVerticalAlignmentFill];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self updateShow];
    [self getUnreadNotificationFromServer];
    [self updateInitData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    ///Ruoyu
    ///in ios8, this should be in viewDidLayoutSubviews
    ///but in ios7, self.view.frame is 0 in viewDidLayoutSubviews
    ///have to put code here.
    [self layoutCustomizedViews];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)appDidBecomeActive:(NSNotification *)notif{
    //后台到前台时，未读消息数有可能更新
    //查询后，广播，所有页面更新未读消息
    [self getUnreadNotificationFromServer];
}

- (void)layoutCustomizedViews{
    
    if (IS_IPHONE_4_4S) {
        self.avatarTopSpace.constant = 60;
        self.coverRowHeight.constant = 200;
    }else{
        self.avatarTopSpace.constant = 74;
        self.coverRowHeight.constant = 224;
    }
    
    //调整每一行高度
    float height = self.contentView.frame.size.height - self.coverRowHeight.constant;
    height = height / 6.0;
    self.homeRowHeight.constant = height;
    self.planRowHeight.constant = height;
    self.chatRowHeight.constant = height;
    self.favorRowHeight.constant = height;
    self.settingRowHeight.constant = height;
    self.sendPlanRowHeight.constant = height;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view setNeedsUpdateConstraints];
        [self.view setNeedsLayout];
        [self.view setNeedsDisplay];
    });
    
    RLog(@"MenuVC layout sub views mh:%f rh:%f",self.view.frame.size.height,height);
    
    //调整滑动栏宽度
    self.slideVC.menuWidth = self.view.frame.size.width - 50;
    
    //设置头像外边框
    self.avatarContainerView.layer.cornerRadius = 44;
    self.avatarContainerView.layer.masksToBounds = YES;
}

- (void)updateShow{
    LCUserInfo *userInfo = [LCDataManager sharedInstance].userInfo;
    if (userInfo) {
        //self.avatarImageView.imageURL = [NSURL URLWithString:userInfo.avatarThumbUrl];
        [self.avatarButton setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:userInfo.avatarThumbUrl]];
        self.nickLabel.text = userInfo.nick;
    }
}

#pragma mark - Notification Functions
- (void)updateInitData {
    NSInteger unreadChatNumFromServer = [LCChatManager sharedInstance].initialData.unreadChatNum;
    NSInteger unreadChatNumLocal = [[LCChatManager sharedInstance] getTotalUnreadMsgNum];
    [self tipUnreadChat:unreadChatNumFromServer+unreadChatNumLocal];
    
    BOOL haveUnreadMsgNum = [LCChatManager sharedInstance].initialData.unreadMsgNum > 0;
    [self tipUnreadInfo:haveUnreadMsgNum];
}

- (void)didReceiveChatMessage:(NSNotification *)notif{
    [self getUnreadNotificationFromServer];
}
#pragma mark - Public Interface
- (void)updateMenuActiveType:(MenuActiveType)activeType{
    [self setAllButtonOff];
    switch (activeType) {
        case MenuActiveHomePage:
            [self setHomeButtonON:YES];
            break;
        case MenuActiveMyChatPage:
            [self setChatButtonON:YES];
            break;
        case MenuActiveMyFavorPage:
            [self setFavorButtonON:YES];
            break;
        case MenuActiveMyPlanPage:
            [self setPlanButtonON:YES];
            break;
        case MenuActiveNearbyPage:
            [self setNearbyButtonON:YES];
            break;
        case MenuActiveNone:
            break;
        default:
            break;
    }
}

- (void)tipUnreadInfo:(BOOL)haveUnreadInfo{
    if (haveUnreadInfo) {
        self.systemInfoTipPoint.hidden = NO;
    }else{
        self.systemInfoTipPoint.hidden = YES;
    }
}
- (void)tipUnreadChat:(NSInteger)unreadChatNumber {
    if (unreadChatNumber <= 0) {
        self.chatInfoLabel.hidden = YES;
        self.chatInfoTipPoint.hidden = YES;
    } else {
        self.chatInfoLabel.hidden = NO;
        self.chatInfoTipPoint.hidden = NO;
        if (unreadChatNumber < 100) {
            self.chatInfoLabel.text = [NSString stringWithFormat:@"%tu",unreadChatNumber];
        } else {
            self.chatInfoLabel.text = @"99+";
        }
    }
}

#pragma mark - Button Actions
- (IBAction)systemInfoButtonClick:(id)sender {
    RLog(@"system info button");
    [self setAllButtonOff];
    if (self.slideVC) {
        [self.slideVC hideMenuAnimated:YES];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:NotificationShowMessageCenter object:nil];
}
- (IBAction)avatarButtonClick:(id)sender {
    [self setAllButtonOff];
    if (self.slideVC) {
        [self.slideVC hideMenuAnimated:YES];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:NotificationShowSelfView object:nil];
}

- (IBAction)homePageButtonClick:(id)sender{
    [self setAllButtonOff];
    [self setHomeButtonON:YES];
    if (self.slideVC) {
        [self.slideVC hideMenuAnimated:YES];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:NotificationShowHomePage object:nil];
}


- (IBAction)planListButtonClick:(id)sender {
    [self setAllButtonOff];
    [self setPlanButtonON:YES];
    if (self.slideVC) {
        [self.slideVC hideMenuAnimated:YES];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:NotificationShowPlanList object:nil];
}

- (IBAction)chatButtonClick:(id)sender {
    [self setAllButtonOff];
    [self setChatButtonON:YES];
    if (self.slideVC) {
        [self.slideVC hideMenuAnimated:YES];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:NotificationShowChat object:nil];
}

- (IBAction)favorButtonClick:(id)sender {
    [self setAllButtonOff];
    [self setFavorButtonON:YES];
    if (self.slideVC) {
        [self.slideVC hideMenuAnimated:YES];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:NotificationShowFavorList object:nil];
}
- (IBAction)nearbyButtonClick:(id)sender {
    [self setAllButtonOff];
    [self setNearbyButtonON:YES];
    if (self.slideVC){
        [self.slideVC hideMenuAnimated:YES];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:NotificationShowNearbyPage object:nil];
}

//- (IBAction)settingButtonClick:(id)sender {
//    [self setAllButtonOff];
//    [self setSettingButtonON:YES];
//    if (self.slideVC) {
//        [self.slideVC hideMenuAnimated:YES];
//    }
//    [[NSNotificationCenter defaultCenter]postNotificationName:NotificationShowSettingPage object:nil];
//}
- (IBAction)sendPlanButtonClick:(id)sender {
    [self setAllButtonOff];
    [self setHomeButtonON:YES];
    if (self.slideVC) {
        [self.slideVC hideMenuAnimated:YES];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:NotificationShowSendPartnerPlan object:nil];
}
- (IBAction)sendReceptionButtonClick:(id)sender {
    [self setAllButtonOff];
    [self setHomeButtonON:YES];
    if (self.slideVC) {
        [self.slideVC hideMenuAnimated:YES];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:NotificationShowSendReceptionPlan object:nil];
}

#pragma mark - Network Request
- (void)getUnreadNotificationFromServer {
    //如果已登录
    if ([LCStringUtil isNotNullString:[LCDataManager sharedInstance].userInfo.cid]) {
        LCCommonApi *api = [[LCCommonApi alloc] initWithDelegate:self];
        [api getUnreadNotification];
    }
}

- (void)commonApi:(LCCommonApi *)api didGetUnreadNotification:(LCInitData *)initialData withError:(NSError *)error {
    if (!error) {
        [LCChatManager sharedInstance].initialData = initialData;
        //赋值来触发notification，以便其它页面更新显示
        [LCChatManager sharedInstance].initialData.unreadChatNum = initialData.unreadChatNum;
        [LCChatManager sharedInstance].initialData.unreadMsgNum = initialData.unreadMsgNum;
    }
}

#pragma mark - Inner Function
- (void)setAllButtonOff{
    [self setHomeButtonON:NO];
    [self setPlanButtonON:NO];
    [self setChatButtonON:NO];
    [self setFavorButtonON:NO];
    [self setNearbyButtonON:NO];
}
- (void)setHomeButtonON:(BOOL)on{
    if (on) {
        [self.homeButton setTitleColor:UIColorFromRGBA(DUCKER_YELLOW, 1) forState:UIControlStateNormal];
        self.homeImageView.image = [UIImage imageNamed:@"MenuHomeOn"];
    }else{
        [self.homeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.homeImageView.image = [UIImage imageNamed:@"MenuHome"];
    }
}
- (void)setPlanButtonON:(BOOL)on{
    if (on) {
        [self.planButton setTitleColor:UIColorFromRGBA(DUCKER_YELLOW, 1) forState:UIControlStateNormal];
        self.planImageView.image = [UIImage imageNamed:@"MenuPlanOn"];
    }else{
        [self.planButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.planImageView.image = [UIImage imageNamed:@"MenuPlan"];
    }
}
- (void)setChatButtonON:(BOOL)on{
    if (on) {
        [self.chatButton setTitleColor:UIColorFromRGBA(DUCKER_YELLOW, 1) forState:UIControlStateNormal];
        self.chatImageView.image = [UIImage imageNamed:@"MenuChatOn"];
    }else{
        [self.chatButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.chatImageView.image = [UIImage imageNamed:@"MenuChat"];
    }
}
- (void)setFavorButtonON:(BOOL)on{
    if (on) {
        [self.favorButton setTitleColor:UIColorFromRGBA(DUCKER_YELLOW, 1) forState:UIControlStateNormal];
        self.favorImageView.image = [UIImage imageNamed:@"MenuFavorOn"];
    }else{
        [self.favorButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.favorImageView.image = [UIImage imageNamed:@"MenuFavor"];
    }
}
- (void)setNearbyButtonON:(BOOL)on{
    if (on) {
        [self.nearbyButton setTitleColor:UIColorFromRGBA(DUCKER_YELLOW, 1) forState:UIControlStateNormal];
        self.nearbyImageView.image = [UIImage imageNamed:@"MenuRadarOn"];
    }else{
        [self.nearbyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.nearbyImageView.image = [UIImage imageNamed:@"MenuRadarOff"];
    }
}

@end
