//
//  LCReceptionDetailVC.m
//  LinkCity
//
//  Created by roy on 11/12/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCReceptionDetailVC.h"
#import "LCReceptionApi.h"
#import "LCMemberCollectionCell.h"
#import "LCMemberCollectionView.h"
#import "LCRouteTableView.h"
#import "EGOImageView.h"
#import "LCDateUtil.h"
#import "LCCoverMemberView.h"
#import "LCRoutesBrowserCollectionCell.h"
#import "LCRoutesBrowserVC.h"
#import "LCStoryboardManager.h"
#import "YSAlertUtil.h"
#import "LCPlanApi.h"
#import "LCPlanCommentVC.h"
#import "LCXMPPUtil.h"
#import "ChatViewController.h"
#import "LCUserInfoVC.h"
#import "LCShareView.h"
#import "LCShareUtil.h"
#import "LCViewSwitcher.h"
#import "LCAFNBlurredImageView.h"

#define SEGUE_PUSH_COMMENTVC @"SegueReceptionDetailPushToComment"
#define SEGUE_PRESENT_ROUTESVC @"ReceptionDetailToRouteBrowser"
@interface LCReceptionDetailVC ()<LCReceptionApiDelegate,LCRouteTableViewDelegate,LCReceptionApiDelegate,LCPlanApiDelegate,LCCoverMemberViewDelegate,LCShareViewDelegate,LCMemberCollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *wholeVerticalScrollView;

@property (nonatomic, strong) UIBarButtonItem *editBarButton;

//cover image and title, button
@property (weak, nonatomic) IBOutlet LCAFNBlurredImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *destinationLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *coverTimeLeftLine;
@property (weak, nonatomic) IBOutlet UIView *coverTimeRightLine;

@property (weak, nonatomic) IBOutlet UIButton *joinButton;


@property (weak, nonatomic) IBOutlet UIView *coverMemberViewContainer;
@property (weak, nonatomic) IBOutlet UIView *coverMemberView;
@property (strong, nonatomic) LCCoverMemberView *coverMemberViewContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coverImageContentTopSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coverMemberTopSpace;


@property (weak, nonatomic) IBOutlet UIImageView *createrAvatarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *createrSexImageView;
@property (weak, nonatomic) IBOutlet UILabel *createrNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createrLocationLabel;
@property (weak, nonatomic) IBOutlet UIButton *talkButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *createrBottomLineHeight;


@property (weak, nonatomic) IBOutlet UILabel *slogonLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *slogonLabelVerticalToDescriptionLabel;




@property (weak, nonatomic) IBOutlet UIView *buttonPanel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonPanelRightLineWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonPanelLeftLineWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonPanelBottomLineHeight;

@property (weak, nonatomic) IBOutlet UIButton *favorButton;
@property (weak, nonatomic) IBOutlet UIButton *priseButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (weak, nonatomic) IBOutlet UILabel *memberListTitleLabel;


@property (weak, nonatomic) IBOutlet UIView *servicePanel;
@property (weak, nonatomic) IBOutlet UIImageView *servicePlayImageView;
@property (weak, nonatomic) IBOutlet UILabel *servicePlayLabel;
@property (weak, nonatomic) IBOutlet UIImageView *serviceStayImageView;
@property (weak, nonatomic) IBOutlet UILabel *serviceStayLabel;
@property (weak, nonatomic) IBOutlet UIImageView *serviceTravelImageView;
@property (weak, nonatomic) IBOutlet UILabel *serviceTravelLabel;
@property (weak, nonatomic) IBOutlet UIImageView *serviceMealImageView;
@property (weak, nonatomic) IBOutlet UILabel *serviceMealLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *serviceHorizontalSpaceOne;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *serviceHorizontalSpaceTwo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *serviceBottomLineHeight;

@property (weak, nonatomic) IBOutlet UILabel *serviceDescriptionLabel;

@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentBottomLineHeight;
@property (weak, nonatomic) IBOutlet UIView *commenuUnreadTip;



@property (weak, nonatomic) IBOutlet LCMemberCollectionView *memberCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *memberCollectionBottomLineHeight;


@property (weak, nonatomic) IBOutlet LCRouteTableView *routeTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *routeTableViewTipSpaceToUpLine;

@property (nonatomic, assign) NSInteger routeSelectedIndex;


@property (weak, nonatomic) IBOutlet UIButton *quitButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *endLineToScrollViewHeight;

@property (nonatomic, strong) LCShareView *shareView;
@end

