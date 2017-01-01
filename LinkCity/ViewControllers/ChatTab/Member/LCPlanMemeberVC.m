//
//  LCPlanMemeberVC.m
//  LinkCity
//
//  Created by roy on 3/16/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCPlanMemeberVC.h"
#import "LCPlanMemberUserCell.h"
#import "LCPlanMemberBottomCell.h"
#import "LCChatSectionHeaderView.h"

@interface LCPlanMemeberVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,LCPlanMemberBottomCellDelegate>
@property (nonatomic, assign) BOOL isInEditState;   //是否正在编辑状态，即正在踢人
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

static const NSInteger UserNumPerRow = 4;
@implementation LCPlanMemeberVC

+ (instancetype)createInstance{
    LCPlanMemeberVC *memeberVC = (LCPlanMemeberVC *)[LCStoryboardManager viewControllerWithFileName:SBNameChatTab identifier:VCIDPlanMemberVC];
    return memeberVC;
}

- (void)commonInit{
    [super commonInit];
    
    self.isInEditState = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addObserveToNotificationNameToRefreshData:URL_JOIN_PLAN];
    [self addObserveToNotificationNameToRefreshData:URL_QUIT_PLAN];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([LCPlanMemberUserCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([LCPlanMemberUserCell class])];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([LCChatSectionHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([LCChatSectionHeaderView class])];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self updateShow];
}


