//
//  LCGroupListVC.m
//  LinkCity
//
//  Created by zzs on 14/11/30.
//  Copyright (c) 2014年 linkcity. All rights reserved.
//

#import "LCGroupListVC.h"
#import "LCChatApi.h"
#import "LCGroupUserCollectionCell.h"
#import "LCViewSwitcher.h"
#import "LCXMPPUtil.h"
#import "LCChatManager.h"

@interface LCGroupListVC ()<UICollectionViewDelegate, UICollectionViewDataSource, LCGroupUserCollectionCellDelegate, LCChatApiDelegate, LCPlanApiDelegate> {
    BOOL kickOffing;   //!< 是否正在踢人.
    BOOL isAdmin;       //!< 是否群管理员.
}

@property (weak, nonatomic) IBOutlet UIScrollView *wholeVerticalScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userCollectionContainerHeight;
@property (weak, nonatomic) IBOutlet UISwitch *banNotifySwitch;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *groupTitleLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButtonItem;

@end

@implementation LCGroupListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self initButtonItem];
    // Do any additional setup after loading the view.
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = NO;
    NSString *groupType = @"约伴群";
    if ([self.plan.planType isEqualToString:PLAN_TYPE_RECEPTION_STR]) {
        groupType = @"招待群";
    }
    self.groupTitleLabel.text = [NSString stringWithFormat:@"%@·%@（%tu/%tu）", self.plan.destinationName, groupType, self.plan.userNum, self.plan.scaleMax];
    kickOffing = NO;
    isAdmin = NO;
    LCUserInfo *adminInfo = [self.plan.memberList objectAtIndex:0];
    if ([[LCDataManager sharedInstance].userInfo.uuid isEqualToString:adminInfo.uuid]) {
        isAdmin = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.plan) {
        BOOL whetherNotify = [[LCChatManager sharedInstance] getChatNotifySetOfJID:[self roomJID] selfPhone:[self userPhone]];
        [self.banNotifySwitch setOn:!whetherNotify];
    }
}

- (void)viewDidLayoutSubviews{
    //根据成员数，调整CollectionView高度
    NSInteger itemNum = [self itemNumberOfCollectionView];
    NSInteger rowNum = itemNum/4;
    rowNum += itemNum%4==0 ? 0:1;
    self.userCollectionContainerHeight.constant = rowNum*120;
    
    [self.view layoutIfNeeded];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)initButtonItem {
    /// 使用资源原图片.
    UIImage *backImage = [[UIImage imageNamed:@"NavigationBackBG"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.backButtonItem setImage:backImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CollectionView
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LCGroupUserCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GroupUserCollectionCell"
                                                                                  forIndexPath:indexPath];
    cell.delegate = self;
    if (self.plan.memberList.count == indexPath.row) {
        cell.userInfo = nil;
        [cell.avatarButton setImage:[UIImage imageNamed:@"ChatKickOffIcon"] forState:UIControlStateNormal];
        cell.nameLabel.text = @"";
    } else {
        LCUserInfo *userInfo = [self.plan.memberList objectAtIndex:indexPath.row];
        cell.userInfo = userInfo;
        cell.avatarButton.imageURL = [NSURL URLWithString:userInfo.avatarThumbUrl];
        cell.nameLabel.text = userInfo.nick;
    }
    if (kickOffing && 0 != indexPath.row && self.plan.memberList.count != indexPath.row) {
        cell.kickOffMinusSignBtn.hidden = NO;
    } else {
        cell.kickOffMinusSignBtn.hidden = YES;
    }
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self itemNumberOfCollectionView];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:APP_ANIMATION];
}

- (void)kickOffBtnClicked {
    kickOffing = !kickOffing;
    [self.collectionView reloadData];
}

- (void)cancelKickOffUser {
    if (YES == kickOffing) {
        kickOffing = NO;
        [self.collectionView reloadData];
    }
}

- (void)kickOffUserClicked:(LCUserInfo *)userInfo {
    kickOffing = NO;
    [self.collectionView reloadData];
    
    LCChatApi *api = [[LCChatApi alloc] initWithDelegate:self];
    [api kickOffUserPlanGuid:self.plan.planGuid planType:self.plan.planType kickUserUuid:userInfo.uuid];
    [self showHudInView:self.view hint:@"正在踢人..."];
    [MobClick event:MobEPlanKick];
}

