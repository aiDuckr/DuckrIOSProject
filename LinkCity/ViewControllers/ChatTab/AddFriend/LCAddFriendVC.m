//
//  LCAddFriendVC.m
//  LinkCity
//
//  Created by roy on 3/16/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCAddFriendVC.h"
#import "LCTabView.h"
#import "LCUserTableViewCell.h"
#import "LCUserTableViewCellHelper.h"
#import "LCAddFriendPhoneContactorCell.h"
#import "LCPhoneUtil.h"
#import "LCChatSectionHeaderView.h"


#define IS_NOT_INVITED 0
#define IS_INVITED 1

@interface LCAddFriendVC ()<LCTabViewDelegate,UITableViewDataSource,UITableViewDelegate,LCAddFriendPhoneContactorCellDelegate,LCUserTableViewCellDelegate,UISearchBarDelegate>
//Data
@property (nonatomic, strong) NSMutableArray *phoneContactArray;   //array of LCPhoneContactorModel 本地通讯录列表
@property (nonatomic, strong) NSMutableArray *phoneContactTypeArray;    // array of NSNumber, 0: have not invited, 1:have invited
@property (nonatomic, strong) NSMutableArray *registeredPhoneContactArray; //array of LCUserModel 通讯录中已经注册过的用户列表
@property (nonatomic, strong) NSMutableArray *invitedPhoneContactArray;    //array of LCPhoneContactorModel 通讯录中已经邀请过的用户列表

@property (nonatomic, strong) NSMutableArray *filteredPhoneContactArray;    //搜索过滤后的通讯录列表 LCPhoneContactorModel
@property (nonatomic, strong) NSMutableArray *filteredPhoneContactTypeArray;    //搜索过滤后的通讯录类型列表 array of NSNumber, 0: have not invited, 1:have invited
@property (nonatomic, strong) NSMutableArray *filteredRegisteredPhoneContactArray;  //搜索过滤后的已注册用户列表 LCUserModel

@property (nonatomic, strong) NSArray *recommendUserArray;  //array of LCUserModel
@property (nonatomic, strong) UIImage *formerNavigationBarShadowImage;

//UI
@property (weak, nonatomic) IBOutlet UIView *tabBarView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LCAddFriendVC

+ (instancetype)createInstance{
    return (LCAddFriendVC *)[LCStoryboardManager viewControllerWithFileName:SBNameChatTab identifier:VCIDAddFriendVC];
}

- (void)commonInit{
    [super commonInit];
    
    self.showingTab = LCAddFriendVCTab_AddressBookUser;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    LCTabView *tabView = [LCTabView createInstance];
    tabView.frame = CGRectMake(0, 0, DEVICE_WIDTH, LCTabViewHeight);
    tabView.delegate = self;
    tabView.selectIndex = 0;
    [tabView updateButtons:@[@"通讯录好友",@"推荐关注"] withMargin:0];
    [self.tabBarView addSubview:tabView];
    
    self.title = @"查找朋友";
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:LCNavBarBackBarButtonImageName] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonAction)];
    self.navigationItem.leftBarButtonItem = backBarButton;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCAddFriendPhoneContactorCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCAddFriendPhoneContactorCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCUserTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCUserTableViewCell class])];
    
    
    self.phoneContactArray = [[NSMutableArray alloc] initWithArray:[LCPhoneUtil getPhoneContactList]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
    self.formerNavigationBarShadowImage = self.navigationController.navigationBar.shadowImage;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    [self updateShow];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear: animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[LCUIConstants sharedInstance].navBarOpaqueImage forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = UIColorFromRGBA(NavigationBarTintColor, 1);
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGBA(NavigationBarTintColor, 1), NSForegroundColorAttributeName, [UIFont fontWithName:FONT_LANTINGBLACK size:17], NSFontAttributeName, nil];
    self.navigationController.navigationBar.shadowImage = self.formerNavigationBarShadowImage;
}

- (void)updateNavigationBarAppearance {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:FONT_LANTINGBLACK size:17], NSFontAttributeName, nil];
}

