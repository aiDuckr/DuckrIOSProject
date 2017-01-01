//
//  LCPlanDetailUserVC.m
//  LinkCity
//
//  Created by 张宗硕 on 12/12/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCFreePlanDetailVC.h"
#import "LCPlanDetailUserInfoCell.h"
#import "LCTextThreePhotosCell.h"
#import "LCPlanDetailUsersCell.h"
#import "LCUserCommentCell.h"
#import "LCCostPlanJoinIntroCell.h"
#import "LinkCity-Swift.h"
#import "LCOrderHelper.h"
#import "LCUserOrderDetailVC.h"
#import "UIView+BlocksKit.h"

@interface LCFreePlanDetailVC ()<UITableViewDataSource, UITableViewDelegate, LCPlanDetailUserInfoCellDelegate, LCPlanDetailUsersCellDelegate, LCUserCommentCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSArray *commentArray;
@property (retain, nonatomic) UIButton *shareButton;
@property (retain, nonatomic) UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIView *notJoinInView;
@property (weak, nonatomic) IBOutlet UIView *joinedInView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentJoinedInViewWidthConstraint;
@property (weak, nonatomic) IBOutlet UILabel *quitLabel;
@property (weak, nonatomic) IBOutlet UILabel *joinInLabel;
@property (weak, nonatomic) IBOutlet UIImageView *joinInImageView;
@property (weak, nonatomic) IBOutlet UIButton *notJoinInButton;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIImageView *quitImageView;

@property (retain, nonatomic) NSString *orderStr;
@property (nonatomic, strong) LCOrderHelper *orderHelper;
@property (weak, nonatomic) IBOutlet UIImageView *favorImageIcon;
@property (weak, nonatomic) IBOutlet UIView *favorImageView;

@end

@implementation LCFreePlanDetailVC

+ (instancetype)createInstance {
    return (LCFreePlanDetailVC *)[LCStoryboardManager viewControllerWithFileName:SBNamePlanDetail identifier:VCIDPlanDetailUserVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /// 初始化变量.
    [self initVariable];
    /// 初始化导航栏右边按钮.
    [self initNaviRightButton];
    /// 初始化TableView.
    [self initTableView];
    /// 初始化评论阴影遮罩.
    [self initShadowView];
    /// 初始化通知.
    [self initNotifications];
    /// 初始化感兴趣.
    [self initFavorView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    /// 当要显示的是空计划时，是由于deeplink跳转来的，显示hud，当从网络请求数据后会隐藏hud。
    if (!self.plan || [self.plan isEmptyPlan]) {
        [YSAlertUtil showHudWithHint:nil];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)refreshData {
    if (self.cancelAutoRefreshOnce) {
        self.cancelAutoRefreshOnce = NO;
        return ;
    }
    self.orderStr = @"";
    self.commentArray = [[NSArray alloc] init];
    [self requestPlanDetailFromServer];
    [self requestPlanCommentFromServer];
    [self updateShow];
}

- (void)initVariable {
//    self.title = @"邀约详情";
    self.cancelAutoRefreshOnce = NO;
    self.notJoinInView.hidden = NO;
    self.joinedInView.hidden = NO;
    self.commentJoinedInViewWidthConstraint.constant = DEVICE_WIDTH / 3.0f;
}

- (void)initTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 100.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    /// 邀约描述、三张图片和地理位置.
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCTextThreePhotosCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCTextThreePhotosCell class])];
    /// 感兴趣的人.
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCPlanDetailUsersCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCPlanDetailUsersCell class])];
    /// 评论.
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCUserCommentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCUserCommentCell class])];
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefreshAction)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefreshAction)];
}