- (void)refreshData{
    [YSAlertUtil showHudWithHint:nil inView:[UIApplication sharedApplication].delegate.window enableUserInteraction:YES];
    [LCNetRequester getPlanDetailFromPlanGuid:self.plan.planGuid callBack:^(LCPlanModel *plan,NSArray * tourpicArray, NSError *error) {
        if (error) {
            [YSAlertUtil hideHud];
            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
            
            if (error.code == ErrCodePlanNotExist) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else{
            self.plan = plan;
            if ([self isStagePlan]) {
                [LCNetRequester getPlanJoinedUserListFromPlanGuid:self.plan.planGuid callBack:^(NSArray *stageArray, NSDecimalNumber *totalStageIncome, NSError *error) {
                    [YSAlertUtil hideHud];
                    if (error) {
                        [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
                    }else{
                        self.stageArray = stageArray;
                        [self updateShow];
                    }
                }];
            }else{
                [YSAlertUtil hideHud];
                [self updateShow];
            }
        }
    }];
}

- (void)updateShow{
    self.title = @"群信息";
    [self.collectionView reloadData];
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    for (UICollectionViewCell *c in [self.collectionView visibleCells]){
        [c setNeedsLayout];
        [c layoutIfNeeded];
    }
}


#pragma mark - UICollectionView Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSInteger sectionNum = 0;
    
    if ([self isStagePlan]) {
        sectionNum = self.stageArray.count + 1;
    }else{
        sectionNum = 2;
    }
    
    return sectionNum;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger itemNum = 0;
    
    if ([self isStagePlan]) {
        if (section < self.stageArray.count) {
            LCPartnerStageModel *aStage = [self.stageArray objectAtIndex:section];
            itemNum = aStage.member.count;
        }else if(section == self.stageArray.count){
            itemNum = 1;
        }
    }else{
        if (section == 0 && self.plan.memberList) {
            itemNum = self.plan.memberList.count;
            if ([self.plan isCreater:[LCDataManager sharedInstance].userInfo] &&
                self.plan.memberList.count > 1) {
                //如果是计划的创建者
                //并且计划中不止一个人
                //显示踢人按钮
                itemNum ++;
            }
        }else if(section == 1) {
            itemNum = 1;
        }
    }
    
    return itemNum;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = 0;
    CGFloat height = 0;
    
    if ([self isStagePlan]) {
        if (indexPath.section < self.stageArray.count) {
            width = collectionView.frame.size.width/UserNumPerRow;
            height = [LCPlanMemberUserCell getCellHeight];
        }else if(indexPath.section == self.stageArray.count) {
            width = collectionView.frame.size.width;
            height = [LCPlanMemberBottomCell getCellHeightForPlan:self.plan];
        }
    }else{
        if (indexPath.section == 0) {
            width = collectionView.frame.size.width/UserNumPerRow;
            height = [LCPlanMemberUserCell getCellHeight];
        }else if(indexPath.section == 1){
            width = collectionView.frame.size.width;
            height = [LCPlanMemberBottomCell getCellHeightForPlan:self.plan];
        }
    }
    
    return CGSizeMake(width,height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGFloat height = 0;
    
    if ([self isStagePlan]) {
        if (section < self.stageArray.count) {
            height = [LCChatSectionHeaderView getHeaderViewHeight];
        }else{
            height = 0;
        }
    }else{
        if (section == 0) {
            height = [LCChatSectionHeaderView getHeaderViewHeight];
        }else{
            height = 0;
        }
    }
    
    return CGSizeMake(collectionView.frame.size.width, height);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    LCChatSectionHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([LCChatSectionHeaderView class]) forIndexPath:indexPath];
    
    if ([self isStagePlan]) {
        if (indexPath.section < self.stageArray.count) {
            LCPartnerStageModel *aStage = [self.stageArray objectAtIndex:indexPath.section];
            header.leftLabel.hidden = NO;
            header.leftLabel.text = [aStage getDepartTimeStr];
            header.rightLabel.hidden = NO;
            header.rightLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)aStage.joinNumber,(long)aStage.totalNumber];
        }else if(indexPath.section == self.stageArray.count) {
            
        }
    }else{
        if (indexPath.section == 0) {
            header.leftLabel.hidden = NO;
            header.leftLabel.text = @"群成员";
            header.rightLabel.hidden = NO;
            header.rightLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)[self.plan getCurPlanTotalOrderNumber],(long)self.plan.scaleMax];
        }else if(indexPath.section == 1){
            
        }
    }
    
    return header;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = nil;
    
    if ([self isStagePlan]) {
        if (indexPath.section < self.stageArray.count) {
            // user cell
            LCPartnerStageModel *aStage = [self.stageArray objectAtIndex:indexPath.section];
            
            LCPlanMemberUserCell *userCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LCPlanMemberUserCell class]) forIndexPath:indexPath];
            
            userCell.isInEditState = NO;
            cell = userCell;
            
            if (aStage.member.count > indexPath.item) {
                LCUserModel *aUser = [aStage.member objectAtIndex:indexPath.item];
                userCell.user = aUser;
            }else{
                userCell.user = nil;
            }
        }else if(indexPath.section == self.stageArray.count) {
            // bottom cell
            LCPlanMemberBottomCell *bottomCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LCPlanMemberBottomCell class]) forIndexPath:indexPath];
            bottomCell.plan = self.plan;
            bottomCell.delegate = self;
            cell = bottomCell;
        }
    }else{
        if (indexPath.section == 0) {
            // user cell
            LCPlanMemberUserCell *userCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LCPlanMemberUserCell class]) forIndexPath:indexPath];
            if (self.isInEditState && indexPath.item>0) {
                //目前在编辑状态； 并且不是第一个用户，即不是组长自己
                userCell.isInEditState = YES;
            }else{
                userCell.isInEditState = NO;
            }
            cell = userCell;
            
            if (self.plan.memberList.count > indexPath.item){
                LCUserModel *aUser = [self.plan.memberList objectAtIndex:indexPath.item];
                userCell.user = aUser;
            }else if(self.plan.memberList.count == indexPath.item){
                //kick off user cell
                userCell.user = nil;
            }
        }else{
            // bottom cell
            LCPlanMemberBottomCell *bottomCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LCPlanMemberBottomCell class]) forIndexPath:indexPath];
            bottomCell.plan = self.plan;
            bottomCell.delegate = self;
            cell = bottomCell;
        }
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isStagePlan]) {
        if (indexPath.section < self.stageArray.count) {
            // user cell
            LCPartnerStageModel *aStage = [self.stageArray objectAtIndex:indexPath.section];
            LCUserModel *aUser = [aStage.member objectAtIndex:indexPath.item];
            [LCViewSwitcher pushToShowUserInfoVCForUser:aUser on:self.navigationController];
        }
    }else if (indexPath.section == 0) {
        //普通邀约的，user cell
        if (self.plan.memberList.count > indexPath.item) {
            LCUserModel *aUser = [self.plan.memberList objectAtIndex:indexPath.item];
            if (self.isInEditState) {
                //kick off user
                if (indexPath.item == 0) {
                    [YSAlertUtil tipOneMessage:@"不能踢除自己" yoffset:TipDefaultYoffset delay:TipErrorDelay];
                }else{
                    //发踢人消息到群聊
                    [[LCXMPPMessageHelper sharedInstance] sendChatSystemInfo:[LCUIConstants getKickOffUserFromPlanMessageWithUserNick:aUser.nick]
                                                             toBareJidString:self.plan.roomId
                                                                     isGroup:YES];
                    //向Server端请求踢人
                    [LCNetRequester kickOffUser:aUser.uUID ofPlan:self.plan.planGuid callBack:^(LCPlanModel *plan, NSError *error) {
                        if (error) {
                            [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
                        }else{
                            self.plan = plan;
                            [self updateShow];
                        }
                    }];
                }
            }else{
                //view detail
                [LCViewSwitcher pushToShowUserInfoVCForUser:aUser on:self.navigationController];
            }
        }else{
            //kick off user button
            if ([LCDecimalUtil isOverZero:self.plan.costPrice]) {
                [YSAlertUtil tipOneMessage:ErrorMsg_OrderPlanCanNotKickUser yoffset:TipDefaultYoffset delay:TipErrorDelay];
            }else{
                self.isInEditState = !self.isInEditState;
                [self updateShow];
            }
        }
    }
}

#pragma mark LCPlanMemberBottomCell Delegate
- (void)planMemberBottomCellDidUpdateData:(LCPlanMemberBottomCell *)bottomCell{
    [self updateShow];
}


#pragma mark InnerFunc
- (BOOL)isStagePlan{
    if ([LCDecimalUtil isOverZero:self.plan.costPrice]) {
        return YES;
    }else{
        return NO;
    }
}


@end
