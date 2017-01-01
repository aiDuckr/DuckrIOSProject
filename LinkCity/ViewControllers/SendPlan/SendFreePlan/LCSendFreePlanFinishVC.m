//
//  LCSendFreePlanFinishVC.m
//  LinkCity
//
//  Created by Roy on 12/14/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCSendFreePlanFinishVC.h"
#import "LCSendFreePlanFinishTitleCell.h"
#import "LCSendFreePlanFinishUsersCell.h"
#import "LCFreePlanCell.h"
#import "LCCostPlanCell.h"
#import "LCWebPlanCell.h"
#import "LinkCity-Swift.h"

#define TopBgDefaultHeight (DEVICE_WIDTH * 1.0f / 750 * 283)
@interface LCSendFreePlanFinishVC ()<UITableViewDataSource, UITableViewDelegate, LCShareViewDelegate, LCSendFreePlanFinishUsersCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *topBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBgViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBgViewTop;


@property (nonatomic, strong) LCShareView *shareView;

@property (nonatomic, strong) NSArray *recommendUserArray;
@property (nonatomic, strong) NSArray *recommendPlanArray;
@property (nonatomic, strong) NSArray *recommendWebPlanArray;

@property (nonatomic, assign) BOOL haveGetRoomOnline;
@property (nonatomic, assign) BOOL haveShownCarIdAlert;
@end

@implementation LCSendFreePlanFinishVC

+ (instancetype)createInstance{
    return (LCSendFreePlanFinishVC *)[LCStoryboardManager viewControllerWithFileName:SBNameSendPlan identifier:NSStringFromClass([LCSendFreePlanFinishVC class])];
}

- (void)commonInit{
    [super commonInit];
    self.haveGetRoomOnline = NO;
    self.haveShownCarIdAlert = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarBtnAction:)];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    
    UIBarButtonItem *shareBarBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"PlanDetailGrayShareIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(shareBtnAction:)];;
    self.navigationItem.rightBarButtonItem = shareBarBtn;
    
     [self addObserveToNotificationNameToRefreshData:URL_FAVOR_PLAN];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 200;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCSendFreePlanFinishTitleCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCSendFreePlanFinishTitleCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCSendFreePlanFinishUsersCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCSendFreePlanFinishUsersCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCFreePlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCFreePlanCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCWebPlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCWebPlanCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCCostPlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCCostPlanCell class])];
    
    self.topBgViewHeight.constant = TopBgDefaultHeight;
    self.topBgViewTop.constant = 0;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (!self.haveGetRoomOnline) {
        /// 发一条群聊消息 ---期间会get room online.
        NSString *systemMsg = [LCUIConstants getJoinPlanMessageWithUserNick:[LCDataManager sharedInstance].userInfo.nick];
        [[LCXMPPMessageHelper sharedInstance] sendChatSystemInfo:systemMsg toBareJidString:self.plan.roomId isGroup:YES];
        
        self.haveGetRoomOnline = YES;
    }
    
    /*如果没弹过车辆认证
     且发的收费或免费拼车邀约
     且车辆没认证过或者认证失败
     */
    if (!self.haveShownCarIdAlert &&
        ([self.plan isCostCarryPlan] || [self.plan isFreeCarryPlan]) &&
        ([LCDataManager sharedInstance].userInfo.isCarVerify == LCIdentityStatus_None ||
         [LCDataManager sharedInstance].userInfo.isCarVerify == LCIdentityStatus_Failed)) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [LCDialogHelper showOneBtnDialogHideCancelBtn:NO dismissOnBgTouch:NO iconImageName:@"CarIconGray" title:@"认证车辆信息" msg:@"会提高90%的拼车邀约成功率" miniBtnTitle:nil btnTitle:@"去认证" cancelBtnCallBack:^{
                [LCDialogHelper dismissDialog];
            } miniBtnCallBack:^{
                [LCDialogHelper dismissDialog];
            } submitBtnCallBack:^{
                [LCDialogHelper dismissDialog];
                
                [[LCUserIdentityHelper sharedInstance] startCarIdentityWithUser:[LCDataManager sharedInstance].userInfo fromVC:self];
            }];
        });
        self.haveShownCarIdAlert = YES;
    }
}

- (void)updateShow{
    [self updateCellIndex];
    [self.tableView reloadData];
}