- (void)initNaviRightButton {
    UIImage *editImage = [[UIImage imageNamed:@"PlanDetailGrayEditIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.editButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
    [self.editButton setImage:editImage forState:UIControlStateNormal];
    [self.editButton addTarget:self action:@selector(editPlanAction) forControlEvents:UIControlEventTouchUpInside];
    self.editButton.hidden = YES;
    
    UIImage *shareImage = [[UIImage imageNamed:@"PlanDetailGrayShareIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _shareButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 0, 40, 44)];
    [_shareButton setImage:shareImage forState:UIControlStateNormal];
    [_shareButton addTarget:self action:@selector(sharePlanAction) forControlEvents:UIControlEventTouchUpInside];
    _shareButton.hidden = YES;
    
    UIView *rightBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    [rightBarView addSubview:self.editButton];
    [rightBarView addSubview:_shareButton];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarView];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -10;
    
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, customBarItem];
}

- (void)initShadowView {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadowViewTapAction:)];
    [self.shadowView addGestureRecognizer:tapGesture];
}

- (void)initNotifications {
    [self addObserveToNotificationNameToRefreshData:URL_ADD_COMMENT_TO_PLAN];
    [self addObserveToNotificationNameToRefreshData:URL_DELETE_COMMENT_OF_PLAN];
    
    //在邀约成员页加入、退出、踢人，回到详情页需要更新
    [self addObserveToNotificationNameToRefreshData:URL_JOIN_PLAN];
    [self addObserveToNotificationNameToRefreshData:URL_DELETE_PLAN];
    [self addObserveToNotificationNameToRefreshData:URL_QUIT_PLAN];
    [self addObserveToNotificationNameToRefreshData:URL_KICKOFF_USRE_OF_PLAN];
    
    [self addObserveToNotificationNameToRefreshData:URL_SEND_PLAN];
    [self addObserveToNotificationNameToRefreshData:URL_SEND_FREE_PLAN];
    [self addObserveToNotificationNameToRefreshData:URL_SEND_ROUTE];
    [self addObserveToNotificationNameToRefreshData:URL_FAVOR_PLAN];
    [self addObserveToNotificationNameToRefreshData:URL_FAVOR_PLAN];
}

- (void)initFavorView {
    [self.favorImageView bk_whenTapped:^{
        //favor
        [self favorAction];
    }];
    if (0 == self.plan.isFavored) {
        [self.favorImageIcon setImage:[UIImage imageNamed:@"PlanDetailThumbUpIcon"]];
    } else {
        [self.favorImageIcon setImage:[UIImage imageNamed:@"PlanDetailThumbDownIcon"]];
    }
}

- (void)requestPlanDetailFromServer {
    [LCNetRequester getPlanDetailFromPlanGuid:self.plan.planGuid callBack:^(LCPlanModel *plan,NSArray * tourpicArray, NSError *error) {
        /// 从deeplink跳进来时，会显示hud，所以网络刷新后隐藏hud.
        [YSAlertUtil hideHud];
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
            if (ErrCodePlanNotExist == error.code) {
                //计划不存在
                //Roy: 当通过点通知、deeplink跳转到App，自动进详情时，如果计划不存在并退出，会导致页面错乱
                //延时退出可以。。。。。。
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        } else {
            self.plan = plan;
            
            //更新本地的聊天会话model
            if (nil != plan) {
                LCChatContactModel *chatContactModel = [LCChatContactModel chatContactModelWithPlan:plan];
                [[LCDataManager sharedInstance].chatContactDic setObject:chatContactModel forKey:[chatContactModel getBareJidString]];
            }
        }
        [self updateShow];
    }];
}

- (void)requestPlanCommentFromServer {
    [LCNetRequester getCommentOfPlan:self.plan.planGuid corderString:self.orderStr callBack:^(NSArray *commentArray, NSString *orderStr, NSError *error) {
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
        } else {
            if ([LCStringUtil isNullString:self.orderStr]) {
                self.commentArray = [[NSArray alloc] initWithArray:commentArray];
            } else {
                if (nil != commentArray && commentArray.count > 0) {
                    NSMutableArray *mutArr = [[NSMutableArray alloc] initWithArray:self.commentArray];
                    [mutArr addObjectsFromArray:commentArray];
                    self.commentArray = mutArr;
                } else {
                    [YSAlertUtil tipOneMessage:LCFooterRefreshEmptyTip yoffset:TipDefaultYoffset delay:TipDefaultDelay];
                }
            }
            self.orderStr = orderStr;
        }
        [self updateShow];
    }];
}

