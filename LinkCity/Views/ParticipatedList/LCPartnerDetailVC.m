//
//  LCPartnerDetailVC.m
//  LinkCity
//
//  Created by roy on 11/18/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCPartnerDetailVC.h"
#import "EGOImageView.h"
#import "LCCoverMemberView.h"
#import "LCPartnerApi.h"
#import "LCPlanApi.h"
#import "LCPlanCommentVC.h"
#import "LCDateUtil.h"
#import "LCMemberCollectionView.h"
#import "ChatViewController.h"
#import "LCXMPPUtil.h"
#import "LCUserInfoVC.h"
#import "LCShareView.h"
#import "LCShareUtil.h"
#import "LCViewSwitcher.h"
#import "LCAFNBlurredImageView.h"

#define SEGUE_PUSHTO_PARTNER_COMMENTVC @"SeguePartnerDetailPushToComment"
@interface LCPartnerDetailVC ()<LCPartnerApiDelegate,LCPlanApiDelegate,LCCoverMemberViewDelegate,LCMemberCollectionViewDelegate,LCShareViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *wholeVerticalScrollView;

@property (nonatomic, strong) UIBarButtonItem *editBarButton;

@property (weak, nonatomic) IBOutlet LCAFNBlurredImageView *coverImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coverImageContentTopSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coverMemberTopSpace;


@property (weak, nonatomic) IBOutlet UILabel *destinationLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIView *coverTimeLeftLine;
@property (weak, nonatomic) IBOutlet UIView *coverTimeRightLine;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;


@property (weak, nonatomic) IBOutlet UIView *coverMemberViewContainer;
@property (weak, nonatomic) IBOutlet UIView *coverMemberView;
@property (strong, nonatomic) LCCoverMemberView *coverMemberViewContent;


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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonPanelLeftLineWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonPanelRightLineWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonPanelBottomLineHeight;


@property (weak, nonatomic) IBOutlet UIButton *favorButton;
@property (weak, nonatomic) IBOutlet UIButton *priseButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (weak, nonatomic) IBOutlet UILabel *memberListTitleLabel;

@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIView *commenuUnreadTip;


@property (weak, nonatomic) IBOutlet LCMemberCollectionView *memberCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *memberBottomLineHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentBottomLineHeight;


@property (weak, nonatomic) IBOutlet UIButton *quitButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *endLineToScrollViewHeight;

@property (nonatomic, strong) LCShareView *shareView;
@end

@implementation LCPartnerDetailVC

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
    if (self.partnerPlan) {
        [self updateShow];
        
        [self getPartnerPlanDetailByID:self.partnerPlan.planGuid];
    }
}

