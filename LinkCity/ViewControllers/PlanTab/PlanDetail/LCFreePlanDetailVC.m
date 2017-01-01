//
//  LCPlanDetailUserVC.m
//  LinkCity
//
//  Created by 张宗硕 on 12/12/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCFreePlanDetailVC.h"
#import "LCPlanDetailUserInfoCell.h"
#import "LCIconTextArrowCell.h"
#import "LCTextThreePhotosCell.h"
#import "LCPlanDetailUsersCell.h"
#import "LCUserCommentCell.h"
#import "LCPlanDetailNoCommentCell.h"

#define COMMENT_BASE_PLACEHOLDER @"添加评论"

@interface LCFreePlanDetailVC ()<UITableViewDataSource, UITableViewDelegate, LCPlanDetailUserInfoCellDelegate, LCPlanDetailUsersCellDelegate, LCUserCommentCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSMutableArray *commentArray;
@property (retain, nonatomic) UIButton *editButton;

@end

@implementation LCFreePlanDetailVC

+ (instancetype)createInstance {
    return (LCFreePlanDetailVC *)[LCStoryboardManager viewControllerWithFileName:SBNamePlanDetail identifier:VCIDPlanDetailUserVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /// 初始化变量.
    [self initVariable];
    /// 初始化导航栏右边按钮.
    [self initNaviRightButton];
    /// 初始化TableView.
    [self initTableView];
    /// 初始化评论阴影遮罩
    [self initShadowView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    /// 当要显示的是空计划时，是由于deeplink跳转来的，显示hud，当从网络请求数据后会隐藏hud。
    if (!self.plan || [self.plan isEmptyPlan]) {
        [YSAlertUtil showHudWithHint:nil];
    }
    
    [self updateShow];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    /// 显示蒙版.
    switch ([self.plan getPlanRelation]) {
        case LCPlanRelationScanner:
        case LCPlanRelationKicked:
        case LCPlanRelationRejected:
            if (self.plan.isNeedReview) {
                [LCMaskViewHelper checkToShowApplyPlanMaskView];
            } else {
                [LCMaskViewHelper checkToShowJoinPlanMaskView];
            }
            break;
        case LCPlanRelationCreater:
        case LCPlanRelationMember:
            [LCMaskViewHelper checkToShowChatWithPlanMaskView];
            break;
        case LCPlanRelationApplying:
            break;
    }
}

- (void)refreshData {
    [LCNetRequester getPlanDetailFromPlanGuid:self.plan.planGuid callBacl:^(LCPlanModel *plan, NSError *error) {
        /// 从deeplink跳进来时，会显示hud，所以网络刷新后隐藏hud.
        [YSAlertUtil hideHud];
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
            
            if (error.code == ErrCodePlanNotExist) {
                //计划不存在
                
                //Roy: 当通过点通知、deeplink跳转到App，自动进详情时，如果计划不存在并退出，会导致页面错乱
                //延时退出可以。。。。。。
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
            
            [self updateShow];
        } else {
            self.plan = plan;
            
            //更新本地的聊天会话model
            LCChatContactModel *chatContactModel = [LCChatContactModel chatContactModelWithPlan:plan];
            [[LCDataManager sharedInstance].chatContactDic setObject:chatContactModel forKey:[chatContactModel getBareJidString]];
            
            [self updateShow];
        }
    }];
    [self requestPlanCommentFromOrderString:nil];
}

- (void)requestPlanCommentFromOrderString:(NSString *)orderString {
    if ([LCStringUtil isNullString:orderString]) {
        self.commentArray = [[NSMutableArray alloc] init];
    }
    [LCNetRequester getCommentOfPlan:self.plan.planGuid corderString:orderString callBack:^(NSArray *commentArray, NSError *error) {
        [self.tableView footerEndRefreshing];
        
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
        } else {
            //上拉加载更多
            if (self.commentArray && self.commentArray.count > 0 && (!commentArray || commentArray.count <= 0)) {
                [YSAlertUtil tipOneMessage:LCFooterRefreshEmptyTip yoffset:TipDefaultYoffset delay:TipDefaultDelay];
            } else {
                if (!self.commentArray) {
                    self.commentArray = [[NSMutableArray alloc] initWithCapacity:0];
                }
                [self.commentArray addObjectsFromArray:commentArray];
            }
        }
        
        [self updateShow];
    }];
}

- (void)initShadowView {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadowViewTapAction:)];
    [self.shadowView addGestureRecognizer:tapGesture];
}

-(void)shadowViewTapAction:(id)sender {
    [self hideInputToolBar];
}