- (void)refreshData {
    [YSAlertUtil showHudWithHint:@"正在获取信息..." inView:[UIApplication sharedApplication].delegate.window enableUserInteraction:YES];
    [LCNetRequester getInviteUserListInAddressBookWithCallBack:^(NSArray *registeredPhoneContactArray, NSArray *invitedPhoneContactArray, NSError *error) {
        if (error) {
            LCLogWarn(@"getInviteUserListInAddressBookWithCallBack error:%@",error);
        }else{
            self.registeredPhoneContactArray = [NSMutableArray arrayWithArray:registeredPhoneContactArray];
            self.invitedPhoneContactArray = [NSMutableArray arrayWithArray:invitedPhoneContactArray];
            
            //filter out registeredPhoneContact from phoneContact
            for (LCUserModel *registeredUser in registeredPhoneContactArray){
                NSUInteger registeredUserIndex = [[self.phoneContactArray valueForKeyPath:@"phone"] indexOfObject:registeredUser.telephone];
                if (registeredUserIndex != NSNotFound &&
                    self.phoneContactArray.count > registeredUserIndex) {
                    
                    LCLogInfo(@"remove registeredUser %ld, %@, %@",(long)registeredUserIndex, registeredUser.nick, registeredUser.telephone);
                    [self.phoneContactArray removeObjectAtIndex:registeredUserIndex];
                }
            }
            
            //update phoneContactTypeArray
            self.phoneContactTypeArray = [[NSMutableArray alloc] initWithCapacity:self.phoneContactArray.count];
            for (int i=0; i<self.phoneContactArray.count; i++){
                NSNumber *phoneContactType = nil;
                LCPhoneContactorModel *phoneContact = (LCPhoneContactorModel *)self.phoneContactArray[i];
                if ([[self.invitedPhoneContactArray valueForKey:@"phone"] containsObject:phoneContact.phone]) {
                    phoneContactType = [NSNumber numberWithInteger:IS_INVITED];
                    LCLogInfo(@"have invited : %@, %@",phoneContact.phone, phoneContact.name);
                }else{
                    phoneContactType = [NSNumber numberWithInteger:IS_NOT_INVITED];
                }
                [self.phoneContactTypeArray addObject:phoneContactType];
            }
            
            self.filteredRegisteredPhoneContactArray = [[NSMutableArray alloc] initWithArray:self.registeredPhoneContactArray];
            self.filteredPhoneContactArray = [[NSMutableArray alloc] initWithArray:self.phoneContactArray];
            self.filteredPhoneContactTypeArray = [[NSMutableArray alloc] initWithArray:self.phoneContactTypeArray];
            
            [self updateShow];
            [YSAlertUtil hideHud];
        }
    }];
    [LCNetRequester getRecommendedUserListWithCallBack:^(NSArray *userArray, NSError *error) {
        if (error) {
            LCLogWarn(@"getRecommendedUserListWithCallBack error:%@",error);
        }else{
            self.recommendUserArray = userArray;
            [self updateShow];
//            [YSAlertUtil hideHud];
        }
    }];
}

- (void)updateShow{
    self.tableView.scrollsToTop = NO;
    
    [self.tableView reloadData];
    [self updateNavigationBarAppearance];
}

#pragma mark ButtonAction
- (void)backBarButtonAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark LCTabView Delegate
- (void)tabView:(LCTabView *)tabView didSelectIndex:(NSInteger)index{
    [self.view endEditing:YES];
    
    if (index == 0){
        self.showingTab = LCAddFriendVCTab_AddressBookUser;
    }else if(index == 1){
        self.showingTab = LCAddFriendVCTab_RecommendUser;
    }
    
    [self updateShow];
}