- (void)refreshData{
    [LCNetRequester getRecommendOfPlan:self.plan.planGuid callBack:^(NSArray *userArray, NSArray *planArray, NSArray *webPlanArray, NSError *error) {
        if (error) {
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipDefaultDelay];
        }else{
            self.recommendUserArray = userArray;
            self.recommendPlanArray = planArray;
            self.recommendWebPlanArray = webPlanArray;
            [self updateShow];
        }
    }];
}

#pragma mark ButtonAction
- (void)leftBarBtnAction:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:NO];
//    if ([[[self.navigationController childViewControllers] lastObject] isEqual:self]) {
//        [self.navigationController popViewControllerAnimated:YES];
//    } else {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
}
- (void)shareBtnAction:(id)sender{
    [self sharePlan:self.plan];
}

#pragma mark - UITableView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY >= 0) {
        self.topBgViewHeight.constant = TopBgDefaultHeight;
        self.topBgViewTop.constant = 0 - offsetY;
    }else{
        if (offsetY <= -50) {
            offsetY = -50;
            scrollView.contentOffset = CGPointMake(0, -50);
        }
        
        self.topBgViewHeight.constant = TopBgDefaultHeight - offsetY;
        self.topBgViewTop.constant = 0;
    }
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return cellNum;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    
    if (indexPath.row == titleIndex) {
        LCSendFreePlanFinishTitleCell *titleCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCSendFreePlanFinishTitleCell class]) forIndexPath:indexPath];
        
        cell = titleCell;
    }else if(indexPath.row == recUserIndex) {
        LCSendFreePlanFinishUsersCell *usersCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCSendFreePlanFinishUsersCell class]) forIndexPath:indexPath];
        usersCell.userArray = self.recommendUserArray;
        usersCell.delegate = self;
        cell = usersCell;
    }else if(indexPath.row >= recPlanIndex && indexPath.row < recPlanIndex+self.recommendPlanArray.count){
        LCPlanModel *plan = [self getPlanByIndexPath:indexPath];
        if ([plan isMerchantCostPlan]) {
            LCCostPlanCell *costPlanCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCCostPlanCell class]) forIndexPath:indexPath];
            [costPlanCell updateShowWithPlan:plan];
            cell = costPlanCell;
        }else{
            LCFreePlanCell *freePlanCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCFreePlanCell class]) forIndexPath:indexPath];
            if (indexPath.row != ([tableView numberOfRowsInSection:indexPath.section] - 1))
                [freePlanCell updateShowWithPlan:plan hideThemeId:0 withSpaInset:YES];
            else
                [freePlanCell updateShowWithPlan:plan hideThemeId:0 withSpaInset:NO];
            cell = freePlanCell;
        }
    }else if(indexPath.row >= recWebPlanIndex && indexPath.row < recWebPlanIndex+self.recommendWebPlanArray.count) {
        LCWebPlanModel *webPlan = [self getWebPlanByIndexPath:indexPath];
        LCWebPlanCell *webPlanCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCWebPlanCell class]) forIndexPath:indexPath];
        [webPlanCell updateShowWebPlan:webPlan];
        
        cell = webPlanCell;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == titleIndex) {
        
    }else if(indexPath.row == recUserIndex) {
        
    }else if(indexPath.row >= recPlanIndex && indexPath.row < recPlanIndex + self.recommendPlanArray.count){
        LCPlanModel *plan = [self getPlanByIndexPath:indexPath];
        [LCViewSwitcher pushToShowPlanDetailVCForPlan:plan recmdUuid:nil on:self.navigationController];
    }else if(indexPath.row >= recWebPlanIndex) {
        LCWebPlanModel *webPlan = [self getWebPlanByIndexPath:indexPath];
        [LCViewSwitcher pushWebVCtoShowURL:webPlan.planUrl withTitle:webPlan.title on:self.navigationController];
    }
}

