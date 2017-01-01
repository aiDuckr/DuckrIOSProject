//
//  LCContactSearchVC.m
//  LinkCity
//
//  Created by 张宗硕 on 8/31/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCContactSearchVC.h"
#import "LCUserInfo.h"
#import "LCAddFriendPhoneContactorCell.h"
#import "LCChatSectionHeaderView.h"

@interface LCContactSearchVC ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, LCAddFriendPhoneContactorCellDelegate>
@property (nonatomic, retain) LCSearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSArray *unfavorArr;
@property (retain, nonatomic) NSArray *favoredArr;
@property (nonatomic, strong) LCBlankContentView *blankView;

@end

@implementation LCContactSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /// 初始化搜索框.
    [self initSearchBar];
    /// 初始化右上角的搜索按钮.
    [self initRightButton];
    /// 初始化搜索结果列表.
    [self initTableView];
    /// 初始化变量.
    [self initVariable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    if (self.isViewWillAppearCalledFirstTime) {
        [self.searchBar becomeFirstResponder];
    }
    [super viewWillAppear:animated];
    [self.tableView showBlankViewWithImageName:BlankContentImageA title:@"您可以通过昵称或手机号\r\n来搜索用户" marginTop:BlankContentMarginTop];
}

- (void)initRightButton {
    UIBarButtonItem *searchBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"ContactSearchButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(searchButtonAction:)];
    self.navigationItem.rightBarButtonItem = searchBtn;
}

- (void)initTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCAddFriendPhoneContactorCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCAddFriendPhoneContactorCell class])];
}

- (void)initVariable {
    self.unfavorArr = [[NSArray alloc] init];
    self.favoredArr = [[NSArray alloc] init];
}

- (void)searchButtonAction:(id)sender {
    [self.searchBar resignFirstResponder];
    if ([LCStringUtil isNullString:self.searchBar.text]) {
        return ;
    }
    [LCNetRequester searchUserByKeyWord:self.searchBar.text callBack:^(NSArray *userArray, NSError *error) {
        if (error) {
            LCLogWarn(@"search related place error: %@",error);
        } else {
            NSMutableArray *unfavorArr = [[NSMutableArray alloc] init];
            NSMutableArray *favoredArr = [[NSMutableArray alloc] init];
            for (LCUserInfo *user in userArray) {
                if (0 == user.isFavored) {
                    [unfavorArr addObject:user];
                } else if (1 == user.isFavored) {
                    [favoredArr addObject:user];
                }
            }
            self.unfavorArr = [[NSArray alloc] initWithArray:unfavorArr];
            self.favoredArr = [[NSArray alloc] initWithArray:favoredArr];
            if (0 != self.unfavorArr.count || 0 != self.favoredArr.count) {
                [self.tableView hideBlankView];
            } else {
                [self.tableView showBlankViewWithImageName:BlankContentImageA title:@"没有找到相应的达客" marginTop:BlankContentMarginTop];
            }
            [self.tableView reloadData];
        }
    }];
}

/// 初始化搜索框.
- (void)initSearchBar {
    self.searchBar = [[LCSearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, (DEVICE_WIDTH - 45.0f * 3), 44.0f)];
    self.searchBar.delegate = self;
    self.searchBar.text = @"";
    [self.searchBar setPlaceholder:@"搜索用户"];
    self.searchBar.showsCancelButton = NO;
    
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(45.0f, 0.0f, (DEVICE_WIDTH - 45.0f * 3), 44.0f)];
    [searchView addSubview:self.searchBar];

    self.navigationItem.titleView = searchView;
}