- (void)updateShow {
    if (!self.plan || [self.plan isEmptyPlan]) {
        /// 是一个空计划，不更新显示.
        self.tableView.hidden = YES;
        return;
    } else {
        self.tableView.hidden = NO;
    }
    
    if ([LCStringUtil isNotNullString:self.plan.planShareTitle]) {
        self.shareButton.hidden = NO;
    }
    
    if (0 == self.plan.commentNumber) {
        self.footerView.hidden = NO;
        self.tableView.tableFooterView = self.footerView;
        [self.tableView removeFooter];
    } else {
        self.footerView.hidden = YES;
        self.tableView.tableFooterView = [[UIView alloc] init];
        [self.tableView addFooterWithTarget:self action:@selector(footerRefreshAction)];
    }
    
    LCPlanRelation relation = [self.plan getPlanRelation];
    if (LCPlanRelationCreater == relation) {
        self.quitLabel.text = @"删除";
        self.editButton.hidden = NO;
        self.quitImageView.image = [UIImage imageNamed:@"PlanDetailDeleteIcon"];
    } else if (LCPlanRelationMember == relation) {
        self.quitLabel.text = @"退出";
        self.editButton.hidden = YES;
        self.quitImageView.image = [UIImage imageNamed:@"PlanDetailQuitIcon"];
    }
    
    if (LCPlanRelationCreater == relation || LCPlanRelationMember == relation) {
        self.notJoinInView.hidden = YES;
        self.joinedInView.hidden = NO;
    } else {
        self.notJoinInView.hidden = NO;
        self.joinedInView.hidden = YES;
        if (self.plan.userNum == self.plan.scaleMax) {
            self.joinInLabel.text = @"此约已满";
            self.joinInImageView.image = [UIImage imageNamed:@"PlanDetailGroupChat"];
            self.notJoinInButton.enabled = NO;
        } else {
            self.joinInLabel.text = @"加入";
            self.joinInImageView.image = [UIImage imageNamed:@"PlanDetailJoinButtonIcon"];
            self.notJoinInButton.enabled = YES;
        }
    }
    
    [self.tableView reloadData];
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

-(void)shadowViewTapAction:(id)sender {
    [self hideInputToolBar];
}

- (void)sharePlanAction {
    [MobClick event:Mob_PlanDetail_Share];
    self.shadowView.hidden = YES;
    if (self.inputToolBar) {
        [self.inputToolBar.inputTextView resignFirstResponder];
        [self.inputContainer removeFromSuperview];
    }
    [self sharePlan:self.plan];
}

- (void)editPlanAction {
    if ([self.plan getPlanRelation] == LCPlanRelationCreater) {
        [[LCSendPlanHelper sharedInstance] modify:self.plan];
    }
}

#pragma mark UIButton Actions
- (IBAction)quitPlanActiion:(id)sender {
    switch ([self.plan getPlanRelation]) {
        case LCPlanRelationCreater: {
            [YSAlertUtil alertTwoButton:LCDeletePlanAlertConfirmBtnTitle btnTwo:LCDeletePlanAlertCancelBtnTitle withTitle:nil msg:LCDeletePlanAlertMsg callBack:^(NSInteger chooseIndex) {
                if (0 == chooseIndex){
                    [self doDeletePlan];
                }
            }];
        }
            break;
        case LCPlanRelationMember: {
            [YSAlertUtil alertTwoButton:LCQuitPlanAlertConfirmBtnTitle btnTwo:LCQuitPlanAlertCancelBtnTitle withTitle:nil msg:LCQuitPlanAlertMsg callBack:^(NSInteger chooseIndex) {
                if (0 == chooseIndex) {
                    [self doQuitPlan];
                }
            }];
        }
            break;
        case LCPlanRelationApplying:
        case LCPlanRelationKicked:
        case LCPlanRelationRejected:
        case LCPlanRelationScanner:
            break;
    }
}

- (void)doDeletePlan {
    //删除群的网络请求会导致本页面refreshData
    //当在本页面点删除群时，不需要刷新数据，因此取消掉一次自动刷新
    self.cancelAutoRefreshOnce = YES;
    
    //delete
    //删除群
    [LCNetRequester deletePlan:self.plan.planGuid callBack:^(NSError *error) {
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
        }else{
            [YSAlertUtil tipOneMessage:@"删除成功" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
            
            //下线群聊
            [[LCXMPPMessageHelper sharedInstance] getRoomOfflineWithRoomBareJid:self.plan.roomId];
            
            //删除聊天记录和通讯录和红点
            NSString *bareJidStr = self.plan.roomId;
            [LCXMPPUtil deleteChatMsg:bareJidStr];
            [LCXMPPUtil deleteChatContact:bareJidStr];
            [[LCDataManager sharedInstance] clearUnreadNumForBareJidStr:bareJidStr];
            
            
            //Roy 2015.6.11
            //如果在发邀约成功页进到详情，点删除邀约，直接dismiss整个发邀约流程
            if (self.presentingViewController) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
    }];
}

- (void)doQuitPlan {
    //quit
    //先发一条系统消息
//    NSString *systemMsg = [LCUIConstants getQuitPlanMessageWithUserNick:[LCDataManager sharedInstance].userInfo.nick];
//    [[LCXMPPMessageHelper sharedInstance] sendChatSystemInfo:systemMsg toBareJidString:self.plan.roomId isGroup:YES];
    
    //退出群
    [LCNetRequester quitPlan:self.plan.planGuid callBack:^(NSError *error) {
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
        }else{
            [YSAlertUtil tipOneMessage:@"退出成功" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
            
            //下线群聊
            [[LCXMPPMessageHelper sharedInstance] getRoomOfflineWithRoomBareJid:self.plan.roomId];
            
            //删除聊天记录和通讯录和红点
            NSString *bareJidStr = self.plan.roomId;
            [LCXMPPUtil deleteChatMsg:bareJidStr];
            [LCXMPPUtil deleteChatContact:bareJidStr];
            [[LCDataManager sharedInstance] clearUnreadNumForBareJidStr:bareJidStr];
            
            //如果VC栈中存在聊天页，直接pop到顶
            for (UIViewController *vc in self.navigationController.viewControllers){
                if ([vc isKindOfClass:[LCChatBaseVC class]]) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    break;
                }
            }
        }
    }];
}

- (IBAction)commentButtonAction:(id)sender {
    [MobClick event:Mob_PlanDetail_Comment];
    
    if ([self haveLogin]) {
        if (nil != self.commentArray && self.commentArray.count > 0) {
            NSIndexPath *scrollIndexPath = nil;
            if (0 != self.plan.favorNumber) {
                scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
            } else {
                scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:2];
            }
            [self.tableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        [self showInputToolBarWithPlaceHolder:@"添加留言" withReplyCommentId:DefaultCommentReplyToId];
    } else {
        [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
    }
}

- (IBAction)groupChatAction:(id)sender {
    if (![self haveLogin]) {
        [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
        return ;
    }
    [LCViewSwitcher pushToShowChatWithPlanVC:self.plan on:self.navigationController];
}

- (void)favorAction {
    if (![self haveLogin]) {
        [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
        return ;
    }
    if (self.plan.isFavored == 0) {
        [self.favorImageIcon setImage:[UIImage imageNamed:@"PlanDetailThumbDownIcon"]];
        self.plan.isFavored = 1;
        [LCNetRequester favorPlan:self.plan.planGuid withType: 1 callBack:^(LCPlanModel *plan, NSError *error){
            if (error) {
                [YSAlertUtil tipOneMessage:error.domain];
            }
        }];
    } else {
        [self.favorImageIcon setImage:[UIImage imageNamed:@"PlanDetailThumbUpIcon"]];
        self.plan.isFavored = 0;
        [LCNetRequester favorPlan:self.plan.planGuid withType: 0 callBack:^(LCPlanModel *plan, NSError *error){
            if (error) {
                [YSAlertUtil tipOneMessage:error.domain];
            }
        }];
    }
    
}

- (IBAction)applyButtonAction:(id)sender {
    if (![self haveLogin]) {
        [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
    } else {
        /// 加入邀约 不需要支付
        [YSAlertUtil showHudWithHint:nil];
        [LCNetRequester joinPlan:self.plan.planGuid callBack:^(LCPlanModel *plan ,NSError *error) {
            [YSAlertUtil hideHud];
            if (error) {
                [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
            } else {
                self.plan = plan;
                [self updateShow];
                switch ([self.plan getPlanRelation]) {
                    case LCPlanRelationApplying: {
                        [YSAlertUtil tipOneMessage:@"申请成功!" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
                    }
                        break;
                    case LCPlanRelationCreater:
                    case LCPlanRelationMember: {
                        [YSAlertUtil tipOneMessage:@"加入成功!" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
                        
                        /// 发一条群聊消息 ---期间会get room online.
                        NSString *systemMsg = [LCUIConstants getJoinPlanMessageWithUserNick:[LCDataManager sharedInstance].userInfo.nick];
                        [[LCXMPPMessageHelper sharedInstance] sendChatSystemInfo:systemMsg toBareJidString:self.plan.roomId isGroup:YES];
                        /// 先发一条系统消息.
                        
                        /// 延时跳转到聊天.
                        /// 是为了先发送签到信息，再跳到聊天页，以便在聊天页加载消息时可以加载出最新发送的签到.
                        /// 否则不显示签到，下次进入聊天页时才显示.
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [YSAlertUtil hideHud];
                            [LCViewSwitcher pushToShowChatWithPlanVC:self.plan on:self.navigationController];
                        });
                    }
                        break;
                    case LCPlanRelationKicked:
                    case LCPlanRelationRejected:
                    case LCPlanRelationScanner: {
                        
                    }
                        break;
                }
            }
        }];
    }
}

#pragma mark - UITableView
#pragma mark Header Refresh
- (void)headerRefreshAction {
    [self refreshData];
}

- (void)footerRefreshAction {
    [self requestPlanCommentFromServer];
}

#pragma mark TableView Cell Delegate
- (void)planDetailUserInfoCellToViewUserDetail:(LCPlanDetailUserInfoCell *)cell {
    if (nil != self.plan.memberList && self.plan.memberList.count > 0) {
        LCUserModel *user = [self.plan.memberList firstObject];
        [LCViewSwitcher pushToShowUserInfoVCForUser:user on:self.navigationController];
    }
}

- (void)planDetailUserInfoCellToViewPlace:(NSString *)placeName isDepart:(BOOL)isDepart{
    if ([LCStringUtil isNotNullString:placeName]) {
        [LCViewSwitcher pushToShowPlaceSearchResultForPlace:placeName isDepart:isDepart on:self.navigationController];
    }
}

- (void)planDetailUsersCellToViewMoreUsersDetail:(LCPlanDetailUsersCell *)cell {
    [MobClick event:Mob_PlanDetail_SeeMember];
    
    if ([self haveLogin]) {
        [LCViewSwitcher pushToShowPlanMemberVCForPlan:self.plan on:self.navigationController];
    } else {
        [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
    }
}

- (void)planDetailUsersCellToViewUserDetail:(LCUserModel *)user {
    [LCViewSwitcher pushToShowUserInfoVCForUser:user on:self.navigationController];
}

- (void)userCommentToViewUserDetail:(LCUserModel *)user {
    [LCViewSwitcher pushToShowUserInfoVCForUser:user on:self.navigationController];
}

#pragma mark UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0.0;
    if (2 == section) {
        if (0 == self.plan.favorNumber) {
            height = 52.0;
        } else {
            height = 40.0;
        }
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)];
    if (2 == section) {
        UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, DEVICE_WIDTH, 40.0)];
        commentView.backgroundColor = [UIColor whiteColor];
        /// 评论图标.
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 15.0, 15.0, 13.0)];
        imageView.image = [UIImage imageNamed:@"PlanDetailCommentHintIcon"];
        [commentView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35.0, 14.0, 100.0, 16.0)];
        label.textColor = UIColorFromRGBA(0x2c2a28, 1.0);
        label.text = [NSString stringWithFormat:@"留言 %ld", (long)self.plan.commentNumber];
        [commentView addSubview:label];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 39.5, DEVICE_WIDTH, 0.5)];
        lineView.backgroundColor = DefaultSpalineColor;
        [commentView addSubview:lineView];
        
        if (0 == self.plan.favorNumber) {
            view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, DEVICE_WIDTH, 52.0)];
            view.backgroundColor = [UIColor clearColor];
            commentView.frame = CGRectMake(0.0, 12.0, DEVICE_WIDTH, 40.0);
            [view addSubview:commentView];
        } else {
            view = commentView;
        }
    }
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger num = 0;
    if (0 == section) {
        num = 2;
    } else if (1 == section) {
        if (0 != self.plan.favorNumber) {
            num = 1;
        }
    } else if (2 == section) {
        if (nil != self.commentArray && self.commentArray.count > 0) {
            num = self.commentArray.count;
        }
    }
    return num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (0 == indexPath.section) {
        if (0 == indexPath.row) {
            LCPlanDetailUserInfoCell *userInfoCell = [tableView dequeueReusableCellWithIdentifier:@"PlanDetailUserInfoCell" forIndexPath:indexPath];
            userInfoCell.delegate = self;
            [userInfoCell updateShowUserInfo:self.plan];
            cell = userInfoCell;
        } else if (1 == indexPath.row) {
            LCTextThreePhotosCell *photoCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCTextThreePhotosCell class]) forIndexPath:indexPath];
            [photoCell updateShowTextThreePhotos:self.plan];
            cell = photoCell;
        }
    } else if (1 == indexPath.section) {
        LCPlanDetailUsersCell *usersCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCPlanDetailUsersCell class]) forIndexPath:indexPath];
        usersCell.delegate = self;
        [usersCell updateShowDetailUsers:self.plan];
        cell = usersCell;
    } else if (2 == indexPath.section) {
        if (nil != self.commentArray && self.commentArray.count > 0) {
            LCUserCommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCUserCommentCell class]) forIndexPath:indexPath];
            commentCell.delegate = self;
            LCCommentModel *comment = [self.commentArray objectAtIndex:indexPath.row];
            [commentCell updateShowComment:comment];
            cell = commentCell;
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (2 == indexPath.section && indexPath.row < self.commentArray.count) {
        if ([self haveLogin]) {
            if (nil != self.commentArray && self.commentArray.count > 0) {
                LCCommentModel *comment = [self.commentArray objectAtIndex:indexPath.row];
                NSInteger commentId = [LCStringUtil idToNSInteger:comment.commentId];
                if ([[LCDataManager sharedInstance].userInfo.uUID isEqualToString:comment.user.uUID]) {
                    [YSAlertUtil tipOneMessage:@"不能给自己留言，左滑可删除留言"];
                } else {
                    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
                    [self.tableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                    [self showInputToolBarWithPlaceHolder:[NSString stringWithFormat:@"回复@%@:", comment.user.nick] withReplyCommentId:commentId];
                }
            }
        } else {
            [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (2 == indexPath.section) {
        if (nil != self.commentArray && self.commentArray.count > 0) {
            return YES;
        }
    }
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (2 == indexPath.section && nil != self.commentArray && self.commentArray.count > 0) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            /// 删除评论.
            LCCommentModel *aComment = [self.commentArray objectAtIndex:indexPath.row];
            [LCNetRequester deleteCommentOfPlanWithCommentID:aComment.commentId callBack:^(NSError *error) {
                if (error) {
                    [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
                } else {
                    NSMutableArray *mutArray = [[NSMutableArray alloc] initWithArray:self.commentArray];
                    [mutArray removeObjectAtIndex:indexPath.row];
                    self.commentArray = mutArray;
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                
                [self updateShow];
            }];
        }
    }
}

@end
