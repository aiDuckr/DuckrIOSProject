//
//  LCChatRoomMemberVC.m
//  LinkCity
//
//  Created by roy on 3/11/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCChatGroupMemberVC.h"
#import "LCChatGroupMemberBottomCell.h"
#import "LCChatGroupMemberUserCell.h"
#import "LCChatSectionHeaderView.h"

@interface LCChatGroupMemberVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,LCChatGroupMemeberBottomCellDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end



static const NSInteger UserNumPerRow = 4;
@implementation LCChatGroupMemberVC

+ (instancetype)createInstance{
    return (LCChatGroupMemberVC *)[LCStoryboardManager viewControllerWithFileName:SBNameChatTab identifier:VCIDChatGroupMemberVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //加入聊天室时，接口会返回新的聊天室信息，所以不用再请求一遍了
    //退出聊天室时，没有返回新的成员信息，所以刷新数据
    [self addObserveToNotificationNameToRefreshData:URL_QUIT_CHATGROUP];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([LCChatGroupMemberUserCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([LCChatGroupMemberUserCell class])];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([LCChatSectionHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([LCChatSectionHeaderView class])];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    
    [self updateShow];
}

- (void)refreshData{
    [LCNetRequester getChatGroupInfoForGroupGuid:self.chatGroup.guid callBack:^(LCChatGroupModel *chatGroup, NSError *error) {
        if (error) {
            LCLogWarn(@"getChatGroupInfoForGroupGuid error:%@",error);
        }else{
            self.chatGroup = chatGroup;
            
            //更新本地的聊天会话model
            LCChatContactModel *chatContactModel = [LCChatContactModel chatContactModelWithGroup:chatGroup];
            [[LCDataManager sharedInstance].chatContactDic setObject:chatContactModel forKey:[chatContactModel getBareJidString]];
            
            [self updateShow];
        }
    }];
}

- (void)updateShow{
    self.title = [NSString stringWithFormat:@"%@(%ld)",self.chatGroup.name,(long)self.chatGroup.userNum];
    [self.collectionView reloadData];
}






#pragma mark - UICollectionView Delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = 0;
    CGFloat height = 0;
    
    if (indexPath.section == 0) {
        width = collectionView.frame.size.width/UserNumPerRow;
        height = [LCChatGroupMemberUserCell getCellHeight];
    }else if(indexPath.section == 1){
        width = collectionView.frame.size.width;
        height = [LCChatGroupMemberBottomCell getCellheightForChatGroup:self.chatGroup];
    }
    
    return CGSizeMake(width,height);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGFloat height = 0;
    height = [LCChatSectionHeaderView getHeaderViewHeight];
    return CGSizeMake(collectionView.frame.size.width, height);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger itemNum = 0;
    
    if (section == 0 && self.chatGroup.memberList) {
        itemNum = self.chatGroup.memberList.count;
    }else if(section == 1) {
        itemNum = 1;
    }
    
    return itemNum;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    LCChatSectionHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([LCChatSectionHeaderView class]) forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        header.leftLabel.hidden = NO;
        header.leftLabel.text = @"群成员";
        header.rightLabel.hidden = NO;
        header.rightLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)self.chatGroup.userNum,(long)self.chatGroup.maxScale];
    }else if(indexPath.section == 1){
        header.leftLabel.hidden = NO;
        header.leftLabel.text = @"群介绍";
        header.rightLabel.hidden = YES;
    }
    
    return header;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = nil;
    
    if (indexPath.section == 0){
        // member
        if (self.chatGroup.memberList.count > indexPath.row){
            LCUserModel *aUser = [self.chatGroup.memberList objectAtIndex:indexPath.item];
            LCChatGroupMemberUserCell *userCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LCChatGroupMemberUserCell class]) forIndexPath:indexPath];
            userCell.user = aUser;
            cell = userCell;
        }
    }else if(indexPath.section == 1){
        // bottom cell
        LCChatGroupMemberBottomCell *bottomCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LCChatGroupMemberBottomCell class]) forIndexPath:indexPath];
        bottomCell.chatGroup = self.chatGroup;
        bottomCell.delegate = self;
        cell = bottomCell;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //member
        if (self.chatGroup.memberList.count > indexPath.row){
            LCUserModel *aUser = [self.chatGroup.memberList objectAtIndex:indexPath.item];
            [LCViewSwitcher pushToShowUserInfoVCForUser:aUser on:self.navigationController];
        }
    }else if(indexPath.section == 1){
        // bottom cell
    }
}

#pragma mark LCChatGroupMemeberBottomCell
- (void)chatGroupMemberBottomCellDidUpdateData:(LCChatGroupMemberBottomCell *)bottomCell{
    [self updateShow];
}
- (void)chatGroupMemberBottomCellDidJoinChatGroup:(LCChatGroupMemberBottomCell *)bottomCell newChatGroup:(LCChatGroupModel *)newChatGroup{
    self.chatGroup = newChatGroup;
    [self updateShow];
    
    [LCViewSwitcher pushToShowChatWithGroupVC:self.chatGroup on:self.navigationController];
}
- (void)chatGroupMemberBottomCellDidQuitChatGroup:(LCChatGroupMemberBottomCell *)bottomCell{
    [self updateShow];
    
    // if stack of navigationControllers have chatBaseVC, pop to root
    for (UIViewController *vc in self.navigationController.viewControllers){
        if ([vc isKindOfClass:[LCChatBaseVC class]]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
        }
    }
}

@end