#pragma mark UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger sectionNum = 0;
    
    if (LCAddFriendVCTab_AddressBookUser == self.showingTab) {
        sectionNum = 2;
    } else if (LCAddFriendVCTab_RecommendUser == self.showingTab) {
        sectionNum = 1;
    }
    
    return sectionNum;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowNum = 0;
    
    if (LCAddFriendVCTab_AddressBookUser == self.showingTab) {
        if (section == 0 && self.filteredRegisteredPhoneContactArray) {
            rowNum = self.filteredRegisteredPhoneContactArray.count;
        } else if(section == 1 && self.filteredPhoneContactArray) {
            rowNum = self.filteredPhoneContactArray.count;
        }
    } else if (LCAddFriendVCTab_RecommendUser == self.showingTab) {
        rowNum = self.recommendUserArray.count;
    }
    
    return rowNum;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    
    if (LCAddFriendVCTab_AddressBookUser == self.showingTab) {
        height = [LCAddFriendPhoneContactorCell getCellHeight];
    } else if (LCAddFriendVCTab_RecommendUser == self.showingTab) {
        height = [LCUserTableViewCell getCellHeight];
    }
    
    return height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0;
    
    if (LCAddFriendVCTab_AddressBookUser == self.showingTab) {
        height = [LCChatSectionHeaderView getHeaderViewHeight];
    }
    
    return height;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = nil;
    
    if (LCAddFriendVCTab_AddressBookUser == self.showingTab) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([LCChatSectionHeaderView class]) bundle:nil];
        LCChatSectionHeaderView *sectionView = [[nib instantiateWithOwner:nil options:0] firstObject];
        if (section == 0) {
            sectionView.leftLabel.text = @"已加入达客";
            sectionView.rightLabel.hidden = YES;
        }else if(section == 1){
            sectionView.leftLabel.text = @"邀请加入达客";
            sectionView.rightLabel.hidden = YES;
        }
        view = sectionView;
    }
    
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    
    if (LCAddFriendVCTab_AddressBookUser == self.showingTab) {
        //LCAddFriendVCTab_AddressBookUser
        LCAddFriendPhoneContactorCell *phoneContactCell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCAddFriendPhoneContactorCell class]) forIndexPath:indexPath];
        phoneContactCell.delegate = self;
        
        if (indexPath.section == 0) {
            //registered user
            LCUserModel *registeredUser = [self.filteredRegisteredPhoneContactArray objectAtIndex:indexPath.row];
            [phoneContactCell.avatarImageView setImageWithURL:[NSURL URLWithString:registeredUser.avatarThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultAvatarImageName]];
            phoneContactCell.nameLabel.text = [LCStringUtil getNotNullStr:registeredUser.nick];
            if (registeredUser.isFavored) {
                phoneContactCell.showType = LCAddFriendPhoneContactorCellType_Favored;
            }else{
                phoneContactCell.showType = LCAddFriendPhoneContactorCellType_Favor;
            }
        }else if(indexPath.section == 1) {
            //user to invite
            LCPhoneContactorModel *phoneContactor = [self.filteredPhoneContactArray objectAtIndex:indexPath.row];
            NSNumber *phoneContactorType = [self.filteredPhoneContactTypeArray objectAtIndex:indexPath.row];
            [phoneContactCell.avatarImageView setImageWithURL:[NSURL URLWithString:phoneContactor.avatarUrl] placeholderImage:[UIImage imageNamed:LCDefaultAvatarImageName]];
            phoneContactCell.nameLabel.text = [LCStringUtil getNotNullStr:phoneContactor.name];
            if ([phoneContactorType integerValue] == IS_INVITED) {
                phoneContactCell.showType = LCAddFriendPhoneContactorCellType_Invited;
            }else{
                phoneContactCell.showType = LCAddFriendPhoneContactorCellType_Invite;
            }
        }
        
        cell = phoneContactCell;
    } else if (LCAddFriendVCTab_RecommendUser == self.showingTab) {
        LCUserModel *recommendedUser = [self.recommendUserArray objectAtIndex:indexPath.row];
        LCUserTableViewCell *userCell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCUserTableViewCell class]) forIndexPath:indexPath];
        [LCUserTableViewCellHelper setUserTableViewCell:userCell shownAsAddRecommendedFriendWithUser:recommendedUser];
        userCell.delegate = self;
        
        cell = userCell;
    }
    
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (LCAddFriendVCTab_AddressBookUser == self.showingTab) {
        if (indexPath.section == 0) {
            //registered user
            LCUserModel *registeredUser = [self.filteredRegisteredPhoneContactArray objectAtIndex:indexPath.row];
            [LCViewSwitcher pushToShowUserInfoVCForUser:registeredUser on:self.navigationController];
        }else if(indexPath.section == 1) {
            //user to invite
            
        }
    } else if (LCAddFriendVCTab_RecommendUser == self.showingTab) {
        LCUserModel *recommendedUser = [self.recommendUserArray objectAtIndex:indexPath.row];
        [LCViewSwitcher pushToShowUserInfoVCForUser:recommendedUser on:self.navigationController];
    }
}