- (void)viewDidLayoutSubviews{
    if (![self haveLayoutSubViews]) {
        [self loadCustomizedUI];
        //[self updateShow];
    }
    [super viewDidLayoutSubviews];
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

#pragma mark - SetUI
- (void)todoAfterViewDidLoad{
    self.title = @"约伴详情";
    
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
    
    //add shadow
    //****************************************************************************
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
    //****************************************************************************
    
    //update button panel, for favor, share, prise
    self.buttonPanel.layer.borderWidth = 0.5;
    self.buttonPanel.layer.borderColor = UIColorFromR_G_B_A(195, 190, 185, 1).CGColor;
    self.buttonPanel.layer.cornerRadius = 3;
    
    [self.talkButton updateLayoutToVerticalAlineWithVerticalSpace:4];
    
    self.createrBottomLineHeight.constant = 0.5;
    self.buttonPanelLeftLineWidth.constant = 0.5;
    self.buttonPanelRightLineWidth.constant = 0.5;
    self.buttonPanelBottomLineHeight.constant = 0.5;
    self.memberBottomLineHeight.constant = 0.5;
    self.commentBottomLineHeight.constant = 0.5;
    
//    [self.favorButton setImage:[UIImage imageNamed:@"DetailFavorOffIcon"] forState:UIControlStateNormal];
//    [self.favorButton setTitle:@"0" forState:UIControlStateNormal];
//    
    [self.shareButton setImage:[UIImage imageNamed:@"DetailShareIcon"] forState:UIControlStateNormal];
    [self.shareButton setTitle:@"0" forState:UIControlStateNormal];
//
//    [self.priseButton setImage:[UIImage imageNamed:@"DetailPriseOffIcon"] forState:UIControlStateNormal];
//    [self.priseButton setTitle:@"0" forState:UIControlStateNormal];
    
    [self.joinButton addTarget:self action:@selector(joinButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.favorButton addTarget:self action:@selector(favorButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.priseButton addTarget:self action:@selector(priseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.commentButton addTarget:self action:@selector(commentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)loadCustomizedUI{
    if (!self.coverMemberViewContent) {
        self.coverMemberViewContent = [LCCoverMemberView createInstance];
        self.coverMemberViewContent.delegate = self;
        self.coverMemberViewContent.frame = self.coverMemberView.bounds;
        [self.coverMemberView addSubview:self.coverMemberViewContent];
        
        if (self.partnerPlan.isMember) {
            self.coverMemberViewContent.members = self.partnerPlan.memberList;
        }
    }
}

- (void)tapImgViewHandle {
    ZLog(@"tapImgViewHandle {");
    LCImageModel *imgModel = [[LCImageModel alloc]init];
    imgModel.imageUrl = self.partnerPlan.imageCover;
    imgModel.imageUrlThumb = self.partnerPlan.imageCoverThumb;
    [LCViewSwitcher presentPhotoScannerToShow:@[imgModel] fromIndex:0];
}

#pragma mark - LCCoverMeberViewDelegate
- (void)talkButtonClicked {
    /// 存储群聊的联系人.
    //Roy 2015.1.13
    //目前看来saveChatPlanGroup 不执行也没关系，不过暂时保留了
    [LCXMPPUtil saveChatPlanGroup:self.partnerPlan];
    ChatViewController *controller = [[ChatViewController alloc] initWithPlan:self.partnerPlan];
    [self.navigationController pushViewController:controller animated:APP_ANIMATION];
}
- (void)coverMemberView:(LCCoverMemberView *)memberView didClickUserIndex:(NSInteger)userIndex{
    if (self.partnerPlan.memberList.count > userIndex) {
        [LCViewSwitcher pushToShowUserInfo:[self.partnerPlan.memberList objectAtIndex:userIndex] onNavigationVC:self.navigationController];
    }
}
#pragma mark - Public Interface
- (void)setPartnerPlan:(LCPartnerPlan *)partnerPlan{
    _partnerPlan = partnerPlan;
    if ([LCStringUtil isNullString:partnerPlan.destinationName]) {
        //空计划，重新从网络获取详情
        _partnerPlan = nil;
        [self showHudInView:self.view hint:nil];
        [self getPartnerPlanDetailByID:partnerPlan.planGuid];
    }
}
#pragma mark - ButtonClick Action
-(void)editButtonClick:(id)sender{
    RLog(@"edit button click");
    LCNewPartnerPlanVC *vc = (LCNewPartnerPlanVC *)[LCStoryboardManager viewControllerWithFileName:SBNamePartnerPlan identifier:VCIDNewPartnerPlan];
    [LCDataManager sharedInstance].partnerPlan = self.partnerPlan;
    vc.type = NPT_EDIT_PARTNER;
    [self.navigationController pushViewController:vc animated:APP_ANIMATION];
}
- (IBAction)chatAction:(id)sender {
    ZLog(@"the publish user id is %@", self.partnerPlan.createrUuid);
    ZLog(@"the publish user avatar is %@", self.partnerPlan.createrAvatar);
    ZLog(@"the publish user name is %@", self.partnerPlan.createrNick);
    NSString *uuid = [LCDataManager sharedInstance].userInfo.uuid;
    LCUserInfo *userInfo = [self.partnerPlan.memberList objectAtIndex:0];
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
    [planApi joinPlanGuid:self.partnerPlan.planGuid planType:self.partnerPlan.planType];
}

- (void)favorButtonClick:(UIButton *)sender{
    [self disableButtons];
    LCPlanApi *api = [[LCPlanApi alloc]initWithDelegate:self];
    if (self.partnerPlan.isFavored) {
        [api cancelFavorPlan:self.partnerPlan.planGuid planType:self.partnerPlan.planType];
    }else{
        [api favorPlan:self.partnerPlan.planGuid planType:self.partnerPlan.planType];
    }
}
- (void)shareButtonClick:(UIButton *)sender{
    if (!self.shareView) {
        self.shareView = [LCShareView createInstance];
        self.shareView.delegate = self;
    }
    [LCShareView showShareView:self.shareView onViewController:self forPlan:self.partnerPlan];
}
- (void)priseButtonClick:(UIButton *)sender{
    [self disableButtons];
    LCPlanApi *api = [[LCPlanApi alloc]initWithDelegate:self];
    if (self.partnerPlan.isLiked) {
        [api cancelPrisePlan:self.partnerPlan.planGuid planType:self.partnerPlan.planType];
    }else{
        [api prisePlan:self.partnerPlan.planGuid planType:self.partnerPlan.planType];
    }
}
- (void)commentButtonClick:(UIButton *)sender{
    [self performSegueWithIdentifier:SEGUE_PUSHTO_PARTNER_COMMENTVC sender:self];
}

- (IBAction)quitButtonClick:(id)sender {
    __weak __typeof(self) weakSelf = self;
    if (self.partnerPlan.memberList.count <=1) {
        [YSAlertUtil alertTwoButton:@"确定" btnTwo:@"取消" withTitle:@"提示" msg:@"确定要删除群吗?" callBack:^(NSInteger chooseIndex){
            __strong __typeof(self) strongSelf = weakSelf;
            if (chooseIndex==0) {
                [strongSelf disableButtons];
                LCPlanApi *planApi = [[LCPlanApi alloc]initWithDelegate:self];
                [planApi deletePlanGuid:self.partnerPlan.planGuid planType:self.partnerPlan.planType];
            }
        }];
    }else{
        [YSAlertUtil alertTwoButton:@"确定" btnTwo:@"取消" withTitle:@"提示" msg:@"确定要退出群吗?" callBack:^(NSInteger chooseIndex){
            __strong __typeof(self) strongSelf = weakSelf;
            if (chooseIndex==0) {
                [strongSelf disableButtons];
                LCPlanApi *planApi = [[LCPlanApi alloc]initWithDelegate:self];
                [planApi quitPlanGuid:self.partnerPlan.planGuid planType:self.partnerPlan.planType];
            }
        }];
    }
}

- (IBAction)createrAvatarTapAction:(id)sender {
    if (self.partnerPlan.memberList.count>0) {
        [LCViewSwitcher pushToShowUserInfo:[self.partnerPlan.memberList firstObject] onNavigationVC:self.navigationController];
    }
}
#pragma mark - LCMemberCollectionView Delegate
- (void)memberCollectionView:(LCMemberCollectionView *)memberColectionView didSelectIndex:(NSInteger)index{
    if (self.partnerPlan.memberList.count > index) {
        LCUserInfo *userinfo = [self.partnerPlan.memberList objectAtIndex:index];
        [LCViewSwitcher pushToShowUserInfo:userinfo onNavigationVC:self.navigationController];
    }
}

#pragma mark - LCPlanApiDelegate
- (void)planApi:(LCPlanApi *)api didJoinPlanWithError:(NSError *)error{
    [self enableButtons];
    if (!error) {
        //Mob statistics
        [MobClick event:MobEJoinPartner];
        //set self user as member of the plan
        self.partnerPlan.isMember = 1;
        //add user num
        self.partnerPlan.userNum++;
        //add self user to the member list
        self.partnerPlan.memberList = [self.partnerPlan.memberList arrayByAddingObject:[LCDataManager sharedInstance].userInfo];
        //tip the end user
        [YSAlertUtil tipOneMessage:@"加入成功!" delay:TIME_FOR_RIGHT_TIP];
        /// 存储群聊的联系人.
        [LCXMPPUtil saveChatPlanGroup:self.partnerPlan];
        /// 打开群聊天
        [self talkButtonClicked];
    }else{
        self.partnerPlan.isMember = 0;
        //同时加入过多计划
        //error.code == ErrCodeJoinMultiPlanConflict;
        [YSAlertUtil tipOneMessage:error.domain delay:TIME_FOR_ERROR_TIP];
    }
    [self updateShow];
}
- (void)planApi:(LCPlanApi *)api didQuitPlanWithError:(NSError *)error{
    [self enableButtons];
    if (!error) {
        RLog(@"quit plan succeed");
        [LCXMPPUtil deleteJid:self.partnerPlan.roomID];
        [MobClick event:MobEQuitPartner];
        //set self user as not member of the plan
        self.partnerPlan.isMember = 0;
        //minum user num
        self.partnerPlan.userNum--;
        //remove self user from the member list of the plan
        NSArray *members = self.partnerPlan.memberList;
        NSMutableArray *muteArr = [NSMutableArray arrayWithArray:members];
        for (LCUserInfo *u in muteArr) {
            if ([u.uuid isEqualToString:[LCDataManager sharedInstance].userInfo.uuid]) {
                [muteArr removeObject:u];
                break;
            }
        }
        self.partnerPlan.memberList = muteArr;
        //tip the end user
        [YSAlertUtil tipOneMessage:@"退出成功!" delay:TIME_FOR_RIGHT_TIP];
        [[NSNotificationCenter defaultCenter]postNotificationName:NotificationShouldRefreshPlanListFromServer object:nil];
    }else{
        RLog(@"quit plan failed. %@",error);
        if (QUIT_PLAN_DIDKICK_ERROR == error.code) {
            /// 删除本地列表.
            [LCXMPPUtil deleteJid:self.partnerPlan.roomID];
        }
        self.partnerPlan.isMember = 1;
        [YSAlertUtil tipOneMessage:error.domain delay:TIME_FOR_ERROR_TIP];
    }
    [self updateShow];
}
- (void)planApi:(LCPlanApi *)api didDeletePlanWithError:(NSError *)error{
    [self enableButtons];
    if (!error) {
        RLog(@"quit plan succeed");
        [LCXMPPUtil deleteJid:self.partnerPlan.roomID];
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
        [MobClick event:MobEFavorPartner];
        self.partnerPlan.isFavored = 1;
        self.partnerPlan.favorNum = favorNumber;
        [LCDataManager sharedInstance].isAutoUpdateFavorPlanList = YES;
        [YSAlertUtil tipOneMessage:@"收藏成功" delay:TIME_FOR_RIGHT_TIP];
        [self updateFavorButtonShow];
    }else{
        [YSAlertUtil tipOneMessage:error.domain delay:TIME_FOR_ERROR_TIP];
    }
}
- (void)planApi:(LCPlanApi *)api didCancelFavorPlan:(NSInteger)favorNumber withError:(NSError *)error{
    [self enableButtons];
    if (!error) {
        self.partnerPlan.isFavored = 0;
        self.partnerPlan.favorNum = favorNumber;
        [LCDataManager sharedInstance].isAutoUpdateFavorPlanList = YES;
        [YSAlertUtil tipOneMessage:@"取消收藏成功" delay:TIME_FOR_RIGHT_TIP];
        [self updateFavorButtonShow];
    }else{
        [YSAlertUtil tipOneMessage:error.domain delay:TIME_FOR_ERROR_TIP];
    }
}
- (void)planApi:(LCPlanApi *)api didPrisePlan:(NSInteger)priseNumber withError:(NSError *)error{
    [self enableButtons];
    if (!error) {
        [MobClick event:MobELikePartner];
        self.partnerPlan.isLiked = 1;
        self.partnerPlan.likeNum = priseNumber;
        [YSAlertUtil tipOneMessage:@"点赞成功" delay:TIME_FOR_RIGHT_TIP];
        [self updatePriseButtonShow];
    }else{
        [YSAlertUtil tipOneMessage:error.domain delay:TIME_FOR_ERROR_TIP];
    }
}
- (void)planApi:(LCPlanApi *)api didCancelPrisePlan:(NSInteger)priseNumber withError:(NSError *)error{
    [self enableButtons];
    if (!error) {
        self.partnerPlan.isLiked = 0;
        self.partnerPlan.likeNum = priseNumber;
        [YSAlertUtil tipOneMessage:@"取消点赞成功" delay:TIME_FOR_RIGHT_TIP];
        [self updatePriseButtonShow];
    }else{
        [YSAlertUtil tipOneMessage:error.domain delay:TIME_FOR_ERROR_TIP];
    }
}
- (void)planApi:(LCPlanApi *)api didAddShareNumber:(NSInteger)shareNumber withError:(NSError *)error{
    if (!error) {
        self.partnerPlan.forwardNum = shareNumber;
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
    [api addShareNumberToPlan:self.partnerPlan.planGuid planType:self.partnerPlan.planType];
}
#pragma mark - LCPartnerApiDelegate
- (void)partnerApi:(LCPartnerApi *)api didGetPartner:(LCPartnerPlan *)partnerPlan withError:(NSError *)error{
    [self hideHudInView];
    if (error) {
        RLog(@"get partner detail error %@",error);
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
    }else{
        RLog(@"get partner detail succeed!   %@",partnerPlan.planGuid);
        //如果已经有计划信息，使用网络请求的内容更新已经有计划
        //否则，使用网络返回的内容替换已有计划
        if (!self.partnerPlan) {
            self.partnerPlan = partnerPlan;
        }else{
            [self.partnerPlan updateValueWithObject:partnerPlan];
        }
        [self updateShow];
    }
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:SEGUE_PUSHTO_PARTNER_COMMENTVC]){
        LCPlanCommentVC *commentVC = (LCPlanCommentVC *)segue.destinationViewController;
        [commentVC showCommentForPlan:self.partnerPlan];
    }
}


- (void)updateShow{
    if (!self.partnerPlan) {
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
    self.destinationLabel.text = self.partnerPlan.destinationName;
    
    [self.timeLabel setAttributedText:[self getTimeLabelAttributedString:self.partnerPlan]];
    
    [self updateCoverImageView];
    //self.coverImageView.imageURL = [NSURL URLWithString:self.partnerPlan.imageCover];
    
    if (self.partnerPlan.memberList.count > 0) {
        LCUserInfo *creater = [self.partnerPlan.memberList objectAtIndex:0];
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
    self.slogonLabel.text = self.partnerPlan.declaration;
    if ([LCStringUtil isNullString:self.partnerPlan.descriptionStr]) {
        self.slogonLabelVerticalToDescriptionLabel.constant = 0;
    }else{
        self.slogonLabelVerticalToDescriptionLabel.constant = 14;
    }
    [self.descriptionLabel setText:self.partnerPlan.descriptionStr withLineSpace:10];
    
    //更新按钮列表
    [self updateFavorButtonShow];
    [self updatePriseButtonShow];
    [self updateShareButtonShow];
    
    //更新群组成员信息
    self.memberListTitleLabel.text = [NSString stringWithFormat:@"群成员 (%ld/%ld)",(unsigned long)self.partnerPlan.memberList.count,(long)self.partnerPlan.scaleMax];
    self.memberCollectionView.users = [[NSArray alloc] init];
    self.memberCollectionView.users = self.partnerPlan.memberList;
    self.memberCollectionView.memberCollectionViewDelegate = self;
    
    //更新是否已经加入的显示
    //receptionPlan.isMember = 0;
    if (self.partnerPlan.isMember) {
        self.joinButton.hidden = YES;
        self.coverMemberViewContainer.hidden = NO;
        self.coverMemberViewContent.members = self.partnerPlan.memberList;
        
        self.quitButton.hidden = NO;
        self.endLineToScrollViewHeight.constant = 90;
    }else{
        self.joinButton.hidden = NO;
        self.coverMemberViewContainer.hidden = YES;
        
        self.quitButton.hidden = YES;
        self.endLineToScrollViewHeight.constant = 20;
    }
    
    //未读评论的提示
    if (self.partnerPlan.unreadCommentNum > 0) {
        self.commenuUnreadTip.hidden = NO;
    }else{
        self.commenuUnreadTip.hidden = YES;
    }
    
    //更新退出按钮的显示
    if (self.partnerPlan.memberList.count <= 1) {
        [self.quitButton setTitle:@"删除该群" forState:UIControlStateNormal];
    }else{
        [self.quitButton setTitle:@"退出该群" forState:UIControlStateNormal];
    }
}

- (void)updateFavorButtonShow{
    if (!self.partnerPlan.isFavored) {
        [self.favorButton setImage:[UIImage imageNamed:@"DetailFavorOffIcon"] forState:UIControlStateNormal];
    }else{
        [self.favorButton setImage:[UIImage imageNamed:@"DetailFavorOnIcon"] forState:UIControlStateNormal];
    }
    [self.favorButton setTitle:[LCStringUtil integerToString:self.partnerPlan.favorNum] forState:UIControlStateNormal];
}
- (void)updateShareButtonShow{
    [self.shareButton setTitle:[LCStringUtil integerToString:self.partnerPlan.forwardNum] forState:UIControlStateNormal];
}
- (void)updatePriseButtonShow{
    if (!self.partnerPlan.isLiked) {
        [self.priseButton setImage:[UIImage imageNamed:@"DetailPriseOffIcon"] forState:UIControlStateNormal];
    }else{
        [self.priseButton setImage:[UIImage imageNamed:@"DetailPriseOnIcon"] forState:UIControlStateNormal];
    }
    [self.priseButton setTitle:[LCStringUtil integerToString:self.partnerPlan.likeNum] forState:UIControlStateNormal];
}

- (void)disableButtons{
    self.joinButton.enabled = NO;
    //self.talkButton.enabled = NO;
    self.priseButton.enabled = NO;
    self.shareButton.enabled = NO;
    self.favorButton.enabled = NO;
    self.commentButton.enabled = NO;
    self.quitButton.enabled = NO;
}
- (void)enableButtons{
    self.joinButton.enabled = YES;
    //self.talkButton.enabled = YES;
    self.priseButton.enabled = YES;
    self.shareButton.enabled = YES;
    self.favorButton.enabled = YES;
    self.commentButton.enabled = YES;
    self.quitButton.enabled = YES;
}

#pragma mark - About Edit BarButtonItem
- (BOOL)isManagerOfThePlan{
    if (self.partnerPlan.memberList.count>0) {
        LCUserInfo *user = [self.partnerPlan.memberList firstObject];
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
    self.coverImageView.backgroundColor = [LCImageUtil getColorFromColorStr:self.partnerPlan.coverColor];
    if (self.partnerPlan.isMember) {
        self.coverImageView.imageType = AFNImageTypeBlurredShowBlured;
    }else{
        self.coverImageView.imageType = AFNImageTypeBlurredShowNormal;
    }
    [self.coverImageView setImageWithURL:[NSURL URLWithString:self.partnerPlan.imageCover]];
}

- (void)getPartnerPlanDetailByID:(NSString *)planGuid{
    LCPartnerApi *api = [[LCPartnerApi alloc]init];
    api.delegate = self;
    [api getPartnerDetailByID:planGuid];
}
@end