@implementation LCReceptionDetailVC

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self todoAfterViewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //显示NavigationBar， 因为app中有的NavigationController有可能隐藏bar
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //显示已有数据，同时更新最新数据
    if (self.receptionPlan) {
        [self updateShow];
        
        [self getReceptionDetailByID:self.receptionPlan.planGuid];
    }
}

- (void)viewDidLayoutSubviews{
    if (![self haveLayoutSubViews]) {
        [self loadCustomizedUI];
        //[self updateShow];
    }
    [super viewDidLayoutSubviews];
    
    
    //update service icon's space
    float serviceSpace = (self.servicePanel.frame.size.width - self.servicePlayImageView.frame.size.width*4 ) / 3.0;
    self.serviceHorizontalSpaceOne.constant = serviceSpace;
    self.serviceHorizontalSpaceTwo.constant = serviceSpace;
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    switch (self.scrollType) {
        case PlanDetailScrollToTop:
            [self.wholeVerticalScrollView scrollRectToVisible:CGRectMake(0, 0, 10, 10) animated:YES];
            break;
        case PlanDetailNotScroll:
            break;
        case PlanDetailScrollToBottom:
            [self.wholeVerticalScrollView scrollRectToVisible:CGRectMake(0, self.wholeVerticalScrollView.contentSize.height-10, 10, 10) animated:YES];
            break;
        default:
            break;
    }
    self.scrollType = PlanDetailNotScroll;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

#pragma mark - Public Interface
- (void)setReceptionPlan:(LCReceptionPlan *)receptionPlan{
    _receptionPlan = receptionPlan;
    if ([LCStringUtil isNullString:receptionPlan.destinationName]) {
        //空计划，重新从网络获取详情
        _receptionPlan = nil;
        [self showHudInView:self.view hint:nil];
        [self getReceptionDetailByID:receptionPlan.planGuid];
    }
}

#pragma mark - SetUI
- (void)todoAfterViewDidLoad{
    self.title = @"招待详情";
    
    if (IS_IPHONE_4_4S || IS_IPHONE_5_5S) {
        self.coverImageContentTopSpace.constant = 8;
        self.coverMemberTopSpace.constant = 10;
    }else{
        self.coverImageContentTopSpace.constant = 20;
        self.coverMemberTopSpace.constant = 30;
    }
    
    self.coverImageView.imageType = AFNImageTypeBlurredShowNormal;
    self.coverImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapImgView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImgViewHandle)];
    [self.coverImageView addGestureRecognizer:tapImgView];
    //self.coverImageView.delegate = self;
    
    //add shadow
    self.destinationLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.destinationLabel.layer.shadowOpacity = 0.5;
    self.destinationLabel.layer.shadowOffset = CGSizeMake(1, 1);
    self.destinationLabel.layer.shadowRadius = 1;
    self.destinationLabel.layer.shouldRasterize = YES;
    
    self.timeLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.timeLabel.layer.shadowOpacity = 0.5;
    self.timeLabel.layer.shadowOffset = CGSizeMake(1, 1);
    self.timeLabel.layer.shadowRadius = 1;
    self.timeLabel.layer.shouldRasterize = YES;
    
    self.coverTimeLeftLine.layer.shadowColor = [UIColor blackColor].CGColor;
    self.coverTimeLeftLine.layer.shadowOpacity = 0.5;
    self.coverTimeLeftLine.layer.shadowOffset = CGSizeMake(1, 1);
    self.coverTimeLeftLine.layer.shadowRadius = 1;
    self.coverTimeLeftLine.layer.shouldRasterize = YES;
    
    self.coverTimeRightLine.layer.shadowColor = [UIColor blackColor].CGColor;
    self.coverTimeRightLine.layer.shadowOpacity = 0.5;
    self.coverTimeRightLine.layer.shadowOffset = CGSizeMake(1, 1);
    self.coverTimeRightLine.layer.shadowRadius = 1;
    self.coverTimeRightLine.layer.shouldRasterize = YES;
    
    self.createrBottomLineHeight.constant = 0.5;
    self.buttonPanelLeftLineWidth.constant = 0.5;
    self.buttonPanelRightLineWidth.constant = 0.5;
    self.buttonPanelBottomLineHeight.constant = 0.5;
    self.memberCollectionBottomLineHeight.constant = 0.5;
    self.serviceBottomLineHeight.constant = 0.5;
    self.commentBottomLineHeight.constant = 0.5;
    
    //update button panel, for favor, share, prise
    self.buttonPanel.layer.borderWidth = 0.5;
    self.buttonPanel.layer.borderColor = UIColorFromR_G_B_A(195, 190, 185, 1).CGColor;
    self.buttonPanel.layer.cornerRadius = 3;
    
    [self.talkButton updateLayoutToVerticalAlineWithVerticalSpace:4];
    
    [self.favorButton setImage:[UIImage imageNamed:@"DetailFavorOffIcon"] forState:UIControlStateNormal];
    [self.favorButton setTitle:@"0" forState:UIControlStateNormal];
    
    [self.shareButton setImage:[UIImage imageNamed:@"DetailShareIcon"] forState:UIControlStateNormal];
    [self.shareButton setTitle:@"0" forState:UIControlStateNormal];
    
    [self.priseButton setImage:[UIImage imageNamed:@"DetailPriseOffIcon"] forState:UIControlStateNormal];
    [self.priseButton setTitle:@"0" forState:UIControlStateNormal];
    
    [self.joinButton addTarget:self action:@selector(joinButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //[self.talkButton addTarget:self action:@selector(talkButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.favorButton addTarget:self action:@selector(favorButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.priseButton addTarget:self action:@selector(priseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.commentButton addTarget:self action:@selector(commentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.routeTableView.routeTableDelegate = self;
}
- (void)tapImgViewHandle {
    ZLog(@"tapImgViewHandle {");
    LCImageModel *imgModel = [[LCImageModel alloc]init];
    imgModel.imageUrl = self.receptionPlan.imageCover;
    imgModel.imageUrlThumb = self.receptionPlan.imageCoverThumb;
    [LCViewSwitcher presentPhotoScannerToShow:@[imgModel] fromIndex:0];
}
- (void)loadCustomizedUI{
    if (!self.coverMemberViewContent) {
        self.coverMemberViewContent = [LCCoverMemberView createInstance];
        self.coverMemberViewContent.frame = self.coverMemberView.bounds;
        self.coverMemberViewContent.delegate = self;
        [self.coverMemberView addSubview:self.coverMemberViewContent];
        
        
        if (self.receptionPlan.isMember) {
            self.coverMemberViewContent.members = self.receptionPlan.memberList;
        }
    }
}

#pragma mark - LCCoverMemberViewDelegate
- (void)talkButtonClicked {
    /// 存储群聊的联系人.
    [LCXMPPUtil saveChatPlanGroup:self.receptionPlan];
    ChatViewController *controller = [[ChatViewController alloc] initWithPlan:self.receptionPlan];
    [self.navigationController pushViewController:controller animated:APP_ANIMATION];
}

- (void)coverMemberView:(LCCoverMemberView *)memberView didClickUserIndex:(NSInteger)userIndex{
    if (self.receptionPlan.memberList.count > userIndex) {
        [LCViewSwitcher pushToShowUserInfo:[self.receptionPlan.memberList objectAtIndex:userIndex] onNavigationVC:self.navigationController];
    }
}
#pragma mark - ButtonClick Action
-(void)editButtonClick:(id)sender{
    RLog(@"edit button click");
    LCNewReceptionPlanVC *vc = (LCNewReceptionPlanVC *)[LCStoryboardManager viewControllerWithFileName:SBNameReceptionPlan identifier:VCIDNewReceptionPlan];
    [LCDataManager sharedInstance].receptionPlan = self.receptionPlan;
    vc.type = NRT_EDIT_RECEPTION;
    [self.navigationController pushViewController:vc animated:APP_ANIMATION];
}

- (IBAction)chatAction:(id)sender {
    ZLog(@"the publish user id is %@", self.receptionPlan.createrUuid);
    ZLog(@"the publish user avatar is %@", self.receptionPlan.createrAvatar);
    ZLog(@"the publish user name is %@", self.receptionPlan.createrNick);
    NSString *uuid = [LCDataManager sharedInstance].userInfo.uuid;
    LCUserInfo *userInfo = [self.receptionPlan.memberList objectAtIndex:0];
    if ([uuid isEqualToString:userInfo.uuid]) {
        [YSAlertUtil alertOneMessage:@"不能和自己聊天！"];
    }else{
        [LCXMPPUtil saveChatContact:userInfo withType:CHAT_CONTACT_PRIVATE_CHAT];
        ChatViewController *controller = [[ChatViewController alloc] initWithUser:userInfo];
        [self.navigationController pushViewController:controller animated:APP_ANIMATION];
    }
}

- (void)joinButtonClick:(UIButton *)sender{
    [self disableButtons];
    LCPlanApi *planApi = [[LCPlanApi alloc]initWithDelegate:self];
    [planApi joinPlanGuid:self.receptionPlan.planGuid planType:self.receptionPlan.planType];
}
- (void)favorButtonClick:(UIButton *)sender{
    [self disableButtons];
    LCPlanApi *api = [[LCPlanApi alloc]initWithDelegate:self];
    if (self.receptionPlan.isFavored) {
        [api cancelFavorPlan:self.receptionPlan.planGuid planType:self.receptionPlan.planType];
    }else{
        [api favorPlan:self.receptionPlan.planGuid planType:self.receptionPlan.planType];
    }
}
- (void)shareButtonClick:(UIButton *)sender{
    if (!self.shareView) {
        self.shareView = [LCShareView createInstance];
        self.shareView.delegate = self;
    }
    [LCShareView showShareView:self.shareView onViewController:self forPlan:self.receptionPlan];
}
- (void)priseButtonClick:(UIButton *)sender{
    [self disableButtons];
    LCPlanApi *api = [[LCPlanApi alloc]initWithDelegate:self];
    if (self.receptionPlan.isLiked) {
        [api cancelPrisePlan:self.receptionPlan.planGuid planType:self.receptionPlan.planType];
    }else{
        [api prisePlan:self.receptionPlan.planGuid planType:self.receptionPlan.planType];
    }
}
- (void)commentButtonClick:(UIButton *)sender{
    [self performSegueWithIdentifier:SEGUE_PUSH_COMMENTVC sender:self];
}

- (IBAction)quitButtonClick:(id)sender {
    __weak __typeof(self) weakSelf = self;
    if (self.receptionPlan.memberList.count <=1) {
        [YSAlertUtil alertTwoButton:@"确定" btnTwo:@"取消" withTitle:@"提示" msg:@"确定要删除群吗?" callBack:^(NSInteger chooseIndex){
            __strong __typeof(self) strongSelf = weakSelf;
            if (chooseIndex==0) {
                [strongSelf disableButtons];
                LCPlanApi *planApi = [[LCPlanApi alloc]initWithDelegate:self];
                [planApi deletePlanGuid:self.receptionPlan.planGuid planType:self.receptionPlan.planType];
            }
        }];
    }else{
        [YSAlertUtil alertTwoButton:@"确定" btnTwo:@"取消" withTitle:@"提示" msg:@"确定要退出群吗?" callBack:^(NSInteger chooseIndex){
            __strong __typeof(self) strongSelf = weakSelf;
            if (chooseIndex==0) {
                [strongSelf disableButtons];
                LCPlanApi *planApi = [[LCPlanApi alloc]initWithDelegate:self];
                [planApi quitPlanGuid:self.receptionPlan.planGuid planType:self.receptionPlan.planType];
            }
        }];
    }
}

- (IBAction)createrAvatarTapAction:(UITapGestureRecognizer *)sender {
    if (self.receptionPlan.memberList.count>0) {
        [LCViewSwitcher pushToShowUserInfo:[self.receptionPlan.memberList firstObject] onNavigationVC:self.navigationController];
    }
}

#pragma mark - LCMemberCollectionView Delegate
- (void)memberCollectionView:(LCMemberCollectionView *)memberColectionView didSelectIndex:(NSInteger)index{
    if (self.receptionPlan.memberList.count > index) {
        [LCViewSwitcher pushToShowUserInfo:[self.receptionPlan.memberList objectAtIndex:index] onNavigationVC:self.navigationController];
    }
}

#pragma mark - LCPlanApiDelegate
- (void)planApi:(LCPlanApi *)api didJoinPlanWithError:(NSError *)error{
    [self enableButtons];
    if (!error) {
        //Mob statistics
        [MobClick event:MobEJoinReception];
        //set self user as member of the plan
        self.receptionPlan.isMember = 1;
        //add self user to the member list
        self.receptionPlan.memberList = [self.receptionPlan.memberList arrayByAddingObject:[LCDataManager sharedInstance].userInfo];
        //add user num by 1
        self.receptionPlan.userNum++;
        //tip the end user
        [YSAlertUtil tipOneMessage:@"加入成功!" delay:TIME_FOR_RIGHT_TIP];
        /// 存储群聊的联系人.
        [LCXMPPUtil saveChatPlanGroup:self.receptionPlan];
        /// 打开群聊天
        [self talkButtonClicked];
    }else{
        self.receptionPlan.isMember = 0;
        //同时加入过多计划
        //error.code == ErrCodeJoinMultiPlanConflict;
        [YSAlertUtil tipOneMessage:error.domain delay:TIME_FOR_ERROR_TIP];
//        [self showHint:error.domain];
    }
    [self updateShow];
}
- (void)planApi:(LCPlanApi *)api didQuitPlanWithError:(NSError *)error{
    [self enableButtons];
    if (!error) {
        [LCXMPPUtil deleteJid:self.receptionPlan.roomID];
        [MobClick event:MobEQuitReception];
        //set self user as not member of the plan
        self.receptionPlan.isMember = 0;
        //minus usernum by 1
        self.receptionPlan.userNum--;
        //remove self user from the member list of the plan
        NSArray *members = self.receptionPlan.memberList;
        NSMutableArray *muteArr = [NSMutableArray arrayWithArray:members];
        for (LCUserInfo *u in muteArr) {
            if ([u.uuid isEqualToString:[LCDataManager sharedInstance].userInfo.uuid]) {
                [muteArr removeObject:u];
                break;
            }
        }
        self.receptionPlan.memberList = muteArr;
        //tip the end user
        [YSAlertUtil tipOneMessage:@"退出成功!" delay:TIME_FOR_RIGHT_TIP];
        [[NSNotificationCenter defaultCenter]postNotificationName:NotificationShouldRefreshPlanListFromServer object:nil];
    }else{
        if (QUIT_PLAN_DIDKICK_ERROR == error.code) {
            [LCXMPPUtil deleteJid:self.receptionPlan.roomID];
        }
        self.receptionPlan.isMember = 1;
        [YSAlertUtil tipOneMessage:error.domain delay:TIME_FOR_ERROR_TIP];
    }
    [self updateShow];
}
- (void)planApi:(LCPlanApi *)api didDeletePlanWithError:(NSError *)error{
    [self enableButtons];
    if (!error) {
        RLog(@"quit plan succeed");
        [LCXMPPUtil deleteJid:self.receptionPlan.roomID];
        [[NSNotificationCenter defaultCenter]postNotificationName:NotificationShouldRefreshPlanListFromServer object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        RLog(@"delete plan failed. %@",error);
        [YSAlertUtil tipOneMessage:error.domain delay:TIME_FOR_ERROR_TIP];
    }
}
#pragma mark Prise - Share - Favor
- (void)planApi:(LCPlanApi *)api didFavorPlan:(NSInteger)favorNumber withError:(NSError *)error{
    [self enableButtons];
    if (!error) {
        [LCDataManager sharedInstance].isAutoUpdateFavorPlanList = YES;
        [MobClick event:MobEFavorReception];
        self.receptionPlan.isFavored = 1;
        self.receptionPlan.favorNum = favorNumber;
        [YSAlertUtil tipOneMessage:@"收藏成功" delay:TIME_FOR_RIGHT_TIP];
        [self updateFavorButtonShow];
    }else{
        [YSAlertUtil tipOneMessage:error.domain delay:TIME_FOR_ERROR_TIP];
    }
}
- (void)planApi:(LCPlanApi *)api didCancelFavorPlan:(NSInteger)favorNumber withError:(NSError *)error{
    [self enableButtons];
    if (!error) {
        [LCDataManager sharedInstance].isAutoUpdateFavorPlanList = YES;
        self.receptionPlan.isFavored = 0;
        self.receptionPlan.favorNum = favorNumber;
        [YSAlertUtil tipOneMessage:@"取消收藏成功" delay:TIME_FOR_RIGHT_TIP];
        [self updateFavorButtonShow];
    }else{
        [YSAlertUtil tipOneMessage:error.domain delay:TIME_FOR_ERROR_TIP];
    }
}
- (void)planApi:(LCPlanApi *)api didPrisePlan:(NSInteger)priseNumber withError:(NSError *)error{
    [self enableButtons];
    if (!error) {
        [MobClick event:MobELikeReception];
        self.receptionPlan.isLiked = 1;
        self.receptionPlan.likeNum = priseNumber;
        [YSAlertUtil tipOneMessage:@"点赞成功" delay:TIME_FOR_RIGHT_TIP];
        [self updatePriseButtonShow];
    }else{
        [YSAlertUtil tipOneMessage:error.domain delay:TIME_FOR_ERROR_TIP];
    }
}
- (void)planApi:(LCPlanApi *)api didCancelPrisePlan:(NSInteger)priseNumber withError:(NSError *)error{
    [self enableButtons];
    if (!error) {
        self.receptionPlan.isLiked = 0;
        self.receptionPlan.likeNum = priseNumber;
        [YSAlertUtil tipOneMessage:@"取消点赞成功" delay:TIME_FOR_RIGHT_TIP];
        [self updatePriseButtonShow];
    }else{
        [YSAlertUtil tipOneMessage:error.domain delay:TIME_FOR_ERROR_TIP];
    }
}
- (void)planApi:(LCPlanApi *)api didAddShareNumber:(NSInteger)shareNumber withError:(NSError *)error{
    [self enableButtons];
    if (!error) {
        self.receptionPlan.forwardNum = shareNumber;
        [self updateShareButtonShow];
    }else{
    }
}

#pragma mark - LCShareViewDelegate
- (void)cancelShareAction
{
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){}];
}
- (void)shareWeixinAction:(LCPlan *)plan
{
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){
        [LCShareUtil shareWeixinAction:plan presentedController:self];
    }];
    [self netRequestAddShareNumber];
}