- (void)updateShow {
    if (!self.plan || [self.plan isEmptyPlan]) {
        /// 是一个空计划，不更新显示.
        self.tableView.hidden = YES;
        return;
    } else {
        self.tableView.hidden = NO;
    }
    
    if (0 == self.plan.commentNumber) {
        [self.tableView removeFooter];
    }
    
    if (LCPlanRelationCreater == [self.plan getPlanRelation]) {
        self.editButton.hidden = NO;
    } else {
        self.editButton.hidden = YES;
    }
    
//    [self updateCellIndex];
    [self.tableView reloadData];
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

- (void)initVariable {
    self.title = @"约伴详情";
}

- (void)initTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 100.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCIconTextArrowCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCIconTextArrowCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCTextThreePhotosCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCTextThreePhotosCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCPlanDetailUsersCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCPlanDetailUsersCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCUserCommentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCUserCommentCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCPlanDetailNoCommentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCPlanDetailNoCommentCell class])];
    
    
    [self.tableView addFooterWithTarget:self action:@selector(footerRefreshAction)];
}

- (void)initNaviRightButton {
    UIImage *editImage = [[UIImage imageNamed:@"PlanDetailEdit"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];;
    self.editButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
    [self.editButton setImage:editImage forState:UIControlStateNormal];
    [self.editButton addTarget:self action:@selector(editPlanAction) forControlEvents:UIControlEventTouchUpInside];
    self.editButton.hidden = YES;
    
    UIImage *shareImage = [[UIImage imageNamed:@"NaviShareIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 0, 40, 44)];
    [shareButton setImage:shareImage forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(sharePlanAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *rightBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    [rightBarView addSubview:self.editButton];
    [rightBarView addSubview:shareButton];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarView];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace                                    target:nil action:nil];
    negativeSpacer.width = -10;
    
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, customBarItem];
}

- (void)sharePlanAction {
    [MobClick event:Mob_PlanDetail_Share];
    [self sharePlan:self.plan];
}

- (void)editPlanAction {
    if ([self.plan getPlanRelation] == LCPlanRelationCreater) {
        [[LCSendPlanHelper sharedInstance] modify:self.plan];
    }
}

- (void)footerRefreshAction {
    if (!self.commentArray || self.commentArray.count <= 0) {
        [self requestPlanCommentFromOrderString:nil];
    } else {
        LCCommentModel *lastComment = [self.commentArray lastObject];
        [self requestPlanCommentFromOrderString:lastComment.orderStr];
    }
}

- (void)planDetailUserInfoCellToViewUserDetail:(LCPlanDetailUserInfoCell *)cell {
    if (nil != self.plan.memberList && self.plan.memberList.count > 0) {
        LCUserModel *user = [self.plan.memberList firstObject];
        [LCViewSwitcher pushToShowUserInfoVCForUser:user on:self.navigationController];
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

- (void)rightBarButtonAction:(id)sender {
    
}

- (IBAction)commentButtonAction:(id)sender {
    [MobClick event:Mob_PlanDetail_Comment];
    
    if ([self haveLogin]) {
        if (nil != self.commentArray && self.commentArray.count > 0) {
            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
            [self.tableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        [self showInputToolBarWithPlaceHolder:COMMENT_BASE_PLACEHOLDER withReplyCommentId:DefaultCommentReplyToId];
    } else {
        [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
    }
}

- (IBAction)applyButtonAction:(id)sender {
    if (![self haveLogin]) {
        [[LCRegisterAndLoginHelper sharedInstance] startRegisterWithDelegate:nil];
    } else {
        switch ([self.plan getPlanRelation]) {
            case LCPlanRelationApplying: {
                /// 正在等待中.
                [YSAlertUtil tipOneMessage:@"正在等待创建者同意" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
            }
                break;
            case LCPlanRelationCreater:
            case LCPlanRelationMember: {
                /// 群聊.
                [LCViewSwitcher pushToShowChatWithPlanVC:self.plan on:self.navigationController];
            }
                break;
            case LCPlanRelationKicked:
            case LCPlanRelationRejected:
            case LCPlanRelationScanner: {
                [MobClick event:Mob_PlanDetail_Join];
                
                /// 加入约伴 不需要支付
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
                break;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0.0;
    if (1 == section) {
        height = 40.0;
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)];
    if (1 == section) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, DEVICE_WIDTH, 40.0)];
        view.backgroundColor = [UIColor whiteColor];
        /// 评论图标.
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 15.0, 15.0, 13.0)];
        imageView.image = [UIImage imageNamed:@"PlanDetailCommentHintIcon"];
        [view addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35.0, 14.0, 100.0, 16.0)];
        label.textColor = UIColorFromRGBA(0x2c2a28, 1.0);
        label.text = [NSString stringWithFormat:@"评论 %ld", (long)self.plan.commentNumber];
        [view addSubview:label];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 39.5, DEVICE_WIDTH, 0.5)];
        lineView.backgroundColor = UIColorFromRGBA(0xe8e4dd, 1.0);
        [view addSubview:lineView];
    }
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger num = 0;
    if (0 == section) {
        num = 3;
        if (nil != self.plan.userRoute && self.plan.userRoute.userRouteId > 0) {
            num = 4;
        }
    } else {
        if (nil != self.commentArray && self.commentArray.count > 0) {
            num = self.commentArray.count;
        } else {
            num = 1;
        }
    }
    return num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    BOOL isHaveUserRoute = nil != self.plan.userRoute && self.plan.userRoute.userRouteId > 0;
    if (0 == indexPath.section) {
        if (0 == indexPath.row) {
            LCPlanDetailUserInfoCell *userInfoCell = [tableView dequeueReusableCellWithIdentifier:@"PlanDetailUserInfoCell" forIndexPath:indexPath];
            userInfoCell.delegate = self;
            [userInfoCell updateShowUserInfo:self.plan];
            cell = userInfoCell;
        } else if (true == isHaveUserRoute && 1 == indexPath.row) {
            
            LCIconTextArrowCell *textCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCIconTextArrowCell class]) forIndexPath:indexPath];
            [textCell updateShowIconText:self.plan.userRoute.routeTitle withIconImageName:@"PlanRouteHintIcon"];
            cell = textCell;
        } else if ((true == isHaveUserRoute && 2 == indexPath.row) || (false == isHaveUserRoute && 1 == indexPath.row)) {
            LCTextThreePhotosCell *photoCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCTextThreePhotosCell class]) forIndexPath:indexPath];
            [photoCell updateShowTextThreePhotos:self.plan];
            cell = photoCell;
        } else if ((true == isHaveUserRoute && 3 == indexPath.row) || (false == isHaveUserRoute && 2 == indexPath.row)) {
            LCPlanDetailUsersCell *usersCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCPlanDetailUsersCell class]) forIndexPath:indexPath];
            usersCell.delegate = self;
            [usersCell updateShowDetailUsers:self.plan];
            cell = usersCell;
        }
    } else if (1 == indexPath.section) {
        if (nil != self.commentArray && self.commentArray.count > 0) {
            LCUserCommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCUserCommentCell class]) forIndexPath:indexPath];
            commentCell.delegate = self;
            LCCommentModel *comment = [self.commentArray objectAtIndex:indexPath.row];
            [commentCell updateShowComment:comment];
            cell = commentCell;
        } else {
            LCPlanDetailNoCommentCell *noCommentCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCPlanDetailNoCommentCell class]) forIndexPath:indexPath];
            cell = noCommentCell;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isHaveUserRoute = nil != self.plan.userRoute && self.plan.userRoute.userRouteId > 0;
    if (0 == indexPath.section && true == isHaveUserRoute && 1 == indexPath.row) {
        [LCViewSwitcher pushToShowRouteDetailVCForRoute:self.plan.userRoute routeOwner:[self.plan.memberList firstObject] editable:NO showDayIndex:0 on:self.navigationController];
    } else if (1 == indexPath.section && indexPath.row < self.commentArray.count) {
        if ([self haveLogin]) {
            if (nil != self.commentArray && self.commentArray.count > 0) {
                LCCommentModel *comment = [self.commentArray objectAtIndex:indexPath.row];
                NSInteger commentId = [LCStringUtil idToNSInteger:comment.commentId];
                if ([[LCDataManager sharedInstance].userInfo.uUID isEqualToString:comment.user.uUID]) {
                    [YSAlertUtil tipOneMessage:@"不能评论自己，左滑可删除评论"];
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
    /// 如果评论是自己发的，可以删除.
    if (1 == indexPath.section) {
        if (nil != self.commentArray && self.commentArray.count > 0) {
            LCCommentModel *aComment = [self.commentArray objectAtIndex:indexPath.row];
            if ([aComment.user.uUID isEqualToString:[LCDataManager sharedInstance].userInfo.uUID]) {
                return YES;
            }
        }
    }
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (1 == indexPath.section && nil != self.commentArray && self.commentArray.count > 0) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            /// 删除评论.
            LCCommentModel *aComment = [self.commentArray objectAtIndex:indexPath.row];
            [LCNetRequester deleteCommentOfPlanWithCommentID:aComment.commentId callBack:^(NSError *error) {
                if (error) {
                    [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
                }else{
                    [self.commentArray removeObjectAtIndex:indexPath.row];
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                
                [tableView reloadData];
            }];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
