//
//  LCUserInfoVC.m
//  LinkCity
//
//  Created by roy on 11/22/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCUserInfoVC.h"
#import "LCXMPPUtil.h"
#import "LCSettingVC.h"
#import "ChatViewController.h"
#import "LCChatManager.h"

@interface LCUserInfoVC ()<UINavigationControllerDelegate,UINavigationBarDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabButtonLeftLineWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabButtonRightLineWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabButtonBottomLineHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *realNameBottomLineHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sexBottomLineHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ageBottomLineHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *schoolBottomLineHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *companyBottomLineHeight;
@end

@implementation LCUserInfoVC

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //init whole vertical scroll view
    self.wholeVerticalScrollView.delegate = self;
    
    // set line height
    self.tabButtonLeftLineWidth.constant = 0.5;
    self.tabButtonRightLineWidth.constant = 0.5;
    self.tabButtonBottomLineHeight.constant = 0.5;
    self.realNameBottomLineHeight.constant = 0.5;
    self.sexBottomLineHeight.constant = 0.5;
    self.ageBottomLineHeight.constant = 0.5;
    self.schoolBottomLineHeight.constant = 0.5;
    self.companyBottomLineHeight.constant = 0.5;
    
    //初始化最初显示个人信息页
    self.showingPageType = UserInfoVC_InfoPage;
    
    //初始化cover 样式
    self.coverButtonContainerView.layer.cornerRadius = 16;
    self.coverButtonContainerView.layer.masksToBounds = YES;
    self.coverButtonContainerView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.coverButtonContainerView.layer.borderWidth = 0.5;
    
    self.editButton.layer.cornerRadius = 16;
    self.editButton.layer.masksToBounds = YES;
    self.editButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.editButton.layer.borderWidth = 0.5;
    
    //初始化scroll view
    self.pageHorizontalScrollView.delegate = self;
    
    //初始化个人信息页
    UIImage *image = self.userSlogonBorderImageView.image;
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(28, 15, 6, 15) resizingMode:UIImageResizingModeStretch];
    self.userSlogonBorderImageView.image = image;
    
    //初始化旅行动态页
    self.userPlanTableView.delegate = self;
    self.userPlanTableView.dataSource = self;
    self.userPlanTableView.scrollEnabled = NO;
    self.userPlanTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //初始化个人相册页
    self.userAlbumCollectionView.delegate = self;
    self.userAlbumCollectionView.dataSource = self;
    self.userAlbumCollectionView.scrollEnabled = NO;
    self.userAlbumCollectionView.tipWhenEmpty = @"这只达客很神秘，没有上传任何照片";
    self.userAlbumCollectionView.tipImageName = @"UserAlbumEmpty";
    
    [self addFooterRefersh];
}