- (void)shareWeixinTimeLineAction:(LCPlan *)plan
{
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){
        [LCShareUtil shareWeixinTimeLineAction:plan presentedController:self];
    }];
    [self netRequestAddShareNumber];
}

- (void)shareWeiboAction:(LCPlan *)plan
{
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){
        [LCShareUtil shareWeiboAction:plan presentedController:self];
    }];
    [self netRequestAddShareNumber];
}

- (void)shareRenrenAction:(LCPlan *)plan
{
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){
        [LCShareUtil shareRenrenAction:plan presentedController:self];
    }];
    [self netRequestAddShareNumber];
}

- (void)shareDuckrAction:(LCPlan *)plan
{
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){
        [LCShareUtil shareDuckrAction:plan presentedController:self];
    }];
    [self netRequestAddShareNumber];
}

#pragma mark - Network Request
- (void)netRequestAddShareNumber{
    LCPlanApi *api = [[LCPlanApi alloc]initWithDelegate:self];
    [api addShareNumberToPlan:self.receptionPlan.planGuid planType:self.receptionPlan.planType];
}

#pragma mark - LCReceptionApiDelegate
- (void)receptionApi:(LCReceptionApi *)api didGetReception:(LCReceptionPlan *)receptionPlan withError:(NSError *)error{
    [self hideHudInView];
    if (error) {
        RLog(@"get reception detail error %@",error);
        [YSAlertUtil tipOneMessage:error.domain delay:TIME_FOR_ERROR_TIP];
        
        
        if (self.navigationController) {
            self.view.userInteractionEnabled = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.view.userInteractionEnabled = YES;
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
//        if (error.code == ErrCodePlanNotExist) {
//            if (self.navigationController) {
//                [self.navigationController popViewControllerAnimated:YES];
//            }
//        }
        return;
    }else{
        RLog(@"get reception detail succeed!  %@",receptionPlan);
        //如果已经有计划信息，使用网络请求的内容更新已经有计划
        //否则，使用网络返回的内容替换已有计划
        if (!self.receptionPlan) {
            self.receptionPlan = receptionPlan;
        }else{
            [self.receptionPlan updateValueWithObject:receptionPlan];
        }
        [self updateShow];
    }
}

#pragma mark - RouteTableView Delegate
- (void)routeTableView:(LCRouteTableView *)routeTableView didSelectRoute:(NSInteger)index{
    if (self.receptionPlan.routes && self.receptionPlan.routes.count > index) {
        self.routeSelectedIndex = index;
        [self performSegueWithIdentifier:SEGUE_PRESENT_ROUTESVC sender:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:SEGUE_PRESENT_ROUTESVC]) {
        LCRoutesBrowserVC *routeBrowserVC = segue.destinationViewController;
        
        //屏幕截图
        UIGraphicsBeginImageContext([UIApplication sharedApplication].keyWindow.bounds.size);
        [[UIApplication sharedApplication].keyWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        routeBrowserVC.bgImage = image;
        
        [routeBrowserVC showRoutes:self.receptionPlan.routes atIndex:self.routeSelectedIndex];
    }else if ([segue.identifier isEqualToString:SEGUE_PUSH_COMMENTVC]){
        LCPlanCommentVC *commentVC = (LCPlanCommentVC *)segue.destinationViewController;
        [commentVC showCommentForPlan:self.receptionPlan];
    }
}


- (void)updateShow{
    if (!self.receptionPlan) {
        RLog(@"try to update show with an nil receptionPlan");
        return;
    }
    
    //update navigation bar
    if ([self isManagerOfThePlan]) {
        [self showEditBarButton];
    }else{
        [self hideEditBarButton];
    }
    
    //更新主View
    self.destinationLabel.text = self.receptionPlan.destinationName;
    
    [self.timeLabel setAttributedText:[self getTimeLabelAttributedString:self.receptionPlan]];
    
    [self updateCoverImageView];
    
    if (self.receptionPlan.memberList.count > 0) {
        LCUserInfo *creater = [self.receptionPlan.memberList objectAtIndex:0];
        if ([creater getUserSexEnumValue] == UserSexMale) {
            self.createrSexImageView.image = [UIImage imageNamed:@"DetailSexMale"];
        }else if([creater getUserSexEnumValue] == UserSexFemale){
            self.createrSexImageView.image = [UIImage imageNamed:@"DetailSexFemale"];
        }
        self.createrNameLabel.text = creater.nick;
        self.createrLocationLabel.text = [LCStringUtil getLocationStrWhichMaybeNil:creater.livingPlace];
        [self.createrAvatarImageView setImageWithURL:[NSURL URLWithString:creater.avatarThumbUrl]];
    }
    
    //更新标语和描述
    self.slogonLabel.text = self.receptionPlan.declaration;
    if ([LCStringUtil isNullString:self.receptionPlan.descriptionStr]) {
        self.slogonLabelVerticalToDescriptionLabel.constant = 0;
    }else{
        self.slogonLabelVerticalToDescriptionLabel.constant = 14;
    }
    [self.descriptionLabel setText:self.receptionPlan.descriptionStr withLineSpace:10];
    
    //更新按钮列表
    [self updateFavorButtonShow];
    [self updatePriseButtonShow];
    [self updateShareButtonShow];
    
    //更新群组成员信息
    self.memberListTitleLabel.text = [NSString stringWithFormat:@"群成员 (%ld/%ld)",(unsigned long)self.receptionPlan.memberList.count,(long)self.receptionPlan.scaleMax];
    self.memberCollectionView.users = self.receptionPlan.memberList;
    self.memberCollectionView.memberCollectionViewDelegate = self;
    
    //更新服务信息
    if (self.receptionPlan.serviceAccompany){
        self.servicePlayImageView.image = [UIImage imageNamed:@"DetailServicePlayOn"];
        self.servicePlayLabel.textColor = UIColorFromRGBA(SERVICE_ON_FONTCOLOR, 1);
    }else{
        self.servicePlayImageView.image = [UIImage imageNamed:@"DetailServicePlayOff"];
        self.servicePlayLabel.textColor = UIColorFromRGBA(SERVICE_OFF_FONTCOLOR, 1);
    }
    
    if (self.receptionPlan.serviceDinner){
        self.serviceMealImageView.image = [UIImage imageNamed:@"DetailServiceMealOn"];
        self.serviceMealLabel.textColor = UIColorFromRGBA(SERVICE_ON_FONTCOLOR, 1);
    }else{
        self.serviceMealImageView.image = [UIImage imageNamed:@"DetailServiceMealOff"];
        self.serviceMealLabel.textColor = UIColorFromRGBA(SERVICE_OFF_FONTCOLOR, 1);
    }
    
    if (self.receptionPlan.serviceHotel) {
        self.serviceStayImageView.image = [UIImage imageNamed:@"DetailServiceStayOn"];
        self.serviceStayLabel.textColor = UIColorFromRGBA(SERVICE_ON_FONTCOLOR, 1);
    }else{
        self.serviceStayImageView.image = [UIImage imageNamed:@"DetailServiceStayOff"];
        self.serviceStayLabel.textColor = UIColorFromRGBA(SERVICE_OFF_FONTCOLOR, 1);
    }
    
    if (self.receptionPlan.serviceCar) {
        self.serviceTravelImageView.image = [UIImage imageNamed:@"DetailServiceTravelOn"];
        self.serviceTravelLabel.textColor = UIColorFromRGBA(SERVICE_ON_FONTCOLOR, 1);
    }else{
        self.serviceTravelImageView.image = [UIImage imageNamed:@"DetailServiceTravelOff"];
        self.serviceTravelLabel.textColor = UIColorFromRGBA(SERVICE_OFF_FONTCOLOR, 1);
    }
    
    [self.serviceDescriptionLabel setText:self.receptionPlan.serviceDesc withLineSpace:10];
    
    //更新路线信息
    self.routeTableView.routeInfos = self.receptionPlan.routes;
    if (self.receptionPlan.routes && self.receptionPlan.routes.count>0) {
        self.routeTableViewTipSpaceToUpLine.constant = 57;
    }else{
        self.routeTableViewTipSpaceToUpLine.constant = 0;
    }
    
    //更新是否已经加入的显示
    //receptionPlan.isMember = 0;
    if (self.receptionPlan.isMember) {
        self.joinButton.hidden = YES;
        self.coverMemberViewContainer.hidden = NO;
        self.coverMemberViewContent.members = self.receptionPlan.memberList;
        
        self.quitButton.hidden = NO;
        self.endLineToScrollViewHeight.constant = 90;
    }else{
        self.joinButton.hidden = NO;
        self.coverMemberViewContainer.hidden = YES;
        
        self.quitButton.hidden = YES;
        self.endLineToScrollViewHeight.constant = 20;
    }
    
    //未读评论的提示
    if (self.receptionPlan.unreadCommentNum > 0) {
        self.commenuUnreadTip.hidden = NO;
    }else{
        self.commenuUnreadTip.hidden = YES;
    }
    
    //更新退出按钮的显示
    if (self.receptionPlan.memberList.count <= 1) {
        [self.quitButton setTitle:@"删除该群" forState:UIControlStateNormal];
    }else{
        [self.quitButton setTitle:@"退出该群" forState:UIControlStateNormal];
    }
    
}

- (void)updateFavorButtonShow{
    if (!self.receptionPlan.isFavored) {
        [self.favorButton setImage:[UIImage imageNamed:@"DetailFavorOffIcon"] forState:UIControlStateNormal];
    }else{
        [self.favorButton setImage:[UIImage imageNamed:@"DetailFavorOnIcon"] forState:UIControlStateNormal];
    }
    [self.favorButton setTitle:[LCStringUtil integerToString:self.receptionPlan.favorNum] forState:UIControlStateNormal];
}
- (void)updateShareButtonShow{
    [self.shareButton setTitle:[LCStringUtil integerToString:self.receptionPlan.forwardNum] forState:UIControlStateNormal];
}
- (void)updatePriseButtonShow{
    if (!self.receptionPlan.isLiked) {
        [self.priseButton setImage:[UIImage imageNamed:@"DetailPriseOffIcon"] forState:UIControlStateNormal];
    }else{
        [self.priseButton setImage:[UIImage imageNamed:@"DetailPriseOnIcon"] forState:UIControlStateNormal];
    }
    [self.priseButton setTitle:[LCStringUtil integerToString:self.receptionPlan.likeNum] forState:UIControlStateNormal];
}

- (void)disableButtons{
    self.joinButton.enabled = NO;
    //self.talkButton.enabled = NO;
    self.priseButton.enabled = NO;
    self.shareButton.enabled = NO;
    self.favorButton.enabled = NO;
    self.quitButton.enabled = NO;
}
- (void)enableButtons{
    self.joinButton.enabled = YES;
    //self.talkButton.enabled = YES;
    self.priseButton.enabled = YES;
    self.shareButton.enabled = YES;
    self.favorButton.enabled = YES;
    self.quitButton.enabled = YES;
}

#pragma mark - About Edit BarButtonItem
- (BOOL)isManagerOfThePlan{
    if (self.receptionPlan.memberList.count>0) {
        LCUserInfo *user = [self.receptionPlan.memberList firstObject];
        if ([user.uuid isEqualToString:[LCDataManager sharedInstance].userInfo.uuid]) {
            return YES;
        }
    }
    return NO;
}
- (void)showEditBarButton{
    if (!self.editBarButton) {
        self.editBarButton = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editButtonClick:)];
    }
    self.navigationItem.rightBarButtonItem = self.editBarButton;
}
- (void)hideEditBarButton{
    self.navigationItem.rightBarButtonItem = nil;
}

#pragma mark - About CoverImageView
- (void)updateCoverImageView{
    self.coverImageView.backgroundColor = [LCImageUtil getColorFromColorStr:self.receptionPlan.coverColor];
    if (self.receptionPlan.isMember) {
        self.coverImageView.imageType = AFNImageTypeBlurredShowBlured;
    }else{
        self.coverImageView.imageType = AFNImageTypeBlurredShowNormal;
    }
    [self.coverImageView setImageWithURL:[NSURL URLWithString:self.receptionPlan.imageCover]];
    
}

- (void)getReceptionDetailByID:(NSString *)planGuid{
    LCReceptionApi *receptionApi = [[LCReceptionApi alloc]init];
    receptionApi.delegate = self;
    [receptionApi getReceptionDetailByID:planGuid];
}
@end