#pragma mark LCAddFriendPhoneContactorCellDelegate
- (void)addFriendPhoneContactorCellDidClickButton:(LCAddFriendPhoneContactorCell *)cell{
    //通讯录列表中button被点
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (cell.showType == LCAddFriendPhoneContactorCellType_Favor) {
        //favor
        if (indexPath.section == 0) {
            __block LCUserModel *user = [self.filteredRegisteredPhoneContactArray objectAtIndex:indexPath.row];
            if (!user.isFavored) {
                [LCNetRequester followUser:@[user.uUID] callBack:^(NSError *error) {
                    if (error) {
                        [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
                    }else{
                        user.isFavored = 1;
                        [self updateShow];
                    }
                }];
            }
        }
    }else if(cell.showType == LCAddFriendPhoneContactorCellType_Invite) {
        //invite
        //user to invite
        __block LCPhoneContactorModel *phoneContactor = [self.filteredPhoneContactArray objectAtIndex:indexPath.row];
        [LCNetRequester inviteUserInAddressBookWithTelephone:phoneContactor.phone callBack:^(NSError *error) {
            if (error) {
                [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
            }else{
                [self.invitedPhoneContactArray addObject:phoneContactor];
                
                [self.filteredPhoneContactTypeArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithInteger:IS_INVITED]];
                
                for (int i=0; i<self.phoneContactArray.count; i++){
                    LCPhoneContactorModel *aPhoneContactor = [self.phoneContactArray objectAtIndex:i];
                    if ([aPhoneContactor.phone isEqualToString:phoneContactor.phone] &&
                        self.phoneContactTypeArray.count > i) {
                        //第i个通讯录的Type变了
                        [self.phoneContactTypeArray replaceObjectAtIndex:i withObject:[NSNumber numberWithInteger:IS_INVITED]];
                    }
                }
                
                [self updateShow];
            }
        }];
    }
}
#pragma mark LCUserDetailTableCellDelegate
- (void)userTableViewCellDidClickRightTopButton:(LCUserTableViewCell *)userCell{
//    推荐的人的列表Cell被点
    NSIndexPath *indexPath = [self.tableView indexPathForCell:userCell];
    __block LCUserModel *user = [self.recommendUserArray objectAtIndex:indexPath.row];
    if (!user.isFavored) {
        [LCNetRequester followUser:@[user.uUID] callBack:^(NSError *error) {
            if (error) {
                [YSAlertUtil tipOneMessage:error.domain yoffset:TipDefaultYoffset delay:TipErrorDelay];
            }else{
                user.isFavored = 1;
                [self updateShow];
            }
        }];
    }
}

- (void)userTableViewCellDidClickAvatarButton:(LCUserTableViewCell *)userCell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:userCell];
    LCUserModel *user = [self.recommendUserArray objectAtIndex:indexPath.row];
    [LCViewSwitcher pushToShowUserInfoVCForUser:user on:self.navigationController];
}

#pragma mark UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;{
    
    if ([LCStringUtil isNullString:searchText]) {
        self.filteredRegisteredPhoneContactArray = [[NSMutableArray alloc] initWithArray:self.registeredPhoneContactArray];
        self.filteredPhoneContactArray = [[NSMutableArray alloc] initWithArray:self.phoneContactArray];
        self.filteredPhoneContactTypeArray = [[NSMutableArray alloc] initWithArray:self.phoneContactTypeArray];
    }else{
        
        [self.filteredRegisteredPhoneContactArray removeAllObjects];
        for (LCUserModel *user in self.registeredPhoneContactArray){
            if (NSNotFound != [user.nick rangeOfString:searchText options:NSCaseInsensitiveSearch].location ||
                NSNotFound != [user.telephone rangeOfString:searchText options:NSCaseInsensitiveSearch].location) {
                [self.filteredRegisteredPhoneContactArray addObject:user];
            }
        }
        
        [self.filteredPhoneContactArray removeAllObjects];
        [self.filteredPhoneContactTypeArray removeAllObjects];
        for (int i=0; i<self.phoneContactArray.count; i++){
            LCPhoneContactorModel *phoneContact = (LCPhoneContactorModel *)self.phoneContactArray[i];
            if (NSNotFound != [phoneContact.name rangeOfString:searchText options:NSCaseInsensitiveSearch].location ||
                NSNotFound != [phoneContact.phone rangeOfString:searchText options:NSCaseInsensitiveSearch].location) {
                
                [self.filteredPhoneContactArray addObject:phoneContact];
                [self.filteredPhoneContactTypeArray addObject:[self.phoneContactTypeArray objectAtIndex:i]];
            }
        }
    }

    [self updateShow];
}


@end