#pragma mark LCSendFreePlanFinishUsersCellDelegate
- (void)sendFreePlanFinishUsersCellDidClickInvite:(LCSendFreePlanFinishUsersCell *)cell{
    NSMutableArray *userToInvite = [[NSMutableArray alloc] init];
    for (int i=0; i<cell.userArray.count; i++){
        //用户被选中了，并且被邀请用户不是自己
        if ([[cell.selectionArray objectAtIndex:i] boolValue] &&
            ![[cell.userArray[i] openfireAccount] isEqualToString:[LCDataManager sharedInstance].userInfo.openfireAccount]) {
            
            [userToInvite addObject:cell.userArray[i]];
        }
    }
    
    NSString *msg;
    for (LCUserModel *user in userToInvite){
        NSString *destinationStr = @"";
        for (int i=0; i<self.plan.destinationNames.count; i++){
            if (i == 0) {
                destinationStr = self.plan.destinationNames[i];
            }else{
                destinationStr = [destinationStr stringByAppendingFormat:@"、%@",self.plan.destinationNames[i]];
            }
        }
        msg = [NSString stringWithFormat:@"Hi,%@,我要去%@玩儿，要不要一起？",user.nick,destinationStr];
        MessageModel *model = [self getMessageModelFromPlan:self.plan text:msg];
        [[LCXMPPMessageHelper sharedInstance] sendChatMessageModel:model toBareJidString:user.openfireAccount];
    }
    
    
    [YSAlertUtil tipOneMessage:@"邀请成功!" yoffset:TipDefaultYoffset delay:TipDefaultDelay];
    self.recommendUserArray = nil;
    [self updateShow];
}

/// 在聊天列表中显示发送的计划信息.
- (MessageModel *)getMessageModelFromPlan:(LCPlanModel *)plan text:(NSString *)text {
    LCUserModel *userInfo = [LCDataManager sharedInstance].userInfo;
    MessageModel *model = [[MessageModel alloc] init];
    model.plan = plan;
    model.type = eMessageBodyType_Plan;
    model.content = text;
    model.isSender = YES;
    model.headImageURL = [NSURL URLWithString:userInfo.avatarThumbUrl];
    model.sendDate = [NSDate date];
    return model;
}

#pragma mark Caculate Cell Index
static NSInteger cellNum = 0;
static NSInteger titleIndex = 0;
static NSInteger recUserIndex = 0;
static NSInteger recPlanIndex = 0;
static NSInteger recWebPlanIndex = 0;

- (void)updateCellIndex{
    cellNum = 0;
    
    titleIndex = cellNum++;
    
    if (self.recommendUserArray.count > 0) {
        recUserIndex = cellNum++;
    }else{
        recUserIndex = -1;
    }
    
    if (self.recommendPlanArray.count > 0) {
        recPlanIndex = cellNum;
        cellNum += self.recommendPlanArray.count;
    }else{
        recPlanIndex = -1;
    }
    
    if (self.recommendWebPlanArray.count > 0) {
        recWebPlanIndex = cellNum;
        cellNum += self.recommendWebPlanArray.count;
    }else{
        recWebPlanIndex = -1;
    }
}

- (LCPlanModel *)getPlanByIndexPath:(NSIndexPath *)indexPath{
    NSInteger planIndex = indexPath.row - recPlanIndex;
    if (planIndex >= 0 && planIndex < self.recommendPlanArray.count) {
        return self.recommendPlanArray[planIndex];
    }
    return nil;
}

- (LCWebPlanModel *)getWebPlanByIndexPath:(NSIndexPath *)indexPath{
    NSInteger webPlanIndex = indexPath.row - recWebPlanIndex;
    if (webPlanIndex >= 0 && webPlanIndex < self.recommendWebPlanArray.count) {
        return self.recommendWebPlanArray[webPlanIndex];
    }
    return nil;
}


#pragma mark SharePlan
- (void)sharePlan:(LCPlanModel *)plan{
    if (!self.shareView) {
        self.shareView = [LCShareView createInstance];
        [self.shareView setShareToDuckrHiden:NO];
        self.shareView.delegate = self;
    }
    [LCShareView showShareView:self.shareView onViewController:self forPlan:plan];
}

#pragma mark - LCShareViewDelegate
- (void)cancelShareAction
{
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){}];
}
- (void)shareWeixinAction:(LCPlanModel *)plan
{
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){
        [LCShareUtil shareWeixinAction:plan presentedController:self];
    }];
}

- (void)shareWeixinTimeLineAction:(LCPlanModel *)plan
{
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){
        [LCShareUtil shareWeixinTimeLineAction:plan presentedController:self];
    }];
}

- (void)shareWeiboAction:(LCPlanModel *)plan
{
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){
        [LCShareUtil shareWeiboAction:plan presentedController:self];
    }];
}

- (void)shareQQAction:(LCPlanModel *)plan
{
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){
        [LCShareUtil shareQQAction:plan presentedController:self];
    }];
}

- (void)shareDuckrAction:(LCPlanModel *)plan
{
    [LCShareView dismissShareView:self.shareView onViewController:self animation:YES completion:^(){
        [LCShareUtil shareDuckrAction:plan presentedController:self];
    }];
}



@end