#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sectionNum = 0;
    if (self.unfavorArr.count > 0) {
        sectionNum++;
    }
    if (self.favoredArr.count > 0) {
        sectionNum++;
    }
    return sectionNum;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat headerHeight = 0.0f;
    headerHeight = [LCChatSectionHeaderView getHeaderViewHeight];
    return headerHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([LCChatSectionHeaderView class]) bundle:nil];
    LCChatSectionHeaderView *header = [[nib instantiateWithOwner:nil options:0] firstObject];
    
    if (self.unfavorArr.count > 0 && 0 == section) {
        header.leftLabel.hidden = NO;
        header.leftLabel.text = @"未关注";
        header.rightLabel.hidden = YES;
    } else if (self.favoredArr.count > 0 && ((self.unfavorArr.count <= 0 && 0 == section)
                                             || (self.unfavorArr.count > 0 && 1 == section))) {
        header.leftLabel.hidden = NO;
        header.leftLabel.text = @"已关注";
        header.rightLabel.hidden = YES;
    }

    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowNum = 0;
    if (self.unfavorArr.count > 0 && 0 == section) {
        rowNum = self.unfavorArr.count;
    } else if (self.favoredArr.count > 0 && ((self.unfavorArr.count <= 0 && 0 == section)
                                             || (self.unfavorArr.count > 0 && 1 == section))) {
        rowNum = self.favoredArr.count;
    }
    return rowNum;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight = 0;
    rowHeight = [LCAddFriendPhoneContactorCell getCellHeight];
    return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCAddFriendPhoneContactorCell *contactCell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCAddFriendPhoneContactorCell class]) forIndexPath:indexPath];
    contactCell.delegate = self;
    
    LCUserModel *user = nil;
    if (self.unfavorArr.count > 0 && 0 == indexPath.section) {
        user = [self.unfavorArr objectAtIndex:indexPath.row];
    } else if (self.favoredArr.count > 0 && ((self.unfavorArr.count <= 0 && 0 == indexPath.section)
                                             || (self.unfavorArr.count > 0 && 1 == indexPath.section))) {
        user = [self.favoredArr objectAtIndex:indexPath.row];
    }
    if (nil != user) {
        [contactCell.avatarImageView setImageWithURL:[NSURL URLWithString:user.avatarThumbUrl] placeholderImage:[UIImage imageNamed:LCDefaultAvatarImageName]];
        contactCell.nameLabel.text = [LCStringUtil getNotNullStr:user.nick];
        if (user.isFavored) {
            contactCell.showType = LCAddFriendPhoneContactorCellType_Favored;
        }else{
            contactCell.showType = LCAddFriendPhoneContactorCellType_Favor;
        }
    }
    return contactCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *arr = [[NSArray alloc] init];
    if (self.unfavorArr.count > 0 && 0 == indexPath.section) {
        arr = self.unfavorArr;
    } else if (self.favoredArr.count > 0 && ((self.unfavorArr.count <= 0 && 0 == indexPath.section)
                                             || (self.unfavorArr.count > 0 && 1 == indexPath.section))) {
        arr = self.favoredArr;
    }
    LCUserModel *user = [arr objectAtIndex:indexPath.row];
    if (nil != user) {
        [LCViewSwitcher pushToShowUserInfoVCForUser:user on:self.navigationController];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - UISearchBar Delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self dismissKeyboardAndHideSearchResult];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchButtonAction:nil];
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}

#pragma mark InnerFunc
- (void)dismissKeyboardAndHideSearchResult{
    [self.searchBar resignFirstResponder];
//    self.tableView.hidden = YES;
}

#pragma mark LCAddFriendPhoneContactorCellDelegate
- (void)addFriendPhoneContactorCellDidClickButton:(LCAddFriendPhoneContactorCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (cell.showType == LCAddFriendPhoneContactorCellType_Favor) {
        NSArray *arr = [[NSArray alloc] init];
        if (self.unfavorArr.count > 0 && 0 == indexPath.section) {
            arr = self.unfavorArr;
        } else if (self.favoredArr.count > 0 && ((self.unfavorArr.count <= 0 && 0 == indexPath.section)
                                                 || (self.unfavorArr.count > 0 && 1 == indexPath.section))) {
            arr = self.favoredArr;
        }
        __block LCUserModel *user = [arr objectAtIndex:indexPath.row];
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
}

- (void)updateShow {
    self.tableView.scrollsToTop = NO;
    
    [self.tableView reloadData];
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