- (void)viewDidLayoutSubviews{
    if (![self haveLayoutSubViews]) {
        self.coverButtonContainerVerticalLineWidth.constant = 0.5;
    }
    [self updateShow];
    [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if (NO == [self.userInfo.uuid isEqualToString:self.lastUserUuid]) {
        self.plans = [[NSArray alloc] init];
        self.photos = [[NSArray alloc] init];
    }
    self.lastUserUuid = self.userInfo.uuid;
    
    [MobClick event:MobEProfileInfo];
    [self updateShow];
    if (self.isShowingSelf) {
        [self getUserInfo:[LCDataManager sharedInstance].userInfo.uuid];
    }else{
        [self getUserInfo:self.userInfo.uuid];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.buttonsContainerViewTop = self.buttonsContainerView.frame.origin.y;
    RLog(@"Buttons container View top %f",self.buttonsContainerView.frame.origin.y);
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Public Interface
+ (UINavigationController *)createNavigationVCInstance{
    UIViewController *vc = [LCStoryboardManager viewControllerWithFileName:SBNameUserinfo identifier:VCIDUserinfoNavigationVC];
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)vc;
    }
    return nil;
}

+ (LCUserInfoVC *)createRootVCInstance{
    LCUserInfoVC *vc = (LCUserInfoVC *)[LCStoryboardManager viewControllerWithFileName:SBNameUserinfo identifier:VCIDUserinfoVC];
    return vc;
}

- (void)showUserinfo:(LCUserInfo *)userInfo showSelfInfo:(BOOL)isShowingSelf{
    self.userInfo = userInfo;
    self.isShowingSelf = isShowingSelf;
    
    if (isShowingSelf) {
        self.userInfo = [LCDataManager sharedInstance].userInfo;
    }
    
    if (self.haveLayoutSubViews) {
        [self updateShow];
    }
}

#pragma mark - MJRefresh
- (void)footerRereshing {
    NSLog(@"footer refresh");
}

#pragma mark - Inner Function
- (void)updateShow {
    if (!self.view) {
        RLog(@"view haven't load");
        return;
    }
    
    [self updateShowAccordingToShowingToWhom];
    [self updatePageShowTo:self.showingPageType];
    
    self.navBarTitleLabel.text = self.userInfo.nick;
    self.title = self.userInfo.nick;
    
    self.partnerNumLabel.text = [NSString stringWithFormat:@"%ld",(long)self.userInfo.partnerTime];
    self.receptionNumLabel.text = [NSString stringWithFormat:@"%ld",(long)self.userInfo.receptionTime];
    self.createrAvatarView.imageURL = [NSURL URLWithString:self.userInfo.avatarThumbUrl];
    
    [self updateFaveButtonShow];
    [self.faveButton updateLayoutToCenterMargin:4];
    [self.talkButton updateLayoutToCenterMargin:4];
    
    self.userLocationLabel.text = [LCStringUtil getShowStringFromMayNullString:self.userInfo.livingPlace];
    self.realNameLabel.text = [LCStringUtil getShowStringFromMayNullString:self.userInfo.realName];
    
//    NSString *slogonString = [LCStringUtil getShowStringFromMayNullString:self.userInfo.signature];
//    float height = [LCStringUtil getHeightOfString:slogonString withFont:self.userSlogonLabel.font lineSpace:9 labelWidth:(DEVICE_WIDTH-78)];
//    self.userSlogonRowHeight.constant = height+24;
    NSString *slogonString = [LCStringUtil isNullString:self.userInfo.signature]?@"个性签名: 未填写":self.userInfo.signature;
    [self.userSlogonLabel setText:slogonString withLineSpace:9];
    self.userSlogonRowHeight.constant = self.userSlogonLabel.frame.size.height+24;
    
    self.sexLabel.text = [self.userInfo getSexStringForChinese];
    self.sexImageView.image = [self.userInfo getSexImageForSelfInfoPage];
    
    self.ageLabel.text = self.userInfo.age>=0?[NSString stringWithFormat:@"%ld",(long)self.userInfo.age]:[LCStringUtil getShowStringFromMayNullString:nil];
    self.schoolLabel.text = [LCStringUtil getShowStringFromMayNullString:self.userInfo.school];
    self.companyLabel.text = [LCStringUtil getShowStringFromMayNullString:self.userInfo.company];
    
    [self.userPlanTableView reloadData];
    [self.userAlbumCollectionView reloadData];
}

- (void)updateShowAccordingToShowingToWhom {
    if (self.isShowingSelf) {
        //显示自己的个人主页～～从侧边栏进入
        NSInteger menuNumber = [LCChatManager sharedInstance].initialData.unreadChatNum + [LCChatManager sharedInstance].initialData.unreadMsgNum;
        if (0 != menuNumber) {
            [self.navBarBackButton setImage:[UIImage imageNamed:@"UserMenuButtonWithTip"] forState:UIControlStateNormal];
        }else{
            [self.navBarBackButton setImage:[UIImage imageNamed:@"UserMenuButton"] forState:UIControlStateNormal];
        }
        self.coverButtonContainerView.hidden = YES;
        self.editButton.hidden = NO;
        self.navBarSettingButton.hidden = NO;
        self.userPlanTableView.tipWhenEmpty = @"还没有参与计划，先去首页逛逛吧!";
        self.userPlanTableView.tipImageName = @"UserPlanEmpty";
    }else{
        //从其它入口进入，相当于浏览用户信息
        self.coverButtonContainerView.hidden = NO;
        self.editButton.hidden = YES;
        [self.navBarBackButton setImage:[UIImage imageNamed:@"UserBackButton"] forState:UIControlStateNormal];
        self.navBarSettingButton.hidden = YES;
        self.userPlanTableView.tipWhenEmpty = @"这只达客很宅，哪都没去过";
        self.userPlanTableView.tipImageName = @"UserPlanEmpty";
    }
}

- (void)updateFaveButtonShow {
    if (self.userInfo && self.userInfo.isFavored) {
        [self.faveButton setImage:[UIImage imageNamed:@"UserFavorOn"] forState:UIControlStateNormal];
    }else if(self.userInfo && !self.userInfo.isFavored){
        [self.faveButton setImage:[UIImage imageNamed:@"UserFavorOff"] forState:UIControlStateNormal];
    }
}

- (void)updatePageShowTo:(UserInfoVC_PageType)pageType {
    self.showingPageType = pageType;
    
    float viewWidth = self.pageHorizontalScrollView.frame.size.width;
    if (pageType == UserInfoVC_InfoPage) {
        [self.pageHorizontalScrollView scrollRectToVisible:CGRectMake(0, 0, viewWidth, 10) animated:YES];
        
        self.buttonBottomLineLeft.constant = 0;
        [self.userInfoButton setTitleColor:UIColorFromR_G_B_A(72, 67, 63, 1) forState:UIControlStateNormal];
        [self.planStateButton setTitleColor:UIColorFromR_G_B_A(182, 180, 178, 1) forState:UIControlStateNormal];
        [self.userAlbumButton setTitleColor:UIColorFromR_G_B_A(182, 180, 178, 1) forState:UIControlStateNormal];
        
        [self updateHeightToUserInfoPage];
        [self hideFooterRefresh:YES];
    }else if(pageType == UserInfoVC_PlansPage){
        [self.pageHorizontalScrollView scrollRectToVisible:CGRectMake(viewWidth, 0, viewWidth, 10) animated:YES];
        
        self.buttonBottomLineLeft.constant = viewWidth/3*1;
        [self.userInfoButton setTitleColor:UIColorFromR_G_B_A(182, 180, 178, 1) forState:UIControlStateNormal];
        [self.planStateButton setTitleColor:UIColorFromR_G_B_A(72, 67, 63, 1) forState:UIControlStateNormal];
        [self.userAlbumButton setTitleColor:UIColorFromR_G_B_A(182, 180, 178, 1) forState:UIControlStateNormal];
        
        [self updateHeightToUserPlansPage];
        [self hideFooterRefresh:NO];
    }else if(pageType == UserInfoVC_AlbumPage){
        [self.pageHorizontalScrollView scrollRectToVisible:CGRectMake(viewWidth*2, 0, viewWidth, 10) animated:YES];
        self.buttonBottomLineLeft.constant = viewWidth/3*2;
        [self.userInfoButton setTitleColor:UIColorFromR_G_B_A(182, 180, 178, 1) forState:UIControlStateNormal];
        [self.planStateButton setTitleColor:UIColorFromR_G_B_A(182, 180, 178, 1) forState:UIControlStateNormal];
        [self.userAlbumButton setTitleColor:UIColorFromR_G_B_A(72, 67, 63, 1) forState:UIControlStateNormal];
        
        [self updateHeightToUserAlbumPage];
        [self hideFooterRefresh:NO];
    }
}


#pragma mark - ButtonAction
- (IBAction)navBarBackButtonAction:(id)sender {
    RLog(@"%@",[[NSThread callStackSymbols]firstObject]);
    if (self.isShowingSelf) {
        [LCSlideVC showMenu];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (IBAction)navBarSettingButtonAction:(id)sender {
    RLog(@"setting button click");
    UIViewController *controller = [LCStoryboardManager viewControllerWithFileName:SBNameSetting identifier:VCIDSettingVC];
    [self.navigationController pushViewController:controller animated:APP_ANIMATION];
}

- (IBAction)avatarImageButtonClick:(id)sender {
    LCImageModel *img = [[LCImageModel alloc]init];
    img.imageUrl = self.userInfo.avatarUrl;
    img.imageUrlThumb = self.userInfo.avatarThumbUrl;
    [LCViewSwitcher presentPhotoScannerToShow:@[img] fromIndex:0];
}

- (IBAction)editButtonClick:(id)sender {
    RLog(@"%@",[[NSThread callStackSymbols]firstObject]);
    LCUserInfoEditVC *userinfoEditVC = [LCUserInfoEditVC createVCInstance];
    userinfoEditVC.userInfo = self.userInfo;
    UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:userinfoEditVC];
    [self presentViewController:navC animated:YES completion:nil];
}

- (IBAction)favorButtonClick:(id)sender {
    if ([self.userInfo.uuid isEqualToString:[LCDataManager sharedInstance].userInfo.uuid]) {
        //如果当前是在浏览用户信息
        //同时被浏览的正是登录的这个用户自己
        [YSAlertUtil tipOneMessage:@"不能收藏自己" delay:TIME_FOR_RIGHT_TIP];
        return;
    }
    
    [self disableButtons];
    [LCXMPPUtil saveChatContact:self.userInfo withType:CHAT_CONTACT_FAVOR];
    LCUserApi *api = [[LCUserApi alloc] initWithDelegate:self];
    if (self.userInfo && !self.userInfo.isFavored) {
        [api favorUser:self.userInfo.uuid];
    } else if(self.userInfo && self.userInfo.isFavored){
        [api cancelFavorUser:self.userInfo.uuid];
    }
    RLog(@"FavorButtonClick");
}

- (IBAction)talkButtonClick:(id)sender {
    if ([self.userInfo.uuid isEqualToString:[LCDataManager sharedInstance].userInfo.uuid]) {
        //如果当前是在浏览用户信息
        //同时被浏览的正是登录的这个用户自己
        [YSAlertUtil tipOneMessage:@"不能和自己聊天" delay:TIME_FOR_RIGHT_TIP];
        return;
    }
    
    //TODO: 跳转到聊天页
    RLog(@"talkButtonClick");
    if (NO == [self.userInfo.uuid isEqualToString:[LCDataManager sharedInstance].userInfo.uuid]) {
        /// 算私聊添加联系人.
        [LCXMPPUtil saveChatContact:self.userInfo withType:CHAT_CONTACT_PRIVATE_CHAT];
        ChatViewController *controller = [[ChatViewController alloc] initWithUser:self.userInfo];
        [self.navigationController pushViewController:controller animated:APP_ANIMATION];
    } else {
        [self showHint:@"不能和自己聊天！"];
    }
}

- (IBAction)userInfoButtonClick:(id)sender {
    [MobClick event:MobEProfileInfo];
    [self updatePageShowTo:UserInfoVC_InfoPage];
}

- (IBAction)userPlansButtonClick:(id)sender {
    [MobClick event:MobEProfilePlan];
    [self updatePageShowTo:UserInfoVC_PlansPage];
}

- (IBAction)userAlbumButtonClick:(id)sender {
    [MobClick event:MobEProfilePhoto];
    [self updatePageShowTo:UserInfoVC_AlbumPage];
}

#pragma mark - LCUserApiDelegate
- (void)userApi:(LCUserApi *)userApi didFavorUserWithError:(NSError *)error {
    [self enableButtons];
    if (error) {
        [YSAlertUtil tipOneMessage:error.domain delay:TIME_FOR_ERROR_TIP];
    }else{
        self.userInfo.isFavored = 1;
        [YSAlertUtil tipOneMessage:@"收藏成功!" delay:TIME_FOR_RIGHT_TIP];
        [self updateShow];
    }
}

- (void)userApi:(LCUserApi *)userApi didCancelFavorUserWithError:(NSError *)error {
    [self enableButtons];
    if (error) {
        [YSAlertUtil tipOneMessage:error.domain delay:TIME_FOR_ERROR_TIP];
    }else{
        self.userInfo.isFavored = 0;
        [YSAlertUtil tipOneMessage:@"取消收藏成功!" delay:TIME_FOR_RIGHT_TIP];
        [self updateShow];
    }
}

#pragma mark - InnerFuction

- (void)updateHeightToUserInfoPage {
    CGPoint topLeftOfPageHorizontalScrollView = [self.wholeVerticalScrollView convertPoint:CGPointMake(0, 0) fromView:self.pageHorizontalScrollView];
    float minHeight = self.view.frame.size.height-topLeftOfPageHorizontalScrollView.y;
    CGPoint p = CGPointMake(self.companyLabel.frame.size.width, self.companyLabel.frame.size.height);
    p = [self.companyLabel convertPoint:p toView:self.pageHorizontalScrollView];
    float h = MAX(minHeight, p.y);
    self.pageHorizontalScrollViewHeight.constant = h+40;
}

- (void)updateHeightToUserPlansPage {
    CGPoint topLeftOfPageHorizontalScrollView = [self.wholeVerticalScrollView convertPoint:CGPointMake(0, 0) fromView:self.pageHorizontalScrollView];
    float minHeight = self.view.frame.size.height-topLeftOfPageHorizontalScrollView.y;
    //如果高度太小，view下能上下滚动
    //minHeight表示屏幕高，减去上边cover的高
    float h = MAX(minHeight, self.plans.count*PlansTableCellHeight);
    self.pageHorizontalScrollViewHeight.constant = h+20;
}

- (void)updateHeightToUserAlbumPage {
    CGPoint topLeftOfPageHorizontalScrollView = [self.wholeVerticalScrollView convertPoint:CGPointMake(0, 0) fromView:self.pageHorizontalScrollView];
    float minHeight = self.view.frame.size.height-topLeftOfPageHorizontalScrollView.y;
    //如果高度太小，view下能上下滚动
    //minHeight表示屏幕高，减去上边cover的高
    float h = MAX(minHeight, [self getAlbumCollectionViewContentHeight]);
    self.pageHorizontalScrollViewHeight.constant = h+20;
}

- (void)disableButtons {
    self.faveButton.enabled = NO;
}

- (void)enableButtons {
    self.faveButton.enabled = YES;
}
@end