- (IBAction)banNotifySwitchValueChanged:(UISwitch *)sender {
    self.banNotifySwitch.enabled = NO;
    LCChatApi *chatApi = [[LCChatApi alloc]initWithDelegate:self];
    if (self.banNotifySwitch.on) {
        [chatApi setWhetherPushNotificationOfChat:[self roomJID] userPhone:[self userPhone] whetherPush:NO];
    } else {
        [chatApi setWhetherPushNotificationOfChat:[self roomJID] userPhone:[self userPhone] whetherPush:YES];
    }
}

- (void)chatApi:(LCChatApi *)api didSetWhetherPushNotificationOfChatWithError:(NSError *)error{
    self.banNotifySwitch.enabled = YES;
    if (error) {
        [self.banNotifySwitch setOn:!self.banNotifySwitch.on animated:YES];
        [YSAlertUtil tipOneMessage:error.domain delay:TIME_FOR_ERROR_TIP];
    } else {
        [[LCChatManager sharedInstance] setChatNotify:!self.banNotifySwitch.on ofJID:[self roomJID] selfPhont:[self userPhone]];
    }
}


- (void)chatApi:(LCChatApi *)api didKickOffUserPlan:(LCPlan *)plan withError:(NSError *)error {
    [self hideHudInView];
    if (!error) {
        self.plan = plan;
        kickOffing = NO;
        [self.collectionView reloadData];
    } else {
        [self showHint:error.domain];
    }
}

- (IBAction)quitGroupChatAction:(id)sender {
    if (self.plan.memberList.count <= 1) {
        [YSAlertUtil alertTwoButton:@"确定" btnTwo:@"取消" withTitle:@"提示" msg:@"确定要退出该群并删除对应出行计划吗?" callBack:^(NSInteger chooseIndex){
            if (0 == chooseIndex) {
                LCPlanApi *api = [[LCPlanApi alloc] initWithDelegate:self];
                [api deletePlanGuid:self.plan.planGuid planType:self.plan.planType];
                [self showHudInView:self.view hint:@"正在退出该群..."];
            }
        }];
    } else {
        [YSAlertUtil alertTwoButton:@"确定" btnTwo:@"取消" withTitle:@"提示" msg:@"确定要退出群并退出对应出行计划吗?" callBack:^(NSInteger chooseIndex){
            if (0 == chooseIndex) {
                LCPlanApi *api = [[LCPlanApi alloc] initWithDelegate:self];
                [api quitPlanGuid:self.plan.planGuid planType:self.plan.planType];
                [self showHudInView:self.view hint:@"正在退出该群..."];
            }
        }];
    }
}

- (void)planApi:(LCPlanApi *)api didQuitPlanWithError:(NSError *)error {
    [self hideHudInView];
    if (!error) {
        /// 删除本地列表.
        [LCXMPPUtil deleteJid:self.plan.roomID];
        [LCDataManager sharedInstance].isAutoUpdateMyselfPlanList = YES;
    } else {
        [self showHint:error.domain];
        if (QUIT_PLAN_DIDKICK_ERROR == error.code) {
            /// 删除本地列表.
            [LCXMPPUtil deleteJid:self.plan.roomID];
        }
    }
    [self.navigationController popToRootViewControllerAnimated:APP_ANIMATION];
}

- (void)planApi:(LCPlanApi *)api didDeletePlanWithError:(NSError *)error {
    [self hideHudInView];
    if (!error) {
        /// 删除本地列表.
        [LCXMPPUtil deleteJid:self.plan.roomID];
        [LCDataManager sharedInstance].isAutoUpdateMyselfPlanList = YES;
    } else {
        [self showHint:error.domain];
    }
    [self.navigationController popToRootViewControllerAnimated:APP_ANIMATION];
}

- (void)goToUserPage:(LCUserInfo *)userInfo {
    [LCViewSwitcher pushToShowUserInfo:userInfo onNavigationVC:self.navigationController];
}


#pragma mark - Private
- (NSString *)roomJID{
    XMPPJID *chatJID = [XMPPJID jidWithString:self.plan.roomID];
    return chatJID.bare;
}
- (NSString *)userPhone{
    return [LCDataManager sharedInstance].userInfo.telephone;
}

- (NSInteger)itemNumberOfCollectionView{
    if (YES == isAdmin) {
        return self.plan.memberList.count + 1;
    }
    return self.plan.memberList.count;
}

@end
